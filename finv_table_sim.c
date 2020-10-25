#include <stdio.h>
#include <math.h>
union Single { float f; int i; };//single precision

union Single bare(union Single a){
    union Single r;
    r.i =  (a.i & 0x007fffff);
    return r;
}

union Single init(union Single a){//初期値
    union Single r, next;
    next.i = a.i + 1;
    r.f = (1 / (a.f * powf(2, 13)) + 1 / (next.f * powf(2, 13))) / 2;
    //r.f = 1 / (a.f * powf(2, 13));
    return r;
}

union Single norm(union Single a){//正規化
    union Single r;
    r.i =  (a.i & 0x007fffff) | 0x3f000000;
    return r;
}

union Single constant(union Single x0, union Single a){//定数(24bit数, 先頭は1)
    union Single r;
    //r.i = 2 * x0.i
      //- (int) (((long long int)a.i * (long long int) x0.i * (long long int) x0.i) >> 33);
    r.i = 2 * x0.i - (int)(((long long int) x0.i * (long long int) x0.i * (long long int) a.i) >> 34);
    return bare(r);
}

union Single grad(union Single x0){//勾配(13bit数)
    union Single r;
    r.i = (int) (((long long int) x0.i *(long long int) x0.i) >> 35);
    return bare(r);
}

union Single appr(union Single c, union Single g, union Single a){//近似値
    union Single r;
    r.i = c.i - (int)(((long int)a.i * (long int)g.i)>>12);
    return r;
}

int err(union Single a, union Single b){//|近似値 - 実数値|
    return (a.i > b.i ? a.i - b.i : b.i - a.i);
}

int main(void){
    printf("float = %lu\n",sizeof(float));
    printf("int = %lu\n",sizeof(int));
    printf("long = %lu\n",sizeof(long));
    printf("long long = %lu\n",sizeof(long long int));

    union Single a, b, a_l, a_m, x0, c, g, r;

    //a.f = 1.5;
    //a.f = init(a.f);
    //printf("a.f >> 8 = %08X, %08f\n", a.i >> 8, a.i/powf(2,8));
    /*b.f = 1 / a.f;
    b = norm(b);
    a_l.i = (a.i & 0x1fff);
    a_m.i = ((a.i & 0x7fe000) >> 13) | 0x400;
    x0.i = bare(init(a_m)).i | 0x800000;*/
    //printf("(bare(a)).i) = %08X\n",(bare(a)).i);
    /*r.i = (int)(((long long int) x0.i * (long long int) x0.i * (long long int) (a_m).i) >> 34);
    r = bare(r);*/
    //printf("const2 = %10f, %08X\n", r.f, r.i);
    /*c = constant(x0, a_m);
    g = grad(x0);*/
    //r.i = (bare(appr(c, g, a_l)).i >> 1);
    /*r.i = ((appr(c, g, a_l)).i);
    r = norm(r);*/
    //printf("x0 = %10f, %08X\n", x0.f, x0.i);
    /*x0 = norm(x0);
    c = norm(c);*/
    /*printf("x0 = %10f, %08X\n", x0.f, x0.i);
    printf("c = %10f, %08X\n", c.f, c.i);
    printf("g = %10f, %08X\n", g.f, g.i);
    printf("r = %10f, %08X\n", r.f, r.i);
    printf("a_m = %10f, %08X, a_l = %10f, %08X\n", a_m.f, a_m.i, a_l.f, a_l.i);
    printf("a = %10f, %08X, b = %10f, %08X, %10f\n\n\n", a.f, a.i, b.f, b.i, a.f * b.f);*/
    puts("check start");
    for (int j = 1; j < 8388608; j++){
        a.f = 1.0 + (float)j / powf(2, 23);
        a_l.i = (a.i & 0x1fff);
        a_m.i = ((a.i & 0x7fe000) >> 13) | 0x400;
        x0.i = bare(init(a_m)).i | 0x800000;
        b.f = 1 / a.f;
        b = norm(b);
        c = constant(x0, a_m);
        g = grad(x0);
        r.i = ((appr(c, g, a_l)).i);
        r = norm(r);
        if (err(b,r) > 4)
        printf("real = %10f, %08X, appr = %10f, %08X,err = %d,key = %08X, a = %08X\n",
               b.f,b.i,r.f,r.i, err(b,r), a_m.i & 0x3ff, a.i);
    }
    puts("check finish");
    return 0;
}
