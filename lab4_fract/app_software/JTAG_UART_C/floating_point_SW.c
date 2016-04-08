/*************************************************************************
* Copyright © 2004 Altera Corporation, San Jose, California, USA.        *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
*************************************************************************/
/******************************************************************************
 *
 * Description
 * ************* 
 * The 4 functions in this file perform floating point +, -, *, / using 
 * software.  Each function takes in 2 float arguments and returns the result as
 * a float.
 * 
 * Uses #pragma statements to instruct the compiler to bypass the Nios II 
 * floating point custom instruction for +, -, *, / operations.  Hence, these 
 * operations are performed in softare.
 * 
 * Section SW_SECTION (#define in floating_point.h) of the performance counter 
 * is used to measure the time for each operation. The PERF_BEGIN and
 * PERF_END statements start and stop the counter for measuring the time.
 * 
 * Requirements
 * **************
 * This program requires the following devices to be configured:
 *   Performance Counter name "PERFORMANCE_COUNTER" with 2 sections
 *
 * Peripherals Exercised by SW
 * *****************************
 * Performance Counter name "PERFORMANCE_COUNTER"
 */

#include "altera_avalon_performance_counter.h"
#include "system.h"
#include "floating_point.h" 

#pragma no_custom_fadds
#pragma no_custom_fsubs
#pragma no_custom_fmuls
#pragma no_custom_fdivs

float fp_add_SW(float operand_a, float operand_b)
{
  float result_SW;

  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, SW_SECTION);
  result_SW = operand_a + operand_b;
  PERF_END (PERFORMANCE_COUNTER_BASE, SW_SECTION);

  return result_SW;
}

float fp_sub_SW(float operand_a, float operand_b)
{
  float result_SW;

  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, SW_SECTION);
  result_SW = operand_a - operand_b;
  PERF_END (PERFORMANCE_COUNTER_BASE, SW_SECTION);

  return result_SW;
}

float fp_mul_SW(float operand_a, float operand_b)
{
  float result_SW;

  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, SW_SECTION);
  result_SW = operand_a * operand_b;
  PERF_END (PERFORMANCE_COUNTER_BASE, SW_SECTION);

  return result_SW;
}

float fp_div_SW(float operand_a, float operand_b)
{
  float result_SW;

  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, SW_SECTION);
  result_SW = operand_a / operand_b;
  PERF_END (PERFORMANCE_COUNTER_BASE, SW_SECTION);

  return result_SW;
}
