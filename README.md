# Performance (KCU105)
- fmul: 100MHz 1clock (Maximum operating frequency = 160MHz)
- fsqrt: 100MHz 2clock (Pipeline) (Maximum operating frequency = 160MHz)
- itof: 100MHz 1clock (Maximum operating frequency = 150MHz)
- ftoi: 100MHz 1clock 

# Utilization (KCU105)
- fmul: LUT 53, FF 96, DSP 2
- itof: LUT 246, FF 64
- ftoi: LUT 264, FF 64

# Dependency
- fdiv (fdiv.v)
  - fmul_for_fdiv (fmul_for_fdiv.v)
  - finv (finv.v)
    - finv_const_table (finv_table.v)
    - finv_grad_table (finv_table.v)
- fsqrt (fsqrt.v)
  - fsqrt_const_table (fsqrt_table.v)
  - fsqrt_grad_table (fsqrt_table.v)
    
# Notes
- fmul, fdiv and fsqrt only support normalized numbers.
  - if the exponent is 0, then the mantissa is set to 0 and the number is regarded as 0.
  - if the exponent is 255, then the mantissa is set to 0 and the number is regarded as infinity.
- fsqrt
  -If you enter negative number in fsqrt, 0 will be returned.
- ftoi
  -If you enter more than 2^31, 0x7fffffff will be returned.
  -If you enter less than -2^31, 0x80000001 will be returned.
