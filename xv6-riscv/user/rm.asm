
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d563          	bge	a5,a0,3a <main+0x3a>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	2fe000ef          	jal	ra,328 <unlink>
  2e:	02054063          	bltz	a0,4e <main+0x4e>
  for(i = 1; i < argc; i++){
  32:	04a1                	addi	s1,s1,8
  34:	ff249ae3          	bne	s1,s2,28 <main+0x28>
  38:	a01d                	j	5e <main+0x5e>
    fprintf(2, "Usage: rm files...\n");
  3a:	00001597          	auipc	a1,0x1
  3e:	84658593          	addi	a1,a1,-1978 # 880 <malloc+0xe4>
  42:	4509                	li	a0,2
  44:	674000ef          	jal	ra,6b8 <fprintf>
    exit(1);
  48:	4505                	li	a0,1
  4a:	28e000ef          	jal	ra,2d8 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  4e:	6090                	ld	a2,0(s1)
  50:	00001597          	auipc	a1,0x1
  54:	84858593          	addi	a1,a1,-1976 # 898 <malloc+0xfc>
  58:	4509                	li	a0,2
  5a:	65e000ef          	jal	ra,6b8 <fprintf>
      break;
    }
  }

  exit(0);
  5e:	4501                	li	a0,0
  60:	278000ef          	jal	ra,2d8 <exit>

0000000000000064 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6c:	f95ff0ef          	jal	ra,0 <main>
  exit(0);
  70:	4501                	li	a0,0
  72:	266000ef          	jal	ra,2d8 <exit>

0000000000000076 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7c:	87aa                	mv	a5,a0
  7e:	0585                	addi	a1,a1,1
  80:	0785                	addi	a5,a5,1
  82:	fff5c703          	lbu	a4,-1(a1)
  86:	fee78fa3          	sb	a4,-1(a5)
  8a:	fb75                	bnez	a4,7e <strcpy+0x8>
    ;
  return os;
}
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret

0000000000000092 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	cb91                	beqz	a5,b0 <strcmp+0x1e>
  9e:	0005c703          	lbu	a4,0(a1)
  a2:	00f71763          	bne	a4,a5,b0 <strcmp+0x1e>
    p++, q++;
  a6:	0505                	addi	a0,a0,1
  a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	fbe5                	bnez	a5,9e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b0:	0005c503          	lbu	a0,0(a1)
}
  b4:	40a7853b          	subw	a0,a5,a0
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strlen>:

uint
strlen(const char *s)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cf91                	beqz	a5,e4 <strlen+0x26>
  ca:	0505                	addi	a0,a0,1
  cc:	87aa                	mv	a5,a0
  ce:	4685                	li	a3,1
  d0:	9e89                	subw	a3,a3,a0
  d2:	00f6853b          	addw	a0,a3,a5
  d6:	0785                	addi	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	fb7d                	bnez	a4,d2 <strlen+0x14>
    ;
  return n;
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  for(n = 0; s[n]; n++)
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strlen+0x20>

00000000000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ee:	ce09                	beqz	a2,108 <memset+0x20>
  f0:	87aa                	mv	a5,a0
  f2:	fff6071b          	addiw	a4,a2,-1
  f6:	1702                	slli	a4,a4,0x20
  f8:	9301                	srli	a4,a4,0x20
  fa:	0705                	addi	a4,a4,1
  fc:	972a                	add	a4,a4,a0
    cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x16>
  }
  return dst;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strchr>:

char*
strchr(const char *s, char c)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  for(; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cb99                	beqz	a5,12e <strchr+0x20>
    if(*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1a>
  for(; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xc>
      return (char*)s;
  return 0;
 126:	4501                	li	a0,0
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret
  return 0;
 12e:	4501                	li	a0,0
 130:	bfe5                	j	128 <strchr+0x1a>

0000000000000132 <gets>:

char*
gets(char *buf, int max)
{
 132:	711d                	addi	sp,sp,-96
 134:	ec86                	sd	ra,88(sp)
 136:	e8a2                	sd	s0,80(sp)
 138:	e4a6                	sd	s1,72(sp)
 13a:	e0ca                	sd	s2,64(sp)
 13c:	fc4e                	sd	s3,56(sp)
 13e:	f852                	sd	s4,48(sp)
 140:	f456                	sd	s5,40(sp)
 142:	f05a                	sd	s6,32(sp)
 144:	ec5e                	sd	s7,24(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 150:	4aa9                	li	s5,10
 152:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 154:	89a6                	mv	s3,s1
 156:	2485                	addiw	s1,s1,1
 158:	0344d663          	bge	s1,s4,184 <gets+0x52>
    cc = read(0, &c, 1);
 15c:	4605                	li	a2,1
 15e:	faf40593          	addi	a1,s0,-81
 162:	4501                	li	a0,0
 164:	18c000ef          	jal	ra,2f0 <read>
    if(cc < 1)
 168:	00a05e63          	blez	a0,184 <gets+0x52>
    buf[i++] = c;
 16c:	faf44783          	lbu	a5,-81(s0)
 170:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 174:	01578763          	beq	a5,s5,182 <gets+0x50>
 178:	0905                	addi	s2,s2,1
 17a:	fd679de3          	bne	a5,s6,154 <gets+0x22>
  for(i=0; i+1 < max; ){
 17e:	89a6                	mv	s3,s1
 180:	a011                	j	184 <gets+0x52>
 182:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 184:	99de                	add	s3,s3,s7
 186:	00098023          	sb	zero,0(s3)
  return buf;
}
 18a:	855e                	mv	a0,s7
 18c:	60e6                	ld	ra,88(sp)
 18e:	6446                	ld	s0,80(sp)
 190:	64a6                	ld	s1,72(sp)
 192:	6906                	ld	s2,64(sp)
 194:	79e2                	ld	s3,56(sp)
 196:	7a42                	ld	s4,48(sp)
 198:	7aa2                	ld	s5,40(sp)
 19a:	7b02                	ld	s6,32(sp)
 19c:	6be2                	ld	s7,24(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	4581                	li	a1,0
 1b2:	166000ef          	jal	ra,318 <open>
  if(fd < 0)
 1b6:	02054163          	bltz	a0,1d8 <stat+0x36>
 1ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1bc:	85ca                	mv	a1,s2
 1be:	172000ef          	jal	ra,330 <fstat>
 1c2:	892a                	mv	s2,a0
  close(fd);
 1c4:	8526                	mv	a0,s1
 1c6:	13a000ef          	jal	ra,300 <close>
  return r;
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	64a2                	ld	s1,8(sp)
 1d2:	6902                	ld	s2,0(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret
    return -1;
 1d8:	597d                	li	s2,-1
 1da:	bfc5                	j	1ca <stat+0x28>

00000000000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054603          	lbu	a2,0(a0)
 1e6:	fd06079b          	addiw	a5,a2,-48
 1ea:	0ff7f793          	andi	a5,a5,255
 1ee:	4725                	li	a4,9
 1f0:	02f76963          	bltu	a4,a5,222 <atoi+0x46>
 1f4:	86aa                	mv	a3,a0
  n = 0;
 1f6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1fa:	0685                	addi	a3,a3,1
 1fc:	0025179b          	slliw	a5,a0,0x2
 200:	9fa9                	addw	a5,a5,a0
 202:	0017979b          	slliw	a5,a5,0x1
 206:	9fb1                	addw	a5,a5,a2
 208:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20c:	0006c603          	lbu	a2,0(a3)
 210:	fd06071b          	addiw	a4,a2,-48
 214:	0ff77713          	andi	a4,a4,255
 218:	fee5f1e3          	bgeu	a1,a4,1fa <atoi+0x1e>
  return n;
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22c:	02b57663          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 230:	02c05163          	blez	a2,252 <memmove+0x2c>
 234:	fff6079b          	addiw	a5,a2,-1
 238:	1782                	slli	a5,a5,0x20
 23a:	9381                	srli	a5,a5,0x20
 23c:	0785                	addi	a5,a5,1
 23e:	97aa                	add	a5,a5,a0
  dst = vdst;
 240:	872a                	mv	a4,a0
      *dst++ = *src++;
 242:	0585                	addi	a1,a1,1
 244:	0705                	addi	a4,a4,1
 246:	fff5c683          	lbu	a3,-1(a1)
 24a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    dst += n;
 258:	00c50733          	add	a4,a0,a2
    src += n;
 25c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 25e:	fec05ae3          	blez	a2,252 <memmove+0x2c>
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x4a>
 280:	bfc9                	j	252 <memmove+0x2c>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 288:	ca05                	beqz	a2,2b8 <memcmp+0x36>
 28a:	fff6069b          	addiw	a3,a2,-1
 28e:	1682                	slli	a3,a3,0x20
 290:	9281                	srli	a3,a3,0x20
 292:	0685                	addi	a3,a3,1
 294:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 296:	00054783          	lbu	a5,0(a0)
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00e79863          	bne	a5,a4,2ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a2:	0505                	addi	a0,a0,1
    p2++;
 2a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a6:	fed518e3          	bne	a0,a3,296 <memcmp+0x14>
  }
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	a019                	j	2b2 <memcmp+0x30>
      return *p1 - *p2;
 2ae:	40e7853b          	subw	a0,a5,a4
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <memcmp+0x30>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	ra,226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d0:	4885                	li	a7,1
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d8:	4889                	li	a7,2
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e0:	488d                	li	a7,3
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e8:	4891                	li	a7,4
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <read>:
.global read
read:
 li a7, SYS_read
 2f0:	4895                	li	a7,5
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <write>:
.global write
write:
 li a7, SYS_write
 2f8:	48c1                	li	a7,16
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <close>:
.global close
close:
 li a7, SYS_close
 300:	48d5                	li	a7,21
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <kill>:
.global kill
kill:
 li a7, SYS_kill
 308:	4899                	li	a7,6
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exec>:
.global exec
exec:
 li a7, SYS_exec
 310:	489d                	li	a7,7
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <open>:
.global open
open:
 li a7, SYS_open
 318:	48bd                	li	a7,15
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 320:	48c5                	li	a7,17
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 328:	48c9                	li	a7,18
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 330:	48a1                	li	a7,8
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <link>:
.global link
link:
 li a7, SYS_link
 338:	48cd                	li	a7,19
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 340:	48d1                	li	a7,20
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 348:	48a5                	li	a7,9
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <dup>:
.global dup
dup:
 li a7, SYS_dup
 350:	48a9                	li	a7,10
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 358:	48ad                	li	a7,11
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 360:	48b1                	li	a7,12
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 368:	48b5                	li	a7,13
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 370:	48b9                	li	a7,14
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	f6fff0ef          	jal	ra,2f8 <write>
}
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret

0000000000000396 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 396:	7139                	addi	sp,sp,-64
 398:	fc06                	sd	ra,56(sp)
 39a:	f822                	sd	s0,48(sp)
 39c:	f426                	sd	s1,40(sp)
 39e:	f04a                	sd	s2,32(sp)
 3a0:	ec4e                	sd	s3,24(sp)
 3a2:	0080                	addi	s0,sp,64
 3a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a6:	c299                	beqz	a3,3ac <printint+0x16>
 3a8:	0805c663          	bltz	a1,434 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ac:	2581                	sext.w	a1,a1
  neg = 0;
 3ae:	4881                	li	a7,0
 3b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b6:	2601                	sext.w	a2,a2
 3b8:	00000517          	auipc	a0,0x0
 3bc:	50850513          	addi	a0,a0,1288 # 8c0 <digits>
 3c0:	883a                	mv	a6,a4
 3c2:	2705                	addiw	a4,a4,1
 3c4:	02c5f7bb          	remuw	a5,a1,a2
 3c8:	1782                	slli	a5,a5,0x20
 3ca:	9381                	srli	a5,a5,0x20
 3cc:	97aa                	add	a5,a5,a0
 3ce:	0007c783          	lbu	a5,0(a5)
 3d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d6:	0005879b          	sext.w	a5,a1
 3da:	02c5d5bb          	divuw	a1,a1,a2
 3de:	0685                	addi	a3,a3,1
 3e0:	fec7f0e3          	bgeu	a5,a2,3c0 <printint+0x2a>
  if(neg)
 3e4:	00088b63          	beqz	a7,3fa <printint+0x64>
    buf[i++] = '-';
 3e8:	fd040793          	addi	a5,s0,-48
 3ec:	973e                	add	a4,a4,a5
 3ee:	02d00793          	li	a5,45
 3f2:	fef70823          	sb	a5,-16(a4)
 3f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fa:	02e05663          	blez	a4,426 <printint+0x90>
 3fe:	fc040793          	addi	a5,s0,-64
 402:	00e78933          	add	s2,a5,a4
 406:	fff78993          	addi	s3,a5,-1
 40a:	99ba                	add	s3,s3,a4
 40c:	377d                	addiw	a4,a4,-1
 40e:	1702                	slli	a4,a4,0x20
 410:	9301                	srli	a4,a4,0x20
 412:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 416:	fff94583          	lbu	a1,-1(s2)
 41a:	8526                	mv	a0,s1
 41c:	f5dff0ef          	jal	ra,378 <putc>
  while(--i >= 0)
 420:	197d                	addi	s2,s2,-1
 422:	ff391ae3          	bne	s2,s3,416 <printint+0x80>
}
 426:	70e2                	ld	ra,56(sp)
 428:	7442                	ld	s0,48(sp)
 42a:	74a2                	ld	s1,40(sp)
 42c:	7902                	ld	s2,32(sp)
 42e:	69e2                	ld	s3,24(sp)
 430:	6121                	addi	sp,sp,64
 432:	8082                	ret
    x = -xx;
 434:	40b005bb          	negw	a1,a1
    neg = 1;
 438:	4885                	li	a7,1
    x = -xx;
 43a:	bf9d                	j	3b0 <printint+0x1a>

000000000000043c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43c:	7119                	addi	sp,sp,-128
 43e:	fc86                	sd	ra,120(sp)
 440:	f8a2                	sd	s0,112(sp)
 442:	f4a6                	sd	s1,104(sp)
 444:	f0ca                	sd	s2,96(sp)
 446:	ecce                	sd	s3,88(sp)
 448:	e8d2                	sd	s4,80(sp)
 44a:	e4d6                	sd	s5,72(sp)
 44c:	e0da                	sd	s6,64(sp)
 44e:	fc5e                	sd	s7,56(sp)
 450:	f862                	sd	s8,48(sp)
 452:	f466                	sd	s9,40(sp)
 454:	f06a                	sd	s10,32(sp)
 456:	ec6e                	sd	s11,24(sp)
 458:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45a:	0005c903          	lbu	s2,0(a1)
 45e:	22090e63          	beqz	s2,69a <vprintf+0x25e>
 462:	8b2a                	mv	s6,a0
 464:	8a2e                	mv	s4,a1
 466:	8bb2                	mv	s7,a2
  state = 0;
 468:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46a:	4481                	li	s1,0
 46c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 46e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 472:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 476:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 47a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 47e:	00000c97          	auipc	s9,0x0
 482:	442c8c93          	addi	s9,s9,1090 # 8c0 <digits>
 486:	a005                	j	4a6 <vprintf+0x6a>
        putc(fd, c0);
 488:	85ca                	mv	a1,s2
 48a:	855a                	mv	a0,s6
 48c:	eedff0ef          	jal	ra,378 <putc>
 490:	a019                	j	496 <vprintf+0x5a>
    } else if(state == '%'){
 492:	03598263          	beq	s3,s5,4b6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 496:	2485                	addiw	s1,s1,1
 498:	8726                	mv	a4,s1
 49a:	009a07b3          	add	a5,s4,s1
 49e:	0007c903          	lbu	s2,0(a5)
 4a2:	1e090c63          	beqz	s2,69a <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 4a6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4aa:	fe0994e3          	bnez	s3,492 <vprintf+0x56>
      if(c0 == '%'){
 4ae:	fd579de3          	bne	a5,s5,488 <vprintf+0x4c>
        state = '%';
 4b2:	89be                	mv	s3,a5
 4b4:	b7cd                	j	496 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b6:	cfa5                	beqz	a5,52e <vprintf+0xf2>
 4b8:	00ea06b3          	add	a3,s4,a4
 4bc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c2:	c681                	beqz	a3,4ca <vprintf+0x8e>
 4c4:	9752                	add	a4,a4,s4
 4c6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ca:	03878a63          	beq	a5,s8,4fe <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ce:	05a78463          	beq	a5,s10,516 <vprintf+0xda>
      } else if(c0 == 'u'){
 4d2:	0db78763          	beq	a5,s11,5a0 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d6:	07800713          	li	a4,120
 4da:	10e78963          	beq	a5,a4,5ec <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4de:	07000713          	li	a4,112
 4e2:	12e78e63          	beq	a5,a4,61e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4e6:	07300713          	li	a4,115
 4ea:	16e78b63          	beq	a5,a4,660 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ee:	05579063          	bne	a5,s5,52e <vprintf+0xf2>
        putc(fd, '%');
 4f2:	85d6                	mv	a1,s5
 4f4:	855a                	mv	a0,s6
 4f6:	e83ff0ef          	jal	ra,378 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bf69                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b8913          	addi	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	e8bff0ef          	jal	ra,396 <printint>
 510:	8bca                	mv	s7,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	b749                	j	496 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	03868663          	beq	a3,s8,542 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51a:	05a68163          	beq	a3,s10,55c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 51e:	09b68d63          	beq	a3,s11,5b8 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 522:	03a68f63          	beq	a3,s10,560 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 526:	07800793          	li	a5,120
 52a:	0cf68d63          	beq	a3,a5,604 <vprintf+0x1c8>
        putc(fd, '%');
 52e:	85d6                	mv	a1,s5
 530:	855a                	mv	a0,s6
 532:	e47ff0ef          	jal	ra,378 <putc>
        putc(fd, c0);
 536:	85ca                	mv	a1,s2
 538:	855a                	mv	a0,s6
 53a:	e3fff0ef          	jal	ra,378 <putc>
      state = 0;
 53e:	4981                	li	s3,0
 540:	bf99                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	008b8913          	addi	s2,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	e47ff0ef          	jal	ra,396 <printint>
        i += 1;
 554:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	8bca                	mv	s7,s2
      state = 0;
 558:	4981                	li	s3,0
        i += 1;
 55a:	bf35                	j	496 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55c:	03860563          	beq	a2,s8,586 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 560:	07b60963          	beq	a2,s11,5d2 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 564:	07800793          	li	a5,120
 568:	fcf613e3          	bne	a2,a5,52e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4641                	li	a2,16
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e1dff0ef          	jal	ra,396 <printint>
        i += 2;
 57e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
        i += 2;
 584:	bf09                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e03ff0ef          	jal	ra,396 <printint>
        i += 2;
 598:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	bde5                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	de9ff0ef          	jal	ra,396 <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b5c5                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	dd1ff0ef          	jal	ra,396 <printint>
        i += 1;
 5ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 1;
 5d0:	b5d9                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	db7ff0ef          	jal	ra,396 <printint>
        i += 2;
 5e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	b575                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	d9dff0ef          	jal	ra,396 <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bd51                	j	496 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	d85ff0ef          	jal	ra,396 <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	bdad                	j	496 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 61e:	008b8793          	addi	a5,s7,8
 622:	f8f43423          	sd	a5,-120(s0)
 626:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62a:	03000593          	li	a1,48
 62e:	855a                	mv	a0,s6
 630:	d49ff0ef          	jal	ra,378 <putc>
  putc(fd, 'x');
 634:	07800593          	li	a1,120
 638:	855a                	mv	a0,s6
 63a:	d3fff0ef          	jal	ra,378 <putc>
 63e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 640:	03c9d793          	srli	a5,s3,0x3c
 644:	97e6                	add	a5,a5,s9
 646:	0007c583          	lbu	a1,0(a5)
 64a:	855a                	mv	a0,s6
 64c:	d2dff0ef          	jal	ra,378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 650:	0992                	slli	s3,s3,0x4
 652:	397d                	addiw	s2,s2,-1
 654:	fe0916e3          	bnez	s2,640 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 658:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd25                	j	496 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 660:	008b8993          	addi	s3,s7,8
 664:	000bb903          	ld	s2,0(s7)
 668:	00090f63          	beqz	s2,686 <vprintf+0x24a>
        for(; *s; s++)
 66c:	00094583          	lbu	a1,0(s2)
 670:	c195                	beqz	a1,694 <vprintf+0x258>
          putc(fd, *s);
 672:	855a                	mv	a0,s6
 674:	d05ff0ef          	jal	ra,378 <putc>
        for(; *s; s++)
 678:	0905                	addi	s2,s2,1
 67a:	00094583          	lbu	a1,0(s2)
 67e:	f9f5                	bnez	a1,672 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	bd09                	j	496 <vprintf+0x5a>
          s = "(null)";
 686:	00000917          	auipc	s2,0x0
 68a:	23290913          	addi	s2,s2,562 # 8b8 <malloc+0x11c>
        for(; *s; s++)
 68e:	02800593          	li	a1,40
 692:	b7c5                	j	672 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bbfd                	j	496 <vprintf+0x5a>
    }
  }
}
 69a:	70e6                	ld	ra,120(sp)
 69c:	7446                	ld	s0,112(sp)
 69e:	74a6                	ld	s1,104(sp)
 6a0:	7906                	ld	s2,96(sp)
 6a2:	69e6                	ld	s3,88(sp)
 6a4:	6a46                	ld	s4,80(sp)
 6a6:	6aa6                	ld	s5,72(sp)
 6a8:	6b06                	ld	s6,64(sp)
 6aa:	7be2                	ld	s7,56(sp)
 6ac:	7c42                	ld	s8,48(sp)
 6ae:	7ca2                	ld	s9,40(sp)
 6b0:	7d02                	ld	s10,32(sp)
 6b2:	6de2                	ld	s11,24(sp)
 6b4:	6109                	addi	sp,sp,128
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d4:	8622                	mv	a2,s0
 6d6:	d67ff0ef          	jal	ra,43c <vprintf>
}
 6da:	60e2                	ld	ra,24(sp)
 6dc:	6442                	ld	s0,16(sp)
 6de:	6161                	addi	sp,sp,80
 6e0:	8082                	ret

00000000000006e2 <printf>:

void
printf(const char *fmt, ...)
{
 6e2:	711d                	addi	sp,sp,-96
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	addi	s0,sp,32
 6ea:	e40c                	sd	a1,8(s0)
 6ec:	e810                	sd	a2,16(s0)
 6ee:	ec14                	sd	a3,24(s0)
 6f0:	f018                	sd	a4,32(s0)
 6f2:	f41c                	sd	a5,40(s0)
 6f4:	03043823          	sd	a6,48(s0)
 6f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fc:	00840613          	addi	a2,s0,8
 700:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 704:	85aa                	mv	a1,a0
 706:	4505                	li	a0,1
 708:	d35ff0ef          	jal	ra,43c <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	1141                	addi	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	00001797          	auipc	a5,0x1
 722:	8e27b783          	ld	a5,-1822(a5) # 1000 <freep>
 726:	a805                	j	756 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 728:	4618                	lw	a4,8(a2)
 72a:	9db9                	addw	a1,a1,a4
 72c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	6398                	ld	a4,0(a5)
 732:	6318                	ld	a4,0(a4)
 734:	fee53823          	sd	a4,-16(a0)
 738:	a091                	j	77c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73a:	ff852703          	lw	a4,-8(a0)
 73e:	9e39                	addw	a2,a2,a4
 740:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 742:	ff053703          	ld	a4,-16(a0)
 746:	e398                	sd	a4,0(a5)
 748:	a099                	j	78e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74a:	6398                	ld	a4,0(a5)
 74c:	00e7e463          	bltu	a5,a4,754 <free+0x40>
 750:	00e6ea63          	bltu	a3,a4,764 <free+0x50>
{
 754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	fed7fae3          	bgeu	a5,a3,74a <free+0x36>
 75a:	6398                	ld	a4,0(a5)
 75c:	00e6e463          	bltu	a3,a4,764 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	fee7eae3          	bltu	a5,a4,754 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 764:	ff852583          	lw	a1,-8(a0)
 768:	6390                	ld	a2,0(a5)
 76a:	02059713          	slli	a4,a1,0x20
 76e:	9301                	srli	a4,a4,0x20
 770:	0712                	slli	a4,a4,0x4
 772:	9736                	add	a4,a4,a3
 774:	fae60ae3          	beq	a2,a4,728 <free+0x14>
    bp->s.ptr = p->s.ptr;
 778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77c:	4790                	lw	a2,8(a5)
 77e:	02061713          	slli	a4,a2,0x20
 782:	9301                	srli	a4,a4,0x20
 784:	0712                	slli	a4,a4,0x4
 786:	973e                	add	a4,a4,a5
 788:	fae689e3          	beq	a3,a4,73a <free+0x26>
  } else
    p->s.ptr = bp;
 78c:	e394                	sd	a3,0(a5)
  freep = p;
 78e:	00001717          	auipc	a4,0x1
 792:	86f73923          	sd	a5,-1934(a4) # 1000 <freep>
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	ec4e                	sd	s3,24(sp)
 7a8:	e852                	sd	s4,16(sp)
 7aa:	e456                	sd	s5,8(sp)
 7ac:	e05a                	sd	s6,0(sp)
 7ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b0:	02051493          	slli	s1,a0,0x20
 7b4:	9081                	srli	s1,s1,0x20
 7b6:	04bd                	addi	s1,s1,15
 7b8:	8091                	srli	s1,s1,0x4
 7ba:	0014899b          	addiw	s3,s1,1
 7be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c0:	00001517          	auipc	a0,0x1
 7c4:	84053503          	ld	a0,-1984(a0) # 1000 <freep>
 7c8:	c515                	beqz	a0,7f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	02977f63          	bgeu	a4,s1,80c <malloc+0x70>
 7d2:	8a4e                	mv	s4,s3
 7d4:	0009871b          	sext.w	a4,s3
 7d8:	6685                	lui	a3,0x1
 7da:	00d77363          	bgeu	a4,a3,7e0 <malloc+0x44>
 7de:	6a05                	lui	s4,0x1
 7e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e8:	00001917          	auipc	s2,0x1
 7ec:	81890913          	addi	s2,s2,-2024 # 1000 <freep>
  if(p == (char*)-1)
 7f0:	5afd                	li	s5,-1
 7f2:	a0bd                	j	860 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7f4:	00001797          	auipc	a5,0x1
 7f8:	81c78793          	addi	a5,a5,-2020 # 1010 <base>
 7fc:	00001717          	auipc	a4,0x1
 800:	80f73223          	sd	a5,-2044(a4) # 1000 <freep>
 804:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 806:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80a:	b7e1                	j	7d2 <malloc+0x36>
      if(p->s.size == nunits)
 80c:	02e48b63          	beq	s1,a4,842 <malloc+0xa6>
        p->s.size -= nunits;
 810:	4137073b          	subw	a4,a4,s3
 814:	c798                	sw	a4,8(a5)
        p += p->s.size;
 816:	1702                	slli	a4,a4,0x20
 818:	9301                	srli	a4,a4,0x20
 81a:	0712                	slli	a4,a4,0x4
 81c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 822:	00000717          	auipc	a4,0x0
 826:	7ca73f23          	sd	a0,2014(a4) # 1000 <freep>
      return (void*)(p + 1);
 82a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82e:	70e2                	ld	ra,56(sp)
 830:	7442                	ld	s0,48(sp)
 832:	74a2                	ld	s1,40(sp)
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	e118                	sd	a4,0(a0)
 846:	bff1                	j	822 <malloc+0x86>
  hp->s.size = nu;
 848:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84c:	0541                	addi	a0,a0,16
 84e:	ec7ff0ef          	jal	ra,714 <free>
  return freep;
 852:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 856:	dd61                	beqz	a0,82e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	fa9778e3          	bgeu	a4,s1,80c <malloc+0x70>
    if(p == freep)
 860:	00093703          	ld	a4,0(s2)
 864:	853e                	mv	a0,a5
 866:	fef719e3          	bne	a4,a5,858 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 86a:	8552                	mv	a0,s4
 86c:	af5ff0ef          	jal	ra,360 <sbrk>
  if(p == (char*)-1)
 870:	fd551ce3          	bne	a0,s5,848 <malloc+0xac>
        return 0;
 874:	4501                	li	a0,0
 876:	bf65                	j	82e <malloc+0x92>
