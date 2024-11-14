
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	948a0a13          	addi	s4,s4,-1720 # 980 <malloc+0xe6>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1c6000ef          	jal	ra,20c <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01248d63          	beq	s1,s2,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2b85                	addiw	s7,s7,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0997e3          	bnez	s3,4e <wc+0x4e>
        w++;
  64:	2c05                	addiw	s8,s8,1
        inword = 1;
  66:	4985                	li	s3,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	00001597          	auipc	a1,0x1
  76:	f9e58593          	addi	a1,a1,-98 # 1010 <buf>
  7a:	f8843503          	ld	a0,-120(s0)
  7e:	370000ef          	jal	ra,3ee <read>
  82:	00a05f63          	blez	a0,a0 <wc+0xa0>
    for(i=0; i<n; i++){
  86:	00001497          	auipc	s1,0x1
  8a:	f8a48493          	addi	s1,s1,-118 # 1010 <buf>
  8e:	00050d1b          	sext.w	s10,a0
  92:	fff5091b          	addiw	s2,a0,-1
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	996e                	add	s2,s2,s11
  9e:	bf5d                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  a0:	02054c63          	bltz	a0,d8 <wc+0xd8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  a4:	f8043703          	ld	a4,-128(s0)
  a8:	86e6                	mv	a3,s9
  aa:	8662                	mv	a2,s8
  ac:	85de                	mv	a1,s7
  ae:	00001517          	auipc	a0,0x1
  b2:	8ea50513          	addi	a0,a0,-1814 # 998 <malloc+0xfe>
  b6:	72a000ef          	jal	ra,7e0 <printf>
}
  ba:	70e6                	ld	ra,120(sp)
  bc:	7446                	ld	s0,112(sp)
  be:	74a6                	ld	s1,104(sp)
  c0:	7906                	ld	s2,96(sp)
  c2:	69e6                	ld	s3,88(sp)
  c4:	6a46                	ld	s4,80(sp)
  c6:	6aa6                	ld	s5,72(sp)
  c8:	6b06                	ld	s6,64(sp)
  ca:	7be2                	ld	s7,56(sp)
  cc:	7c42                	ld	s8,48(sp)
  ce:	7ca2                	ld	s9,40(sp)
  d0:	7d02                	ld	s10,32(sp)
  d2:	6de2                	ld	s11,24(sp)
  d4:	6109                	addi	sp,sp,128
  d6:	8082                	ret
    printf("wc: read error\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	8b050513          	addi	a0,a0,-1872 # 988 <malloc+0xee>
  e0:	700000ef          	jal	ra,7e0 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	2f0000ef          	jal	ra,3d6 <exit>

00000000000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	7179                	addi	sp,sp,-48
  ec:	f406                	sd	ra,40(sp)
  ee:	f022                	sd	s0,32(sp)
  f0:	ec26                	sd	s1,24(sp)
  f2:	e84a                	sd	s2,16(sp)
  f4:	e44e                	sd	s3,8(sp)
  f6:	e052                	sd	s4,0(sp)
  f8:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fa:	4785                	li	a5,1
  fc:	02a7df63          	bge	a5,a0,13a <main+0x50>
 100:	00858493          	addi	s1,a1,8
 104:	ffe5099b          	addiw	s3,a0,-2
 108:	1982                	slli	s3,s3,0x20
 10a:	0209d993          	srli	s3,s3,0x20
 10e:	098e                	slli	s3,s3,0x3
 110:	05c1                	addi	a1,a1,16
 112:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 114:	4581                	li	a1,0
 116:	6088                	ld	a0,0(s1)
 118:	2fe000ef          	jal	ra,416 <open>
 11c:	892a                	mv	s2,a0
 11e:	02054863          	bltz	a0,14e <main+0x64>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 122:	608c                	ld	a1,0(s1)
 124:	eddff0ef          	jal	ra,0 <wc>
    close(fd);
 128:	854a                	mv	a0,s2
 12a:	2d4000ef          	jal	ra,3fe <close>
  for(i = 1; i < argc; i++){
 12e:	04a1                	addi	s1,s1,8
 130:	ff3492e3          	bne	s1,s3,114 <main+0x2a>
  }
  exit(0);
 134:	4501                	li	a0,0
 136:	2a0000ef          	jal	ra,3d6 <exit>
    wc(0, "");
 13a:	00001597          	auipc	a1,0x1
 13e:	86e58593          	addi	a1,a1,-1938 # 9a8 <malloc+0x10e>
 142:	4501                	li	a0,0
 144:	ebdff0ef          	jal	ra,0 <wc>
    exit(0);
 148:	4501                	li	a0,0
 14a:	28c000ef          	jal	ra,3d6 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 14e:	608c                	ld	a1,0(s1)
 150:	00001517          	auipc	a0,0x1
 154:	86050513          	addi	a0,a0,-1952 # 9b0 <malloc+0x116>
 158:	688000ef          	jal	ra,7e0 <printf>
      exit(1);
 15c:	4505                	li	a0,1
 15e:	278000ef          	jal	ra,3d6 <exit>

0000000000000162 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16a:	f81ff0ef          	jal	ra,ea <main>
  exit(0);
 16e:	4501                	li	a0,0
 170:	266000ef          	jal	ra,3d6 <exit>

0000000000000174 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17a:	87aa                	mv	a5,a0
 17c:	0585                	addi	a1,a1,1
 17e:	0785                	addi	a5,a5,1
 180:	fff5c703          	lbu	a4,-1(a1)
 184:	fee78fa3          	sb	a4,-1(a5)
 188:	fb75                	bnez	a4,17c <strcpy+0x8>
    ;
  return os;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x1e>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x1e>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cf91                	beqz	a5,1e2 <strlen+0x26>
 1c8:	0505                	addi	a0,a0,1
 1ca:	87aa                	mv	a5,a0
 1cc:	4685                	li	a3,1
 1ce:	9e89                	subw	a3,a3,a0
 1d0:	00f6853b          	addw	a0,a3,a5
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff7c703          	lbu	a4,-1(a5)
 1da:	fb7d                	bnez	a4,1d0 <strlen+0x14>
    ;
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  for(n = 0; s[n]; n++)
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <strlen+0x20>

00000000000001e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ec:	ce09                	beqz	a2,206 <memset+0x20>
 1ee:	87aa                	mv	a5,a0
 1f0:	fff6071b          	addiw	a4,a2,-1
 1f4:	1702                	slli	a4,a4,0x20
 1f6:	9301                	srli	a4,a4,0x20
 1f8:	0705                	addi	a4,a4,1
 1fa:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 200:	0785                	addi	a5,a5,1
 202:	fee79de3          	bne	a5,a4,1fc <memset+0x16>
  }
  return dst;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strchr>:

char*
strchr(const char *s, char c)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  for(; *s; s++)
 212:	00054783          	lbu	a5,0(a0)
 216:	cb99                	beqz	a5,22c <strchr+0x20>
    if(*s == c)
 218:	00f58763          	beq	a1,a5,226 <strchr+0x1a>
  for(; *s; s++)
 21c:	0505                	addi	a0,a0,1
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbfd                	bnez	a5,218 <strchr+0xc>
      return (char*)s;
  return 0;
 224:	4501                	li	a0,0
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  return 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <strchr+0x1a>

0000000000000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	711d                	addi	sp,sp,-96
 232:	ec86                	sd	ra,88(sp)
 234:	e8a2                	sd	s0,80(sp)
 236:	e4a6                	sd	s1,72(sp)
 238:	e0ca                	sd	s2,64(sp)
 23a:	fc4e                	sd	s3,56(sp)
 23c:	f852                	sd	s4,48(sp)
 23e:	f456                	sd	s5,40(sp)
 240:	f05a                	sd	s6,32(sp)
 242:	ec5e                	sd	s7,24(sp)
 244:	1080                	addi	s0,sp,96
 246:	8baa                	mv	s7,a0
 248:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	892a                	mv	s2,a0
 24c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24e:	4aa9                	li	s5,10
 250:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 252:	89a6                	mv	s3,s1
 254:	2485                	addiw	s1,s1,1
 256:	0344d663          	bge	s1,s4,282 <gets+0x52>
    cc = read(0, &c, 1);
 25a:	4605                	li	a2,1
 25c:	faf40593          	addi	a1,s0,-81
 260:	4501                	li	a0,0
 262:	18c000ef          	jal	ra,3ee <read>
    if(cc < 1)
 266:	00a05e63          	blez	a0,282 <gets+0x52>
    buf[i++] = c;
 26a:	faf44783          	lbu	a5,-81(s0)
 26e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 272:	01578763          	beq	a5,s5,280 <gets+0x50>
 276:	0905                	addi	s2,s2,1
 278:	fd679de3          	bne	a5,s6,252 <gets+0x22>
  for(i=0; i+1 < max; ){
 27c:	89a6                	mv	s3,s1
 27e:	a011                	j	282 <gets+0x52>
 280:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 282:	99de                	add	s3,s3,s7
 284:	00098023          	sb	zero,0(s3)
  return buf;
}
 288:	855e                	mv	a0,s7
 28a:	60e6                	ld	ra,88(sp)
 28c:	6446                	ld	s0,80(sp)
 28e:	64a6                	ld	s1,72(sp)
 290:	6906                	ld	s2,64(sp)
 292:	79e2                	ld	s3,56(sp)
 294:	7a42                	ld	s4,48(sp)
 296:	7aa2                	ld	s5,40(sp)
 298:	7b02                	ld	s6,32(sp)
 29a:	6be2                	ld	s7,24(sp)
 29c:	6125                	addi	sp,sp,96
 29e:	8082                	ret

00000000000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a0:	1101                	addi	sp,sp,-32
 2a2:	ec06                	sd	ra,24(sp)
 2a4:	e822                	sd	s0,16(sp)
 2a6:	e426                	sd	s1,8(sp)
 2a8:	e04a                	sd	s2,0(sp)
 2aa:	1000                	addi	s0,sp,32
 2ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	4581                	li	a1,0
 2b0:	166000ef          	jal	ra,416 <open>
  if(fd < 0)
 2b4:	02054163          	bltz	a0,2d6 <stat+0x36>
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	172000ef          	jal	ra,42e <fstat>
 2c0:	892a                	mv	s2,a0
  close(fd);
 2c2:	8526                	mv	a0,s1
 2c4:	13a000ef          	jal	ra,3fe <close>
  return r;
}
 2c8:	854a                	mv	a0,s2
 2ca:	60e2                	ld	ra,24(sp)
 2cc:	6442                	ld	s0,16(sp)
 2ce:	64a2                	ld	s1,8(sp)
 2d0:	6902                	ld	s2,0(sp)
 2d2:	6105                	addi	sp,sp,32
 2d4:	8082                	ret
    return -1;
 2d6:	597d                	li	s2,-1
 2d8:	bfc5                	j	2c8 <stat+0x28>

00000000000002da <atoi>:

int
atoi(const char *s)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e0:	00054603          	lbu	a2,0(a0)
 2e4:	fd06079b          	addiw	a5,a2,-48
 2e8:	0ff7f793          	andi	a5,a5,255
 2ec:	4725                	li	a4,9
 2ee:	02f76963          	bltu	a4,a5,320 <atoi+0x46>
 2f2:	86aa                	mv	a3,a0
  n = 0;
 2f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f8:	0685                	addi	a3,a3,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb1                	addw	a5,a5,a2
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	0006c603          	lbu	a2,0(a3)
 30e:	fd06071b          	addiw	a4,a2,-48
 312:	0ff77713          	andi	a4,a4,255
 316:	fee5f1e3          	bgeu	a1,a4,2f8 <atoi+0x1e>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x40>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57663          	bgeu	a0,a1,356 <memmove+0x32>
    while(n-- > 0)
 32e:	02c05163          	blez	a2,350 <memmove+0x2c>
 332:	fff6079b          	addiw	a5,a2,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	0785                	addi	a5,a5,1
 33c:	97aa                	add	a5,a5,a0
  dst = vdst;
 33e:	872a                	mv	a4,a0
      *dst++ = *src++;
 340:	0585                	addi	a1,a1,1
 342:	0705                	addi	a4,a4,1
 344:	fff5c683          	lbu	a3,-1(a1)
 348:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35c:	fec05ae3          	blez	a2,350 <memmove+0x2c>
 360:	fff6079b          	addiw	a5,a2,-1
 364:	1782                	slli	a5,a5,0x20
 366:	9381                	srli	a5,a5,0x20
 368:	fff7c793          	not	a5,a5
 36c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36e:	15fd                	addi	a1,a1,-1
 370:	177d                	addi	a4,a4,-1
 372:	0005c683          	lbu	a3,0(a1)
 376:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x4a>
 37e:	bfc9                	j	350 <memmove+0x2c>

0000000000000380 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 386:	ca05                	beqz	a2,3b6 <memcmp+0x36>
 388:	fff6069b          	addiw	a3,a2,-1
 38c:	1682                	slli	a3,a3,0x20
 38e:	9281                	srli	a3,a3,0x20
 390:	0685                	addi	a3,a3,1
 392:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 394:	00054783          	lbu	a5,0(a0)
 398:	0005c703          	lbu	a4,0(a1)
 39c:	00e79863          	bne	a5,a4,3ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a0:	0505                	addi	a0,a0,1
    p2++;
 3a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a4:	fed518e3          	bne	a0,a3,394 <memcmp+0x14>
  }
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	a019                	j	3b0 <memcmp+0x30>
      return *p1 - *p2;
 3ac:	40e7853b          	subw	a0,a5,a4
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <memcmp+0x30>

00000000000003ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c2:	f63ff0ef          	jal	ra,324 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	1000                	addi	s0,sp,32
 47e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 482:	4605                	li	a2,1
 484:	fef40593          	addi	a1,s0,-17
 488:	f6fff0ef          	jal	ra,3f6 <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c663          	bltz	a1,532 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4881                	li	a7,0
 4ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00000517          	auipc	a0,0x0
 4ba:	51a50513          	addi	a0,a0,1306 # 9d0 <digits>
 4be:	883a                	mv	a6,a4
 4c0:	2705                	addiw	a4,a4,1
 4c2:	02c5f7bb          	remuw	a5,a1,a2
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	97aa                	add	a5,a5,a0
 4cc:	0007c783          	lbu	a5,0(a5)
 4d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d4:	0005879b          	sext.w	a5,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fec7f0e3          	bgeu	a5,a2,4be <printint+0x2a>
  if(neg)
 4e2:	00088b63          	beqz	a7,4f8 <printint+0x64>
    buf[i++] = '-';
 4e6:	fd040793          	addi	a5,s0,-48
 4ea:	973e                	add	a4,a4,a5
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05663          	blez	a4,524 <printint+0x90>
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	addi	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addiw	a4,a4,-1
 50c:	1702                	slli	a4,a4,0x20
 50e:	9301                	srli	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	f5dff0ef          	jal	ra,476 <putc>
  while(--i >= 0)
 51e:	197d                	addi	s2,s2,-1
 520:	ff391ae3          	bne	s2,s3,514 <printint+0x80>
}
 524:	70e2                	ld	ra,56(sp)
 526:	7442                	ld	s0,48(sp)
 528:	74a2                	ld	s1,40(sp)
 52a:	7902                	ld	s2,32(sp)
 52c:	69e2                	ld	s3,24(sp)
 52e:	6121                	addi	sp,sp,64
 530:	8082                	ret
    x = -xx;
 532:	40b005bb          	negw	a1,a1
    neg = 1;
 536:	4885                	li	a7,1
    x = -xx;
 538:	bf9d                	j	4ae <printint+0x1a>

000000000000053a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53a:	7119                	addi	sp,sp,-128
 53c:	fc86                	sd	ra,120(sp)
 53e:	f8a2                	sd	s0,112(sp)
 540:	f4a6                	sd	s1,104(sp)
 542:	f0ca                	sd	s2,96(sp)
 544:	ecce                	sd	s3,88(sp)
 546:	e8d2                	sd	s4,80(sp)
 548:	e4d6                	sd	s5,72(sp)
 54a:	e0da                	sd	s6,64(sp)
 54c:	fc5e                	sd	s7,56(sp)
 54e:	f862                	sd	s8,48(sp)
 550:	f466                	sd	s9,40(sp)
 552:	f06a                	sd	s10,32(sp)
 554:	ec6e                	sd	s11,24(sp)
 556:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 558:	0005c903          	lbu	s2,0(a1)
 55c:	22090e63          	beqz	s2,798 <vprintf+0x25e>
 560:	8b2a                	mv	s6,a0
 562:	8a2e                	mv	s4,a1
 564:	8bb2                	mv	s7,a2
  state = 0;
 566:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 568:	4481                	li	s1,0
 56a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 56c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 570:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 574:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 578:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57c:	00000c97          	auipc	s9,0x0
 580:	454c8c93          	addi	s9,s9,1108 # 9d0 <digits>
 584:	a005                	j	5a4 <vprintf+0x6a>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	eedff0ef          	jal	ra,476 <putc>
 58e:	a019                	j	594 <vprintf+0x5a>
    } else if(state == '%'){
 590:	03598263          	beq	s3,s5,5b4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 594:	2485                	addiw	s1,s1,1
 596:	8726                	mv	a4,s1
 598:	009a07b3          	add	a5,s4,s1
 59c:	0007c903          	lbu	s2,0(a5)
 5a0:	1e090c63          	beqz	s2,798 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5a8:	fe0994e3          	bnez	s3,590 <vprintf+0x56>
      if(c0 == '%'){
 5ac:	fd579de3          	bne	a5,s5,586 <vprintf+0x4c>
        state = '%';
 5b0:	89be                	mv	s3,a5
 5b2:	b7cd                	j	594 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b4:	cfa5                	beqz	a5,62c <vprintf+0xf2>
 5b6:	00ea06b3          	add	a3,s4,a4
 5ba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5be:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5c0:	c681                	beqz	a3,5c8 <vprintf+0x8e>
 5c2:	9752                	add	a4,a4,s4
 5c4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5c8:	03878a63          	beq	a5,s8,5fc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5cc:	05a78463          	beq	a5,s10,614 <vprintf+0xda>
      } else if(c0 == 'u'){
 5d0:	0db78763          	beq	a5,s11,69e <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5d4:	07800713          	li	a4,120
 5d8:	10e78963          	beq	a5,a4,6ea <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5dc:	07000713          	li	a4,112
 5e0:	12e78e63          	beq	a5,a4,71c <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5e4:	07300713          	li	a4,115
 5e8:	16e78b63          	beq	a5,a4,75e <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ec:	05579063          	bne	a5,s5,62c <vprintf+0xf2>
        putc(fd, '%');
 5f0:	85d6                	mv	a1,s5
 5f2:	855a                	mv	a0,s6
 5f4:	e83ff0ef          	jal	ra,476 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bf69                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e8bff0ef          	jal	ra,494 <printint>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b749                	j	594 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 614:	03868663          	beq	a3,s8,640 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	05a68163          	beq	a3,s10,65a <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 61c:	09b68d63          	beq	a3,s11,6b6 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 620:	03a68f63          	beq	a3,s10,65e <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 624:	07800793          	li	a5,120
 628:	0cf68d63          	beq	a3,a5,702 <vprintf+0x1c8>
        putc(fd, '%');
 62c:	85d6                	mv	a1,s5
 62e:	855a                	mv	a0,s6
 630:	e47ff0ef          	jal	ra,476 <putc>
        putc(fd, c0);
 634:	85ca                	mv	a1,s2
 636:	855a                	mv	a0,s6
 638:	e3fff0ef          	jal	ra,476 <putc>
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf99                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	008b8913          	addi	s2,s7,8
 644:	4685                	li	a3,1
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e47ff0ef          	jal	ra,494 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	bf35                	j	594 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	03860563          	beq	a2,s8,684 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65e:	07b60963          	beq	a2,s11,6d0 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 662:	07800793          	li	a5,120
 666:	fcf613e3          	bne	a2,a5,62c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e1dff0ef          	jal	ra,494 <printint>
        i += 2;
 67c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	bf09                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 684:	008b8913          	addi	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	e03ff0ef          	jal	ra,494 <printint>
        i += 2;
 696:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
        i += 2;
 69c:	bde5                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	de9ff0ef          	jal	ra,494 <printint>
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b5c5                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	dd1ff0ef          	jal	ra,494 <printint>
        i += 1;
 6c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
        i += 1;
 6ce:	b5d9                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4629                	li	a2,10
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	db7ff0ef          	jal	ra,494 <printint>
        i += 2;
 6e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
        i += 2;
 6e8:	b575                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d9dff0ef          	jal	ra,494 <printint>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd51                	j	594 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4641                	li	a2,16
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d85ff0ef          	jal	ra,494 <printint>
        i += 1;
 714:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
        i += 1;
 71a:	bdad                	j	594 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 71c:	008b8793          	addi	a5,s7,8
 720:	f8f43423          	sd	a5,-120(s0)
 724:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 728:	03000593          	li	a1,48
 72c:	855a                	mv	a0,s6
 72e:	d49ff0ef          	jal	ra,476 <putc>
  putc(fd, 'x');
 732:	07800593          	li	a1,120
 736:	855a                	mv	a0,s6
 738:	d3fff0ef          	jal	ra,476 <putc>
 73c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	03c9d793          	srli	a5,s3,0x3c
 742:	97e6                	add	a5,a5,s9
 744:	0007c583          	lbu	a1,0(a5)
 748:	855a                	mv	a0,s6
 74a:	d2dff0ef          	jal	ra,476 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74e:	0992                	slli	s3,s3,0x4
 750:	397d                	addiw	s2,s2,-1
 752:	fe0916e3          	bnez	s2,73e <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 756:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bd25                	j	594 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 75e:	008b8993          	addi	s3,s7,8
 762:	000bb903          	ld	s2,0(s7)
 766:	00090f63          	beqz	s2,784 <vprintf+0x24a>
        for(; *s; s++)
 76a:	00094583          	lbu	a1,0(s2)
 76e:	c195                	beqz	a1,792 <vprintf+0x258>
          putc(fd, *s);
 770:	855a                	mv	a0,s6
 772:	d05ff0ef          	jal	ra,476 <putc>
        for(; *s; s++)
 776:	0905                	addi	s2,s2,1
 778:	00094583          	lbu	a1,0(s2)
 77c:	f9f5                	bnez	a1,770 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	bd09                	j	594 <vprintf+0x5a>
          s = "(null)";
 784:	00000917          	auipc	s2,0x0
 788:	24490913          	addi	s2,s2,580 # 9c8 <malloc+0x12e>
        for(; *s; s++)
 78c:	02800593          	li	a1,40
 790:	b7c5                	j	770 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	bbfd                	j	594 <vprintf+0x5a>
    }
  }
}
 798:	70e6                	ld	ra,120(sp)
 79a:	7446                	ld	s0,112(sp)
 79c:	74a6                	ld	s1,104(sp)
 79e:	7906                	ld	s2,96(sp)
 7a0:	69e6                	ld	s3,88(sp)
 7a2:	6a46                	ld	s4,80(sp)
 7a4:	6aa6                	ld	s5,72(sp)
 7a6:	6b06                	ld	s6,64(sp)
 7a8:	7be2                	ld	s7,56(sp)
 7aa:	7c42                	ld	s8,48(sp)
 7ac:	7ca2                	ld	s9,40(sp)
 7ae:	7d02                	ld	s10,32(sp)
 7b0:	6de2                	ld	s11,24(sp)
 7b2:	6109                	addi	sp,sp,128
 7b4:	8082                	ret

00000000000007b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b6:	715d                	addi	sp,sp,-80
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e010                	sd	a2,0(s0)
 7c0:	e414                	sd	a3,8(s0)
 7c2:	e818                	sd	a4,16(s0)
 7c4:	ec1c                	sd	a5,24(s0)
 7c6:	03043023          	sd	a6,32(s0)
 7ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d2:	8622                	mv	a2,s0
 7d4:	d67ff0ef          	jal	ra,53a <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6161                	addi	sp,sp,80
 7de:	8082                	ret

00000000000007e0 <printf>:

void
printf(const char *fmt, ...)
{
 7e0:	711d                	addi	sp,sp,-96
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e40c                	sd	a1,8(s0)
 7ea:	e810                	sd	a2,16(s0)
 7ec:	ec14                	sd	a3,24(s0)
 7ee:	f018                	sd	a4,32(s0)
 7f0:	f41c                	sd	a5,40(s0)
 7f2:	03043823          	sd	a6,48(s0)
 7f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	00840613          	addi	a2,s0,8
 7fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 802:	85aa                	mv	a1,a0
 804:	4505                	li	a0,1
 806:	d35ff0ef          	jal	ra,53a <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6125                	addi	sp,sp,96
 810:	8082                	ret

0000000000000812 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 812:	1141                	addi	sp,sp,-16
 814:	e422                	sd	s0,8(sp)
 816:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 818:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	00000797          	auipc	a5,0x0
 820:	7e47b783          	ld	a5,2020(a5) # 1000 <freep>
 824:	a805                	j	854 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 826:	4618                	lw	a4,8(a2)
 828:	9db9                	addw	a1,a1,a4
 82a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82e:	6398                	ld	a4,0(a5)
 830:	6318                	ld	a4,0(a4)
 832:	fee53823          	sd	a4,-16(a0)
 836:	a091                	j	87a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 838:	ff852703          	lw	a4,-8(a0)
 83c:	9e39                	addw	a2,a2,a4
 83e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 840:	ff053703          	ld	a4,-16(a0)
 844:	e398                	sd	a4,0(a5)
 846:	a099                	j	88c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	6398                	ld	a4,0(a5)
 84a:	00e7e463          	bltu	a5,a4,852 <free+0x40>
 84e:	00e6ea63          	bltu	a3,a4,862 <free+0x50>
{
 852:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	fed7fae3          	bgeu	a5,a3,848 <free+0x36>
 858:	6398                	ld	a4,0(a5)
 85a:	00e6e463          	bltu	a3,a4,862 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	fee7eae3          	bltu	a5,a4,852 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 862:	ff852583          	lw	a1,-8(a0)
 866:	6390                	ld	a2,0(a5)
 868:	02059713          	slli	a4,a1,0x20
 86c:	9301                	srli	a4,a4,0x20
 86e:	0712                	slli	a4,a4,0x4
 870:	9736                	add	a4,a4,a3
 872:	fae60ae3          	beq	a2,a4,826 <free+0x14>
    bp->s.ptr = p->s.ptr;
 876:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87a:	4790                	lw	a2,8(a5)
 87c:	02061713          	slli	a4,a2,0x20
 880:	9301                	srli	a4,a4,0x20
 882:	0712                	slli	a4,a4,0x4
 884:	973e                	add	a4,a4,a5
 886:	fae689e3          	beq	a3,a4,838 <free+0x26>
  } else
    p->s.ptr = bp;
 88a:	e394                	sd	a3,0(a5)
  freep = p;
 88c:	00000717          	auipc	a4,0x0
 890:	76f73a23          	sd	a5,1908(a4) # 1000 <freep>
}
 894:	6422                	ld	s0,8(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret

000000000000089a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89a:	7139                	addi	sp,sp,-64
 89c:	fc06                	sd	ra,56(sp)
 89e:	f822                	sd	s0,48(sp)
 8a0:	f426                	sd	s1,40(sp)
 8a2:	f04a                	sd	s2,32(sp)
 8a4:	ec4e                	sd	s3,24(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
 8ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ae:	02051493          	slli	s1,a0,0x20
 8b2:	9081                	srli	s1,s1,0x20
 8b4:	04bd                	addi	s1,s1,15
 8b6:	8091                	srli	s1,s1,0x4
 8b8:	0014899b          	addiw	s3,s1,1
 8bc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8be:	00000517          	auipc	a0,0x0
 8c2:	74253503          	ld	a0,1858(a0) # 1000 <freep>
 8c6:	c515                	beqz	a0,8f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	02977f63          	bgeu	a4,s1,90a <malloc+0x70>
 8d0:	8a4e                	mv	s4,s3
 8d2:	0009871b          	sext.w	a4,s3
 8d6:	6685                	lui	a3,0x1
 8d8:	00d77363          	bgeu	a4,a3,8de <malloc+0x44>
 8dc:	6a05                	lui	s4,0x1
 8de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e6:	00000917          	auipc	s2,0x0
 8ea:	71a90913          	addi	s2,s2,1818 # 1000 <freep>
  if(p == (char*)-1)
 8ee:	5afd                	li	s5,-1
 8f0:	a0bd                	j	95e <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8f2:	00001797          	auipc	a5,0x1
 8f6:	91e78793          	addi	a5,a5,-1762 # 1210 <base>
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70f73323          	sd	a5,1798(a4) # 1000 <freep>
 902:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 904:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 908:	b7e1                	j	8d0 <malloc+0x36>
      if(p->s.size == nunits)
 90a:	02e48b63          	beq	s1,a4,940 <malloc+0xa6>
        p->s.size -= nunits;
 90e:	4137073b          	subw	a4,a4,s3
 912:	c798                	sw	a4,8(a5)
        p += p->s.size;
 914:	1702                	slli	a4,a4,0x20
 916:	9301                	srli	a4,a4,0x20
 918:	0712                	slli	a4,a4,0x4
 91a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 920:	00000717          	auipc	a4,0x0
 924:	6ea73023          	sd	a0,1760(a4) # 1000 <freep>
      return (void*)(p + 1);
 928:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 92c:	70e2                	ld	ra,56(sp)
 92e:	7442                	ld	s0,48(sp)
 930:	74a2                	ld	s1,40(sp)
 932:	7902                	ld	s2,32(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 940:	6398                	ld	a4,0(a5)
 942:	e118                	sd	a4,0(a0)
 944:	bff1                	j	920 <malloc+0x86>
  hp->s.size = nu;
 946:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94a:	0541                	addi	a0,a0,16
 94c:	ec7ff0ef          	jal	ra,812 <free>
  return freep;
 950:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 954:	dd61                	beqz	a0,92c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 958:	4798                	lw	a4,8(a5)
 95a:	fa9778e3          	bgeu	a4,s1,90a <malloc+0x70>
    if(p == freep)
 95e:	00093703          	ld	a4,0(s2)
 962:	853e                	mv	a0,a5
 964:	fef719e3          	bne	a4,a5,956 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 968:	8552                	mv	a0,s4
 96a:	af5ff0ef          	jal	ra,45e <sbrk>
  if(p == (char*)-1)
 96e:	fd551ce3          	bne	a0,s5,946 <malloc+0xac>
        return 0;
 972:	4501                	li	a0,0
 974:	bf65                	j	92c <malloc+0x92>
