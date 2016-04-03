#include <stdio.h>
#include <math.h>
#include <stdint.h>

#define I 4
#define Q 32
#define float_divisor ( (double) (((int64_t) 1)<<Q) )
#define HEX_LENGTH ((I+Q)/4)
int64_t double2fix(double);
int64_t mult_fix(signed __int128 a, signed __int128 b);
double fix2double(int64_t);

int main()
{
double thing1 = 3.5;
double thing2 = 3.25;

int64_t fix1 = double2fix(thing1);
int64_t fix2 = double2fix(thing2);
int64_t mult_out = mult_fix(fix1,fix2);
printf("0x%016X\n",fix1);
printf("0x%016X\n",fix2);

printf("%f\n",thing1); 
printf("%f\n",thing2);

printf("%f\n", fix2double(fix1));
printf("%f\n", fix2double(fix2));

printf("\n---MULTIPLICATION RESULTS---\n\n");
printf("0x%016X\n",mult_out);
printf("%f\n", fix2double(mult_out));
return 0;
}

int64_t mult_fix(signed __int128 a, signed __int128 b)
{
    signed __int128 dumb = a*b; 
    return (dumb >> Q); 
}
int64_t double2fix(double a)
{
    return (int64_t)(a*float_divisor);
}

double fix2double(int64_t a)
{
    return ((double)a)/float_divisor; 
}
