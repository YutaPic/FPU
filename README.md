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
- If you enter negative number in fsqrt, 0 will be returned.
