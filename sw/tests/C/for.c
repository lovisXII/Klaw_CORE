extern void _bad();
extern void _good();

__asm__(".section .text.init") ;
__asm__(".global _start") ;


__asm__("_start:");
__asm__("addi x1,x1, 4");
__asm__("sub x2, x2,x1 ");
__asm__("jal x5, main");

int main()
{
    int a, i;
    a = 1;
    for(i=1; i <= 1; ++i)
    {
            a = i;
    }
	if(a == 1)
    {
        _good() ;
    }
    else{
        _bad() ;
    }
}