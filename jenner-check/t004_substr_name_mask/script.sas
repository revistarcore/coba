/* Adapted from "masking NIK dan isi kolom.sas" (final data have / want block).
   Runs unmodified from upstream -- the repo's own placeholder name datalines and its
   own PROC PRINT of "want" are used exactly as written. */
data have;
    input nama $20.;
    datalines;
NamaAnda
ContohNamaLain
NamaSaya
;
run;

data want;
    set have;
    length nama_baru $20.;

    /* Menggunakan substr() untuk mengambil tiga huruf pertama */
    /* dan menggabungkan dengan tanda bintang (*) sebanyak panjang sisa nama */
    nama_baru = substr(nama, 1, 3) || repeat('*', length(nama) - 3);

    drop nama;
run;

proc print data=want;
run;
