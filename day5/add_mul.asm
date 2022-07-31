.text
  addi  $s1, $zero, 2
  addi  $s2, $zero, 3
  mul   $t0, $s1  , $s2
  li	$v0,	10		# プログラムの終了
  syscall
