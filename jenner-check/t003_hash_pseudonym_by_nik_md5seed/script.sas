/* Adapted from "masking NIK dan isi kolom.sas" (data have / hav1).
   NIK = Indonesian national ID number. Sample NIK/nama values below are the repo's own
   placeholder datalines (fabricated numbers, not real IDs).
   Edit vs. upstream: added a PROC PRINT at the end so the run has visible tabular
   output to pin -- the DATA step logic (per-NIK MD5-derived streaminit seed feeding a
   hash-object lookup, then substr-based name masking) is unchanged. */
data have;
    input NIK $16. nama $ status $;
    datalines;
1234567890123456 adi a
9876543210987654 testing b
1234567890123456 adi c
9876543210987654 kolo d
9876543210987655 kolo e
9876543210987655 juuuji f
9876543210987659 juujit g
9876543210987678 poo h
9876543210987678 ij i
;
run;

data hav1;
set have;
/* Fungsi hash */
    length random_number 8 nik_masking $8. nama_baru $255.;
    if _n_ = 1 then do;
        declare hash h(hashexp: 16);
        rc = h.definekey('NIK');
        rc = h.definedata('random_number');
        rc = h.definedone();
    end;
    seed = put(scan(catt(md5(NIK), " "), 1, " "), $hex32.);
    /* Menghasilkan angka acak berdasarkan NIK */
    rc = h.find();
    if rc ne 0 then do;
	call streaminit(seed);
        random_number = rand('integer', 10000000, 99999999);
        rc = h.add();
    end;
	nik_masking = put(random_number,$8.);

    /* Menggunakan substr() untuk mengambil tiga huruf pertama */
    /* dan menggabungkan dengan tanda bintang (*) sebanyak panjang sisa nama */
    nama_baru = substr(nama, 1, 2) || repeat('*', length(nama) - 2);

run;

proc print data=hav1;
  var nik nama nik_masking nama_baru;
run;
