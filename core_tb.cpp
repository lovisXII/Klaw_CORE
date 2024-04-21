#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <unordered_map>
#include "elfio/elfio.hpp"
#include "systemc.h"
#include "../include/colors.h"
#include <sys/stat.h>  // mkdir
#include <verilated.h>
#include <sstream>
#include "Vcore.h"
#define MAX_CYCLES 100000
#if VM_TRACE
#include <verilated_vcd_sc.h>
#endif

using namespace std;
using namespace ELFIO;

enum error_type {HELP = 0, ARG_MISS = 1, OV_CYCLES, DEBUG};

void helper(int error){
    cout << endl << endl;
    if(error == ARG_MISS){
        cerr << "Usage: obj_dir/Vcore test_filename [options] ..." << endl;
        cerr << "file_name type accepted are .s, .S, .c or elf file" << endl;
        cerr << "Options:" << endl << endl;
        cerr << "--riscof signature_filename \t Allow to enable the riscof gestion and store the signature in the file named signature_filename" << endl ;
        cerr << "--riscof signature_filename --debug \t Allow to visualise all the store made by the cpu" << endl;
        cerr << "--stats                     \t Allow to use the statistic such as the number of cycle needed to end the program" << endl;
        exit(0);
    }
    else if (error == OV_CYCLES){
        cerr << "[Error] Number of cycles for simulation exceed, maximum is ";
        cerr << MAX_CYCLES << endl;
        exit(0);
    }
    else if(error == HELP){
        cerr << "Usage: obj_dir/Vcore test_filename [options] ..." << endl;
        cerr << "file_name type accepted are .s, .S, .c or elf file" << endl;
        cerr << "Options:" << endl << endl;
        cerr << "--riscof signature_filename \t Allow to enable the riscof gestion and store the signature in the file named signature_filename" << endl ;
        cerr << "--riscof signature_filename --debug \t Allow to visualise all the store made by the cpu" << endl;
        cerr << "--stats                     \t Allow to use the statistic such as the number of cycle needed to end the program" << endl;
        exit(0);
    }
    else if(error == DEBUG)
    {
        cerr << "[Error] Please enter a valide option" << endl;
        cerr << "[info] run --help to see the options" << endl ;
        exit(0);
    }
}

void cleanup(Vcore &core, VerilatedVcdSc *tf, int retval){
     // Final model cleanup
    core.final();
    // Close trace if opened
    if (tf) {
        tf->close();
        tf = nullptr;
    }
    // Coverage analysis (calling write only after the test is known to pass)
    #if VM_COVERAGE
        Verilated::mkdir("logs");
        VerilatedCov::write("logs/coverage.dat");
    #endif
    exit(retval);
}

int sc_main(int argc, char* argv[]) {

    /*
    ##############################################################
                    Checking main arguments
    ##############################################################
    */
    if(argc < 2){
        helper(ARG_MISS);
    }

    // Compiling options

    bool                    debug = false;
    bool                    riscof = false;
    bool                    stats = false ;

    // Addresses and sections
    int                     reset_adr;
    int                     start_adr;
    int                     good_adr;
    int                     exception_occur ;
    int                     bad_adr;
    int                     rvtest_code_end     = 0xFFFFFFFF;
    int                     rvtest_entry_point  = 0xFFFFFFFF;
    int                     begin_signature;
    int                     end_signature;
    int                     rvtest_end          = 0xFFFFFFFF;

    // Files settings

    fstream                 test_stats;
    string                  signature_name;
    string                  filename_stats;
    string                  test_filename(argv[1]);
    string                  path(argv[1]);
    char                    test[512] = "> a.out.txt.s";

    // Ram and elfio object

    unordered_map<int, int> ram;
    elfio                   reader;
    ofstream                signature;
    for(int i = 2; i < argc; i++){
        if (std::string(argv[i])== "--help"){
                helper(HELP);
        }
        if (std::string(argv[i])== "--riscof") {
            if(argv[i + 1] == NULL)
                helper(HELP);
            else{
                signature_name          = string(argv[i + 1]);
                i++; // increment i to avoid re-reding the filename
                riscof                  = true;
                int tmp                 = test_filename.find("src/");
                int tmp2                = test_filename.find("dut/");

                string tempo_string     = test_filename.substr(0,tmp);
                string tempo_string2    = test_filename.substr(0,tmp2);
                int tmp3                = tempo_string2.size() - (tempo_string.size() + 4);

                test_filename           = test_filename.substr(tmp+4, tmp3);
                filename_stats          = "stats.txt";
                test_stats.open(filename_stats, fstream::app);
                signature.open(signature_name, ios::out | ios::trunc);
            }
        }
        if (std::string(argv[i])== "--debug") {
            debug = true;
        }
        if (std::string(argv[i])== "--stats") {
            stats                   = true;
            int tmp                 = test_filename.rfind("/");
            test_filename           = test_filename.substr(tmp+1, test_filename.size());
            filename_stats          = "test_stats.txt";
            test_stats.open(filename_stats, fstream::app);

            if(!test_stats.is_open())
            {
                cout << "Impossible to open " << filename_stats << endl ;
                exit(1);
            }
        }
    }

    /*
    ##############################################################
                    Waves setup
    ##############################################################
    */

    // trace file settings
    Verilated::mkdir("logs");
    Verilated::traceEverOn(true);
    VerilatedVcdSc* tfp     = nullptr;
    tfp                     = new VerilatedVcdSc;

    // Core instanciation
    Vcore core("u_core");

    (riscof) ? cout << "[info] riscof enable" << endl : cout << "[info] riscof disable" << endl;
/*
    ##############################################################
                    PARSING ELF/.s/.c file
    ##############################################################
*/
    char temp_text[512];
    string extension           = path.substr(path.find_last_of(".") + 1) ;
    if (!riscof) {
        path = "a.out";
    }
    if (!reader.load(path)) {
        std::cout << "Can't find or process ELF file " << argv[1] << std::endl;
        return -3;
    }
    sprintf(temp_text, "riscv32-unknown-elf-objdump -D %s", path.c_str());
    strcat(temp_text, test);
    system((char*)temp_text);

    cout << "Loading ELF file..." << endl;
    int n_sec = reader.sections.size();  // get the total amount of sections

/*
    ##############################################################
                    PLACING DATA INTO THE RAM
    ##############################################################
*/

    if(debug) signature << "RAM init begin" << endl;
    for (int i = 0; i < n_sec; i++) {
        section* sec = reader.sections[i];
        cout << "Section " << sec->get_name() << " at address 0x" << std::hex << sec->get_address() << endl;
        int  adr  = sec->get_address();
        int  size = sec->get_size();
        int* data = (int*)sec->get_data();
        if (adr) {
            cout << "Loading data";
            for (int j = 0; j < size; j += 4) {
                cout << ".";
                ram[adr + j] = data[j / 4];
                if(debug){
                    signature << setfill('0') << setw(8) << hex << adr + j << " " << setfill('0') << setw(8) << hex << data[j / 4] << endl;
                }
            }
            cout << endl;
        }

/*
    ##############################################################
                    LOOKING FOR SECTIONS IN ELF FILE
    ##############################################################
*/

        if (sec->get_type() == SHT_SYMTAB) {
            cout << "Reading symbols table..." << endl;
            const symbol_section_accessor symbols(reader, sec);

            for (unsigned int j = 0; j < symbols.get_symbols_num(); ++j) {
                std::string   name;
                Elf64_Addr    value;
                Elf_Xword     size;
                unsigned char bind;
                unsigned char type;
                Elf_Half      section_index;
                unsigned char other;

                symbols.get_symbol(j, name, value, size, bind, type, section_index, other);

                if (name == "_reset") {
                    reset_adr = value;
                    cout << "Found reset at address 0x" << std::hex << reset_adr << endl;
                }
                if (name == "_start") {
                    start_adr = value - 4;
                    cout << "Found start at address 0x" << std::hex << start_adr << endl;
                }
                if (name == "_bad") {
                    bad_adr = value;
                    cout << "Found bad at address 0x" << std::hex << bad_adr << endl;
                }
                if (name == "_good") {
                    good_adr = value;
                    cout << "Found good at address 0x" << std::hex << good_adr  << endl;
                }
                if (name == "_exception_occur") {
                    exception_occur = value;
                    cout << "Found exception_occur at address 0x" << std::hex << exception_occur << endl;
                }
                if (name == "rvtest_code_end") {
                    rvtest_code_end = value;
                    cout << "Found rvtest_code_end at address 0x" << std::hex << rvtest_code_end << endl;
                }
                if (name == "rvtest_entry_point") {
                    rvtest_entry_point = value ;
                    cout << "Found rvtest_entry_point at address 0x" << std::hex << rvtest_entry_point << endl;
                }
                if (name == "begin_signature") {
                    begin_signature = value;
                    cout << "Found begin_signature at address 0x" << std::hex << begin_signature << endl;
                }
                if (name == "end_signature") {
                    end_signature = value;
                    cout << "Found end_signature at address 0x" << std::hex << end_signature << endl;
                }
                if (name == "rvtest_end") {
                    rvtest_end = value;
                    cout << "Found rvtest_end at address 0x " << std::hex << rvtest_end << endl;
                }
            }
        }
    }
    if(debug) signature << "RAM init end" << endl;
    vector<string> data;
/*
    ##############################################################
                    COMPONENT INSTANCIATION
    ##############################################################
*/


    core.trace(tfp, 99);  // Trace 99 levels of hierarchy
    Verilated::mkdir("logs");
    tfp->open("logs/vlt_dump.vcd");

    sc_clock            clk("clk", 1, SC_NS);
    sc_signal<bool>     reset_n;

    // --------------------------------
    //     Memory interface line 0
    // --------------------------------
    sc_signal<sc_uint<32>>  if_reset_adr;
    sc_signal<sc_uint<32>>  icache_adr0;
    sc_signal<sc_uint<32>>  icache_instr;
    sc_signal<bool>         adr_v;
    sc_signal<sc_uint<32>>  mem_adr;
    sc_signal<bool>         is_store;
    sc_signal<sc_uint<32>>  store_data;
    sc_signal<sc_uint<32>>  load_data;
    sc_signal<sc_uint<3>>   access_size;


    sc_signal<sc_uint<32>>  wbk_data;
    sc_signal<sc_uint<5>>   wbk_adr;
    sc_signal<bool>         wbk_v;
    sc_signal<sc_uint<32>>   pc_val;
    sc_signal<sc_uint<32>>   pc_val_mem;

    //csr
    sc_signal<sc_uint<12>>   wbk_csr_adr;
    sc_signal<bool>          wbk_csr_v;
    sc_signal<sc_uint<32>>   wbk_csr_data;

    core.clk              (clk);
    core.reset_n          (reset_n);
    core.reset_adr_i      (if_reset_adr);
    core.icache_adr_o     (icache_adr0);
    core.icache_instr_i   (icache_instr);
    core.adr_v_o          (adr_v);
    core.adr_o            (mem_adr);
    core.is_store_o       (is_store);
    core.store_data_o     (store_data);
    core.load_data_i      (load_data);
    core.access_size_o    (access_size);

    // Checkers outputs
    // rd
    core.wbk_v_q_o        (wbk_v);
    core.wbk_adr_q_o      (wbk_adr);
    core.wbk_data_q_o     (wbk_data);
    //csr
    core.wbk_csr_v_q_o    (wbk_csr_v);
    core.wbk_csr_adr_q_o  (wbk_csr_adr);
    core.wbk_csr_data_q_o (wbk_csr_data);

    core.pc_val_o         (pc_val);
    core.pc_val_mem_o     (pc_val_mem);

    cout << "Reseting...";

    if (riscof){
        if_reset_adr = rvtest_entry_point;
    }
    else
        if_reset_adr = reset_adr;
    if (debug) cout << FBLU("[Debug] ") << "Reset adr is " << std::hex << if_reset_adr << endl;

    reset_n.write(false);
    sc_start(3, SC_NS);
    reset_n.write(true);
    sc_start(500, SC_PS);

    cerr << "done." << endl;

    // Use to let the time to riscof to execute the last instruction
    // When it arrives to the end of the code it will start the countdown before exiting

    int NB_CYCLES           = 0;
    int countdown           = 100 ;
    bool start_countdown    = false;


    std:: ofstream register_file;
    register_file.open("sim.log");
    int prev_cycle;
    int prev_cycle2;

    while (1)
    {

        if(start_countdown)
            countdown --;

        // Ifetch interface
        int  if_adr         = icache_adr0.read();
        bool if_afr_valid   = true;
        int  adr            = mem_adr.read();
        unsigned int pc_adr = icache_adr0.read();
        NB_CYCLES           = sc_time_stamp().to_double()/1000;
/*
    ##############################################################
                    SIGNOFF
    ##############################################################
*/
    if(NB_CYCLES > MAX_CYCLES){
        // Writting signature for riscof if enabled
        if (riscof)
        {
            if (debug){
                for (int i = begin_signature; i < end_signature; i += 4) {
                    signature << setfill('0') << setw(8) << hex << i << " " << setfill('0') << setw(8) << hex << ram[i] << endl;
                }
            }
            else{
                for (int i = begin_signature; i < end_signature; i += 4) {
                    signature << setfill('0') << setw(8) << hex << ram[i] << endl;
                }
            }
        }
        // Close trace if opened
        if (tfp) {
            tfp->close();
            tfp = nullptr;
        }
        // Coverage analysis (calling write only after the test is known to pass)
        #if VM_COVERAGE
            Verilated::mkdir("logs");
            VerilatedCov::write("logs/coverage.dat");
        #endif
        cout << "Test never end, last adress registered : " << std::hex << pc_adr << endl;
        core.final();
        helper(OV_CYCLES);
    }
    // Exit
    if(!riscof && signature_name == "" && pc_adr == bad_adr && if_afr_valid){
        cout << "Reaching ending point, starting countdown" << endl;
        cout << FRED("Error ! ") << "Found bad at adr 0x" << std::hex << pc_adr << endl;
        sc_start(3, SC_NS);
        cleanup(core, tfp,1);
    }
    else if(!riscof && signature_name == "" && pc_adr == good_adr && if_afr_valid){
        cout << "Reaching ending point, starting countdown" << endl;
        if(stats){
            test_stats << test_filename << " " << NB_CYCLES  << " " << "SCALAR" << endl;
            test_stats.close();
        }
        cout << FGRN("Success ! ") << "Found good at adr 0x" << std::hex << pc_adr << endl;
        sc_start(3, SC_NS);
        cleanup(core, tfp, 0);
    }
    else if(!riscof && signature_name == "" && pc_adr == exception_occur && if_afr_valid){
        cout << "Reaching ending point, starting countdown" << endl;
        cout << FYEL("Error ! ") << "Found exception_occur at adr 0x" << std::hex << pc_adr << endl;
        sc_start(3, SC_NS);
        cleanup(core, tfp, 2);
    }
    // riscof :
    else if(((riscof && !start_countdown && pc_adr == rvtest_code_end) || (pc_adr ==  rvtest_end)) && if_afr_valid){
        cout << "Reaching ending point, starting countdown" << endl;
        start_countdown = true;
    }

    if (riscof && countdown == 0)
    {
        cout << "Test ended at " << std::hex << pc_adr << endl;
        sc_start(3, SC_NS);

        // Stats Gestion riscof
        test_stats << test_filename << " " << NB_CYCLES  << " " << "SCALAR" << endl;
        test_stats.close();

        cout << "signature_name :" << signature_name << endl ;
        cout << "begin_signature :" << begin_signature << endl ;
        cout << "end_signature :" << end_signature << endl ;
        if(debug){
            for (int i = begin_signature; i < end_signature; i += 4) {
                signature << setfill('0') << setw(8) << hex << i << " " << setfill('0') << setw(8) << hex << ram[i] << endl;
            }
        }
        else{
            for (int i = begin_signature; i < end_signature; i += 4) {
                signature << setfill('0') << setw(8) << hex << ram[i] << endl;
            }
        }
        cleanup(core, tfp, 0);
    }

/*
    ##############################################################
                    MEMORY ACCESS GESTION
    ##############################################################
*/
        int phys_adr = adr & 0xFFFFFFFC;
        // Store always store the lsb of the register into the proper part of the adress
        // May be done directly by the core -> to discuss
        if (is_store.read() && adr_v.read()) {
        cout << pc_val_mem << " " << adr << " " << store_data.read() << endl;
        if(access_size.read() == 1){
            if ((adr & 0b11) == 0) ram[phys_adr] = (ram[phys_adr] & 0xFFFFFF00) | (store_data.read() & 0x000000FF);
            if ((adr & 0b11) == 1) ram[phys_adr] = (ram[phys_adr] & 0xFFFF00FF) | ((store_data.read() & 0x000000FF) << 8);
            if ((adr & 0b11) == 2) ram[phys_adr] = (ram[phys_adr] & 0xFF00FFFF) | ((store_data.read() & 0x000000FF) << 16);
            if ((adr & 0b11) == 3) ram[phys_adr] = (ram[phys_adr] & 0x00FFFFFF) | ((store_data.read() & 0x000000FF) << 24);
        }
        // store half word
        else if(access_size.read() == 2){
            if ((adr & 0b11) == 0) ram[phys_adr] = (ram[phys_adr] & 0xFFFF0000) | (store_data.read()  & 0x0000FFFF);
            if ((adr & 0b10) == 2) ram[phys_adr] = (ram[phys_adr] & 0x0000FFFF) | ((store_data.read() & 0x0000FFFF) << 16);
        }
        // store word
        else if (access_size.read() == 4) ram[phys_adr] = store_data.read();
        }
        load_data    = ram[phys_adr];
        icache_instr = ram[if_adr];

/*
    ##############################################################
                    CHECKER
    ##############################################################
*/
    //Show what's been written in the destination register at each cycle
    if (wbk_v.read() | wbk_csr_v.read() | adr_v.read()){
        std::stringstream pc;
        std::stringstream pc_mem;
        std::stringstream rd;
        std::stringstream data_chck;
        std::stringstream mem_adr_chck;
        std::stringstream mem_data;
        std::stringstream csr;
        std::stringstream csr_data_chck;

        pc            << "0x" << std::hex << setfill('0') << setw(8) << static_cast<unsigned int>(pc_val.read());
        pc_mem        << "0x" << std::hex << setfill('0') << setw(8) << static_cast<unsigned int>(pc_val_mem.read());

        rd            << "x" <<  wbk_adr.read();
        data_chck     << "0x" << std::hex << setfill('0') << setw(8) << static_cast<unsigned int>(wbk_data.read());
        mem_adr_chck  << "0x" << std::hex << setfill('0') << setw(8) << phys_adr;
        mem_data      << "0x" << std::hex << setfill('0') << setw(8) << store_data.read();
        csr           << "0x" << std::hex << setfill('0') << setw(3) << static_cast<unsigned int>(wbk_csr_adr.read());
        csr_data_chck << "0x" << std::hex << setfill('0') << setw(8) << static_cast<unsigned int>(wbk_csr_data.read());

        data.push_back(adr_v.read()                       ? pc_mem.str() : pc.str()        );
        data.push_back(wbk_v.read() && wbk_adr.read() !=0 ? rd.str()               : "None");
        data.push_back(wbk_v.read() && wbk_adr.read() !=0 ? data_chck.str()        : "None");
        data.push_back(adr_v.read()                       ? mem_adr_chck.str(  )   : "None");
        data.push_back(is_store.read()                    ? mem_data.str()         : "None");
        data.push_back(wbk_csr_v.read()                   ? csr.str()              : "None");
        data.push_back(wbk_csr_v.read()                   ? csr_data_chck.str()    : "None");

        for (auto it = data.begin(); it != data.end() -1; ++it) {
            register_file << *it << ";"; // Write data to file
        }
        register_file << *(data.end() -1) << endl;
        data.clear();
    }

    sc_start(1, SC_NS);
    }
    return 0;
}