
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

proc sort data=have;
by nik nama;
run;

data havee;
set have;
  /* Generate dua angka acak antara 10 dan 99 */
  random_number1 = int((99-10+1) * ranuni(0)) + 10;
  random_number2 = int((99-10+1) * ranuni(0)) + 10;


  /* Menambahkan dua angka acak ke depan NIK */
  NIK_with_random = cats(random_number1, random_number2, NIK);
run;


data havee2;
set havee;
  array from(3) $ 15 from1-from3 ('0123456789','0123456789','0123456789');    /*2*/
  array to(3) $ 15 to1-to3 ('L5QHES1YR7','VXJBAIFNP3','6UZMK9WOTC');/*0G24D8*/
  array old(16) $ old1-old16;
  array new(16) $ new1-new16;
  array mask(16) $ mask1-mask16;
*  array index_c(16) $ index_c1-index_c16;
  char_num=nik;                                                       /*3*/
  do i = 1 to 16;                                                              /*4*/
    old(i)=substr(char_num,i,1);
	old(i)=old(i);
  end;
  j=1;
  do k = 1 to 16;                                                              /*5*/
    if indexc(old(k),from(j)) > 0 then do;
      new(k)=translate(old(k),to(j),from(j));
*	  index_c(i)=indexc(old(k),from(j));
      j+1;
      if j=4 then j=1;
    end;
  end;
  j=1;
  do a = 1 to 16;
  	if (a+1) < 16 then do;
		mask(a)='*';
	end;
	else mask(a)=substr(char_num,a,1); 
  end;
  encrypt_nik=cats(of new1-new16);
  masking_nik=cats(of mask1-mask16); 
*keep nik encrypt_nik masking_nik;
run;

proc sql print;
	select count(distinct encrypt_nik) as dist_nik,
		count(*) as count_total from kjmu; 
quit; 

data hav2;
    set have;
    /* Fungsi hash */
    length random_number 8 nik_masking $8. nama_baru $255.;
    if _n_ = 1 then do;
        declare hash h(hashexp: 16);
        rc = h.definekey('nama');
        rc = h.definedata('random_number');
        rc = h.definedone();
    end;
    
    /* Menghasilkan angka acak berdasarkan NIK */
    call missing(random_number);
    rc = h.find();
    if rc ne 0 then do;
		call streaminit(40);
        random_number = rand('integer', 10000000, 99999999);
        rc = h.add();
    end;
	nik_masking = put(random_number,$8.);
    
    /* Menggunakan substr() untuk mengambil tiga huruf pertama */
    /* dan menggabungkan dengan tanda bintang (*) sebanyak panjang sisa nama */
    nama_baru = substr(nama, 1, 2) || repeat('*', length(nama) - 2);
    
    drop random_number rc;
run;


data have2;
    input NIK $16. nama $;
    datalines;
1234567890123456 coba
9876543210987654 testing
1234567890123456 adi
9876543210987654 kolo
9876543210987655 kol
9876543210987655 juuuji
9876543210987659 juujit
9876543210987678 poo
9876543210987678 ij
9876543210987628 ij
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

proc print data=have;
run;
