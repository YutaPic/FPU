# FPU
For CPU experiment

#Dependency
- fdiv
  - fmul_for_fdiv
  - finv
    - finv_const_table
    - finv_grad_table
    
#Notes
- fmul, fdiv only supports normalized numbers.
  - if the exponent is 0, then the mantissa is set to 0 and the number is regarded as 0.
  - if the exponent is 255, then the mantissa is set to 0 and the number is regarded as infinity.
