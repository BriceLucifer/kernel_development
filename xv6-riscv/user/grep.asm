
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	ra,4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	ra,0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	ra,4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	ra,4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	ra,4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	e862                	sd	s8,16(sp)
 11c:	e466                	sd	s9,8(sp)
 11e:	e06a                	sd	s10,0(sp)
 120:	1080                	addi	s0,sp,96
 122:	89aa                	mv	s3,a0
 124:	8bae                	mv	s7,a1
  m = 0;
 126:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 128:	3ff00c13          	li	s8,1023
 12c:	00001b17          	auipc	s6,0x1
 130:	ee4b0b13          	addi	s6,s6,-284 # 1010 <buf>
    p = buf;
 134:	8d5a                	mv	s10,s6
        *q = '\n';
 136:	4aa9                	li	s5,10
    p = buf;
 138:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13a:	a82d                	j	174 <grep+0x6e>
        *q = '\n';
 13c:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 140:	00148613          	addi	a2,s1,1
 144:	4126063b          	subw	a2,a2,s2
 148:	85ca                	mv	a1,s2
 14a:	4505                	li	a0,1
 14c:	3a6000ef          	jal	ra,4f2 <write>
      p = q+1;
 150:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 154:	45a9                	li	a1,10
 156:	854a                	mv	a0,s2
 158:	1b0000ef          	jal	ra,308 <strchr>
 15c:	84aa                	mv	s1,a0
 15e:	c909                	beqz	a0,170 <grep+0x6a>
      *q = 0;
 160:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 164:	85ca                	mv	a1,s2
 166:	854e                	mv	a0,s3
 168:	f59ff0ef          	jal	ra,c0 <match>
 16c:	d175                	beqz	a0,150 <grep+0x4a>
 16e:	b7f9                	j	13c <grep+0x36>
    if(m > 0){
 170:	03404363          	bgtz	s4,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 174:	414c063b          	subw	a2,s8,s4
 178:	014b05b3          	add	a1,s6,s4
 17c:	855e                	mv	a0,s7
 17e:	36c000ef          	jal	ra,4ea <read>
 182:	02a05463          	blez	a0,1aa <grep+0xa4>
    m += n;
 186:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 18a:	014b07b3          	add	a5,s6,s4
 18e:	00078023          	sb	zero,0(a5)
    p = buf;
 192:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 194:	b7c1                	j	154 <grep+0x4e>
      m -= p - buf;
 196:	416907b3          	sub	a5,s2,s6
 19a:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 19e:	8652                	mv	a2,s4
 1a0:	85ca                	mv	a1,s2
 1a2:	856a                	mv	a0,s10
 1a4:	27c000ef          	jal	ra,420 <memmove>
 1a8:	b7f1                	j	174 <grep+0x6e>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7139                	addi	sp,sp,-64
 1c8:	fc06                	sd	ra,56(sp)
 1ca:	f822                	sd	s0,48(sp)
 1cc:	f426                	sd	s1,40(sp)
 1ce:	f04a                	sd	s2,32(sp)
 1d0:	ec4e                	sd	s3,24(sp)
 1d2:	e852                	sd	s4,16(sp)
 1d4:	e456                	sd	s5,8(sp)
 1d6:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1d8:	4785                	li	a5,1
 1da:	04a7d663          	bge	a5,a0,226 <main+0x60>
  pattern = argv[1];
 1de:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e2:	4789                	li	a5,2
 1e4:	04a7db63          	bge	a5,a0,23a <main+0x74>
 1e8:	01058913          	addi	s2,a1,16
 1ec:	ffd5099b          	addiw	s3,a0,-3
 1f0:	1982                	slli	s3,s3,0x20
 1f2:	0209d993          	srli	s3,s3,0x20
 1f6:	098e                	slli	s3,s3,0x3
 1f8:	05e1                	addi	a1,a1,24
 1fa:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fc:	4581                	li	a1,0
 1fe:	00093503          	ld	a0,0(s2)
 202:	310000ef          	jal	ra,512 <open>
 206:	84aa                	mv	s1,a0
 208:	04054063          	bltz	a0,248 <main+0x82>
    grep(pattern, fd);
 20c:	85aa                	mv	a1,a0
 20e:	8552                	mv	a0,s4
 210:	ef7ff0ef          	jal	ra,106 <grep>
    close(fd);
 214:	8526                	mv	a0,s1
 216:	2e4000ef          	jal	ra,4fa <close>
  for(i = 2; i < argc; i++){
 21a:	0921                	addi	s2,s2,8
 21c:	ff3910e3          	bne	s2,s3,1fc <main+0x36>
  exit(0);
 220:	4501                	li	a0,0
 222:	2b0000ef          	jal	ra,4d2 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 226:	00001597          	auipc	a1,0x1
 22a:	85a58593          	addi	a1,a1,-1958 # a80 <malloc+0xea>
 22e:	4509                	li	a0,2
 230:	682000ef          	jal	ra,8b2 <fprintf>
    exit(1);
 234:	4505                	li	a0,1
 236:	29c000ef          	jal	ra,4d2 <exit>
    grep(pattern, 0);
 23a:	4581                	li	a1,0
 23c:	8552                	mv	a0,s4
 23e:	ec9ff0ef          	jal	ra,106 <grep>
    exit(0);
 242:	4501                	li	a0,0
 244:	28e000ef          	jal	ra,4d2 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 248:	00093583          	ld	a1,0(s2)
 24c:	00001517          	auipc	a0,0x1
 250:	85450513          	addi	a0,a0,-1964 # aa0 <malloc+0x10a>
 254:	688000ef          	jal	ra,8dc <printf>
      exit(1);
 258:	4505                	li	a0,1
 25a:	278000ef          	jal	ra,4d2 <exit>

000000000000025e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  extern int main();
  main();
 266:	f61ff0ef          	jal	ra,1c6 <main>
  exit(0);
 26a:	4501                	li	a0,0
 26c:	266000ef          	jal	ra,4d2 <exit>

0000000000000270 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 276:	87aa                	mv	a5,a0
 278:	0585                	addi	a1,a1,1
 27a:	0785                	addi	a5,a5,1
 27c:	fff5c703          	lbu	a4,-1(a1)
 280:	fee78fa3          	sb	a4,-1(a5)
 284:	fb75                	bnez	a4,278 <strcpy+0x8>
    ;
  return os;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	cb91                	beqz	a5,2aa <strcmp+0x1e>
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00f71763          	bne	a4,a5,2aa <strcmp+0x1e>
    p++, q++;
 2a0:	0505                	addi	a0,a0,1
 2a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbe5                	bnez	a5,298 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2aa:	0005c503          	lbu	a0,0(a1)
}
 2ae:	40a7853b          	subw	a0,a5,a0
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	cf91                	beqz	a5,2de <strlen+0x26>
 2c4:	0505                	addi	a0,a0,1
 2c6:	87aa                	mv	a5,a0
 2c8:	4685                	li	a3,1
 2ca:	9e89                	subw	a3,a3,a0
 2cc:	00f6853b          	addw	a0,a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	fb7d                	bnez	a4,2cc <strlen+0x14>
    ;
  return n;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  for(n = 0; s[n]; n++)
 2de:	4501                	li	a0,0
 2e0:	bfe5                	j	2d8 <strlen+0x20>

00000000000002e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e8:	ce09                	beqz	a2,302 <memset+0x20>
 2ea:	87aa                	mv	a5,a0
 2ec:	fff6071b          	addiw	a4,a2,-1
 2f0:	1702                	slli	a4,a4,0x20
 2f2:	9301                	srli	a4,a4,0x20
 2f4:	0705                	addi	a4,a4,1
 2f6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x16>
  }
  return dst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strchr>:

char*
strchr(const char *s, char c)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb99                	beqz	a5,328 <strchr+0x20>
    if(*s == c)
 314:	00f58763          	beq	a1,a5,322 <strchr+0x1a>
  for(; *s; s++)
 318:	0505                	addi	a0,a0,1
 31a:	00054783          	lbu	a5,0(a0)
 31e:	fbfd                	bnez	a5,314 <strchr+0xc>
      return (char*)s;
  return 0;
 320:	4501                	li	a0,0
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <strchr+0x1a>

000000000000032c <gets>:

char*
gets(char *buf, int max)
{
 32c:	711d                	addi	sp,sp,-96
 32e:	ec86                	sd	ra,88(sp)
 330:	e8a2                	sd	s0,80(sp)
 332:	e4a6                	sd	s1,72(sp)
 334:	e0ca                	sd	s2,64(sp)
 336:	fc4e                	sd	s3,56(sp)
 338:	f852                	sd	s4,48(sp)
 33a:	f456                	sd	s5,40(sp)
 33c:	f05a                	sd	s6,32(sp)
 33e:	ec5e                	sd	s7,24(sp)
 340:	1080                	addi	s0,sp,96
 342:	8baa                	mv	s7,a0
 344:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	892a                	mv	s2,a0
 348:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34a:	4aa9                	li	s5,10
 34c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34e:	89a6                	mv	s3,s1
 350:	2485                	addiw	s1,s1,1
 352:	0344d663          	bge	s1,s4,37e <gets+0x52>
    cc = read(0, &c, 1);
 356:	4605                	li	a2,1
 358:	faf40593          	addi	a1,s0,-81
 35c:	4501                	li	a0,0
 35e:	18c000ef          	jal	ra,4ea <read>
    if(cc < 1)
 362:	00a05e63          	blez	a0,37e <gets+0x52>
    buf[i++] = c;
 366:	faf44783          	lbu	a5,-81(s0)
 36a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36e:	01578763          	beq	a5,s5,37c <gets+0x50>
 372:	0905                	addi	s2,s2,1
 374:	fd679de3          	bne	a5,s6,34e <gets+0x22>
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	a011                	j	37e <gets+0x52>
 37c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37e:	99de                	add	s3,s3,s7
 380:	00098023          	sb	zero,0(s3)
  return buf;
}
 384:	855e                	mv	a0,s7
 386:	60e6                	ld	ra,88(sp)
 388:	6446                	ld	s0,80(sp)
 38a:	64a6                	ld	s1,72(sp)
 38c:	6906                	ld	s2,64(sp)
 38e:	79e2                	ld	s3,56(sp)
 390:	7a42                	ld	s4,48(sp)
 392:	7aa2                	ld	s5,40(sp)
 394:	7b02                	ld	s6,32(sp)
 396:	6be2                	ld	s7,24(sp)
 398:	6125                	addi	sp,sp,96
 39a:	8082                	ret

000000000000039c <stat>:

int
stat(const char *n, struct stat *st)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	e426                	sd	s1,8(sp)
 3a4:	e04a                	sd	s2,0(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3aa:	4581                	li	a1,0
 3ac:	166000ef          	jal	ra,512 <open>
  if(fd < 0)
 3b0:	02054163          	bltz	a0,3d2 <stat+0x36>
 3b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b6:	85ca                	mv	a1,s2
 3b8:	172000ef          	jal	ra,52a <fstat>
 3bc:	892a                	mv	s2,a0
  close(fd);
 3be:	8526                	mv	a0,s1
 3c0:	13a000ef          	jal	ra,4fa <close>
  return r;
}
 3c4:	854a                	mv	a0,s2
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	64a2                	ld	s1,8(sp)
 3cc:	6902                	ld	s2,0(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret
    return -1;
 3d2:	597d                	li	s2,-1
 3d4:	bfc5                	j	3c4 <stat+0x28>

00000000000003d6 <atoi>:

int
atoi(const char *s)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3dc:	00054603          	lbu	a2,0(a0)
 3e0:	fd06079b          	addiw	a5,a2,-48
 3e4:	0ff7f793          	andi	a5,a5,255
 3e8:	4725                	li	a4,9
 3ea:	02f76963          	bltu	a4,a5,41c <atoi+0x46>
 3ee:	86aa                	mv	a3,a0
  n = 0;
 3f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f4:	0685                	addi	a3,a3,1
 3f6:	0025179b          	slliw	a5,a0,0x2
 3fa:	9fa9                	addw	a5,a5,a0
 3fc:	0017979b          	slliw	a5,a5,0x1
 400:	9fb1                	addw	a5,a5,a2
 402:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 406:	0006c603          	lbu	a2,0(a3)
 40a:	fd06071b          	addiw	a4,a2,-48
 40e:	0ff77713          	andi	a4,a4,255
 412:	fee5f1e3          	bgeu	a1,a4,3f4 <atoi+0x1e>
  return n;
}
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
  n = 0;
 41c:	4501                	li	a0,0
 41e:	bfe5                	j	416 <atoi+0x40>

0000000000000420 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 426:	02b57663          	bgeu	a0,a1,452 <memmove+0x32>
    while(n-- > 0)
 42a:	02c05163          	blez	a2,44c <memmove+0x2c>
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	0785                	addi	a5,a5,1
 438:	97aa                	add	a5,a5,a0
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fee79ae3          	bne	a5,a4,43c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x2c>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x4a>
 47a:	bfc9                	j	44c <memmove+0x2c>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f63ff0ef          	jal	ra,420 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 572:	1101                	addi	sp,sp,-32
 574:	ec06                	sd	ra,24(sp)
 576:	e822                	sd	s0,16(sp)
 578:	1000                	addi	s0,sp,32
 57a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57e:	4605                	li	a2,1
 580:	fef40593          	addi	a1,s0,-17
 584:	f6fff0ef          	jal	ra,4f2 <write>
}
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	7139                	addi	sp,sp,-64
 592:	fc06                	sd	ra,56(sp)
 594:	f822                	sd	s0,48(sp)
 596:	f426                	sd	s1,40(sp)
 598:	f04a                	sd	s2,32(sp)
 59a:	ec4e                	sd	s3,24(sp)
 59c:	0080                	addi	s0,sp,64
 59e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a0:	c299                	beqz	a3,5a6 <printint+0x16>
 5a2:	0805c663          	bltz	a1,62e <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a6:	2581                	sext.w	a1,a1
  neg = 0;
 5a8:	4881                	li	a7,0
 5aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b0:	2601                	sext.w	a2,a2
 5b2:	00000517          	auipc	a0,0x0
 5b6:	50e50513          	addi	a0,a0,1294 # ac0 <digits>
 5ba:	883a                	mv	a6,a4
 5bc:	2705                	addiw	a4,a4,1
 5be:	02c5f7bb          	remuw	a5,a1,a2
 5c2:	1782                	slli	a5,a5,0x20
 5c4:	9381                	srli	a5,a5,0x20
 5c6:	97aa                	add	a5,a5,a0
 5c8:	0007c783          	lbu	a5,0(a5)
 5cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d0:	0005879b          	sext.w	a5,a1
 5d4:	02c5d5bb          	divuw	a1,a1,a2
 5d8:	0685                	addi	a3,a3,1
 5da:	fec7f0e3          	bgeu	a5,a2,5ba <printint+0x2a>
  if(neg)
 5de:	00088b63          	beqz	a7,5f4 <printint+0x64>
    buf[i++] = '-';
 5e2:	fd040793          	addi	a5,s0,-48
 5e6:	973e                	add	a4,a4,a5
 5e8:	02d00793          	li	a5,45
 5ec:	fef70823          	sb	a5,-16(a4)
 5f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f4:	02e05663          	blez	a4,620 <printint+0x90>
 5f8:	fc040793          	addi	a5,s0,-64
 5fc:	00e78933          	add	s2,a5,a4
 600:	fff78993          	addi	s3,a5,-1
 604:	99ba                	add	s3,s3,a4
 606:	377d                	addiw	a4,a4,-1
 608:	1702                	slli	a4,a4,0x20
 60a:	9301                	srli	a4,a4,0x20
 60c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 610:	fff94583          	lbu	a1,-1(s2)
 614:	8526                	mv	a0,s1
 616:	f5dff0ef          	jal	ra,572 <putc>
  while(--i >= 0)
 61a:	197d                	addi	s2,s2,-1
 61c:	ff391ae3          	bne	s2,s3,610 <printint+0x80>
}
 620:	70e2                	ld	ra,56(sp)
 622:	7442                	ld	s0,48(sp)
 624:	74a2                	ld	s1,40(sp)
 626:	7902                	ld	s2,32(sp)
 628:	69e2                	ld	s3,24(sp)
 62a:	6121                	addi	sp,sp,64
 62c:	8082                	ret
    x = -xx;
 62e:	40b005bb          	negw	a1,a1
    neg = 1;
 632:	4885                	li	a7,1
    x = -xx;
 634:	bf9d                	j	5aa <printint+0x1a>

0000000000000636 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 636:	7119                	addi	sp,sp,-128
 638:	fc86                	sd	ra,120(sp)
 63a:	f8a2                	sd	s0,112(sp)
 63c:	f4a6                	sd	s1,104(sp)
 63e:	f0ca                	sd	s2,96(sp)
 640:	ecce                	sd	s3,88(sp)
 642:	e8d2                	sd	s4,80(sp)
 644:	e4d6                	sd	s5,72(sp)
 646:	e0da                	sd	s6,64(sp)
 648:	fc5e                	sd	s7,56(sp)
 64a:	f862                	sd	s8,48(sp)
 64c:	f466                	sd	s9,40(sp)
 64e:	f06a                	sd	s10,32(sp)
 650:	ec6e                	sd	s11,24(sp)
 652:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 654:	0005c903          	lbu	s2,0(a1)
 658:	22090e63          	beqz	s2,894 <vprintf+0x25e>
 65c:	8b2a                	mv	s6,a0
 65e:	8a2e                	mv	s4,a1
 660:	8bb2                	mv	s7,a2
  state = 0;
 662:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 664:	4481                	li	s1,0
 666:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 668:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 66c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 670:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 674:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 678:	00000c97          	auipc	s9,0x0
 67c:	448c8c93          	addi	s9,s9,1096 # ac0 <digits>
 680:	a005                	j	6a0 <vprintf+0x6a>
        putc(fd, c0);
 682:	85ca                	mv	a1,s2
 684:	855a                	mv	a0,s6
 686:	eedff0ef          	jal	ra,572 <putc>
 68a:	a019                	j	690 <vprintf+0x5a>
    } else if(state == '%'){
 68c:	03598263          	beq	s3,s5,6b0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 690:	2485                	addiw	s1,s1,1
 692:	8726                	mv	a4,s1
 694:	009a07b3          	add	a5,s4,s1
 698:	0007c903          	lbu	s2,0(a5)
 69c:	1e090c63          	beqz	s2,894 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 6a0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a4:	fe0994e3          	bnez	s3,68c <vprintf+0x56>
      if(c0 == '%'){
 6a8:	fd579de3          	bne	a5,s5,682 <vprintf+0x4c>
        state = '%';
 6ac:	89be                	mv	s3,a5
 6ae:	b7cd                	j	690 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6b0:	cfa5                	beqz	a5,728 <vprintf+0xf2>
 6b2:	00ea06b3          	add	a3,s4,a4
 6b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6bc:	c681                	beqz	a3,6c4 <vprintf+0x8e>
 6be:	9752                	add	a4,a4,s4
 6c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6c4:	03878a63          	beq	a5,s8,6f8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	05a78463          	beq	a5,s10,710 <vprintf+0xda>
      } else if(c0 == 'u'){
 6cc:	0db78763          	beq	a5,s11,79a <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6d0:	07800713          	li	a4,120
 6d4:	10e78963          	beq	a5,a4,7e6 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6d8:	07000713          	li	a4,112
 6dc:	12e78e63          	beq	a5,a4,818 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6e0:	07300713          	li	a4,115
 6e4:	16e78b63          	beq	a5,a4,85a <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6e8:	05579063          	bne	a5,s5,728 <vprintf+0xf2>
        putc(fd, '%');
 6ec:	85d6                	mv	a1,s5
 6ee:	855a                	mv	a0,s6
 6f0:	e83ff0ef          	jal	ra,572 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bf69                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e8bff0ef          	jal	ra,590 <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b749                	j	690 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	03868663          	beq	a3,s8,73c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 714:	05a68163          	beq	a3,s10,756 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 718:	09b68d63          	beq	a3,s11,7b2 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71c:	03a68f63          	beq	a3,s10,75a <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 720:	07800793          	li	a5,120
 724:	0cf68d63          	beq	a3,a5,7fe <vprintf+0x1c8>
        putc(fd, '%');
 728:	85d6                	mv	a1,s5
 72a:	855a                	mv	a0,s6
 72c:	e47ff0ef          	jal	ra,572 <putc>
        putc(fd, c0);
 730:	85ca                	mv	a1,s2
 732:	855a                	mv	a0,s6
 734:	e3fff0ef          	jal	ra,572 <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf99                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73c:	008b8913          	addi	s2,s7,8
 740:	4685                	li	a3,1
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	e47ff0ef          	jal	ra,590 <printint>
        i += 1;
 74e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
        i += 1;
 754:	bf35                	j	690 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 756:	03860563          	beq	a2,s8,780 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 75a:	07b60963          	beq	a2,s11,7cc <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 75e:	07800793          	li	a5,120
 762:	fcf613e3          	bne	a2,a5,728 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8913          	addi	s2,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000ba583          	lw	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	e1dff0ef          	jal	ra,590 <printint>
        i += 2;
 778:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 2;
 77e:	bf09                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 780:	008b8913          	addi	s2,s7,8
 784:	4685                	li	a3,1
 786:	4629                	li	a2,10
 788:	000ba583          	lw	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	e03ff0ef          	jal	ra,590 <printint>
        i += 2;
 792:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
        i += 2;
 798:	bde5                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	de9ff0ef          	jal	ra,590 <printint>
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b5c5                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b2:	008b8913          	addi	s2,s7,8
 7b6:	4681                	li	a3,0
 7b8:	4629                	li	a2,10
 7ba:	000ba583          	lw	a1,0(s7)
 7be:	855a                	mv	a0,s6
 7c0:	dd1ff0ef          	jal	ra,590 <printint>
        i += 1;
 7c4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
        i += 1;
 7ca:	b5d9                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4629                	li	a2,10
 7d4:	000ba583          	lw	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	db7ff0ef          	jal	ra,590 <printint>
        i += 2;
 7de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
        i += 2;
 7e4:	b575                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	d9dff0ef          	jal	ra,590 <printint>
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bd51                	j	690 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4641                	li	a2,16
 806:	000ba583          	lw	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	d85ff0ef          	jal	ra,590 <printint>
        i += 1;
 810:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 812:	8bca                	mv	s7,s2
      state = 0;
 814:	4981                	li	s3,0
        i += 1;
 816:	bdad                	j	690 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 818:	008b8793          	addi	a5,s7,8
 81c:	f8f43423          	sd	a5,-120(s0)
 820:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 824:	03000593          	li	a1,48
 828:	855a                	mv	a0,s6
 82a:	d49ff0ef          	jal	ra,572 <putc>
  putc(fd, 'x');
 82e:	07800593          	li	a1,120
 832:	855a                	mv	a0,s6
 834:	d3fff0ef          	jal	ra,572 <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	03c9d793          	srli	a5,s3,0x3c
 83e:	97e6                	add	a5,a5,s9
 840:	0007c583          	lbu	a1,0(a5)
 844:	855a                	mv	a0,s6
 846:	d2dff0ef          	jal	ra,572 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84a:	0992                	slli	s3,s3,0x4
 84c:	397d                	addiw	s2,s2,-1
 84e:	fe0916e3          	bnez	s2,83a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 852:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 856:	4981                	li	s3,0
 858:	bd25                	j	690 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 85a:	008b8993          	addi	s3,s7,8
 85e:	000bb903          	ld	s2,0(s7)
 862:	00090f63          	beqz	s2,880 <vprintf+0x24a>
        for(; *s; s++)
 866:	00094583          	lbu	a1,0(s2)
 86a:	c195                	beqz	a1,88e <vprintf+0x258>
          putc(fd, *s);
 86c:	855a                	mv	a0,s6
 86e:	d05ff0ef          	jal	ra,572 <putc>
        for(; *s; s++)
 872:	0905                	addi	s2,s2,1
 874:	00094583          	lbu	a1,0(s2)
 878:	f9f5                	bnez	a1,86c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 87a:	8bce                	mv	s7,s3
      state = 0;
 87c:	4981                	li	s3,0
 87e:	bd09                	j	690 <vprintf+0x5a>
          s = "(null)";
 880:	00000917          	auipc	s2,0x0
 884:	23890913          	addi	s2,s2,568 # ab8 <malloc+0x122>
        for(; *s; s++)
 888:	02800593          	li	a1,40
 88c:	b7c5                	j	86c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 88e:	8bce                	mv	s7,s3
      state = 0;
 890:	4981                	li	s3,0
 892:	bbfd                	j	690 <vprintf+0x5a>
    }
  }
}
 894:	70e6                	ld	ra,120(sp)
 896:	7446                	ld	s0,112(sp)
 898:	74a6                	ld	s1,104(sp)
 89a:	7906                	ld	s2,96(sp)
 89c:	69e6                	ld	s3,88(sp)
 89e:	6a46                	ld	s4,80(sp)
 8a0:	6aa6                	ld	s5,72(sp)
 8a2:	6b06                	ld	s6,64(sp)
 8a4:	7be2                	ld	s7,56(sp)
 8a6:	7c42                	ld	s8,48(sp)
 8a8:	7ca2                	ld	s9,40(sp)
 8aa:	7d02                	ld	s10,32(sp)
 8ac:	6de2                	ld	s11,24(sp)
 8ae:	6109                	addi	sp,sp,128
 8b0:	8082                	ret

00000000000008b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b2:	715d                	addi	sp,sp,-80
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e010                	sd	a2,0(s0)
 8bc:	e414                	sd	a3,8(s0)
 8be:	e818                	sd	a4,16(s0)
 8c0:	ec1c                	sd	a5,24(s0)
 8c2:	03043023          	sd	a6,32(s0)
 8c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ce:	8622                	mv	a2,s0
 8d0:	d67ff0ef          	jal	ra,636 <vprintf>
}
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6161                	addi	sp,sp,80
 8da:	8082                	ret

00000000000008dc <printf>:

void
printf(const char *fmt, ...)
{
 8dc:	711d                	addi	sp,sp,-96
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	e40c                	sd	a1,8(s0)
 8e6:	e810                	sd	a2,16(s0)
 8e8:	ec14                	sd	a3,24(s0)
 8ea:	f018                	sd	a4,32(s0)
 8ec:	f41c                	sd	a5,40(s0)
 8ee:	03043823          	sd	a6,48(s0)
 8f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f6:	00840613          	addi	a2,s0,8
 8fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fe:	85aa                	mv	a1,a0
 900:	4505                	li	a0,1
 902:	d35ff0ef          	jal	ra,636 <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6125                	addi	sp,sp,96
 90c:	8082                	ret

000000000000090e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90e:	1141                	addi	sp,sp,-16
 910:	e422                	sd	s0,8(sp)
 912:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 914:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 918:	00000797          	auipc	a5,0x0
 91c:	6e87b783          	ld	a5,1768(a5) # 1000 <freep>
 920:	a805                	j	950 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 922:	4618                	lw	a4,8(a2)
 924:	9db9                	addw	a1,a1,a4
 926:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 92a:	6398                	ld	a4,0(a5)
 92c:	6318                	ld	a4,0(a4)
 92e:	fee53823          	sd	a4,-16(a0)
 932:	a091                	j	976 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 934:	ff852703          	lw	a4,-8(a0)
 938:	9e39                	addw	a2,a2,a4
 93a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 93c:	ff053703          	ld	a4,-16(a0)
 940:	e398                	sd	a4,0(a5)
 942:	a099                	j	988 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	6398                	ld	a4,0(a5)
 946:	00e7e463          	bltu	a5,a4,94e <free+0x40>
 94a:	00e6ea63          	bltu	a3,a4,95e <free+0x50>
{
 94e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	fed7fae3          	bgeu	a5,a3,944 <free+0x36>
 954:	6398                	ld	a4,0(a5)
 956:	00e6e463          	bltu	a3,a4,95e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	fee7eae3          	bltu	a5,a4,94e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 95e:	ff852583          	lw	a1,-8(a0)
 962:	6390                	ld	a2,0(a5)
 964:	02059713          	slli	a4,a1,0x20
 968:	9301                	srli	a4,a4,0x20
 96a:	0712                	slli	a4,a4,0x4
 96c:	9736                	add	a4,a4,a3
 96e:	fae60ae3          	beq	a2,a4,922 <free+0x14>
    bp->s.ptr = p->s.ptr;
 972:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 976:	4790                	lw	a2,8(a5)
 978:	02061713          	slli	a4,a2,0x20
 97c:	9301                	srli	a4,a4,0x20
 97e:	0712                	slli	a4,a4,0x4
 980:	973e                	add	a4,a4,a5
 982:	fae689e3          	beq	a3,a4,934 <free+0x26>
  } else
    p->s.ptr = bp;
 986:	e394                	sd	a3,0(a5)
  freep = p;
 988:	00000717          	auipc	a4,0x0
 98c:	66f73c23          	sd	a5,1656(a4) # 1000 <freep>
}
 990:	6422                	ld	s0,8(sp)
 992:	0141                	addi	sp,sp,16
 994:	8082                	ret

0000000000000996 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 996:	7139                	addi	sp,sp,-64
 998:	fc06                	sd	ra,56(sp)
 99a:	f822                	sd	s0,48(sp)
 99c:	f426                	sd	s1,40(sp)
 99e:	f04a                	sd	s2,32(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
 9a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9aa:	02051493          	slli	s1,a0,0x20
 9ae:	9081                	srli	s1,s1,0x20
 9b0:	04bd                	addi	s1,s1,15
 9b2:	8091                	srli	s1,s1,0x4
 9b4:	0014899b          	addiw	s3,s1,1
 9b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ba:	00000517          	auipc	a0,0x0
 9be:	64653503          	ld	a0,1606(a0) # 1000 <freep>
 9c2:	c515                	beqz	a0,9ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	02977f63          	bgeu	a4,s1,a06 <malloc+0x70>
 9cc:	8a4e                	mv	s4,s3
 9ce:	0009871b          	sext.w	a4,s3
 9d2:	6685                	lui	a3,0x1
 9d4:	00d77363          	bgeu	a4,a3,9da <malloc+0x44>
 9d8:	6a05                	lui	s4,0x1
 9da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e2:	00000917          	auipc	s2,0x0
 9e6:	61e90913          	addi	s2,s2,1566 # 1000 <freep>
  if(p == (char*)-1)
 9ea:	5afd                	li	s5,-1
 9ec:	a0bd                	j	a5a <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 9ee:	00001797          	auipc	a5,0x1
 9f2:	a2278793          	addi	a5,a5,-1502 # 1410 <base>
 9f6:	00000717          	auipc	a4,0x0
 9fa:	60f73523          	sd	a5,1546(a4) # 1000 <freep>
 9fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a00:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a04:	b7e1                	j	9cc <malloc+0x36>
      if(p->s.size == nunits)
 a06:	02e48b63          	beq	s1,a4,a3c <malloc+0xa6>
        p->s.size -= nunits;
 a0a:	4137073b          	subw	a4,a4,s3
 a0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a10:	1702                	slli	a4,a4,0x20
 a12:	9301                	srli	a4,a4,0x20
 a14:	0712                	slli	a4,a4,0x4
 a16:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a18:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1c:	00000717          	auipc	a4,0x0
 a20:	5ea73223          	sd	a0,1508(a4) # 1000 <freep>
      return (void*)(p + 1);
 a24:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a28:	70e2                	ld	ra,56(sp)
 a2a:	7442                	ld	s0,48(sp)
 a2c:	74a2                	ld	s1,40(sp)
 a2e:	7902                	ld	s2,32(sp)
 a30:	69e2                	ld	s3,24(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
 a38:	6121                	addi	sp,sp,64
 a3a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a3c:	6398                	ld	a4,0(a5)
 a3e:	e118                	sd	a4,0(a0)
 a40:	bff1                	j	a1c <malloc+0x86>
  hp->s.size = nu;
 a42:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a46:	0541                	addi	a0,a0,16
 a48:	ec7ff0ef          	jal	ra,90e <free>
  return freep;
 a4c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a50:	dd61                	beqz	a0,a28 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a52:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a54:	4798                	lw	a4,8(a5)
 a56:	fa9778e3          	bgeu	a4,s1,a06 <malloc+0x70>
    if(p == freep)
 a5a:	00093703          	ld	a4,0(s2)
 a5e:	853e                	mv	a0,a5
 a60:	fef719e3          	bne	a4,a5,a52 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a64:	8552                	mv	a0,s4
 a66:	af5ff0ef          	jal	ra,55a <sbrk>
  if(p == (char*)-1)
 a6a:	fd551ce3          	bne	a0,s5,a42 <malloc+0xac>
        return 0;
 a6e:	4501                	li	a0,0
 a70:	bf65                	j	a28 <malloc+0x92>
