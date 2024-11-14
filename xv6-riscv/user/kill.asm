
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	ra,1c8 <atoi>
  2c:	2c8000ef          	jal	ra,2f4 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	28c000ef          	jal	ra,2c4 <exit>
    fprintf(2, "usage: kill pid...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	83458593          	addi	a1,a1,-1996 # 870 <malloc+0xe8>
  44:	4509                	li	a0,2
  46:	65e000ef          	jal	ra,6a4 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	278000ef          	jal	ra,2c4 <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  extern int main();
  main();
  58:	fa9ff0ef          	jal	ra,0 <main>
  exit(0);
  5c:	4501                	li	a0,0
  5e:	266000ef          	jal	ra,2c4 <exit>

0000000000000062 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	addi	a0,a0,1
  94:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	addi	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	4685                	li	a3,1
  bc:	9e89                	subw	a3,a3,a0
  be:	00f6853b          	addw	a0,a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	fb7d                	bnez	a4,be <strlen+0x14>
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ce09                	beqz	a2,f4 <memset+0x20>
  dc:	87aa                	mv	a5,a0
  de:	fff6071b          	addiw	a4,a2,-1
  e2:	1702                	slli	a4,a4,0x20
  e4:	9301                	srli	a4,a4,0x20
  e6:	0705                	addi	a4,a4,1
  e8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x16>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	18c000ef          	jal	ra,2dc <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
  for(i=0; i+1 < max; ){
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e426                	sd	s1,8(sp)
 196:	e04a                	sd	s2,0(sp)
 198:	1000                	addi	s0,sp,32
 19a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19c:	4581                	li	a1,0
 19e:	166000ef          	jal	ra,304 <open>
  if(fd < 0)
 1a2:	02054163          	bltz	a0,1c4 <stat+0x36>
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	172000ef          	jal	ra,31c <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	13a000ef          	jal	ra,2ec <close>
  return r;
}
 1b6:	854a                	mv	a0,s2
 1b8:	60e2                	ld	ra,24(sp)
 1ba:	6442                	ld	s0,16(sp)
 1bc:	64a2                	ld	s1,8(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfc5                	j	1b6 <stat+0x28>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054603          	lbu	a2,0(a0)
 1d2:	fd06079b          	addiw	a5,a2,-48
 1d6:	0ff7f793          	andi	a5,a5,255
 1da:	4725                	li	a4,9
 1dc:	02f76963          	bltu	a4,a5,20e <atoi+0x46>
 1e0:	86aa                	mv	a3,a0
  n = 0;
 1e2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1e4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1e6:	0685                	addi	a3,a3,1
 1e8:	0025179b          	slliw	a5,a0,0x2
 1ec:	9fa9                	addw	a5,a5,a0
 1ee:	0017979b          	slliw	a5,a5,0x1
 1f2:	9fb1                	addw	a5,a5,a2
 1f4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f8:	0006c603          	lbu	a2,0(a3)
 1fc:	fd06071b          	addiw	a4,a2,-48
 200:	0ff77713          	andi	a4,a4,255
 204:	fee5f1e3          	bgeu	a1,a4,1e6 <atoi+0x1e>
  return n;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  n = 0;
 20e:	4501                	li	a0,0
 210:	bfe5                	j	208 <atoi+0x40>

0000000000000212 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 218:	02b57663          	bgeu	a0,a1,244 <memmove+0x32>
    while(n-- > 0)
 21c:	02c05163          	blez	a2,23e <memmove+0x2c>
 220:	fff6079b          	addiw	a5,a2,-1
 224:	1782                	slli	a5,a5,0x20
 226:	9381                	srli	a5,a5,0x20
 228:	0785                	addi	a5,a5,1
 22a:	97aa                	add	a5,a5,a0
  dst = vdst;
 22c:	872a                	mv	a4,a0
      *dst++ = *src++;
 22e:	0585                	addi	a1,a1,1
 230:	0705                	addi	a4,a4,1
 232:	fff5c683          	lbu	a3,-1(a1)
 236:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23a:	fee79ae3          	bne	a5,a4,22e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
    dst += n;
 244:	00c50733          	add	a4,a0,a2
    src += n;
 248:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24a:	fec05ae3          	blez	a2,23e <memmove+0x2c>
 24e:	fff6079b          	addiw	a5,a2,-1
 252:	1782                	slli	a5,a5,0x20
 254:	9381                	srli	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	addi	a1,a1,-1
 25e:	177d                	addi	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x4a>
 26c:	bfc9                	j	23e <memmove+0x2c>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 274:	ca05                	beqz	a2,2a4 <memcmp+0x36>
 276:	fff6069b          	addiw	a3,a2,-1
 27a:	1682                	slli	a3,a3,0x20
 27c:	9281                	srli	a3,a3,0x20
 27e:	0685                	addi	a3,a3,1
 280:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 282:	00054783          	lbu	a5,0(a0)
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00e79863          	bne	a5,a4,29a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28e:	0505                	addi	a0,a0,1
    p2++;
 290:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 292:	fed518e3          	bne	a0,a3,282 <memcmp+0x14>
  }
  return 0;
 296:	4501                	li	a0,0
 298:	a019                	j	29e <memcmp+0x30>
      return *p1 - *p2;
 29a:	40e7853b          	subw	a0,a5,a4
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <memcmp+0x30>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b0:	f63ff0ef          	jal	ra,212 <memmove>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2bc:	4885                	li	a7,1
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c4:	4889                	li	a7,2
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2cc:	488d                	li	a7,3
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d4:	4891                	li	a7,4
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <read>:
.global read
read:
 li a7, SYS_read
 2dc:	4895                	li	a7,5
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <write>:
.global write
write:
 li a7, SYS_write
 2e4:	48c1                	li	a7,16
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <close>:
.global close
close:
 li a7, SYS_close
 2ec:	48d5                	li	a7,21
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f4:	4899                	li	a7,6
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fc:	489d                	li	a7,7
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <open>:
.global open
open:
 li a7, SYS_open
 304:	48bd                	li	a7,15
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30c:	48c5                	li	a7,17
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 314:	48c9                	li	a7,18
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31c:	48a1                	li	a7,8
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <link>:
.global link
link:
 li a7, SYS_link
 324:	48cd                	li	a7,19
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32c:	48d1                	li	a7,20
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 334:	48a5                	li	a7,9
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <dup>:
.global dup
dup:
 li a7, SYS_dup
 33c:	48a9                	li	a7,10
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 344:	48ad                	li	a7,11
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34c:	48b1                	li	a7,12
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 354:	48b5                	li	a7,13
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35c:	48b9                	li	a7,14
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 370:	4605                	li	a2,1
 372:	fef40593          	addi	a1,s0,-17
 376:	f6fff0ef          	jal	ra,2e4 <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 382:	7139                	addi	sp,sp,-64
 384:	fc06                	sd	ra,56(sp)
 386:	f822                	sd	s0,48(sp)
 388:	f426                	sd	s1,40(sp)
 38a:	f04a                	sd	s2,32(sp)
 38c:	ec4e                	sd	s3,24(sp)
 38e:	0080                	addi	s0,sp,64
 390:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x16>
 394:	0805c663          	bltz	a1,420 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	2581                	sext.w	a1,a1
  neg = 0;
 39a:	4881                	li	a7,0
 39c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a2:	2601                	sext.w	a2,a2
 3a4:	00000517          	auipc	a0,0x0
 3a8:	4ec50513          	addi	a0,a0,1260 # 890 <digits>
 3ac:	883a                	mv	a6,a4
 3ae:	2705                	addiw	a4,a4,1
 3b0:	02c5f7bb          	remuw	a5,a1,a2
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	97aa                	add	a5,a5,a0
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c2:	0005879b          	sext.w	a5,a1
 3c6:	02c5d5bb          	divuw	a1,a1,a2
 3ca:	0685                	addi	a3,a3,1
 3cc:	fec7f0e3          	bgeu	a5,a2,3ac <printint+0x2a>
  if(neg)
 3d0:	00088b63          	beqz	a7,3e6 <printint+0x64>
    buf[i++] = '-';
 3d4:	fd040793          	addi	a5,s0,-48
 3d8:	973e                	add	a4,a4,a5
 3da:	02d00793          	li	a5,45
 3de:	fef70823          	sb	a5,-16(a4)
 3e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e6:	02e05663          	blez	a4,412 <printint+0x90>
 3ea:	fc040793          	addi	a5,s0,-64
 3ee:	00e78933          	add	s2,a5,a4
 3f2:	fff78993          	addi	s3,a5,-1
 3f6:	99ba                	add	s3,s3,a4
 3f8:	377d                	addiw	a4,a4,-1
 3fa:	1702                	slli	a4,a4,0x20
 3fc:	9301                	srli	a4,a4,0x20
 3fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 402:	fff94583          	lbu	a1,-1(s2)
 406:	8526                	mv	a0,s1
 408:	f5dff0ef          	jal	ra,364 <putc>
  while(--i >= 0)
 40c:	197d                	addi	s2,s2,-1
 40e:	ff391ae3          	bne	s2,s3,402 <printint+0x80>
}
 412:	70e2                	ld	ra,56(sp)
 414:	7442                	ld	s0,48(sp)
 416:	74a2                	ld	s1,40(sp)
 418:	7902                	ld	s2,32(sp)
 41a:	69e2                	ld	s3,24(sp)
 41c:	6121                	addi	sp,sp,64
 41e:	8082                	ret
    x = -xx;
 420:	40b005bb          	negw	a1,a1
    neg = 1;
 424:	4885                	li	a7,1
    x = -xx;
 426:	bf9d                	j	39c <printint+0x1a>

0000000000000428 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 428:	7119                	addi	sp,sp,-128
 42a:	fc86                	sd	ra,120(sp)
 42c:	f8a2                	sd	s0,112(sp)
 42e:	f4a6                	sd	s1,104(sp)
 430:	f0ca                	sd	s2,96(sp)
 432:	ecce                	sd	s3,88(sp)
 434:	e8d2                	sd	s4,80(sp)
 436:	e4d6                	sd	s5,72(sp)
 438:	e0da                	sd	s6,64(sp)
 43a:	fc5e                	sd	s7,56(sp)
 43c:	f862                	sd	s8,48(sp)
 43e:	f466                	sd	s9,40(sp)
 440:	f06a                	sd	s10,32(sp)
 442:	ec6e                	sd	s11,24(sp)
 444:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 446:	0005c903          	lbu	s2,0(a1)
 44a:	22090e63          	beqz	s2,686 <vprintf+0x25e>
 44e:	8b2a                	mv	s6,a0
 450:	8a2e                	mv	s4,a1
 452:	8bb2                	mv	s7,a2
  state = 0;
 454:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 456:	4481                	li	s1,0
 458:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 462:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 466:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 46a:	00000c97          	auipc	s9,0x0
 46e:	426c8c93          	addi	s9,s9,1062 # 890 <digits>
 472:	a005                	j	492 <vprintf+0x6a>
        putc(fd, c0);
 474:	85ca                	mv	a1,s2
 476:	855a                	mv	a0,s6
 478:	eedff0ef          	jal	ra,364 <putc>
 47c:	a019                	j	482 <vprintf+0x5a>
    } else if(state == '%'){
 47e:	03598263          	beq	s3,s5,4a2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 482:	2485                	addiw	s1,s1,1
 484:	8726                	mv	a4,s1
 486:	009a07b3          	add	a5,s4,s1
 48a:	0007c903          	lbu	s2,0(a5)
 48e:	1e090c63          	beqz	s2,686 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 492:	0009079b          	sext.w	a5,s2
    if(state == 0){
 496:	fe0994e3          	bnez	s3,47e <vprintf+0x56>
      if(c0 == '%'){
 49a:	fd579de3          	bne	a5,s5,474 <vprintf+0x4c>
        state = '%';
 49e:	89be                	mv	s3,a5
 4a0:	b7cd                	j	482 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a2:	cfa5                	beqz	a5,51a <vprintf+0xf2>
 4a4:	00ea06b3          	add	a3,s4,a4
 4a8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ac:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ae:	c681                	beqz	a3,4b6 <vprintf+0x8e>
 4b0:	9752                	add	a4,a4,s4
 4b2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b6:	03878a63          	beq	a5,s8,4ea <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ba:	05a78463          	beq	a5,s10,502 <vprintf+0xda>
      } else if(c0 == 'u'){
 4be:	0db78763          	beq	a5,s11,58c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c2:	07800713          	li	a4,120
 4c6:	10e78963          	beq	a5,a4,5d8 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ca:	07000713          	li	a4,112
 4ce:	12e78e63          	beq	a5,a4,60a <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4d2:	07300713          	li	a4,115
 4d6:	16e78b63          	beq	a5,a4,64c <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4da:	05579063          	bne	a5,s5,51a <vprintf+0xf2>
        putc(fd, '%');
 4de:	85d6                	mv	a1,s5
 4e0:	855a                	mv	a0,s6
 4e2:	e83ff0ef          	jal	ra,364 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	bf69                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ea:	008b8913          	addi	s2,s7,8
 4ee:	4685                	li	a3,1
 4f0:	4629                	li	a2,10
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	855a                	mv	a0,s6
 4f8:	e8bff0ef          	jal	ra,382 <printint>
 4fc:	8bca                	mv	s7,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	b749                	j	482 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	03868663          	beq	a3,s8,52e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 506:	05a68163          	beq	a3,s10,548 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 50a:	09b68d63          	beq	a3,s11,5a4 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 50e:	03a68f63          	beq	a3,s10,54c <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 512:	07800793          	li	a5,120
 516:	0cf68d63          	beq	a3,a5,5f0 <vprintf+0x1c8>
        putc(fd, '%');
 51a:	85d6                	mv	a1,s5
 51c:	855a                	mv	a0,s6
 51e:	e47ff0ef          	jal	ra,364 <putc>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	e3fff0ef          	jal	ra,364 <putc>
      state = 0;
 52a:	4981                	li	s3,0
 52c:	bf99                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	008b8913          	addi	s2,s7,8
 532:	4685                	li	a3,1
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e47ff0ef          	jal	ra,382 <printint>
        i += 1;
 540:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	8bca                	mv	s7,s2
      state = 0;
 544:	4981                	li	s3,0
        i += 1;
 546:	bf35                	j	482 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 548:	03860563          	beq	a2,s8,572 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 54c:	07b60963          	beq	a2,s11,5be <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 550:	07800793          	li	a5,120
 554:	fcf613e3          	bne	a2,a5,51a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 558:	008b8913          	addi	s2,s7,8
 55c:	4681                	li	a3,0
 55e:	4641                	li	a2,16
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e1dff0ef          	jal	ra,382 <printint>
        i += 2;
 56a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 56c:	8bca                	mv	s7,s2
      state = 0;
 56e:	4981                	li	s3,0
        i += 2;
 570:	bf09                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e03ff0ef          	jal	ra,382 <printint>
        i += 2;
 584:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	bde5                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 58c:	008b8913          	addi	s2,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	de9ff0ef          	jal	ra,382 <printint>
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b5c5                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	dd1ff0ef          	jal	ra,382 <printint>
        i += 1;
 5b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
        i += 1;
 5bc:	b5d9                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	db7ff0ef          	jal	ra,382 <printint>
        i += 2;
 5d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	b575                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	d9dff0ef          	jal	ra,382 <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bd51                	j	482 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	d85ff0ef          	jal	ra,382 <printint>
        i += 1;
 602:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 1;
 608:	bdad                	j	482 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 60a:	008b8793          	addi	a5,s7,8
 60e:	f8f43423          	sd	a5,-120(s0)
 612:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 616:	03000593          	li	a1,48
 61a:	855a                	mv	a0,s6
 61c:	d49ff0ef          	jal	ra,364 <putc>
  putc(fd, 'x');
 620:	07800593          	li	a1,120
 624:	855a                	mv	a0,s6
 626:	d3fff0ef          	jal	ra,364 <putc>
 62a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97e6                	add	a5,a5,s9
 632:	0007c583          	lbu	a1,0(a5)
 636:	855a                	mv	a0,s6
 638:	d2dff0ef          	jal	ra,364 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63c:	0992                	slli	s3,s3,0x4
 63e:	397d                	addiw	s2,s2,-1
 640:	fe0916e3          	bnez	s2,62c <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 644:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd25                	j	482 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 64c:	008b8993          	addi	s3,s7,8
 650:	000bb903          	ld	s2,0(s7)
 654:	00090f63          	beqz	s2,672 <vprintf+0x24a>
        for(; *s; s++)
 658:	00094583          	lbu	a1,0(s2)
 65c:	c195                	beqz	a1,680 <vprintf+0x258>
          putc(fd, *s);
 65e:	855a                	mv	a0,s6
 660:	d05ff0ef          	jal	ra,364 <putc>
        for(; *s; s++)
 664:	0905                	addi	s2,s2,1
 666:	00094583          	lbu	a1,0(s2)
 66a:	f9f5                	bnez	a1,65e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	bd09                	j	482 <vprintf+0x5a>
          s = "(null)";
 672:	00000917          	auipc	s2,0x0
 676:	21690913          	addi	s2,s2,534 # 888 <malloc+0x100>
        for(; *s; s++)
 67a:	02800593          	li	a1,40
 67e:	b7c5                	j	65e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	bbfd                	j	482 <vprintf+0x5a>
    }
  }
}
 686:	70e6                	ld	ra,120(sp)
 688:	7446                	ld	s0,112(sp)
 68a:	74a6                	ld	s1,104(sp)
 68c:	7906                	ld	s2,96(sp)
 68e:	69e6                	ld	s3,88(sp)
 690:	6a46                	ld	s4,80(sp)
 692:	6aa6                	ld	s5,72(sp)
 694:	6b06                	ld	s6,64(sp)
 696:	7be2                	ld	s7,56(sp)
 698:	7c42                	ld	s8,48(sp)
 69a:	7ca2                	ld	s9,40(sp)
 69c:	7d02                	ld	s10,32(sp)
 69e:	6de2                	ld	s11,24(sp)
 6a0:	6109                	addi	sp,sp,128
 6a2:	8082                	ret

00000000000006a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a4:	715d                	addi	sp,sp,-80
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e010                	sd	a2,0(s0)
 6ae:	e414                	sd	a3,8(s0)
 6b0:	e818                	sd	a4,16(s0)
 6b2:	ec1c                	sd	a5,24(s0)
 6b4:	03043023          	sd	a6,32(s0)
 6b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c0:	8622                	mv	a2,s0
 6c2:	d67ff0ef          	jal	ra,428 <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6161                	addi	sp,sp,80
 6cc:	8082                	ret

00000000000006ce <printf>:

void
printf(const char *fmt, ...)
{
 6ce:	711d                	addi	sp,sp,-96
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e40c                	sd	a1,8(s0)
 6d8:	e810                	sd	a2,16(s0)
 6da:	ec14                	sd	a3,24(s0)
 6dc:	f018                	sd	a4,32(s0)
 6de:	f41c                	sd	a5,40(s0)
 6e0:	03043823          	sd	a6,48(s0)
 6e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	00840613          	addi	a2,s0,8
 6ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f0:	85aa                	mv	a1,a0
 6f2:	4505                	li	a0,1
 6f4:	d35ff0ef          	jal	ra,428 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6125                	addi	sp,sp,96
 6fe:	8082                	ret

0000000000000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	1141                	addi	sp,sp,-16
 702:	e422                	sd	s0,8(sp)
 704:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 706:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	00001797          	auipc	a5,0x1
 70e:	8f67b783          	ld	a5,-1802(a5) # 1000 <freep>
 712:	a805                	j	742 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 714:	4618                	lw	a4,8(a2)
 716:	9db9                	addw	a1,a1,a4
 718:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	6398                	ld	a4,0(a5)
 71e:	6318                	ld	a4,0(a4)
 720:	fee53823          	sd	a4,-16(a0)
 724:	a091                	j	768 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 726:	ff852703          	lw	a4,-8(a0)
 72a:	9e39                	addw	a2,a2,a4
 72c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 72e:	ff053703          	ld	a4,-16(a0)
 732:	e398                	sd	a4,0(a5)
 734:	a099                	j	77a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	6398                	ld	a4,0(a5)
 738:	00e7e463          	bltu	a5,a4,740 <free+0x40>
 73c:	00e6ea63          	bltu	a3,a4,750 <free+0x50>
{
 740:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	fed7fae3          	bgeu	a5,a3,736 <free+0x36>
 746:	6398                	ld	a4,0(a5)
 748:	00e6e463          	bltu	a3,a4,750 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	fee7eae3          	bltu	a5,a4,740 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 750:	ff852583          	lw	a1,-8(a0)
 754:	6390                	ld	a2,0(a5)
 756:	02059713          	slli	a4,a1,0x20
 75a:	9301                	srli	a4,a4,0x20
 75c:	0712                	slli	a4,a4,0x4
 75e:	9736                	add	a4,a4,a3
 760:	fae60ae3          	beq	a2,a4,714 <free+0x14>
    bp->s.ptr = p->s.ptr;
 764:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 768:	4790                	lw	a2,8(a5)
 76a:	02061713          	slli	a4,a2,0x20
 76e:	9301                	srli	a4,a4,0x20
 770:	0712                	slli	a4,a4,0x4
 772:	973e                	add	a4,a4,a5
 774:	fae689e3          	beq	a3,a4,726 <free+0x26>
  } else
    p->s.ptr = bp;
 778:	e394                	sd	a3,0(a5)
  freep = p;
 77a:	00001717          	auipc	a4,0x1
 77e:	88f73323          	sd	a5,-1914(a4) # 1000 <freep>
}
 782:	6422                	ld	s0,8(sp)
 784:	0141                	addi	sp,sp,16
 786:	8082                	ret

0000000000000788 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 788:	7139                	addi	sp,sp,-64
 78a:	fc06                	sd	ra,56(sp)
 78c:	f822                	sd	s0,48(sp)
 78e:	f426                	sd	s1,40(sp)
 790:	f04a                	sd	s2,32(sp)
 792:	ec4e                	sd	s3,24(sp)
 794:	e852                	sd	s4,16(sp)
 796:	e456                	sd	s5,8(sp)
 798:	e05a                	sd	s6,0(sp)
 79a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79c:	02051493          	slli	s1,a0,0x20
 7a0:	9081                	srli	s1,s1,0x20
 7a2:	04bd                	addi	s1,s1,15
 7a4:	8091                	srli	s1,s1,0x4
 7a6:	0014899b          	addiw	s3,s1,1
 7aa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ac:	00001517          	auipc	a0,0x1
 7b0:	85453503          	ld	a0,-1964(a0) # 1000 <freep>
 7b4:	c515                	beqz	a0,7e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b8:	4798                	lw	a4,8(a5)
 7ba:	02977f63          	bgeu	a4,s1,7f8 <malloc+0x70>
 7be:	8a4e                	mv	s4,s3
 7c0:	0009871b          	sext.w	a4,s3
 7c4:	6685                	lui	a3,0x1
 7c6:	00d77363          	bgeu	a4,a3,7cc <malloc+0x44>
 7ca:	6a05                	lui	s4,0x1
 7cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d4:	00001917          	auipc	s2,0x1
 7d8:	82c90913          	addi	s2,s2,-2004 # 1000 <freep>
  if(p == (char*)-1)
 7dc:	5afd                	li	s5,-1
 7de:	a0bd                	j	84c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7e0:	00001797          	auipc	a5,0x1
 7e4:	83078793          	addi	a5,a5,-2000 # 1010 <base>
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80f73c23          	sd	a5,-2024(a4) # 1000 <freep>
 7f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f6:	b7e1                	j	7be <malloc+0x36>
      if(p->s.size == nunits)
 7f8:	02e48b63          	beq	s1,a4,82e <malloc+0xa6>
        p->s.size -= nunits;
 7fc:	4137073b          	subw	a4,a4,s3
 800:	c798                	sw	a4,8(a5)
        p += p->s.size;
 802:	1702                	slli	a4,a4,0x20
 804:	9301                	srli	a4,a4,0x20
 806:	0712                	slli	a4,a4,0x4
 808:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 80a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 80e:	00000717          	auipc	a4,0x0
 812:	7ea73923          	sd	a0,2034(a4) # 1000 <freep>
      return (void*)(p + 1);
 816:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 81a:	70e2                	ld	ra,56(sp)
 81c:	7442                	ld	s0,48(sp)
 81e:	74a2                	ld	s1,40(sp)
 820:	7902                	ld	s2,32(sp)
 822:	69e2                	ld	s3,24(sp)
 824:	6a42                	ld	s4,16(sp)
 826:	6aa2                	ld	s5,8(sp)
 828:	6b02                	ld	s6,0(sp)
 82a:	6121                	addi	sp,sp,64
 82c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 82e:	6398                	ld	a4,0(a5)
 830:	e118                	sd	a4,0(a0)
 832:	bff1                	j	80e <malloc+0x86>
  hp->s.size = nu;
 834:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 838:	0541                	addi	a0,a0,16
 83a:	ec7ff0ef          	jal	ra,700 <free>
  return freep;
 83e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 842:	dd61                	beqz	a0,81a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	fa9778e3          	bgeu	a4,s1,7f8 <malloc+0x70>
    if(p == freep)
 84c:	00093703          	ld	a4,0(s2)
 850:	853e                	mv	a0,a5
 852:	fef719e3          	bne	a4,a5,844 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 856:	8552                	mv	a0,s4
 858:	af5ff0ef          	jal	ra,34c <sbrk>
  if(p == (char*)-1)
 85c:	fd551ce3          	bne	a0,s5,834 <malloc+0xac>
        return 0;
 860:	4501                	li	a0,0
 862:	bf65                	j	81a <malloc+0x92>
