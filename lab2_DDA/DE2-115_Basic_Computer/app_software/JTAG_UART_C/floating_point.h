#ifndef __FLOATING_POINT_H__
#define __FLOATING_POINT_H__

#define CI_SECTION 1  /* performance counter section for floating point custom instruction operations */
#define SW_SECTION 2  /* performance counter section for floating point SW operations */

float fp_add_CI(float, float);
float fp_sub_CI(float, float);
float fp_mul_CI(float, float);
float fp_div_CI(float, float);

float fp_add_SW(float, float);
float fp_sub_SW(float, float);
float fp_mul_SW(float, float);
float fp_div_SW(float, float);

#endif /* __FLOATING_POINT_H__ */
