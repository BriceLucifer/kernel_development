
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	37278793          	addi	a5,a5,882 # 7380 <malloc+0x2472>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	245040ef          	jal	ra,4a8a <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	faa50513          	addi	a0,a0,-86 # 5010 <malloc+0x102>
      6e:	5e7040ef          	jal	ra,4e54 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	1d7040ef          	jal	ra,4a4a <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	4f078793          	addi	a5,a5,1264 # 9568 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	bf868693          	addi	a3,a3,-1032 # bc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	f9050513          	addi	a0,a0,-112 # 5030 <malloc+0x122>
      a8:	5ad040ef          	jal	ra,4e54 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	19d040ef          	jal	ra,4a4a <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	f8850513          	addi	a0,a0,-120 # 5048 <malloc+0x13a>
      c8:	1c3040ef          	jal	ra,4a8a <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	1a3040ef          	jal	ra,4a72 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	f9250513          	addi	a0,a0,-110 # 5068 <malloc+0x15a>
      de:	1ad040ef          	jal	ra,4a8a <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	f5e50513          	addi	a0,a0,-162 # 5050 <malloc+0x142>
      fa:	55b040ef          	jal	ra,4e54 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	14b040ef          	jal	ra,4a4a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	f7250513          	addi	a0,a0,-142 # 5078 <malloc+0x16a>
     10e:	547040ef          	jal	ra,4e54 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	137040ef          	jal	ra,4a4a <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	f7850513          	addi	a0,a0,-136 # 50a0 <malloc+0x192>
     130:	16b040ef          	jal	ra,4a9a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	f6850513          	addi	a0,a0,-152 # 50a0 <malloc+0x192>
     140:	14b040ef          	jal	ra,4a8a <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	f6858593          	addi	a1,a1,-152 # 50b0 <malloc+0x1a2>
     150:	11b040ef          	jal	ra,4a6a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	f4850513          	addi	a0,a0,-184 # 50a0 <malloc+0x192>
     160:	12b040ef          	jal	ra,4a8a <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	f5058593          	addi	a1,a1,-176 # 50b8 <malloc+0x1aa>
     170:	8526                	mv	a0,s1
     172:	0f9040ef          	jal	ra,4a6a <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	f2450513          	addi	a0,a0,-220 # 50a0 <malloc+0x192>
     184:	117040ef          	jal	ra,4a9a <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	0e9040ef          	jal	ra,4a72 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	0e3040ef          	jal	ra,4a72 <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	f1a50513          	addi	a0,a0,-230 # 50c0 <malloc+0x1b2>
     1ae:	4a7040ef          	jal	ra,4e54 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	097040ef          	jal	ra,4a4a <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	0a7040ef          	jal	ra,4a8a <open>
    close(fd);
     1e8:	08b040ef          	jal	ra,4a72 <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	andi	s1,s1,255
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	089040ef          	jal	ra,4a9a <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	andi	s1,s1,255
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	ea450513          	addi	a0,a0,-348 # 50e8 <malloc+0x1da>
     24c:	04f040ef          	jal	ra,4a9a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	e94a8a93          	addi	s5,s5,-364 # 50e8 <malloc+0x1da>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a1ca0a13          	addi	s4,s4,-1508 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x45>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	01b040ef          	jal	ra,4a8a <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	7ec040ef          	jal	ra,4a6a <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49a63          	bne	s1,a0,2d8 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	7dc040ef          	jal	ra,4a6a <write>
      if(cc != sz){
     292:	04951163          	bne	a0,s1,2d4 <bigwrite+0xa8>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	7da040ef          	jal	ra,4a72 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	7fc040ef          	jal	ra,4a9a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	e3650513          	addi	a0,a0,-458 # 50f8 <malloc+0x1ea>
     2ca:	38b040ef          	jal	ra,4e54 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	77a040ef          	jal	ra,4a4a <exit>
     2d4:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     2d6:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d8:	86ce                	mv	a3,s3
     2da:	8626                	mv	a2,s1
     2dc:	85de                	mv	a1,s7
     2de:	00005517          	auipc	a0,0x5
     2e2:	e3a50513          	addi	a0,a0,-454 # 5118 <malloc+0x20a>
     2e6:	36f040ef          	jal	ra,4e54 <printf>
        exit(1);
     2ea:	4505                	li	a0,1
     2ec:	75e040ef          	jal	ra,4a4a <exit>

00000000000002f0 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2f0:	7179                	addi	sp,sp,-48
     2f2:	f406                	sd	ra,40(sp)
     2f4:	f022                	sd	s0,32(sp)
     2f6:	ec26                	sd	s1,24(sp)
     2f8:	e84a                	sd	s2,16(sp)
     2fa:	e44e                	sd	s3,8(sp)
     2fc:	e052                	sd	s4,0(sp)
     2fe:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     300:	00005517          	auipc	a0,0x5
     304:	e3050513          	addi	a0,a0,-464 # 5130 <malloc+0x222>
     308:	792040ef          	jal	ra,4a9a <unlink>
     30c:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     310:	00005997          	auipc	s3,0x5
     314:	e2098993          	addi	s3,s3,-480 # 5130 <malloc+0x222>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     318:	5a7d                	li	s4,-1
     31a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31e:	20100593          	li	a1,513
     322:	854e                	mv	a0,s3
     324:	766040ef          	jal	ra,4a8a <open>
     328:	84aa                	mv	s1,a0
    if(fd < 0){
     32a:	04054d63          	bltz	a0,384 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32e:	4605                	li	a2,1
     330:	85d2                	mv	a1,s4
     332:	738040ef          	jal	ra,4a6a <write>
    close(fd);
     336:	8526                	mv	a0,s1
     338:	73a040ef          	jal	ra,4a72 <close>
    unlink("junk");
     33c:	854e                	mv	a0,s3
     33e:	75c040ef          	jal	ra,4a9a <unlink>
  for(int i = 0; i < assumed_free; i++){
     342:	397d                	addiw	s2,s2,-1
     344:	fc091de3          	bnez	s2,31e <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     348:	20100593          	li	a1,513
     34c:	00005517          	auipc	a0,0x5
     350:	de450513          	addi	a0,a0,-540 # 5130 <malloc+0x222>
     354:	736040ef          	jal	ra,4a8a <open>
     358:	84aa                	mv	s1,a0
  if(fd < 0){
     35a:	02054e63          	bltz	a0,396 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35e:	4605                	li	a2,1
     360:	00005597          	auipc	a1,0x5
     364:	d5858593          	addi	a1,a1,-680 # 50b8 <malloc+0x1aa>
     368:	702040ef          	jal	ra,4a6a <write>
     36c:	4785                	li	a5,1
     36e:	02f50d63          	beq	a0,a5,3a8 <badwrite+0xb8>
    printf("write failed\n");
     372:	00005517          	auipc	a0,0x5
     376:	dde50513          	addi	a0,a0,-546 # 5150 <malloc+0x242>
     37a:	2db040ef          	jal	ra,4e54 <printf>
    exit(1);
     37e:	4505                	li	a0,1
     380:	6ca040ef          	jal	ra,4a4a <exit>
      printf("open junk failed\n");
     384:	00005517          	auipc	a0,0x5
     388:	db450513          	addi	a0,a0,-588 # 5138 <malloc+0x22a>
     38c:	2c9040ef          	jal	ra,4e54 <printf>
      exit(1);
     390:	4505                	li	a0,1
     392:	6b8040ef          	jal	ra,4a4a <exit>
    printf("open junk failed\n");
     396:	00005517          	auipc	a0,0x5
     39a:	da250513          	addi	a0,a0,-606 # 5138 <malloc+0x22a>
     39e:	2b7040ef          	jal	ra,4e54 <printf>
    exit(1);
     3a2:	4505                	li	a0,1
     3a4:	6a6040ef          	jal	ra,4a4a <exit>
  }
  close(fd);
     3a8:	8526                	mv	a0,s1
     3aa:	6c8040ef          	jal	ra,4a72 <close>
  unlink("junk");
     3ae:	00005517          	auipc	a0,0x5
     3b2:	d8250513          	addi	a0,a0,-638 # 5130 <malloc+0x222>
     3b6:	6e4040ef          	jal	ra,4a9a <unlink>

  exit(0);
     3ba:	4501                	li	a0,0
     3bc:	68e040ef          	jal	ra,4a4a <exit>

00000000000003c0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3c0:	715d                	addi	sp,sp,-80
     3c2:	e486                	sd	ra,72(sp)
     3c4:	e0a2                	sd	s0,64(sp)
     3c6:	fc26                	sd	s1,56(sp)
     3c8:	f84a                	sd	s2,48(sp)
     3ca:	f44e                	sd	s3,40(sp)
     3cc:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3ce:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3d0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d4:	40000993          	li	s3,1024
    name[0] = 'z';
     3d8:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3dc:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3e0:	41f4d79b          	sraiw	a5,s1,0x1f
     3e4:	01b7d71b          	srliw	a4,a5,0x1b
     3e8:	009707bb          	addw	a5,a4,s1
     3ec:	4057d69b          	sraiw	a3,a5,0x5
     3f0:	0306869b          	addiw	a3,a3,48
     3f4:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f8:	8bfd                	andi	a5,a5,31
     3fa:	9f99                	subw	a5,a5,a4
     3fc:	0307879b          	addiw	a5,a5,48
     400:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     404:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     408:	fb040513          	addi	a0,s0,-80
     40c:	68e040ef          	jal	ra,4a9a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     410:	60200593          	li	a1,1538
     414:	fb040513          	addi	a0,s0,-80
     418:	672040ef          	jal	ra,4a8a <open>
    if(fd < 0){
     41c:	00054763          	bltz	a0,42a <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     420:	652040ef          	jal	ra,4a72 <close>
  for(int i = 0; i < nzz; i++){
     424:	2485                	addiw	s1,s1,1
     426:	fb3499e3          	bne	s1,s3,3d8 <outofinodes+0x18>
     42a:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     430:	40000993          	li	s3,1024
    name[0] = 'z';
     434:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     438:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43c:	41f4d79b          	sraiw	a5,s1,0x1f
     440:	01b7d71b          	srliw	a4,a5,0x1b
     444:	009707bb          	addw	a5,a4,s1
     448:	4057d69b          	sraiw	a3,a5,0x5
     44c:	0306869b          	addiw	a3,a3,48
     450:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     454:	8bfd                	andi	a5,a5,31
     456:	9f99                	subw	a5,a5,a4
     458:	0307879b          	addiw	a5,a5,48
     45c:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     460:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     464:	fb040513          	addi	a0,s0,-80
     468:	632040ef          	jal	ra,4a9a <unlink>
  for(int i = 0; i < nzz; i++){
     46c:	2485                	addiw	s1,s1,1
     46e:	fd3493e3          	bne	s1,s3,434 <outofinodes+0x74>
  }
}
     472:	60a6                	ld	ra,72(sp)
     474:	6406                	ld	s0,64(sp)
     476:	74e2                	ld	s1,56(sp)
     478:	7942                	ld	s2,48(sp)
     47a:	79a2                	ld	s3,40(sp)
     47c:	6161                	addi	sp,sp,80
     47e:	8082                	ret

0000000000000480 <copyin>:
{
     480:	7159                	addi	sp,sp,-112
     482:	f486                	sd	ra,104(sp)
     484:	f0a2                	sd	s0,96(sp)
     486:	eca6                	sd	s1,88(sp)
     488:	e8ca                	sd	s2,80(sp)
     48a:	e4ce                	sd	s3,72(sp)
     48c:	e0d2                	sd	s4,64(sp)
     48e:	fc56                	sd	s5,56(sp)
     490:	f85a                	sd	s6,48(sp)
     492:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     494:	00007797          	auipc	a5,0x7
     498:	eec78793          	addi	a5,a5,-276 # 7380 <malloc+0x2472>
     49c:	638c                	ld	a1,0(a5)
     49e:	6790                	ld	a2,8(a5)
     4a0:	6b94                	ld	a3,16(a5)
     4a2:	6f98                	ld	a4,24(a5)
     4a4:	739c                	ld	a5,32(a5)
     4a6:	f8b43c23          	sd	a1,-104(s0)
     4aa:	fac43023          	sd	a2,-96(s0)
     4ae:	fad43423          	sd	a3,-88(s0)
     4b2:	fae43823          	sd	a4,-80(s0)
     4b6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ba:	f9840993          	addi	s3,s0,-104
     4be:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4c2:	00005a17          	auipc	s4,0x5
     4c6:	c9ea0a13          	addi	s4,s4,-866 # 5160 <malloc+0x252>
    uint64 addr = addrs[ai];
     4ca:	0009b903          	ld	s2,0(s3)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ce:	20100593          	li	a1,513
     4d2:	8552                	mv	a0,s4
     4d4:	5b6040ef          	jal	ra,4a8a <open>
     4d8:	84aa                	mv	s1,a0
    if(fd < 0){
     4da:	06054863          	bltz	a0,54a <copyin+0xca>
    int n = write(fd, (void*)addr, 8192);
     4de:	6609                	lui	a2,0x2
     4e0:	85ca                	mv	a1,s2
     4e2:	588040ef          	jal	ra,4a6a <write>
    if(n >= 0){
     4e6:	06055b63          	bgez	a0,55c <copyin+0xdc>
    close(fd);
     4ea:	8526                	mv	a0,s1
     4ec:	586040ef          	jal	ra,4a72 <close>
    unlink("copyin1");
     4f0:	8552                	mv	a0,s4
     4f2:	5a8040ef          	jal	ra,4a9a <unlink>
    n = write(1, (char*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ca                	mv	a1,s2
     4fa:	4505                	li	a0,1
     4fc:	56e040ef          	jal	ra,4a6a <write>
    if(n > 0){
     500:	06a04963          	bgtz	a0,572 <copyin+0xf2>
    if(pipe(fds) < 0){
     504:	f9040513          	addi	a0,s0,-112
     508:	552040ef          	jal	ra,4a5a <pipe>
     50c:	06054e63          	bltz	a0,588 <copyin+0x108>
    n = write(fds[1], (char*)addr, 8192);
     510:	6609                	lui	a2,0x2
     512:	85ca                	mv	a1,s2
     514:	f9442503          	lw	a0,-108(s0)
     518:	552040ef          	jal	ra,4a6a <write>
    if(n > 0){
     51c:	06a04f63          	bgtz	a0,59a <copyin+0x11a>
    close(fds[0]);
     520:	f9042503          	lw	a0,-112(s0)
     524:	54e040ef          	jal	ra,4a72 <close>
    close(fds[1]);
     528:	f9442503          	lw	a0,-108(s0)
     52c:	546040ef          	jal	ra,4a72 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     530:	09a1                	addi	s3,s3,8
     532:	f9599ce3          	bne	s3,s5,4ca <copyin+0x4a>
}
     536:	70a6                	ld	ra,104(sp)
     538:	7406                	ld	s0,96(sp)
     53a:	64e6                	ld	s1,88(sp)
     53c:	6946                	ld	s2,80(sp)
     53e:	69a6                	ld	s3,72(sp)
     540:	6a06                	ld	s4,64(sp)
     542:	7ae2                	ld	s5,56(sp)
     544:	7b42                	ld	s6,48(sp)
     546:	6165                	addi	sp,sp,112
     548:	8082                	ret
      printf("open(copyin1) failed\n");
     54a:	00005517          	auipc	a0,0x5
     54e:	c1e50513          	addi	a0,a0,-994 # 5168 <malloc+0x25a>
     552:	103040ef          	jal	ra,4e54 <printf>
      exit(1);
     556:	4505                	li	a0,1
     558:	4f2040ef          	jal	ra,4a4a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     55c:	862a                	mv	a2,a0
     55e:	85ca                	mv	a1,s2
     560:	00005517          	auipc	a0,0x5
     564:	c2050513          	addi	a0,a0,-992 # 5180 <malloc+0x272>
     568:	0ed040ef          	jal	ra,4e54 <printf>
      exit(1);
     56c:	4505                	li	a0,1
     56e:	4dc040ef          	jal	ra,4a4a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     572:	862a                	mv	a2,a0
     574:	85ca                	mv	a1,s2
     576:	00005517          	auipc	a0,0x5
     57a:	c3a50513          	addi	a0,a0,-966 # 51b0 <malloc+0x2a2>
     57e:	0d7040ef          	jal	ra,4e54 <printf>
      exit(1);
     582:	4505                	li	a0,1
     584:	4c6040ef          	jal	ra,4a4a <exit>
      printf("pipe() failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	c5850513          	addi	a0,a0,-936 # 51e0 <malloc+0x2d2>
     590:	0c5040ef          	jal	ra,4e54 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	4b4040ef          	jal	ra,4a4a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ca                	mv	a1,s2
     59e:	00005517          	auipc	a0,0x5
     5a2:	c5250513          	addi	a0,a0,-942 # 51f0 <malloc+0x2e2>
     5a6:	0af040ef          	jal	ra,4e54 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	49e040ef          	jal	ra,4a4a <exit>

00000000000005b0 <copyout>:
{
     5b0:	7175                	addi	sp,sp,-144
     5b2:	e506                	sd	ra,136(sp)
     5b4:	e122                	sd	s0,128(sp)
     5b6:	fca6                	sd	s1,120(sp)
     5b8:	f8ca                	sd	s2,112(sp)
     5ba:	f4ce                	sd	s3,104(sp)
     5bc:	f0d2                	sd	s4,96(sp)
     5be:	ecd6                	sd	s5,88(sp)
     5c0:	e8da                	sd	s6,80(sp)
     5c2:	e4de                	sd	s7,72(sp)
     5c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5c6:	00007797          	auipc	a5,0x7
     5ca:	dba78793          	addi	a5,a5,-582 # 7380 <malloc+0x2472>
     5ce:	7788                	ld	a0,40(a5)
     5d0:	7b8c                	ld	a1,48(a5)
     5d2:	7f90                	ld	a2,56(a5)
     5d4:	63b4                	ld	a3,64(a5)
     5d6:	67b8                	ld	a4,72(a5)
     5d8:	6bbc                	ld	a5,80(a5)
     5da:	f8a43023          	sd	a0,-128(s0)
     5de:	f8b43423          	sd	a1,-120(s0)
     5e2:	f8c43823          	sd	a2,-112(s0)
     5e6:	f8d43c23          	sd	a3,-104(s0)
     5ea:	fae43023          	sd	a4,-96(s0)
     5ee:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5f2:	f8040913          	addi	s2,s0,-128
     5f6:	fb040b13          	addi	s6,s0,-80
    int fd = open("README", 0);
     5fa:	00005a17          	auipc	s4,0x5
     5fe:	c26a0a13          	addi	s4,s4,-986 # 5220 <malloc+0x312>
    n = write(fds[1], "x", 1);
     602:	00005a97          	auipc	s5,0x5
     606:	ab6a8a93          	addi	s5,s5,-1354 # 50b8 <malloc+0x1aa>
    uint64 addr = addrs[ai];
     60a:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     60e:	4581                	li	a1,0
     610:	8552                	mv	a0,s4
     612:	478040ef          	jal	ra,4a8a <open>
     616:	84aa                	mv	s1,a0
    if(fd < 0){
     618:	06054863          	bltz	a0,688 <copyout+0xd8>
    int n = read(fd, (void*)addr, 8192);
     61c:	6609                	lui	a2,0x2
     61e:	85ce                	mv	a1,s3
     620:	442040ef          	jal	ra,4a62 <read>
    if(n > 0){
     624:	06a04b63          	bgtz	a0,69a <copyout+0xea>
    close(fd);
     628:	8526                	mv	a0,s1
     62a:	448040ef          	jal	ra,4a72 <close>
    if(pipe(fds) < 0){
     62e:	f7840513          	addi	a0,s0,-136
     632:	428040ef          	jal	ra,4a5a <pipe>
     636:	06054d63          	bltz	a0,6b0 <copyout+0x100>
    n = write(fds[1], "x", 1);
     63a:	4605                	li	a2,1
     63c:	85d6                	mv	a1,s5
     63e:	f7c42503          	lw	a0,-132(s0)
     642:	428040ef          	jal	ra,4a6a <write>
    if(n != 1){
     646:	4785                	li	a5,1
     648:	06f51d63          	bne	a0,a5,6c2 <copyout+0x112>
    n = read(fds[0], (void*)addr, 8192);
     64c:	6609                	lui	a2,0x2
     64e:	85ce                	mv	a1,s3
     650:	f7842503          	lw	a0,-136(s0)
     654:	40e040ef          	jal	ra,4a62 <read>
    if(n > 0){
     658:	06a04e63          	bgtz	a0,6d4 <copyout+0x124>
    close(fds[0]);
     65c:	f7842503          	lw	a0,-136(s0)
     660:	412040ef          	jal	ra,4a72 <close>
    close(fds[1]);
     664:	f7c42503          	lw	a0,-132(s0)
     668:	40a040ef          	jal	ra,4a72 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     66c:	0921                	addi	s2,s2,8
     66e:	f9691ee3          	bne	s2,s6,60a <copyout+0x5a>
}
     672:	60aa                	ld	ra,136(sp)
     674:	640a                	ld	s0,128(sp)
     676:	74e6                	ld	s1,120(sp)
     678:	7946                	ld	s2,112(sp)
     67a:	79a6                	ld	s3,104(sp)
     67c:	7a06                	ld	s4,96(sp)
     67e:	6ae6                	ld	s5,88(sp)
     680:	6b46                	ld	s6,80(sp)
     682:	6ba6                	ld	s7,72(sp)
     684:	6149                	addi	sp,sp,144
     686:	8082                	ret
      printf("open(README) failed\n");
     688:	00005517          	auipc	a0,0x5
     68c:	ba050513          	addi	a0,a0,-1120 # 5228 <malloc+0x31a>
     690:	7c4040ef          	jal	ra,4e54 <printf>
      exit(1);
     694:	4505                	li	a0,1
     696:	3b4040ef          	jal	ra,4a4a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     69a:	862a                	mv	a2,a0
     69c:	85ce                	mv	a1,s3
     69e:	00005517          	auipc	a0,0x5
     6a2:	ba250513          	addi	a0,a0,-1118 # 5240 <malloc+0x332>
     6a6:	7ae040ef          	jal	ra,4e54 <printf>
      exit(1);
     6aa:	4505                	li	a0,1
     6ac:	39e040ef          	jal	ra,4a4a <exit>
      printf("pipe() failed\n");
     6b0:	00005517          	auipc	a0,0x5
     6b4:	b3050513          	addi	a0,a0,-1232 # 51e0 <malloc+0x2d2>
     6b8:	79c040ef          	jal	ra,4e54 <printf>
      exit(1);
     6bc:	4505                	li	a0,1
     6be:	38c040ef          	jal	ra,4a4a <exit>
      printf("pipe write failed\n");
     6c2:	00005517          	auipc	a0,0x5
     6c6:	bae50513          	addi	a0,a0,-1106 # 5270 <malloc+0x362>
     6ca:	78a040ef          	jal	ra,4e54 <printf>
      exit(1);
     6ce:	4505                	li	a0,1
     6d0:	37a040ef          	jal	ra,4a4a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6d4:	862a                	mv	a2,a0
     6d6:	85ce                	mv	a1,s3
     6d8:	00005517          	auipc	a0,0x5
     6dc:	bb050513          	addi	a0,a0,-1104 # 5288 <malloc+0x37a>
     6e0:	774040ef          	jal	ra,4e54 <printf>
      exit(1);
     6e4:	4505                	li	a0,1
     6e6:	364040ef          	jal	ra,4a4a <exit>

00000000000006ea <truncate1>:
{
     6ea:	711d                	addi	sp,sp,-96
     6ec:	ec86                	sd	ra,88(sp)
     6ee:	e8a2                	sd	s0,80(sp)
     6f0:	e4a6                	sd	s1,72(sp)
     6f2:	e0ca                	sd	s2,64(sp)
     6f4:	fc4e                	sd	s3,56(sp)
     6f6:	f852                	sd	s4,48(sp)
     6f8:	f456                	sd	s5,40(sp)
     6fa:	1080                	addi	s0,sp,96
     6fc:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6fe:	00005517          	auipc	a0,0x5
     702:	9a250513          	addi	a0,a0,-1630 # 50a0 <malloc+0x192>
     706:	394040ef          	jal	ra,4a9a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     70a:	60100593          	li	a1,1537
     70e:	00005517          	auipc	a0,0x5
     712:	99250513          	addi	a0,a0,-1646 # 50a0 <malloc+0x192>
     716:	374040ef          	jal	ra,4a8a <open>
     71a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     71c:	4611                	li	a2,4
     71e:	00005597          	auipc	a1,0x5
     722:	99258593          	addi	a1,a1,-1646 # 50b0 <malloc+0x1a2>
     726:	344040ef          	jal	ra,4a6a <write>
  close(fd1);
     72a:	8526                	mv	a0,s1
     72c:	346040ef          	jal	ra,4a72 <close>
  int fd2 = open("truncfile", O_RDONLY);
     730:	4581                	li	a1,0
     732:	00005517          	auipc	a0,0x5
     736:	96e50513          	addi	a0,a0,-1682 # 50a0 <malloc+0x192>
     73a:	350040ef          	jal	ra,4a8a <open>
     73e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     740:	02000613          	li	a2,32
     744:	fa040593          	addi	a1,s0,-96
     748:	31a040ef          	jal	ra,4a62 <read>
  if(n != 4){
     74c:	4791                	li	a5,4
     74e:	0af51863          	bne	a0,a5,7fe <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     752:	40100593          	li	a1,1025
     756:	00005517          	auipc	a0,0x5
     75a:	94a50513          	addi	a0,a0,-1718 # 50a0 <malloc+0x192>
     75e:	32c040ef          	jal	ra,4a8a <open>
     762:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     764:	4581                	li	a1,0
     766:	00005517          	auipc	a0,0x5
     76a:	93a50513          	addi	a0,a0,-1734 # 50a0 <malloc+0x192>
     76e:	31c040ef          	jal	ra,4a8a <open>
     772:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     774:	02000613          	li	a2,32
     778:	fa040593          	addi	a1,s0,-96
     77c:	2e6040ef          	jal	ra,4a62 <read>
     780:	8a2a                	mv	s4,a0
  if(n != 0){
     782:	e949                	bnez	a0,814 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     784:	02000613          	li	a2,32
     788:	fa040593          	addi	a1,s0,-96
     78c:	8526                	mv	a0,s1
     78e:	2d4040ef          	jal	ra,4a62 <read>
     792:	8a2a                	mv	s4,a0
  if(n != 0){
     794:	e155                	bnez	a0,838 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     796:	4619                	li	a2,6
     798:	00005597          	auipc	a1,0x5
     79c:	b8058593          	addi	a1,a1,-1152 # 5318 <malloc+0x40a>
     7a0:	854e                	mv	a0,s3
     7a2:	2c8040ef          	jal	ra,4a6a <write>
  n = read(fd3, buf, sizeof(buf));
     7a6:	02000613          	li	a2,32
     7aa:	fa040593          	addi	a1,s0,-96
     7ae:	854a                	mv	a0,s2
     7b0:	2b2040ef          	jal	ra,4a62 <read>
  if(n != 6){
     7b4:	4799                	li	a5,6
     7b6:	0af51363          	bne	a0,a5,85c <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7ba:	02000613          	li	a2,32
     7be:	fa040593          	addi	a1,s0,-96
     7c2:	8526                	mv	a0,s1
     7c4:	29e040ef          	jal	ra,4a62 <read>
  if(n != 2){
     7c8:	4789                	li	a5,2
     7ca:	0af51463          	bne	a0,a5,872 <truncate1+0x188>
  unlink("truncfile");
     7ce:	00005517          	auipc	a0,0x5
     7d2:	8d250513          	addi	a0,a0,-1838 # 50a0 <malloc+0x192>
     7d6:	2c4040ef          	jal	ra,4a9a <unlink>
  close(fd1);
     7da:	854e                	mv	a0,s3
     7dc:	296040ef          	jal	ra,4a72 <close>
  close(fd2);
     7e0:	8526                	mv	a0,s1
     7e2:	290040ef          	jal	ra,4a72 <close>
  close(fd3);
     7e6:	854a                	mv	a0,s2
     7e8:	28a040ef          	jal	ra,4a72 <close>
}
     7ec:	60e6                	ld	ra,88(sp)
     7ee:	6446                	ld	s0,80(sp)
     7f0:	64a6                	ld	s1,72(sp)
     7f2:	6906                	ld	s2,64(sp)
     7f4:	79e2                	ld	s3,56(sp)
     7f6:	7a42                	ld	s4,48(sp)
     7f8:	7aa2                	ld	s5,40(sp)
     7fa:	6125                	addi	sp,sp,96
     7fc:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7fe:	862a                	mv	a2,a0
     800:	85d6                	mv	a1,s5
     802:	00005517          	auipc	a0,0x5
     806:	ab650513          	addi	a0,a0,-1354 # 52b8 <malloc+0x3aa>
     80a:	64a040ef          	jal	ra,4e54 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	23a040ef          	jal	ra,4a4a <exit>
    printf("aaa fd3=%d\n", fd3);
     814:	85ca                	mv	a1,s2
     816:	00005517          	auipc	a0,0x5
     81a:	ac250513          	addi	a0,a0,-1342 # 52d8 <malloc+0x3ca>
     81e:	636040ef          	jal	ra,4e54 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     822:	8652                	mv	a2,s4
     824:	85d6                	mv	a1,s5
     826:	00005517          	auipc	a0,0x5
     82a:	ac250513          	addi	a0,a0,-1342 # 52e8 <malloc+0x3da>
     82e:	626040ef          	jal	ra,4e54 <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	216040ef          	jal	ra,4a4a <exit>
    printf("bbb fd2=%d\n", fd2);
     838:	85a6                	mv	a1,s1
     83a:	00005517          	auipc	a0,0x5
     83e:	ace50513          	addi	a0,a0,-1330 # 5308 <malloc+0x3fa>
     842:	612040ef          	jal	ra,4e54 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     846:	8652                	mv	a2,s4
     848:	85d6                	mv	a1,s5
     84a:	00005517          	auipc	a0,0x5
     84e:	a9e50513          	addi	a0,a0,-1378 # 52e8 <malloc+0x3da>
     852:	602040ef          	jal	ra,4e54 <printf>
    exit(1);
     856:	4505                	li	a0,1
     858:	1f2040ef          	jal	ra,4a4a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     85c:	862a                	mv	a2,a0
     85e:	85d6                	mv	a1,s5
     860:	00005517          	auipc	a0,0x5
     864:	ac050513          	addi	a0,a0,-1344 # 5320 <malloc+0x412>
     868:	5ec040ef          	jal	ra,4e54 <printf>
    exit(1);
     86c:	4505                	li	a0,1
     86e:	1dc040ef          	jal	ra,4a4a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     872:	862a                	mv	a2,a0
     874:	85d6                	mv	a1,s5
     876:	00005517          	auipc	a0,0x5
     87a:	aca50513          	addi	a0,a0,-1334 # 5340 <malloc+0x432>
     87e:	5d6040ef          	jal	ra,4e54 <printf>
    exit(1);
     882:	4505                	li	a0,1
     884:	1c6040ef          	jal	ra,4a4a <exit>

0000000000000888 <writetest>:
{
     888:	7139                	addi	sp,sp,-64
     88a:	fc06                	sd	ra,56(sp)
     88c:	f822                	sd	s0,48(sp)
     88e:	f426                	sd	s1,40(sp)
     890:	f04a                	sd	s2,32(sp)
     892:	ec4e                	sd	s3,24(sp)
     894:	e852                	sd	s4,16(sp)
     896:	e456                	sd	s5,8(sp)
     898:	e05a                	sd	s6,0(sp)
     89a:	0080                	addi	s0,sp,64
     89c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     89e:	20200593          	li	a1,514
     8a2:	00005517          	auipc	a0,0x5
     8a6:	abe50513          	addi	a0,a0,-1346 # 5360 <malloc+0x452>
     8aa:	1e0040ef          	jal	ra,4a8a <open>
  if(fd < 0){
     8ae:	08054f63          	bltz	a0,94c <writetest+0xc4>
     8b2:	892a                	mv	s2,a0
     8b4:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8b6:	00005997          	auipc	s3,0x5
     8ba:	ad298993          	addi	s3,s3,-1326 # 5388 <malloc+0x47a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8be:	00005a97          	auipc	s5,0x5
     8c2:	b02a8a93          	addi	s5,s5,-1278 # 53c0 <malloc+0x4b2>
  for(i = 0; i < N; i++){
     8c6:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ca:	4629                	li	a2,10
     8cc:	85ce                	mv	a1,s3
     8ce:	854a                	mv	a0,s2
     8d0:	19a040ef          	jal	ra,4a6a <write>
     8d4:	47a9                	li	a5,10
     8d6:	08f51563          	bne	a0,a5,960 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8da:	4629                	li	a2,10
     8dc:	85d6                	mv	a1,s5
     8de:	854a                	mv	a0,s2
     8e0:	18a040ef          	jal	ra,4a6a <write>
     8e4:	47a9                	li	a5,10
     8e6:	08f51863          	bne	a0,a5,976 <writetest+0xee>
  for(i = 0; i < N; i++){
     8ea:	2485                	addiw	s1,s1,1
     8ec:	fd449fe3          	bne	s1,s4,8ca <writetest+0x42>
  close(fd);
     8f0:	854a                	mv	a0,s2
     8f2:	180040ef          	jal	ra,4a72 <close>
  fd = open("small", O_RDONLY);
     8f6:	4581                	li	a1,0
     8f8:	00005517          	auipc	a0,0x5
     8fc:	a6850513          	addi	a0,a0,-1432 # 5360 <malloc+0x452>
     900:	18a040ef          	jal	ra,4a8a <open>
     904:	84aa                	mv	s1,a0
  if(fd < 0){
     906:	08054363          	bltz	a0,98c <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     90a:	7d000613          	li	a2,2000
     90e:	0000b597          	auipc	a1,0xb
     912:	36a58593          	addi	a1,a1,874 # bc78 <buf>
     916:	14c040ef          	jal	ra,4a62 <read>
  if(i != N*SZ*2){
     91a:	7d000793          	li	a5,2000
     91e:	08f51163          	bne	a0,a5,9a0 <writetest+0x118>
  close(fd);
     922:	8526                	mv	a0,s1
     924:	14e040ef          	jal	ra,4a72 <close>
  if(unlink("small") < 0){
     928:	00005517          	auipc	a0,0x5
     92c:	a3850513          	addi	a0,a0,-1480 # 5360 <malloc+0x452>
     930:	16a040ef          	jal	ra,4a9a <unlink>
     934:	08054063          	bltz	a0,9b4 <writetest+0x12c>
}
     938:	70e2                	ld	ra,56(sp)
     93a:	7442                	ld	s0,48(sp)
     93c:	74a2                	ld	s1,40(sp)
     93e:	7902                	ld	s2,32(sp)
     940:	69e2                	ld	s3,24(sp)
     942:	6a42                	ld	s4,16(sp)
     944:	6aa2                	ld	s5,8(sp)
     946:	6b02                	ld	s6,0(sp)
     948:	6121                	addi	sp,sp,64
     94a:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     94c:	85da                	mv	a1,s6
     94e:	00005517          	auipc	a0,0x5
     952:	a1a50513          	addi	a0,a0,-1510 # 5368 <malloc+0x45a>
     956:	4fe040ef          	jal	ra,4e54 <printf>
    exit(1);
     95a:	4505                	li	a0,1
     95c:	0ee040ef          	jal	ra,4a4a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     960:	8626                	mv	a2,s1
     962:	85da                	mv	a1,s6
     964:	00005517          	auipc	a0,0x5
     968:	a3450513          	addi	a0,a0,-1484 # 5398 <malloc+0x48a>
     96c:	4e8040ef          	jal	ra,4e54 <printf>
      exit(1);
     970:	4505                	li	a0,1
     972:	0d8040ef          	jal	ra,4a4a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     976:	8626                	mv	a2,s1
     978:	85da                	mv	a1,s6
     97a:	00005517          	auipc	a0,0x5
     97e:	a5650513          	addi	a0,a0,-1450 # 53d0 <malloc+0x4c2>
     982:	4d2040ef          	jal	ra,4e54 <printf>
      exit(1);
     986:	4505                	li	a0,1
     988:	0c2040ef          	jal	ra,4a4a <exit>
    printf("%s: error: open small failed!\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	a6a50513          	addi	a0,a0,-1430 # 53f8 <malloc+0x4ea>
     996:	4be040ef          	jal	ra,4e54 <printf>
    exit(1);
     99a:	4505                	li	a0,1
     99c:	0ae040ef          	jal	ra,4a4a <exit>
    printf("%s: read failed\n", s);
     9a0:	85da                	mv	a1,s6
     9a2:	00005517          	auipc	a0,0x5
     9a6:	a7650513          	addi	a0,a0,-1418 # 5418 <malloc+0x50a>
     9aa:	4aa040ef          	jal	ra,4e54 <printf>
    exit(1);
     9ae:	4505                	li	a0,1
     9b0:	09a040ef          	jal	ra,4a4a <exit>
    printf("%s: unlink small failed\n", s);
     9b4:	85da                	mv	a1,s6
     9b6:	00005517          	auipc	a0,0x5
     9ba:	a7a50513          	addi	a0,a0,-1414 # 5430 <malloc+0x522>
     9be:	496040ef          	jal	ra,4e54 <printf>
    exit(1);
     9c2:	4505                	li	a0,1
     9c4:	086040ef          	jal	ra,4a4a <exit>

00000000000009c8 <writebig>:
{
     9c8:	7139                	addi	sp,sp,-64
     9ca:	fc06                	sd	ra,56(sp)
     9cc:	f822                	sd	s0,48(sp)
     9ce:	f426                	sd	s1,40(sp)
     9d0:	f04a                	sd	s2,32(sp)
     9d2:	ec4e                	sd	s3,24(sp)
     9d4:	e852                	sd	s4,16(sp)
     9d6:	e456                	sd	s5,8(sp)
     9d8:	0080                	addi	s0,sp,64
     9da:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9dc:	20200593          	li	a1,514
     9e0:	00005517          	auipc	a0,0x5
     9e4:	a7050513          	addi	a0,a0,-1424 # 5450 <malloc+0x542>
     9e8:	0a2040ef          	jal	ra,4a8a <open>
     9ec:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9ee:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9f0:	0000b917          	auipc	s2,0xb
     9f4:	28890913          	addi	s2,s2,648 # bc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f8:	10c00a13          	li	s4,268
  if(fd < 0){
     9fc:	06054463          	bltz	a0,a64 <writebig+0x9c>
    ((int*)buf)[0] = i;
     a00:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     a04:	40000613          	li	a2,1024
     a08:	85ca                	mv	a1,s2
     a0a:	854e                	mv	a0,s3
     a0c:	05e040ef          	jal	ra,4a6a <write>
     a10:	40000793          	li	a5,1024
     a14:	06f51263          	bne	a0,a5,a78 <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a18:	2485                	addiw	s1,s1,1
     a1a:	ff4493e3          	bne	s1,s4,a00 <writebig+0x38>
  close(fd);
     a1e:	854e                	mv	a0,s3
     a20:	052040ef          	jal	ra,4a72 <close>
  fd = open("big", O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	00005517          	auipc	a0,0x5
     a2a:	a2a50513          	addi	a0,a0,-1494 # 5450 <malloc+0x542>
     a2e:	05c040ef          	jal	ra,4a8a <open>
     a32:	89aa                	mv	s3,a0
  n = 0;
     a34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a36:	0000b917          	auipc	s2,0xb
     a3a:	24290913          	addi	s2,s2,578 # bc78 <buf>
  if(fd < 0){
     a3e:	04054863          	bltz	a0,a8e <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a42:	40000613          	li	a2,1024
     a46:	85ca                	mv	a1,s2
     a48:	854e                	mv	a0,s3
     a4a:	018040ef          	jal	ra,4a62 <read>
    if(i == 0){
     a4e:	c931                	beqz	a0,aa2 <writebig+0xda>
    } else if(i != BSIZE){
     a50:	40000793          	li	a5,1024
     a54:	08f51a63          	bne	a0,a5,ae8 <writebig+0x120>
    if(((int*)buf)[0] != n){
     a58:	00092683          	lw	a3,0(s2)
     a5c:	0a969163          	bne	a3,s1,afe <writebig+0x136>
    n++;
     a60:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a62:	b7c5                	j	a42 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a64:	85d6                	mv	a1,s5
     a66:	00005517          	auipc	a0,0x5
     a6a:	9f250513          	addi	a0,a0,-1550 # 5458 <malloc+0x54a>
     a6e:	3e6040ef          	jal	ra,4e54 <printf>
    exit(1);
     a72:	4505                	li	a0,1
     a74:	7d7030ef          	jal	ra,4a4a <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a78:	8626                	mv	a2,s1
     a7a:	85d6                	mv	a1,s5
     a7c:	00005517          	auipc	a0,0x5
     a80:	9fc50513          	addi	a0,a0,-1540 # 5478 <malloc+0x56a>
     a84:	3d0040ef          	jal	ra,4e54 <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	7c1030ef          	jal	ra,4a4a <exit>
    printf("%s: error: open big failed!\n", s);
     a8e:	85d6                	mv	a1,s5
     a90:	00005517          	auipc	a0,0x5
     a94:	a1050513          	addi	a0,a0,-1520 # 54a0 <malloc+0x592>
     a98:	3bc040ef          	jal	ra,4e54 <printf>
    exit(1);
     a9c:	4505                	li	a0,1
     a9e:	7ad030ef          	jal	ra,4a4a <exit>
      if(n != MAXFILE){
     aa2:	10c00793          	li	a5,268
     aa6:	02f49663          	bne	s1,a5,ad2 <writebig+0x10a>
  close(fd);
     aaa:	854e                	mv	a0,s3
     aac:	7c7030ef          	jal	ra,4a72 <close>
  if(unlink("big") < 0){
     ab0:	00005517          	auipc	a0,0x5
     ab4:	9a050513          	addi	a0,a0,-1632 # 5450 <malloc+0x542>
     ab8:	7e3030ef          	jal	ra,4a9a <unlink>
     abc:	04054c63          	bltz	a0,b14 <writebig+0x14c>
}
     ac0:	70e2                	ld	ra,56(sp)
     ac2:	7442                	ld	s0,48(sp)
     ac4:	74a2                	ld	s1,40(sp)
     ac6:	7902                	ld	s2,32(sp)
     ac8:	69e2                	ld	s3,24(sp)
     aca:	6a42                	ld	s4,16(sp)
     acc:	6aa2                	ld	s5,8(sp)
     ace:	6121                	addi	sp,sp,64
     ad0:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ad2:	8626                	mv	a2,s1
     ad4:	85d6                	mv	a1,s5
     ad6:	00005517          	auipc	a0,0x5
     ada:	9ea50513          	addi	a0,a0,-1558 # 54c0 <malloc+0x5b2>
     ade:	376040ef          	jal	ra,4e54 <printf>
        exit(1);
     ae2:	4505                	li	a0,1
     ae4:	767030ef          	jal	ra,4a4a <exit>
      printf("%s: read failed %d\n", s, i);
     ae8:	862a                	mv	a2,a0
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	9fc50513          	addi	a0,a0,-1540 # 54e8 <malloc+0x5da>
     af4:	360040ef          	jal	ra,4e54 <printf>
      exit(1);
     af8:	4505                	li	a0,1
     afa:	751030ef          	jal	ra,4a4a <exit>
      printf("%s: read content of block %d is %d\n", s,
     afe:	8626                	mv	a2,s1
     b00:	85d6                	mv	a1,s5
     b02:	00005517          	auipc	a0,0x5
     b06:	9fe50513          	addi	a0,a0,-1538 # 5500 <malloc+0x5f2>
     b0a:	34a040ef          	jal	ra,4e54 <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	73b030ef          	jal	ra,4a4a <exit>
    printf("%s: unlink big failed\n", s);
     b14:	85d6                	mv	a1,s5
     b16:	00005517          	auipc	a0,0x5
     b1a:	a1250513          	addi	a0,a0,-1518 # 5528 <malloc+0x61a>
     b1e:	336040ef          	jal	ra,4e54 <printf>
    exit(1);
     b22:	4505                	li	a0,1
     b24:	727030ef          	jal	ra,4a4a <exit>

0000000000000b28 <unlinkread>:
{
     b28:	7179                	addi	sp,sp,-48
     b2a:	f406                	sd	ra,40(sp)
     b2c:	f022                	sd	s0,32(sp)
     b2e:	ec26                	sd	s1,24(sp)
     b30:	e84a                	sd	s2,16(sp)
     b32:	e44e                	sd	s3,8(sp)
     b34:	1800                	addi	s0,sp,48
     b36:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b38:	20200593          	li	a1,514
     b3c:	00005517          	auipc	a0,0x5
     b40:	a0450513          	addi	a0,a0,-1532 # 5540 <malloc+0x632>
     b44:	747030ef          	jal	ra,4a8a <open>
  if(fd < 0){
     b48:	0a054f63          	bltz	a0,c06 <unlinkread+0xde>
     b4c:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b4e:	4615                	li	a2,5
     b50:	00005597          	auipc	a1,0x5
     b54:	a2058593          	addi	a1,a1,-1504 # 5570 <malloc+0x662>
     b58:	713030ef          	jal	ra,4a6a <write>
  close(fd);
     b5c:	8526                	mv	a0,s1
     b5e:	715030ef          	jal	ra,4a72 <close>
  fd = open("unlinkread", O_RDWR);
     b62:	4589                	li	a1,2
     b64:	00005517          	auipc	a0,0x5
     b68:	9dc50513          	addi	a0,a0,-1572 # 5540 <malloc+0x632>
     b6c:	71f030ef          	jal	ra,4a8a <open>
     b70:	84aa                	mv	s1,a0
  if(fd < 0){
     b72:	0a054463          	bltz	a0,c1a <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b76:	00005517          	auipc	a0,0x5
     b7a:	9ca50513          	addi	a0,a0,-1590 # 5540 <malloc+0x632>
     b7e:	71d030ef          	jal	ra,4a9a <unlink>
     b82:	e555                	bnez	a0,c2e <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	9b850513          	addi	a0,a0,-1608 # 5540 <malloc+0x632>
     b90:	6fb030ef          	jal	ra,4a8a <open>
     b94:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b96:	460d                	li	a2,3
     b98:	00005597          	auipc	a1,0x5
     b9c:	a2058593          	addi	a1,a1,-1504 # 55b8 <malloc+0x6aa>
     ba0:	6cb030ef          	jal	ra,4a6a <write>
  close(fd1);
     ba4:	854a                	mv	a0,s2
     ba6:	6cd030ef          	jal	ra,4a72 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     baa:	660d                	lui	a2,0x3
     bac:	0000b597          	auipc	a1,0xb
     bb0:	0cc58593          	addi	a1,a1,204 # bc78 <buf>
     bb4:	8526                	mv	a0,s1
     bb6:	6ad030ef          	jal	ra,4a62 <read>
     bba:	4795                	li	a5,5
     bbc:	08f51363          	bne	a0,a5,c42 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bc0:	0000b717          	auipc	a4,0xb
     bc4:	0b874703          	lbu	a4,184(a4) # bc78 <buf>
     bc8:	06800793          	li	a5,104
     bcc:	08f71563          	bne	a4,a5,c56 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bd0:	4629                	li	a2,10
     bd2:	0000b597          	auipc	a1,0xb
     bd6:	0a658593          	addi	a1,a1,166 # bc78 <buf>
     bda:	8526                	mv	a0,s1
     bdc:	68f030ef          	jal	ra,4a6a <write>
     be0:	47a9                	li	a5,10
     be2:	08f51463          	bne	a0,a5,c6a <unlinkread+0x142>
  close(fd);
     be6:	8526                	mv	a0,s1
     be8:	68b030ef          	jal	ra,4a72 <close>
  unlink("unlinkread");
     bec:	00005517          	auipc	a0,0x5
     bf0:	95450513          	addi	a0,a0,-1708 # 5540 <malloc+0x632>
     bf4:	6a7030ef          	jal	ra,4a9a <unlink>
}
     bf8:	70a2                	ld	ra,40(sp)
     bfa:	7402                	ld	s0,32(sp)
     bfc:	64e2                	ld	s1,24(sp)
     bfe:	6942                	ld	s2,16(sp)
     c00:	69a2                	ld	s3,8(sp)
     c02:	6145                	addi	sp,sp,48
     c04:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c06:	85ce                	mv	a1,s3
     c08:	00005517          	auipc	a0,0x5
     c0c:	94850513          	addi	a0,a0,-1720 # 5550 <malloc+0x642>
     c10:	244040ef          	jal	ra,4e54 <printf>
    exit(1);
     c14:	4505                	li	a0,1
     c16:	635030ef          	jal	ra,4a4a <exit>
    printf("%s: open unlinkread failed\n", s);
     c1a:	85ce                	mv	a1,s3
     c1c:	00005517          	auipc	a0,0x5
     c20:	95c50513          	addi	a0,a0,-1700 # 5578 <malloc+0x66a>
     c24:	230040ef          	jal	ra,4e54 <printf>
    exit(1);
     c28:	4505                	li	a0,1
     c2a:	621030ef          	jal	ra,4a4a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c2e:	85ce                	mv	a1,s3
     c30:	00005517          	auipc	a0,0x5
     c34:	96850513          	addi	a0,a0,-1688 # 5598 <malloc+0x68a>
     c38:	21c040ef          	jal	ra,4e54 <printf>
    exit(1);
     c3c:	4505                	li	a0,1
     c3e:	60d030ef          	jal	ra,4a4a <exit>
    printf("%s: unlinkread read failed", s);
     c42:	85ce                	mv	a1,s3
     c44:	00005517          	auipc	a0,0x5
     c48:	97c50513          	addi	a0,a0,-1668 # 55c0 <malloc+0x6b2>
     c4c:	208040ef          	jal	ra,4e54 <printf>
    exit(1);
     c50:	4505                	li	a0,1
     c52:	5f9030ef          	jal	ra,4a4a <exit>
    printf("%s: unlinkread wrong data\n", s);
     c56:	85ce                	mv	a1,s3
     c58:	00005517          	auipc	a0,0x5
     c5c:	98850513          	addi	a0,a0,-1656 # 55e0 <malloc+0x6d2>
     c60:	1f4040ef          	jal	ra,4e54 <printf>
    exit(1);
     c64:	4505                	li	a0,1
     c66:	5e5030ef          	jal	ra,4a4a <exit>
    printf("%s: unlinkread write failed\n", s);
     c6a:	85ce                	mv	a1,s3
     c6c:	00005517          	auipc	a0,0x5
     c70:	99450513          	addi	a0,a0,-1644 # 5600 <malloc+0x6f2>
     c74:	1e0040ef          	jal	ra,4e54 <printf>
    exit(1);
     c78:	4505                	li	a0,1
     c7a:	5d1030ef          	jal	ra,4a4a <exit>

0000000000000c7e <linktest>:
{
     c7e:	1101                	addi	sp,sp,-32
     c80:	ec06                	sd	ra,24(sp)
     c82:	e822                	sd	s0,16(sp)
     c84:	e426                	sd	s1,8(sp)
     c86:	e04a                	sd	s2,0(sp)
     c88:	1000                	addi	s0,sp,32
     c8a:	892a                	mv	s2,a0
  unlink("lf1");
     c8c:	00005517          	auipc	a0,0x5
     c90:	99450513          	addi	a0,a0,-1644 # 5620 <malloc+0x712>
     c94:	607030ef          	jal	ra,4a9a <unlink>
  unlink("lf2");
     c98:	00005517          	auipc	a0,0x5
     c9c:	99050513          	addi	a0,a0,-1648 # 5628 <malloc+0x71a>
     ca0:	5fb030ef          	jal	ra,4a9a <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     ca4:	20200593          	li	a1,514
     ca8:	00005517          	auipc	a0,0x5
     cac:	97850513          	addi	a0,a0,-1672 # 5620 <malloc+0x712>
     cb0:	5db030ef          	jal	ra,4a8a <open>
  if(fd < 0){
     cb4:	0c054f63          	bltz	a0,d92 <linktest+0x114>
     cb8:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cba:	4615                	li	a2,5
     cbc:	00005597          	auipc	a1,0x5
     cc0:	8b458593          	addi	a1,a1,-1868 # 5570 <malloc+0x662>
     cc4:	5a7030ef          	jal	ra,4a6a <write>
     cc8:	4795                	li	a5,5
     cca:	0cf51e63          	bne	a0,a5,da6 <linktest+0x128>
  close(fd);
     cce:	8526                	mv	a0,s1
     cd0:	5a3030ef          	jal	ra,4a72 <close>
  if(link("lf1", "lf2") < 0){
     cd4:	00005597          	auipc	a1,0x5
     cd8:	95458593          	addi	a1,a1,-1708 # 5628 <malloc+0x71a>
     cdc:	00005517          	auipc	a0,0x5
     ce0:	94450513          	addi	a0,a0,-1724 # 5620 <malloc+0x712>
     ce4:	5c7030ef          	jal	ra,4aaa <link>
     ce8:	0c054963          	bltz	a0,dba <linktest+0x13c>
  unlink("lf1");
     cec:	00005517          	auipc	a0,0x5
     cf0:	93450513          	addi	a0,a0,-1740 # 5620 <malloc+0x712>
     cf4:	5a7030ef          	jal	ra,4a9a <unlink>
  if(open("lf1", 0) >= 0){
     cf8:	4581                	li	a1,0
     cfa:	00005517          	auipc	a0,0x5
     cfe:	92650513          	addi	a0,a0,-1754 # 5620 <malloc+0x712>
     d02:	589030ef          	jal	ra,4a8a <open>
     d06:	0c055463          	bgez	a0,dce <linktest+0x150>
  fd = open("lf2", 0);
     d0a:	4581                	li	a1,0
     d0c:	00005517          	auipc	a0,0x5
     d10:	91c50513          	addi	a0,a0,-1764 # 5628 <malloc+0x71a>
     d14:	577030ef          	jal	ra,4a8a <open>
     d18:	84aa                	mv	s1,a0
  if(fd < 0){
     d1a:	0c054463          	bltz	a0,de2 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d1e:	660d                	lui	a2,0x3
     d20:	0000b597          	auipc	a1,0xb
     d24:	f5858593          	addi	a1,a1,-168 # bc78 <buf>
     d28:	53b030ef          	jal	ra,4a62 <read>
     d2c:	4795                	li	a5,5
     d2e:	0cf51463          	bne	a0,a5,df6 <linktest+0x178>
  close(fd);
     d32:	8526                	mv	a0,s1
     d34:	53f030ef          	jal	ra,4a72 <close>
  if(link("lf2", "lf2") >= 0){
     d38:	00005597          	auipc	a1,0x5
     d3c:	8f058593          	addi	a1,a1,-1808 # 5628 <malloc+0x71a>
     d40:	852e                	mv	a0,a1
     d42:	569030ef          	jal	ra,4aaa <link>
     d46:	0c055263          	bgez	a0,e0a <linktest+0x18c>
  unlink("lf2");
     d4a:	00005517          	auipc	a0,0x5
     d4e:	8de50513          	addi	a0,a0,-1826 # 5628 <malloc+0x71a>
     d52:	549030ef          	jal	ra,4a9a <unlink>
  if(link("lf2", "lf1") >= 0){
     d56:	00005597          	auipc	a1,0x5
     d5a:	8ca58593          	addi	a1,a1,-1846 # 5620 <malloc+0x712>
     d5e:	00005517          	auipc	a0,0x5
     d62:	8ca50513          	addi	a0,a0,-1846 # 5628 <malloc+0x71a>
     d66:	545030ef          	jal	ra,4aaa <link>
     d6a:	0a055a63          	bgez	a0,e1e <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d6e:	00005597          	auipc	a1,0x5
     d72:	8b258593          	addi	a1,a1,-1870 # 5620 <malloc+0x712>
     d76:	00005517          	auipc	a0,0x5
     d7a:	9ba50513          	addi	a0,a0,-1606 # 5730 <malloc+0x822>
     d7e:	52d030ef          	jal	ra,4aaa <link>
     d82:	0a055863          	bgez	a0,e32 <linktest+0x1b4>
}
     d86:	60e2                	ld	ra,24(sp)
     d88:	6442                	ld	s0,16(sp)
     d8a:	64a2                	ld	s1,8(sp)
     d8c:	6902                	ld	s2,0(sp)
     d8e:	6105                	addi	sp,sp,32
     d90:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d92:	85ca                	mv	a1,s2
     d94:	00005517          	auipc	a0,0x5
     d98:	89c50513          	addi	a0,a0,-1892 # 5630 <malloc+0x722>
     d9c:	0b8040ef          	jal	ra,4e54 <printf>
    exit(1);
     da0:	4505                	li	a0,1
     da2:	4a9030ef          	jal	ra,4a4a <exit>
    printf("%s: write lf1 failed\n", s);
     da6:	85ca                	mv	a1,s2
     da8:	00005517          	auipc	a0,0x5
     dac:	8a050513          	addi	a0,a0,-1888 # 5648 <malloc+0x73a>
     db0:	0a4040ef          	jal	ra,4e54 <printf>
    exit(1);
     db4:	4505                	li	a0,1
     db6:	495030ef          	jal	ra,4a4a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     dba:	85ca                	mv	a1,s2
     dbc:	00005517          	auipc	a0,0x5
     dc0:	8a450513          	addi	a0,a0,-1884 # 5660 <malloc+0x752>
     dc4:	090040ef          	jal	ra,4e54 <printf>
    exit(1);
     dc8:	4505                	li	a0,1
     dca:	481030ef          	jal	ra,4a4a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dce:	85ca                	mv	a1,s2
     dd0:	00005517          	auipc	a0,0x5
     dd4:	8b050513          	addi	a0,a0,-1872 # 5680 <malloc+0x772>
     dd8:	07c040ef          	jal	ra,4e54 <printf>
    exit(1);
     ddc:	4505                	li	a0,1
     dde:	46d030ef          	jal	ra,4a4a <exit>
    printf("%s: open lf2 failed\n", s);
     de2:	85ca                	mv	a1,s2
     de4:	00005517          	auipc	a0,0x5
     de8:	8cc50513          	addi	a0,a0,-1844 # 56b0 <malloc+0x7a2>
     dec:	068040ef          	jal	ra,4e54 <printf>
    exit(1);
     df0:	4505                	li	a0,1
     df2:	459030ef          	jal	ra,4a4a <exit>
    printf("%s: read lf2 failed\n", s);
     df6:	85ca                	mv	a1,s2
     df8:	00005517          	auipc	a0,0x5
     dfc:	8d050513          	addi	a0,a0,-1840 # 56c8 <malloc+0x7ba>
     e00:	054040ef          	jal	ra,4e54 <printf>
    exit(1);
     e04:	4505                	li	a0,1
     e06:	445030ef          	jal	ra,4a4a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e0a:	85ca                	mv	a1,s2
     e0c:	00005517          	auipc	a0,0x5
     e10:	8d450513          	addi	a0,a0,-1836 # 56e0 <malloc+0x7d2>
     e14:	040040ef          	jal	ra,4e54 <printf>
    exit(1);
     e18:	4505                	li	a0,1
     e1a:	431030ef          	jal	ra,4a4a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e1e:	85ca                	mv	a1,s2
     e20:	00005517          	auipc	a0,0x5
     e24:	8e850513          	addi	a0,a0,-1816 # 5708 <malloc+0x7fa>
     e28:	02c040ef          	jal	ra,4e54 <printf>
    exit(1);
     e2c:	4505                	li	a0,1
     e2e:	41d030ef          	jal	ra,4a4a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e32:	85ca                	mv	a1,s2
     e34:	00005517          	auipc	a0,0x5
     e38:	90450513          	addi	a0,a0,-1788 # 5738 <malloc+0x82a>
     e3c:	018040ef          	jal	ra,4e54 <printf>
    exit(1);
     e40:	4505                	li	a0,1
     e42:	409030ef          	jal	ra,4a4a <exit>

0000000000000e46 <validatetest>:
{
     e46:	7139                	addi	sp,sp,-64
     e48:	fc06                	sd	ra,56(sp)
     e4a:	f822                	sd	s0,48(sp)
     e4c:	f426                	sd	s1,40(sp)
     e4e:	f04a                	sd	s2,32(sp)
     e50:	ec4e                	sd	s3,24(sp)
     e52:	e852                	sd	s4,16(sp)
     e54:	e456                	sd	s5,8(sp)
     e56:	e05a                	sd	s6,0(sp)
     e58:	0080                	addi	s0,sp,64
     e5a:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5c:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e5e:	00005997          	auipc	s3,0x5
     e62:	8fa98993          	addi	s3,s3,-1798 # 5758 <malloc+0x84a>
     e66:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e68:	6a85                	lui	s5,0x1
     e6a:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e6e:	85a6                	mv	a1,s1
     e70:	854e                	mv	a0,s3
     e72:	439030ef          	jal	ra,4aaa <link>
     e76:	01251f63          	bne	a0,s2,e94 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e7a:	94d6                	add	s1,s1,s5
     e7c:	ff4499e3          	bne	s1,s4,e6e <validatetest+0x28>
}
     e80:	70e2                	ld	ra,56(sp)
     e82:	7442                	ld	s0,48(sp)
     e84:	74a2                	ld	s1,40(sp)
     e86:	7902                	ld	s2,32(sp)
     e88:	69e2                	ld	s3,24(sp)
     e8a:	6a42                	ld	s4,16(sp)
     e8c:	6aa2                	ld	s5,8(sp)
     e8e:	6b02                	ld	s6,0(sp)
     e90:	6121                	addi	sp,sp,64
     e92:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e94:	85da                	mv	a1,s6
     e96:	00005517          	auipc	a0,0x5
     e9a:	8d250513          	addi	a0,a0,-1838 # 5768 <malloc+0x85a>
     e9e:	7b7030ef          	jal	ra,4e54 <printf>
      exit(1);
     ea2:	4505                	li	a0,1
     ea4:	3a7030ef          	jal	ra,4a4a <exit>

0000000000000ea8 <bigdir>:
{
     ea8:	715d                	addi	sp,sp,-80
     eaa:	e486                	sd	ra,72(sp)
     eac:	e0a2                	sd	s0,64(sp)
     eae:	fc26                	sd	s1,56(sp)
     eb0:	f84a                	sd	s2,48(sp)
     eb2:	f44e                	sd	s3,40(sp)
     eb4:	f052                	sd	s4,32(sp)
     eb6:	ec56                	sd	s5,24(sp)
     eb8:	e85a                	sd	s6,16(sp)
     eba:	0880                	addi	s0,sp,80
     ebc:	89aa                	mv	s3,a0
  unlink("bd");
     ebe:	00005517          	auipc	a0,0x5
     ec2:	8ca50513          	addi	a0,a0,-1846 # 5788 <malloc+0x87a>
     ec6:	3d5030ef          	jal	ra,4a9a <unlink>
  fd = open("bd", O_CREATE);
     eca:	20000593          	li	a1,512
     ece:	00005517          	auipc	a0,0x5
     ed2:	8ba50513          	addi	a0,a0,-1862 # 5788 <malloc+0x87a>
     ed6:	3b5030ef          	jal	ra,4a8a <open>
  if(fd < 0){
     eda:	0c054163          	bltz	a0,f9c <bigdir+0xf4>
  close(fd);
     ede:	395030ef          	jal	ra,4a72 <close>
  for(i = 0; i < N; i++){
     ee2:	4901                	li	s2,0
    name[0] = 'x';
     ee4:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee8:	00005a17          	auipc	s4,0x5
     eec:	8a0a0a13          	addi	s4,s4,-1888 # 5788 <malloc+0x87a>
  for(i = 0; i < N; i++){
     ef0:	1f400b13          	li	s6,500
    name[0] = 'x';
     ef4:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef8:	41f9579b          	sraiw	a5,s2,0x1f
     efc:	01a7d71b          	srliw	a4,a5,0x1a
     f00:	012707bb          	addw	a5,a4,s2
     f04:	4067d69b          	sraiw	a3,a5,0x6
     f08:	0306869b          	addiw	a3,a3,48
     f0c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f10:	03f7f793          	andi	a5,a5,63
     f14:	9f99                	subw	a5,a5,a4
     f16:	0307879b          	addiw	a5,a5,48
     f1a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f1e:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f22:	fb040593          	addi	a1,s0,-80
     f26:	8552                	mv	a0,s4
     f28:	383030ef          	jal	ra,4aaa <link>
     f2c:	84aa                	mv	s1,a0
     f2e:	e149                	bnez	a0,fb0 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f30:	2905                	addiw	s2,s2,1
     f32:	fd6911e3          	bne	s2,s6,ef4 <bigdir+0x4c>
  unlink("bd");
     f36:	00005517          	auipc	a0,0x5
     f3a:	85250513          	addi	a0,a0,-1966 # 5788 <malloc+0x87a>
     f3e:	35d030ef          	jal	ra,4a9a <unlink>
    name[0] = 'x';
     f42:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f46:	1f400a13          	li	s4,500
    name[0] = 'x';
     f4a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f4e:	41f4d79b          	sraiw	a5,s1,0x1f
     f52:	01a7d71b          	srliw	a4,a5,0x1a
     f56:	009707bb          	addw	a5,a4,s1
     f5a:	4067d69b          	sraiw	a3,a5,0x6
     f5e:	0306869b          	addiw	a3,a3,48
     f62:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f66:	03f7f793          	andi	a5,a5,63
     f6a:	9f99                	subw	a5,a5,a4
     f6c:	0307879b          	addiw	a5,a5,48
     f70:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f74:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f78:	fb040513          	addi	a0,s0,-80
     f7c:	31f030ef          	jal	ra,4a9a <unlink>
     f80:	e529                	bnez	a0,fca <bigdir+0x122>
  for(i = 0; i < N; i++){
     f82:	2485                	addiw	s1,s1,1
     f84:	fd4493e3          	bne	s1,s4,f4a <bigdir+0xa2>
}
     f88:	60a6                	ld	ra,72(sp)
     f8a:	6406                	ld	s0,64(sp)
     f8c:	74e2                	ld	s1,56(sp)
     f8e:	7942                	ld	s2,48(sp)
     f90:	79a2                	ld	s3,40(sp)
     f92:	7a02                	ld	s4,32(sp)
     f94:	6ae2                	ld	s5,24(sp)
     f96:	6b42                	ld	s6,16(sp)
     f98:	6161                	addi	sp,sp,80
     f9a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f9c:	85ce                	mv	a1,s3
     f9e:	00004517          	auipc	a0,0x4
     fa2:	7f250513          	addi	a0,a0,2034 # 5790 <malloc+0x882>
     fa6:	6af030ef          	jal	ra,4e54 <printf>
    exit(1);
     faa:	4505                	li	a0,1
     fac:	29f030ef          	jal	ra,4a4a <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fb0:	fb040693          	addi	a3,s0,-80
     fb4:	864a                	mv	a2,s2
     fb6:	85ce                	mv	a1,s3
     fb8:	00004517          	auipc	a0,0x4
     fbc:	7f850513          	addi	a0,a0,2040 # 57b0 <malloc+0x8a2>
     fc0:	695030ef          	jal	ra,4e54 <printf>
      exit(1);
     fc4:	4505                	li	a0,1
     fc6:	285030ef          	jal	ra,4a4a <exit>
      printf("%s: bigdir unlink failed", s);
     fca:	85ce                	mv	a1,s3
     fcc:	00005517          	auipc	a0,0x5
     fd0:	80c50513          	addi	a0,a0,-2036 # 57d8 <malloc+0x8ca>
     fd4:	681030ef          	jal	ra,4e54 <printf>
      exit(1);
     fd8:	4505                	li	a0,1
     fda:	271030ef          	jal	ra,4a4a <exit>

0000000000000fde <pgbug>:
{
     fde:	7179                	addi	sp,sp,-48
     fe0:	f406                	sd	ra,40(sp)
     fe2:	f022                	sd	s0,32(sp)
     fe4:	ec26                	sd	s1,24(sp)
     fe6:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fe8:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fec:	00007497          	auipc	s1,0x7
     ff0:	01448493          	addi	s1,s1,20 # 8000 <big>
     ff4:	fd840593          	addi	a1,s0,-40
     ff8:	6088                	ld	a0,0(s1)
     ffa:	289030ef          	jal	ra,4a82 <exec>
  pipe(big);
     ffe:	6088                	ld	a0,0(s1)
    1000:	25b030ef          	jal	ra,4a5a <pipe>
  exit(0);
    1004:	4501                	li	a0,0
    1006:	245030ef          	jal	ra,4a4a <exit>

000000000000100a <badarg>:
{
    100a:	7139                	addi	sp,sp,-64
    100c:	fc06                	sd	ra,56(sp)
    100e:	f822                	sd	s0,48(sp)
    1010:	f426                	sd	s1,40(sp)
    1012:	f04a                	sd	s2,32(sp)
    1014:	ec4e                	sd	s3,24(sp)
    1016:	0080                	addi	s0,sp,64
    1018:	64b1                	lui	s1,0xc
    101a:	35048493          	addi	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    101e:	597d                	li	s2,-1
    1020:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1024:	00004997          	auipc	s3,0x4
    1028:	02498993          	addi	s3,s3,36 # 5048 <malloc+0x13a>
    argv[0] = (char*)0xffffffff;
    102c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1030:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1034:	fc040593          	addi	a1,s0,-64
    1038:	854e                	mv	a0,s3
    103a:	249030ef          	jal	ra,4a82 <exec>
  for(int i = 0; i < 50000; i++){
    103e:	34fd                	addiw	s1,s1,-1
    1040:	f4f5                	bnez	s1,102c <badarg+0x22>
  exit(0);
    1042:	4501                	li	a0,0
    1044:	207030ef          	jal	ra,4a4a <exit>

0000000000001048 <copyinstr2>:
{
    1048:	7155                	addi	sp,sp,-208
    104a:	e586                	sd	ra,200(sp)
    104c:	e1a2                	sd	s0,192(sp)
    104e:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1050:	f6840793          	addi	a5,s0,-152
    1054:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1058:	07800713          	li	a4,120
    105c:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1060:	0785                	addi	a5,a5,1
    1062:	fed79de3          	bne	a5,a3,105c <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1066:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    106a:	f6840513          	addi	a0,s0,-152
    106e:	22d030ef          	jal	ra,4a9a <unlink>
  if(ret != -1){
    1072:	57fd                	li	a5,-1
    1074:	0cf51263          	bne	a0,a5,1138 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1078:	20100593          	li	a1,513
    107c:	f6840513          	addi	a0,s0,-152
    1080:	20b030ef          	jal	ra,4a8a <open>
  if(fd != -1){
    1084:	57fd                	li	a5,-1
    1086:	0cf51563          	bne	a0,a5,1150 <copyinstr2+0x108>
  ret = link(b, b);
    108a:	f6840593          	addi	a1,s0,-152
    108e:	852e                	mv	a0,a1
    1090:	21b030ef          	jal	ra,4aaa <link>
  if(ret != -1){
    1094:	57fd                	li	a5,-1
    1096:	0cf51963          	bne	a0,a5,1168 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    109a:	00006797          	auipc	a5,0x6
    109e:	88e78793          	addi	a5,a5,-1906 # 6928 <malloc+0x1a1a>
    10a2:	f4f43c23          	sd	a5,-168(s0)
    10a6:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10aa:	f5840593          	addi	a1,s0,-168
    10ae:	f6840513          	addi	a0,s0,-152
    10b2:	1d1030ef          	jal	ra,4a82 <exec>
  if(ret != -1){
    10b6:	57fd                	li	a5,-1
    10b8:	0cf51563          	bne	a0,a5,1182 <copyinstr2+0x13a>
  int pid = fork();
    10bc:	187030ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    10c0:	0c054d63          	bltz	a0,119a <copyinstr2+0x152>
  if(pid == 0){
    10c4:	0e051863          	bnez	a0,11b4 <copyinstr2+0x16c>
    10c8:	00007797          	auipc	a5,0x7
    10cc:	49878793          	addi	a5,a5,1176 # 8560 <big.1779>
    10d0:	00008697          	auipc	a3,0x8
    10d4:	49068693          	addi	a3,a3,1168 # 9560 <big.1779+0x1000>
      big[i] = 'x';
    10d8:	07800713          	li	a4,120
    10dc:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10e0:	0785                	addi	a5,a5,1
    10e2:	fed79de3          	bne	a5,a3,10dc <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10e6:	00008797          	auipc	a5,0x8
    10ea:	46078d23          	sb	zero,1146(a5) # 9560 <big.1779+0x1000>
    char *args2[] = { big, big, big, 0 };
    10ee:	00006797          	auipc	a5,0x6
    10f2:	29278793          	addi	a5,a5,658 # 7380 <malloc+0x2472>
    10f6:	6fb0                	ld	a2,88(a5)
    10f8:	73b4                	ld	a3,96(a5)
    10fa:	77b8                	ld	a4,104(a5)
    10fc:	7bbc                	ld	a5,112(a5)
    10fe:	f2c43823          	sd	a2,-208(s0)
    1102:	f2d43c23          	sd	a3,-200(s0)
    1106:	f4e43023          	sd	a4,-192(s0)
    110a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    110e:	f3040593          	addi	a1,s0,-208
    1112:	00004517          	auipc	a0,0x4
    1116:	f3650513          	addi	a0,a0,-202 # 5048 <malloc+0x13a>
    111a:	169030ef          	jal	ra,4a82 <exec>
    if(ret != -1){
    111e:	57fd                	li	a5,-1
    1120:	08f50663          	beq	a0,a5,11ac <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1124:	55fd                	li	a1,-1
    1126:	00004517          	auipc	a0,0x4
    112a:	75a50513          	addi	a0,a0,1882 # 5880 <malloc+0x972>
    112e:	527030ef          	jal	ra,4e54 <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	117030ef          	jal	ra,4a4a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1138:	862a                	mv	a2,a0
    113a:	f6840593          	addi	a1,s0,-152
    113e:	00004517          	auipc	a0,0x4
    1142:	6ba50513          	addi	a0,a0,1722 # 57f8 <malloc+0x8ea>
    1146:	50f030ef          	jal	ra,4e54 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	0ff030ef          	jal	ra,4a4a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1150:	862a                	mv	a2,a0
    1152:	f6840593          	addi	a1,s0,-152
    1156:	00004517          	auipc	a0,0x4
    115a:	6c250513          	addi	a0,a0,1730 # 5818 <malloc+0x90a>
    115e:	4f7030ef          	jal	ra,4e54 <printf>
    exit(1);
    1162:	4505                	li	a0,1
    1164:	0e7030ef          	jal	ra,4a4a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1168:	86aa                	mv	a3,a0
    116a:	f6840613          	addi	a2,s0,-152
    116e:	85b2                	mv	a1,a2
    1170:	00004517          	auipc	a0,0x4
    1174:	6c850513          	addi	a0,a0,1736 # 5838 <malloc+0x92a>
    1178:	4dd030ef          	jal	ra,4e54 <printf>
    exit(1);
    117c:	4505                	li	a0,1
    117e:	0cd030ef          	jal	ra,4a4a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1182:	567d                	li	a2,-1
    1184:	f6840593          	addi	a1,s0,-152
    1188:	00004517          	auipc	a0,0x4
    118c:	6d850513          	addi	a0,a0,1752 # 5860 <malloc+0x952>
    1190:	4c5030ef          	jal	ra,4e54 <printf>
    exit(1);
    1194:	4505                	li	a0,1
    1196:	0b5030ef          	jal	ra,4a4a <exit>
    printf("fork failed\n");
    119a:	00006517          	auipc	a0,0x6
    119e:	c8e50513          	addi	a0,a0,-882 # 6e28 <malloc+0x1f1a>
    11a2:	4b3030ef          	jal	ra,4e54 <printf>
    exit(1);
    11a6:	4505                	li	a0,1
    11a8:	0a3030ef          	jal	ra,4a4a <exit>
    exit(747); // OK
    11ac:	2eb00513          	li	a0,747
    11b0:	09b030ef          	jal	ra,4a4a <exit>
  int st = 0;
    11b4:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b8:	f5440513          	addi	a0,s0,-172
    11bc:	097030ef          	jal	ra,4a52 <wait>
  if(st != 747){
    11c0:	f5442703          	lw	a4,-172(s0)
    11c4:	2eb00793          	li	a5,747
    11c8:	00f71663          	bne	a4,a5,11d4 <copyinstr2+0x18c>
}
    11cc:	60ae                	ld	ra,200(sp)
    11ce:	640e                	ld	s0,192(sp)
    11d0:	6169                	addi	sp,sp,208
    11d2:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11d4:	00004517          	auipc	a0,0x4
    11d8:	6d450513          	addi	a0,a0,1748 # 58a8 <malloc+0x99a>
    11dc:	479030ef          	jal	ra,4e54 <printf>
    exit(1);
    11e0:	4505                	li	a0,1
    11e2:	069030ef          	jal	ra,4a4a <exit>

00000000000011e6 <truncate3>:
{
    11e6:	7159                	addi	sp,sp,-112
    11e8:	f486                	sd	ra,104(sp)
    11ea:	f0a2                	sd	s0,96(sp)
    11ec:	eca6                	sd	s1,88(sp)
    11ee:	e8ca                	sd	s2,80(sp)
    11f0:	e4ce                	sd	s3,72(sp)
    11f2:	e0d2                	sd	s4,64(sp)
    11f4:	fc56                	sd	s5,56(sp)
    11f6:	1880                	addi	s0,sp,112
    11f8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11fa:	60100593          	li	a1,1537
    11fe:	00004517          	auipc	a0,0x4
    1202:	ea250513          	addi	a0,a0,-350 # 50a0 <malloc+0x192>
    1206:	085030ef          	jal	ra,4a8a <open>
    120a:	069030ef          	jal	ra,4a72 <close>
  pid = fork();
    120e:	035030ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    1212:	06054263          	bltz	a0,1276 <truncate3+0x90>
  if(pid == 0){
    1216:	ed59                	bnez	a0,12b4 <truncate3+0xce>
    1218:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    121c:	00004a17          	auipc	s4,0x4
    1220:	e84a0a13          	addi	s4,s4,-380 # 50a0 <malloc+0x192>
      int n = write(fd, "1234567890", 10);
    1224:	00004a97          	auipc	s5,0x4
    1228:	6e4a8a93          	addi	s5,s5,1764 # 5908 <malloc+0x9fa>
      int fd = open("truncfile", O_WRONLY);
    122c:	4585                	li	a1,1
    122e:	8552                	mv	a0,s4
    1230:	05b030ef          	jal	ra,4a8a <open>
    1234:	84aa                	mv	s1,a0
      if(fd < 0){
    1236:	04054a63          	bltz	a0,128a <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    123a:	4629                	li	a2,10
    123c:	85d6                	mv	a1,s5
    123e:	02d030ef          	jal	ra,4a6a <write>
      if(n != 10){
    1242:	47a9                	li	a5,10
    1244:	04f51d63          	bne	a0,a5,129e <truncate3+0xb8>
      close(fd);
    1248:	8526                	mv	a0,s1
    124a:	029030ef          	jal	ra,4a72 <close>
      fd = open("truncfile", O_RDONLY);
    124e:	4581                	li	a1,0
    1250:	8552                	mv	a0,s4
    1252:	039030ef          	jal	ra,4a8a <open>
    1256:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1258:	02000613          	li	a2,32
    125c:	f9840593          	addi	a1,s0,-104
    1260:	003030ef          	jal	ra,4a62 <read>
      close(fd);
    1264:	8526                	mv	a0,s1
    1266:	00d030ef          	jal	ra,4a72 <close>
    for(int i = 0; i < 100; i++){
    126a:	39fd                	addiw	s3,s3,-1
    126c:	fc0990e3          	bnez	s3,122c <truncate3+0x46>
    exit(0);
    1270:	4501                	li	a0,0
    1272:	7d8030ef          	jal	ra,4a4a <exit>
    printf("%s: fork failed\n", s);
    1276:	85ca                	mv	a1,s2
    1278:	00004517          	auipc	a0,0x4
    127c:	66050513          	addi	a0,a0,1632 # 58d8 <malloc+0x9ca>
    1280:	3d5030ef          	jal	ra,4e54 <printf>
    exit(1);
    1284:	4505                	li	a0,1
    1286:	7c4030ef          	jal	ra,4a4a <exit>
        printf("%s: open failed\n", s);
    128a:	85ca                	mv	a1,s2
    128c:	00004517          	auipc	a0,0x4
    1290:	66450513          	addi	a0,a0,1636 # 58f0 <malloc+0x9e2>
    1294:	3c1030ef          	jal	ra,4e54 <printf>
        exit(1);
    1298:	4505                	li	a0,1
    129a:	7b0030ef          	jal	ra,4a4a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129e:	862a                	mv	a2,a0
    12a0:	85ca                	mv	a1,s2
    12a2:	00004517          	auipc	a0,0x4
    12a6:	67650513          	addi	a0,a0,1654 # 5918 <malloc+0xa0a>
    12aa:	3ab030ef          	jal	ra,4e54 <printf>
        exit(1);
    12ae:	4505                	li	a0,1
    12b0:	79a030ef          	jal	ra,4a4a <exit>
    12b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12b8:	00004a17          	auipc	s4,0x4
    12bc:	de8a0a13          	addi	s4,s4,-536 # 50a0 <malloc+0x192>
    int n = write(fd, "xxx", 3);
    12c0:	00004a97          	auipc	s5,0x4
    12c4:	678a8a93          	addi	s5,s5,1656 # 5938 <malloc+0xa2a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c8:	60100593          	li	a1,1537
    12cc:	8552                	mv	a0,s4
    12ce:	7bc030ef          	jal	ra,4a8a <open>
    12d2:	84aa                	mv	s1,a0
    if(fd < 0){
    12d4:	02054d63          	bltz	a0,130e <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12d8:	460d                	li	a2,3
    12da:	85d6                	mv	a1,s5
    12dc:	78e030ef          	jal	ra,4a6a <write>
    if(n != 3){
    12e0:	478d                	li	a5,3
    12e2:	04f51063          	bne	a0,a5,1322 <truncate3+0x13c>
    close(fd);
    12e6:	8526                	mv	a0,s1
    12e8:	78a030ef          	jal	ra,4a72 <close>
  for(int i = 0; i < 150; i++){
    12ec:	39fd                	addiw	s3,s3,-1
    12ee:	fc099de3          	bnez	s3,12c8 <truncate3+0xe2>
  wait(&xstatus);
    12f2:	fbc40513          	addi	a0,s0,-68
    12f6:	75c030ef          	jal	ra,4a52 <wait>
  unlink("truncfile");
    12fa:	00004517          	auipc	a0,0x4
    12fe:	da650513          	addi	a0,a0,-602 # 50a0 <malloc+0x192>
    1302:	798030ef          	jal	ra,4a9a <unlink>
  exit(xstatus);
    1306:	fbc42503          	lw	a0,-68(s0)
    130a:	740030ef          	jal	ra,4a4a <exit>
      printf("%s: open failed\n", s);
    130e:	85ca                	mv	a1,s2
    1310:	00004517          	auipc	a0,0x4
    1314:	5e050513          	addi	a0,a0,1504 # 58f0 <malloc+0x9e2>
    1318:	33d030ef          	jal	ra,4e54 <printf>
      exit(1);
    131c:	4505                	li	a0,1
    131e:	72c030ef          	jal	ra,4a4a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1322:	862a                	mv	a2,a0
    1324:	85ca                	mv	a1,s2
    1326:	00004517          	auipc	a0,0x4
    132a:	61a50513          	addi	a0,a0,1562 # 5940 <malloc+0xa32>
    132e:	327030ef          	jal	ra,4e54 <printf>
      exit(1);
    1332:	4505                	li	a0,1
    1334:	716030ef          	jal	ra,4a4a <exit>

0000000000001338 <exectest>:
{
    1338:	715d                	addi	sp,sp,-80
    133a:	e486                	sd	ra,72(sp)
    133c:	e0a2                	sd	s0,64(sp)
    133e:	fc26                	sd	s1,56(sp)
    1340:	f84a                	sd	s2,48(sp)
    1342:	0880                	addi	s0,sp,80
    1344:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1346:	00004797          	auipc	a5,0x4
    134a:	d0278793          	addi	a5,a5,-766 # 5048 <malloc+0x13a>
    134e:	fcf43023          	sd	a5,-64(s0)
    1352:	00004797          	auipc	a5,0x4
    1356:	60e78793          	addi	a5,a5,1550 # 5960 <malloc+0xa52>
    135a:	fcf43423          	sd	a5,-56(s0)
    135e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1362:	00004517          	auipc	a0,0x4
    1366:	60650513          	addi	a0,a0,1542 # 5968 <malloc+0xa5a>
    136a:	730030ef          	jal	ra,4a9a <unlink>
  pid = fork();
    136e:	6d4030ef          	jal	ra,4a42 <fork>
  if(pid < 0) {
    1372:	02054e63          	bltz	a0,13ae <exectest+0x76>
    1376:	84aa                	mv	s1,a0
  if(pid == 0) {
    1378:	e92d                	bnez	a0,13ea <exectest+0xb2>
    close(1);
    137a:	4505                	li	a0,1
    137c:	6f6030ef          	jal	ra,4a72 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1380:	20100593          	li	a1,513
    1384:	00004517          	auipc	a0,0x4
    1388:	5e450513          	addi	a0,a0,1508 # 5968 <malloc+0xa5a>
    138c:	6fe030ef          	jal	ra,4a8a <open>
    if(fd < 0) {
    1390:	02054963          	bltz	a0,13c2 <exectest+0x8a>
    if(fd != 1) {
    1394:	4785                	li	a5,1
    1396:	04f50063          	beq	a0,a5,13d6 <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    139a:	85ca                	mv	a1,s2
    139c:	00004517          	auipc	a0,0x4
    13a0:	5ec50513          	addi	a0,a0,1516 # 5988 <malloc+0xa7a>
    13a4:	2b1030ef          	jal	ra,4e54 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	6a0030ef          	jal	ra,4a4a <exit>
     printf("%s: fork failed\n", s);
    13ae:	85ca                	mv	a1,s2
    13b0:	00004517          	auipc	a0,0x4
    13b4:	52850513          	addi	a0,a0,1320 # 58d8 <malloc+0x9ca>
    13b8:	29d030ef          	jal	ra,4e54 <printf>
     exit(1);
    13bc:	4505                	li	a0,1
    13be:	68c030ef          	jal	ra,4a4a <exit>
      printf("%s: create failed\n", s);
    13c2:	85ca                	mv	a1,s2
    13c4:	00004517          	auipc	a0,0x4
    13c8:	5ac50513          	addi	a0,a0,1452 # 5970 <malloc+0xa62>
    13cc:	289030ef          	jal	ra,4e54 <printf>
      exit(1);
    13d0:	4505                	li	a0,1
    13d2:	678030ef          	jal	ra,4a4a <exit>
    if(exec("echo", echoargv) < 0){
    13d6:	fc040593          	addi	a1,s0,-64
    13da:	00004517          	auipc	a0,0x4
    13de:	c6e50513          	addi	a0,a0,-914 # 5048 <malloc+0x13a>
    13e2:	6a0030ef          	jal	ra,4a82 <exec>
    13e6:	00054d63          	bltz	a0,1400 <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13ea:	fdc40513          	addi	a0,s0,-36
    13ee:	664030ef          	jal	ra,4a52 <wait>
    13f2:	02951163          	bne	a0,s1,1414 <exectest+0xdc>
  if(xstatus != 0)
    13f6:	fdc42503          	lw	a0,-36(s0)
    13fa:	c50d                	beqz	a0,1424 <exectest+0xec>
    exit(xstatus);
    13fc:	64e030ef          	jal	ra,4a4a <exit>
      printf("%s: exec echo failed\n", s);
    1400:	85ca                	mv	a1,s2
    1402:	00004517          	auipc	a0,0x4
    1406:	59650513          	addi	a0,a0,1430 # 5998 <malloc+0xa8a>
    140a:	24b030ef          	jal	ra,4e54 <printf>
      exit(1);
    140e:	4505                	li	a0,1
    1410:	63a030ef          	jal	ra,4a4a <exit>
    printf("%s: wait failed!\n", s);
    1414:	85ca                	mv	a1,s2
    1416:	00004517          	auipc	a0,0x4
    141a:	59a50513          	addi	a0,a0,1434 # 59b0 <malloc+0xaa2>
    141e:	237030ef          	jal	ra,4e54 <printf>
    1422:	bfd1                	j	13f6 <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    1424:	4581                	li	a1,0
    1426:	00004517          	auipc	a0,0x4
    142a:	54250513          	addi	a0,a0,1346 # 5968 <malloc+0xa5a>
    142e:	65c030ef          	jal	ra,4a8a <open>
  if(fd < 0) {
    1432:	02054463          	bltz	a0,145a <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    1436:	4609                	li	a2,2
    1438:	fb840593          	addi	a1,s0,-72
    143c:	626030ef          	jal	ra,4a62 <read>
    1440:	4789                	li	a5,2
    1442:	02f50663          	beq	a0,a5,146e <exectest+0x136>
    printf("%s: read failed\n", s);
    1446:	85ca                	mv	a1,s2
    1448:	00004517          	auipc	a0,0x4
    144c:	fd050513          	addi	a0,a0,-48 # 5418 <malloc+0x50a>
    1450:	205030ef          	jal	ra,4e54 <printf>
    exit(1);
    1454:	4505                	li	a0,1
    1456:	5f4030ef          	jal	ra,4a4a <exit>
    printf("%s: open failed\n", s);
    145a:	85ca                	mv	a1,s2
    145c:	00004517          	auipc	a0,0x4
    1460:	49450513          	addi	a0,a0,1172 # 58f0 <malloc+0x9e2>
    1464:	1f1030ef          	jal	ra,4e54 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	5e0030ef          	jal	ra,4a4a <exit>
  unlink("echo-ok");
    146e:	00004517          	auipc	a0,0x4
    1472:	4fa50513          	addi	a0,a0,1274 # 5968 <malloc+0xa5a>
    1476:	624030ef          	jal	ra,4a9a <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    147a:	fb844703          	lbu	a4,-72(s0)
    147e:	04f00793          	li	a5,79
    1482:	00f71863          	bne	a4,a5,1492 <exectest+0x15a>
    1486:	fb944703          	lbu	a4,-71(s0)
    148a:	04b00793          	li	a5,75
    148e:	00f70c63          	beq	a4,a5,14a6 <exectest+0x16e>
    printf("%s: wrong output\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00004517          	auipc	a0,0x4
    1498:	53450513          	addi	a0,a0,1332 # 59c8 <malloc+0xaba>
    149c:	1b9030ef          	jal	ra,4e54 <printf>
    exit(1);
    14a0:	4505                	li	a0,1
    14a2:	5a8030ef          	jal	ra,4a4a <exit>
    exit(0);
    14a6:	4501                	li	a0,0
    14a8:	5a2030ef          	jal	ra,4a4a <exit>

00000000000014ac <pipe1>:
{
    14ac:	711d                	addi	sp,sp,-96
    14ae:	ec86                	sd	ra,88(sp)
    14b0:	e8a2                	sd	s0,80(sp)
    14b2:	e4a6                	sd	s1,72(sp)
    14b4:	e0ca                	sd	s2,64(sp)
    14b6:	fc4e                	sd	s3,56(sp)
    14b8:	f852                	sd	s4,48(sp)
    14ba:	f456                	sd	s5,40(sp)
    14bc:	f05a                	sd	s6,32(sp)
    14be:	ec5e                	sd	s7,24(sp)
    14c0:	1080                	addi	s0,sp,96
    14c2:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14c4:	fa840513          	addi	a0,s0,-88
    14c8:	592030ef          	jal	ra,4a5a <pipe>
    14cc:	e535                	bnez	a0,1538 <pipe1+0x8c>
    14ce:	84aa                	mv	s1,a0
  pid = fork();
    14d0:	572030ef          	jal	ra,4a42 <fork>
    14d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d6:	c93d                	beqz	a0,154c <pipe1+0xa0>
  } else if(pid > 0){
    14d8:	14a05163          	blez	a0,161a <pipe1+0x16e>
    close(fds[1]);
    14dc:	fac42503          	lw	a0,-84(s0)
    14e0:	592030ef          	jal	ra,4a72 <close>
    total = 0;
    14e4:	8a26                	mv	s4,s1
    cc = 1;
    14e6:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14e8:	0000aa97          	auipc	s5,0xa
    14ec:	790a8a93          	addi	s5,s5,1936 # bc78 <buf>
      if(cc > sizeof(buf))
    14f0:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    14f2:	864e                	mv	a2,s3
    14f4:	85d6                	mv	a1,s5
    14f6:	fa842503          	lw	a0,-88(s0)
    14fa:	568030ef          	jal	ra,4a62 <read>
    14fe:	0ea05263          	blez	a0,15e2 <pipe1+0x136>
      for(i = 0; i < n; i++){
    1502:	0000a717          	auipc	a4,0xa
    1506:	77670713          	addi	a4,a4,1910 # bc78 <buf>
    150a:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    150e:	00074683          	lbu	a3,0(a4)
    1512:	0ff4f793          	andi	a5,s1,255
    1516:	2485                	addiw	s1,s1,1
    1518:	0af69363          	bne	a3,a5,15be <pipe1+0x112>
      for(i = 0; i < n; i++){
    151c:	0705                	addi	a4,a4,1
    151e:	fec498e3          	bne	s1,a2,150e <pipe1+0x62>
      total += n;
    1522:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1526:	0019979b          	slliw	a5,s3,0x1
    152a:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    152e:	013b7363          	bgeu	s6,s3,1534 <pipe1+0x88>
        cc = sizeof(buf);
    1532:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1534:	84b2                	mv	s1,a2
    1536:	bf75                	j	14f2 <pipe1+0x46>
    printf("%s: pipe() failed\n", s);
    1538:	85ca                	mv	a1,s2
    153a:	00004517          	auipc	a0,0x4
    153e:	4a650513          	addi	a0,a0,1190 # 59e0 <malloc+0xad2>
    1542:	113030ef          	jal	ra,4e54 <printf>
    exit(1);
    1546:	4505                	li	a0,1
    1548:	502030ef          	jal	ra,4a4a <exit>
    close(fds[0]);
    154c:	fa842503          	lw	a0,-88(s0)
    1550:	522030ef          	jal	ra,4a72 <close>
    for(n = 0; n < N; n++){
    1554:	0000ab17          	auipc	s6,0xa
    1558:	724b0b13          	addi	s6,s6,1828 # bc78 <buf>
    155c:	416004bb          	negw	s1,s6
    1560:	0ff4f493          	andi	s1,s1,255
    1564:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1568:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    156a:	6a85                	lui	s5,0x1
    156c:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xf5>
{
    1570:	87da                	mv	a5,s6
        buf[i] = seq++;
    1572:	0097873b          	addw	a4,a5,s1
    1576:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    157a:	0785                	addi	a5,a5,1
    157c:	fef99be3          	bne	s3,a5,1572 <pipe1+0xc6>
    1580:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1584:	40900613          	li	a2,1033
    1588:	85de                	mv	a1,s7
    158a:	fac42503          	lw	a0,-84(s0)
    158e:	4dc030ef          	jal	ra,4a6a <write>
    1592:	40900793          	li	a5,1033
    1596:	00f51a63          	bne	a0,a5,15aa <pipe1+0xfe>
    for(n = 0; n < N; n++){
    159a:	24a5                	addiw	s1,s1,9
    159c:	0ff4f493          	andi	s1,s1,255
    15a0:	fd5a18e3          	bne	s4,s5,1570 <pipe1+0xc4>
    exit(0);
    15a4:	4501                	li	a0,0
    15a6:	4a4030ef          	jal	ra,4a4a <exit>
        printf("%s: pipe1 oops 1\n", s);
    15aa:	85ca                	mv	a1,s2
    15ac:	00004517          	auipc	a0,0x4
    15b0:	44c50513          	addi	a0,a0,1100 # 59f8 <malloc+0xaea>
    15b4:	0a1030ef          	jal	ra,4e54 <printf>
        exit(1);
    15b8:	4505                	li	a0,1
    15ba:	490030ef          	jal	ra,4a4a <exit>
          printf("%s: pipe1 oops 2\n", s);
    15be:	85ca                	mv	a1,s2
    15c0:	00004517          	auipc	a0,0x4
    15c4:	45050513          	addi	a0,a0,1104 # 5a10 <malloc+0xb02>
    15c8:	08d030ef          	jal	ra,4e54 <printf>
}
    15cc:	60e6                	ld	ra,88(sp)
    15ce:	6446                	ld	s0,80(sp)
    15d0:	64a6                	ld	s1,72(sp)
    15d2:	6906                	ld	s2,64(sp)
    15d4:	79e2                	ld	s3,56(sp)
    15d6:	7a42                	ld	s4,48(sp)
    15d8:	7aa2                	ld	s5,40(sp)
    15da:	7b02                	ld	s6,32(sp)
    15dc:	6be2                	ld	s7,24(sp)
    15de:	6125                	addi	sp,sp,96
    15e0:	8082                	ret
    if(total != N * SZ){
    15e2:	6785                	lui	a5,0x1
    15e4:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xf5>
    15e8:	00fa0d63          	beq	s4,a5,1602 <pipe1+0x156>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15ec:	8652                	mv	a2,s4
    15ee:	85ca                	mv	a1,s2
    15f0:	00004517          	auipc	a0,0x4
    15f4:	43850513          	addi	a0,a0,1080 # 5a28 <malloc+0xb1a>
    15f8:	05d030ef          	jal	ra,4e54 <printf>
      exit(1);
    15fc:	4505                	li	a0,1
    15fe:	44c030ef          	jal	ra,4a4a <exit>
    close(fds[0]);
    1602:	fa842503          	lw	a0,-88(s0)
    1606:	46c030ef          	jal	ra,4a72 <close>
    wait(&xstatus);
    160a:	fa440513          	addi	a0,s0,-92
    160e:	444030ef          	jal	ra,4a52 <wait>
    exit(xstatus);
    1612:	fa442503          	lw	a0,-92(s0)
    1616:	434030ef          	jal	ra,4a4a <exit>
    printf("%s: fork() failed\n", s);
    161a:	85ca                	mv	a1,s2
    161c:	00004517          	auipc	a0,0x4
    1620:	42c50513          	addi	a0,a0,1068 # 5a48 <malloc+0xb3a>
    1624:	031030ef          	jal	ra,4e54 <printf>
    exit(1);
    1628:	4505                	li	a0,1
    162a:	420030ef          	jal	ra,4a4a <exit>

000000000000162e <exitwait>:
{
    162e:	7139                	addi	sp,sp,-64
    1630:	fc06                	sd	ra,56(sp)
    1632:	f822                	sd	s0,48(sp)
    1634:	f426                	sd	s1,40(sp)
    1636:	f04a                	sd	s2,32(sp)
    1638:	ec4e                	sd	s3,24(sp)
    163a:	e852                	sd	s4,16(sp)
    163c:	0080                	addi	s0,sp,64
    163e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1640:	4901                	li	s2,0
    1642:	06400993          	li	s3,100
    pid = fork();
    1646:	3fc030ef          	jal	ra,4a42 <fork>
    164a:	84aa                	mv	s1,a0
    if(pid < 0){
    164c:	02054863          	bltz	a0,167c <exitwait+0x4e>
    if(pid){
    1650:	c525                	beqz	a0,16b8 <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1652:	fcc40513          	addi	a0,s0,-52
    1656:	3fc030ef          	jal	ra,4a52 <wait>
    165a:	02951b63          	bne	a0,s1,1690 <exitwait+0x62>
      if(i != xstate) {
    165e:	fcc42783          	lw	a5,-52(s0)
    1662:	05279163          	bne	a5,s2,16a4 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    1666:	2905                	addiw	s2,s2,1
    1668:	fd391fe3          	bne	s2,s3,1646 <exitwait+0x18>
}
    166c:	70e2                	ld	ra,56(sp)
    166e:	7442                	ld	s0,48(sp)
    1670:	74a2                	ld	s1,40(sp)
    1672:	7902                	ld	s2,32(sp)
    1674:	69e2                	ld	s3,24(sp)
    1676:	6a42                	ld	s4,16(sp)
    1678:	6121                	addi	sp,sp,64
    167a:	8082                	ret
      printf("%s: fork failed\n", s);
    167c:	85d2                	mv	a1,s4
    167e:	00004517          	auipc	a0,0x4
    1682:	25a50513          	addi	a0,a0,602 # 58d8 <malloc+0x9ca>
    1686:	7ce030ef          	jal	ra,4e54 <printf>
      exit(1);
    168a:	4505                	li	a0,1
    168c:	3be030ef          	jal	ra,4a4a <exit>
        printf("%s: wait wrong pid\n", s);
    1690:	85d2                	mv	a1,s4
    1692:	00004517          	auipc	a0,0x4
    1696:	3ce50513          	addi	a0,a0,974 # 5a60 <malloc+0xb52>
    169a:	7ba030ef          	jal	ra,4e54 <printf>
        exit(1);
    169e:	4505                	li	a0,1
    16a0:	3aa030ef          	jal	ra,4a4a <exit>
        printf("%s: wait wrong exit status\n", s);
    16a4:	85d2                	mv	a1,s4
    16a6:	00004517          	auipc	a0,0x4
    16aa:	3d250513          	addi	a0,a0,978 # 5a78 <malloc+0xb6a>
    16ae:	7a6030ef          	jal	ra,4e54 <printf>
        exit(1);
    16b2:	4505                	li	a0,1
    16b4:	396030ef          	jal	ra,4a4a <exit>
      exit(i);
    16b8:	854a                	mv	a0,s2
    16ba:	390030ef          	jal	ra,4a4a <exit>

00000000000016be <twochildren>:
{
    16be:	1101                	addi	sp,sp,-32
    16c0:	ec06                	sd	ra,24(sp)
    16c2:	e822                	sd	s0,16(sp)
    16c4:	e426                	sd	s1,8(sp)
    16c6:	e04a                	sd	s2,0(sp)
    16c8:	1000                	addi	s0,sp,32
    16ca:	892a                	mv	s2,a0
    16cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    16d0:	372030ef          	jal	ra,4a42 <fork>
    if(pid1 < 0){
    16d4:	02054663          	bltz	a0,1700 <twochildren+0x42>
    if(pid1 == 0){
    16d8:	cd15                	beqz	a0,1714 <twochildren+0x56>
      int pid2 = fork();
    16da:	368030ef          	jal	ra,4a42 <fork>
      if(pid2 < 0){
    16de:	02054d63          	bltz	a0,1718 <twochildren+0x5a>
      if(pid2 == 0){
    16e2:	c529                	beqz	a0,172c <twochildren+0x6e>
        wait(0);
    16e4:	4501                	li	a0,0
    16e6:	36c030ef          	jal	ra,4a52 <wait>
        wait(0);
    16ea:	4501                	li	a0,0
    16ec:	366030ef          	jal	ra,4a52 <wait>
  for(int i = 0; i < 1000; i++){
    16f0:	34fd                	addiw	s1,s1,-1
    16f2:	fcf9                	bnez	s1,16d0 <twochildren+0x12>
}
    16f4:	60e2                	ld	ra,24(sp)
    16f6:	6442                	ld	s0,16(sp)
    16f8:	64a2                	ld	s1,8(sp)
    16fa:	6902                	ld	s2,0(sp)
    16fc:	6105                	addi	sp,sp,32
    16fe:	8082                	ret
      printf("%s: fork failed\n", s);
    1700:	85ca                	mv	a1,s2
    1702:	00004517          	auipc	a0,0x4
    1706:	1d650513          	addi	a0,a0,470 # 58d8 <malloc+0x9ca>
    170a:	74a030ef          	jal	ra,4e54 <printf>
      exit(1);
    170e:	4505                	li	a0,1
    1710:	33a030ef          	jal	ra,4a4a <exit>
      exit(0);
    1714:	336030ef          	jal	ra,4a4a <exit>
        printf("%s: fork failed\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00004517          	auipc	a0,0x4
    171e:	1be50513          	addi	a0,a0,446 # 58d8 <malloc+0x9ca>
    1722:	732030ef          	jal	ra,4e54 <printf>
        exit(1);
    1726:	4505                	li	a0,1
    1728:	322030ef          	jal	ra,4a4a <exit>
        exit(0);
    172c:	31e030ef          	jal	ra,4a4a <exit>

0000000000001730 <forkfork>:
{
    1730:	7179                	addi	sp,sp,-48
    1732:	f406                	sd	ra,40(sp)
    1734:	f022                	sd	s0,32(sp)
    1736:	ec26                	sd	s1,24(sp)
    1738:	1800                	addi	s0,sp,48
    173a:	84aa                	mv	s1,a0
    int pid = fork();
    173c:	306030ef          	jal	ra,4a42 <fork>
    if(pid < 0){
    1740:	02054b63          	bltz	a0,1776 <forkfork+0x46>
    if(pid == 0){
    1744:	c139                	beqz	a0,178a <forkfork+0x5a>
    int pid = fork();
    1746:	2fc030ef          	jal	ra,4a42 <fork>
    if(pid < 0){
    174a:	02054663          	bltz	a0,1776 <forkfork+0x46>
    if(pid == 0){
    174e:	cd15                	beqz	a0,178a <forkfork+0x5a>
    wait(&xstatus);
    1750:	fdc40513          	addi	a0,s0,-36
    1754:	2fe030ef          	jal	ra,4a52 <wait>
    if(xstatus != 0) {
    1758:	fdc42783          	lw	a5,-36(s0)
    175c:	ebb9                	bnez	a5,17b2 <forkfork+0x82>
    wait(&xstatus);
    175e:	fdc40513          	addi	a0,s0,-36
    1762:	2f0030ef          	jal	ra,4a52 <wait>
    if(xstatus != 0) {
    1766:	fdc42783          	lw	a5,-36(s0)
    176a:	e7a1                	bnez	a5,17b2 <forkfork+0x82>
}
    176c:	70a2                	ld	ra,40(sp)
    176e:	7402                	ld	s0,32(sp)
    1770:	64e2                	ld	s1,24(sp)
    1772:	6145                	addi	sp,sp,48
    1774:	8082                	ret
      printf("%s: fork failed", s);
    1776:	85a6                	mv	a1,s1
    1778:	00004517          	auipc	a0,0x4
    177c:	32050513          	addi	a0,a0,800 # 5a98 <malloc+0xb8a>
    1780:	6d4030ef          	jal	ra,4e54 <printf>
      exit(1);
    1784:	4505                	li	a0,1
    1786:	2c4030ef          	jal	ra,4a4a <exit>
{
    178a:	0c800493          	li	s1,200
        int pid1 = fork();
    178e:	2b4030ef          	jal	ra,4a42 <fork>
        if(pid1 < 0){
    1792:	00054b63          	bltz	a0,17a8 <forkfork+0x78>
        if(pid1 == 0){
    1796:	cd01                	beqz	a0,17ae <forkfork+0x7e>
        wait(0);
    1798:	4501                	li	a0,0
    179a:	2b8030ef          	jal	ra,4a52 <wait>
      for(int j = 0; j < 200; j++){
    179e:	34fd                	addiw	s1,s1,-1
    17a0:	f4fd                	bnez	s1,178e <forkfork+0x5e>
      exit(0);
    17a2:	4501                	li	a0,0
    17a4:	2a6030ef          	jal	ra,4a4a <exit>
          exit(1);
    17a8:	4505                	li	a0,1
    17aa:	2a0030ef          	jal	ra,4a4a <exit>
          exit(0);
    17ae:	29c030ef          	jal	ra,4a4a <exit>
      printf("%s: fork in child failed", s);
    17b2:	85a6                	mv	a1,s1
    17b4:	00004517          	auipc	a0,0x4
    17b8:	2f450513          	addi	a0,a0,756 # 5aa8 <malloc+0xb9a>
    17bc:	698030ef          	jal	ra,4e54 <printf>
      exit(1);
    17c0:	4505                	li	a0,1
    17c2:	288030ef          	jal	ra,4a4a <exit>

00000000000017c6 <reparent2>:
{
    17c6:	1101                	addi	sp,sp,-32
    17c8:	ec06                	sd	ra,24(sp)
    17ca:	e822                	sd	s0,16(sp)
    17cc:	e426                	sd	s1,8(sp)
    17ce:	1000                	addi	s0,sp,32
    17d0:	32000493          	li	s1,800
    int pid1 = fork();
    17d4:	26e030ef          	jal	ra,4a42 <fork>
    if(pid1 < 0){
    17d8:	00054b63          	bltz	a0,17ee <reparent2+0x28>
    if(pid1 == 0){
    17dc:	c115                	beqz	a0,1800 <reparent2+0x3a>
    wait(0);
    17de:	4501                	li	a0,0
    17e0:	272030ef          	jal	ra,4a52 <wait>
  for(int i = 0; i < 800; i++){
    17e4:	34fd                	addiw	s1,s1,-1
    17e6:	f4fd                	bnez	s1,17d4 <reparent2+0xe>
  exit(0);
    17e8:	4501                	li	a0,0
    17ea:	260030ef          	jal	ra,4a4a <exit>
      printf("fork failed\n");
    17ee:	00005517          	auipc	a0,0x5
    17f2:	63a50513          	addi	a0,a0,1594 # 6e28 <malloc+0x1f1a>
    17f6:	65e030ef          	jal	ra,4e54 <printf>
      exit(1);
    17fa:	4505                	li	a0,1
    17fc:	24e030ef          	jal	ra,4a4a <exit>
      fork();
    1800:	242030ef          	jal	ra,4a42 <fork>
      fork();
    1804:	23e030ef          	jal	ra,4a42 <fork>
      exit(0);
    1808:	4501                	li	a0,0
    180a:	240030ef          	jal	ra,4a4a <exit>

000000000000180e <createdelete>:
{
    180e:	7175                	addi	sp,sp,-144
    1810:	e506                	sd	ra,136(sp)
    1812:	e122                	sd	s0,128(sp)
    1814:	fca6                	sd	s1,120(sp)
    1816:	f8ca                	sd	s2,112(sp)
    1818:	f4ce                	sd	s3,104(sp)
    181a:	f0d2                	sd	s4,96(sp)
    181c:	ecd6                	sd	s5,88(sp)
    181e:	e8da                	sd	s6,80(sp)
    1820:	e4de                	sd	s7,72(sp)
    1822:	e0e2                	sd	s8,64(sp)
    1824:	fc66                	sd	s9,56(sp)
    1826:	0900                	addi	s0,sp,144
    1828:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    182a:	4901                	li	s2,0
    182c:	4991                	li	s3,4
    pid = fork();
    182e:	214030ef          	jal	ra,4a42 <fork>
    1832:	84aa                	mv	s1,a0
    if(pid < 0){
    1834:	02054d63          	bltz	a0,186e <createdelete+0x60>
    if(pid == 0){
    1838:	c529                	beqz	a0,1882 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    183a:	2905                	addiw	s2,s2,1
    183c:	ff3919e3          	bne	s2,s3,182e <createdelete+0x20>
    1840:	4491                	li	s1,4
    wait(&xstatus);
    1842:	f7c40513          	addi	a0,s0,-132
    1846:	20c030ef          	jal	ra,4a52 <wait>
    if(xstatus != 0)
    184a:	f7c42903          	lw	s2,-132(s0)
    184e:	0a091e63          	bnez	s2,190a <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1852:	34fd                	addiw	s1,s1,-1
    1854:	f4fd                	bnez	s1,1842 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1856:	f8040123          	sb	zero,-126(s0)
    185a:	03000993          	li	s3,48
    185e:	5a7d                	li	s4,-1
    1860:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1864:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1866:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1868:	07400a93          	li	s5,116
    186c:	a20d                	j	198e <createdelete+0x180>
      printf("%s: fork failed\n", s);
    186e:	85e6                	mv	a1,s9
    1870:	00004517          	auipc	a0,0x4
    1874:	06850513          	addi	a0,a0,104 # 58d8 <malloc+0x9ca>
    1878:	5dc030ef          	jal	ra,4e54 <printf>
      exit(1);
    187c:	4505                	li	a0,1
    187e:	1cc030ef          	jal	ra,4a4a <exit>
      name[0] = 'p' + pi;
    1882:	0709091b          	addiw	s2,s2,112
    1886:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    188a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    188e:	4951                	li	s2,20
    1890:	a831                	j	18ac <createdelete+0x9e>
          printf("%s: create failed\n", s);
    1892:	85e6                	mv	a1,s9
    1894:	00004517          	auipc	a0,0x4
    1898:	0dc50513          	addi	a0,a0,220 # 5970 <malloc+0xa62>
    189c:	5b8030ef          	jal	ra,4e54 <printf>
          exit(1);
    18a0:	4505                	li	a0,1
    18a2:	1a8030ef          	jal	ra,4a4a <exit>
      for(i = 0; i < N; i++){
    18a6:	2485                	addiw	s1,s1,1
    18a8:	05248e63          	beq	s1,s2,1904 <createdelete+0xf6>
        name[1] = '0' + i;
    18ac:	0304879b          	addiw	a5,s1,48
    18b0:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18b4:	20200593          	li	a1,514
    18b8:	f8040513          	addi	a0,s0,-128
    18bc:	1ce030ef          	jal	ra,4a8a <open>
        if(fd < 0){
    18c0:	fc0549e3          	bltz	a0,1892 <createdelete+0x84>
        close(fd);
    18c4:	1ae030ef          	jal	ra,4a72 <close>
        if(i > 0 && (i % 2 ) == 0){
    18c8:	fc905fe3          	blez	s1,18a6 <createdelete+0x98>
    18cc:	0014f793          	andi	a5,s1,1
    18d0:	fbf9                	bnez	a5,18a6 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18d2:	01f4d79b          	srliw	a5,s1,0x1f
    18d6:	9fa5                	addw	a5,a5,s1
    18d8:	4017d79b          	sraiw	a5,a5,0x1
    18dc:	0307879b          	addiw	a5,a5,48
    18e0:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18e4:	f8040513          	addi	a0,s0,-128
    18e8:	1b2030ef          	jal	ra,4a9a <unlink>
    18ec:	fa055de3          	bgez	a0,18a6 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18f0:	85e6                	mv	a1,s9
    18f2:	00004517          	auipc	a0,0x4
    18f6:	1d650513          	addi	a0,a0,470 # 5ac8 <malloc+0xbba>
    18fa:	55a030ef          	jal	ra,4e54 <printf>
            exit(1);
    18fe:	4505                	li	a0,1
    1900:	14a030ef          	jal	ra,4a4a <exit>
      exit(0);
    1904:	4501                	li	a0,0
    1906:	144030ef          	jal	ra,4a4a <exit>
      exit(1);
    190a:	4505                	li	a0,1
    190c:	13e030ef          	jal	ra,4a4a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1910:	f8040613          	addi	a2,s0,-128
    1914:	85e6                	mv	a1,s9
    1916:	00004517          	auipc	a0,0x4
    191a:	1ca50513          	addi	a0,a0,458 # 5ae0 <malloc+0xbd2>
    191e:	536030ef          	jal	ra,4e54 <printf>
        exit(1);
    1922:	4505                	li	a0,1
    1924:	126030ef          	jal	ra,4a4a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1928:	034b7d63          	bgeu	s6,s4,1962 <createdelete+0x154>
      if(fd >= 0)
    192c:	02055863          	bgez	a0,195c <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1930:	2485                	addiw	s1,s1,1
    1932:	0ff4f493          	andi	s1,s1,255
    1936:	05548463          	beq	s1,s5,197e <createdelete+0x170>
      name[0] = 'p' + pi;
    193a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    193e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1942:	4581                	li	a1,0
    1944:	f8040513          	addi	a0,s0,-128
    1948:	142030ef          	jal	ra,4a8a <open>
      if((i == 0 || i >= N/2) && fd < 0){
    194c:	00090463          	beqz	s2,1954 <createdelete+0x146>
    1950:	fd2bdce3          	bge	s7,s2,1928 <createdelete+0x11a>
    1954:	fa054ee3          	bltz	a0,1910 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1958:	014b7763          	bgeu	s6,s4,1966 <createdelete+0x158>
        close(fd);
    195c:	116030ef          	jal	ra,4a72 <close>
    1960:	bfc1                	j	1930 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1962:	fc0547e3          	bltz	a0,1930 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1966:	f8040613          	addi	a2,s0,-128
    196a:	85e6                	mv	a1,s9
    196c:	00004517          	auipc	a0,0x4
    1970:	19c50513          	addi	a0,a0,412 # 5b08 <malloc+0xbfa>
    1974:	4e0030ef          	jal	ra,4e54 <printf>
        exit(1);
    1978:	4505                	li	a0,1
    197a:	0d0030ef          	jal	ra,4a4a <exit>
  for(i = 0; i < N; i++){
    197e:	2905                	addiw	s2,s2,1
    1980:	2a05                	addiw	s4,s4,1
    1982:	2985                	addiw	s3,s3,1
    1984:	0ff9f993          	andi	s3,s3,255
    1988:	47d1                	li	a5,20
    198a:	02f90863          	beq	s2,a5,19ba <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    198e:	84e2                	mv	s1,s8
    1990:	b76d                	j	193a <createdelete+0x12c>
  for(i = 0; i < N; i++){
    1992:	2905                	addiw	s2,s2,1
    1994:	0ff97913          	andi	s2,s2,255
    1998:	03490a63          	beq	s2,s4,19cc <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    199c:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    199e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19a2:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19a6:	f8040513          	addi	a0,s0,-128
    19aa:	0f0030ef          	jal	ra,4a9a <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19ae:	2485                	addiw	s1,s1,1
    19b0:	0ff4f493          	andi	s1,s1,255
    19b4:	ff3495e3          	bne	s1,s3,199e <createdelete+0x190>
    19b8:	bfe9                	j	1992 <createdelete+0x184>
    19ba:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19be:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19c2:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19c6:	04400a13          	li	s4,68
    19ca:	bfc9                	j	199c <createdelete+0x18e>
}
    19cc:	60aa                	ld	ra,136(sp)
    19ce:	640a                	ld	s0,128(sp)
    19d0:	74e6                	ld	s1,120(sp)
    19d2:	7946                	ld	s2,112(sp)
    19d4:	79a6                	ld	s3,104(sp)
    19d6:	7a06                	ld	s4,96(sp)
    19d8:	6ae6                	ld	s5,88(sp)
    19da:	6b46                	ld	s6,80(sp)
    19dc:	6ba6                	ld	s7,72(sp)
    19de:	6c06                	ld	s8,64(sp)
    19e0:	7ce2                	ld	s9,56(sp)
    19e2:	6149                	addi	sp,sp,144
    19e4:	8082                	ret

00000000000019e6 <linkunlink>:
{
    19e6:	711d                	addi	sp,sp,-96
    19e8:	ec86                	sd	ra,88(sp)
    19ea:	e8a2                	sd	s0,80(sp)
    19ec:	e4a6                	sd	s1,72(sp)
    19ee:	e0ca                	sd	s2,64(sp)
    19f0:	fc4e                	sd	s3,56(sp)
    19f2:	f852                	sd	s4,48(sp)
    19f4:	f456                	sd	s5,40(sp)
    19f6:	f05a                	sd	s6,32(sp)
    19f8:	ec5e                	sd	s7,24(sp)
    19fa:	e862                	sd	s8,16(sp)
    19fc:	e466                	sd	s9,8(sp)
    19fe:	1080                	addi	s0,sp,96
    1a00:	84aa                	mv	s1,a0
  unlink("x");
    1a02:	00003517          	auipc	a0,0x3
    1a06:	6b650513          	addi	a0,a0,1718 # 50b8 <malloc+0x1aa>
    1a0a:	090030ef          	jal	ra,4a9a <unlink>
  pid = fork();
    1a0e:	034030ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    1a12:	02054b63          	bltz	a0,1a48 <linkunlink+0x62>
    1a16:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a18:	4c85                	li	s9,1
    1a1a:	e119                	bnez	a0,1a20 <linkunlink+0x3a>
    1a1c:	06100c93          	li	s9,97
    1a20:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a24:	41c659b7          	lui	s3,0x41c65
    1a28:	e6d9899b          	addiw	s3,s3,-403
    1a2c:	690d                	lui	s2,0x3
    1a2e:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1a32:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a34:	4b05                	li	s6,1
      unlink("x");
    1a36:	00003a97          	auipc	s5,0x3
    1a3a:	682a8a93          	addi	s5,s5,1666 # 50b8 <malloc+0x1aa>
      link("cat", "x");
    1a3e:	00004b97          	auipc	s7,0x4
    1a42:	0f2b8b93          	addi	s7,s7,242 # 5b30 <malloc+0xc22>
    1a46:	a805                	j	1a76 <linkunlink+0x90>
    printf("%s: fork failed\n", s);
    1a48:	85a6                	mv	a1,s1
    1a4a:	00004517          	auipc	a0,0x4
    1a4e:	e8e50513          	addi	a0,a0,-370 # 58d8 <malloc+0x9ca>
    1a52:	402030ef          	jal	ra,4e54 <printf>
    exit(1);
    1a56:	4505                	li	a0,1
    1a58:	7f3020ef          	jal	ra,4a4a <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a5c:	20200593          	li	a1,514
    1a60:	8556                	mv	a0,s5
    1a62:	028030ef          	jal	ra,4a8a <open>
    1a66:	00c030ef          	jal	ra,4a72 <close>
    1a6a:	a021                	j	1a72 <linkunlink+0x8c>
      unlink("x");
    1a6c:	8556                	mv	a0,s5
    1a6e:	02c030ef          	jal	ra,4a9a <unlink>
  for(i = 0; i < 100; i++){
    1a72:	34fd                	addiw	s1,s1,-1
    1a74:	c08d                	beqz	s1,1a96 <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a76:	033c87bb          	mulw	a5,s9,s3
    1a7a:	012787bb          	addw	a5,a5,s2
    1a7e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a82:	0347f7bb          	remuw	a5,a5,s4
    1a86:	dbf9                	beqz	a5,1a5c <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a88:	ff6792e3          	bne	a5,s6,1a6c <linkunlink+0x86>
      link("cat", "x");
    1a8c:	85d6                	mv	a1,s5
    1a8e:	855e                	mv	a0,s7
    1a90:	01a030ef          	jal	ra,4aaa <link>
    1a94:	bff9                	j	1a72 <linkunlink+0x8c>
  if(pid)
    1a96:	020c0263          	beqz	s8,1aba <linkunlink+0xd4>
    wait(0);
    1a9a:	4501                	li	a0,0
    1a9c:	7b7020ef          	jal	ra,4a52 <wait>
}
    1aa0:	60e6                	ld	ra,88(sp)
    1aa2:	6446                	ld	s0,80(sp)
    1aa4:	64a6                	ld	s1,72(sp)
    1aa6:	6906                	ld	s2,64(sp)
    1aa8:	79e2                	ld	s3,56(sp)
    1aaa:	7a42                	ld	s4,48(sp)
    1aac:	7aa2                	ld	s5,40(sp)
    1aae:	7b02                	ld	s6,32(sp)
    1ab0:	6be2                	ld	s7,24(sp)
    1ab2:	6c42                	ld	s8,16(sp)
    1ab4:	6ca2                	ld	s9,8(sp)
    1ab6:	6125                	addi	sp,sp,96
    1ab8:	8082                	ret
    exit(0);
    1aba:	4501                	li	a0,0
    1abc:	78f020ef          	jal	ra,4a4a <exit>

0000000000001ac0 <forktest>:
{
    1ac0:	7179                	addi	sp,sp,-48
    1ac2:	f406                	sd	ra,40(sp)
    1ac4:	f022                	sd	s0,32(sp)
    1ac6:	ec26                	sd	s1,24(sp)
    1ac8:	e84a                	sd	s2,16(sp)
    1aca:	e44e                	sd	s3,8(sp)
    1acc:	1800                	addi	s0,sp,48
    1ace:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ad0:	4481                	li	s1,0
    1ad2:	3e800913          	li	s2,1000
    pid = fork();
    1ad6:	76d020ef          	jal	ra,4a42 <fork>
    if(pid < 0)
    1ada:	02054263          	bltz	a0,1afe <forktest+0x3e>
    if(pid == 0)
    1ade:	cd11                	beqz	a0,1afa <forktest+0x3a>
  for(n=0; n<N; n++){
    1ae0:	2485                	addiw	s1,s1,1
    1ae2:	ff249ae3          	bne	s1,s2,1ad6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ae6:	85ce                	mv	a1,s3
    1ae8:	00004517          	auipc	a0,0x4
    1aec:	06850513          	addi	a0,a0,104 # 5b50 <malloc+0xc42>
    1af0:	364030ef          	jal	ra,4e54 <printf>
    exit(1);
    1af4:	4505                	li	a0,1
    1af6:	755020ef          	jal	ra,4a4a <exit>
      exit(0);
    1afa:	751020ef          	jal	ra,4a4a <exit>
  if (n == 0) {
    1afe:	c89d                	beqz	s1,1b34 <forktest+0x74>
  if(n == N){
    1b00:	3e800793          	li	a5,1000
    1b04:	fef481e3          	beq	s1,a5,1ae6 <forktest+0x26>
  for(; n > 0; n--){
    1b08:	00905963          	blez	s1,1b1a <forktest+0x5a>
    if(wait(0) < 0){
    1b0c:	4501                	li	a0,0
    1b0e:	745020ef          	jal	ra,4a52 <wait>
    1b12:	02054b63          	bltz	a0,1b48 <forktest+0x88>
  for(; n > 0; n--){
    1b16:	34fd                	addiw	s1,s1,-1
    1b18:	f8f5                	bnez	s1,1b0c <forktest+0x4c>
  if(wait(0) != -1){
    1b1a:	4501                	li	a0,0
    1b1c:	737020ef          	jal	ra,4a52 <wait>
    1b20:	57fd                	li	a5,-1
    1b22:	02f51d63          	bne	a0,a5,1b5c <forktest+0x9c>
}
    1b26:	70a2                	ld	ra,40(sp)
    1b28:	7402                	ld	s0,32(sp)
    1b2a:	64e2                	ld	s1,24(sp)
    1b2c:	6942                	ld	s2,16(sp)
    1b2e:	69a2                	ld	s3,8(sp)
    1b30:	6145                	addi	sp,sp,48
    1b32:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b34:	85ce                	mv	a1,s3
    1b36:	00004517          	auipc	a0,0x4
    1b3a:	00250513          	addi	a0,a0,2 # 5b38 <malloc+0xc2a>
    1b3e:	316030ef          	jal	ra,4e54 <printf>
    exit(1);
    1b42:	4505                	li	a0,1
    1b44:	707020ef          	jal	ra,4a4a <exit>
      printf("%s: wait stopped early\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00004517          	auipc	a0,0x4
    1b4e:	02e50513          	addi	a0,a0,46 # 5b78 <malloc+0xc6a>
    1b52:	302030ef          	jal	ra,4e54 <printf>
      exit(1);
    1b56:	4505                	li	a0,1
    1b58:	6f3020ef          	jal	ra,4a4a <exit>
    printf("%s: wait got too many\n", s);
    1b5c:	85ce                	mv	a1,s3
    1b5e:	00004517          	auipc	a0,0x4
    1b62:	03250513          	addi	a0,a0,50 # 5b90 <malloc+0xc82>
    1b66:	2ee030ef          	jal	ra,4e54 <printf>
    exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	6df020ef          	jal	ra,4a4a <exit>

0000000000001b70 <kernmem>:
{
    1b70:	715d                	addi	sp,sp,-80
    1b72:	e486                	sd	ra,72(sp)
    1b74:	e0a2                	sd	s0,64(sp)
    1b76:	fc26                	sd	s1,56(sp)
    1b78:	f84a                	sd	s2,48(sp)
    1b7a:	f44e                	sd	s3,40(sp)
    1b7c:	f052                	sd	s4,32(sp)
    1b7e:	ec56                	sd	s5,24(sp)
    1b80:	0880                	addi	s0,sp,80
    1b82:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b84:	4485                	li	s1,1
    1b86:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1b88:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b8a:	69b1                	lui	s3,0xc
    1b8c:	35098993          	addi	s3,s3,848 # c350 <buf+0x6d8>
    1b90:	1003d937          	lui	s2,0x1003d
    1b94:	090e                	slli	s2,s2,0x3
    1b96:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e808>
    pid = fork();
    1b9a:	6a9020ef          	jal	ra,4a42 <fork>
    if(pid < 0){
    1b9e:	02054763          	bltz	a0,1bcc <kernmem+0x5c>
    if(pid == 0){
    1ba2:	cd1d                	beqz	a0,1be0 <kernmem+0x70>
    wait(&xstatus);
    1ba4:	fbc40513          	addi	a0,s0,-68
    1ba8:	6ab020ef          	jal	ra,4a52 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bac:	fbc42783          	lw	a5,-68(s0)
    1bb0:	05579563          	bne	a5,s5,1bfa <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bb4:	94ce                	add	s1,s1,s3
    1bb6:	ff2492e3          	bne	s1,s2,1b9a <kernmem+0x2a>
}
    1bba:	60a6                	ld	ra,72(sp)
    1bbc:	6406                	ld	s0,64(sp)
    1bbe:	74e2                	ld	s1,56(sp)
    1bc0:	7942                	ld	s2,48(sp)
    1bc2:	79a2                	ld	s3,40(sp)
    1bc4:	7a02                	ld	s4,32(sp)
    1bc6:	6ae2                	ld	s5,24(sp)
    1bc8:	6161                	addi	sp,sp,80
    1bca:	8082                	ret
      printf("%s: fork failed\n", s);
    1bcc:	85d2                	mv	a1,s4
    1bce:	00004517          	auipc	a0,0x4
    1bd2:	d0a50513          	addi	a0,a0,-758 # 58d8 <malloc+0x9ca>
    1bd6:	27e030ef          	jal	ra,4e54 <printf>
      exit(1);
    1bda:	4505                	li	a0,1
    1bdc:	66f020ef          	jal	ra,4a4a <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1be0:	0004c683          	lbu	a3,0(s1)
    1be4:	8626                	mv	a2,s1
    1be6:	85d2                	mv	a1,s4
    1be8:	00004517          	auipc	a0,0x4
    1bec:	fc050513          	addi	a0,a0,-64 # 5ba8 <malloc+0xc9a>
    1bf0:	264030ef          	jal	ra,4e54 <printf>
      exit(1);
    1bf4:	4505                	li	a0,1
    1bf6:	655020ef          	jal	ra,4a4a <exit>
      exit(1);
    1bfa:	4505                	li	a0,1
    1bfc:	64f020ef          	jal	ra,4a4a <exit>

0000000000001c00 <MAXVAplus>:
{
    1c00:	7179                	addi	sp,sp,-48
    1c02:	f406                	sd	ra,40(sp)
    1c04:	f022                	sd	s0,32(sp)
    1c06:	ec26                	sd	s1,24(sp)
    1c08:	e84a                	sd	s2,16(sp)
    1c0a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c0c:	4785                	li	a5,1
    1c0e:	179a                	slli	a5,a5,0x26
    1c10:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c14:	fd843783          	ld	a5,-40(s0)
    1c18:	cb85                	beqz	a5,1c48 <MAXVAplus+0x48>
    1c1a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c1c:	54fd                	li	s1,-1
    pid = fork();
    1c1e:	625020ef          	jal	ra,4a42 <fork>
    if(pid < 0){
    1c22:	02054963          	bltz	a0,1c54 <MAXVAplus+0x54>
    if(pid == 0){
    1c26:	c129                	beqz	a0,1c68 <MAXVAplus+0x68>
    wait(&xstatus);
    1c28:	fd440513          	addi	a0,s0,-44
    1c2c:	627020ef          	jal	ra,4a52 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c30:	fd442783          	lw	a5,-44(s0)
    1c34:	04979c63          	bne	a5,s1,1c8c <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c38:	fd843783          	ld	a5,-40(s0)
    1c3c:	0786                	slli	a5,a5,0x1
    1c3e:	fcf43c23          	sd	a5,-40(s0)
    1c42:	fd843783          	ld	a5,-40(s0)
    1c46:	ffe1                	bnez	a5,1c1e <MAXVAplus+0x1e>
}
    1c48:	70a2                	ld	ra,40(sp)
    1c4a:	7402                	ld	s0,32(sp)
    1c4c:	64e2                	ld	s1,24(sp)
    1c4e:	6942                	ld	s2,16(sp)
    1c50:	6145                	addi	sp,sp,48
    1c52:	8082                	ret
      printf("%s: fork failed\n", s);
    1c54:	85ca                	mv	a1,s2
    1c56:	00004517          	auipc	a0,0x4
    1c5a:	c8250513          	addi	a0,a0,-894 # 58d8 <malloc+0x9ca>
    1c5e:	1f6030ef          	jal	ra,4e54 <printf>
      exit(1);
    1c62:	4505                	li	a0,1
    1c64:	5e7020ef          	jal	ra,4a4a <exit>
      *(char*)a = 99;
    1c68:	fd843783          	ld	a5,-40(s0)
    1c6c:	06300713          	li	a4,99
    1c70:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c74:	fd843603          	ld	a2,-40(s0)
    1c78:	85ca                	mv	a1,s2
    1c7a:	00004517          	auipc	a0,0x4
    1c7e:	f4e50513          	addi	a0,a0,-178 # 5bc8 <malloc+0xcba>
    1c82:	1d2030ef          	jal	ra,4e54 <printf>
      exit(1);
    1c86:	4505                	li	a0,1
    1c88:	5c3020ef          	jal	ra,4a4a <exit>
      exit(1);
    1c8c:	4505                	li	a0,1
    1c8e:	5bd020ef          	jal	ra,4a4a <exit>

0000000000001c92 <stacktest>:
{
    1c92:	7179                	addi	sp,sp,-48
    1c94:	f406                	sd	ra,40(sp)
    1c96:	f022                	sd	s0,32(sp)
    1c98:	ec26                	sd	s1,24(sp)
    1c9a:	1800                	addi	s0,sp,48
    1c9c:	84aa                	mv	s1,a0
  pid = fork();
    1c9e:	5a5020ef          	jal	ra,4a42 <fork>
  if(pid == 0) {
    1ca2:	cd11                	beqz	a0,1cbe <stacktest+0x2c>
  } else if(pid < 0){
    1ca4:	02054c63          	bltz	a0,1cdc <stacktest+0x4a>
  wait(&xstatus);
    1ca8:	fdc40513          	addi	a0,s0,-36
    1cac:	5a7020ef          	jal	ra,4a52 <wait>
  if(xstatus == -1)  // kernel killed child?
    1cb0:	fdc42503          	lw	a0,-36(s0)
    1cb4:	57fd                	li	a5,-1
    1cb6:	02f50d63          	beq	a0,a5,1cf0 <stacktest+0x5e>
    exit(xstatus);
    1cba:	591020ef          	jal	ra,4a4a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cbe:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cc0:	77fd                	lui	a5,0xfffff
    1cc2:	97ba                	add	a5,a5,a4
    1cc4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1cc8:	85a6                	mv	a1,s1
    1cca:	00004517          	auipc	a0,0x4
    1cce:	f1650513          	addi	a0,a0,-234 # 5be0 <malloc+0xcd2>
    1cd2:	182030ef          	jal	ra,4e54 <printf>
    exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	573020ef          	jal	ra,4a4a <exit>
    printf("%s: fork failed\n", s);
    1cdc:	85a6                	mv	a1,s1
    1cde:	00004517          	auipc	a0,0x4
    1ce2:	bfa50513          	addi	a0,a0,-1030 # 58d8 <malloc+0x9ca>
    1ce6:	16e030ef          	jal	ra,4e54 <printf>
    exit(1);
    1cea:	4505                	li	a0,1
    1cec:	55f020ef          	jal	ra,4a4a <exit>
    exit(0);
    1cf0:	4501                	li	a0,0
    1cf2:	559020ef          	jal	ra,4a4a <exit>

0000000000001cf6 <nowrite>:
{
    1cf6:	7159                	addi	sp,sp,-112
    1cf8:	f486                	sd	ra,104(sp)
    1cfa:	f0a2                	sd	s0,96(sp)
    1cfc:	eca6                	sd	s1,88(sp)
    1cfe:	e8ca                	sd	s2,80(sp)
    1d00:	e4ce                	sd	s3,72(sp)
    1d02:	1880                	addi	s0,sp,112
    1d04:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d06:	00005797          	auipc	a5,0x5
    1d0a:	67a78793          	addi	a5,a5,1658 # 7380 <malloc+0x2472>
    1d0e:	7788                	ld	a0,40(a5)
    1d10:	7b8c                	ld	a1,48(a5)
    1d12:	7f90                	ld	a2,56(a5)
    1d14:	63b4                	ld	a3,64(a5)
    1d16:	67b8                	ld	a4,72(a5)
    1d18:	6bbc                	ld	a5,80(a5)
    1d1a:	f8a43c23          	sd	a0,-104(s0)
    1d1e:	fab43023          	sd	a1,-96(s0)
    1d22:	fac43423          	sd	a2,-88(s0)
    1d26:	fad43823          	sd	a3,-80(s0)
    1d2a:	fae43c23          	sd	a4,-72(s0)
    1d2e:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d32:	4481                	li	s1,0
    1d34:	4919                	li	s2,6
    pid = fork();
    1d36:	50d020ef          	jal	ra,4a42 <fork>
    if(pid == 0) {
    1d3a:	c105                	beqz	a0,1d5a <nowrite+0x64>
    } else if(pid < 0){
    1d3c:	04054163          	bltz	a0,1d7e <nowrite+0x88>
    wait(&xstatus);
    1d40:	fcc40513          	addi	a0,s0,-52
    1d44:	50f020ef          	jal	ra,4a52 <wait>
    if(xstatus == 0){
    1d48:	fcc42783          	lw	a5,-52(s0)
    1d4c:	c3b9                	beqz	a5,1d92 <nowrite+0x9c>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d4e:	2485                	addiw	s1,s1,1
    1d50:	ff2493e3          	bne	s1,s2,1d36 <nowrite+0x40>
  exit(0);
    1d54:	4501                	li	a0,0
    1d56:	4f5020ef          	jal	ra,4a4a <exit>
      volatile int *addr = (int *) addrs[ai];
    1d5a:	048e                	slli	s1,s1,0x3
    1d5c:	fd040793          	addi	a5,s0,-48
    1d60:	94be                	add	s1,s1,a5
    1d62:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d66:	47a9                	li	a5,10
    1d68:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d6a:	85ce                	mv	a1,s3
    1d6c:	00004517          	auipc	a0,0x4
    1d70:	e9c50513          	addi	a0,a0,-356 # 5c08 <malloc+0xcfa>
    1d74:	0e0030ef          	jal	ra,4e54 <printf>
      exit(0);
    1d78:	4501                	li	a0,0
    1d7a:	4d1020ef          	jal	ra,4a4a <exit>
      printf("%s: fork failed\n", s);
    1d7e:	85ce                	mv	a1,s3
    1d80:	00004517          	auipc	a0,0x4
    1d84:	b5850513          	addi	a0,a0,-1192 # 58d8 <malloc+0x9ca>
    1d88:	0cc030ef          	jal	ra,4e54 <printf>
      exit(1);
    1d8c:	4505                	li	a0,1
    1d8e:	4bd020ef          	jal	ra,4a4a <exit>
      exit(1);
    1d92:	4505                	li	a0,1
    1d94:	4b7020ef          	jal	ra,4a4a <exit>

0000000000001d98 <manywrites>:
{
    1d98:	711d                	addi	sp,sp,-96
    1d9a:	ec86                	sd	ra,88(sp)
    1d9c:	e8a2                	sd	s0,80(sp)
    1d9e:	e4a6                	sd	s1,72(sp)
    1da0:	e0ca                	sd	s2,64(sp)
    1da2:	fc4e                	sd	s3,56(sp)
    1da4:	f852                	sd	s4,48(sp)
    1da6:	f456                	sd	s5,40(sp)
    1da8:	f05a                	sd	s6,32(sp)
    1daa:	ec5e                	sd	s7,24(sp)
    1dac:	1080                	addi	s0,sp,96
    1dae:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    int pid = fork();
    1db4:	48f020ef          	jal	ra,4a42 <fork>
    1db8:	84aa                	mv	s1,a0
    if(pid < 0){
    1dba:	02054563          	bltz	a0,1de4 <manywrites+0x4c>
    if(pid == 0){
    1dbe:	cd05                	beqz	a0,1df6 <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1dc0:	2905                	addiw	s2,s2,1
    1dc2:	ff3919e3          	bne	s2,s3,1db4 <manywrites+0x1c>
    1dc6:	4491                	li	s1,4
    int st = 0;
    1dc8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dcc:	fa840513          	addi	a0,s0,-88
    1dd0:	483020ef          	jal	ra,4a52 <wait>
    if(st != 0)
    1dd4:	fa842503          	lw	a0,-88(s0)
    1dd8:	e169                	bnez	a0,1e9a <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dda:	34fd                	addiw	s1,s1,-1
    1ddc:	f4f5                	bnez	s1,1dc8 <manywrites+0x30>
  exit(0);
    1dde:	4501                	li	a0,0
    1de0:	46b020ef          	jal	ra,4a4a <exit>
      printf("fork failed\n");
    1de4:	00005517          	auipc	a0,0x5
    1de8:	04450513          	addi	a0,a0,68 # 6e28 <malloc+0x1f1a>
    1dec:	068030ef          	jal	ra,4e54 <printf>
      exit(1);
    1df0:	4505                	li	a0,1
    1df2:	459020ef          	jal	ra,4a4a <exit>
      name[0] = 'b';
    1df6:	06200793          	li	a5,98
    1dfa:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1dfe:	0619079b          	addiw	a5,s2,97
    1e02:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e06:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e0a:	fa840513          	addi	a0,s0,-88
    1e0e:	48d020ef          	jal	ra,4a9a <unlink>
    1e12:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1e14:	0000ab97          	auipc	s7,0xa
    1e18:	e64b8b93          	addi	s7,s7,-412 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e1c:	8a26                	mv	s4,s1
    1e1e:	02094863          	bltz	s2,1e4e <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e22:	20200593          	li	a1,514
    1e26:	fa840513          	addi	a0,s0,-88
    1e2a:	461020ef          	jal	ra,4a8a <open>
    1e2e:	89aa                	mv	s3,a0
          if(fd < 0){
    1e30:	02054d63          	bltz	a0,1e6a <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e34:	660d                	lui	a2,0x3
    1e36:	85de                	mv	a1,s7
    1e38:	433020ef          	jal	ra,4a6a <write>
          if(cc != sz){
    1e3c:	678d                	lui	a5,0x3
    1e3e:	04f51263          	bne	a0,a5,1e82 <manywrites+0xea>
          close(fd);
    1e42:	854e                	mv	a0,s3
    1e44:	42f020ef          	jal	ra,4a72 <close>
        for(int i = 0; i < ci+1; i++){
    1e48:	2a05                	addiw	s4,s4,1
    1e4a:	fd495ce3          	bge	s2,s4,1e22 <manywrites+0x8a>
        unlink(name);
    1e4e:	fa840513          	addi	a0,s0,-88
    1e52:	449020ef          	jal	ra,4a9a <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e56:	3b7d                	addiw	s6,s6,-1
    1e58:	fc0b12e3          	bnez	s6,1e1c <manywrites+0x84>
      unlink(name);
    1e5c:	fa840513          	addi	a0,s0,-88
    1e60:	43b020ef          	jal	ra,4a9a <unlink>
      exit(0);
    1e64:	4501                	li	a0,0
    1e66:	3e5020ef          	jal	ra,4a4a <exit>
            printf("%s: cannot create %s\n", s, name);
    1e6a:	fa840613          	addi	a2,s0,-88
    1e6e:	85d6                	mv	a1,s5
    1e70:	00004517          	auipc	a0,0x4
    1e74:	db850513          	addi	a0,a0,-584 # 5c28 <malloc+0xd1a>
    1e78:	7dd020ef          	jal	ra,4e54 <printf>
            exit(1);
    1e7c:	4505                	li	a0,1
    1e7e:	3cd020ef          	jal	ra,4a4a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e82:	86aa                	mv	a3,a0
    1e84:	660d                	lui	a2,0x3
    1e86:	85d6                	mv	a1,s5
    1e88:	00003517          	auipc	a0,0x3
    1e8c:	29050513          	addi	a0,a0,656 # 5118 <malloc+0x20a>
    1e90:	7c5020ef          	jal	ra,4e54 <printf>
            exit(1);
    1e94:	4505                	li	a0,1
    1e96:	3b5020ef          	jal	ra,4a4a <exit>
      exit(st);
    1e9a:	3b1020ef          	jal	ra,4a4a <exit>

0000000000001e9e <copyinstr3>:
{
    1e9e:	7179                	addi	sp,sp,-48
    1ea0:	f406                	sd	ra,40(sp)
    1ea2:	f022                	sd	s0,32(sp)
    1ea4:	ec26                	sd	s1,24(sp)
    1ea6:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ea8:	6509                	lui	a0,0x2
    1eaa:	429020ef          	jal	ra,4ad2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1eae:	4501                	li	a0,0
    1eb0:	423020ef          	jal	ra,4ad2 <sbrk>
  if((top % PGSIZE) != 0){
    1eb4:	03451793          	slli	a5,a0,0x34
    1eb8:	e7bd                	bnez	a5,1f26 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eba:	4501                	li	a0,0
    1ebc:	417020ef          	jal	ra,4ad2 <sbrk>
  if(top % PGSIZE){
    1ec0:	03451793          	slli	a5,a0,0x34
    1ec4:	ebad                	bnez	a5,1f36 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ec6:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x5d>
  *b = 'x';
    1eca:	07800793          	li	a5,120
    1ece:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ed2:	8526                	mv	a0,s1
    1ed4:	3c7020ef          	jal	ra,4a9a <unlink>
  if(ret != -1){
    1ed8:	57fd                	li	a5,-1
    1eda:	06f51763          	bne	a0,a5,1f48 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ede:	20100593          	li	a1,513
    1ee2:	8526                	mv	a0,s1
    1ee4:	3a7020ef          	jal	ra,4a8a <open>
  if(fd != -1){
    1ee8:	57fd                	li	a5,-1
    1eea:	06f51a63          	bne	a0,a5,1f5e <copyinstr3+0xc0>
  ret = link(b, b);
    1eee:	85a6                	mv	a1,s1
    1ef0:	8526                	mv	a0,s1
    1ef2:	3b9020ef          	jal	ra,4aaa <link>
  if(ret != -1){
    1ef6:	57fd                	li	a5,-1
    1ef8:	06f51e63          	bne	a0,a5,1f74 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1efc:	00005797          	auipc	a5,0x5
    1f00:	a2c78793          	addi	a5,a5,-1492 # 6928 <malloc+0x1a1a>
    1f04:	fcf43823          	sd	a5,-48(s0)
    1f08:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f0c:	fd040593          	addi	a1,s0,-48
    1f10:	8526                	mv	a0,s1
    1f12:	371020ef          	jal	ra,4a82 <exec>
  if(ret != -1){
    1f16:	57fd                	li	a5,-1
    1f18:	06f51a63          	bne	a0,a5,1f8c <copyinstr3+0xee>
}
    1f1c:	70a2                	ld	ra,40(sp)
    1f1e:	7402                	ld	s0,32(sp)
    1f20:	64e2                	ld	s1,24(sp)
    1f22:	6145                	addi	sp,sp,48
    1f24:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f26:	0347d513          	srli	a0,a5,0x34
    1f2a:	6785                	lui	a5,0x1
    1f2c:	40a7853b          	subw	a0,a5,a0
    1f30:	3a3020ef          	jal	ra,4ad2 <sbrk>
    1f34:	b759                	j	1eba <copyinstr3+0x1c>
    printf("oops\n");
    1f36:	00004517          	auipc	a0,0x4
    1f3a:	d0a50513          	addi	a0,a0,-758 # 5c40 <malloc+0xd32>
    1f3e:	717020ef          	jal	ra,4e54 <printf>
    exit(1);
    1f42:	4505                	li	a0,1
    1f44:	307020ef          	jal	ra,4a4a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f48:	862a                	mv	a2,a0
    1f4a:	85a6                	mv	a1,s1
    1f4c:	00004517          	auipc	a0,0x4
    1f50:	8ac50513          	addi	a0,a0,-1876 # 57f8 <malloc+0x8ea>
    1f54:	701020ef          	jal	ra,4e54 <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	2f1020ef          	jal	ra,4a4a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f5e:	862a                	mv	a2,a0
    1f60:	85a6                	mv	a1,s1
    1f62:	00004517          	auipc	a0,0x4
    1f66:	8b650513          	addi	a0,a0,-1866 # 5818 <malloc+0x90a>
    1f6a:	6eb020ef          	jal	ra,4e54 <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	2db020ef          	jal	ra,4a4a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f74:	86aa                	mv	a3,a0
    1f76:	8626                	mv	a2,s1
    1f78:	85a6                	mv	a1,s1
    1f7a:	00004517          	auipc	a0,0x4
    1f7e:	8be50513          	addi	a0,a0,-1858 # 5838 <malloc+0x92a>
    1f82:	6d3020ef          	jal	ra,4e54 <printf>
    exit(1);
    1f86:	4505                	li	a0,1
    1f88:	2c3020ef          	jal	ra,4a4a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f8c:	567d                	li	a2,-1
    1f8e:	85a6                	mv	a1,s1
    1f90:	00004517          	auipc	a0,0x4
    1f94:	8d050513          	addi	a0,a0,-1840 # 5860 <malloc+0x952>
    1f98:	6bd020ef          	jal	ra,4e54 <printf>
    exit(1);
    1f9c:	4505                	li	a0,1
    1f9e:	2ad020ef          	jal	ra,4a4a <exit>

0000000000001fa2 <rwsbrk>:
{
    1fa2:	1101                	addi	sp,sp,-32
    1fa4:	ec06                	sd	ra,24(sp)
    1fa6:	e822                	sd	s0,16(sp)
    1fa8:	e426                	sd	s1,8(sp)
    1faa:	e04a                	sd	s2,0(sp)
    1fac:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fae:	6509                	lui	a0,0x2
    1fb0:	323020ef          	jal	ra,4ad2 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fb4:	57fd                	li	a5,-1
    1fb6:	04f50963          	beq	a0,a5,2008 <rwsbrk+0x66>
    1fba:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fbc:	7579                	lui	a0,0xffffe
    1fbe:	315020ef          	jal	ra,4ad2 <sbrk>
    1fc2:	57fd                	li	a5,-1
    1fc4:	04f50b63          	beq	a0,a5,201a <rwsbrk+0x78>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fc8:	20100593          	li	a1,513
    1fcc:	00004517          	auipc	a0,0x4
    1fd0:	cb450513          	addi	a0,a0,-844 # 5c80 <malloc+0xd72>
    1fd4:	2b7020ef          	jal	ra,4a8a <open>
    1fd8:	892a                	mv	s2,a0
  if(fd < 0){
    1fda:	04054963          	bltz	a0,202c <rwsbrk+0x8a>
  n = write(fd, (void*)(a+4096), 1024);
    1fde:	6505                	lui	a0,0x1
    1fe0:	94aa                	add	s1,s1,a0
    1fe2:	40000613          	li	a2,1024
    1fe6:	85a6                	mv	a1,s1
    1fe8:	854a                	mv	a0,s2
    1fea:	281020ef          	jal	ra,4a6a <write>
    1fee:	862a                	mv	a2,a0
  if(n >= 0){
    1ff0:	04054763          	bltz	a0,203e <rwsbrk+0x9c>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    1ff4:	85a6                	mv	a1,s1
    1ff6:	00004517          	auipc	a0,0x4
    1ffa:	caa50513          	addi	a0,a0,-854 # 5ca0 <malloc+0xd92>
    1ffe:	657020ef          	jal	ra,4e54 <printf>
    exit(1);
    2002:	4505                	li	a0,1
    2004:	247020ef          	jal	ra,4a4a <exit>
    printf("sbrk(rwsbrk) failed\n");
    2008:	00004517          	auipc	a0,0x4
    200c:	c4050513          	addi	a0,a0,-960 # 5c48 <malloc+0xd3a>
    2010:	645020ef          	jal	ra,4e54 <printf>
    exit(1);
    2014:	4505                	li	a0,1
    2016:	235020ef          	jal	ra,4a4a <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    201a:	00004517          	auipc	a0,0x4
    201e:	c4650513          	addi	a0,a0,-954 # 5c60 <malloc+0xd52>
    2022:	633020ef          	jal	ra,4e54 <printf>
    exit(1);
    2026:	4505                	li	a0,1
    2028:	223020ef          	jal	ra,4a4a <exit>
    printf("open(rwsbrk) failed\n");
    202c:	00004517          	auipc	a0,0x4
    2030:	c5c50513          	addi	a0,a0,-932 # 5c88 <malloc+0xd7a>
    2034:	621020ef          	jal	ra,4e54 <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	211020ef          	jal	ra,4a4a <exit>
  close(fd);
    203e:	854a                	mv	a0,s2
    2040:	233020ef          	jal	ra,4a72 <close>
  unlink("rwsbrk");
    2044:	00004517          	auipc	a0,0x4
    2048:	c3c50513          	addi	a0,a0,-964 # 5c80 <malloc+0xd72>
    204c:	24f020ef          	jal	ra,4a9a <unlink>
  fd = open("README", O_RDONLY);
    2050:	4581                	li	a1,0
    2052:	00003517          	auipc	a0,0x3
    2056:	1ce50513          	addi	a0,a0,462 # 5220 <malloc+0x312>
    205a:	231020ef          	jal	ra,4a8a <open>
    205e:	892a                	mv	s2,a0
  if(fd < 0){
    2060:	02054363          	bltz	a0,2086 <rwsbrk+0xe4>
  n = read(fd, (void*)(a+4096), 10);
    2064:	4629                	li	a2,10
    2066:	85a6                	mv	a1,s1
    2068:	1fb020ef          	jal	ra,4a62 <read>
    206c:	862a                	mv	a2,a0
  if(n >= 0){
    206e:	02054563          	bltz	a0,2098 <rwsbrk+0xf6>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2072:	85a6                	mv	a1,s1
    2074:	00004517          	auipc	a0,0x4
    2078:	c5c50513          	addi	a0,a0,-932 # 5cd0 <malloc+0xdc2>
    207c:	5d9020ef          	jal	ra,4e54 <printf>
    exit(1);
    2080:	4505                	li	a0,1
    2082:	1c9020ef          	jal	ra,4a4a <exit>
    printf("open(rwsbrk) failed\n");
    2086:	00004517          	auipc	a0,0x4
    208a:	c0250513          	addi	a0,a0,-1022 # 5c88 <malloc+0xd7a>
    208e:	5c7020ef          	jal	ra,4e54 <printf>
    exit(1);
    2092:	4505                	li	a0,1
    2094:	1b7020ef          	jal	ra,4a4a <exit>
  close(fd);
    2098:	854a                	mv	a0,s2
    209a:	1d9020ef          	jal	ra,4a72 <close>
  exit(0);
    209e:	4501                	li	a0,0
    20a0:	1ab020ef          	jal	ra,4a4a <exit>

00000000000020a4 <sbrkbasic>:
{
    20a4:	715d                	addi	sp,sp,-80
    20a6:	e486                	sd	ra,72(sp)
    20a8:	e0a2                	sd	s0,64(sp)
    20aa:	fc26                	sd	s1,56(sp)
    20ac:	f84a                	sd	s2,48(sp)
    20ae:	f44e                	sd	s3,40(sp)
    20b0:	f052                	sd	s4,32(sp)
    20b2:	ec56                	sd	s5,24(sp)
    20b4:	0880                	addi	s0,sp,80
    20b6:	8a2a                	mv	s4,a0
  pid = fork();
    20b8:	18b020ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    20bc:	02054863          	bltz	a0,20ec <sbrkbasic+0x48>
  if(pid == 0){
    20c0:	e131                	bnez	a0,2104 <sbrkbasic+0x60>
    a = sbrk(TOOMUCH);
    20c2:	40000537          	lui	a0,0x40000
    20c6:	20d020ef          	jal	ra,4ad2 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20ca:	57fd                	li	a5,-1
    20cc:	02f50963          	beq	a0,a5,20fe <sbrkbasic+0x5a>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d0:	400007b7          	lui	a5,0x40000
    20d4:	97aa                	add	a5,a5,a0
      *b = 99;
    20d6:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    20da:	6705                	lui	a4,0x1
      *b = 99;
    20dc:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20e0:	953a                	add	a0,a0,a4
    20e2:	fef51de3          	bne	a0,a5,20dc <sbrkbasic+0x38>
    exit(1);
    20e6:	4505                	li	a0,1
    20e8:	163020ef          	jal	ra,4a4a <exit>
    printf("fork failed in sbrkbasic\n");
    20ec:	00004517          	auipc	a0,0x4
    20f0:	c0c50513          	addi	a0,a0,-1012 # 5cf8 <malloc+0xdea>
    20f4:	561020ef          	jal	ra,4e54 <printf>
    exit(1);
    20f8:	4505                	li	a0,1
    20fa:	151020ef          	jal	ra,4a4a <exit>
      exit(0);
    20fe:	4501                	li	a0,0
    2100:	14b020ef          	jal	ra,4a4a <exit>
  wait(&xstatus);
    2104:	fbc40513          	addi	a0,s0,-68
    2108:	14b020ef          	jal	ra,4a52 <wait>
  if(xstatus == 1){
    210c:	fbc42703          	lw	a4,-68(s0)
    2110:	4785                	li	a5,1
    2112:	00f70c63          	beq	a4,a5,212a <sbrkbasic+0x86>
  a = sbrk(0);
    2116:	4501                	li	a0,0
    2118:	1bb020ef          	jal	ra,4ad2 <sbrk>
    211c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    211e:	4901                	li	s2,0
    *b = 1;
    2120:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2122:	6985                	lui	s3,0x1
    2124:	38898993          	addi	s3,s3,904 # 1388 <exectest+0x50>
    2128:	a821                	j	2140 <sbrkbasic+0x9c>
    printf("%s: too much memory allocated!\n", s);
    212a:	85d2                	mv	a1,s4
    212c:	00004517          	auipc	a0,0x4
    2130:	bec50513          	addi	a0,a0,-1044 # 5d18 <malloc+0xe0a>
    2134:	521020ef          	jal	ra,4e54 <printf>
    exit(1);
    2138:	4505                	li	a0,1
    213a:	111020ef          	jal	ra,4a4a <exit>
    a = b + 1;
    213e:	84be                	mv	s1,a5
    b = sbrk(1);
    2140:	4505                	li	a0,1
    2142:	191020ef          	jal	ra,4ad2 <sbrk>
    if(b != a){
    2146:	04951163          	bne	a0,s1,2188 <sbrkbasic+0xe4>
    *b = 1;
    214a:	01548023          	sb	s5,0(s1)
    a = b + 1;
    214e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2152:	2905                	addiw	s2,s2,1
    2154:	ff3915e3          	bne	s2,s3,213e <sbrkbasic+0x9a>
  pid = fork();
    2158:	0eb020ef          	jal	ra,4a42 <fork>
    215c:	892a                	mv	s2,a0
  if(pid < 0){
    215e:	04054263          	bltz	a0,21a2 <sbrkbasic+0xfe>
  c = sbrk(1);
    2162:	4505                	li	a0,1
    2164:	16f020ef          	jal	ra,4ad2 <sbrk>
  c = sbrk(1);
    2168:	4505                	li	a0,1
    216a:	169020ef          	jal	ra,4ad2 <sbrk>
  if(c != a + 1){
    216e:	0489                	addi	s1,s1,2
    2170:	04a48363          	beq	s1,a0,21b6 <sbrkbasic+0x112>
    printf("%s: sbrk test failed post-fork\n", s);
    2174:	85d2                	mv	a1,s4
    2176:	00004517          	auipc	a0,0x4
    217a:	c0250513          	addi	a0,a0,-1022 # 5d78 <malloc+0xe6a>
    217e:	4d7020ef          	jal	ra,4e54 <printf>
    exit(1);
    2182:	4505                	li	a0,1
    2184:	0c7020ef          	jal	ra,4a4a <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2188:	872a                	mv	a4,a0
    218a:	86a6                	mv	a3,s1
    218c:	864a                	mv	a2,s2
    218e:	85d2                	mv	a1,s4
    2190:	00004517          	auipc	a0,0x4
    2194:	ba850513          	addi	a0,a0,-1112 # 5d38 <malloc+0xe2a>
    2198:	4bd020ef          	jal	ra,4e54 <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	0ad020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk test fork failed\n", s);
    21a2:	85d2                	mv	a1,s4
    21a4:	00004517          	auipc	a0,0x4
    21a8:	bb450513          	addi	a0,a0,-1100 # 5d58 <malloc+0xe4a>
    21ac:	4a9020ef          	jal	ra,4e54 <printf>
    exit(1);
    21b0:	4505                	li	a0,1
    21b2:	099020ef          	jal	ra,4a4a <exit>
  if(pid == 0)
    21b6:	00091563          	bnez	s2,21c0 <sbrkbasic+0x11c>
    exit(0);
    21ba:	4501                	li	a0,0
    21bc:	08f020ef          	jal	ra,4a4a <exit>
  wait(&xstatus);
    21c0:	fbc40513          	addi	a0,s0,-68
    21c4:	08f020ef          	jal	ra,4a52 <wait>
  exit(xstatus);
    21c8:	fbc42503          	lw	a0,-68(s0)
    21cc:	07f020ef          	jal	ra,4a4a <exit>

00000000000021d0 <sbrkmuch>:
{
    21d0:	7179                	addi	sp,sp,-48
    21d2:	f406                	sd	ra,40(sp)
    21d4:	f022                	sd	s0,32(sp)
    21d6:	ec26                	sd	s1,24(sp)
    21d8:	e84a                	sd	s2,16(sp)
    21da:	e44e                	sd	s3,8(sp)
    21dc:	e052                	sd	s4,0(sp)
    21de:	1800                	addi	s0,sp,48
    21e0:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21e2:	4501                	li	a0,0
    21e4:	0ef020ef          	jal	ra,4ad2 <sbrk>
    21e8:	892a                	mv	s2,a0
  a = sbrk(0);
    21ea:	4501                	li	a0,0
    21ec:	0e7020ef          	jal	ra,4ad2 <sbrk>
    21f0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21f2:	06400537          	lui	a0,0x6400
    21f6:	9d05                	subw	a0,a0,s1
    21f8:	0db020ef          	jal	ra,4ad2 <sbrk>
  if (p != a) {
    21fc:	0aa49463          	bne	s1,a0,22a4 <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    2200:	4501                	li	a0,0
    2202:	0d1020ef          	jal	ra,4ad2 <sbrk>
    2206:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2208:	00a4f963          	bgeu	s1,a0,221a <sbrkmuch+0x4a>
    *pp = 1;
    220c:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    220e:	6705                	lui	a4,0x1
    *pp = 1;
    2210:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2214:	94ba                	add	s1,s1,a4
    2216:	fef4ede3          	bltu	s1,a5,2210 <sbrkmuch+0x40>
  *lastaddr = 99;
    221a:	064007b7          	lui	a5,0x6400
    221e:	06300713          	li	a4,99
    2222:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    2226:	4501                	li	a0,0
    2228:	0ab020ef          	jal	ra,4ad2 <sbrk>
    222c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    222e:	757d                	lui	a0,0xfffff
    2230:	0a3020ef          	jal	ra,4ad2 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2234:	57fd                	li	a5,-1
    2236:	08f50163          	beq	a0,a5,22b8 <sbrkmuch+0xe8>
  c = sbrk(0);
    223a:	4501                	li	a0,0
    223c:	097020ef          	jal	ra,4ad2 <sbrk>
  if(c != a - PGSIZE){
    2240:	77fd                	lui	a5,0xfffff
    2242:	97a6                	add	a5,a5,s1
    2244:	08f51463          	bne	a0,a5,22cc <sbrkmuch+0xfc>
  a = sbrk(0);
    2248:	4501                	li	a0,0
    224a:	089020ef          	jal	ra,4ad2 <sbrk>
    224e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2250:	6505                	lui	a0,0x1
    2252:	081020ef          	jal	ra,4ad2 <sbrk>
    2256:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2258:	08a49663          	bne	s1,a0,22e4 <sbrkmuch+0x114>
    225c:	4501                	li	a0,0
    225e:	075020ef          	jal	ra,4ad2 <sbrk>
    2262:	6785                	lui	a5,0x1
    2264:	97a6                	add	a5,a5,s1
    2266:	06f51f63          	bne	a0,a5,22e4 <sbrkmuch+0x114>
  if(*lastaddr == 99){
    226a:	064007b7          	lui	a5,0x6400
    226e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    2272:	06300793          	li	a5,99
    2276:	08f70363          	beq	a4,a5,22fc <sbrkmuch+0x12c>
  a = sbrk(0);
    227a:	4501                	li	a0,0
    227c:	057020ef          	jal	ra,4ad2 <sbrk>
    2280:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2282:	4501                	li	a0,0
    2284:	04f020ef          	jal	ra,4ad2 <sbrk>
    2288:	40a9053b          	subw	a0,s2,a0
    228c:	047020ef          	jal	ra,4ad2 <sbrk>
  if(c != a){
    2290:	08a49063          	bne	s1,a0,2310 <sbrkmuch+0x140>
}
    2294:	70a2                	ld	ra,40(sp)
    2296:	7402                	ld	s0,32(sp)
    2298:	64e2                	ld	s1,24(sp)
    229a:	6942                	ld	s2,16(sp)
    229c:	69a2                	ld	s3,8(sp)
    229e:	6a02                	ld	s4,0(sp)
    22a0:	6145                	addi	sp,sp,48
    22a2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22a4:	85ce                	mv	a1,s3
    22a6:	00004517          	auipc	a0,0x4
    22aa:	af250513          	addi	a0,a0,-1294 # 5d98 <malloc+0xe8a>
    22ae:	3a7020ef          	jal	ra,4e54 <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	796020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22b8:	85ce                	mv	a1,s3
    22ba:	00004517          	auipc	a0,0x4
    22be:	b2650513          	addi	a0,a0,-1242 # 5de0 <malloc+0xed2>
    22c2:	393020ef          	jal	ra,4e54 <printf>
    exit(1);
    22c6:	4505                	li	a0,1
    22c8:	782020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22cc:	86aa                	mv	a3,a0
    22ce:	8626                	mv	a2,s1
    22d0:	85ce                	mv	a1,s3
    22d2:	00004517          	auipc	a0,0x4
    22d6:	b2e50513          	addi	a0,a0,-1234 # 5e00 <malloc+0xef2>
    22da:	37b020ef          	jal	ra,4e54 <printf>
    exit(1);
    22de:	4505                	li	a0,1
    22e0:	76a020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22e4:	86d2                	mv	a3,s4
    22e6:	8626                	mv	a2,s1
    22e8:	85ce                	mv	a1,s3
    22ea:	00004517          	auipc	a0,0x4
    22ee:	b5650513          	addi	a0,a0,-1194 # 5e40 <malloc+0xf32>
    22f2:	363020ef          	jal	ra,4e54 <printf>
    exit(1);
    22f6:	4505                	li	a0,1
    22f8:	752020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22fc:	85ce                	mv	a1,s3
    22fe:	00004517          	auipc	a0,0x4
    2302:	b7250513          	addi	a0,a0,-1166 # 5e70 <malloc+0xf62>
    2306:	34f020ef          	jal	ra,4e54 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	73e020ef          	jal	ra,4a4a <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2310:	86aa                	mv	a3,a0
    2312:	8626                	mv	a2,s1
    2314:	85ce                	mv	a1,s3
    2316:	00004517          	auipc	a0,0x4
    231a:	b9250513          	addi	a0,a0,-1134 # 5ea8 <malloc+0xf9a>
    231e:	337020ef          	jal	ra,4e54 <printf>
    exit(1);
    2322:	4505                	li	a0,1
    2324:	726020ef          	jal	ra,4a4a <exit>

0000000000002328 <sbrkarg>:
{
    2328:	7179                	addi	sp,sp,-48
    232a:	f406                	sd	ra,40(sp)
    232c:	f022                	sd	s0,32(sp)
    232e:	ec26                	sd	s1,24(sp)
    2330:	e84a                	sd	s2,16(sp)
    2332:	e44e                	sd	s3,8(sp)
    2334:	1800                	addi	s0,sp,48
    2336:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	798020ef          	jal	ra,4ad2 <sbrk>
    233e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2340:	20100593          	li	a1,513
    2344:	00004517          	auipc	a0,0x4
    2348:	b8c50513          	addi	a0,a0,-1140 # 5ed0 <malloc+0xfc2>
    234c:	73e020ef          	jal	ra,4a8a <open>
    2350:	84aa                	mv	s1,a0
  unlink("sbrk");
    2352:	00004517          	auipc	a0,0x4
    2356:	b7e50513          	addi	a0,a0,-1154 # 5ed0 <malloc+0xfc2>
    235a:	740020ef          	jal	ra,4a9a <unlink>
  if(fd < 0)  {
    235e:	0204c963          	bltz	s1,2390 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2362:	6605                	lui	a2,0x1
    2364:	85ca                	mv	a1,s2
    2366:	8526                	mv	a0,s1
    2368:	702020ef          	jal	ra,4a6a <write>
    236c:	02054c63          	bltz	a0,23a4 <sbrkarg+0x7c>
  close(fd);
    2370:	8526                	mv	a0,s1
    2372:	700020ef          	jal	ra,4a72 <close>
  a = sbrk(PGSIZE);
    2376:	6505                	lui	a0,0x1
    2378:	75a020ef          	jal	ra,4ad2 <sbrk>
  if(pipe((int *) a) != 0){
    237c:	6de020ef          	jal	ra,4a5a <pipe>
    2380:	ed05                	bnez	a0,23b8 <sbrkarg+0x90>
}
    2382:	70a2                	ld	ra,40(sp)
    2384:	7402                	ld	s0,32(sp)
    2386:	64e2                	ld	s1,24(sp)
    2388:	6942                	ld	s2,16(sp)
    238a:	69a2                	ld	s3,8(sp)
    238c:	6145                	addi	sp,sp,48
    238e:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2390:	85ce                	mv	a1,s3
    2392:	00004517          	auipc	a0,0x4
    2396:	b4650513          	addi	a0,a0,-1210 # 5ed8 <malloc+0xfca>
    239a:	2bb020ef          	jal	ra,4e54 <printf>
    exit(1);
    239e:	4505                	li	a0,1
    23a0:	6aa020ef          	jal	ra,4a4a <exit>
    printf("%s: write sbrk failed\n", s);
    23a4:	85ce                	mv	a1,s3
    23a6:	00004517          	auipc	a0,0x4
    23aa:	b4a50513          	addi	a0,a0,-1206 # 5ef0 <malloc+0xfe2>
    23ae:	2a7020ef          	jal	ra,4e54 <printf>
    exit(1);
    23b2:	4505                	li	a0,1
    23b4:	696020ef          	jal	ra,4a4a <exit>
    printf("%s: pipe() failed\n", s);
    23b8:	85ce                	mv	a1,s3
    23ba:	00003517          	auipc	a0,0x3
    23be:	62650513          	addi	a0,a0,1574 # 59e0 <malloc+0xad2>
    23c2:	293020ef          	jal	ra,4e54 <printf>
    exit(1);
    23c6:	4505                	li	a0,1
    23c8:	682020ef          	jal	ra,4a4a <exit>

00000000000023cc <argptest>:
{
    23cc:	1101                	addi	sp,sp,-32
    23ce:	ec06                	sd	ra,24(sp)
    23d0:	e822                	sd	s0,16(sp)
    23d2:	e426                	sd	s1,8(sp)
    23d4:	e04a                	sd	s2,0(sp)
    23d6:	1000                	addi	s0,sp,32
    23d8:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23da:	4581                	li	a1,0
    23dc:	00004517          	auipc	a0,0x4
    23e0:	b2c50513          	addi	a0,a0,-1236 # 5f08 <malloc+0xffa>
    23e4:	6a6020ef          	jal	ra,4a8a <open>
  if (fd < 0) {
    23e8:	02054563          	bltz	a0,2412 <argptest+0x46>
    23ec:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23ee:	4501                	li	a0,0
    23f0:	6e2020ef          	jal	ra,4ad2 <sbrk>
    23f4:	567d                	li	a2,-1
    23f6:	fff50593          	addi	a1,a0,-1
    23fa:	8526                	mv	a0,s1
    23fc:	666020ef          	jal	ra,4a62 <read>
  close(fd);
    2400:	8526                	mv	a0,s1
    2402:	670020ef          	jal	ra,4a72 <close>
}
    2406:	60e2                	ld	ra,24(sp)
    2408:	6442                	ld	s0,16(sp)
    240a:	64a2                	ld	s1,8(sp)
    240c:	6902                	ld	s2,0(sp)
    240e:	6105                	addi	sp,sp,32
    2410:	8082                	ret
    printf("%s: open failed\n", s);
    2412:	85ca                	mv	a1,s2
    2414:	00003517          	auipc	a0,0x3
    2418:	4dc50513          	addi	a0,a0,1244 # 58f0 <malloc+0x9e2>
    241c:	239020ef          	jal	ra,4e54 <printf>
    exit(1);
    2420:	4505                	li	a0,1
    2422:	628020ef          	jal	ra,4a4a <exit>

0000000000002426 <sbrkbugs>:
{
    2426:	1141                	addi	sp,sp,-16
    2428:	e406                	sd	ra,8(sp)
    242a:	e022                	sd	s0,0(sp)
    242c:	0800                	addi	s0,sp,16
  int pid = fork();
    242e:	614020ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    2432:	00054c63          	bltz	a0,244a <sbrkbugs+0x24>
  if(pid == 0){
    2436:	e11d                	bnez	a0,245c <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2438:	69a020ef          	jal	ra,4ad2 <sbrk>
    sbrk(-sz);
    243c:	40a0053b          	negw	a0,a0
    2440:	692020ef          	jal	ra,4ad2 <sbrk>
    exit(0);
    2444:	4501                	li	a0,0
    2446:	604020ef          	jal	ra,4a4a <exit>
    printf("fork failed\n");
    244a:	00005517          	auipc	a0,0x5
    244e:	9de50513          	addi	a0,a0,-1570 # 6e28 <malloc+0x1f1a>
    2452:	203020ef          	jal	ra,4e54 <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	5f2020ef          	jal	ra,4a4a <exit>
  wait(0);
    245c:	4501                	li	a0,0
    245e:	5f4020ef          	jal	ra,4a52 <wait>
  pid = fork();
    2462:	5e0020ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    2466:	00054f63          	bltz	a0,2484 <sbrkbugs+0x5e>
  if(pid == 0){
    246a:	e515                	bnez	a0,2496 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    246c:	666020ef          	jal	ra,4ad2 <sbrk>
    sbrk(-(sz - 3500));
    2470:	6785                	lui	a5,0x1
    2472:	dac7879b          	addiw	a5,a5,-596
    2476:	40a7853b          	subw	a0,a5,a0
    247a:	658020ef          	jal	ra,4ad2 <sbrk>
    exit(0);
    247e:	4501                	li	a0,0
    2480:	5ca020ef          	jal	ra,4a4a <exit>
    printf("fork failed\n");
    2484:	00005517          	auipc	a0,0x5
    2488:	9a450513          	addi	a0,a0,-1628 # 6e28 <malloc+0x1f1a>
    248c:	1c9020ef          	jal	ra,4e54 <printf>
    exit(1);
    2490:	4505                	li	a0,1
    2492:	5b8020ef          	jal	ra,4a4a <exit>
  wait(0);
    2496:	4501                	li	a0,0
    2498:	5ba020ef          	jal	ra,4a52 <wait>
  pid = fork();
    249c:	5a6020ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    24a0:	02054263          	bltz	a0,24c4 <sbrkbugs+0x9e>
  if(pid == 0){
    24a4:	e90d                	bnez	a0,24d6 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    24a6:	62c020ef          	jal	ra,4ad2 <sbrk>
    24aa:	67ad                	lui	a5,0xb
    24ac:	8007879b          	addiw	a5,a5,-2048
    24b0:	40a7853b          	subw	a0,a5,a0
    24b4:	61e020ef          	jal	ra,4ad2 <sbrk>
    sbrk(-10);
    24b8:	5559                	li	a0,-10
    24ba:	618020ef          	jal	ra,4ad2 <sbrk>
    exit(0);
    24be:	4501                	li	a0,0
    24c0:	58a020ef          	jal	ra,4a4a <exit>
    printf("fork failed\n");
    24c4:	00005517          	auipc	a0,0x5
    24c8:	96450513          	addi	a0,a0,-1692 # 6e28 <malloc+0x1f1a>
    24cc:	189020ef          	jal	ra,4e54 <printf>
    exit(1);
    24d0:	4505                	li	a0,1
    24d2:	578020ef          	jal	ra,4a4a <exit>
  wait(0);
    24d6:	4501                	li	a0,0
    24d8:	57a020ef          	jal	ra,4a52 <wait>
  exit(0);
    24dc:	4501                	li	a0,0
    24de:	56c020ef          	jal	ra,4a4a <exit>

00000000000024e2 <sbrklast>:
{
    24e2:	7179                	addi	sp,sp,-48
    24e4:	f406                	sd	ra,40(sp)
    24e6:	f022                	sd	s0,32(sp)
    24e8:	ec26                	sd	s1,24(sp)
    24ea:	e84a                	sd	s2,16(sp)
    24ec:	e44e                	sd	s3,8(sp)
    24ee:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24f0:	4501                	li	a0,0
    24f2:	5e0020ef          	jal	ra,4ad2 <sbrk>
  if((top % 4096) != 0)
    24f6:	03451793          	slli	a5,a0,0x34
    24fa:	ebb5                	bnez	a5,256e <sbrklast+0x8c>
  sbrk(4096);
    24fc:	6505                	lui	a0,0x1
    24fe:	5d4020ef          	jal	ra,4ad2 <sbrk>
  sbrk(10);
    2502:	4529                	li	a0,10
    2504:	5ce020ef          	jal	ra,4ad2 <sbrk>
  sbrk(-20);
    2508:	5531                	li	a0,-20
    250a:	5c8020ef          	jal	ra,4ad2 <sbrk>
  top = (uint64) sbrk(0);
    250e:	4501                	li	a0,0
    2510:	5c2020ef          	jal	ra,4ad2 <sbrk>
    2514:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2516:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x118>
  p[0] = 'x';
    251a:	07800793          	li	a5,120
    251e:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2522:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2526:	20200593          	li	a1,514
    252a:	854a                	mv	a0,s2
    252c:	55e020ef          	jal	ra,4a8a <open>
    2530:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2532:	4605                	li	a2,1
    2534:	85ca                	mv	a1,s2
    2536:	534020ef          	jal	ra,4a6a <write>
  close(fd);
    253a:	854e                	mv	a0,s3
    253c:	536020ef          	jal	ra,4a72 <close>
  fd = open(p, O_RDWR);
    2540:	4589                	li	a1,2
    2542:	854a                	mv	a0,s2
    2544:	546020ef          	jal	ra,4a8a <open>
  p[0] = '\0';
    2548:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    254c:	4605                	li	a2,1
    254e:	85ca                	mv	a1,s2
    2550:	512020ef          	jal	ra,4a62 <read>
  if(p[0] != 'x')
    2554:	fc04c703          	lbu	a4,-64(s1)
    2558:	07800793          	li	a5,120
    255c:	02f71163          	bne	a4,a5,257e <sbrklast+0x9c>
}
    2560:	70a2                	ld	ra,40(sp)
    2562:	7402                	ld	s0,32(sp)
    2564:	64e2                	ld	s1,24(sp)
    2566:	6942                	ld	s2,16(sp)
    2568:	69a2                	ld	s3,8(sp)
    256a:	6145                	addi	sp,sp,48
    256c:	8082                	ret
    sbrk(4096 - (top % 4096));
    256e:	0347d513          	srli	a0,a5,0x34
    2572:	6785                	lui	a5,0x1
    2574:	40a7853b          	subw	a0,a5,a0
    2578:	55a020ef          	jal	ra,4ad2 <sbrk>
    257c:	b741                	j	24fc <sbrklast+0x1a>
    exit(1);
    257e:	4505                	li	a0,1
    2580:	4ca020ef          	jal	ra,4a4a <exit>

0000000000002584 <sbrk8000>:
{
    2584:	1141                	addi	sp,sp,-16
    2586:	e406                	sd	ra,8(sp)
    2588:	e022                	sd	s0,0(sp)
    258a:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    258c:	80000537          	lui	a0,0x80000
    2590:	0511                	addi	a0,a0,4
    2592:	540020ef          	jal	ra,4ad2 <sbrk>
  volatile char *top = sbrk(0);
    2596:	4501                	li	a0,0
    2598:	53a020ef          	jal	ra,4ad2 <sbrk>
  *(top-1) = *(top-1) + 1;
    259c:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff1387>
    25a0:	0785                	addi	a5,a5,1
    25a2:	0ff7f793          	andi	a5,a5,255
    25a6:	fef50fa3          	sb	a5,-1(a0)
}
    25aa:	60a2                	ld	ra,8(sp)
    25ac:	6402                	ld	s0,0(sp)
    25ae:	0141                	addi	sp,sp,16
    25b0:	8082                	ret

00000000000025b2 <execout>:
{
    25b2:	715d                	addi	sp,sp,-80
    25b4:	e486                	sd	ra,72(sp)
    25b6:	e0a2                	sd	s0,64(sp)
    25b8:	fc26                	sd	s1,56(sp)
    25ba:	f84a                	sd	s2,48(sp)
    25bc:	f44e                	sd	s3,40(sp)
    25be:	f052                	sd	s4,32(sp)
    25c0:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25c2:	4901                	li	s2,0
    25c4:	49bd                	li	s3,15
    int pid = fork();
    25c6:	47c020ef          	jal	ra,4a42 <fork>
    25ca:	84aa                	mv	s1,a0
    if(pid < 0){
    25cc:	00054c63          	bltz	a0,25e4 <execout+0x32>
    } else if(pid == 0){
    25d0:	c11d                	beqz	a0,25f6 <execout+0x44>
      wait((int*)0);
    25d2:	4501                	li	a0,0
    25d4:	47e020ef          	jal	ra,4a52 <wait>
  for(int avail = 0; avail < 15; avail++){
    25d8:	2905                	addiw	s2,s2,1
    25da:	ff3916e3          	bne	s2,s3,25c6 <execout+0x14>
  exit(0);
    25de:	4501                	li	a0,0
    25e0:	46a020ef          	jal	ra,4a4a <exit>
      printf("fork failed\n");
    25e4:	00005517          	auipc	a0,0x5
    25e8:	84450513          	addi	a0,a0,-1980 # 6e28 <malloc+0x1f1a>
    25ec:	069020ef          	jal	ra,4e54 <printf>
      exit(1);
    25f0:	4505                	li	a0,1
    25f2:	458020ef          	jal	ra,4a4a <exit>
        if(a == 0xffffffffffffffffLL)
    25f6:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    25f8:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    25fa:	6505                	lui	a0,0x1
    25fc:	4d6020ef          	jal	ra,4ad2 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2600:	01350763          	beq	a0,s3,260e <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    2604:	6785                	lui	a5,0x1
    2606:	953e                	add	a0,a0,a5
    2608:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x21>
      while(1){
    260c:	b7fd                	j	25fa <execout+0x48>
      for(int i = 0; i < avail; i++)
    260e:	01205863          	blez	s2,261e <execout+0x6c>
        sbrk(-4096);
    2612:	757d                	lui	a0,0xfffff
    2614:	4be020ef          	jal	ra,4ad2 <sbrk>
      for(int i = 0; i < avail; i++)
    2618:	2485                	addiw	s1,s1,1
    261a:	ff249ce3          	bne	s1,s2,2612 <execout+0x60>
      close(1);
    261e:	4505                	li	a0,1
    2620:	452020ef          	jal	ra,4a72 <close>
      char *args[] = { "echo", "x", 0 };
    2624:	00003517          	auipc	a0,0x3
    2628:	a2450513          	addi	a0,a0,-1500 # 5048 <malloc+0x13a>
    262c:	faa43c23          	sd	a0,-72(s0)
    2630:	00003797          	auipc	a5,0x3
    2634:	a8878793          	addi	a5,a5,-1400 # 50b8 <malloc+0x1aa>
    2638:	fcf43023          	sd	a5,-64(s0)
    263c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2640:	fb840593          	addi	a1,s0,-72
    2644:	43e020ef          	jal	ra,4a82 <exec>
      exit(0);
    2648:	4501                	li	a0,0
    264a:	400020ef          	jal	ra,4a4a <exit>

000000000000264e <fourteen>:
{
    264e:	1101                	addi	sp,sp,-32
    2650:	ec06                	sd	ra,24(sp)
    2652:	e822                	sd	s0,16(sp)
    2654:	e426                	sd	s1,8(sp)
    2656:	1000                	addi	s0,sp,32
    2658:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    265a:	00004517          	auipc	a0,0x4
    265e:	a8650513          	addi	a0,a0,-1402 # 60e0 <malloc+0x11d2>
    2662:	450020ef          	jal	ra,4ab2 <mkdir>
    2666:	e555                	bnez	a0,2712 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    2668:	00004517          	auipc	a0,0x4
    266c:	8d050513          	addi	a0,a0,-1840 # 5f38 <malloc+0x102a>
    2670:	442020ef          	jal	ra,4ab2 <mkdir>
    2674:	e94d                	bnez	a0,2726 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2676:	20000593          	li	a1,512
    267a:	00004517          	auipc	a0,0x4
    267e:	91650513          	addi	a0,a0,-1770 # 5f90 <malloc+0x1082>
    2682:	408020ef          	jal	ra,4a8a <open>
  if(fd < 0){
    2686:	0a054a63          	bltz	a0,273a <fourteen+0xec>
  close(fd);
    268a:	3e8020ef          	jal	ra,4a72 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    268e:	4581                	li	a1,0
    2690:	00004517          	auipc	a0,0x4
    2694:	97850513          	addi	a0,a0,-1672 # 6008 <malloc+0x10fa>
    2698:	3f2020ef          	jal	ra,4a8a <open>
  if(fd < 0){
    269c:	0a054963          	bltz	a0,274e <fourteen+0x100>
  close(fd);
    26a0:	3d2020ef          	jal	ra,4a72 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26a4:	00004517          	auipc	a0,0x4
    26a8:	9d450513          	addi	a0,a0,-1580 # 6078 <malloc+0x116a>
    26ac:	406020ef          	jal	ra,4ab2 <mkdir>
    26b0:	c94d                	beqz	a0,2762 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26b2:	00004517          	auipc	a0,0x4
    26b6:	a1e50513          	addi	a0,a0,-1506 # 60d0 <malloc+0x11c2>
    26ba:	3f8020ef          	jal	ra,4ab2 <mkdir>
    26be:	cd45                	beqz	a0,2776 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26c0:	00004517          	auipc	a0,0x4
    26c4:	a1050513          	addi	a0,a0,-1520 # 60d0 <malloc+0x11c2>
    26c8:	3d2020ef          	jal	ra,4a9a <unlink>
  unlink("12345678901234/12345678901234");
    26cc:	00004517          	auipc	a0,0x4
    26d0:	9ac50513          	addi	a0,a0,-1620 # 6078 <malloc+0x116a>
    26d4:	3c6020ef          	jal	ra,4a9a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26d8:	00004517          	auipc	a0,0x4
    26dc:	93050513          	addi	a0,a0,-1744 # 6008 <malloc+0x10fa>
    26e0:	3ba020ef          	jal	ra,4a9a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26e4:	00004517          	auipc	a0,0x4
    26e8:	8ac50513          	addi	a0,a0,-1876 # 5f90 <malloc+0x1082>
    26ec:	3ae020ef          	jal	ra,4a9a <unlink>
  unlink("12345678901234/123456789012345");
    26f0:	00004517          	auipc	a0,0x4
    26f4:	84850513          	addi	a0,a0,-1976 # 5f38 <malloc+0x102a>
    26f8:	3a2020ef          	jal	ra,4a9a <unlink>
  unlink("12345678901234");
    26fc:	00004517          	auipc	a0,0x4
    2700:	9e450513          	addi	a0,a0,-1564 # 60e0 <malloc+0x11d2>
    2704:	396020ef          	jal	ra,4a9a <unlink>
}
    2708:	60e2                	ld	ra,24(sp)
    270a:	6442                	ld	s0,16(sp)
    270c:	64a2                	ld	s1,8(sp)
    270e:	6105                	addi	sp,sp,32
    2710:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2712:	85a6                	mv	a1,s1
    2714:	00003517          	auipc	a0,0x3
    2718:	7fc50513          	addi	a0,a0,2044 # 5f10 <malloc+0x1002>
    271c:	738020ef          	jal	ra,4e54 <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	328020ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2726:	85a6                	mv	a1,s1
    2728:	00004517          	auipc	a0,0x4
    272c:	83050513          	addi	a0,a0,-2000 # 5f58 <malloc+0x104a>
    2730:	724020ef          	jal	ra,4e54 <printf>
    exit(1);
    2734:	4505                	li	a0,1
    2736:	314020ef          	jal	ra,4a4a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    273a:	85a6                	mv	a1,s1
    273c:	00004517          	auipc	a0,0x4
    2740:	88450513          	addi	a0,a0,-1916 # 5fc0 <malloc+0x10b2>
    2744:	710020ef          	jal	ra,4e54 <printf>
    exit(1);
    2748:	4505                	li	a0,1
    274a:	300020ef          	jal	ra,4a4a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    274e:	85a6                	mv	a1,s1
    2750:	00004517          	auipc	a0,0x4
    2754:	8e850513          	addi	a0,a0,-1816 # 6038 <malloc+0x112a>
    2758:	6fc020ef          	jal	ra,4e54 <printf>
    exit(1);
    275c:	4505                	li	a0,1
    275e:	2ec020ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2762:	85a6                	mv	a1,s1
    2764:	00004517          	auipc	a0,0x4
    2768:	93450513          	addi	a0,a0,-1740 # 6098 <malloc+0x118a>
    276c:	6e8020ef          	jal	ra,4e54 <printf>
    exit(1);
    2770:	4505                	li	a0,1
    2772:	2d8020ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2776:	85a6                	mv	a1,s1
    2778:	00004517          	auipc	a0,0x4
    277c:	97850513          	addi	a0,a0,-1672 # 60f0 <malloc+0x11e2>
    2780:	6d4020ef          	jal	ra,4e54 <printf>
    exit(1);
    2784:	4505                	li	a0,1
    2786:	2c4020ef          	jal	ra,4a4a <exit>

000000000000278a <diskfull>:
{
    278a:	b8010113          	addi	sp,sp,-1152
    278e:	46113c23          	sd	ra,1144(sp)
    2792:	46813823          	sd	s0,1136(sp)
    2796:	46913423          	sd	s1,1128(sp)
    279a:	47213023          	sd	s2,1120(sp)
    279e:	45313c23          	sd	s3,1112(sp)
    27a2:	45413823          	sd	s4,1104(sp)
    27a6:	45513423          	sd	s5,1096(sp)
    27aa:	45613023          	sd	s6,1088(sp)
    27ae:	43713c23          	sd	s7,1080(sp)
    27b2:	43813823          	sd	s8,1072(sp)
    27b6:	43913423          	sd	s9,1064(sp)
    27ba:	48010413          	addi	s0,sp,1152
    27be:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27c0:	00004517          	auipc	a0,0x4
    27c4:	96850513          	addi	a0,a0,-1688 # 6128 <malloc+0x121a>
    27c8:	2d2020ef          	jal	ra,4a9a <unlink>
    27cc:	03000993          	li	s3,48
    name[0] = 'b';
    27d0:	06200b13          	li	s6,98
    name[1] = 'i';
    27d4:	06900a93          	li	s5,105
    name[2] = 'g';
    27d8:	06700a13          	li	s4,103
    27dc:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27e0:	07f00c13          	li	s8,127
    27e4:	aab9                	j	2942 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    27e6:	b8040613          	addi	a2,s0,-1152
    27ea:	85e6                	mv	a1,s9
    27ec:	00004517          	auipc	a0,0x4
    27f0:	94c50513          	addi	a0,a0,-1716 # 6138 <malloc+0x122a>
    27f4:	660020ef          	jal	ra,4e54 <printf>
      break;
    27f8:	a039                	j	2806 <diskfull+0x7c>
        close(fd);
    27fa:	854a                	mv	a0,s2
    27fc:	276020ef          	jal	ra,4a72 <close>
    close(fd);
    2800:	854a                	mv	a0,s2
    2802:	270020ef          	jal	ra,4a72 <close>
  for(int i = 0; i < nzz; i++){
    2806:	4481                	li	s1,0
    name[0] = 'z';
    2808:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    280c:	08000993          	li	s3,128
    name[0] = 'z';
    2810:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2814:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2818:	41f4d79b          	sraiw	a5,s1,0x1f
    281c:	01b7d71b          	srliw	a4,a5,0x1b
    2820:	009707bb          	addw	a5,a4,s1
    2824:	4057d69b          	sraiw	a3,a5,0x5
    2828:	0306869b          	addiw	a3,a3,48
    282c:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2830:	8bfd                	andi	a5,a5,31
    2832:	9f99                	subw	a5,a5,a4
    2834:	0307879b          	addiw	a5,a5,48
    2838:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    283c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2840:	ba040513          	addi	a0,s0,-1120
    2844:	256020ef          	jal	ra,4a9a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2848:	60200593          	li	a1,1538
    284c:	ba040513          	addi	a0,s0,-1120
    2850:	23a020ef          	jal	ra,4a8a <open>
    if(fd < 0)
    2854:	00054763          	bltz	a0,2862 <diskfull+0xd8>
    close(fd);
    2858:	21a020ef          	jal	ra,4a72 <close>
  for(int i = 0; i < nzz; i++){
    285c:	2485                	addiw	s1,s1,1
    285e:	fb3499e3          	bne	s1,s3,2810 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    2862:	00004517          	auipc	a0,0x4
    2866:	8c650513          	addi	a0,a0,-1850 # 6128 <malloc+0x121a>
    286a:	248020ef          	jal	ra,4ab2 <mkdir>
    286e:	12050063          	beqz	a0,298e <diskfull+0x204>
  unlink("diskfulldir");
    2872:	00004517          	auipc	a0,0x4
    2876:	8b650513          	addi	a0,a0,-1866 # 6128 <malloc+0x121a>
    287a:	220020ef          	jal	ra,4a9a <unlink>
  for(int i = 0; i < nzz; i++){
    287e:	4481                	li	s1,0
    name[0] = 'z';
    2880:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2884:	08000993          	li	s3,128
    name[0] = 'z';
    2888:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    288c:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2890:	41f4d79b          	sraiw	a5,s1,0x1f
    2894:	01b7d71b          	srliw	a4,a5,0x1b
    2898:	009707bb          	addw	a5,a4,s1
    289c:	4057d69b          	sraiw	a3,a5,0x5
    28a0:	0306869b          	addiw	a3,a3,48
    28a4:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28a8:	8bfd                	andi	a5,a5,31
    28aa:	9f99                	subw	a5,a5,a4
    28ac:	0307879b          	addiw	a5,a5,48
    28b0:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28b4:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28b8:	ba040513          	addi	a0,s0,-1120
    28bc:	1de020ef          	jal	ra,4a9a <unlink>
  for(int i = 0; i < nzz; i++){
    28c0:	2485                	addiw	s1,s1,1
    28c2:	fd3493e3          	bne	s1,s3,2888 <diskfull+0xfe>
    28c6:	03000493          	li	s1,48
    name[0] = 'b';
    28ca:	06200a93          	li	s5,98
    name[1] = 'i';
    28ce:	06900a13          	li	s4,105
    name[2] = 'g';
    28d2:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28d6:	07f00913          	li	s2,127
    name[0] = 'b';
    28da:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28de:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28e2:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28e6:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28ea:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28ee:	ba040513          	addi	a0,s0,-1120
    28f2:	1a8020ef          	jal	ra,4a9a <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28f6:	2485                	addiw	s1,s1,1
    28f8:	0ff4f493          	andi	s1,s1,255
    28fc:	fd249fe3          	bne	s1,s2,28da <diskfull+0x150>
}
    2900:	47813083          	ld	ra,1144(sp)
    2904:	47013403          	ld	s0,1136(sp)
    2908:	46813483          	ld	s1,1128(sp)
    290c:	46013903          	ld	s2,1120(sp)
    2910:	45813983          	ld	s3,1112(sp)
    2914:	45013a03          	ld	s4,1104(sp)
    2918:	44813a83          	ld	s5,1096(sp)
    291c:	44013b03          	ld	s6,1088(sp)
    2920:	43813b83          	ld	s7,1080(sp)
    2924:	43013c03          	ld	s8,1072(sp)
    2928:	42813c83          	ld	s9,1064(sp)
    292c:	48010113          	addi	sp,sp,1152
    2930:	8082                	ret
    close(fd);
    2932:	854a                	mv	a0,s2
    2934:	13e020ef          	jal	ra,4a72 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2938:	2985                	addiw	s3,s3,1
    293a:	0ff9f993          	andi	s3,s3,255
    293e:	ed8984e3          	beq	s3,s8,2806 <diskfull+0x7c>
    name[0] = 'b';
    2942:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    2946:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    294a:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    294e:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2952:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    2956:	b8040513          	addi	a0,s0,-1152
    295a:	140020ef          	jal	ra,4a9a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    295e:	60200593          	li	a1,1538
    2962:	b8040513          	addi	a0,s0,-1152
    2966:	124020ef          	jal	ra,4a8a <open>
    296a:	892a                	mv	s2,a0
    if(fd < 0){
    296c:	e6054de3          	bltz	a0,27e6 <diskfull+0x5c>
    2970:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2972:	40000613          	li	a2,1024
    2976:	ba040593          	addi	a1,s0,-1120
    297a:	854a                	mv	a0,s2
    297c:	0ee020ef          	jal	ra,4a6a <write>
    2980:	40000793          	li	a5,1024
    2984:	e6f51be3          	bne	a0,a5,27fa <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    2988:	34fd                	addiw	s1,s1,-1
    298a:	f4e5                	bnez	s1,2972 <diskfull+0x1e8>
    298c:	b75d                	j	2932 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    298e:	85e6                	mv	a1,s9
    2990:	00003517          	auipc	a0,0x3
    2994:	7c850513          	addi	a0,a0,1992 # 6158 <malloc+0x124a>
    2998:	4bc020ef          	jal	ra,4e54 <printf>
    299c:	bdd9                	j	2872 <diskfull+0xe8>

000000000000299e <iputtest>:
{
    299e:	1101                	addi	sp,sp,-32
    29a0:	ec06                	sd	ra,24(sp)
    29a2:	e822                	sd	s0,16(sp)
    29a4:	e426                	sd	s1,8(sp)
    29a6:	1000                	addi	s0,sp,32
    29a8:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29aa:	00003517          	auipc	a0,0x3
    29ae:	7de50513          	addi	a0,a0,2014 # 6188 <malloc+0x127a>
    29b2:	100020ef          	jal	ra,4ab2 <mkdir>
    29b6:	02054f63          	bltz	a0,29f4 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29ba:	00003517          	auipc	a0,0x3
    29be:	7ce50513          	addi	a0,a0,1998 # 6188 <malloc+0x127a>
    29c2:	0f8020ef          	jal	ra,4aba <chdir>
    29c6:	04054163          	bltz	a0,2a08 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29ca:	00003517          	auipc	a0,0x3
    29ce:	7fe50513          	addi	a0,a0,2046 # 61c8 <malloc+0x12ba>
    29d2:	0c8020ef          	jal	ra,4a9a <unlink>
    29d6:	04054363          	bltz	a0,2a1c <iputtest+0x7e>
  if(chdir("/") < 0){
    29da:	00004517          	auipc	a0,0x4
    29de:	81e50513          	addi	a0,a0,-2018 # 61f8 <malloc+0x12ea>
    29e2:	0d8020ef          	jal	ra,4aba <chdir>
    29e6:	04054563          	bltz	a0,2a30 <iputtest+0x92>
}
    29ea:	60e2                	ld	ra,24(sp)
    29ec:	6442                	ld	s0,16(sp)
    29ee:	64a2                	ld	s1,8(sp)
    29f0:	6105                	addi	sp,sp,32
    29f2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29f4:	85a6                	mv	a1,s1
    29f6:	00003517          	auipc	a0,0x3
    29fa:	79a50513          	addi	a0,a0,1946 # 6190 <malloc+0x1282>
    29fe:	456020ef          	jal	ra,4e54 <printf>
    exit(1);
    2a02:	4505                	li	a0,1
    2a04:	046020ef          	jal	ra,4a4a <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a08:	85a6                	mv	a1,s1
    2a0a:	00003517          	auipc	a0,0x3
    2a0e:	79e50513          	addi	a0,a0,1950 # 61a8 <malloc+0x129a>
    2a12:	442020ef          	jal	ra,4e54 <printf>
    exit(1);
    2a16:	4505                	li	a0,1
    2a18:	032020ef          	jal	ra,4a4a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a1c:	85a6                	mv	a1,s1
    2a1e:	00003517          	auipc	a0,0x3
    2a22:	7ba50513          	addi	a0,a0,1978 # 61d8 <malloc+0x12ca>
    2a26:	42e020ef          	jal	ra,4e54 <printf>
    exit(1);
    2a2a:	4505                	li	a0,1
    2a2c:	01e020ef          	jal	ra,4a4a <exit>
    printf("%s: chdir / failed\n", s);
    2a30:	85a6                	mv	a1,s1
    2a32:	00003517          	auipc	a0,0x3
    2a36:	7ce50513          	addi	a0,a0,1998 # 6200 <malloc+0x12f2>
    2a3a:	41a020ef          	jal	ra,4e54 <printf>
    exit(1);
    2a3e:	4505                	li	a0,1
    2a40:	00a020ef          	jal	ra,4a4a <exit>

0000000000002a44 <exitiputtest>:
{
    2a44:	7179                	addi	sp,sp,-48
    2a46:	f406                	sd	ra,40(sp)
    2a48:	f022                	sd	s0,32(sp)
    2a4a:	ec26                	sd	s1,24(sp)
    2a4c:	1800                	addi	s0,sp,48
    2a4e:	84aa                	mv	s1,a0
  pid = fork();
    2a50:	7f3010ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    2a54:	02054e63          	bltz	a0,2a90 <exitiputtest+0x4c>
  if(pid == 0){
    2a58:	e541                	bnez	a0,2ae0 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a5a:	00003517          	auipc	a0,0x3
    2a5e:	72e50513          	addi	a0,a0,1838 # 6188 <malloc+0x127a>
    2a62:	050020ef          	jal	ra,4ab2 <mkdir>
    2a66:	02054f63          	bltz	a0,2aa4 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a6a:	00003517          	auipc	a0,0x3
    2a6e:	71e50513          	addi	a0,a0,1822 # 6188 <malloc+0x127a>
    2a72:	048020ef          	jal	ra,4aba <chdir>
    2a76:	04054163          	bltz	a0,2ab8 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a7a:	00003517          	auipc	a0,0x3
    2a7e:	74e50513          	addi	a0,a0,1870 # 61c8 <malloc+0x12ba>
    2a82:	018020ef          	jal	ra,4a9a <unlink>
    2a86:	04054363          	bltz	a0,2acc <exitiputtest+0x88>
    exit(0);
    2a8a:	4501                	li	a0,0
    2a8c:	7bf010ef          	jal	ra,4a4a <exit>
    printf("%s: fork failed\n", s);
    2a90:	85a6                	mv	a1,s1
    2a92:	00003517          	auipc	a0,0x3
    2a96:	e4650513          	addi	a0,a0,-442 # 58d8 <malloc+0x9ca>
    2a9a:	3ba020ef          	jal	ra,4e54 <printf>
    exit(1);
    2a9e:	4505                	li	a0,1
    2aa0:	7ab010ef          	jal	ra,4a4a <exit>
      printf("%s: mkdir failed\n", s);
    2aa4:	85a6                	mv	a1,s1
    2aa6:	00003517          	auipc	a0,0x3
    2aaa:	6ea50513          	addi	a0,a0,1770 # 6190 <malloc+0x1282>
    2aae:	3a6020ef          	jal	ra,4e54 <printf>
      exit(1);
    2ab2:	4505                	li	a0,1
    2ab4:	797010ef          	jal	ra,4a4a <exit>
      printf("%s: child chdir failed\n", s);
    2ab8:	85a6                	mv	a1,s1
    2aba:	00003517          	auipc	a0,0x3
    2abe:	75e50513          	addi	a0,a0,1886 # 6218 <malloc+0x130a>
    2ac2:	392020ef          	jal	ra,4e54 <printf>
      exit(1);
    2ac6:	4505                	li	a0,1
    2ac8:	783010ef          	jal	ra,4a4a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2acc:	85a6                	mv	a1,s1
    2ace:	00003517          	auipc	a0,0x3
    2ad2:	70a50513          	addi	a0,a0,1802 # 61d8 <malloc+0x12ca>
    2ad6:	37e020ef          	jal	ra,4e54 <printf>
      exit(1);
    2ada:	4505                	li	a0,1
    2adc:	76f010ef          	jal	ra,4a4a <exit>
  wait(&xstatus);
    2ae0:	fdc40513          	addi	a0,s0,-36
    2ae4:	76f010ef          	jal	ra,4a52 <wait>
  exit(xstatus);
    2ae8:	fdc42503          	lw	a0,-36(s0)
    2aec:	75f010ef          	jal	ra,4a4a <exit>

0000000000002af0 <dirtest>:
{
    2af0:	1101                	addi	sp,sp,-32
    2af2:	ec06                	sd	ra,24(sp)
    2af4:	e822                	sd	s0,16(sp)
    2af6:	e426                	sd	s1,8(sp)
    2af8:	1000                	addi	s0,sp,32
    2afa:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2afc:	00003517          	auipc	a0,0x3
    2b00:	73450513          	addi	a0,a0,1844 # 6230 <malloc+0x1322>
    2b04:	7af010ef          	jal	ra,4ab2 <mkdir>
    2b08:	02054f63          	bltz	a0,2b46 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b0c:	00003517          	auipc	a0,0x3
    2b10:	72450513          	addi	a0,a0,1828 # 6230 <malloc+0x1322>
    2b14:	7a7010ef          	jal	ra,4aba <chdir>
    2b18:	04054163          	bltz	a0,2b5a <dirtest+0x6a>
  if(chdir("..") < 0){
    2b1c:	00003517          	auipc	a0,0x3
    2b20:	73450513          	addi	a0,a0,1844 # 6250 <malloc+0x1342>
    2b24:	797010ef          	jal	ra,4aba <chdir>
    2b28:	04054363          	bltz	a0,2b6e <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b2c:	00003517          	auipc	a0,0x3
    2b30:	70450513          	addi	a0,a0,1796 # 6230 <malloc+0x1322>
    2b34:	767010ef          	jal	ra,4a9a <unlink>
    2b38:	04054563          	bltz	a0,2b82 <dirtest+0x92>
}
    2b3c:	60e2                	ld	ra,24(sp)
    2b3e:	6442                	ld	s0,16(sp)
    2b40:	64a2                	ld	s1,8(sp)
    2b42:	6105                	addi	sp,sp,32
    2b44:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b46:	85a6                	mv	a1,s1
    2b48:	00003517          	auipc	a0,0x3
    2b4c:	64850513          	addi	a0,a0,1608 # 6190 <malloc+0x1282>
    2b50:	304020ef          	jal	ra,4e54 <printf>
    exit(1);
    2b54:	4505                	li	a0,1
    2b56:	6f5010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b5a:	85a6                	mv	a1,s1
    2b5c:	00003517          	auipc	a0,0x3
    2b60:	6dc50513          	addi	a0,a0,1756 # 6238 <malloc+0x132a>
    2b64:	2f0020ef          	jal	ra,4e54 <printf>
    exit(1);
    2b68:	4505                	li	a0,1
    2b6a:	6e1010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir .. failed\n", s);
    2b6e:	85a6                	mv	a1,s1
    2b70:	00003517          	auipc	a0,0x3
    2b74:	6e850513          	addi	a0,a0,1768 # 6258 <malloc+0x134a>
    2b78:	2dc020ef          	jal	ra,4e54 <printf>
    exit(1);
    2b7c:	4505                	li	a0,1
    2b7e:	6cd010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b82:	85a6                	mv	a1,s1
    2b84:	00003517          	auipc	a0,0x3
    2b88:	6ec50513          	addi	a0,a0,1772 # 6270 <malloc+0x1362>
    2b8c:	2c8020ef          	jal	ra,4e54 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	6b9010ef          	jal	ra,4a4a <exit>

0000000000002b96 <subdir>:
{
    2b96:	1101                	addi	sp,sp,-32
    2b98:	ec06                	sd	ra,24(sp)
    2b9a:	e822                	sd	s0,16(sp)
    2b9c:	e426                	sd	s1,8(sp)
    2b9e:	e04a                	sd	s2,0(sp)
    2ba0:	1000                	addi	s0,sp,32
    2ba2:	892a                	mv	s2,a0
  unlink("ff");
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	81450513          	addi	a0,a0,-2028 # 63b8 <malloc+0x14aa>
    2bac:	6ef010ef          	jal	ra,4a9a <unlink>
  if(mkdir("dd") != 0){
    2bb0:	00003517          	auipc	a0,0x3
    2bb4:	6d850513          	addi	a0,a0,1752 # 6288 <malloc+0x137a>
    2bb8:	6fb010ef          	jal	ra,4ab2 <mkdir>
    2bbc:	2e051263          	bnez	a0,2ea0 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bc0:	20200593          	li	a1,514
    2bc4:	00003517          	auipc	a0,0x3
    2bc8:	6e450513          	addi	a0,a0,1764 # 62a8 <malloc+0x139a>
    2bcc:	6bf010ef          	jal	ra,4a8a <open>
    2bd0:	84aa                	mv	s1,a0
  if(fd < 0){
    2bd2:	2e054163          	bltz	a0,2eb4 <subdir+0x31e>
  write(fd, "ff", 2);
    2bd6:	4609                	li	a2,2
    2bd8:	00003597          	auipc	a1,0x3
    2bdc:	7e058593          	addi	a1,a1,2016 # 63b8 <malloc+0x14aa>
    2be0:	68b010ef          	jal	ra,4a6a <write>
  close(fd);
    2be4:	8526                	mv	a0,s1
    2be6:	68d010ef          	jal	ra,4a72 <close>
  if(unlink("dd") >= 0){
    2bea:	00003517          	auipc	a0,0x3
    2bee:	69e50513          	addi	a0,a0,1694 # 6288 <malloc+0x137a>
    2bf2:	6a9010ef          	jal	ra,4a9a <unlink>
    2bf6:	2c055963          	bgez	a0,2ec8 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2bfa:	00003517          	auipc	a0,0x3
    2bfe:	70650513          	addi	a0,a0,1798 # 6300 <malloc+0x13f2>
    2c02:	6b1010ef          	jal	ra,4ab2 <mkdir>
    2c06:	2c051b63          	bnez	a0,2edc <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c0a:	20200593          	li	a1,514
    2c0e:	00003517          	auipc	a0,0x3
    2c12:	71a50513          	addi	a0,a0,1818 # 6328 <malloc+0x141a>
    2c16:	675010ef          	jal	ra,4a8a <open>
    2c1a:	84aa                	mv	s1,a0
  if(fd < 0){
    2c1c:	2c054a63          	bltz	a0,2ef0 <subdir+0x35a>
  write(fd, "FF", 2);
    2c20:	4609                	li	a2,2
    2c22:	00003597          	auipc	a1,0x3
    2c26:	73658593          	addi	a1,a1,1846 # 6358 <malloc+0x144a>
    2c2a:	641010ef          	jal	ra,4a6a <write>
  close(fd);
    2c2e:	8526                	mv	a0,s1
    2c30:	643010ef          	jal	ra,4a72 <close>
  fd = open("dd/dd/../ff", 0);
    2c34:	4581                	li	a1,0
    2c36:	00003517          	auipc	a0,0x3
    2c3a:	72a50513          	addi	a0,a0,1834 # 6360 <malloc+0x1452>
    2c3e:	64d010ef          	jal	ra,4a8a <open>
    2c42:	84aa                	mv	s1,a0
  if(fd < 0){
    2c44:	2c054063          	bltz	a0,2f04 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c48:	660d                	lui	a2,0x3
    2c4a:	00009597          	auipc	a1,0x9
    2c4e:	02e58593          	addi	a1,a1,46 # bc78 <buf>
    2c52:	611010ef          	jal	ra,4a62 <read>
  if(cc != 2 || buf[0] != 'f'){
    2c56:	4789                	li	a5,2
    2c58:	2cf51063          	bne	a0,a5,2f18 <subdir+0x382>
    2c5c:	00009717          	auipc	a4,0x9
    2c60:	01c74703          	lbu	a4,28(a4) # bc78 <buf>
    2c64:	06600793          	li	a5,102
    2c68:	2af71863          	bne	a4,a5,2f18 <subdir+0x382>
  close(fd);
    2c6c:	8526                	mv	a0,s1
    2c6e:	605010ef          	jal	ra,4a72 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c72:	00003597          	auipc	a1,0x3
    2c76:	73e58593          	addi	a1,a1,1854 # 63b0 <malloc+0x14a2>
    2c7a:	00003517          	auipc	a0,0x3
    2c7e:	6ae50513          	addi	a0,a0,1710 # 6328 <malloc+0x141a>
    2c82:	629010ef          	jal	ra,4aaa <link>
    2c86:	2a051363          	bnez	a0,2f2c <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c8a:	00003517          	auipc	a0,0x3
    2c8e:	69e50513          	addi	a0,a0,1694 # 6328 <malloc+0x141a>
    2c92:	609010ef          	jal	ra,4a9a <unlink>
    2c96:	2a051563          	bnez	a0,2f40 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c9a:	4581                	li	a1,0
    2c9c:	00003517          	auipc	a0,0x3
    2ca0:	68c50513          	addi	a0,a0,1676 # 6328 <malloc+0x141a>
    2ca4:	5e7010ef          	jal	ra,4a8a <open>
    2ca8:	2a055663          	bgez	a0,2f54 <subdir+0x3be>
  if(chdir("dd") != 0){
    2cac:	00003517          	auipc	a0,0x3
    2cb0:	5dc50513          	addi	a0,a0,1500 # 6288 <malloc+0x137a>
    2cb4:	607010ef          	jal	ra,4aba <chdir>
    2cb8:	2a051863          	bnez	a0,2f68 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2cbc:	00003517          	auipc	a0,0x3
    2cc0:	78c50513          	addi	a0,a0,1932 # 6448 <malloc+0x153a>
    2cc4:	5f7010ef          	jal	ra,4aba <chdir>
    2cc8:	2a051a63          	bnez	a0,2f7c <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2ccc:	00003517          	auipc	a0,0x3
    2cd0:	7ac50513          	addi	a0,a0,1964 # 6478 <malloc+0x156a>
    2cd4:	5e7010ef          	jal	ra,4aba <chdir>
    2cd8:	2a051c63          	bnez	a0,2f90 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cdc:	00003517          	auipc	a0,0x3
    2ce0:	7d450513          	addi	a0,a0,2004 # 64b0 <malloc+0x15a2>
    2ce4:	5d7010ef          	jal	ra,4aba <chdir>
    2ce8:	2a051e63          	bnez	a0,2fa4 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cec:	4581                	li	a1,0
    2cee:	00003517          	auipc	a0,0x3
    2cf2:	6c250513          	addi	a0,a0,1730 # 63b0 <malloc+0x14a2>
    2cf6:	595010ef          	jal	ra,4a8a <open>
    2cfa:	84aa                	mv	s1,a0
  if(fd < 0){
    2cfc:	2a054e63          	bltz	a0,2fb8 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d00:	660d                	lui	a2,0x3
    2d02:	00009597          	auipc	a1,0x9
    2d06:	f7658593          	addi	a1,a1,-138 # bc78 <buf>
    2d0a:	559010ef          	jal	ra,4a62 <read>
    2d0e:	4789                	li	a5,2
    2d10:	2af51e63          	bne	a0,a5,2fcc <subdir+0x436>
  close(fd);
    2d14:	8526                	mv	a0,s1
    2d16:	55d010ef          	jal	ra,4a72 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d1a:	4581                	li	a1,0
    2d1c:	00003517          	auipc	a0,0x3
    2d20:	60c50513          	addi	a0,a0,1548 # 6328 <malloc+0x141a>
    2d24:	567010ef          	jal	ra,4a8a <open>
    2d28:	2a055c63          	bgez	a0,2fe0 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d2c:	20200593          	li	a1,514
    2d30:	00004517          	auipc	a0,0x4
    2d34:	81050513          	addi	a0,a0,-2032 # 6540 <malloc+0x1632>
    2d38:	553010ef          	jal	ra,4a8a <open>
    2d3c:	2a055c63          	bgez	a0,2ff4 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d40:	20200593          	li	a1,514
    2d44:	00004517          	auipc	a0,0x4
    2d48:	82c50513          	addi	a0,a0,-2004 # 6570 <malloc+0x1662>
    2d4c:	53f010ef          	jal	ra,4a8a <open>
    2d50:	2a055c63          	bgez	a0,3008 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d54:	20000593          	li	a1,512
    2d58:	00003517          	auipc	a0,0x3
    2d5c:	53050513          	addi	a0,a0,1328 # 6288 <malloc+0x137a>
    2d60:	52b010ef          	jal	ra,4a8a <open>
    2d64:	2a055c63          	bgez	a0,301c <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d68:	4589                	li	a1,2
    2d6a:	00003517          	auipc	a0,0x3
    2d6e:	51e50513          	addi	a0,a0,1310 # 6288 <malloc+0x137a>
    2d72:	519010ef          	jal	ra,4a8a <open>
    2d76:	2a055d63          	bgez	a0,3030 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d7a:	4585                	li	a1,1
    2d7c:	00003517          	auipc	a0,0x3
    2d80:	50c50513          	addi	a0,a0,1292 # 6288 <malloc+0x137a>
    2d84:	507010ef          	jal	ra,4a8a <open>
    2d88:	2a055e63          	bgez	a0,3044 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d8c:	00004597          	auipc	a1,0x4
    2d90:	87458593          	addi	a1,a1,-1932 # 6600 <malloc+0x16f2>
    2d94:	00003517          	auipc	a0,0x3
    2d98:	7ac50513          	addi	a0,a0,1964 # 6540 <malloc+0x1632>
    2d9c:	50f010ef          	jal	ra,4aaa <link>
    2da0:	2a050c63          	beqz	a0,3058 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2da4:	00004597          	auipc	a1,0x4
    2da8:	85c58593          	addi	a1,a1,-1956 # 6600 <malloc+0x16f2>
    2dac:	00003517          	auipc	a0,0x3
    2db0:	7c450513          	addi	a0,a0,1988 # 6570 <malloc+0x1662>
    2db4:	4f7010ef          	jal	ra,4aaa <link>
    2db8:	2a050a63          	beqz	a0,306c <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2dbc:	00003597          	auipc	a1,0x3
    2dc0:	5f458593          	addi	a1,a1,1524 # 63b0 <malloc+0x14a2>
    2dc4:	00003517          	auipc	a0,0x3
    2dc8:	4e450513          	addi	a0,a0,1252 # 62a8 <malloc+0x139a>
    2dcc:	4df010ef          	jal	ra,4aaa <link>
    2dd0:	2a050863          	beqz	a0,3080 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dd4:	00003517          	auipc	a0,0x3
    2dd8:	76c50513          	addi	a0,a0,1900 # 6540 <malloc+0x1632>
    2ddc:	4d7010ef          	jal	ra,4ab2 <mkdir>
    2de0:	2a050a63          	beqz	a0,3094 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2de4:	00003517          	auipc	a0,0x3
    2de8:	78c50513          	addi	a0,a0,1932 # 6570 <malloc+0x1662>
    2dec:	4c7010ef          	jal	ra,4ab2 <mkdir>
    2df0:	2a050c63          	beqz	a0,30a8 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2df4:	00003517          	auipc	a0,0x3
    2df8:	5bc50513          	addi	a0,a0,1468 # 63b0 <malloc+0x14a2>
    2dfc:	4b7010ef          	jal	ra,4ab2 <mkdir>
    2e00:	2a050e63          	beqz	a0,30bc <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e04:	00003517          	auipc	a0,0x3
    2e08:	76c50513          	addi	a0,a0,1900 # 6570 <malloc+0x1662>
    2e0c:	48f010ef          	jal	ra,4a9a <unlink>
    2e10:	2c050063          	beqz	a0,30d0 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e14:	00003517          	auipc	a0,0x3
    2e18:	72c50513          	addi	a0,a0,1836 # 6540 <malloc+0x1632>
    2e1c:	47f010ef          	jal	ra,4a9a <unlink>
    2e20:	2c050263          	beqz	a0,30e4 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e24:	00003517          	auipc	a0,0x3
    2e28:	48450513          	addi	a0,a0,1156 # 62a8 <malloc+0x139a>
    2e2c:	48f010ef          	jal	ra,4aba <chdir>
    2e30:	2c050463          	beqz	a0,30f8 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e34:	00004517          	auipc	a0,0x4
    2e38:	91c50513          	addi	a0,a0,-1764 # 6750 <malloc+0x1842>
    2e3c:	47f010ef          	jal	ra,4aba <chdir>
    2e40:	2c050663          	beqz	a0,310c <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e44:	00003517          	auipc	a0,0x3
    2e48:	56c50513          	addi	a0,a0,1388 # 63b0 <malloc+0x14a2>
    2e4c:	44f010ef          	jal	ra,4a9a <unlink>
    2e50:	2c051863          	bnez	a0,3120 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e54:	00003517          	auipc	a0,0x3
    2e58:	45450513          	addi	a0,a0,1108 # 62a8 <malloc+0x139a>
    2e5c:	43f010ef          	jal	ra,4a9a <unlink>
    2e60:	2c051a63          	bnez	a0,3134 <subdir+0x59e>
  if(unlink("dd") == 0){
    2e64:	00003517          	auipc	a0,0x3
    2e68:	42450513          	addi	a0,a0,1060 # 6288 <malloc+0x137a>
    2e6c:	42f010ef          	jal	ra,4a9a <unlink>
    2e70:	2c050c63          	beqz	a0,3148 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e74:	00004517          	auipc	a0,0x4
    2e78:	94c50513          	addi	a0,a0,-1716 # 67c0 <malloc+0x18b2>
    2e7c:	41f010ef          	jal	ra,4a9a <unlink>
    2e80:	2c054e63          	bltz	a0,315c <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e84:	00003517          	auipc	a0,0x3
    2e88:	40450513          	addi	a0,a0,1028 # 6288 <malloc+0x137a>
    2e8c:	40f010ef          	jal	ra,4a9a <unlink>
    2e90:	2e054063          	bltz	a0,3170 <subdir+0x5da>
}
    2e94:	60e2                	ld	ra,24(sp)
    2e96:	6442                	ld	s0,16(sp)
    2e98:	64a2                	ld	s1,8(sp)
    2e9a:	6902                	ld	s2,0(sp)
    2e9c:	6105                	addi	sp,sp,32
    2e9e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2ea0:	85ca                	mv	a1,s2
    2ea2:	00003517          	auipc	a0,0x3
    2ea6:	3ee50513          	addi	a0,a0,1006 # 6290 <malloc+0x1382>
    2eaa:	7ab010ef          	jal	ra,4e54 <printf>
    exit(1);
    2eae:	4505                	li	a0,1
    2eb0:	39b010ef          	jal	ra,4a4a <exit>
    printf("%s: create dd/ff failed\n", s);
    2eb4:	85ca                	mv	a1,s2
    2eb6:	00003517          	auipc	a0,0x3
    2eba:	3fa50513          	addi	a0,a0,1018 # 62b0 <malloc+0x13a2>
    2ebe:	797010ef          	jal	ra,4e54 <printf>
    exit(1);
    2ec2:	4505                	li	a0,1
    2ec4:	387010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ec8:	85ca                	mv	a1,s2
    2eca:	00003517          	auipc	a0,0x3
    2ece:	40650513          	addi	a0,a0,1030 # 62d0 <malloc+0x13c2>
    2ed2:	783010ef          	jal	ra,4e54 <printf>
    exit(1);
    2ed6:	4505                	li	a0,1
    2ed8:	373010ef          	jal	ra,4a4a <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2edc:	85ca                	mv	a1,s2
    2ede:	00003517          	auipc	a0,0x3
    2ee2:	42a50513          	addi	a0,a0,1066 # 6308 <malloc+0x13fa>
    2ee6:	76f010ef          	jal	ra,4e54 <printf>
    exit(1);
    2eea:	4505                	li	a0,1
    2eec:	35f010ef          	jal	ra,4a4a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ef0:	85ca                	mv	a1,s2
    2ef2:	00003517          	auipc	a0,0x3
    2ef6:	44650513          	addi	a0,a0,1094 # 6338 <malloc+0x142a>
    2efa:	75b010ef          	jal	ra,4e54 <printf>
    exit(1);
    2efe:	4505                	li	a0,1
    2f00:	34b010ef          	jal	ra,4a4a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f04:	85ca                	mv	a1,s2
    2f06:	00003517          	auipc	a0,0x3
    2f0a:	46a50513          	addi	a0,a0,1130 # 6370 <malloc+0x1462>
    2f0e:	747010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f12:	4505                	li	a0,1
    2f14:	337010ef          	jal	ra,4a4a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f18:	85ca                	mv	a1,s2
    2f1a:	00003517          	auipc	a0,0x3
    2f1e:	47650513          	addi	a0,a0,1142 # 6390 <malloc+0x1482>
    2f22:	733010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f26:	4505                	li	a0,1
    2f28:	323010ef          	jal	ra,4a4a <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f2c:	85ca                	mv	a1,s2
    2f2e:	00003517          	auipc	a0,0x3
    2f32:	49250513          	addi	a0,a0,1170 # 63c0 <malloc+0x14b2>
    2f36:	71f010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f3a:	4505                	li	a0,1
    2f3c:	30f010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f40:	85ca                	mv	a1,s2
    2f42:	00003517          	auipc	a0,0x3
    2f46:	4a650513          	addi	a0,a0,1190 # 63e8 <malloc+0x14da>
    2f4a:	70b010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	2fb010ef          	jal	ra,4a4a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f54:	85ca                	mv	a1,s2
    2f56:	00003517          	auipc	a0,0x3
    2f5a:	4b250513          	addi	a0,a0,1202 # 6408 <malloc+0x14fa>
    2f5e:	6f7010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f62:	4505                	li	a0,1
    2f64:	2e7010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dd failed\n", s);
    2f68:	85ca                	mv	a1,s2
    2f6a:	00003517          	auipc	a0,0x3
    2f6e:	4c650513          	addi	a0,a0,1222 # 6430 <malloc+0x1522>
    2f72:	6e3010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f76:	4505                	li	a0,1
    2f78:	2d3010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f7c:	85ca                	mv	a1,s2
    2f7e:	00003517          	auipc	a0,0x3
    2f82:	4da50513          	addi	a0,a0,1242 # 6458 <malloc+0x154a>
    2f86:	6cf010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f8a:	4505                	li	a0,1
    2f8c:	2bf010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f90:	85ca                	mv	a1,s2
    2f92:	00003517          	auipc	a0,0x3
    2f96:	4f650513          	addi	a0,a0,1270 # 6488 <malloc+0x157a>
    2f9a:	6bb010ef          	jal	ra,4e54 <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	2ab010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir ./.. failed\n", s);
    2fa4:	85ca                	mv	a1,s2
    2fa6:	00003517          	auipc	a0,0x3
    2faa:	51250513          	addi	a0,a0,1298 # 64b8 <malloc+0x15aa>
    2fae:	6a7010ef          	jal	ra,4e54 <printf>
    exit(1);
    2fb2:	4505                	li	a0,1
    2fb4:	297010ef          	jal	ra,4a4a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fb8:	85ca                	mv	a1,s2
    2fba:	00003517          	auipc	a0,0x3
    2fbe:	51650513          	addi	a0,a0,1302 # 64d0 <malloc+0x15c2>
    2fc2:	693010ef          	jal	ra,4e54 <printf>
    exit(1);
    2fc6:	4505                	li	a0,1
    2fc8:	283010ef          	jal	ra,4a4a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fcc:	85ca                	mv	a1,s2
    2fce:	00003517          	auipc	a0,0x3
    2fd2:	52250513          	addi	a0,a0,1314 # 64f0 <malloc+0x15e2>
    2fd6:	67f010ef          	jal	ra,4e54 <printf>
    exit(1);
    2fda:	4505                	li	a0,1
    2fdc:	26f010ef          	jal	ra,4a4a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fe0:	85ca                	mv	a1,s2
    2fe2:	00003517          	auipc	a0,0x3
    2fe6:	52e50513          	addi	a0,a0,1326 # 6510 <malloc+0x1602>
    2fea:	66b010ef          	jal	ra,4e54 <printf>
    exit(1);
    2fee:	4505                	li	a0,1
    2ff0:	25b010ef          	jal	ra,4a4a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2ff4:	85ca                	mv	a1,s2
    2ff6:	00003517          	auipc	a0,0x3
    2ffa:	55a50513          	addi	a0,a0,1370 # 6550 <malloc+0x1642>
    2ffe:	657010ef          	jal	ra,4e54 <printf>
    exit(1);
    3002:	4505                	li	a0,1
    3004:	247010ef          	jal	ra,4a4a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3008:	85ca                	mv	a1,s2
    300a:	00003517          	auipc	a0,0x3
    300e:	57650513          	addi	a0,a0,1398 # 6580 <malloc+0x1672>
    3012:	643010ef          	jal	ra,4e54 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	233010ef          	jal	ra,4a4a <exit>
    printf("%s: create dd succeeded!\n", s);
    301c:	85ca                	mv	a1,s2
    301e:	00003517          	auipc	a0,0x3
    3022:	58250513          	addi	a0,a0,1410 # 65a0 <malloc+0x1692>
    3026:	62f010ef          	jal	ra,4e54 <printf>
    exit(1);
    302a:	4505                	li	a0,1
    302c:	21f010ef          	jal	ra,4a4a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3030:	85ca                	mv	a1,s2
    3032:	00003517          	auipc	a0,0x3
    3036:	58e50513          	addi	a0,a0,1422 # 65c0 <malloc+0x16b2>
    303a:	61b010ef          	jal	ra,4e54 <printf>
    exit(1);
    303e:	4505                	li	a0,1
    3040:	20b010ef          	jal	ra,4a4a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3044:	85ca                	mv	a1,s2
    3046:	00003517          	auipc	a0,0x3
    304a:	59a50513          	addi	a0,a0,1434 # 65e0 <malloc+0x16d2>
    304e:	607010ef          	jal	ra,4e54 <printf>
    exit(1);
    3052:	4505                	li	a0,1
    3054:	1f7010ef          	jal	ra,4a4a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3058:	85ca                	mv	a1,s2
    305a:	00003517          	auipc	a0,0x3
    305e:	5b650513          	addi	a0,a0,1462 # 6610 <malloc+0x1702>
    3062:	5f3010ef          	jal	ra,4e54 <printf>
    exit(1);
    3066:	4505                	li	a0,1
    3068:	1e3010ef          	jal	ra,4a4a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    306c:	85ca                	mv	a1,s2
    306e:	00003517          	auipc	a0,0x3
    3072:	5ca50513          	addi	a0,a0,1482 # 6638 <malloc+0x172a>
    3076:	5df010ef          	jal	ra,4e54 <printf>
    exit(1);
    307a:	4505                	li	a0,1
    307c:	1cf010ef          	jal	ra,4a4a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3080:	85ca                	mv	a1,s2
    3082:	00003517          	auipc	a0,0x3
    3086:	5de50513          	addi	a0,a0,1502 # 6660 <malloc+0x1752>
    308a:	5cb010ef          	jal	ra,4e54 <printf>
    exit(1);
    308e:	4505                	li	a0,1
    3090:	1bb010ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3094:	85ca                	mv	a1,s2
    3096:	00003517          	auipc	a0,0x3
    309a:	5f250513          	addi	a0,a0,1522 # 6688 <malloc+0x177a>
    309e:	5b7010ef          	jal	ra,4e54 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	1a7010ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30a8:	85ca                	mv	a1,s2
    30aa:	00003517          	auipc	a0,0x3
    30ae:	5fe50513          	addi	a0,a0,1534 # 66a8 <malloc+0x179a>
    30b2:	5a3010ef          	jal	ra,4e54 <printf>
    exit(1);
    30b6:	4505                	li	a0,1
    30b8:	193010ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30bc:	85ca                	mv	a1,s2
    30be:	00003517          	auipc	a0,0x3
    30c2:	60a50513          	addi	a0,a0,1546 # 66c8 <malloc+0x17ba>
    30c6:	58f010ef          	jal	ra,4e54 <printf>
    exit(1);
    30ca:	4505                	li	a0,1
    30cc:	17f010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30d0:	85ca                	mv	a1,s2
    30d2:	00003517          	auipc	a0,0x3
    30d6:	61e50513          	addi	a0,a0,1566 # 66f0 <malloc+0x17e2>
    30da:	57b010ef          	jal	ra,4e54 <printf>
    exit(1);
    30de:	4505                	li	a0,1
    30e0:	16b010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00003517          	auipc	a0,0x3
    30ea:	62a50513          	addi	a0,a0,1578 # 6710 <malloc+0x1802>
    30ee:	567010ef          	jal	ra,4e54 <printf>
    exit(1);
    30f2:	4505                	li	a0,1
    30f4:	157010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30f8:	85ca                	mv	a1,s2
    30fa:	00003517          	auipc	a0,0x3
    30fe:	63650513          	addi	a0,a0,1590 # 6730 <malloc+0x1822>
    3102:	553010ef          	jal	ra,4e54 <printf>
    exit(1);
    3106:	4505                	li	a0,1
    3108:	143010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    310c:	85ca                	mv	a1,s2
    310e:	00003517          	auipc	a0,0x3
    3112:	64a50513          	addi	a0,a0,1610 # 6758 <malloc+0x184a>
    3116:	53f010ef          	jal	ra,4e54 <printf>
    exit(1);
    311a:	4505                	li	a0,1
    311c:	12f010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3120:	85ca                	mv	a1,s2
    3122:	00003517          	auipc	a0,0x3
    3126:	2c650513          	addi	a0,a0,710 # 63e8 <malloc+0x14da>
    312a:	52b010ef          	jal	ra,4e54 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	11b010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3134:	85ca                	mv	a1,s2
    3136:	00003517          	auipc	a0,0x3
    313a:	64250513          	addi	a0,a0,1602 # 6778 <malloc+0x186a>
    313e:	517010ef          	jal	ra,4e54 <printf>
    exit(1);
    3142:	4505                	li	a0,1
    3144:	107010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3148:	85ca                	mv	a1,s2
    314a:	00003517          	auipc	a0,0x3
    314e:	64e50513          	addi	a0,a0,1614 # 6798 <malloc+0x188a>
    3152:	503010ef          	jal	ra,4e54 <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	0f3010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    315c:	85ca                	mv	a1,s2
    315e:	00003517          	auipc	a0,0x3
    3162:	66a50513          	addi	a0,a0,1642 # 67c8 <malloc+0x18ba>
    3166:	4ef010ef          	jal	ra,4e54 <printf>
    exit(1);
    316a:	4505                	li	a0,1
    316c:	0df010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dd failed\n", s);
    3170:	85ca                	mv	a1,s2
    3172:	00003517          	auipc	a0,0x3
    3176:	67650513          	addi	a0,a0,1654 # 67e8 <malloc+0x18da>
    317a:	4db010ef          	jal	ra,4e54 <printf>
    exit(1);
    317e:	4505                	li	a0,1
    3180:	0cb010ef          	jal	ra,4a4a <exit>

0000000000003184 <rmdot>:
{
    3184:	1101                	addi	sp,sp,-32
    3186:	ec06                	sd	ra,24(sp)
    3188:	e822                	sd	s0,16(sp)
    318a:	e426                	sd	s1,8(sp)
    318c:	1000                	addi	s0,sp,32
    318e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3190:	00003517          	auipc	a0,0x3
    3194:	67050513          	addi	a0,a0,1648 # 6800 <malloc+0x18f2>
    3198:	11b010ef          	jal	ra,4ab2 <mkdir>
    319c:	e53d                	bnez	a0,320a <rmdot+0x86>
  if(chdir("dots") != 0){
    319e:	00003517          	auipc	a0,0x3
    31a2:	66250513          	addi	a0,a0,1634 # 6800 <malloc+0x18f2>
    31a6:	115010ef          	jal	ra,4aba <chdir>
    31aa:	e935                	bnez	a0,321e <rmdot+0x9a>
  if(unlink(".") == 0){
    31ac:	00002517          	auipc	a0,0x2
    31b0:	58450513          	addi	a0,a0,1412 # 5730 <malloc+0x822>
    31b4:	0e7010ef          	jal	ra,4a9a <unlink>
    31b8:	cd2d                	beqz	a0,3232 <rmdot+0xae>
  if(unlink("..") == 0){
    31ba:	00003517          	auipc	a0,0x3
    31be:	09650513          	addi	a0,a0,150 # 6250 <malloc+0x1342>
    31c2:	0d9010ef          	jal	ra,4a9a <unlink>
    31c6:	c141                	beqz	a0,3246 <rmdot+0xc2>
  if(chdir("/") != 0){
    31c8:	00003517          	auipc	a0,0x3
    31cc:	03050513          	addi	a0,a0,48 # 61f8 <malloc+0x12ea>
    31d0:	0eb010ef          	jal	ra,4aba <chdir>
    31d4:	e159                	bnez	a0,325a <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31d6:	00003517          	auipc	a0,0x3
    31da:	69250513          	addi	a0,a0,1682 # 6868 <malloc+0x195a>
    31de:	0bd010ef          	jal	ra,4a9a <unlink>
    31e2:	c551                	beqz	a0,326e <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31e4:	00003517          	auipc	a0,0x3
    31e8:	6ac50513          	addi	a0,a0,1708 # 6890 <malloc+0x1982>
    31ec:	0af010ef          	jal	ra,4a9a <unlink>
    31f0:	c949                	beqz	a0,3282 <rmdot+0xfe>
  if(unlink("dots") != 0){
    31f2:	00003517          	auipc	a0,0x3
    31f6:	60e50513          	addi	a0,a0,1550 # 6800 <malloc+0x18f2>
    31fa:	0a1010ef          	jal	ra,4a9a <unlink>
    31fe:	ed41                	bnez	a0,3296 <rmdot+0x112>
}
    3200:	60e2                	ld	ra,24(sp)
    3202:	6442                	ld	s0,16(sp)
    3204:	64a2                	ld	s1,8(sp)
    3206:	6105                	addi	sp,sp,32
    3208:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    320a:	85a6                	mv	a1,s1
    320c:	00003517          	auipc	a0,0x3
    3210:	5fc50513          	addi	a0,a0,1532 # 6808 <malloc+0x18fa>
    3214:	441010ef          	jal	ra,4e54 <printf>
    exit(1);
    3218:	4505                	li	a0,1
    321a:	031010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dots failed\n", s);
    321e:	85a6                	mv	a1,s1
    3220:	00003517          	auipc	a0,0x3
    3224:	60050513          	addi	a0,a0,1536 # 6820 <malloc+0x1912>
    3228:	42d010ef          	jal	ra,4e54 <printf>
    exit(1);
    322c:	4505                	li	a0,1
    322e:	01d010ef          	jal	ra,4a4a <exit>
    printf("%s: rm . worked!\n", s);
    3232:	85a6                	mv	a1,s1
    3234:	00003517          	auipc	a0,0x3
    3238:	60450513          	addi	a0,a0,1540 # 6838 <malloc+0x192a>
    323c:	419010ef          	jal	ra,4e54 <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	009010ef          	jal	ra,4a4a <exit>
    printf("%s: rm .. worked!\n", s);
    3246:	85a6                	mv	a1,s1
    3248:	00003517          	auipc	a0,0x3
    324c:	60850513          	addi	a0,a0,1544 # 6850 <malloc+0x1942>
    3250:	405010ef          	jal	ra,4e54 <printf>
    exit(1);
    3254:	4505                	li	a0,1
    3256:	7f4010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir / failed\n", s);
    325a:	85a6                	mv	a1,s1
    325c:	00003517          	auipc	a0,0x3
    3260:	fa450513          	addi	a0,a0,-92 # 6200 <malloc+0x12f2>
    3264:	3f1010ef          	jal	ra,4e54 <printf>
    exit(1);
    3268:	4505                	li	a0,1
    326a:	7e0010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    326e:	85a6                	mv	a1,s1
    3270:	00003517          	auipc	a0,0x3
    3274:	60050513          	addi	a0,a0,1536 # 6870 <malloc+0x1962>
    3278:	3dd010ef          	jal	ra,4e54 <printf>
    exit(1);
    327c:	4505                	li	a0,1
    327e:	7cc010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3282:	85a6                	mv	a1,s1
    3284:	00003517          	auipc	a0,0x3
    3288:	61450513          	addi	a0,a0,1556 # 6898 <malloc+0x198a>
    328c:	3c9010ef          	jal	ra,4e54 <printf>
    exit(1);
    3290:	4505                	li	a0,1
    3292:	7b8010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dots failed!\n", s);
    3296:	85a6                	mv	a1,s1
    3298:	00003517          	auipc	a0,0x3
    329c:	62050513          	addi	a0,a0,1568 # 68b8 <malloc+0x19aa>
    32a0:	3b5010ef          	jal	ra,4e54 <printf>
    exit(1);
    32a4:	4505                	li	a0,1
    32a6:	7a4010ef          	jal	ra,4a4a <exit>

00000000000032aa <dirfile>:
{
    32aa:	1101                	addi	sp,sp,-32
    32ac:	ec06                	sd	ra,24(sp)
    32ae:	e822                	sd	s0,16(sp)
    32b0:	e426                	sd	s1,8(sp)
    32b2:	e04a                	sd	s2,0(sp)
    32b4:	1000                	addi	s0,sp,32
    32b6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32b8:	20000593          	li	a1,512
    32bc:	00003517          	auipc	a0,0x3
    32c0:	61c50513          	addi	a0,a0,1564 # 68d8 <malloc+0x19ca>
    32c4:	7c6010ef          	jal	ra,4a8a <open>
  if(fd < 0){
    32c8:	0c054563          	bltz	a0,3392 <dirfile+0xe8>
  close(fd);
    32cc:	7a6010ef          	jal	ra,4a72 <close>
  if(chdir("dirfile") == 0){
    32d0:	00003517          	auipc	a0,0x3
    32d4:	60850513          	addi	a0,a0,1544 # 68d8 <malloc+0x19ca>
    32d8:	7e2010ef          	jal	ra,4aba <chdir>
    32dc:	c569                	beqz	a0,33a6 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32de:	4581                	li	a1,0
    32e0:	00003517          	auipc	a0,0x3
    32e4:	64050513          	addi	a0,a0,1600 # 6920 <malloc+0x1a12>
    32e8:	7a2010ef          	jal	ra,4a8a <open>
  if(fd >= 0){
    32ec:	0c055763          	bgez	a0,33ba <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32f0:	20000593          	li	a1,512
    32f4:	00003517          	auipc	a0,0x3
    32f8:	62c50513          	addi	a0,a0,1580 # 6920 <malloc+0x1a12>
    32fc:	78e010ef          	jal	ra,4a8a <open>
  if(fd >= 0){
    3300:	0c055763          	bgez	a0,33ce <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3304:	00003517          	auipc	a0,0x3
    3308:	61c50513          	addi	a0,a0,1564 # 6920 <malloc+0x1a12>
    330c:	7a6010ef          	jal	ra,4ab2 <mkdir>
    3310:	0c050963          	beqz	a0,33e2 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3314:	00003517          	auipc	a0,0x3
    3318:	60c50513          	addi	a0,a0,1548 # 6920 <malloc+0x1a12>
    331c:	77e010ef          	jal	ra,4a9a <unlink>
    3320:	0c050b63          	beqz	a0,33f6 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3324:	00003597          	auipc	a1,0x3
    3328:	5fc58593          	addi	a1,a1,1532 # 6920 <malloc+0x1a12>
    332c:	00002517          	auipc	a0,0x2
    3330:	ef450513          	addi	a0,a0,-268 # 5220 <malloc+0x312>
    3334:	776010ef          	jal	ra,4aaa <link>
    3338:	0c050963          	beqz	a0,340a <dirfile+0x160>
  if(unlink("dirfile") != 0){
    333c:	00003517          	auipc	a0,0x3
    3340:	59c50513          	addi	a0,a0,1436 # 68d8 <malloc+0x19ca>
    3344:	756010ef          	jal	ra,4a9a <unlink>
    3348:	0c051b63          	bnez	a0,341e <dirfile+0x174>
  fd = open(".", O_RDWR);
    334c:	4589                	li	a1,2
    334e:	00002517          	auipc	a0,0x2
    3352:	3e250513          	addi	a0,a0,994 # 5730 <malloc+0x822>
    3356:	734010ef          	jal	ra,4a8a <open>
  if(fd >= 0){
    335a:	0c055c63          	bgez	a0,3432 <dirfile+0x188>
  fd = open(".", 0);
    335e:	4581                	li	a1,0
    3360:	00002517          	auipc	a0,0x2
    3364:	3d050513          	addi	a0,a0,976 # 5730 <malloc+0x822>
    3368:	722010ef          	jal	ra,4a8a <open>
    336c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    336e:	4605                	li	a2,1
    3370:	00002597          	auipc	a1,0x2
    3374:	d4858593          	addi	a1,a1,-696 # 50b8 <malloc+0x1aa>
    3378:	6f2010ef          	jal	ra,4a6a <write>
    337c:	0ca04563          	bgtz	a0,3446 <dirfile+0x19c>
  close(fd);
    3380:	8526                	mv	a0,s1
    3382:	6f0010ef          	jal	ra,4a72 <close>
}
    3386:	60e2                	ld	ra,24(sp)
    3388:	6442                	ld	s0,16(sp)
    338a:	64a2                	ld	s1,8(sp)
    338c:	6902                	ld	s2,0(sp)
    338e:	6105                	addi	sp,sp,32
    3390:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3392:	85ca                	mv	a1,s2
    3394:	00003517          	auipc	a0,0x3
    3398:	54c50513          	addi	a0,a0,1356 # 68e0 <malloc+0x19d2>
    339c:	2b9010ef          	jal	ra,4e54 <printf>
    exit(1);
    33a0:	4505                	li	a0,1
    33a2:	6a8010ef          	jal	ra,4a4a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33a6:	85ca                	mv	a1,s2
    33a8:	00003517          	auipc	a0,0x3
    33ac:	55850513          	addi	a0,a0,1368 # 6900 <malloc+0x19f2>
    33b0:	2a5010ef          	jal	ra,4e54 <printf>
    exit(1);
    33b4:	4505                	li	a0,1
    33b6:	694010ef          	jal	ra,4a4a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ba:	85ca                	mv	a1,s2
    33bc:	00003517          	auipc	a0,0x3
    33c0:	57450513          	addi	a0,a0,1396 # 6930 <malloc+0x1a22>
    33c4:	291010ef          	jal	ra,4e54 <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	680010ef          	jal	ra,4a4a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ce:	85ca                	mv	a1,s2
    33d0:	00003517          	auipc	a0,0x3
    33d4:	56050513          	addi	a0,a0,1376 # 6930 <malloc+0x1a22>
    33d8:	27d010ef          	jal	ra,4e54 <printf>
    exit(1);
    33dc:	4505                	li	a0,1
    33de:	66c010ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33e2:	85ca                	mv	a1,s2
    33e4:	00003517          	auipc	a0,0x3
    33e8:	57450513          	addi	a0,a0,1396 # 6958 <malloc+0x1a4a>
    33ec:	269010ef          	jal	ra,4e54 <printf>
    exit(1);
    33f0:	4505                	li	a0,1
    33f2:	658010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33f6:	85ca                	mv	a1,s2
    33f8:	00003517          	auipc	a0,0x3
    33fc:	58850513          	addi	a0,a0,1416 # 6980 <malloc+0x1a72>
    3400:	255010ef          	jal	ra,4e54 <printf>
    exit(1);
    3404:	4505                	li	a0,1
    3406:	644010ef          	jal	ra,4a4a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00003517          	auipc	a0,0x3
    3410:	59c50513          	addi	a0,a0,1436 # 69a8 <malloc+0x1a9a>
    3414:	241010ef          	jal	ra,4e54 <printf>
    exit(1);
    3418:	4505                	li	a0,1
    341a:	630010ef          	jal	ra,4a4a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    341e:	85ca                	mv	a1,s2
    3420:	00003517          	auipc	a0,0x3
    3424:	5b050513          	addi	a0,a0,1456 # 69d0 <malloc+0x1ac2>
    3428:	22d010ef          	jal	ra,4e54 <printf>
    exit(1);
    342c:	4505                	li	a0,1
    342e:	61c010ef          	jal	ra,4a4a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3432:	85ca                	mv	a1,s2
    3434:	00003517          	auipc	a0,0x3
    3438:	5bc50513          	addi	a0,a0,1468 # 69f0 <malloc+0x1ae2>
    343c:	219010ef          	jal	ra,4e54 <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	608010ef          	jal	ra,4a4a <exit>
    printf("%s: write . succeeded!\n", s);
    3446:	85ca                	mv	a1,s2
    3448:	00003517          	auipc	a0,0x3
    344c:	5d050513          	addi	a0,a0,1488 # 6a18 <malloc+0x1b0a>
    3450:	205010ef          	jal	ra,4e54 <printf>
    exit(1);
    3454:	4505                	li	a0,1
    3456:	5f4010ef          	jal	ra,4a4a <exit>

000000000000345a <iref>:
{
    345a:	7139                	addi	sp,sp,-64
    345c:	fc06                	sd	ra,56(sp)
    345e:	f822                	sd	s0,48(sp)
    3460:	f426                	sd	s1,40(sp)
    3462:	f04a                	sd	s2,32(sp)
    3464:	ec4e                	sd	s3,24(sp)
    3466:	e852                	sd	s4,16(sp)
    3468:	e456                	sd	s5,8(sp)
    346a:	e05a                	sd	s6,0(sp)
    346c:	0080                	addi	s0,sp,64
    346e:	8b2a                	mv	s6,a0
    3470:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3474:	00003a17          	auipc	s4,0x3
    3478:	5bca0a13          	addi	s4,s4,1468 # 6a30 <malloc+0x1b22>
    mkdir("");
    347c:	00003497          	auipc	s1,0x3
    3480:	0bc48493          	addi	s1,s1,188 # 6538 <malloc+0x162a>
    link("README", "");
    3484:	00002a97          	auipc	s5,0x2
    3488:	d9ca8a93          	addi	s5,s5,-612 # 5220 <malloc+0x312>
    fd = open("xx", O_CREATE);
    348c:	00003997          	auipc	s3,0x3
    3490:	49c98993          	addi	s3,s3,1180 # 6928 <malloc+0x1a1a>
    3494:	a835                	j	34d0 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    3496:	85da                	mv	a1,s6
    3498:	00003517          	auipc	a0,0x3
    349c:	5a050513          	addi	a0,a0,1440 # 6a38 <malloc+0x1b2a>
    34a0:	1b5010ef          	jal	ra,4e54 <printf>
      exit(1);
    34a4:	4505                	li	a0,1
    34a6:	5a4010ef          	jal	ra,4a4a <exit>
      printf("%s: chdir irefd failed\n", s);
    34aa:	85da                	mv	a1,s6
    34ac:	00003517          	auipc	a0,0x3
    34b0:	5a450513          	addi	a0,a0,1444 # 6a50 <malloc+0x1b42>
    34b4:	1a1010ef          	jal	ra,4e54 <printf>
      exit(1);
    34b8:	4505                	li	a0,1
    34ba:	590010ef          	jal	ra,4a4a <exit>
      close(fd);
    34be:	5b4010ef          	jal	ra,4a72 <close>
    34c2:	a82d                	j	34fc <iref+0xa2>
    unlink("xx");
    34c4:	854e                	mv	a0,s3
    34c6:	5d4010ef          	jal	ra,4a9a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34ca:	397d                	addiw	s2,s2,-1
    34cc:	04090263          	beqz	s2,3510 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34d0:	8552                	mv	a0,s4
    34d2:	5e0010ef          	jal	ra,4ab2 <mkdir>
    34d6:	f161                	bnez	a0,3496 <iref+0x3c>
    if(chdir("irefd") != 0){
    34d8:	8552                	mv	a0,s4
    34da:	5e0010ef          	jal	ra,4aba <chdir>
    34de:	f571                	bnez	a0,34aa <iref+0x50>
    mkdir("");
    34e0:	8526                	mv	a0,s1
    34e2:	5d0010ef          	jal	ra,4ab2 <mkdir>
    link("README", "");
    34e6:	85a6                	mv	a1,s1
    34e8:	8556                	mv	a0,s5
    34ea:	5c0010ef          	jal	ra,4aaa <link>
    fd = open("", O_CREATE);
    34ee:	20000593          	li	a1,512
    34f2:	8526                	mv	a0,s1
    34f4:	596010ef          	jal	ra,4a8a <open>
    if(fd >= 0)
    34f8:	fc0553e3          	bgez	a0,34be <iref+0x64>
    fd = open("xx", O_CREATE);
    34fc:	20000593          	li	a1,512
    3500:	854e                	mv	a0,s3
    3502:	588010ef          	jal	ra,4a8a <open>
    if(fd >= 0)
    3506:	fa054fe3          	bltz	a0,34c4 <iref+0x6a>
      close(fd);
    350a:	568010ef          	jal	ra,4a72 <close>
    350e:	bf5d                	j	34c4 <iref+0x6a>
    3510:	03300493          	li	s1,51
    chdir("..");
    3514:	00003997          	auipc	s3,0x3
    3518:	d3c98993          	addi	s3,s3,-708 # 6250 <malloc+0x1342>
    unlink("irefd");
    351c:	00003917          	auipc	s2,0x3
    3520:	51490913          	addi	s2,s2,1300 # 6a30 <malloc+0x1b22>
    chdir("..");
    3524:	854e                	mv	a0,s3
    3526:	594010ef          	jal	ra,4aba <chdir>
    unlink("irefd");
    352a:	854a                	mv	a0,s2
    352c:	56e010ef          	jal	ra,4a9a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3530:	34fd                	addiw	s1,s1,-1
    3532:	f8ed                	bnez	s1,3524 <iref+0xca>
  chdir("/");
    3534:	00003517          	auipc	a0,0x3
    3538:	cc450513          	addi	a0,a0,-828 # 61f8 <malloc+0x12ea>
    353c:	57e010ef          	jal	ra,4aba <chdir>
}
    3540:	70e2                	ld	ra,56(sp)
    3542:	7442                	ld	s0,48(sp)
    3544:	74a2                	ld	s1,40(sp)
    3546:	7902                	ld	s2,32(sp)
    3548:	69e2                	ld	s3,24(sp)
    354a:	6a42                	ld	s4,16(sp)
    354c:	6aa2                	ld	s5,8(sp)
    354e:	6b02                	ld	s6,0(sp)
    3550:	6121                	addi	sp,sp,64
    3552:	8082                	ret

0000000000003554 <openiputtest>:
{
    3554:	7179                	addi	sp,sp,-48
    3556:	f406                	sd	ra,40(sp)
    3558:	f022                	sd	s0,32(sp)
    355a:	ec26                	sd	s1,24(sp)
    355c:	1800                	addi	s0,sp,48
    355e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3560:	00003517          	auipc	a0,0x3
    3564:	50850513          	addi	a0,a0,1288 # 6a68 <malloc+0x1b5a>
    3568:	54a010ef          	jal	ra,4ab2 <mkdir>
    356c:	02054a63          	bltz	a0,35a0 <openiputtest+0x4c>
  pid = fork();
    3570:	4d2010ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    3574:	04054063          	bltz	a0,35b4 <openiputtest+0x60>
  if(pid == 0){
    3578:	e939                	bnez	a0,35ce <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    357a:	4589                	li	a1,2
    357c:	00003517          	auipc	a0,0x3
    3580:	4ec50513          	addi	a0,a0,1260 # 6a68 <malloc+0x1b5a>
    3584:	506010ef          	jal	ra,4a8a <open>
    if(fd >= 0){
    3588:	04054063          	bltz	a0,35c8 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    358c:	85a6                	mv	a1,s1
    358e:	00003517          	auipc	a0,0x3
    3592:	4fa50513          	addi	a0,a0,1274 # 6a88 <malloc+0x1b7a>
    3596:	0bf010ef          	jal	ra,4e54 <printf>
      exit(1);
    359a:	4505                	li	a0,1
    359c:	4ae010ef          	jal	ra,4a4a <exit>
    printf("%s: mkdir oidir failed\n", s);
    35a0:	85a6                	mv	a1,s1
    35a2:	00003517          	auipc	a0,0x3
    35a6:	4ce50513          	addi	a0,a0,1230 # 6a70 <malloc+0x1b62>
    35aa:	0ab010ef          	jal	ra,4e54 <printf>
    exit(1);
    35ae:	4505                	li	a0,1
    35b0:	49a010ef          	jal	ra,4a4a <exit>
    printf("%s: fork failed\n", s);
    35b4:	85a6                	mv	a1,s1
    35b6:	00002517          	auipc	a0,0x2
    35ba:	32250513          	addi	a0,a0,802 # 58d8 <malloc+0x9ca>
    35be:	097010ef          	jal	ra,4e54 <printf>
    exit(1);
    35c2:	4505                	li	a0,1
    35c4:	486010ef          	jal	ra,4a4a <exit>
    exit(0);
    35c8:	4501                	li	a0,0
    35ca:	480010ef          	jal	ra,4a4a <exit>
  sleep(1);
    35ce:	4505                	li	a0,1
    35d0:	50a010ef          	jal	ra,4ada <sleep>
  if(unlink("oidir") != 0){
    35d4:	00003517          	auipc	a0,0x3
    35d8:	49450513          	addi	a0,a0,1172 # 6a68 <malloc+0x1b5a>
    35dc:	4be010ef          	jal	ra,4a9a <unlink>
    35e0:	c919                	beqz	a0,35f6 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35e2:	85a6                	mv	a1,s1
    35e4:	00002517          	auipc	a0,0x2
    35e8:	4e450513          	addi	a0,a0,1252 # 5ac8 <malloc+0xbba>
    35ec:	069010ef          	jal	ra,4e54 <printf>
    exit(1);
    35f0:	4505                	li	a0,1
    35f2:	458010ef          	jal	ra,4a4a <exit>
  wait(&xstatus);
    35f6:	fdc40513          	addi	a0,s0,-36
    35fa:	458010ef          	jal	ra,4a52 <wait>
  exit(xstatus);
    35fe:	fdc42503          	lw	a0,-36(s0)
    3602:	448010ef          	jal	ra,4a4a <exit>

0000000000003606 <forkforkfork>:
{
    3606:	1101                	addi	sp,sp,-32
    3608:	ec06                	sd	ra,24(sp)
    360a:	e822                	sd	s0,16(sp)
    360c:	e426                	sd	s1,8(sp)
    360e:	1000                	addi	s0,sp,32
    3610:	84aa                	mv	s1,a0
  unlink("stopforking");
    3612:	00003517          	auipc	a0,0x3
    3616:	49e50513          	addi	a0,a0,1182 # 6ab0 <malloc+0x1ba2>
    361a:	480010ef          	jal	ra,4a9a <unlink>
  int pid = fork();
    361e:	424010ef          	jal	ra,4a42 <fork>
  if(pid < 0){
    3622:	02054b63          	bltz	a0,3658 <forkforkfork+0x52>
  if(pid == 0){
    3626:	c139                	beqz	a0,366c <forkforkfork+0x66>
  sleep(20); // two seconds
    3628:	4551                	li	a0,20
    362a:	4b0010ef          	jal	ra,4ada <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    362e:	20200593          	li	a1,514
    3632:	00003517          	auipc	a0,0x3
    3636:	47e50513          	addi	a0,a0,1150 # 6ab0 <malloc+0x1ba2>
    363a:	450010ef          	jal	ra,4a8a <open>
    363e:	434010ef          	jal	ra,4a72 <close>
  wait(0);
    3642:	4501                	li	a0,0
    3644:	40e010ef          	jal	ra,4a52 <wait>
  sleep(10); // one second
    3648:	4529                	li	a0,10
    364a:	490010ef          	jal	ra,4ada <sleep>
}
    364e:	60e2                	ld	ra,24(sp)
    3650:	6442                	ld	s0,16(sp)
    3652:	64a2                	ld	s1,8(sp)
    3654:	6105                	addi	sp,sp,32
    3656:	8082                	ret
    printf("%s: fork failed", s);
    3658:	85a6                	mv	a1,s1
    365a:	00002517          	auipc	a0,0x2
    365e:	43e50513          	addi	a0,a0,1086 # 5a98 <malloc+0xb8a>
    3662:	7f2010ef          	jal	ra,4e54 <printf>
    exit(1);
    3666:	4505                	li	a0,1
    3668:	3e2010ef          	jal	ra,4a4a <exit>
      int fd = open("stopforking", 0);
    366c:	00003497          	auipc	s1,0x3
    3670:	44448493          	addi	s1,s1,1092 # 6ab0 <malloc+0x1ba2>
    3674:	4581                	li	a1,0
    3676:	8526                	mv	a0,s1
    3678:	412010ef          	jal	ra,4a8a <open>
      if(fd >= 0){
    367c:	00055e63          	bgez	a0,3698 <forkforkfork+0x92>
      if(fork() < 0){
    3680:	3c2010ef          	jal	ra,4a42 <fork>
    3684:	fe0558e3          	bgez	a0,3674 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    3688:	20200593          	li	a1,514
    368c:	8526                	mv	a0,s1
    368e:	3fc010ef          	jal	ra,4a8a <open>
    3692:	3e0010ef          	jal	ra,4a72 <close>
    3696:	bff9                	j	3674 <forkforkfork+0x6e>
        exit(0);
    3698:	4501                	li	a0,0
    369a:	3b0010ef          	jal	ra,4a4a <exit>

000000000000369e <killstatus>:
{
    369e:	7139                	addi	sp,sp,-64
    36a0:	fc06                	sd	ra,56(sp)
    36a2:	f822                	sd	s0,48(sp)
    36a4:	f426                	sd	s1,40(sp)
    36a6:	f04a                	sd	s2,32(sp)
    36a8:	ec4e                	sd	s3,24(sp)
    36aa:	e852                	sd	s4,16(sp)
    36ac:	0080                	addi	s0,sp,64
    36ae:	8a2a                	mv	s4,a0
    36b0:	06400913          	li	s2,100
    if(xst != -1) {
    36b4:	59fd                	li	s3,-1
    int pid1 = fork();
    36b6:	38c010ef          	jal	ra,4a42 <fork>
    36ba:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36bc:	02054763          	bltz	a0,36ea <killstatus+0x4c>
    if(pid1 == 0){
    36c0:	cd1d                	beqz	a0,36fe <killstatus+0x60>
    sleep(1);
    36c2:	4505                	li	a0,1
    36c4:	416010ef          	jal	ra,4ada <sleep>
    kill(pid1);
    36c8:	8526                	mv	a0,s1
    36ca:	3b0010ef          	jal	ra,4a7a <kill>
    wait(&xst);
    36ce:	fcc40513          	addi	a0,s0,-52
    36d2:	380010ef          	jal	ra,4a52 <wait>
    if(xst != -1) {
    36d6:	fcc42783          	lw	a5,-52(s0)
    36da:	03379563          	bne	a5,s3,3704 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36de:	397d                	addiw	s2,s2,-1
    36e0:	fc091be3          	bnez	s2,36b6 <killstatus+0x18>
  exit(0);
    36e4:	4501                	li	a0,0
    36e6:	364010ef          	jal	ra,4a4a <exit>
      printf("%s: fork failed\n", s);
    36ea:	85d2                	mv	a1,s4
    36ec:	00002517          	auipc	a0,0x2
    36f0:	1ec50513          	addi	a0,a0,492 # 58d8 <malloc+0x9ca>
    36f4:	760010ef          	jal	ra,4e54 <printf>
      exit(1);
    36f8:	4505                	li	a0,1
    36fa:	350010ef          	jal	ra,4a4a <exit>
        getpid();
    36fe:	3cc010ef          	jal	ra,4aca <getpid>
      while(1) {
    3702:	bff5                	j	36fe <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3704:	85d2                	mv	a1,s4
    3706:	00003517          	auipc	a0,0x3
    370a:	3ba50513          	addi	a0,a0,954 # 6ac0 <malloc+0x1bb2>
    370e:	746010ef          	jal	ra,4e54 <printf>
       exit(1);
    3712:	4505                	li	a0,1
    3714:	336010ef          	jal	ra,4a4a <exit>

0000000000003718 <preempt>:
{
    3718:	7139                	addi	sp,sp,-64
    371a:	fc06                	sd	ra,56(sp)
    371c:	f822                	sd	s0,48(sp)
    371e:	f426                	sd	s1,40(sp)
    3720:	f04a                	sd	s2,32(sp)
    3722:	ec4e                	sd	s3,24(sp)
    3724:	e852                	sd	s4,16(sp)
    3726:	0080                	addi	s0,sp,64
    3728:	84aa                	mv	s1,a0
  pid1 = fork();
    372a:	318010ef          	jal	ra,4a42 <fork>
  if(pid1 < 0) {
    372e:	00054563          	bltz	a0,3738 <preempt+0x20>
    3732:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    3734:	ed01                	bnez	a0,374c <preempt+0x34>
    for(;;)
    3736:	a001                	j	3736 <preempt+0x1e>
    printf("%s: fork failed", s);
    3738:	85a6                	mv	a1,s1
    373a:	00002517          	auipc	a0,0x2
    373e:	35e50513          	addi	a0,a0,862 # 5a98 <malloc+0xb8a>
    3742:	712010ef          	jal	ra,4e54 <printf>
    exit(1);
    3746:	4505                	li	a0,1
    3748:	302010ef          	jal	ra,4a4a <exit>
  pid2 = fork();
    374c:	2f6010ef          	jal	ra,4a42 <fork>
    3750:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3752:	00054463          	bltz	a0,375a <preempt+0x42>
  if(pid2 == 0)
    3756:	ed01                	bnez	a0,376e <preempt+0x56>
    for(;;)
    3758:	a001                	j	3758 <preempt+0x40>
    printf("%s: fork failed\n", s);
    375a:	85a6                	mv	a1,s1
    375c:	00002517          	auipc	a0,0x2
    3760:	17c50513          	addi	a0,a0,380 # 58d8 <malloc+0x9ca>
    3764:	6f0010ef          	jal	ra,4e54 <printf>
    exit(1);
    3768:	4505                	li	a0,1
    376a:	2e0010ef          	jal	ra,4a4a <exit>
  pipe(pfds);
    376e:	fc840513          	addi	a0,s0,-56
    3772:	2e8010ef          	jal	ra,4a5a <pipe>
  pid3 = fork();
    3776:	2cc010ef          	jal	ra,4a42 <fork>
    377a:	892a                	mv	s2,a0
  if(pid3 < 0) {
    377c:	02054863          	bltz	a0,37ac <preempt+0x94>
  if(pid3 == 0){
    3780:	e921                	bnez	a0,37d0 <preempt+0xb8>
    close(pfds[0]);
    3782:	fc842503          	lw	a0,-56(s0)
    3786:	2ec010ef          	jal	ra,4a72 <close>
    if(write(pfds[1], "x", 1) != 1)
    378a:	4605                	li	a2,1
    378c:	00002597          	auipc	a1,0x2
    3790:	92c58593          	addi	a1,a1,-1748 # 50b8 <malloc+0x1aa>
    3794:	fcc42503          	lw	a0,-52(s0)
    3798:	2d2010ef          	jal	ra,4a6a <write>
    379c:	4785                	li	a5,1
    379e:	02f51163          	bne	a0,a5,37c0 <preempt+0xa8>
    close(pfds[1]);
    37a2:	fcc42503          	lw	a0,-52(s0)
    37a6:	2cc010ef          	jal	ra,4a72 <close>
    for(;;)
    37aa:	a001                	j	37aa <preempt+0x92>
     printf("%s: fork failed\n", s);
    37ac:	85a6                	mv	a1,s1
    37ae:	00002517          	auipc	a0,0x2
    37b2:	12a50513          	addi	a0,a0,298 # 58d8 <malloc+0x9ca>
    37b6:	69e010ef          	jal	ra,4e54 <printf>
     exit(1);
    37ba:	4505                	li	a0,1
    37bc:	28e010ef          	jal	ra,4a4a <exit>
      printf("%s: preempt write error", s);
    37c0:	85a6                	mv	a1,s1
    37c2:	00003517          	auipc	a0,0x3
    37c6:	31e50513          	addi	a0,a0,798 # 6ae0 <malloc+0x1bd2>
    37ca:	68a010ef          	jal	ra,4e54 <printf>
    37ce:	bfd1                	j	37a2 <preempt+0x8a>
  close(pfds[1]);
    37d0:	fcc42503          	lw	a0,-52(s0)
    37d4:	29e010ef          	jal	ra,4a72 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37d8:	660d                	lui	a2,0x3
    37da:	00008597          	auipc	a1,0x8
    37de:	49e58593          	addi	a1,a1,1182 # bc78 <buf>
    37e2:	fc842503          	lw	a0,-56(s0)
    37e6:	27c010ef          	jal	ra,4a62 <read>
    37ea:	4785                	li	a5,1
    37ec:	02f50163          	beq	a0,a5,380e <preempt+0xf6>
    printf("%s: preempt read error", s);
    37f0:	85a6                	mv	a1,s1
    37f2:	00003517          	auipc	a0,0x3
    37f6:	30650513          	addi	a0,a0,774 # 6af8 <malloc+0x1bea>
    37fa:	65a010ef          	jal	ra,4e54 <printf>
}
    37fe:	70e2                	ld	ra,56(sp)
    3800:	7442                	ld	s0,48(sp)
    3802:	74a2                	ld	s1,40(sp)
    3804:	7902                	ld	s2,32(sp)
    3806:	69e2                	ld	s3,24(sp)
    3808:	6a42                	ld	s4,16(sp)
    380a:	6121                	addi	sp,sp,64
    380c:	8082                	ret
  close(pfds[0]);
    380e:	fc842503          	lw	a0,-56(s0)
    3812:	260010ef          	jal	ra,4a72 <close>
  printf("kill... ");
    3816:	00003517          	auipc	a0,0x3
    381a:	2fa50513          	addi	a0,a0,762 # 6b10 <malloc+0x1c02>
    381e:	636010ef          	jal	ra,4e54 <printf>
  kill(pid1);
    3822:	8552                	mv	a0,s4
    3824:	256010ef          	jal	ra,4a7a <kill>
  kill(pid2);
    3828:	854e                	mv	a0,s3
    382a:	250010ef          	jal	ra,4a7a <kill>
  kill(pid3);
    382e:	854a                	mv	a0,s2
    3830:	24a010ef          	jal	ra,4a7a <kill>
  printf("wait... ");
    3834:	00003517          	auipc	a0,0x3
    3838:	2ec50513          	addi	a0,a0,748 # 6b20 <malloc+0x1c12>
    383c:	618010ef          	jal	ra,4e54 <printf>
  wait(0);
    3840:	4501                	li	a0,0
    3842:	210010ef          	jal	ra,4a52 <wait>
  wait(0);
    3846:	4501                	li	a0,0
    3848:	20a010ef          	jal	ra,4a52 <wait>
  wait(0);
    384c:	4501                	li	a0,0
    384e:	204010ef          	jal	ra,4a52 <wait>
    3852:	b775                	j	37fe <preempt+0xe6>

0000000000003854 <reparent>:
{
    3854:	7179                	addi	sp,sp,-48
    3856:	f406                	sd	ra,40(sp)
    3858:	f022                	sd	s0,32(sp)
    385a:	ec26                	sd	s1,24(sp)
    385c:	e84a                	sd	s2,16(sp)
    385e:	e44e                	sd	s3,8(sp)
    3860:	e052                	sd	s4,0(sp)
    3862:	1800                	addi	s0,sp,48
    3864:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3866:	264010ef          	jal	ra,4aca <getpid>
    386a:	8a2a                	mv	s4,a0
    386c:	0c800913          	li	s2,200
    int pid = fork();
    3870:	1d2010ef          	jal	ra,4a42 <fork>
    3874:	84aa                	mv	s1,a0
    if(pid < 0){
    3876:	00054e63          	bltz	a0,3892 <reparent+0x3e>
    if(pid){
    387a:	c121                	beqz	a0,38ba <reparent+0x66>
      if(wait(0) != pid){
    387c:	4501                	li	a0,0
    387e:	1d4010ef          	jal	ra,4a52 <wait>
    3882:	02951263          	bne	a0,s1,38a6 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3886:	397d                	addiw	s2,s2,-1
    3888:	fe0914e3          	bnez	s2,3870 <reparent+0x1c>
  exit(0);
    388c:	4501                	li	a0,0
    388e:	1bc010ef          	jal	ra,4a4a <exit>
      printf("%s: fork failed\n", s);
    3892:	85ce                	mv	a1,s3
    3894:	00002517          	auipc	a0,0x2
    3898:	04450513          	addi	a0,a0,68 # 58d8 <malloc+0x9ca>
    389c:	5b8010ef          	jal	ra,4e54 <printf>
      exit(1);
    38a0:	4505                	li	a0,1
    38a2:	1a8010ef          	jal	ra,4a4a <exit>
        printf("%s: wait wrong pid\n", s);
    38a6:	85ce                	mv	a1,s3
    38a8:	00002517          	auipc	a0,0x2
    38ac:	1b850513          	addi	a0,a0,440 # 5a60 <malloc+0xb52>
    38b0:	5a4010ef          	jal	ra,4e54 <printf>
        exit(1);
    38b4:	4505                	li	a0,1
    38b6:	194010ef          	jal	ra,4a4a <exit>
      int pid2 = fork();
    38ba:	188010ef          	jal	ra,4a42 <fork>
      if(pid2 < 0){
    38be:	00054563          	bltz	a0,38c8 <reparent+0x74>
      exit(0);
    38c2:	4501                	li	a0,0
    38c4:	186010ef          	jal	ra,4a4a <exit>
        kill(master_pid);
    38c8:	8552                	mv	a0,s4
    38ca:	1b0010ef          	jal	ra,4a7a <kill>
        exit(1);
    38ce:	4505                	li	a0,1
    38d0:	17a010ef          	jal	ra,4a4a <exit>

00000000000038d4 <sbrkfail>:
{
    38d4:	7119                	addi	sp,sp,-128
    38d6:	fc86                	sd	ra,120(sp)
    38d8:	f8a2                	sd	s0,112(sp)
    38da:	f4a6                	sd	s1,104(sp)
    38dc:	f0ca                	sd	s2,96(sp)
    38de:	ecce                	sd	s3,88(sp)
    38e0:	e8d2                	sd	s4,80(sp)
    38e2:	e4d6                	sd	s5,72(sp)
    38e4:	0100                	addi	s0,sp,128
    38e6:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    38e8:	fb040513          	addi	a0,s0,-80
    38ec:	16e010ef          	jal	ra,4a5a <pipe>
    38f0:	e901                	bnez	a0,3900 <sbrkfail+0x2c>
    38f2:	f8040493          	addi	s1,s0,-128
    38f6:	fa840a13          	addi	s4,s0,-88
    38fa:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    38fc:	5afd                	li	s5,-1
    38fe:	a0a9                	j	3948 <sbrkfail+0x74>
    printf("%s: pipe() failed\n", s);
    3900:	85ca                	mv	a1,s2
    3902:	00002517          	auipc	a0,0x2
    3906:	0de50513          	addi	a0,a0,222 # 59e0 <malloc+0xad2>
    390a:	54a010ef          	jal	ra,4e54 <printf>
    exit(1);
    390e:	4505                	li	a0,1
    3910:	13a010ef          	jal	ra,4a4a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3914:	4501                	li	a0,0
    3916:	1bc010ef          	jal	ra,4ad2 <sbrk>
    391a:	064007b7          	lui	a5,0x6400
    391e:	40a7853b          	subw	a0,a5,a0
    3922:	1b0010ef          	jal	ra,4ad2 <sbrk>
      write(fds[1], "x", 1);
    3926:	4605                	li	a2,1
    3928:	00001597          	auipc	a1,0x1
    392c:	79058593          	addi	a1,a1,1936 # 50b8 <malloc+0x1aa>
    3930:	fb442503          	lw	a0,-76(s0)
    3934:	136010ef          	jal	ra,4a6a <write>
      for(;;) sleep(1000);
    3938:	3e800513          	li	a0,1000
    393c:	19e010ef          	jal	ra,4ada <sleep>
    3940:	bfe5                	j	3938 <sbrkfail+0x64>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3942:	0991                	addi	s3,s3,4
    3944:	03498163          	beq	s3,s4,3966 <sbrkfail+0x92>
    if((pids[i] = fork()) == 0){
    3948:	0fa010ef          	jal	ra,4a42 <fork>
    394c:	00a9a023          	sw	a0,0(s3)
    3950:	d171                	beqz	a0,3914 <sbrkfail+0x40>
    if(pids[i] != -1)
    3952:	ff5508e3          	beq	a0,s5,3942 <sbrkfail+0x6e>
      read(fds[0], &scratch, 1);
    3956:	4605                	li	a2,1
    3958:	faf40593          	addi	a1,s0,-81
    395c:	fb042503          	lw	a0,-80(s0)
    3960:	102010ef          	jal	ra,4a62 <read>
    3964:	bff9                	j	3942 <sbrkfail+0x6e>
  c = sbrk(PGSIZE);
    3966:	6505                	lui	a0,0x1
    3968:	16a010ef          	jal	ra,4ad2 <sbrk>
    396c:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    396e:	5afd                	li	s5,-1
    3970:	a021                	j	3978 <sbrkfail+0xa4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3972:	0491                	addi	s1,s1,4
    3974:	01448b63          	beq	s1,s4,398a <sbrkfail+0xb6>
    if(pids[i] == -1)
    3978:	4088                	lw	a0,0(s1)
    397a:	ff550ce3          	beq	a0,s5,3972 <sbrkfail+0x9e>
    kill(pids[i]);
    397e:	0fc010ef          	jal	ra,4a7a <kill>
    wait(0);
    3982:	4501                	li	a0,0
    3984:	0ce010ef          	jal	ra,4a52 <wait>
    3988:	b7ed                	j	3972 <sbrkfail+0x9e>
  if(c == (char*)0xffffffffffffffffL){
    398a:	57fd                	li	a5,-1
    398c:	02f98d63          	beq	s3,a5,39c6 <sbrkfail+0xf2>
  pid = fork();
    3990:	0b2010ef          	jal	ra,4a42 <fork>
    3994:	84aa                	mv	s1,a0
  if(pid < 0){
    3996:	04054263          	bltz	a0,39da <sbrkfail+0x106>
  if(pid == 0){
    399a:	c931                	beqz	a0,39ee <sbrkfail+0x11a>
  wait(&xstatus);
    399c:	fbc40513          	addi	a0,s0,-68
    39a0:	0b2010ef          	jal	ra,4a52 <wait>
  if(xstatus != -1 && xstatus != 2)
    39a4:	fbc42783          	lw	a5,-68(s0)
    39a8:	577d                	li	a4,-1
    39aa:	00e78563          	beq	a5,a4,39b4 <sbrkfail+0xe0>
    39ae:	4709                	li	a4,2
    39b0:	06e79d63          	bne	a5,a4,3a2a <sbrkfail+0x156>
}
    39b4:	70e6                	ld	ra,120(sp)
    39b6:	7446                	ld	s0,112(sp)
    39b8:	74a6                	ld	s1,104(sp)
    39ba:	7906                	ld	s2,96(sp)
    39bc:	69e6                	ld	s3,88(sp)
    39be:	6a46                	ld	s4,80(sp)
    39c0:	6aa6                	ld	s5,72(sp)
    39c2:	6109                	addi	sp,sp,128
    39c4:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    39c6:	85ca                	mv	a1,s2
    39c8:	00003517          	auipc	a0,0x3
    39cc:	16850513          	addi	a0,a0,360 # 6b30 <malloc+0x1c22>
    39d0:	484010ef          	jal	ra,4e54 <printf>
    exit(1);
    39d4:	4505                	li	a0,1
    39d6:	074010ef          	jal	ra,4a4a <exit>
    printf("%s: fork failed\n", s);
    39da:	85ca                	mv	a1,s2
    39dc:	00002517          	auipc	a0,0x2
    39e0:	efc50513          	addi	a0,a0,-260 # 58d8 <malloc+0x9ca>
    39e4:	470010ef          	jal	ra,4e54 <printf>
    exit(1);
    39e8:	4505                	li	a0,1
    39ea:	060010ef          	jal	ra,4a4a <exit>
    a = sbrk(0);
    39ee:	4501                	li	a0,0
    39f0:	0e2010ef          	jal	ra,4ad2 <sbrk>
    39f4:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    39f6:	3e800537          	lui	a0,0x3e800
    39fa:	0d8010ef          	jal	ra,4ad2 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    39fe:	874e                	mv	a4,s3
    3a00:	3e8007b7          	lui	a5,0x3e800
    3a04:	97ce                	add	a5,a5,s3
    3a06:	6685                	lui	a3,0x1
      n += *(a+i);
    3a08:	00074603          	lbu	a2,0(a4)
    3a0c:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a0e:	9736                	add	a4,a4,a3
    3a10:	fef71ce3          	bne	a4,a5,3a08 <sbrkfail+0x134>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a14:	8626                	mv	a2,s1
    3a16:	85ca                	mv	a1,s2
    3a18:	00003517          	auipc	a0,0x3
    3a1c:	13850513          	addi	a0,a0,312 # 6b50 <malloc+0x1c42>
    3a20:	434010ef          	jal	ra,4e54 <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	024010ef          	jal	ra,4a4a <exit>
    exit(1);
    3a2a:	4505                	li	a0,1
    3a2c:	01e010ef          	jal	ra,4a4a <exit>

0000000000003a30 <mem>:
{
    3a30:	7139                	addi	sp,sp,-64
    3a32:	fc06                	sd	ra,56(sp)
    3a34:	f822                	sd	s0,48(sp)
    3a36:	f426                	sd	s1,40(sp)
    3a38:	f04a                	sd	s2,32(sp)
    3a3a:	ec4e                	sd	s3,24(sp)
    3a3c:	0080                	addi	s0,sp,64
    3a3e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a40:	002010ef          	jal	ra,4a42 <fork>
    m1 = 0;
    3a44:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a46:	6909                	lui	s2,0x2
    3a48:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xc3>
  if((pid = fork()) == 0){
    3a4c:	e129                	bnez	a0,3a8e <mem+0x5e>
    while((m2 = malloc(10001)) != 0){
    3a4e:	854a                	mv	a0,s2
    3a50:	4be010ef          	jal	ra,4f0e <malloc>
    3a54:	c501                	beqz	a0,3a5c <mem+0x2c>
      *(char**)m2 = m1;
    3a56:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a58:	84aa                	mv	s1,a0
    3a5a:	bfd5                	j	3a4e <mem+0x1e>
    while(m1){
    3a5c:	c491                	beqz	s1,3a68 <mem+0x38>
      m2 = *(char**)m1;
    3a5e:	8526                	mv	a0,s1
    3a60:	6084                	ld	s1,0(s1)
      free(m1);
    3a62:	424010ef          	jal	ra,4e86 <free>
    while(m1){
    3a66:	fce5                	bnez	s1,3a5e <mem+0x2e>
    m1 = malloc(1024*20);
    3a68:	6515                	lui	a0,0x5
    3a6a:	4a4010ef          	jal	ra,4f0e <malloc>
    if(m1 == 0){
    3a6e:	c511                	beqz	a0,3a7a <mem+0x4a>
    free(m1);
    3a70:	416010ef          	jal	ra,4e86 <free>
    exit(0);
    3a74:	4501                	li	a0,0
    3a76:	7d5000ef          	jal	ra,4a4a <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a7a:	85ce                	mv	a1,s3
    3a7c:	00003517          	auipc	a0,0x3
    3a80:	10450513          	addi	a0,a0,260 # 6b80 <malloc+0x1c72>
    3a84:	3d0010ef          	jal	ra,4e54 <printf>
      exit(1);
    3a88:	4505                	li	a0,1
    3a8a:	7c1000ef          	jal	ra,4a4a <exit>
    wait(&xstatus);
    3a8e:	fcc40513          	addi	a0,s0,-52
    3a92:	7c1000ef          	jal	ra,4a52 <wait>
    if(xstatus == -1){
    3a96:	fcc42503          	lw	a0,-52(s0)
    3a9a:	57fd                	li	a5,-1
    3a9c:	00f50463          	beq	a0,a5,3aa4 <mem+0x74>
    exit(xstatus);
    3aa0:	7ab000ef          	jal	ra,4a4a <exit>
      exit(0);
    3aa4:	4501                	li	a0,0
    3aa6:	7a5000ef          	jal	ra,4a4a <exit>

0000000000003aaa <sharedfd>:
{
    3aaa:	7159                	addi	sp,sp,-112
    3aac:	f486                	sd	ra,104(sp)
    3aae:	f0a2                	sd	s0,96(sp)
    3ab0:	eca6                	sd	s1,88(sp)
    3ab2:	e8ca                	sd	s2,80(sp)
    3ab4:	e4ce                	sd	s3,72(sp)
    3ab6:	e0d2                	sd	s4,64(sp)
    3ab8:	fc56                	sd	s5,56(sp)
    3aba:	f85a                	sd	s6,48(sp)
    3abc:	f45e                	sd	s7,40(sp)
    3abe:	1880                	addi	s0,sp,112
    3ac0:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3ac2:	00003517          	auipc	a0,0x3
    3ac6:	0de50513          	addi	a0,a0,222 # 6ba0 <malloc+0x1c92>
    3aca:	7d1000ef          	jal	ra,4a9a <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3ace:	20200593          	li	a1,514
    3ad2:	00003517          	auipc	a0,0x3
    3ad6:	0ce50513          	addi	a0,a0,206 # 6ba0 <malloc+0x1c92>
    3ada:	7b1000ef          	jal	ra,4a8a <open>
  if(fd < 0){
    3ade:	04054263          	bltz	a0,3b22 <sharedfd+0x78>
    3ae2:	892a                	mv	s2,a0
  pid = fork();
    3ae4:	75f000ef          	jal	ra,4a42 <fork>
    3ae8:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3aea:	06300593          	li	a1,99
    3aee:	c119                	beqz	a0,3af4 <sharedfd+0x4a>
    3af0:	07000593          	li	a1,112
    3af4:	4629                	li	a2,10
    3af6:	fa040513          	addi	a0,s0,-96
    3afa:	561000ef          	jal	ra,485a <memset>
    3afe:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b02:	4629                	li	a2,10
    3b04:	fa040593          	addi	a1,s0,-96
    3b08:	854a                	mv	a0,s2
    3b0a:	761000ef          	jal	ra,4a6a <write>
    3b0e:	47a9                	li	a5,10
    3b10:	02f51363          	bne	a0,a5,3b36 <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b14:	34fd                	addiw	s1,s1,-1
    3b16:	f4f5                	bnez	s1,3b02 <sharedfd+0x58>
  if(pid == 0) {
    3b18:	02099963          	bnez	s3,3b4a <sharedfd+0xa0>
    exit(0);
    3b1c:	4501                	li	a0,0
    3b1e:	72d000ef          	jal	ra,4a4a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b22:	85d2                	mv	a1,s4
    3b24:	00003517          	auipc	a0,0x3
    3b28:	08c50513          	addi	a0,a0,140 # 6bb0 <malloc+0x1ca2>
    3b2c:	328010ef          	jal	ra,4e54 <printf>
    exit(1);
    3b30:	4505                	li	a0,1
    3b32:	719000ef          	jal	ra,4a4a <exit>
      printf("%s: write sharedfd failed\n", s);
    3b36:	85d2                	mv	a1,s4
    3b38:	00003517          	auipc	a0,0x3
    3b3c:	0a050513          	addi	a0,a0,160 # 6bd8 <malloc+0x1cca>
    3b40:	314010ef          	jal	ra,4e54 <printf>
      exit(1);
    3b44:	4505                	li	a0,1
    3b46:	705000ef          	jal	ra,4a4a <exit>
    wait(&xstatus);
    3b4a:	f9c40513          	addi	a0,s0,-100
    3b4e:	705000ef          	jal	ra,4a52 <wait>
    if(xstatus != 0)
    3b52:	f9c42983          	lw	s3,-100(s0)
    3b56:	00098563          	beqz	s3,3b60 <sharedfd+0xb6>
      exit(xstatus);
    3b5a:	854e                	mv	a0,s3
    3b5c:	6ef000ef          	jal	ra,4a4a <exit>
  close(fd);
    3b60:	854a                	mv	a0,s2
    3b62:	711000ef          	jal	ra,4a72 <close>
  fd = open("sharedfd", 0);
    3b66:	4581                	li	a1,0
    3b68:	00003517          	auipc	a0,0x3
    3b6c:	03850513          	addi	a0,a0,56 # 6ba0 <malloc+0x1c92>
    3b70:	71b000ef          	jal	ra,4a8a <open>
    3b74:	8baa                	mv	s7,a0
  nc = np = 0;
    3b76:	8ace                	mv	s5,s3
  if(fd < 0){
    3b78:	02054363          	bltz	a0,3b9e <sharedfd+0xf4>
    3b7c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3b80:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b84:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b88:	4629                	li	a2,10
    3b8a:	fa040593          	addi	a1,s0,-96
    3b8e:	855e                	mv	a0,s7
    3b90:	6d3000ef          	jal	ra,4a62 <read>
    3b94:	02a05b63          	blez	a0,3bca <sharedfd+0x120>
    3b98:	fa040793          	addi	a5,s0,-96
    3b9c:	a839                	j	3bba <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3b9e:	85d2                	mv	a1,s4
    3ba0:	00003517          	auipc	a0,0x3
    3ba4:	05850513          	addi	a0,a0,88 # 6bf8 <malloc+0x1cea>
    3ba8:	2ac010ef          	jal	ra,4e54 <printf>
    exit(1);
    3bac:	4505                	li	a0,1
    3bae:	69d000ef          	jal	ra,4a4a <exit>
        nc++;
    3bb2:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3bb4:	0785                	addi	a5,a5,1
    3bb6:	fd2789e3          	beq	a5,s2,3b88 <sharedfd+0xde>
      if(buf[i] == 'c')
    3bba:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7f1388>
    3bbe:	fe970ae3          	beq	a4,s1,3bb2 <sharedfd+0x108>
      if(buf[i] == 'p')
    3bc2:	ff6719e3          	bne	a4,s6,3bb4 <sharedfd+0x10a>
        np++;
    3bc6:	2a85                	addiw	s5,s5,1
    3bc8:	b7f5                	j	3bb4 <sharedfd+0x10a>
  close(fd);
    3bca:	855e                	mv	a0,s7
    3bcc:	6a7000ef          	jal	ra,4a72 <close>
  unlink("sharedfd");
    3bd0:	00003517          	auipc	a0,0x3
    3bd4:	fd050513          	addi	a0,a0,-48 # 6ba0 <malloc+0x1c92>
    3bd8:	6c3000ef          	jal	ra,4a9a <unlink>
  if(nc == N*SZ && np == N*SZ){
    3bdc:	6789                	lui	a5,0x2
    3bde:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xc2>
    3be2:	00f99763          	bne	s3,a5,3bf0 <sharedfd+0x146>
    3be6:	6789                	lui	a5,0x2
    3be8:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xc2>
    3bec:	00fa8c63          	beq	s5,a5,3c04 <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3bf0:	85d2                	mv	a1,s4
    3bf2:	00003517          	auipc	a0,0x3
    3bf6:	02e50513          	addi	a0,a0,46 # 6c20 <malloc+0x1d12>
    3bfa:	25a010ef          	jal	ra,4e54 <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	64b000ef          	jal	ra,4a4a <exit>
    exit(0);
    3c04:	4501                	li	a0,0
    3c06:	645000ef          	jal	ra,4a4a <exit>

0000000000003c0a <fourfiles>:
{
    3c0a:	7171                	addi	sp,sp,-176
    3c0c:	f506                	sd	ra,168(sp)
    3c0e:	f122                	sd	s0,160(sp)
    3c10:	ed26                	sd	s1,152(sp)
    3c12:	e94a                	sd	s2,144(sp)
    3c14:	e54e                	sd	s3,136(sp)
    3c16:	e152                	sd	s4,128(sp)
    3c18:	fcd6                	sd	s5,120(sp)
    3c1a:	f8da                	sd	s6,112(sp)
    3c1c:	f4de                	sd	s7,104(sp)
    3c1e:	f0e2                	sd	s8,96(sp)
    3c20:	ece6                	sd	s9,88(sp)
    3c22:	e8ea                	sd	s10,80(sp)
    3c24:	e4ee                	sd	s11,72(sp)
    3c26:	1900                	addi	s0,sp,176
    3c28:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c2a:	00001797          	auipc	a5,0x1
    3c2e:	3c678793          	addi	a5,a5,966 # 4ff0 <malloc+0xe2>
    3c32:	f6f43823          	sd	a5,-144(s0)
    3c36:	00001797          	auipc	a5,0x1
    3c3a:	3c278793          	addi	a5,a5,962 # 4ff8 <malloc+0xea>
    3c3e:	f6f43c23          	sd	a5,-136(s0)
    3c42:	00001797          	auipc	a5,0x1
    3c46:	3be78793          	addi	a5,a5,958 # 5000 <malloc+0xf2>
    3c4a:	f8f43023          	sd	a5,-128(s0)
    3c4e:	00001797          	auipc	a5,0x1
    3c52:	3ba78793          	addi	a5,a5,954 # 5008 <malloc+0xfa>
    3c56:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c5a:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c5e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3c60:	4481                	li	s1,0
    3c62:	4a11                	li	s4,4
    fname = names[pi];
    3c64:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c68:	854e                	mv	a0,s3
    3c6a:	631000ef          	jal	ra,4a9a <unlink>
    pid = fork();
    3c6e:	5d5000ef          	jal	ra,4a42 <fork>
    if(pid < 0){
    3c72:	04054363          	bltz	a0,3cb8 <fourfiles+0xae>
    if(pid == 0){
    3c76:	c939                	beqz	a0,3ccc <fourfiles+0xc2>
  for(pi = 0; pi < NCHILD; pi++){
    3c78:	2485                	addiw	s1,s1,1
    3c7a:	0921                	addi	s2,s2,8
    3c7c:	ff4494e3          	bne	s1,s4,3c64 <fourfiles+0x5a>
    3c80:	4491                	li	s1,4
    wait(&xstatus);
    3c82:	f6c40513          	addi	a0,s0,-148
    3c86:	5cd000ef          	jal	ra,4a52 <wait>
    if(xstatus != 0)
    3c8a:	f6c42503          	lw	a0,-148(s0)
    3c8e:	e94d                	bnez	a0,3d40 <fourfiles+0x136>
  for(pi = 0; pi < NCHILD; pi++){
    3c90:	34fd                	addiw	s1,s1,-1
    3c92:	f8e5                	bnez	s1,3c82 <fourfiles+0x78>
    3c94:	03000b13          	li	s6,48
    total = 0;
    3c98:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c9c:	00008a17          	auipc	s4,0x8
    3ca0:	fdca0a13          	addi	s4,s4,-36 # bc78 <buf>
    3ca4:	00008a97          	auipc	s5,0x8
    3ca8:	fd5a8a93          	addi	s5,s5,-43 # bc79 <buf+0x1>
    if(total != N*SZ){
    3cac:	6d05                	lui	s10,0x1
    3cae:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x40>
  for(i = 0; i < NCHILD; i++){
    3cb2:	03400d93          	li	s11,52
    3cb6:	a0fd                	j	3da4 <fourfiles+0x19a>
      printf("%s: fork failed\n", s);
    3cb8:	85e6                	mv	a1,s9
    3cba:	00002517          	auipc	a0,0x2
    3cbe:	c1e50513          	addi	a0,a0,-994 # 58d8 <malloc+0x9ca>
    3cc2:	192010ef          	jal	ra,4e54 <printf>
      exit(1);
    3cc6:	4505                	li	a0,1
    3cc8:	583000ef          	jal	ra,4a4a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3ccc:	20200593          	li	a1,514
    3cd0:	854e                	mv	a0,s3
    3cd2:	5b9000ef          	jal	ra,4a8a <open>
    3cd6:	892a                	mv	s2,a0
      if(fd < 0){
    3cd8:	04054163          	bltz	a0,3d1a <fourfiles+0x110>
      memset(buf, '0'+pi, SZ);
    3cdc:	1f400613          	li	a2,500
    3ce0:	0304859b          	addiw	a1,s1,48
    3ce4:	00008517          	auipc	a0,0x8
    3ce8:	f9450513          	addi	a0,a0,-108 # bc78 <buf>
    3cec:	36f000ef          	jal	ra,485a <memset>
    3cf0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3cf2:	00008997          	auipc	s3,0x8
    3cf6:	f8698993          	addi	s3,s3,-122 # bc78 <buf>
    3cfa:	1f400613          	li	a2,500
    3cfe:	85ce                	mv	a1,s3
    3d00:	854a                	mv	a0,s2
    3d02:	569000ef          	jal	ra,4a6a <write>
    3d06:	85aa                	mv	a1,a0
    3d08:	1f400793          	li	a5,500
    3d0c:	02f51163          	bne	a0,a5,3d2e <fourfiles+0x124>
      for(i = 0; i < N; i++){
    3d10:	34fd                	addiw	s1,s1,-1
    3d12:	f4e5                	bnez	s1,3cfa <fourfiles+0xf0>
      exit(0);
    3d14:	4501                	li	a0,0
    3d16:	535000ef          	jal	ra,4a4a <exit>
        printf("%s: create failed\n", s);
    3d1a:	85e6                	mv	a1,s9
    3d1c:	00002517          	auipc	a0,0x2
    3d20:	c5450513          	addi	a0,a0,-940 # 5970 <malloc+0xa62>
    3d24:	130010ef          	jal	ra,4e54 <printf>
        exit(1);
    3d28:	4505                	li	a0,1
    3d2a:	521000ef          	jal	ra,4a4a <exit>
          printf("write failed %d\n", n);
    3d2e:	00003517          	auipc	a0,0x3
    3d32:	f0a50513          	addi	a0,a0,-246 # 6c38 <malloc+0x1d2a>
    3d36:	11e010ef          	jal	ra,4e54 <printf>
          exit(1);
    3d3a:	4505                	li	a0,1
    3d3c:	50f000ef          	jal	ra,4a4a <exit>
      exit(xstatus);
    3d40:	50b000ef          	jal	ra,4a4a <exit>
          printf("%s: wrong char\n", s);
    3d44:	85e6                	mv	a1,s9
    3d46:	00003517          	auipc	a0,0x3
    3d4a:	f0a50513          	addi	a0,a0,-246 # 6c50 <malloc+0x1d42>
    3d4e:	106010ef          	jal	ra,4e54 <printf>
          exit(1);
    3d52:	4505                	li	a0,1
    3d54:	4f7000ef          	jal	ra,4a4a <exit>
      total += n;
    3d58:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d5c:	660d                	lui	a2,0x3
    3d5e:	85d2                	mv	a1,s4
    3d60:	854e                	mv	a0,s3
    3d62:	501000ef          	jal	ra,4a62 <read>
    3d66:	02a05363          	blez	a0,3d8c <fourfiles+0x182>
    3d6a:	00008797          	auipc	a5,0x8
    3d6e:	f0e78793          	addi	a5,a5,-242 # bc78 <buf>
    3d72:	fff5069b          	addiw	a3,a0,-1
    3d76:	1682                	slli	a3,a3,0x20
    3d78:	9281                	srli	a3,a3,0x20
    3d7a:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    3d7c:	0007c703          	lbu	a4,0(a5)
    3d80:	fc9712e3          	bne	a4,s1,3d44 <fourfiles+0x13a>
      for(j = 0; j < n; j++){
    3d84:	0785                	addi	a5,a5,1
    3d86:	fed79be3          	bne	a5,a3,3d7c <fourfiles+0x172>
    3d8a:	b7f9                	j	3d58 <fourfiles+0x14e>
    close(fd);
    3d8c:	854e                	mv	a0,s3
    3d8e:	4e5000ef          	jal	ra,4a72 <close>
    if(total != N*SZ){
    3d92:	03a91563          	bne	s2,s10,3dbc <fourfiles+0x1b2>
    unlink(fname);
    3d96:	8562                	mv	a0,s8
    3d98:	503000ef          	jal	ra,4a9a <unlink>
  for(i = 0; i < NCHILD; i++){
    3d9c:	0ba1                	addi	s7,s7,8
    3d9e:	2b05                	addiw	s6,s6,1
    3da0:	03bb0863          	beq	s6,s11,3dd0 <fourfiles+0x1c6>
    fname = names[i];
    3da4:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3da8:	4581                	li	a1,0
    3daa:	8562                	mv	a0,s8
    3dac:	4df000ef          	jal	ra,4a8a <open>
    3db0:	89aa                	mv	s3,a0
    total = 0;
    3db2:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    3db6:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dba:	b74d                	j	3d5c <fourfiles+0x152>
      printf("wrong length %d\n", total);
    3dbc:	85ca                	mv	a1,s2
    3dbe:	00003517          	auipc	a0,0x3
    3dc2:	ea250513          	addi	a0,a0,-350 # 6c60 <malloc+0x1d52>
    3dc6:	08e010ef          	jal	ra,4e54 <printf>
      exit(1);
    3dca:	4505                	li	a0,1
    3dcc:	47f000ef          	jal	ra,4a4a <exit>
}
    3dd0:	70aa                	ld	ra,168(sp)
    3dd2:	740a                	ld	s0,160(sp)
    3dd4:	64ea                	ld	s1,152(sp)
    3dd6:	694a                	ld	s2,144(sp)
    3dd8:	69aa                	ld	s3,136(sp)
    3dda:	6a0a                	ld	s4,128(sp)
    3ddc:	7ae6                	ld	s5,120(sp)
    3dde:	7b46                	ld	s6,112(sp)
    3de0:	7ba6                	ld	s7,104(sp)
    3de2:	7c06                	ld	s8,96(sp)
    3de4:	6ce6                	ld	s9,88(sp)
    3de6:	6d46                	ld	s10,80(sp)
    3de8:	6da6                	ld	s11,72(sp)
    3dea:	614d                	addi	sp,sp,176
    3dec:	8082                	ret

0000000000003dee <concreate>:
{
    3dee:	7135                	addi	sp,sp,-160
    3df0:	ed06                	sd	ra,152(sp)
    3df2:	e922                	sd	s0,144(sp)
    3df4:	e526                	sd	s1,136(sp)
    3df6:	e14a                	sd	s2,128(sp)
    3df8:	fcce                	sd	s3,120(sp)
    3dfa:	f8d2                	sd	s4,112(sp)
    3dfc:	f4d6                	sd	s5,104(sp)
    3dfe:	f0da                	sd	s6,96(sp)
    3e00:	ecde                	sd	s7,88(sp)
    3e02:	1100                	addi	s0,sp,160
    3e04:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e06:	04300793          	li	a5,67
    3e0a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e0e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e12:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e14:	4b0d                	li	s6,3
    3e16:	4a85                	li	s5,1
      link("C0", file);
    3e18:	00003b97          	auipc	s7,0x3
    3e1c:	e60b8b93          	addi	s7,s7,-416 # 6c78 <malloc+0x1d6a>
  for(i = 0; i < N; i++){
    3e20:	02800a13          	li	s4,40
    3e24:	a415                	j	4048 <concreate+0x25a>
      link("C0", file);
    3e26:	fa840593          	addi	a1,s0,-88
    3e2a:	855e                	mv	a0,s7
    3e2c:	47f000ef          	jal	ra,4aaa <link>
    if(pid == 0) {
    3e30:	a409                	j	4032 <concreate+0x244>
    } else if(pid == 0 && (i % 5) == 1){
    3e32:	4795                	li	a5,5
    3e34:	02f9693b          	remw	s2,s2,a5
    3e38:	4785                	li	a5,1
    3e3a:	02f90563          	beq	s2,a5,3e64 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e3e:	20200593          	li	a1,514
    3e42:	fa840513          	addi	a0,s0,-88
    3e46:	445000ef          	jal	ra,4a8a <open>
      if(fd < 0){
    3e4a:	1c055f63          	bgez	a0,4028 <concreate+0x23a>
        printf("concreate create %s failed\n", file);
    3e4e:	fa840593          	addi	a1,s0,-88
    3e52:	00003517          	auipc	a0,0x3
    3e56:	e2e50513          	addi	a0,a0,-466 # 6c80 <malloc+0x1d72>
    3e5a:	7fb000ef          	jal	ra,4e54 <printf>
        exit(1);
    3e5e:	4505                	li	a0,1
    3e60:	3eb000ef          	jal	ra,4a4a <exit>
      link("C0", file);
    3e64:	fa840593          	addi	a1,s0,-88
    3e68:	00003517          	auipc	a0,0x3
    3e6c:	e1050513          	addi	a0,a0,-496 # 6c78 <malloc+0x1d6a>
    3e70:	43b000ef          	jal	ra,4aaa <link>
      exit(0);
    3e74:	4501                	li	a0,0
    3e76:	3d5000ef          	jal	ra,4a4a <exit>
        exit(1);
    3e7a:	4505                	li	a0,1
    3e7c:	3cf000ef          	jal	ra,4a4a <exit>
  memset(fa, 0, sizeof(fa));
    3e80:	02800613          	li	a2,40
    3e84:	4581                	li	a1,0
    3e86:	f8040513          	addi	a0,s0,-128
    3e8a:	1d1000ef          	jal	ra,485a <memset>
  fd = open(".", 0);
    3e8e:	4581                	li	a1,0
    3e90:	00002517          	auipc	a0,0x2
    3e94:	8a050513          	addi	a0,a0,-1888 # 5730 <malloc+0x822>
    3e98:	3f3000ef          	jal	ra,4a8a <open>
    3e9c:	892a                	mv	s2,a0
  n = 0;
    3e9e:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ea0:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3ea4:	02700b13          	li	s6,39
      fa[i] = 1;
    3ea8:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3eaa:	a01d                	j	3ed0 <concreate+0xe2>
        printf("%s: concreate weird file %s\n", s, de.name);
    3eac:	f7240613          	addi	a2,s0,-142
    3eb0:	85ce                	mv	a1,s3
    3eb2:	00003517          	auipc	a0,0x3
    3eb6:	dee50513          	addi	a0,a0,-530 # 6ca0 <malloc+0x1d92>
    3eba:	79b000ef          	jal	ra,4e54 <printf>
        exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	38b000ef          	jal	ra,4a4a <exit>
      fa[i] = 1;
    3ec4:	fb040793          	addi	a5,s0,-80
    3ec8:	973e                	add	a4,a4,a5
    3eca:	fd770823          	sb	s7,-48(a4)
      n++;
    3ece:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    3ed0:	4641                	li	a2,16
    3ed2:	f7040593          	addi	a1,s0,-144
    3ed6:	854a                	mv	a0,s2
    3ed8:	38b000ef          	jal	ra,4a62 <read>
    3edc:	04a05663          	blez	a0,3f28 <concreate+0x13a>
    if(de.inum == 0)
    3ee0:	f7045783          	lhu	a5,-144(s0)
    3ee4:	d7f5                	beqz	a5,3ed0 <concreate+0xe2>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ee6:	f7244783          	lbu	a5,-142(s0)
    3eea:	ff4793e3          	bne	a5,s4,3ed0 <concreate+0xe2>
    3eee:	f7444783          	lbu	a5,-140(s0)
    3ef2:	fff9                	bnez	a5,3ed0 <concreate+0xe2>
      i = de.name[1] - '0';
    3ef4:	f7344783          	lbu	a5,-141(s0)
    3ef8:	fd07879b          	addiw	a5,a5,-48
    3efc:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f00:	faeb66e3          	bltu	s6,a4,3eac <concreate+0xbe>
      if(fa[i]){
    3f04:	fb040793          	addi	a5,s0,-80
    3f08:	97ba                	add	a5,a5,a4
    3f0a:	fd07c783          	lbu	a5,-48(a5)
    3f0e:	dbdd                	beqz	a5,3ec4 <concreate+0xd6>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f10:	f7240613          	addi	a2,s0,-142
    3f14:	85ce                	mv	a1,s3
    3f16:	00003517          	auipc	a0,0x3
    3f1a:	daa50513          	addi	a0,a0,-598 # 6cc0 <malloc+0x1db2>
    3f1e:	737000ef          	jal	ra,4e54 <printf>
        exit(1);
    3f22:	4505                	li	a0,1
    3f24:	327000ef          	jal	ra,4a4a <exit>
  close(fd);
    3f28:	854a                	mv	a0,s2
    3f2a:	349000ef          	jal	ra,4a72 <close>
  if(n != N){
    3f2e:	02800793          	li	a5,40
    3f32:	00fa9763          	bne	s5,a5,3f40 <concreate+0x152>
    if(((i % 3) == 0 && pid == 0) ||
    3f36:	4a8d                	li	s5,3
    3f38:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f3a:	02800a13          	li	s4,40
    3f3e:	a079                	j	3fcc <concreate+0x1de>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f40:	85ce                	mv	a1,s3
    3f42:	00003517          	auipc	a0,0x3
    3f46:	da650513          	addi	a0,a0,-602 # 6ce8 <malloc+0x1dda>
    3f4a:	70b000ef          	jal	ra,4e54 <printf>
    exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	2fb000ef          	jal	ra,4a4a <exit>
      printf("%s: fork failed\n", s);
    3f54:	85ce                	mv	a1,s3
    3f56:	00002517          	auipc	a0,0x2
    3f5a:	98250513          	addi	a0,a0,-1662 # 58d8 <malloc+0x9ca>
    3f5e:	6f7000ef          	jal	ra,4e54 <printf>
      exit(1);
    3f62:	4505                	li	a0,1
    3f64:	2e7000ef          	jal	ra,4a4a <exit>
      close(open(file, 0));
    3f68:	4581                	li	a1,0
    3f6a:	fa840513          	addi	a0,s0,-88
    3f6e:	31d000ef          	jal	ra,4a8a <open>
    3f72:	301000ef          	jal	ra,4a72 <close>
      close(open(file, 0));
    3f76:	4581                	li	a1,0
    3f78:	fa840513          	addi	a0,s0,-88
    3f7c:	30f000ef          	jal	ra,4a8a <open>
    3f80:	2f3000ef          	jal	ra,4a72 <close>
      close(open(file, 0));
    3f84:	4581                	li	a1,0
    3f86:	fa840513          	addi	a0,s0,-88
    3f8a:	301000ef          	jal	ra,4a8a <open>
    3f8e:	2e5000ef          	jal	ra,4a72 <close>
      close(open(file, 0));
    3f92:	4581                	li	a1,0
    3f94:	fa840513          	addi	a0,s0,-88
    3f98:	2f3000ef          	jal	ra,4a8a <open>
    3f9c:	2d7000ef          	jal	ra,4a72 <close>
      close(open(file, 0));
    3fa0:	4581                	li	a1,0
    3fa2:	fa840513          	addi	a0,s0,-88
    3fa6:	2e5000ef          	jal	ra,4a8a <open>
    3faa:	2c9000ef          	jal	ra,4a72 <close>
      close(open(file, 0));
    3fae:	4581                	li	a1,0
    3fb0:	fa840513          	addi	a0,s0,-88
    3fb4:	2d7000ef          	jal	ra,4a8a <open>
    3fb8:	2bb000ef          	jal	ra,4a72 <close>
    if(pid == 0)
    3fbc:	06090363          	beqz	s2,4022 <concreate+0x234>
      wait(0);
    3fc0:	4501                	li	a0,0
    3fc2:	291000ef          	jal	ra,4a52 <wait>
  for(i = 0; i < N; i++){
    3fc6:	2485                	addiw	s1,s1,1
    3fc8:	0b448963          	beq	s1,s4,407a <concreate+0x28c>
    file[1] = '0' + i;
    3fcc:	0304879b          	addiw	a5,s1,48
    3fd0:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fd4:	26f000ef          	jal	ra,4a42 <fork>
    3fd8:	892a                	mv	s2,a0
    if(pid < 0){
    3fda:	f6054de3          	bltz	a0,3f54 <concreate+0x166>
    if(((i % 3) == 0 && pid == 0) ||
    3fde:	0354e73b          	remw	a4,s1,s5
    3fe2:	00a767b3          	or	a5,a4,a0
    3fe6:	2781                	sext.w	a5,a5
    3fe8:	d3c1                	beqz	a5,3f68 <concreate+0x17a>
    3fea:	01671363          	bne	a4,s6,3ff0 <concreate+0x202>
       ((i % 3) == 1 && pid != 0)){
    3fee:	fd2d                	bnez	a0,3f68 <concreate+0x17a>
      unlink(file);
    3ff0:	fa840513          	addi	a0,s0,-88
    3ff4:	2a7000ef          	jal	ra,4a9a <unlink>
      unlink(file);
    3ff8:	fa840513          	addi	a0,s0,-88
    3ffc:	29f000ef          	jal	ra,4a9a <unlink>
      unlink(file);
    4000:	fa840513          	addi	a0,s0,-88
    4004:	297000ef          	jal	ra,4a9a <unlink>
      unlink(file);
    4008:	fa840513          	addi	a0,s0,-88
    400c:	28f000ef          	jal	ra,4a9a <unlink>
      unlink(file);
    4010:	fa840513          	addi	a0,s0,-88
    4014:	287000ef          	jal	ra,4a9a <unlink>
      unlink(file);
    4018:	fa840513          	addi	a0,s0,-88
    401c:	27f000ef          	jal	ra,4a9a <unlink>
    4020:	bf71                	j	3fbc <concreate+0x1ce>
      exit(0);
    4022:	4501                	li	a0,0
    4024:	227000ef          	jal	ra,4a4a <exit>
      close(fd);
    4028:	24b000ef          	jal	ra,4a72 <close>
    if(pid == 0) {
    402c:	b5a1                	j	3e74 <concreate+0x86>
      close(fd);
    402e:	245000ef          	jal	ra,4a72 <close>
      wait(&xstatus);
    4032:	f6c40513          	addi	a0,s0,-148
    4036:	21d000ef          	jal	ra,4a52 <wait>
      if(xstatus != 0)
    403a:	f6c42483          	lw	s1,-148(s0)
    403e:	e2049ee3          	bnez	s1,3e7a <concreate+0x8c>
  for(i = 0; i < N; i++){
    4042:	2905                	addiw	s2,s2,1
    4044:	e3490ee3          	beq	s2,s4,3e80 <concreate+0x92>
    file[1] = '0' + i;
    4048:	0309079b          	addiw	a5,s2,48
    404c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4050:	fa840513          	addi	a0,s0,-88
    4054:	247000ef          	jal	ra,4a9a <unlink>
    pid = fork();
    4058:	1eb000ef          	jal	ra,4a42 <fork>
    if(pid && (i % 3) == 1){
    405c:	dc050be3          	beqz	a0,3e32 <concreate+0x44>
    4060:	036967bb          	remw	a5,s2,s6
    4064:	dd5781e3          	beq	a5,s5,3e26 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4068:	20200593          	li	a1,514
    406c:	fa840513          	addi	a0,s0,-88
    4070:	21b000ef          	jal	ra,4a8a <open>
      if(fd < 0){
    4074:	fa055de3          	bgez	a0,402e <concreate+0x240>
    4078:	bbd9                	j	3e4e <concreate+0x60>
}
    407a:	60ea                	ld	ra,152(sp)
    407c:	644a                	ld	s0,144(sp)
    407e:	64aa                	ld	s1,136(sp)
    4080:	690a                	ld	s2,128(sp)
    4082:	79e6                	ld	s3,120(sp)
    4084:	7a46                	ld	s4,112(sp)
    4086:	7aa6                	ld	s5,104(sp)
    4088:	7b06                	ld	s6,96(sp)
    408a:	6be6                	ld	s7,88(sp)
    408c:	610d                	addi	sp,sp,160
    408e:	8082                	ret

0000000000004090 <bigfile>:
{
    4090:	7139                	addi	sp,sp,-64
    4092:	fc06                	sd	ra,56(sp)
    4094:	f822                	sd	s0,48(sp)
    4096:	f426                	sd	s1,40(sp)
    4098:	f04a                	sd	s2,32(sp)
    409a:	ec4e                	sd	s3,24(sp)
    409c:	e852                	sd	s4,16(sp)
    409e:	e456                	sd	s5,8(sp)
    40a0:	0080                	addi	s0,sp,64
    40a2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40a4:	00003517          	auipc	a0,0x3
    40a8:	c7c50513          	addi	a0,a0,-900 # 6d20 <malloc+0x1e12>
    40ac:	1ef000ef          	jal	ra,4a9a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40b0:	20200593          	li	a1,514
    40b4:	00003517          	auipc	a0,0x3
    40b8:	c6c50513          	addi	a0,a0,-916 # 6d20 <malloc+0x1e12>
    40bc:	1cf000ef          	jal	ra,4a8a <open>
    40c0:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40c2:	4481                	li	s1,0
    memset(buf, i, SZ);
    40c4:	00008917          	auipc	s2,0x8
    40c8:	bb490913          	addi	s2,s2,-1100 # bc78 <buf>
  for(i = 0; i < N; i++){
    40cc:	4a51                	li	s4,20
  if(fd < 0){
    40ce:	08054663          	bltz	a0,415a <bigfile+0xca>
    memset(buf, i, SZ);
    40d2:	25800613          	li	a2,600
    40d6:	85a6                	mv	a1,s1
    40d8:	854a                	mv	a0,s2
    40da:	780000ef          	jal	ra,485a <memset>
    if(write(fd, buf, SZ) != SZ){
    40de:	25800613          	li	a2,600
    40e2:	85ca                	mv	a1,s2
    40e4:	854e                	mv	a0,s3
    40e6:	185000ef          	jal	ra,4a6a <write>
    40ea:	25800793          	li	a5,600
    40ee:	08f51063          	bne	a0,a5,416e <bigfile+0xde>
  for(i = 0; i < N; i++){
    40f2:	2485                	addiw	s1,s1,1
    40f4:	fd449fe3          	bne	s1,s4,40d2 <bigfile+0x42>
  close(fd);
    40f8:	854e                	mv	a0,s3
    40fa:	179000ef          	jal	ra,4a72 <close>
  fd = open("bigfile.dat", 0);
    40fe:	4581                	li	a1,0
    4100:	00003517          	auipc	a0,0x3
    4104:	c2050513          	addi	a0,a0,-992 # 6d20 <malloc+0x1e12>
    4108:	183000ef          	jal	ra,4a8a <open>
    410c:	8a2a                	mv	s4,a0
  total = 0;
    410e:	4981                	li	s3,0
  for(i = 0; ; i++){
    4110:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4112:	00008917          	auipc	s2,0x8
    4116:	b6690913          	addi	s2,s2,-1178 # bc78 <buf>
  if(fd < 0){
    411a:	06054463          	bltz	a0,4182 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    411e:	12c00613          	li	a2,300
    4122:	85ca                	mv	a1,s2
    4124:	8552                	mv	a0,s4
    4126:	13d000ef          	jal	ra,4a62 <read>
    if(cc < 0){
    412a:	06054663          	bltz	a0,4196 <bigfile+0x106>
    if(cc == 0)
    412e:	c155                	beqz	a0,41d2 <bigfile+0x142>
    if(cc != SZ/2){
    4130:	12c00793          	li	a5,300
    4134:	06f51b63          	bne	a0,a5,41aa <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4138:	01f4d79b          	srliw	a5,s1,0x1f
    413c:	9fa5                	addw	a5,a5,s1
    413e:	4017d79b          	sraiw	a5,a5,0x1
    4142:	00094703          	lbu	a4,0(s2)
    4146:	06f71c63          	bne	a4,a5,41be <bigfile+0x12e>
    414a:	12b94703          	lbu	a4,299(s2)
    414e:	06f71863          	bne	a4,a5,41be <bigfile+0x12e>
    total += cc;
    4152:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4156:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4158:	b7d9                	j	411e <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    415a:	85d6                	mv	a1,s5
    415c:	00003517          	auipc	a0,0x3
    4160:	bd450513          	addi	a0,a0,-1068 # 6d30 <malloc+0x1e22>
    4164:	4f1000ef          	jal	ra,4e54 <printf>
    exit(1);
    4168:	4505                	li	a0,1
    416a:	0e1000ef          	jal	ra,4a4a <exit>
      printf("%s: write bigfile failed\n", s);
    416e:	85d6                	mv	a1,s5
    4170:	00003517          	auipc	a0,0x3
    4174:	be050513          	addi	a0,a0,-1056 # 6d50 <malloc+0x1e42>
    4178:	4dd000ef          	jal	ra,4e54 <printf>
      exit(1);
    417c:	4505                	li	a0,1
    417e:	0cd000ef          	jal	ra,4a4a <exit>
    printf("%s: cannot open bigfile\n", s);
    4182:	85d6                	mv	a1,s5
    4184:	00003517          	auipc	a0,0x3
    4188:	bec50513          	addi	a0,a0,-1044 # 6d70 <malloc+0x1e62>
    418c:	4c9000ef          	jal	ra,4e54 <printf>
    exit(1);
    4190:	4505                	li	a0,1
    4192:	0b9000ef          	jal	ra,4a4a <exit>
      printf("%s: read bigfile failed\n", s);
    4196:	85d6                	mv	a1,s5
    4198:	00003517          	auipc	a0,0x3
    419c:	bf850513          	addi	a0,a0,-1032 # 6d90 <malloc+0x1e82>
    41a0:	4b5000ef          	jal	ra,4e54 <printf>
      exit(1);
    41a4:	4505                	li	a0,1
    41a6:	0a5000ef          	jal	ra,4a4a <exit>
      printf("%s: short read bigfile\n", s);
    41aa:	85d6                	mv	a1,s5
    41ac:	00003517          	auipc	a0,0x3
    41b0:	c0450513          	addi	a0,a0,-1020 # 6db0 <malloc+0x1ea2>
    41b4:	4a1000ef          	jal	ra,4e54 <printf>
      exit(1);
    41b8:	4505                	li	a0,1
    41ba:	091000ef          	jal	ra,4a4a <exit>
      printf("%s: read bigfile wrong data\n", s);
    41be:	85d6                	mv	a1,s5
    41c0:	00003517          	auipc	a0,0x3
    41c4:	c0850513          	addi	a0,a0,-1016 # 6dc8 <malloc+0x1eba>
    41c8:	48d000ef          	jal	ra,4e54 <printf>
      exit(1);
    41cc:	4505                	li	a0,1
    41ce:	07d000ef          	jal	ra,4a4a <exit>
  close(fd);
    41d2:	8552                	mv	a0,s4
    41d4:	09f000ef          	jal	ra,4a72 <close>
  if(total != N*SZ){
    41d8:	678d                	lui	a5,0x3
    41da:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x34a>
    41de:	02f99163          	bne	s3,a5,4200 <bigfile+0x170>
  unlink("bigfile.dat");
    41e2:	00003517          	auipc	a0,0x3
    41e6:	b3e50513          	addi	a0,a0,-1218 # 6d20 <malloc+0x1e12>
    41ea:	0b1000ef          	jal	ra,4a9a <unlink>
}
    41ee:	70e2                	ld	ra,56(sp)
    41f0:	7442                	ld	s0,48(sp)
    41f2:	74a2                	ld	s1,40(sp)
    41f4:	7902                	ld	s2,32(sp)
    41f6:	69e2                	ld	s3,24(sp)
    41f8:	6a42                	ld	s4,16(sp)
    41fa:	6aa2                	ld	s5,8(sp)
    41fc:	6121                	addi	sp,sp,64
    41fe:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4200:	85d6                	mv	a1,s5
    4202:	00003517          	auipc	a0,0x3
    4206:	be650513          	addi	a0,a0,-1050 # 6de8 <malloc+0x1eda>
    420a:	44b000ef          	jal	ra,4e54 <printf>
    exit(1);
    420e:	4505                	li	a0,1
    4210:	03b000ef          	jal	ra,4a4a <exit>

0000000000004214 <bigargtest>:
{
    4214:	7121                	addi	sp,sp,-448
    4216:	ff06                	sd	ra,440(sp)
    4218:	fb22                	sd	s0,432(sp)
    421a:	f726                	sd	s1,424(sp)
    421c:	0380                	addi	s0,sp,448
    421e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4220:	00003517          	auipc	a0,0x3
    4224:	be850513          	addi	a0,a0,-1048 # 6e08 <malloc+0x1efa>
    4228:	073000ef          	jal	ra,4a9a <unlink>
  pid = fork();
    422c:	017000ef          	jal	ra,4a42 <fork>
  if(pid == 0){
    4230:	c915                	beqz	a0,4264 <bigargtest+0x50>
  } else if(pid < 0){
    4232:	08054a63          	bltz	a0,42c6 <bigargtest+0xb2>
  wait(&xstatus);
    4236:	fdc40513          	addi	a0,s0,-36
    423a:	019000ef          	jal	ra,4a52 <wait>
  if(xstatus != 0)
    423e:	fdc42503          	lw	a0,-36(s0)
    4242:	ed41                	bnez	a0,42da <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4244:	4581                	li	a1,0
    4246:	00003517          	auipc	a0,0x3
    424a:	bc250513          	addi	a0,a0,-1086 # 6e08 <malloc+0x1efa>
    424e:	03d000ef          	jal	ra,4a8a <open>
  if(fd < 0){
    4252:	08054663          	bltz	a0,42de <bigargtest+0xca>
  close(fd);
    4256:	01d000ef          	jal	ra,4a72 <close>
}
    425a:	70fa                	ld	ra,440(sp)
    425c:	745a                	ld	s0,432(sp)
    425e:	74ba                	ld	s1,424(sp)
    4260:	6139                	addi	sp,sp,448
    4262:	8082                	ret
    memset(big, ' ', sizeof(big));
    4264:	19000613          	li	a2,400
    4268:	02000593          	li	a1,32
    426c:	e4840513          	addi	a0,s0,-440
    4270:	5ea000ef          	jal	ra,485a <memset>
    big[sizeof(big)-1] = '\0';
    4274:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4278:	00004797          	auipc	a5,0x4
    427c:	1e878793          	addi	a5,a5,488 # 8460 <args.2327>
    4280:	00004697          	auipc	a3,0x4
    4284:	2d868693          	addi	a3,a3,728 # 8558 <args.2327+0xf8>
      args[i] = big;
    4288:	e4840713          	addi	a4,s0,-440
    428c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    428e:	07a1                	addi	a5,a5,8
    4290:	fed79ee3          	bne	a5,a3,428c <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4294:	00004597          	auipc	a1,0x4
    4298:	1cc58593          	addi	a1,a1,460 # 8460 <args.2327>
    429c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42a0:	00001517          	auipc	a0,0x1
    42a4:	da850513          	addi	a0,a0,-600 # 5048 <malloc+0x13a>
    42a8:	7da000ef          	jal	ra,4a82 <exec>
    fd = open("bigarg-ok", O_CREATE);
    42ac:	20000593          	li	a1,512
    42b0:	00003517          	auipc	a0,0x3
    42b4:	b5850513          	addi	a0,a0,-1192 # 6e08 <malloc+0x1efa>
    42b8:	7d2000ef          	jal	ra,4a8a <open>
    close(fd);
    42bc:	7b6000ef          	jal	ra,4a72 <close>
    exit(0);
    42c0:	4501                	li	a0,0
    42c2:	788000ef          	jal	ra,4a4a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42c6:	85a6                	mv	a1,s1
    42c8:	00003517          	auipc	a0,0x3
    42cc:	b5050513          	addi	a0,a0,-1200 # 6e18 <malloc+0x1f0a>
    42d0:	385000ef          	jal	ra,4e54 <printf>
    exit(1);
    42d4:	4505                	li	a0,1
    42d6:	774000ef          	jal	ra,4a4a <exit>
    exit(xstatus);
    42da:	770000ef          	jal	ra,4a4a <exit>
    printf("%s: bigarg test failed!\n", s);
    42de:	85a6                	mv	a1,s1
    42e0:	00003517          	auipc	a0,0x3
    42e4:	b5850513          	addi	a0,a0,-1192 # 6e38 <malloc+0x1f2a>
    42e8:	36d000ef          	jal	ra,4e54 <printf>
    exit(1);
    42ec:	4505                	li	a0,1
    42ee:	75c000ef          	jal	ra,4a4a <exit>

00000000000042f2 <fsfull>:
{
    42f2:	7171                	addi	sp,sp,-176
    42f4:	f506                	sd	ra,168(sp)
    42f6:	f122                	sd	s0,160(sp)
    42f8:	ed26                	sd	s1,152(sp)
    42fa:	e94a                	sd	s2,144(sp)
    42fc:	e54e                	sd	s3,136(sp)
    42fe:	e152                	sd	s4,128(sp)
    4300:	fcd6                	sd	s5,120(sp)
    4302:	f8da                	sd	s6,112(sp)
    4304:	f4de                	sd	s7,104(sp)
    4306:	f0e2                	sd	s8,96(sp)
    4308:	ece6                	sd	s9,88(sp)
    430a:	e8ea                	sd	s10,80(sp)
    430c:	e4ee                	sd	s11,72(sp)
    430e:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4310:	00003517          	auipc	a0,0x3
    4314:	b4850513          	addi	a0,a0,-1208 # 6e58 <malloc+0x1f4a>
    4318:	33d000ef          	jal	ra,4e54 <printf>
  for(nfiles = 0; ; nfiles++){
    431c:	4481                	li	s1,0
    name[0] = 'f';
    431e:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4322:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4326:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    432a:	4b29                	li	s6,10
    printf("writing %s\n", name);
    432c:	00003c97          	auipc	s9,0x3
    4330:	b3cc8c93          	addi	s9,s9,-1220 # 6e68 <malloc+0x1f5a>
    int total = 0;
    4334:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4336:	00008a17          	auipc	s4,0x8
    433a:	942a0a13          	addi	s4,s4,-1726 # bc78 <buf>
    name[0] = 'f';
    433e:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4342:	0384c7bb          	divw	a5,s1,s8
    4346:	0307879b          	addiw	a5,a5,48
    434a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    434e:	0384e7bb          	remw	a5,s1,s8
    4352:	0377c7bb          	divw	a5,a5,s7
    4356:	0307879b          	addiw	a5,a5,48
    435a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    435e:	0374e7bb          	remw	a5,s1,s7
    4362:	0367c7bb          	divw	a5,a5,s6
    4366:	0307879b          	addiw	a5,a5,48
    436a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    436e:	0364e7bb          	remw	a5,s1,s6
    4372:	0307879b          	addiw	a5,a5,48
    4376:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    437a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    437e:	f5040593          	addi	a1,s0,-176
    4382:	8566                	mv	a0,s9
    4384:	2d1000ef          	jal	ra,4e54 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4388:	20200593          	li	a1,514
    438c:	f5040513          	addi	a0,s0,-176
    4390:	6fa000ef          	jal	ra,4a8a <open>
    4394:	892a                	mv	s2,a0
    if(fd < 0){
    4396:	0a055063          	bgez	a0,4436 <fsfull+0x144>
      printf("open %s failed\n", name);
    439a:	f5040593          	addi	a1,s0,-176
    439e:	00003517          	auipc	a0,0x3
    43a2:	ada50513          	addi	a0,a0,-1318 # 6e78 <malloc+0x1f6a>
    43a6:	2af000ef          	jal	ra,4e54 <printf>
  while(nfiles >= 0){
    43aa:	0604c163          	bltz	s1,440c <fsfull+0x11a>
    name[0] = 'f';
    43ae:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43b2:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43b6:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43ba:	4929                	li	s2,10
  while(nfiles >= 0){
    43bc:	5afd                	li	s5,-1
    name[0] = 'f';
    43be:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    43c2:	0344c7bb          	divw	a5,s1,s4
    43c6:	0307879b          	addiw	a5,a5,48
    43ca:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    43ce:	0344e7bb          	remw	a5,s1,s4
    43d2:	0337c7bb          	divw	a5,a5,s3
    43d6:	0307879b          	addiw	a5,a5,48
    43da:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    43de:	0334e7bb          	remw	a5,s1,s3
    43e2:	0327c7bb          	divw	a5,a5,s2
    43e6:	0307879b          	addiw	a5,a5,48
    43ea:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    43ee:	0324e7bb          	remw	a5,s1,s2
    43f2:	0307879b          	addiw	a5,a5,48
    43f6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    43fa:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    43fe:	f5040513          	addi	a0,s0,-176
    4402:	698000ef          	jal	ra,4a9a <unlink>
    nfiles--;
    4406:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4408:	fb549be3          	bne	s1,s5,43be <fsfull+0xcc>
  printf("fsfull test finished\n");
    440c:	00003517          	auipc	a0,0x3
    4410:	a8c50513          	addi	a0,a0,-1396 # 6e98 <malloc+0x1f8a>
    4414:	241000ef          	jal	ra,4e54 <printf>
}
    4418:	70aa                	ld	ra,168(sp)
    441a:	740a                	ld	s0,160(sp)
    441c:	64ea                	ld	s1,152(sp)
    441e:	694a                	ld	s2,144(sp)
    4420:	69aa                	ld	s3,136(sp)
    4422:	6a0a                	ld	s4,128(sp)
    4424:	7ae6                	ld	s5,120(sp)
    4426:	7b46                	ld	s6,112(sp)
    4428:	7ba6                	ld	s7,104(sp)
    442a:	7c06                	ld	s8,96(sp)
    442c:	6ce6                	ld	s9,88(sp)
    442e:	6d46                	ld	s10,80(sp)
    4430:	6da6                	ld	s11,72(sp)
    4432:	614d                	addi	sp,sp,176
    4434:	8082                	ret
    int total = 0;
    4436:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4438:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    443c:	40000613          	li	a2,1024
    4440:	85d2                	mv	a1,s4
    4442:	854a                	mv	a0,s2
    4444:	626000ef          	jal	ra,4a6a <write>
      if(cc < BSIZE)
    4448:	00aad563          	bge	s5,a0,4452 <fsfull+0x160>
      total += cc;
    444c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4450:	b7f5                	j	443c <fsfull+0x14a>
    printf("wrote %d bytes\n", total);
    4452:	85ce                	mv	a1,s3
    4454:	00003517          	auipc	a0,0x3
    4458:	a3450513          	addi	a0,a0,-1484 # 6e88 <malloc+0x1f7a>
    445c:	1f9000ef          	jal	ra,4e54 <printf>
    close(fd);
    4460:	854a                	mv	a0,s2
    4462:	610000ef          	jal	ra,4a72 <close>
    if(total == 0)
    4466:	f40982e3          	beqz	s3,43aa <fsfull+0xb8>
  for(nfiles = 0; ; nfiles++){
    446a:	2485                	addiw	s1,s1,1
    446c:	bdc9                	j	433e <fsfull+0x4c>

000000000000446e <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    446e:	7179                	addi	sp,sp,-48
    4470:	f406                	sd	ra,40(sp)
    4472:	f022                	sd	s0,32(sp)
    4474:	ec26                	sd	s1,24(sp)
    4476:	e84a                	sd	s2,16(sp)
    4478:	1800                	addi	s0,sp,48
    447a:	84aa                	mv	s1,a0
    447c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    447e:	00003517          	auipc	a0,0x3
    4482:	a3250513          	addi	a0,a0,-1486 # 6eb0 <malloc+0x1fa2>
    4486:	1cf000ef          	jal	ra,4e54 <printf>
  if((pid = fork()) < 0) {
    448a:	5b8000ef          	jal	ra,4a42 <fork>
    448e:	02054a63          	bltz	a0,44c2 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4492:	c129                	beqz	a0,44d4 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4494:	fdc40513          	addi	a0,s0,-36
    4498:	5ba000ef          	jal	ra,4a52 <wait>
    if(xstatus != 0) 
    449c:	fdc42783          	lw	a5,-36(s0)
    44a0:	cf9d                	beqz	a5,44de <run+0x70>
      printf("FAILED\n");
    44a2:	00003517          	auipc	a0,0x3
    44a6:	a3650513          	addi	a0,a0,-1482 # 6ed8 <malloc+0x1fca>
    44aa:	1ab000ef          	jal	ra,4e54 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44ae:	fdc42503          	lw	a0,-36(s0)
  }
}
    44b2:	00153513          	seqz	a0,a0
    44b6:	70a2                	ld	ra,40(sp)
    44b8:	7402                	ld	s0,32(sp)
    44ba:	64e2                	ld	s1,24(sp)
    44bc:	6942                	ld	s2,16(sp)
    44be:	6145                	addi	sp,sp,48
    44c0:	8082                	ret
    printf("runtest: fork error\n");
    44c2:	00003517          	auipc	a0,0x3
    44c6:	9fe50513          	addi	a0,a0,-1538 # 6ec0 <malloc+0x1fb2>
    44ca:	18b000ef          	jal	ra,4e54 <printf>
    exit(1);
    44ce:	4505                	li	a0,1
    44d0:	57a000ef          	jal	ra,4a4a <exit>
    f(s);
    44d4:	854a                	mv	a0,s2
    44d6:	9482                	jalr	s1
    exit(0);
    44d8:	4501                	li	a0,0
    44da:	570000ef          	jal	ra,4a4a <exit>
      printf("OK\n");
    44de:	00003517          	auipc	a0,0x3
    44e2:	a0250513          	addi	a0,a0,-1534 # 6ee0 <malloc+0x1fd2>
    44e6:	16f000ef          	jal	ra,4e54 <printf>
    44ea:	b7d1                	j	44ae <run+0x40>

00000000000044ec <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    44ec:	7139                	addi	sp,sp,-64
    44ee:	fc06                	sd	ra,56(sp)
    44f0:	f822                	sd	s0,48(sp)
    44f2:	f426                	sd	s1,40(sp)
    44f4:	f04a                	sd	s2,32(sp)
    44f6:	ec4e                	sd	s3,24(sp)
    44f8:	e852                	sd	s4,16(sp)
    44fa:	e456                	sd	s5,8(sp)
    44fc:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    44fe:	00853903          	ld	s2,8(a0)
    4502:	04090c63          	beqz	s2,455a <runtests+0x6e>
    4506:	84aa                	mv	s1,a0
    4508:	89ae                	mv	s3,a1
    450a:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    450c:	4a89                	li	s5,2
    450e:	a031                	j	451a <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4510:	04c1                	addi	s1,s1,16
    4512:	0084b903          	ld	s2,8(s1)
    4516:	02090863          	beqz	s2,4546 <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    451a:	00098763          	beqz	s3,4528 <runtests+0x3c>
    451e:	85ce                	mv	a1,s3
    4520:	854a                	mv	a0,s2
    4522:	2e2000ef          	jal	ra,4804 <strcmp>
    4526:	f56d                	bnez	a0,4510 <runtests+0x24>
      if(!run(t->f, t->s)){
    4528:	85ca                	mv	a1,s2
    452a:	6088                	ld	a0,0(s1)
    452c:	f43ff0ef          	jal	ra,446e <run>
    4530:	f165                	bnez	a0,4510 <runtests+0x24>
        if(continuous != 2){
    4532:	fd5a0fe3          	beq	s4,s5,4510 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    4536:	00003517          	auipc	a0,0x3
    453a:	9b250513          	addi	a0,a0,-1614 # 6ee8 <malloc+0x1fda>
    453e:	117000ef          	jal	ra,4e54 <printf>
          return 1;
    4542:	4505                	li	a0,1
    4544:	a011                	j	4548 <runtests+0x5c>
        }
      }
    }
  }
  return 0;
    4546:	4501                	li	a0,0
}
    4548:	70e2                	ld	ra,56(sp)
    454a:	7442                	ld	s0,48(sp)
    454c:	74a2                	ld	s1,40(sp)
    454e:	7902                	ld	s2,32(sp)
    4550:	69e2                	ld	s3,24(sp)
    4552:	6a42                	ld	s4,16(sp)
    4554:	6aa2                	ld	s5,8(sp)
    4556:	6121                	addi	sp,sp,64
    4558:	8082                	ret
  return 0;
    455a:	4501                	li	a0,0
    455c:	b7f5                	j	4548 <runtests+0x5c>

000000000000455e <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    455e:	7139                	addi	sp,sp,-64
    4560:	fc06                	sd	ra,56(sp)
    4562:	f822                	sd	s0,48(sp)
    4564:	f426                	sd	s1,40(sp)
    4566:	f04a                	sd	s2,32(sp)
    4568:	ec4e                	sd	s3,24(sp)
    456a:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    456c:	fc840513          	addi	a0,s0,-56
    4570:	4ea000ef          	jal	ra,4a5a <pipe>
    4574:	04054c63          	bltz	a0,45cc <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4578:	4ca000ef          	jal	ra,4a42 <fork>

  if(pid < 0){
    457c:	06054163          	bltz	a0,45de <countfree+0x80>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4580:	e93d                	bnez	a0,45f6 <countfree+0x98>
    close(fds[0]);
    4582:	fc842503          	lw	a0,-56(s0)
    4586:	4ec000ef          	jal	ra,4a72 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    458a:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    458c:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    458e:	00001917          	auipc	s2,0x1
    4592:	b2a90913          	addi	s2,s2,-1238 # 50b8 <malloc+0x1aa>
      uint64 a = (uint64) sbrk(4096);
    4596:	6505                	lui	a0,0x1
    4598:	53a000ef          	jal	ra,4ad2 <sbrk>
      if(a == 0xffffffffffffffff){
    459c:	04950a63          	beq	a0,s1,45f0 <countfree+0x92>
      *(char *)(a + 4096 - 1) = 1;
    45a0:	6785                	lui	a5,0x1
    45a2:	953e                	add	a0,a0,a5
    45a4:	ff350fa3          	sb	s3,-1(a0) # fff <pgbug+0x21>
      if(write(fds[1], "x", 1) != 1){
    45a8:	4605                	li	a2,1
    45aa:	85ca                	mv	a1,s2
    45ac:	fcc42503          	lw	a0,-52(s0)
    45b0:	4ba000ef          	jal	ra,4a6a <write>
    45b4:	4785                	li	a5,1
    45b6:	fef500e3          	beq	a0,a5,4596 <countfree+0x38>
        printf("write() failed in countfree()\n");
    45ba:	00003517          	auipc	a0,0x3
    45be:	98650513          	addi	a0,a0,-1658 # 6f40 <malloc+0x2032>
    45c2:	093000ef          	jal	ra,4e54 <printf>
        exit(1);
    45c6:	4505                	li	a0,1
    45c8:	482000ef          	jal	ra,4a4a <exit>
    printf("pipe() failed in countfree()\n");
    45cc:	00003517          	auipc	a0,0x3
    45d0:	93450513          	addi	a0,a0,-1740 # 6f00 <malloc+0x1ff2>
    45d4:	081000ef          	jal	ra,4e54 <printf>
    exit(1);
    45d8:	4505                	li	a0,1
    45da:	470000ef          	jal	ra,4a4a <exit>
    printf("fork failed in countfree()\n");
    45de:	00003517          	auipc	a0,0x3
    45e2:	94250513          	addi	a0,a0,-1726 # 6f20 <malloc+0x2012>
    45e6:	06f000ef          	jal	ra,4e54 <printf>
    exit(1);
    45ea:	4505                	li	a0,1
    45ec:	45e000ef          	jal	ra,4a4a <exit>
      }
    }

    exit(0);
    45f0:	4501                	li	a0,0
    45f2:	458000ef          	jal	ra,4a4a <exit>
  }

  close(fds[1]);
    45f6:	fcc42503          	lw	a0,-52(s0)
    45fa:	478000ef          	jal	ra,4a72 <close>

  int n = 0;
    45fe:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4600:	4605                	li	a2,1
    4602:	fc740593          	addi	a1,s0,-57
    4606:	fc842503          	lw	a0,-56(s0)
    460a:	458000ef          	jal	ra,4a62 <read>
    if(cc < 0){
    460e:	00054563          	bltz	a0,4618 <countfree+0xba>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4612:	cd01                	beqz	a0,462a <countfree+0xcc>
      break;
    n += 1;
    4614:	2485                	addiw	s1,s1,1
  while(1){
    4616:	b7ed                	j	4600 <countfree+0xa2>
      printf("read() failed in countfree()\n");
    4618:	00003517          	auipc	a0,0x3
    461c:	94850513          	addi	a0,a0,-1720 # 6f60 <malloc+0x2052>
    4620:	035000ef          	jal	ra,4e54 <printf>
      exit(1);
    4624:	4505                	li	a0,1
    4626:	424000ef          	jal	ra,4a4a <exit>
  }

  close(fds[0]);
    462a:	fc842503          	lw	a0,-56(s0)
    462e:	444000ef          	jal	ra,4a72 <close>
  wait((int*)0);
    4632:	4501                	li	a0,0
    4634:	41e000ef          	jal	ra,4a52 <wait>
  
  return n;
}
    4638:	8526                	mv	a0,s1
    463a:	70e2                	ld	ra,56(sp)
    463c:	7442                	ld	s0,48(sp)
    463e:	74a2                	ld	s1,40(sp)
    4640:	7902                	ld	s2,32(sp)
    4642:	69e2                	ld	s3,24(sp)
    4644:	6121                	addi	sp,sp,64
    4646:	8082                	ret

0000000000004648 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4648:	711d                	addi	sp,sp,-96
    464a:	ec86                	sd	ra,88(sp)
    464c:	e8a2                	sd	s0,80(sp)
    464e:	e4a6                	sd	s1,72(sp)
    4650:	e0ca                	sd	s2,64(sp)
    4652:	fc4e                	sd	s3,56(sp)
    4654:	f852                	sd	s4,48(sp)
    4656:	f456                	sd	s5,40(sp)
    4658:	f05a                	sd	s6,32(sp)
    465a:	ec5e                	sd	s7,24(sp)
    465c:	e862                	sd	s8,16(sp)
    465e:	e466                	sd	s9,8(sp)
    4660:	e06a                	sd	s10,0(sp)
    4662:	1080                	addi	s0,sp,96
    4664:	8a2a                	mv	s4,a0
    4666:	892e                	mv	s2,a1
    4668:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    466a:	00003b97          	auipc	s7,0x3
    466e:	916b8b93          	addi	s7,s7,-1770 # 6f80 <malloc+0x2072>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4672:	00004b17          	auipc	s6,0x4
    4676:	99eb0b13          	addi	s6,s6,-1634 # 8010 <quicktests>
      if(continuous != 2) {
    467a:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    467c:	00003c97          	auipc	s9,0x3
    4680:	93cc8c93          	addi	s9,s9,-1732 # 6fb8 <malloc+0x20aa>
      if (runtests(slowtests, justone, continuous)) {
    4684:	00004c17          	auipc	s8,0x4
    4688:	d5cc0c13          	addi	s8,s8,-676 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    468c:	00003d17          	auipc	s10,0x3
    4690:	90cd0d13          	addi	s10,s10,-1780 # 6f98 <malloc+0x208a>
    4694:	a819                	j	46aa <drivetests+0x62>
    4696:	856a                	mv	a0,s10
    4698:	7bc000ef          	jal	ra,4e54 <printf>
    469c:	a80d                	j	46ce <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    469e:	ec1ff0ef          	jal	ra,455e <countfree>
    46a2:	04954863          	blt	a0,s1,46f2 <drivetests+0xaa>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    46a6:	06090363          	beqz	s2,470c <drivetests+0xc4>
    printf("usertests starting\n");
    46aa:	855e                	mv	a0,s7
    46ac:	7a8000ef          	jal	ra,4e54 <printf>
    int free0 = countfree();
    46b0:	eafff0ef          	jal	ra,455e <countfree>
    46b4:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    46b6:	864a                	mv	a2,s2
    46b8:	85ce                	mv	a1,s3
    46ba:	855a                	mv	a0,s6
    46bc:	e31ff0ef          	jal	ra,44ec <runtests>
    46c0:	c119                	beqz	a0,46c6 <drivetests+0x7e>
      if(continuous != 2) {
    46c2:	05591163          	bne	s2,s5,4704 <drivetests+0xbc>
    if(!quick) {
    46c6:	fc0a1ce3          	bnez	s4,469e <drivetests+0x56>
      if (justone == 0)
    46ca:	fc0986e3          	beqz	s3,4696 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    46ce:	864a                	mv	a2,s2
    46d0:	85ce                	mv	a1,s3
    46d2:	8562                	mv	a0,s8
    46d4:	e19ff0ef          	jal	ra,44ec <runtests>
    46d8:	d179                	beqz	a0,469e <drivetests+0x56>
        if(continuous != 2) {
    46da:	03591763          	bne	s2,s5,4708 <drivetests+0xc0>
    if((free1 = countfree()) < free0) {
    46de:	e81ff0ef          	jal	ra,455e <countfree>
    46e2:	fc9552e3          	bge	a0,s1,46a6 <drivetests+0x5e>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e6:	8626                	mv	a2,s1
    46e8:	85aa                	mv	a1,a0
    46ea:	8566                	mv	a0,s9
    46ec:	768000ef          	jal	ra,4e54 <printf>
      if(continuous != 2) {
    46f0:	bf6d                	j	46aa <drivetests+0x62>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46f2:	8626                	mv	a2,s1
    46f4:	85aa                	mv	a1,a0
    46f6:	8566                	mv	a0,s9
    46f8:	75c000ef          	jal	ra,4e54 <printf>
      if(continuous != 2) {
    46fc:	fb5907e3          	beq	s2,s5,46aa <drivetests+0x62>
        return 1;
    4700:	4505                	li	a0,1
    4702:	a031                	j	470e <drivetests+0xc6>
        return 1;
    4704:	4505                	li	a0,1
    4706:	a021                	j	470e <drivetests+0xc6>
          return 1;
    4708:	4505                	li	a0,1
    470a:	a011                	j	470e <drivetests+0xc6>
  return 0;
    470c:	854a                	mv	a0,s2
}
    470e:	60e6                	ld	ra,88(sp)
    4710:	6446                	ld	s0,80(sp)
    4712:	64a6                	ld	s1,72(sp)
    4714:	6906                	ld	s2,64(sp)
    4716:	79e2                	ld	s3,56(sp)
    4718:	7a42                	ld	s4,48(sp)
    471a:	7aa2                	ld	s5,40(sp)
    471c:	7b02                	ld	s6,32(sp)
    471e:	6be2                	ld	s7,24(sp)
    4720:	6c42                	ld	s8,16(sp)
    4722:	6ca2                	ld	s9,8(sp)
    4724:	6d02                	ld	s10,0(sp)
    4726:	6125                	addi	sp,sp,96
    4728:	8082                	ret

000000000000472a <main>:

int
main(int argc, char *argv[])
{
    472a:	1101                	addi	sp,sp,-32
    472c:	ec06                	sd	ra,24(sp)
    472e:	e822                	sd	s0,16(sp)
    4730:	e426                	sd	s1,8(sp)
    4732:	e04a                	sd	s2,0(sp)
    4734:	1000                	addi	s0,sp,32
    4736:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4738:	4789                	li	a5,2
    473a:	02f50063          	beq	a0,a5,475a <main+0x30>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    473e:	4785                	li	a5,1
    4740:	06a7c063          	blt	a5,a0,47a0 <main+0x76>
  char *justone = 0;
    4744:	4901                	li	s2,0
  int quick = 0;
    4746:	4501                	li	a0,0
  int continuous = 0;
    4748:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    474a:	864a                	mv	a2,s2
    474c:	85a6                	mv	a1,s1
    474e:	efbff0ef          	jal	ra,4648 <drivetests>
    4752:	c92d                	beqz	a0,47c4 <main+0x9a>
    exit(1);
    4754:	4505                	li	a0,1
    4756:	2f4000ef          	jal	ra,4a4a <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    475a:	0085b903          	ld	s2,8(a1)
    475e:	00003597          	auipc	a1,0x3
    4762:	88a58593          	addi	a1,a1,-1910 # 6fe8 <malloc+0x20da>
    4766:	854a                	mv	a0,s2
    4768:	09c000ef          	jal	ra,4804 <strcmp>
    476c:	c139                	beqz	a0,47b2 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    476e:	00003597          	auipc	a1,0x3
    4772:	88258593          	addi	a1,a1,-1918 # 6ff0 <malloc+0x20e2>
    4776:	854a                	mv	a0,s2
    4778:	08c000ef          	jal	ra,4804 <strcmp>
    477c:	cd1d                	beqz	a0,47ba <main+0x90>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    477e:	00003597          	auipc	a1,0x3
    4782:	87a58593          	addi	a1,a1,-1926 # 6ff8 <malloc+0x20ea>
    4786:	854a                	mv	a0,s2
    4788:	07c000ef          	jal	ra,4804 <strcmp>
    478c:	c915                	beqz	a0,47c0 <main+0x96>
  } else if(argc == 2 && argv[1][0] != '-'){
    478e:	00094703          	lbu	a4,0(s2)
    4792:	02d00793          	li	a5,45
    4796:	00f70563          	beq	a4,a5,47a0 <main+0x76>
  int quick = 0;
    479a:	4501                	li	a0,0
  int continuous = 0;
    479c:	4481                	li	s1,0
    479e:	b775                	j	474a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    47a0:	00003517          	auipc	a0,0x3
    47a4:	86050513          	addi	a0,a0,-1952 # 7000 <malloc+0x20f2>
    47a8:	6ac000ef          	jal	ra,4e54 <printf>
    exit(1);
    47ac:	4505                	li	a0,1
    47ae:	29c000ef          	jal	ra,4a4a <exit>
  int continuous = 0;
    47b2:	84aa                	mv	s1,a0
  char *justone = 0;
    47b4:	4901                	li	s2,0
    quick = 1;
    47b6:	4505                	li	a0,1
    47b8:	bf49                	j	474a <main+0x20>
  char *justone = 0;
    47ba:	4901                	li	s2,0
    continuous = 1;
    47bc:	4485                	li	s1,1
    47be:	b771                	j	474a <main+0x20>
  char *justone = 0;
    47c0:	4901                	li	s2,0
    47c2:	b761                	j	474a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    47c4:	00003517          	auipc	a0,0x3
    47c8:	86c50513          	addi	a0,a0,-1940 # 7030 <malloc+0x2122>
    47cc:	688000ef          	jal	ra,4e54 <printf>
  exit(0);
    47d0:	4501                	li	a0,0
    47d2:	278000ef          	jal	ra,4a4a <exit>

00000000000047d6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    47d6:	1141                	addi	sp,sp,-16
    47d8:	e406                	sd	ra,8(sp)
    47da:	e022                	sd	s0,0(sp)
    47dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
    47de:	f4dff0ef          	jal	ra,472a <main>
  exit(0);
    47e2:	4501                	li	a0,0
    47e4:	266000ef          	jal	ra,4a4a <exit>

00000000000047e8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    47e8:	1141                	addi	sp,sp,-16
    47ea:	e422                	sd	s0,8(sp)
    47ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    47ee:	87aa                	mv	a5,a0
    47f0:	0585                	addi	a1,a1,1
    47f2:	0785                	addi	a5,a5,1
    47f4:	fff5c703          	lbu	a4,-1(a1)
    47f8:	fee78fa3          	sb	a4,-1(a5) # fff <pgbug+0x21>
    47fc:	fb75                	bnez	a4,47f0 <strcpy+0x8>
    ;
  return os;
}
    47fe:	6422                	ld	s0,8(sp)
    4800:	0141                	addi	sp,sp,16
    4802:	8082                	ret

0000000000004804 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4804:	1141                	addi	sp,sp,-16
    4806:	e422                	sd	s0,8(sp)
    4808:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    480a:	00054783          	lbu	a5,0(a0)
    480e:	cb91                	beqz	a5,4822 <strcmp+0x1e>
    4810:	0005c703          	lbu	a4,0(a1)
    4814:	00f71763          	bne	a4,a5,4822 <strcmp+0x1e>
    p++, q++;
    4818:	0505                	addi	a0,a0,1
    481a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    481c:	00054783          	lbu	a5,0(a0)
    4820:	fbe5                	bnez	a5,4810 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4822:	0005c503          	lbu	a0,0(a1)
}
    4826:	40a7853b          	subw	a0,a5,a0
    482a:	6422                	ld	s0,8(sp)
    482c:	0141                	addi	sp,sp,16
    482e:	8082                	ret

0000000000004830 <strlen>:

uint
strlen(const char *s)
{
    4830:	1141                	addi	sp,sp,-16
    4832:	e422                	sd	s0,8(sp)
    4834:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4836:	00054783          	lbu	a5,0(a0)
    483a:	cf91                	beqz	a5,4856 <strlen+0x26>
    483c:	0505                	addi	a0,a0,1
    483e:	87aa                	mv	a5,a0
    4840:	4685                	li	a3,1
    4842:	9e89                	subw	a3,a3,a0
    4844:	00f6853b          	addw	a0,a3,a5
    4848:	0785                	addi	a5,a5,1
    484a:	fff7c703          	lbu	a4,-1(a5)
    484e:	fb7d                	bnez	a4,4844 <strlen+0x14>
    ;
  return n;
}
    4850:	6422                	ld	s0,8(sp)
    4852:	0141                	addi	sp,sp,16
    4854:	8082                	ret
  for(n = 0; s[n]; n++)
    4856:	4501                	li	a0,0
    4858:	bfe5                	j	4850 <strlen+0x20>

000000000000485a <memset>:

void*
memset(void *dst, int c, uint n)
{
    485a:	1141                	addi	sp,sp,-16
    485c:	e422                	sd	s0,8(sp)
    485e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4860:	ce09                	beqz	a2,487a <memset+0x20>
    4862:	87aa                	mv	a5,a0
    4864:	fff6071b          	addiw	a4,a2,-1
    4868:	1702                	slli	a4,a4,0x20
    486a:	9301                	srli	a4,a4,0x20
    486c:	0705                	addi	a4,a4,1
    486e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    4870:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4874:	0785                	addi	a5,a5,1
    4876:	fee79de3          	bne	a5,a4,4870 <memset+0x16>
  }
  return dst;
}
    487a:	6422                	ld	s0,8(sp)
    487c:	0141                	addi	sp,sp,16
    487e:	8082                	ret

0000000000004880 <strchr>:

char*
strchr(const char *s, char c)
{
    4880:	1141                	addi	sp,sp,-16
    4882:	e422                	sd	s0,8(sp)
    4884:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4886:	00054783          	lbu	a5,0(a0)
    488a:	cb99                	beqz	a5,48a0 <strchr+0x20>
    if(*s == c)
    488c:	00f58763          	beq	a1,a5,489a <strchr+0x1a>
  for(; *s; s++)
    4890:	0505                	addi	a0,a0,1
    4892:	00054783          	lbu	a5,0(a0)
    4896:	fbfd                	bnez	a5,488c <strchr+0xc>
      return (char*)s;
  return 0;
    4898:	4501                	li	a0,0
}
    489a:	6422                	ld	s0,8(sp)
    489c:	0141                	addi	sp,sp,16
    489e:	8082                	ret
  return 0;
    48a0:	4501                	li	a0,0
    48a2:	bfe5                	j	489a <strchr+0x1a>

00000000000048a4 <gets>:

char*
gets(char *buf, int max)
{
    48a4:	711d                	addi	sp,sp,-96
    48a6:	ec86                	sd	ra,88(sp)
    48a8:	e8a2                	sd	s0,80(sp)
    48aa:	e4a6                	sd	s1,72(sp)
    48ac:	e0ca                	sd	s2,64(sp)
    48ae:	fc4e                	sd	s3,56(sp)
    48b0:	f852                	sd	s4,48(sp)
    48b2:	f456                	sd	s5,40(sp)
    48b4:	f05a                	sd	s6,32(sp)
    48b6:	ec5e                	sd	s7,24(sp)
    48b8:	1080                	addi	s0,sp,96
    48ba:	8baa                	mv	s7,a0
    48bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    48be:	892a                	mv	s2,a0
    48c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    48c2:	4aa9                	li	s5,10
    48c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    48c6:	89a6                	mv	s3,s1
    48c8:	2485                	addiw	s1,s1,1
    48ca:	0344d663          	bge	s1,s4,48f6 <gets+0x52>
    cc = read(0, &c, 1);
    48ce:	4605                	li	a2,1
    48d0:	faf40593          	addi	a1,s0,-81
    48d4:	4501                	li	a0,0
    48d6:	18c000ef          	jal	ra,4a62 <read>
    if(cc < 1)
    48da:	00a05e63          	blez	a0,48f6 <gets+0x52>
    buf[i++] = c;
    48de:	faf44783          	lbu	a5,-81(s0)
    48e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    48e6:	01578763          	beq	a5,s5,48f4 <gets+0x50>
    48ea:	0905                	addi	s2,s2,1
    48ec:	fd679de3          	bne	a5,s6,48c6 <gets+0x22>
  for(i=0; i+1 < max; ){
    48f0:	89a6                	mv	s3,s1
    48f2:	a011                	j	48f6 <gets+0x52>
    48f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    48f6:	99de                	add	s3,s3,s7
    48f8:	00098023          	sb	zero,0(s3)
  return buf;
}
    48fc:	855e                	mv	a0,s7
    48fe:	60e6                	ld	ra,88(sp)
    4900:	6446                	ld	s0,80(sp)
    4902:	64a6                	ld	s1,72(sp)
    4904:	6906                	ld	s2,64(sp)
    4906:	79e2                	ld	s3,56(sp)
    4908:	7a42                	ld	s4,48(sp)
    490a:	7aa2                	ld	s5,40(sp)
    490c:	7b02                	ld	s6,32(sp)
    490e:	6be2                	ld	s7,24(sp)
    4910:	6125                	addi	sp,sp,96
    4912:	8082                	ret

0000000000004914 <stat>:

int
stat(const char *n, struct stat *st)
{
    4914:	1101                	addi	sp,sp,-32
    4916:	ec06                	sd	ra,24(sp)
    4918:	e822                	sd	s0,16(sp)
    491a:	e426                	sd	s1,8(sp)
    491c:	e04a                	sd	s2,0(sp)
    491e:	1000                	addi	s0,sp,32
    4920:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4922:	4581                	li	a1,0
    4924:	166000ef          	jal	ra,4a8a <open>
  if(fd < 0)
    4928:	02054163          	bltz	a0,494a <stat+0x36>
    492c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    492e:	85ca                	mv	a1,s2
    4930:	172000ef          	jal	ra,4aa2 <fstat>
    4934:	892a                	mv	s2,a0
  close(fd);
    4936:	8526                	mv	a0,s1
    4938:	13a000ef          	jal	ra,4a72 <close>
  return r;
}
    493c:	854a                	mv	a0,s2
    493e:	60e2                	ld	ra,24(sp)
    4940:	6442                	ld	s0,16(sp)
    4942:	64a2                	ld	s1,8(sp)
    4944:	6902                	ld	s2,0(sp)
    4946:	6105                	addi	sp,sp,32
    4948:	8082                	ret
    return -1;
    494a:	597d                	li	s2,-1
    494c:	bfc5                	j	493c <stat+0x28>

000000000000494e <atoi>:

int
atoi(const char *s)
{
    494e:	1141                	addi	sp,sp,-16
    4950:	e422                	sd	s0,8(sp)
    4952:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4954:	00054603          	lbu	a2,0(a0)
    4958:	fd06079b          	addiw	a5,a2,-48
    495c:	0ff7f793          	andi	a5,a5,255
    4960:	4725                	li	a4,9
    4962:	02f76963          	bltu	a4,a5,4994 <atoi+0x46>
    4966:	86aa                	mv	a3,a0
  n = 0;
    4968:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    496a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    496c:	0685                	addi	a3,a3,1
    496e:	0025179b          	slliw	a5,a0,0x2
    4972:	9fa9                	addw	a5,a5,a0
    4974:	0017979b          	slliw	a5,a5,0x1
    4978:	9fb1                	addw	a5,a5,a2
    497a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    497e:	0006c603          	lbu	a2,0(a3)
    4982:	fd06071b          	addiw	a4,a2,-48
    4986:	0ff77713          	andi	a4,a4,255
    498a:	fee5f1e3          	bgeu	a1,a4,496c <atoi+0x1e>
  return n;
}
    498e:	6422                	ld	s0,8(sp)
    4990:	0141                	addi	sp,sp,16
    4992:	8082                	ret
  n = 0;
    4994:	4501                	li	a0,0
    4996:	bfe5                	j	498e <atoi+0x40>

0000000000004998 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4998:	1141                	addi	sp,sp,-16
    499a:	e422                	sd	s0,8(sp)
    499c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    499e:	02b57663          	bgeu	a0,a1,49ca <memmove+0x32>
    while(n-- > 0)
    49a2:	02c05163          	blez	a2,49c4 <memmove+0x2c>
    49a6:	fff6079b          	addiw	a5,a2,-1
    49aa:	1782                	slli	a5,a5,0x20
    49ac:	9381                	srli	a5,a5,0x20
    49ae:	0785                	addi	a5,a5,1
    49b0:	97aa                	add	a5,a5,a0
  dst = vdst;
    49b2:	872a                	mv	a4,a0
      *dst++ = *src++;
    49b4:	0585                	addi	a1,a1,1
    49b6:	0705                	addi	a4,a4,1
    49b8:	fff5c683          	lbu	a3,-1(a1)
    49bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49c0:	fee79ae3          	bne	a5,a4,49b4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    49c4:	6422                	ld	s0,8(sp)
    49c6:	0141                	addi	sp,sp,16
    49c8:	8082                	ret
    dst += n;
    49ca:	00c50733          	add	a4,a0,a2
    src += n;
    49ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    49d0:	fec05ae3          	blez	a2,49c4 <memmove+0x2c>
    49d4:	fff6079b          	addiw	a5,a2,-1
    49d8:	1782                	slli	a5,a5,0x20
    49da:	9381                	srli	a5,a5,0x20
    49dc:	fff7c793          	not	a5,a5
    49e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    49e2:	15fd                	addi	a1,a1,-1
    49e4:	177d                	addi	a4,a4,-1
    49e6:	0005c683          	lbu	a3,0(a1)
    49ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    49ee:	fee79ae3          	bne	a5,a4,49e2 <memmove+0x4a>
    49f2:	bfc9                	j	49c4 <memmove+0x2c>

00000000000049f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    49f4:	1141                	addi	sp,sp,-16
    49f6:	e422                	sd	s0,8(sp)
    49f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    49fa:	ca05                	beqz	a2,4a2a <memcmp+0x36>
    49fc:	fff6069b          	addiw	a3,a2,-1
    4a00:	1682                	slli	a3,a3,0x20
    4a02:	9281                	srli	a3,a3,0x20
    4a04:	0685                	addi	a3,a3,1
    4a06:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4a08:	00054783          	lbu	a5,0(a0)
    4a0c:	0005c703          	lbu	a4,0(a1)
    4a10:	00e79863          	bne	a5,a4,4a20 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4a14:	0505                	addi	a0,a0,1
    p2++;
    4a16:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a18:	fed518e3          	bne	a0,a3,4a08 <memcmp+0x14>
  }
  return 0;
    4a1c:	4501                	li	a0,0
    4a1e:	a019                	j	4a24 <memcmp+0x30>
      return *p1 - *p2;
    4a20:	40e7853b          	subw	a0,a5,a4
}
    4a24:	6422                	ld	s0,8(sp)
    4a26:	0141                	addi	sp,sp,16
    4a28:	8082                	ret
  return 0;
    4a2a:	4501                	li	a0,0
    4a2c:	bfe5                	j	4a24 <memcmp+0x30>

0000000000004a2e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a2e:	1141                	addi	sp,sp,-16
    4a30:	e406                	sd	ra,8(sp)
    4a32:	e022                	sd	s0,0(sp)
    4a34:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a36:	f63ff0ef          	jal	ra,4998 <memmove>
}
    4a3a:	60a2                	ld	ra,8(sp)
    4a3c:	6402                	ld	s0,0(sp)
    4a3e:	0141                	addi	sp,sp,16
    4a40:	8082                	ret

0000000000004a42 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a42:	4885                	li	a7,1
 ecall
    4a44:	00000073          	ecall
 ret
    4a48:	8082                	ret

0000000000004a4a <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a4a:	4889                	li	a7,2
 ecall
    4a4c:	00000073          	ecall
 ret
    4a50:	8082                	ret

0000000000004a52 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a52:	488d                	li	a7,3
 ecall
    4a54:	00000073          	ecall
 ret
    4a58:	8082                	ret

0000000000004a5a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a5a:	4891                	li	a7,4
 ecall
    4a5c:	00000073          	ecall
 ret
    4a60:	8082                	ret

0000000000004a62 <read>:
.global read
read:
 li a7, SYS_read
    4a62:	4895                	li	a7,5
 ecall
    4a64:	00000073          	ecall
 ret
    4a68:	8082                	ret

0000000000004a6a <write>:
.global write
write:
 li a7, SYS_write
    4a6a:	48c1                	li	a7,16
 ecall
    4a6c:	00000073          	ecall
 ret
    4a70:	8082                	ret

0000000000004a72 <close>:
.global close
close:
 li a7, SYS_close
    4a72:	48d5                	li	a7,21
 ecall
    4a74:	00000073          	ecall
 ret
    4a78:	8082                	ret

0000000000004a7a <kill>:
.global kill
kill:
 li a7, SYS_kill
    4a7a:	4899                	li	a7,6
 ecall
    4a7c:	00000073          	ecall
 ret
    4a80:	8082                	ret

0000000000004a82 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4a82:	489d                	li	a7,7
 ecall
    4a84:	00000073          	ecall
 ret
    4a88:	8082                	ret

0000000000004a8a <open>:
.global open
open:
 li a7, SYS_open
    4a8a:	48bd                	li	a7,15
 ecall
    4a8c:	00000073          	ecall
 ret
    4a90:	8082                	ret

0000000000004a92 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4a92:	48c5                	li	a7,17
 ecall
    4a94:	00000073          	ecall
 ret
    4a98:	8082                	ret

0000000000004a9a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4a9a:	48c9                	li	a7,18
 ecall
    4a9c:	00000073          	ecall
 ret
    4aa0:	8082                	ret

0000000000004aa2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4aa2:	48a1                	li	a7,8
 ecall
    4aa4:	00000073          	ecall
 ret
    4aa8:	8082                	ret

0000000000004aaa <link>:
.global link
link:
 li a7, SYS_link
    4aaa:	48cd                	li	a7,19
 ecall
    4aac:	00000073          	ecall
 ret
    4ab0:	8082                	ret

0000000000004ab2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4ab2:	48d1                	li	a7,20
 ecall
    4ab4:	00000073          	ecall
 ret
    4ab8:	8082                	ret

0000000000004aba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4aba:	48a5                	li	a7,9
 ecall
    4abc:	00000073          	ecall
 ret
    4ac0:	8082                	ret

0000000000004ac2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4ac2:	48a9                	li	a7,10
 ecall
    4ac4:	00000073          	ecall
 ret
    4ac8:	8082                	ret

0000000000004aca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4aca:	48ad                	li	a7,11
 ecall
    4acc:	00000073          	ecall
 ret
    4ad0:	8082                	ret

0000000000004ad2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4ad2:	48b1                	li	a7,12
 ecall
    4ad4:	00000073          	ecall
 ret
    4ad8:	8082                	ret

0000000000004ada <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4ada:	48b5                	li	a7,13
 ecall
    4adc:	00000073          	ecall
 ret
    4ae0:	8082                	ret

0000000000004ae2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4ae2:	48b9                	li	a7,14
 ecall
    4ae4:	00000073          	ecall
 ret
    4ae8:	8082                	ret

0000000000004aea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4aea:	1101                	addi	sp,sp,-32
    4aec:	ec06                	sd	ra,24(sp)
    4aee:	e822                	sd	s0,16(sp)
    4af0:	1000                	addi	s0,sp,32
    4af2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4af6:	4605                	li	a2,1
    4af8:	fef40593          	addi	a1,s0,-17
    4afc:	f6fff0ef          	jal	ra,4a6a <write>
}
    4b00:	60e2                	ld	ra,24(sp)
    4b02:	6442                	ld	s0,16(sp)
    4b04:	6105                	addi	sp,sp,32
    4b06:	8082                	ret

0000000000004b08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4b08:	7139                	addi	sp,sp,-64
    4b0a:	fc06                	sd	ra,56(sp)
    4b0c:	f822                	sd	s0,48(sp)
    4b0e:	f426                	sd	s1,40(sp)
    4b10:	f04a                	sd	s2,32(sp)
    4b12:	ec4e                	sd	s3,24(sp)
    4b14:	0080                	addi	s0,sp,64
    4b16:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4b18:	c299                	beqz	a3,4b1e <printint+0x16>
    4b1a:	0805c663          	bltz	a1,4ba6 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4b1e:	2581                	sext.w	a1,a1
  neg = 0;
    4b20:	4881                	li	a7,0
    4b22:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4b26:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4b28:	2601                	sext.w	a2,a2
    4b2a:	00003517          	auipc	a0,0x3
    4b2e:	8d650513          	addi	a0,a0,-1834 # 7400 <digits>
    4b32:	883a                	mv	a6,a4
    4b34:	2705                	addiw	a4,a4,1
    4b36:	02c5f7bb          	remuw	a5,a1,a2
    4b3a:	1782                	slli	a5,a5,0x20
    4b3c:	9381                	srli	a5,a5,0x20
    4b3e:	97aa                	add	a5,a5,a0
    4b40:	0007c783          	lbu	a5,0(a5)
    4b44:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b48:	0005879b          	sext.w	a5,a1
    4b4c:	02c5d5bb          	divuw	a1,a1,a2
    4b50:	0685                	addi	a3,a3,1
    4b52:	fec7f0e3          	bgeu	a5,a2,4b32 <printint+0x2a>
  if(neg)
    4b56:	00088b63          	beqz	a7,4b6c <printint+0x64>
    buf[i++] = '-';
    4b5a:	fd040793          	addi	a5,s0,-48
    4b5e:	973e                	add	a4,a4,a5
    4b60:	02d00793          	li	a5,45
    4b64:	fef70823          	sb	a5,-16(a4)
    4b68:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4b6c:	02e05663          	blez	a4,4b98 <printint+0x90>
    4b70:	fc040793          	addi	a5,s0,-64
    4b74:	00e78933          	add	s2,a5,a4
    4b78:	fff78993          	addi	s3,a5,-1
    4b7c:	99ba                	add	s3,s3,a4
    4b7e:	377d                	addiw	a4,a4,-1
    4b80:	1702                	slli	a4,a4,0x20
    4b82:	9301                	srli	a4,a4,0x20
    4b84:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4b88:	fff94583          	lbu	a1,-1(s2)
    4b8c:	8526                	mv	a0,s1
    4b8e:	f5dff0ef          	jal	ra,4aea <putc>
  while(--i >= 0)
    4b92:	197d                	addi	s2,s2,-1
    4b94:	ff391ae3          	bne	s2,s3,4b88 <printint+0x80>
}
    4b98:	70e2                	ld	ra,56(sp)
    4b9a:	7442                	ld	s0,48(sp)
    4b9c:	74a2                	ld	s1,40(sp)
    4b9e:	7902                	ld	s2,32(sp)
    4ba0:	69e2                	ld	s3,24(sp)
    4ba2:	6121                	addi	sp,sp,64
    4ba4:	8082                	ret
    x = -xx;
    4ba6:	40b005bb          	negw	a1,a1
    neg = 1;
    4baa:	4885                	li	a7,1
    x = -xx;
    4bac:	bf9d                	j	4b22 <printint+0x1a>

0000000000004bae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4bae:	7119                	addi	sp,sp,-128
    4bb0:	fc86                	sd	ra,120(sp)
    4bb2:	f8a2                	sd	s0,112(sp)
    4bb4:	f4a6                	sd	s1,104(sp)
    4bb6:	f0ca                	sd	s2,96(sp)
    4bb8:	ecce                	sd	s3,88(sp)
    4bba:	e8d2                	sd	s4,80(sp)
    4bbc:	e4d6                	sd	s5,72(sp)
    4bbe:	e0da                	sd	s6,64(sp)
    4bc0:	fc5e                	sd	s7,56(sp)
    4bc2:	f862                	sd	s8,48(sp)
    4bc4:	f466                	sd	s9,40(sp)
    4bc6:	f06a                	sd	s10,32(sp)
    4bc8:	ec6e                	sd	s11,24(sp)
    4bca:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4bcc:	0005c903          	lbu	s2,0(a1)
    4bd0:	22090e63          	beqz	s2,4e0c <vprintf+0x25e>
    4bd4:	8b2a                	mv	s6,a0
    4bd6:	8a2e                	mv	s4,a1
    4bd8:	8bb2                	mv	s7,a2
  state = 0;
    4bda:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4bdc:	4481                	li	s1,0
    4bde:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4be0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4be4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4be8:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4bec:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4bf0:	00003c97          	auipc	s9,0x3
    4bf4:	810c8c93          	addi	s9,s9,-2032 # 7400 <digits>
    4bf8:	a005                	j	4c18 <vprintf+0x6a>
        putc(fd, c0);
    4bfa:	85ca                	mv	a1,s2
    4bfc:	855a                	mv	a0,s6
    4bfe:	eedff0ef          	jal	ra,4aea <putc>
    4c02:	a019                	j	4c08 <vprintf+0x5a>
    } else if(state == '%'){
    4c04:	03598263          	beq	s3,s5,4c28 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4c08:	2485                	addiw	s1,s1,1
    4c0a:	8726                	mv	a4,s1
    4c0c:	009a07b3          	add	a5,s4,s1
    4c10:	0007c903          	lbu	s2,0(a5)
    4c14:	1e090c63          	beqz	s2,4e0c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
    4c18:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4c1c:	fe0994e3          	bnez	s3,4c04 <vprintf+0x56>
      if(c0 == '%'){
    4c20:	fd579de3          	bne	a5,s5,4bfa <vprintf+0x4c>
        state = '%';
    4c24:	89be                	mv	s3,a5
    4c26:	b7cd                	j	4c08 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4c28:	cfa5                	beqz	a5,4ca0 <vprintf+0xf2>
    4c2a:	00ea06b3          	add	a3,s4,a4
    4c2e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4c32:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4c34:	c681                	beqz	a3,4c3c <vprintf+0x8e>
    4c36:	9752                	add	a4,a4,s4
    4c38:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4c3c:	03878a63          	beq	a5,s8,4c70 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4c40:	05a78463          	beq	a5,s10,4c88 <vprintf+0xda>
      } else if(c0 == 'u'){
    4c44:	0db78763          	beq	a5,s11,4d12 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c48:	07800713          	li	a4,120
    4c4c:	10e78963          	beq	a5,a4,4d5e <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c50:	07000713          	li	a4,112
    4c54:	12e78e63          	beq	a5,a4,4d90 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c58:	07300713          	li	a4,115
    4c5c:	16e78b63          	beq	a5,a4,4dd2 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c60:	05579063          	bne	a5,s5,4ca0 <vprintf+0xf2>
        putc(fd, '%');
    4c64:	85d6                	mv	a1,s5
    4c66:	855a                	mv	a0,s6
    4c68:	e83ff0ef          	jal	ra,4aea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4c6c:	4981                	li	s3,0
    4c6e:	bf69                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
    4c70:	008b8913          	addi	s2,s7,8
    4c74:	4685                	li	a3,1
    4c76:	4629                	li	a2,10
    4c78:	000ba583          	lw	a1,0(s7)
    4c7c:	855a                	mv	a0,s6
    4c7e:	e8bff0ef          	jal	ra,4b08 <printint>
    4c82:	8bca                	mv	s7,s2
      state = 0;
    4c84:	4981                	li	s3,0
    4c86:	b749                	j	4c08 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
    4c88:	03868663          	beq	a3,s8,4cb4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4c8c:	05a68163          	beq	a3,s10,4cce <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
    4c90:	09b68d63          	beq	a3,s11,4d2a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4c94:	03a68f63          	beq	a3,s10,4cd2 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
    4c98:	07800793          	li	a5,120
    4c9c:	0cf68d63          	beq	a3,a5,4d76 <vprintf+0x1c8>
        putc(fd, '%');
    4ca0:	85d6                	mv	a1,s5
    4ca2:	855a                	mv	a0,s6
    4ca4:	e47ff0ef          	jal	ra,4aea <putc>
        putc(fd, c0);
    4ca8:	85ca                	mv	a1,s2
    4caa:	855a                	mv	a0,s6
    4cac:	e3fff0ef          	jal	ra,4aea <putc>
      state = 0;
    4cb0:	4981                	li	s3,0
    4cb2:	bf99                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cb4:	008b8913          	addi	s2,s7,8
    4cb8:	4685                	li	a3,1
    4cba:	4629                	li	a2,10
    4cbc:	000ba583          	lw	a1,0(s7)
    4cc0:	855a                	mv	a0,s6
    4cc2:	e47ff0ef          	jal	ra,4b08 <printint>
        i += 1;
    4cc6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cc8:	8bca                	mv	s7,s2
      state = 0;
    4cca:	4981                	li	s3,0
        i += 1;
    4ccc:	bf35                	j	4c08 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4cce:	03860563          	beq	a2,s8,4cf8 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4cd2:	07b60963          	beq	a2,s11,4d44 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4cd6:	07800793          	li	a5,120
    4cda:	fcf613e3          	bne	a2,a5,4ca0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cde:	008b8913          	addi	s2,s7,8
    4ce2:	4681                	li	a3,0
    4ce4:	4641                	li	a2,16
    4ce6:	000ba583          	lw	a1,0(s7)
    4cea:	855a                	mv	a0,s6
    4cec:	e1dff0ef          	jal	ra,4b08 <printint>
        i += 2;
    4cf0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cf2:	8bca                	mv	s7,s2
      state = 0;
    4cf4:	4981                	li	s3,0
        i += 2;
    4cf6:	bf09                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cf8:	008b8913          	addi	s2,s7,8
    4cfc:	4685                	li	a3,1
    4cfe:	4629                	li	a2,10
    4d00:	000ba583          	lw	a1,0(s7)
    4d04:	855a                	mv	a0,s6
    4d06:	e03ff0ef          	jal	ra,4b08 <printint>
        i += 2;
    4d0a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d0c:	8bca                	mv	s7,s2
      state = 0;
    4d0e:	4981                	li	s3,0
        i += 2;
    4d10:	bde5                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
    4d12:	008b8913          	addi	s2,s7,8
    4d16:	4681                	li	a3,0
    4d18:	4629                	li	a2,10
    4d1a:	000ba583          	lw	a1,0(s7)
    4d1e:	855a                	mv	a0,s6
    4d20:	de9ff0ef          	jal	ra,4b08 <printint>
    4d24:	8bca                	mv	s7,s2
      state = 0;
    4d26:	4981                	li	s3,0
    4d28:	b5c5                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d2a:	008b8913          	addi	s2,s7,8
    4d2e:	4681                	li	a3,0
    4d30:	4629                	li	a2,10
    4d32:	000ba583          	lw	a1,0(s7)
    4d36:	855a                	mv	a0,s6
    4d38:	dd1ff0ef          	jal	ra,4b08 <printint>
        i += 1;
    4d3c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d3e:	8bca                	mv	s7,s2
      state = 0;
    4d40:	4981                	li	s3,0
        i += 1;
    4d42:	b5d9                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d44:	008b8913          	addi	s2,s7,8
    4d48:	4681                	li	a3,0
    4d4a:	4629                	li	a2,10
    4d4c:	000ba583          	lw	a1,0(s7)
    4d50:	855a                	mv	a0,s6
    4d52:	db7ff0ef          	jal	ra,4b08 <printint>
        i += 2;
    4d56:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d58:	8bca                	mv	s7,s2
      state = 0;
    4d5a:	4981                	li	s3,0
        i += 2;
    4d5c:	b575                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
    4d5e:	008b8913          	addi	s2,s7,8
    4d62:	4681                	li	a3,0
    4d64:	4641                	li	a2,16
    4d66:	000ba583          	lw	a1,0(s7)
    4d6a:	855a                	mv	a0,s6
    4d6c:	d9dff0ef          	jal	ra,4b08 <printint>
    4d70:	8bca                	mv	s7,s2
      state = 0;
    4d72:	4981                	li	s3,0
    4d74:	bd51                	j	4c08 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d76:	008b8913          	addi	s2,s7,8
    4d7a:	4681                	li	a3,0
    4d7c:	4641                	li	a2,16
    4d7e:	000ba583          	lw	a1,0(s7)
    4d82:	855a                	mv	a0,s6
    4d84:	d85ff0ef          	jal	ra,4b08 <printint>
        i += 1;
    4d88:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d8a:	8bca                	mv	s7,s2
      state = 0;
    4d8c:	4981                	li	s3,0
        i += 1;
    4d8e:	bdad                	j	4c08 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
    4d90:	008b8793          	addi	a5,s7,8
    4d94:	f8f43423          	sd	a5,-120(s0)
    4d98:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4d9c:	03000593          	li	a1,48
    4da0:	855a                	mv	a0,s6
    4da2:	d49ff0ef          	jal	ra,4aea <putc>
  putc(fd, 'x');
    4da6:	07800593          	li	a1,120
    4daa:	855a                	mv	a0,s6
    4dac:	d3fff0ef          	jal	ra,4aea <putc>
    4db0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4db2:	03c9d793          	srli	a5,s3,0x3c
    4db6:	97e6                	add	a5,a5,s9
    4db8:	0007c583          	lbu	a1,0(a5)
    4dbc:	855a                	mv	a0,s6
    4dbe:	d2dff0ef          	jal	ra,4aea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4dc2:	0992                	slli	s3,s3,0x4
    4dc4:	397d                	addiw	s2,s2,-1
    4dc6:	fe0916e3          	bnez	s2,4db2 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
    4dca:	f8843b83          	ld	s7,-120(s0)
      state = 0;
    4dce:	4981                	li	s3,0
    4dd0:	bd25                	j	4c08 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
    4dd2:	008b8993          	addi	s3,s7,8
    4dd6:	000bb903          	ld	s2,0(s7)
    4dda:	00090f63          	beqz	s2,4df8 <vprintf+0x24a>
        for(; *s; s++)
    4dde:	00094583          	lbu	a1,0(s2)
    4de2:	c195                	beqz	a1,4e06 <vprintf+0x258>
          putc(fd, *s);
    4de4:	855a                	mv	a0,s6
    4de6:	d05ff0ef          	jal	ra,4aea <putc>
        for(; *s; s++)
    4dea:	0905                	addi	s2,s2,1
    4dec:	00094583          	lbu	a1,0(s2)
    4df0:	f9f5                	bnez	a1,4de4 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4df2:	8bce                	mv	s7,s3
      state = 0;
    4df4:	4981                	li	s3,0
    4df6:	bd09                	j	4c08 <vprintf+0x5a>
          s = "(null)";
    4df8:	00002917          	auipc	s2,0x2
    4dfc:	60090913          	addi	s2,s2,1536 # 73f8 <malloc+0x24ea>
        for(; *s; s++)
    4e00:	02800593          	li	a1,40
    4e04:	b7c5                	j	4de4 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4e06:	8bce                	mv	s7,s3
      state = 0;
    4e08:	4981                	li	s3,0
    4e0a:	bbfd                	j	4c08 <vprintf+0x5a>
    }
  }
}
    4e0c:	70e6                	ld	ra,120(sp)
    4e0e:	7446                	ld	s0,112(sp)
    4e10:	74a6                	ld	s1,104(sp)
    4e12:	7906                	ld	s2,96(sp)
    4e14:	69e6                	ld	s3,88(sp)
    4e16:	6a46                	ld	s4,80(sp)
    4e18:	6aa6                	ld	s5,72(sp)
    4e1a:	6b06                	ld	s6,64(sp)
    4e1c:	7be2                	ld	s7,56(sp)
    4e1e:	7c42                	ld	s8,48(sp)
    4e20:	7ca2                	ld	s9,40(sp)
    4e22:	7d02                	ld	s10,32(sp)
    4e24:	6de2                	ld	s11,24(sp)
    4e26:	6109                	addi	sp,sp,128
    4e28:	8082                	ret

0000000000004e2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e2a:	715d                	addi	sp,sp,-80
    4e2c:	ec06                	sd	ra,24(sp)
    4e2e:	e822                	sd	s0,16(sp)
    4e30:	1000                	addi	s0,sp,32
    4e32:	e010                	sd	a2,0(s0)
    4e34:	e414                	sd	a3,8(s0)
    4e36:	e818                	sd	a4,16(s0)
    4e38:	ec1c                	sd	a5,24(s0)
    4e3a:	03043023          	sd	a6,32(s0)
    4e3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e46:	8622                	mv	a2,s0
    4e48:	d67ff0ef          	jal	ra,4bae <vprintf>
}
    4e4c:	60e2                	ld	ra,24(sp)
    4e4e:	6442                	ld	s0,16(sp)
    4e50:	6161                	addi	sp,sp,80
    4e52:	8082                	ret

0000000000004e54 <printf>:

void
printf(const char *fmt, ...)
{
    4e54:	711d                	addi	sp,sp,-96
    4e56:	ec06                	sd	ra,24(sp)
    4e58:	e822                	sd	s0,16(sp)
    4e5a:	1000                	addi	s0,sp,32
    4e5c:	e40c                	sd	a1,8(s0)
    4e5e:	e810                	sd	a2,16(s0)
    4e60:	ec14                	sd	a3,24(s0)
    4e62:	f018                	sd	a4,32(s0)
    4e64:	f41c                	sd	a5,40(s0)
    4e66:	03043823          	sd	a6,48(s0)
    4e6a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4e6e:	00840613          	addi	a2,s0,8
    4e72:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4e76:	85aa                	mv	a1,a0
    4e78:	4505                	li	a0,1
    4e7a:	d35ff0ef          	jal	ra,4bae <vprintf>
}
    4e7e:	60e2                	ld	ra,24(sp)
    4e80:	6442                	ld	s0,16(sp)
    4e82:	6125                	addi	sp,sp,96
    4e84:	8082                	ret

0000000000004e86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4e86:	1141                	addi	sp,sp,-16
    4e88:	e422                	sd	s0,8(sp)
    4e8a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4e8c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4e90:	00003797          	auipc	a5,0x3
    4e94:	5c07b783          	ld	a5,1472(a5) # 8450 <freep>
    4e98:	a805                	j	4ec8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4e9a:	4618                	lw	a4,8(a2)
    4e9c:	9db9                	addw	a1,a1,a4
    4e9e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4ea2:	6398                	ld	a4,0(a5)
    4ea4:	6318                	ld	a4,0(a4)
    4ea6:	fee53823          	sd	a4,-16(a0)
    4eaa:	a091                	j	4eee <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4eac:	ff852703          	lw	a4,-8(a0)
    4eb0:	9e39                	addw	a2,a2,a4
    4eb2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4eb4:	ff053703          	ld	a4,-16(a0)
    4eb8:	e398                	sd	a4,0(a5)
    4eba:	a099                	j	4f00 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ebc:	6398                	ld	a4,0(a5)
    4ebe:	00e7e463          	bltu	a5,a4,4ec6 <free+0x40>
    4ec2:	00e6ea63          	bltu	a3,a4,4ed6 <free+0x50>
{
    4ec6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4ec8:	fed7fae3          	bgeu	a5,a3,4ebc <free+0x36>
    4ecc:	6398                	ld	a4,0(a5)
    4ece:	00e6e463          	bltu	a3,a4,4ed6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ed2:	fee7eae3          	bltu	a5,a4,4ec6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4ed6:	ff852583          	lw	a1,-8(a0)
    4eda:	6390                	ld	a2,0(a5)
    4edc:	02059713          	slli	a4,a1,0x20
    4ee0:	9301                	srli	a4,a4,0x20
    4ee2:	0712                	slli	a4,a4,0x4
    4ee4:	9736                	add	a4,a4,a3
    4ee6:	fae60ae3          	beq	a2,a4,4e9a <free+0x14>
    bp->s.ptr = p->s.ptr;
    4eea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4eee:	4790                	lw	a2,8(a5)
    4ef0:	02061713          	slli	a4,a2,0x20
    4ef4:	9301                	srli	a4,a4,0x20
    4ef6:	0712                	slli	a4,a4,0x4
    4ef8:	973e                	add	a4,a4,a5
    4efa:	fae689e3          	beq	a3,a4,4eac <free+0x26>
  } else
    p->s.ptr = bp;
    4efe:	e394                	sd	a3,0(a5)
  freep = p;
    4f00:	00003717          	auipc	a4,0x3
    4f04:	54f73823          	sd	a5,1360(a4) # 8450 <freep>
}
    4f08:	6422                	ld	s0,8(sp)
    4f0a:	0141                	addi	sp,sp,16
    4f0c:	8082                	ret

0000000000004f0e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4f0e:	7139                	addi	sp,sp,-64
    4f10:	fc06                	sd	ra,56(sp)
    4f12:	f822                	sd	s0,48(sp)
    4f14:	f426                	sd	s1,40(sp)
    4f16:	f04a                	sd	s2,32(sp)
    4f18:	ec4e                	sd	s3,24(sp)
    4f1a:	e852                	sd	s4,16(sp)
    4f1c:	e456                	sd	s5,8(sp)
    4f1e:	e05a                	sd	s6,0(sp)
    4f20:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4f22:	02051493          	slli	s1,a0,0x20
    4f26:	9081                	srli	s1,s1,0x20
    4f28:	04bd                	addi	s1,s1,15
    4f2a:	8091                	srli	s1,s1,0x4
    4f2c:	0014899b          	addiw	s3,s1,1
    4f30:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4f32:	00003517          	auipc	a0,0x3
    4f36:	51e53503          	ld	a0,1310(a0) # 8450 <freep>
    4f3a:	c515                	beqz	a0,4f66 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f3e:	4798                	lw	a4,8(a5)
    4f40:	02977f63          	bgeu	a4,s1,4f7e <malloc+0x70>
    4f44:	8a4e                	mv	s4,s3
    4f46:	0009871b          	sext.w	a4,s3
    4f4a:	6685                	lui	a3,0x1
    4f4c:	00d77363          	bgeu	a4,a3,4f52 <malloc+0x44>
    4f50:	6a05                	lui	s4,0x1
    4f52:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4f56:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4f5a:	00003917          	auipc	s2,0x3
    4f5e:	4f690913          	addi	s2,s2,1270 # 8450 <freep>
  if(p == (char*)-1)
    4f62:	5afd                	li	s5,-1
    4f64:	a0bd                	j	4fd2 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    4f66:	0000a797          	auipc	a5,0xa
    4f6a:	d1278793          	addi	a5,a5,-750 # ec78 <base>
    4f6e:	00003717          	auipc	a4,0x3
    4f72:	4ef73123          	sd	a5,1250(a4) # 8450 <freep>
    4f76:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4f78:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4f7c:	b7e1                	j	4f44 <malloc+0x36>
      if(p->s.size == nunits)
    4f7e:	02e48b63          	beq	s1,a4,4fb4 <malloc+0xa6>
        p->s.size -= nunits;
    4f82:	4137073b          	subw	a4,a4,s3
    4f86:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4f88:	1702                	slli	a4,a4,0x20
    4f8a:	9301                	srli	a4,a4,0x20
    4f8c:	0712                	slli	a4,a4,0x4
    4f8e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4f90:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4f94:	00003717          	auipc	a4,0x3
    4f98:	4aa73e23          	sd	a0,1212(a4) # 8450 <freep>
      return (void*)(p + 1);
    4f9c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4fa0:	70e2                	ld	ra,56(sp)
    4fa2:	7442                	ld	s0,48(sp)
    4fa4:	74a2                	ld	s1,40(sp)
    4fa6:	7902                	ld	s2,32(sp)
    4fa8:	69e2                	ld	s3,24(sp)
    4faa:	6a42                	ld	s4,16(sp)
    4fac:	6aa2                	ld	s5,8(sp)
    4fae:	6b02                	ld	s6,0(sp)
    4fb0:	6121                	addi	sp,sp,64
    4fb2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4fb4:	6398                	ld	a4,0(a5)
    4fb6:	e118                	sd	a4,0(a0)
    4fb8:	bff1                	j	4f94 <malloc+0x86>
  hp->s.size = nu;
    4fba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4fbe:	0541                	addi	a0,a0,16
    4fc0:	ec7ff0ef          	jal	ra,4e86 <free>
  return freep;
    4fc4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4fc8:	dd61                	beqz	a0,4fa0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fcc:	4798                	lw	a4,8(a5)
    4fce:	fa9778e3          	bgeu	a4,s1,4f7e <malloc+0x70>
    if(p == freep)
    4fd2:	00093703          	ld	a4,0(s2)
    4fd6:	853e                	mv	a0,a5
    4fd8:	fef719e3          	bne	a4,a5,4fca <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    4fdc:	8552                	mv	a0,s4
    4fde:	af5ff0ef          	jal	ra,4ad2 <sbrk>
  if(p == (char*)-1)
    4fe2:	fd551ce3          	bne	a0,s5,4fba <malloc+0xac>
        return 0;
    4fe6:	4501                	li	a0,0
    4fe8:	bf65                	j	4fa0 <malloc+0x92>
