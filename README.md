# FPU
For CPU experiment

#Dependency
- fdiv (in fdiv.v)
  - fmul_for_fdiv (in fmul_for_fdiv.v)
  - finv (in finv.v)
    - finv_const_table (in finv_table.v)
    - finv_grad_table (in finv_table.v)
    
#Notes
- fmul, fdiv only supports normalized numbers.
  - if the exponent is 0, then the mantissa is set to 0 and the number is regarded as 0.
  - if the exponent is 255, then the mantissa is set to 0 and the number is regarded as infinity.
