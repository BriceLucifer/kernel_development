
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	352000ef          	jal	ra,372 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	34a000ef          	jal	ra,37a <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	8c858593          	addi	a1,a1,-1848 # 900 <malloc+0xe2>
  40:	4509                	li	a0,2
  42:	6f8000ef          	jal	ra,73a <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	312000ef          	jal	ra,35a <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8ba58593          	addi	a1,a1,-1862 # 918 <malloc+0xfa>
  66:	4509                	li	a0,2
  68:	6d2000ef          	jal	ra,73a <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	2ec000ef          	jal	ra,35a <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	e052                	sd	s4,0(sp)
  80:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  82:	4785                	li	a5,1
  84:	02a7df63          	bge	a5,a0,c2 <main+0x50>
  88:	00858913          	addi	s2,a1,8
  8c:	ffe5099b          	addiw	s3,a0,-2
  90:	1982                	slli	s3,s3,0x20
  92:	0209d993          	srli	s3,s3,0x20
  96:	098e                	slli	s3,s3,0x3
  98:	05c1                	addi	a1,a1,16
  9a:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9c:	4581                	li	a1,0
  9e:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a2:	2f8000ef          	jal	ra,39a <open>
  a6:	84aa                	mv	s1,a0
  a8:	02054363          	bltz	a0,ce <main+0x5c>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  ac:	f55ff0ef          	jal	ra,0 <cat>
    close(fd);
  b0:	8526                	mv	a0,s1
  b2:	2d0000ef          	jal	ra,382 <close>
  for(i = 1; i < argc; i++){
  b6:	0921                	addi	s2,s2,8
  b8:	ff3912e3          	bne	s2,s3,9c <main+0x2a>
  }
  exit(0);
  bc:	4501                	li	a0,0
  be:	29c000ef          	jal	ra,35a <exit>
    cat(0);
  c2:	4501                	li	a0,0
  c4:	f3dff0ef          	jal	ra,0 <cat>
    exit(0);
  c8:	4501                	li	a0,0
  ca:	290000ef          	jal	ra,35a <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  ce:	00093603          	ld	a2,0(s2)
  d2:	00001597          	auipc	a1,0x1
  d6:	85e58593          	addi	a1,a1,-1954 # 930 <malloc+0x112>
  da:	4509                	li	a0,2
  dc:	65e000ef          	jal	ra,73a <fprintf>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	278000ef          	jal	ra,35a <exit>

00000000000000e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ee:	f85ff0ef          	jal	ra,72 <main>
  exit(0);
  f2:	4501                	li	a0,0
  f4:	266000ef          	jal	ra,35a <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ce09                	beqz	a2,18a <memset+0x20>
 172:	87aa                	mv	a5,a0
 174:	fff6071b          	addiw	a4,a2,-1
 178:	1702                	slli	a4,a4,0x20
 17a:	9301                	srli	a4,a4,0x20
 17c:	0705                	addi	a4,a4,1
 17e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x16>
  }
  return dst;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  for(; *s; s++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
    if(*s == c)
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
  for(; *s; s++)
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
      return (char*)s;
  return 0;
 1a8:	4501                	li	a0,0
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  return 0;
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d663          	bge	s1,s4,206 <gets+0x52>
    cc = read(0, &c, 1);
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	18c000ef          	jal	ra,372 <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x52>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x50>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679de3          	bne	a5,s6,1d6 <gets+0x22>
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x52>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	166000ef          	jal	ra,39a <open>
  if(fd < 0)
 238:	02054163          	bltz	a0,25a <stat+0x36>
 23c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23e:	85ca                	mv	a1,s2
 240:	172000ef          	jal	ra,3b2 <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	13a000ef          	jal	ra,382 <close>
  return r;
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	64a2                	ld	s1,8(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
    return -1;
 25a:	597d                	li	s2,-1
 25c:	bfc5                	j	24c <stat+0x28>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	00054603          	lbu	a2,0(a0)
 268:	fd06079b          	addiw	a5,a2,-48
 26c:	0ff7f793          	andi	a5,a5,255
 270:	4725                	li	a4,9
 272:	02f76963          	bltu	a4,a5,2a4 <atoi+0x46>
 276:	86aa                	mv	a3,a0
  n = 0;
 278:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 27a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 27c:	0685                	addi	a3,a3,1
 27e:	0025179b          	slliw	a5,a0,0x2
 282:	9fa9                	addw	a5,a5,a0
 284:	0017979b          	slliw	a5,a5,0x1
 288:	9fb1                	addw	a5,a5,a2
 28a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28e:	0006c603          	lbu	a2,0(a3)
 292:	fd06071b          	addiw	a4,a2,-48
 296:	0ff77713          	andi	a4,a4,255
 29a:	fee5f1e3          	bgeu	a1,a4,27c <atoi+0x1e>
  return n;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <atoi+0x40>

00000000000002a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ae:	02b57663          	bgeu	a0,a1,2da <memmove+0x32>
    while(n-- > 0)
 2b2:	02c05163          	blez	a2,2d4 <memmove+0x2c>
 2b6:	fff6079b          	addiw	a5,a2,-1
 2ba:	1782                	slli	a5,a5,0x20
 2bc:	9381                	srli	a5,a5,0x20
 2be:	0785                	addi	a5,a5,1
 2c0:	97aa                	add	a5,a5,a0
  dst = vdst;
 2c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c4:	0585                	addi	a1,a1,1
 2c6:	0705                	addi	a4,a4,1
 2c8:	fff5c683          	lbu	a3,-1(a1)
 2cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d0:	fee79ae3          	bne	a5,a4,2c4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    dst += n;
 2da:	00c50733          	add	a4,a0,a2
    src += n;
 2de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e0:	fec05ae3          	blez	a2,2d4 <memmove+0x2c>
 2e4:	fff6079b          	addiw	a5,a2,-1
 2e8:	1782                	slli	a5,a5,0x20
 2ea:	9381                	srli	a5,a5,0x20
 2ec:	fff7c793          	not	a5,a5
 2f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f2:	15fd                	addi	a1,a1,-1
 2f4:	177d                	addi	a4,a4,-1
 2f6:	0005c683          	lbu	a3,0(a1)
 2fa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x4a>
 302:	bfc9                	j	2d4 <memmove+0x2c>

0000000000000304 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e422                	sd	s0,8(sp)
 308:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30a:	ca05                	beqz	a2,33a <memcmp+0x36>
 30c:	fff6069b          	addiw	a3,a2,-1
 310:	1682                	slli	a3,a3,0x20
 312:	9281                	srli	a3,a3,0x20
 314:	0685                	addi	a3,a3,1
 316:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 318:	00054783          	lbu	a5,0(a0)
 31c:	0005c703          	lbu	a4,0(a1)
 320:	00e79863          	bne	a5,a4,330 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 324:	0505                	addi	a0,a0,1
    p2++;
 326:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 328:	fed518e3          	bne	a0,a3,318 <memcmp+0x14>
  }
  return 0;
 32c:	4501                	li	a0,0
 32e:	a019                	j	334 <memcmp+0x30>
      return *p1 - *p2;
 330:	40e7853b          	subw	a0,a5,a4
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfe5                	j	334 <memcmp+0x30>

000000000000033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 346:	f63ff0ef          	jal	ra,2a8 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	f6fff0ef          	jal	ra,37a <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	7139                	addi	sp,sp,-64
 41a:	fc06                	sd	ra,56(sp)
 41c:	f822                	sd	s0,48(sp)
 41e:	f426                	sd	s1,40(sp)
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	0080                	addi	s0,sp,64
 426:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 428:	c299                	beqz	a3,42e <printint+0x16>
 42a:	0805c663          	bltz	a1,4b6 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 42e:	2581                	sext.w	a1,a1
  neg = 0;
 430:	4881                	li	a7,0
 432:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 436:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 438:	2601                	sext.w	a2,a2
 43a:	00000517          	auipc	a0,0x0
 43e:	51650513          	addi	a0,a0,1302 # 950 <digits>
 442:	883a                	mv	a6,a4
 444:	2705                	addiw	a4,a4,1
 446:	02c5f7bb          	remuw	a5,a1,a2
 44a:	1782                	slli	a5,a5,0x20
 44c:	9381                	srli	a5,a5,0x20
 44e:	97aa                	add	a5,a5,a0
 450:	0007c783          	lbu	a5,0(a5)
 454:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 458:	0005879b          	sext.w	a5,a1
 45c:	02c5d5bb          	divuw	a1,a1,a2
 460:	0685                	addi	a3,a3,1
 462:	fec7f0e3          	bgeu	a5,a2,442 <printint+0x2a>
  if(neg)
 466:	00088b63          	beqz	a7,47c <printint+0x64>
    buf[i++] = '-';
 46a:	fd040793          	addi	a5,s0,-48
 46e:	973e                	add	a4,a4,a5
 470:	02d00793          	li	a5,45
 474:	fef70823          	sb	a5,-16(a4)
 478:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 47c:	02e05663          	blez	a4,4a8 <printint+0x90>
 480:	fc040793          	addi	a5,s0,-64
 484:	00e78933          	add	s2,a5,a4
 488:	fff78993          	addi	s3,a5,-1
 48c:	99ba                	add	s3,s3,a4
 48e:	377d                	addiw	a4,a4,-1
 490:	1702                	slli	a4,a4,0x20
 492:	9301                	srli	a4,a4,0x20
 494:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 498:	fff94583          	lbu	a1,-1(s2)
 49c:	8526                	mv	a0,s1
 49e:	f5dff0ef          	jal	ra,3fa <putc>
  while(--i >= 0)
 4a2:	197d                	addi	s2,s2,-1
 4a4:	ff391ae3          	bne	s2,s3,498 <printint+0x80>
}
 4a8:	70e2                	ld	ra,56(sp)
 4aa:	7442                	ld	s0,48(sp)
 4ac:	74a2                	ld	s1,40(sp)
 4ae:	7902                	ld	s2,32(sp)
 4b0:	69e2                	ld	s3,24(sp)
 4b2:	6121                	addi	sp,sp,64
 4b4:	8082                	ret
    x = -xx;
 4b6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ba:	4885                	li	a7,1
    x = -xx;
 4bc:	bf9d                	j	432 <printint+0x1a>

00000000000004be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4be:	7119                	addi	sp,sp,-128
 4c0:	fc86                	sd	ra,120(sp)
 4c2:	f8a2                	sd	s0,112(sp)
 4c4:	f4a6                	sd	s1,104(sp)
 4c6:	f0ca                	sd	s2,96(sp)
 4c8:	ecce                	sd	s3,88(sp)
 4ca:	e8d2                	sd	s4,80(sp)
 4cc:	e4d6                	sd	s5,72(sp)
 4ce:	e0da                	sd	s6,64(sp)
 4d0:	fc5e                	sd	s7,56(sp)
 4d2:	f862                	sd	s8,48(sp)
 4d4:	f466                	sd	s9,40(sp)
 4d6:	f06a                	sd	s10,32(sp)
 4d8:	ec6e                	sd	s11,24(sp)
 4da:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4dc:	0005c903          	lbu	s2,0(a1)
 4e0:	22090e63          	beqz	s2,71c <vprintf+0x25e>
 4e4:	8b2a                	mv	s6,a0
 4e6:	8a2e                	mv	s4,a1
 4e8:	8bb2                	mv	s7,a2
  state = 0;
 4ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ec:	4481                	li	s1,0
 4ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f8:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fc:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 500:	00000c97          	auipc	s9,0x0
 504:	450c8c93          	addi	s9,s9,1104 # 950 <digits>
 508:	a005                	j	528 <vprintf+0x6a>
        putc(fd, c0);
 50a:	85ca                	mv	a1,s2
 50c:	855a                	mv	a0,s6
 50e:	eedff0ef          	jal	ra,3fa <putc>
 512:	a019                	j	518 <vprintf+0x5a>
    } else if(state == '%'){
 514:	03598263          	beq	s3,s5,538 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 518:	2485                	addiw	s1,s1,1
 51a:	8726                	mv	a4,s1
 51c:	009a07b3          	add	a5,s4,s1
 520:	0007c903          	lbu	s2,0(a5)
 524:	1e090c63          	beqz	s2,71c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 528:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52c:	fe0994e3          	bnez	s3,514 <vprintf+0x56>
      if(c0 == '%'){
 530:	fd579de3          	bne	a5,s5,50a <vprintf+0x4c>
        state = '%';
 534:	89be                	mv	s3,a5
 536:	b7cd                	j	518 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 538:	cfa5                	beqz	a5,5b0 <vprintf+0xf2>
 53a:	00ea06b3          	add	a3,s4,a4
 53e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 542:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 544:	c681                	beqz	a3,54c <vprintf+0x8e>
 546:	9752                	add	a4,a4,s4
 548:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54c:	03878a63          	beq	a5,s8,580 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	05a78463          	beq	a5,s10,598 <vprintf+0xda>
      } else if(c0 == 'u'){
 554:	0db78763          	beq	a5,s11,622 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 558:	07800713          	li	a4,120
 55c:	10e78963          	beq	a5,a4,66e <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 560:	07000713          	li	a4,112
 564:	12e78e63          	beq	a5,a4,6a0 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 568:	07300713          	li	a4,115
 56c:	16e78b63          	beq	a5,a4,6e2 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 570:	05579063          	bne	a5,s5,5b0 <vprintf+0xf2>
        putc(fd, '%');
 574:	85d6                	mv	a1,s5
 576:	855a                	mv	a0,s6
 578:	e83ff0ef          	jal	ra,3fa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bf69                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b8913          	addi	s2,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	e8bff0ef          	jal	ra,418 <printint>
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	b749                	j	518 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 598:	03868663          	beq	a3,s8,5c4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59c:	05a68163          	beq	a3,s10,5de <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 5a0:	09b68d63          	beq	a3,s11,63a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a4:	03a68f63          	beq	a3,s10,5e2 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 5a8:	07800793          	li	a5,120
 5ac:	0cf68d63          	beq	a3,a5,686 <vprintf+0x1c8>
        putc(fd, '%');
 5b0:	85d6                	mv	a1,s5
 5b2:	855a                	mv	a0,s6
 5b4:	e47ff0ef          	jal	ra,3fa <putc>
        putc(fd, c0);
 5b8:	85ca                	mv	a1,s2
 5ba:	855a                	mv	a0,s6
 5bc:	e3fff0ef          	jal	ra,3fa <putc>
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bf99                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e47ff0ef          	jal	ra,418 <printint>
        i += 1;
 5d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 1;
 5dc:	bf35                	j	518 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	03860563          	beq	a2,s8,608 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e2:	07b60963          	beq	a2,s11,654 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	fcf613e3          	bne	a2,a5,5b0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e1dff0ef          	jal	ra,418 <printint>
        i += 2;
 600:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
        i += 2;
 606:	bf09                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	008b8913          	addi	s2,s7,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e03ff0ef          	jal	ra,418 <printint>
        i += 2;
 61a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	bde5                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	de9ff0ef          	jal	ra,418 <printint>
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	b5c5                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	dd1ff0ef          	jal	ra,418 <printint>
        i += 1;
 64c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b5d9                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	db7ff0ef          	jal	ra,418 <printint>
        i += 2;
 666:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	b575                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	d9dff0ef          	jal	ra,418 <printint>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	bd51                	j	518 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4641                	li	a2,16
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d85ff0ef          	jal	ra,418 <printint>
        i += 1;
 698:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 1;
 69e:	bdad                	j	518 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6a0:	008b8793          	addi	a5,s7,8
 6a4:	f8f43423          	sd	a5,-120(s0)
 6a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ac:	03000593          	li	a1,48
 6b0:	855a                	mv	a0,s6
 6b2:	d49ff0ef          	jal	ra,3fa <putc>
  putc(fd, 'x');
 6b6:	07800593          	li	a1,120
 6ba:	855a                	mv	a0,s6
 6bc:	d3fff0ef          	jal	ra,3fa <putc>
 6c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c2:	03c9d793          	srli	a5,s3,0x3c
 6c6:	97e6                	add	a5,a5,s9
 6c8:	0007c583          	lbu	a1,0(a5)
 6cc:	855a                	mv	a0,s6
 6ce:	d2dff0ef          	jal	ra,3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d2:	0992                	slli	s3,s3,0x4
 6d4:	397d                	addiw	s2,s2,-1
 6d6:	fe0916e3          	bnez	s2,6c2 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6da:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd25                	j	518 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6e2:	008b8993          	addi	s3,s7,8
 6e6:	000bb903          	ld	s2,0(s7)
 6ea:	00090f63          	beqz	s2,708 <vprintf+0x24a>
        for(; *s; s++)
 6ee:	00094583          	lbu	a1,0(s2)
 6f2:	c195                	beqz	a1,716 <vprintf+0x258>
          putc(fd, *s);
 6f4:	855a                	mv	a0,s6
 6f6:	d05ff0ef          	jal	ra,3fa <putc>
        for(; *s; s++)
 6fa:	0905                	addi	s2,s2,1
 6fc:	00094583          	lbu	a1,0(s2)
 700:	f9f5                	bnez	a1,6f4 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 702:	8bce                	mv	s7,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	bd09                	j	518 <vprintf+0x5a>
          s = "(null)";
 708:	00000917          	auipc	s2,0x0
 70c:	24090913          	addi	s2,s2,576 # 948 <malloc+0x12a>
        for(; *s; s++)
 710:	02800593          	li	a1,40
 714:	b7c5                	j	6f4 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	bbfd                	j	518 <vprintf+0x5a>
    }
  }
}
 71c:	70e6                	ld	ra,120(sp)
 71e:	7446                	ld	s0,112(sp)
 720:	74a6                	ld	s1,104(sp)
 722:	7906                	ld	s2,96(sp)
 724:	69e6                	ld	s3,88(sp)
 726:	6a46                	ld	s4,80(sp)
 728:	6aa6                	ld	s5,72(sp)
 72a:	6b06                	ld	s6,64(sp)
 72c:	7be2                	ld	s7,56(sp)
 72e:	7c42                	ld	s8,48(sp)
 730:	7ca2                	ld	s9,40(sp)
 732:	7d02                	ld	s10,32(sp)
 734:	6de2                	ld	s11,24(sp)
 736:	6109                	addi	sp,sp,128
 738:	8082                	ret

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	d67ff0ef          	jal	ra,4be <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	d35ff0ef          	jal	ra,4be <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00001797          	auipc	a5,0x1
 7a4:	8607b783          	ld	a5,-1952(a5) # 1000 <freep>
 7a8:	a805                	j	7d8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9db9                	addw	a1,a1,a4
 7ae:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6318                	ld	a4,0(a4)
 7b6:	fee53823          	sd	a4,-16(a0)
 7ba:	a091                	j	7fe <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7bc:	ff852703          	lw	a4,-8(a0)
 7c0:	9e39                	addw	a2,a2,a4
 7c2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c4:	ff053703          	ld	a4,-16(a0)
 7c8:	e398                	sd	a4,0(a5)
 7ca:	a099                	j	810 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x40>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x50>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x36>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059713          	slli	a4,a1,0x20
 7f0:	9301                	srli	a4,a4,0x20
 7f2:	0712                	slli	a4,a4,0x4
 7f4:	9736                	add	a4,a4,a3
 7f6:	fae60ae3          	beq	a2,a4,7aa <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061713          	slli	a4,a2,0x20
 804:	9301                	srli	a4,a4,0x20
 806:	0712                	slli	a4,a4,0x4
 808:	973e                	add	a4,a4,a5
 80a:	fae689e3          	beq	a3,a4,7bc <free+0x26>
  } else
    p->s.ptr = bp;
 80e:	e394                	sd	a3,0(a5)
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
}
 818:	6422                	ld	s0,8(sp)
 81a:	0141                	addi	sp,sp,16
 81c:	8082                	ret

000000000000081e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f426                	sd	s1,40(sp)
 826:	f04a                	sd	s2,32(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
 830:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	02051493          	slli	s1,a0,0x20
 836:	9081                	srli	s1,s1,0x20
 838:	04bd                	addi	s1,s1,15
 83a:	8091                	srli	s1,s1,0x4
 83c:	0014899b          	addiw	s3,s1,1
 840:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 842:	00000517          	auipc	a0,0x0
 846:	7be53503          	ld	a0,1982(a0) # 1000 <freep>
 84a:	c515                	beqz	a0,876 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	02977f63          	bgeu	a4,s1,88e <malloc+0x70>
 854:	8a4e                	mv	s4,s3
 856:	0009871b          	sext.w	a4,s3
 85a:	6685                	lui	a3,0x1
 85c:	00d77363          	bgeu	a4,a3,862 <malloc+0x44>
 860:	6a05                	lui	s4,0x1
 862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86a:	00000917          	auipc	s2,0x0
 86e:	79690913          	addi	s2,s2,1942 # 1000 <freep>
  if(p == (char*)-1)
 872:	5afd                	li	s5,-1
 874:	a0bd                	j	8e2 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 876:	00001797          	auipc	a5,0x1
 87a:	99a78793          	addi	a5,a5,-1638 # 1210 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	78f73123          	sd	a5,1922(a4) # 1000 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7e1                	j	854 <malloc+0x36>
      if(p->s.size == nunits)
 88e:	02e48b63          	beq	s1,a4,8c4 <malloc+0xa6>
        p->s.size -= nunits;
 892:	4137073b          	subw	a4,a4,s3
 896:	c798                	sw	a4,8(a5)
        p += p->s.size;
 898:	1702                	slli	a4,a4,0x20
 89a:	9301                	srli	a4,a4,0x20
 89c:	0712                	slli	a4,a4,0x4
 89e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74a73e23          	sd	a0,1884(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ac:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	7902                	ld	s2,32(sp)
 8b8:	69e2                	ld	s3,24(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	6121                	addi	sp,sp,64
 8c2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	bff1                	j	8a4 <malloc+0x86>
  hp->s.size = nu;
 8ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ce:	0541                	addi	a0,a0,16
 8d0:	ec7ff0ef          	jal	ra,796 <free>
  return freep;
 8d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d8:	dd61                	beqz	a0,8b0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8dc:	4798                	lw	a4,8(a5)
 8de:	fa9778e3          	bgeu	a4,s1,88e <malloc+0x70>
    if(p == freep)
 8e2:	00093703          	ld	a4,0(s2)
 8e6:	853e                	mv	a0,a5
 8e8:	fef719e3          	bne	a4,a5,8da <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8ec:	8552                	mv	a0,s4
 8ee:	af5ff0ef          	jal	ra,3e2 <sbrk>
  if(p == (char*)-1)
 8f2:	fd551ce3          	bne	a0,s5,8ca <malloc+0xac>
        return 0;
 8f6:	4501                	li	a0,0
 8f8:	bf65                	j	8b0 <malloc+0x92>
