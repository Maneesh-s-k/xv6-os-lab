
user/_top:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

//-----------------------------------------------------------

static char* states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};

int main(void) {
   0:	8a010113          	addi	sp,sp,-1888
   4:	74113c23          	sd	ra,1880(sp)
   8:	74813823          	sd	s0,1872(sp)
   c:	74913423          	sd	s1,1864(sp)
  10:	75213023          	sd	s2,1856(sp)
  14:	73313c23          	sd	s3,1848(sp)
  18:	73413823          	sd	s4,1840(sp)
  1c:	73513423          	sd	s5,1832(sp)
  20:	73613023          	sd	s6,1824(sp)
  24:	71713c23          	sd	s7,1816(sp)
  28:	71813823          	sd	s8,1808(sp)
  2c:	71913423          	sd	s9,1800(sp)
  30:	76010413          	addi	s0,sp,1888
    
    
    while (1) {
    struct proc_info pinfo[MAX_PROC];
    int n = getprocs(pinfo, MAX_PROC);
  34:	8a040c93          	addi	s9,s0,-1888
  38:	04000c13          	li	s8,64
    printf("PID\tSTATE\t\tTICKS\tNAME\n");
  3c:	00001b97          	auipc	s7,0x1
  40:	8ecb8b93          	addi	s7,s7,-1812 # 928 <malloc+0x106>
    for (int i = 0; i < n; i++) {
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  44:	00001a97          	auipc	s5,0x1
  48:	8dca8a93          	addi	s5,s5,-1828 # 920 <malloc+0xfe>
  4c:	00001b17          	auipc	s6,0x1
  50:	954b0b13          	addi	s6,s6,-1708 # 9a0 <states>
  54:	a835                	j	90 <main+0x90>
        printf("%d\t%s\t%d\t%s\n", pinfo[i].pid, state, pinfo[i].ticks, pinfo[i].name);
  56:	ffc72683          	lw	a3,-4(a4)
  5a:	ff472583          	lw	a1,-12(a4)
  5e:	854e                	mv	a0,s3
  60:	70a000ef          	jal	76a <printf>
    for (int i = 0; i < n; i++) {
  64:	04f1                	addi	s1,s1,28
  66:	01248c63          	beq	s1,s2,7e <main+0x7e>
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  6a:	8726                	mv	a4,s1
  6c:	ff84a783          	lw	a5,-8(s1)
  70:	8656                	mv	a2,s5
  72:	fefa62e3          	bltu	s4,a5,56 <main+0x56>
  76:	078e                	slli	a5,a5,0x3
  78:	97da                	add	a5,a5,s6
  7a:	6390                	ld	a2,0(a5)
  7c:	bfe9                	j	56 <main+0x56>
    }
    sleep(20);                  // sleep for 200 ticks (~2 seconds)
  7e:	4551                	li	a0,20
  80:	36e000ef          	jal	3ee <sleep>
    printf("\033[2J\033[H");   // clear screen and move cursor home
  84:	00001517          	auipc	a0,0x1
  88:	8cc50513          	addi	a0,a0,-1844 # 950 <malloc+0x12e>
  8c:	6de000ef          	jal	76a <printf>
    int n = getprocs(pinfo, MAX_PROC);
  90:	85e2                	mv	a1,s8
  92:	8566                	mv	a0,s9
  94:	36a000ef          	jal	3fe <getprocs>
  98:	89aa                	mv	s3,a0
    printf("PID\tSTATE\t\tTICKS\tNAME\n");
  9a:	855e                	mv	a0,s7
  9c:	6ce000ef          	jal	76a <printf>
    for (int i = 0; i < n; i++) {
  a0:	fd305fe3          	blez	s3,7e <main+0x7e>
  a4:	8ac40493          	addi	s1,s0,-1876
  a8:	00399913          	slli	s2,s3,0x3
  ac:	41390933          	sub	s2,s2,s3
  b0:	090a                	slli	s2,s2,0x2
  b2:	9926                	add	s2,s2,s1
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
  b4:	4a15                	li	s4,5
        printf("%d\t%s\t%d\t%s\n", pinfo[i].pid, state, pinfo[i].ticks, pinfo[i].name);
  b6:	00001997          	auipc	s3,0x1
  ba:	88a98993          	addi	s3,s3,-1910 # 940 <malloc+0x11e>
  be:	b775                	j	6a <main+0x6a>

00000000000000c0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c8:	f39ff0ef          	jal	0 <main>
  exit(0);
  cc:	4501                	li	a0,0
  ce:	290000ef          	jal	35e <exit>

00000000000000d2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0xa>
    ;
  return os;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x20>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x20>
    p++, q++;
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf99                	beqz	a5,14c <strlen+0x2a>
 130:	0505                	addi	a0,a0,1
 132:	87aa                	mv	a5,a0
 134:	86be                	mv	a3,a5
 136:	0785                	addi	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	ff65                	bnez	a4,134 <strlen+0x12>
 13e:	40a6853b          	subw	a0,a3,a0
 142:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  for(n = 0; s[n]; n++)
 14c:	4501                	li	a0,0
 14e:	bfdd                	j	144 <strlen+0x22>

0000000000000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 158:	ca19                	beqz	a2,16e <memset+0x1e>
 15a:	87aa                	mv	a5,a0
 15c:	1602                	slli	a2,a2,0x20
 15e:	9201                	srli	a2,a2,0x20
 160:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 164:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 168:	0785                	addi	a5,a5,1
 16a:	fee79de3          	bne	a5,a4,164 <memset+0x14>
  }
  return dst;
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strchr>:

char*
strchr(const char *s, char c)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf81                	beqz	a5,19a <strchr+0x24>
    if(*s == c)
 184:	00f58763          	beq	a1,a5,192 <strchr+0x1c>
  for(; *s; s++)
 188:	0505                	addi	a0,a0,1
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbfd                	bnez	a5,184 <strchr+0xe>
      return (char*)s;
  return 0;
 190:	4501                	li	a0,0
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret
  return 0;
 19a:	4501                	li	a0,0
 19c:	bfdd                	j	192 <strchr+0x1c>

000000000000019e <gets>:

char*
gets(char *buf, int max)
{
 19e:	7159                	addi	sp,sp,-112
 1a0:	f486                	sd	ra,104(sp)
 1a2:	f0a2                	sd	s0,96(sp)
 1a4:	eca6                	sd	s1,88(sp)
 1a6:	e8ca                	sd	s2,80(sp)
 1a8:	e4ce                	sd	s3,72(sp)
 1aa:	e0d2                	sd	s4,64(sp)
 1ac:	fc56                	sd	s5,56(sp)
 1ae:	f85a                	sd	s6,48(sp)
 1b0:	f45e                	sd	s7,40(sp)
 1b2:	f062                	sd	s8,32(sp)
 1b4:	ec66                	sd	s9,24(sp)
 1b6:	e86a                	sd	s10,16(sp)
 1b8:	1880                	addi	s0,sp,112
 1ba:	8caa                	mv	s9,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c2:	f9f40b13          	addi	s6,s0,-97
 1c6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c8:	4ba9                	li	s7,10
 1ca:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1cc:	8d26                	mv	s10,s1
 1ce:	0014899b          	addiw	s3,s1,1
 1d2:	84ce                	mv	s1,s3
 1d4:	0349d563          	bge	s3,s4,1fe <gets+0x60>
    cc = read(0, &c, 1);
 1d8:	8656                	mv	a2,s5
 1da:	85da                	mv	a1,s6
 1dc:	4501                	li	a0,0
 1de:	198000ef          	jal	376 <read>
    if(cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <gets+0x60>
    buf[i++] = c;
 1e6:	f9f44783          	lbu	a5,-97(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	01778763          	beq	a5,s7,1fc <gets+0x5e>
 1f2:	0905                	addi	s2,s2,1
 1f4:	fd879ce3          	bne	a5,s8,1cc <gets+0x2e>
    buf[i++] = c;
 1f8:	8d4e                	mv	s10,s3
 1fa:	a011                	j	1fe <gets+0x60>
 1fc:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1fe:	9d66                	add	s10,s10,s9
 200:	000d0023          	sb	zero,0(s10)
  return buf;
}
 204:	8566                	mv	a0,s9
 206:	70a6                	ld	ra,104(sp)
 208:	7406                	ld	s0,96(sp)
 20a:	64e6                	ld	s1,88(sp)
 20c:	6946                	ld	s2,80(sp)
 20e:	69a6                	ld	s3,72(sp)
 210:	6a06                	ld	s4,64(sp)
 212:	7ae2                	ld	s5,56(sp)
 214:	7b42                	ld	s6,48(sp)
 216:	7ba2                	ld	s7,40(sp)
 218:	7c02                	ld	s8,32(sp)
 21a:	6ce2                	ld	s9,24(sp)
 21c:	6d42                	ld	s10,16(sp)
 21e:	6165                	addi	sp,sp,112
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	16e000ef          	jal	39e <open>
  if(fd < 0)
 234:	02054263          	bltz	a0,258 <stat+0x36>
 238:	e426                	sd	s1,8(sp)
 23a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23c:	85ca                	mv	a1,s2
 23e:	178000ef          	jal	3b6 <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	140000ef          	jal	386 <close>
  return r;
 24a:	64a2                	ld	s1,8(sp)
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	597d                	li	s2,-1
 25a:	bfcd                	j	24c <stat+0x2a>

000000000000025c <atoi>:

int
atoi(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	00054683          	lbu	a3,0(a0)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	4625                	li	a2,9
 272:	02f66963          	bltu	a2,a5,2a4 <atoi+0x48>
 276:	872a                	mv	a4,a0
  n = 0;
 278:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27a:	0705                	addi	a4,a4,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb5                	addw	a5,a5,a3
 288:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28c:	00074683          	lbu	a3,0(a4)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	fef671e3          	bgeu	a2,a5,27a <atoi+0x1e>
  return n;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <atoi+0x40>

00000000000002a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57563          	bgeu	a0,a1,2da <memmove+0x32>
    while(n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x2a>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ce:	fee79ae3          	bne	a5,a4,2c2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    dst += n;
 2da:	00c50733          	add	a4,a0,a2
    src += n;
 2de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e0:	fec059e3          	blez	a2,2d2 <memmove+0x2a>
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
 2fe:	fef71ae3          	bne	a4,a5,2f2 <memmove+0x4a>
 302:	bfc1                	j	2d2 <memmove+0x2a>

0000000000000304 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30c:	ca0d                	beqz	a2,33e <memcmp+0x3a>
 30e:	fff6069b          	addiw	a3,a2,-1
 312:	1682                	slli	a3,a3,0x20
 314:	9281                	srli	a3,a3,0x20
 316:	0685                	addi	a3,a3,1
 318:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00e79863          	bne	a5,a4,332 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 326:	0505                	addi	a0,a0,1
    p2++;
 328:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32a:	fed518e3          	bne	a0,a3,31a <memcmp+0x16>
  }
  return 0;
 32e:	4501                	li	a0,0
 330:	a019                	j	336 <memcmp+0x32>
      return *p1 - *p2;
 332:	40e7853b          	subw	a0,a5,a4
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <memcmp+0x32>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	f5fff0ef          	jal	2a8 <memmove>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 356:	4885                	li	a7,1
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <exit>:
.global exit
exit:
 li a7, SYS_exit
 35e:	4889                	li	a7,2
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <wait>:
.global wait
wait:
 li a7, SYS_wait
 366:	488d                	li	a7,3
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36e:	4891                	li	a7,4
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <read>:
.global read
read:
 li a7, SYS_read
 376:	4895                	li	a7,5
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <write>:
.global write
write:
 li a7, SYS_write
 37e:	48c1                	li	a7,16
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <close>:
.global close
close:
 li a7, SYS_close
 386:	48d5                	li	a7,21
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <kill>:
.global kill
kill:
 li a7, SYS_kill
 38e:	4899                	li	a7,6
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exec>:
.global exec
exec:
 li a7, SYS_exec
 396:	489d                	li	a7,7
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <open>:
.global open
open:
 li a7, SYS_open
 39e:	48bd                	li	a7,15
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a6:	48c5                	li	a7,17
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ae:	48c9                	li	a7,18
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b6:	48a1                	li	a7,8
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <link>:
.global link
link:
 li a7, SYS_link
 3be:	48cd                	li	a7,19
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c6:	48d1                	li	a7,20
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ce:	48a5                	li	a7,9
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d6:	48a9                	li	a7,10
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3de:	48ad                	li	a7,11
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e6:	48b1                	li	a7,12
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ee:	48b5                	li	a7,13
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f6:	48b9                	li	a7,14
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3fe:	48d9                	li	a7,22
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	f67ff0ef          	jal	37e <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 424:	715d                	addi	sp,sp,-80
 426:	e486                	sd	ra,72(sp)
 428:	e0a2                	sd	s0,64(sp)
 42a:	fc26                	sd	s1,56(sp)
 42c:	f84a                	sd	s2,48(sp)
 42e:	f44e                	sd	s3,40(sp)
 430:	0880                	addi	s0,sp,80
 432:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 434:	c299                	beqz	a3,43a <printint+0x16>
 436:	0605cf63          	bltz	a1,4b4 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43a:	2581                	sext.w	a1,a1
  neg = 0;
 43c:	4e01                	li	t3,0
  }

  i = 0;
 43e:	fb840313          	addi	t1,s0,-72
  neg = 0;
 442:	869a                	mv	a3,t1
  i = 0;
 444:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 446:	00000817          	auipc	a6,0x0
 44a:	58a80813          	addi	a6,a6,1418 # 9d0 <digits>
 44e:	88be                	mv	a7,a5
 450:	0017851b          	addiw	a0,a5,1
 454:	87aa                	mv	a5,a0
 456:	02c5f73b          	remuw	a4,a1,a2
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	9742                	add	a4,a4,a6
 460:	00074703          	lbu	a4,0(a4)
 464:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 468:	872e                	mv	a4,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fcc77fe3          	bgeu	a4,a2,44e <printint+0x2a>
  if(neg)
 474:	000e0c63          	beqz	t3,48c <printint+0x68>
    buf[i++] = '-';
 478:	fd050793          	addi	a5,a0,-48
 47c:	00878533          	add	a0,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef50423          	sb	a5,-24(a0)
 488:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 48c:	fff7899b          	addiw	s3,a5,-1
 490:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 494:	fff4c583          	lbu	a1,-1(s1)
 498:	854a                	mv	a0,s2
 49a:	f6dff0ef          	jal	406 <putc>
  while(--i >= 0)
 49e:	39fd                	addiw	s3,s3,-1
 4a0:	14fd                	addi	s1,s1,-1
 4a2:	fe09d9e3          	bgez	s3,494 <printint+0x70>
}
 4a6:	60a6                	ld	ra,72(sp)
 4a8:	6406                	ld	s0,64(sp)
 4aa:	74e2                	ld	s1,56(sp)
 4ac:	7942                	ld	s2,48(sp)
 4ae:	79a2                	ld	s3,40(sp)
 4b0:	6161                	addi	sp,sp,80
 4b2:	8082                	ret
    x = -xx;
 4b4:	40b005bb          	negw	a1,a1
    neg = 1;
 4b8:	4e05                	li	t3,1
    x = -xx;
 4ba:	b751                	j	43e <printint+0x1a>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	711d                	addi	sp,sp,-96
 4be:	ec86                	sd	ra,88(sp)
 4c0:	e8a2                	sd	s0,80(sp)
 4c2:	e4a6                	sd	s1,72(sp)
 4c4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c6:	0005c483          	lbu	s1,0(a1)
 4ca:	26048663          	beqz	s1,736 <vprintf+0x27a>
 4ce:	e0ca                	sd	s2,64(sp)
 4d0:	fc4e                	sd	s3,56(sp)
 4d2:	f852                	sd	s4,48(sp)
 4d4:	f456                	sd	s5,40(sp)
 4d6:	f05a                	sd	s6,32(sp)
 4d8:	ec5e                	sd	s7,24(sp)
 4da:	e862                	sd	s8,16(sp)
 4dc:	e466                	sd	s9,8(sp)
 4de:	8b2a                	mv	s6,a0
 4e0:	8a2e                	mv	s4,a1
 4e2:	8bb2                	mv	s7,a2
  state = 0;
 4e4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e6:	4901                	li	s2,0
 4e8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ea:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f2:	06c00c93          	li	s9,108
 4f6:	a00d                	j	518 <vprintf+0x5c>
        putc(fd, c0);
 4f8:	85a6                	mv	a1,s1
 4fa:	855a                	mv	a0,s6
 4fc:	f0bff0ef          	jal	406 <putc>
 500:	a019                	j	506 <vprintf+0x4a>
    } else if(state == '%'){
 502:	03598363          	beq	s3,s5,528 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 506:	0019079b          	addiw	a5,s2,1
 50a:	893e                	mv	s2,a5
 50c:	873e                	mv	a4,a5
 50e:	97d2                	add	a5,a5,s4
 510:	0007c483          	lbu	s1,0(a5)
 514:	20048963          	beqz	s1,726 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 518:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51c:	fe0993e3          	bnez	s3,502 <vprintf+0x46>
      if(c0 == '%'){
 520:	fd579ce3          	bne	a5,s5,4f8 <vprintf+0x3c>
        state = '%';
 524:	89be                	mv	s3,a5
 526:	b7c5                	j	506 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 528:	00ea06b3          	add	a3,s4,a4
 52c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 530:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 532:	c681                	beqz	a3,53a <vprintf+0x7e>
 534:	9752                	add	a4,a4,s4
 536:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 53a:	03878e63          	beq	a5,s8,576 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 53e:	05978863          	beq	a5,s9,58e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 542:	07500713          	li	a4,117
 546:	0ee78263          	beq	a5,a4,62a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 54a:	07800713          	li	a4,120
 54e:	12e78463          	beq	a5,a4,676 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 552:	07000713          	li	a4,112
 556:	14e78963          	beq	a5,a4,6a8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 55a:	07300713          	li	a4,115
 55e:	18e78863          	beq	a5,a4,6ee <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 562:	02500713          	li	a4,37
 566:	04e79463          	bne	a5,a4,5ae <vprintf+0xf2>
        putc(fd, '%');
 56a:	85ba                	mv	a1,a4
 56c:	855a                	mv	a0,s6
 56e:	e99ff0ef          	jal	406 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 572:	4981                	li	s3,0
 574:	bf49                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 576:	008b8493          	addi	s1,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	ea1ff0ef          	jal	424 <printint>
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	bfad                	j	506 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	06400793          	li	a5,100
 592:	02f68963          	beq	a3,a5,5c4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 596:	06c00793          	li	a5,108
 59a:	04f68263          	beq	a3,a5,5de <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 59e:	07500793          	li	a5,117
 5a2:	0af68063          	beq	a3,a5,642 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5a6:	07800793          	li	a5,120
 5aa:	0ef68263          	beq	a3,a5,68e <vprintf+0x1d2>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	855a                	mv	a0,s6
 5b4:	e53ff0ef          	jal	406 <putc>
        putc(fd, c0);
 5b8:	85a6                	mv	a1,s1
 5ba:	855a                	mv	a0,s6
 5bc:	e4bff0ef          	jal	406 <putc>
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b791                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000bb583          	ld	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e53ff0ef          	jal	424 <printint>
        i += 1;
 5d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
        i += 1;
 5dc:	b72d                	j	506 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	06400793          	li	a5,100
 5e2:	02f60763          	beq	a2,a5,610 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e6:	07500793          	li	a5,117
 5ea:	06f60963          	beq	a2,a5,65c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ee:	07800793          	li	a5,120
 5f2:	faf61ee3          	bne	a2,a5,5ae <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f6:	008b8493          	addi	s1,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4641                	li	a2,16
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e21ff0ef          	jal	424 <printint>
        i += 2;
 608:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	bde5                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	008b8493          	addi	s1,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e07ff0ef          	jal	424 <printint>
        i += 2;
 622:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	bdf9                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dedff0ef          	jal	424 <printint>
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	b5d9                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	dd5ff0ef          	jal	424 <printint>
        i += 1;
 654:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
        i += 1;
 65a:	b575                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dbbff0ef          	jal	424 <printint>
        i += 2;
 66e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	bd49                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	da1ff0ef          	jal	424 <printint>
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bdad                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4641                	li	a2,16
 696:	000bb583          	ld	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d89ff0ef          	jal	424 <printint>
        i += 1;
 6a0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
        i += 1;
 6a6:	b585                	j	506 <vprintf+0x4a>
 6a8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6aa:	008b8d13          	addi	s10,s7,8
 6ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b2:	03000593          	li	a1,48
 6b6:	855a                	mv	a0,s6
 6b8:	d4fff0ef          	jal	406 <putc>
  putc(fd, 'x');
 6bc:	07800593          	li	a1,120
 6c0:	855a                	mv	a0,s6
 6c2:	d45ff0ef          	jal	406 <putc>
 6c6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c8:	00000b97          	auipc	s7,0x0
 6cc:	308b8b93          	addi	s7,s7,776 # 9d0 <digits>
 6d0:	03c9d793          	srli	a5,s3,0x3c
 6d4:	97de                	add	a5,a5,s7
 6d6:	0007c583          	lbu	a1,0(a5)
 6da:	855a                	mv	a0,s6
 6dc:	d2bff0ef          	jal	406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e0:	0992                	slli	s3,s3,0x4
 6e2:	34fd                	addiw	s1,s1,-1
 6e4:	f4f5                	bnez	s1,6d0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e6:	8bea                	mv	s7,s10
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	6d02                	ld	s10,0(sp)
 6ec:	bd29                	j	506 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ee:	008b8993          	addi	s3,s7,8
 6f2:	000bb483          	ld	s1,0(s7)
 6f6:	cc91                	beqz	s1,712 <vprintf+0x256>
        for(; *s; s++)
 6f8:	0004c583          	lbu	a1,0(s1)
 6fc:	c195                	beqz	a1,720 <vprintf+0x264>
          putc(fd, *s);
 6fe:	855a                	mv	a0,s6
 700:	d07ff0ef          	jal	406 <putc>
        for(; *s; s++)
 704:	0485                	addi	s1,s1,1
 706:	0004c583          	lbu	a1,0(s1)
 70a:	f9f5                	bnez	a1,6fe <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 70c:	8bce                	mv	s7,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	bbdd                	j	506 <vprintf+0x4a>
          s = "(null)";
 712:	00000497          	auipc	s1,0x0
 716:	28648493          	addi	s1,s1,646 # 998 <malloc+0x176>
        for(; *s; s++)
 71a:	02800593          	li	a1,40
 71e:	b7c5                	j	6fe <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	b3cd                	j	506 <vprintf+0x4a>
 726:	6906                	ld	s2,64(sp)
 728:	79e2                	ld	s3,56(sp)
 72a:	7a42                	ld	s4,48(sp)
 72c:	7aa2                	ld	s5,40(sp)
 72e:	7b02                	ld	s6,32(sp)
 730:	6be2                	ld	s7,24(sp)
 732:	6c42                	ld	s8,16(sp)
 734:	6ca2                	ld	s9,8(sp)
    }
  }
}
 736:	60e6                	ld	ra,88(sp)
 738:	6446                	ld	s0,80(sp)
 73a:	64a6                	ld	s1,72(sp)
 73c:	6125                	addi	sp,sp,96
 73e:	8082                	ret

0000000000000740 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 740:	715d                	addi	sp,sp,-80
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e010                	sd	a2,0(s0)
 74a:	e414                	sd	a3,8(s0)
 74c:	e818                	sd	a4,16(s0)
 74e:	ec1c                	sd	a5,24(s0)
 750:	03043023          	sd	a6,32(s0)
 754:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	8622                	mv	a2,s0
 75a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75e:	d5fff0ef          	jal	4bc <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	711d                	addi	sp,sp,-96
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e40c                	sd	a1,8(s0)
 774:	e810                	sd	a2,16(s0)
 776:	ec14                	sd	a3,24(s0)
 778:	f018                	sd	a4,32(s0)
 77a:	f41c                	sd	a5,40(s0)
 77c:	03043823          	sd	a6,48(s0)
 780:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	00840613          	addi	a2,s0,8
 788:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78c:	85aa                	mv	a1,a0
 78e:	4505                	li	a0,1
 790:	d2dff0ef          	jal	4bc <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	1141                	addi	sp,sp,-16
 79e:	e406                	sd	ra,8(sp)
 7a0:	e022                	sd	s0,0(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8587b783          	ld	a5,-1960(a5) # 1000 <freep>
 7b0:	a02d                	j	7da <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b2:	4618                	lw	a4,8(a2)
 7b4:	9f2d                	addw	a4,a4,a1
 7b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	6310                	ld	a2,0(a4)
 7be:	a83d                	j	7fc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9f31                	addw	a4,a4,a2
 7c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053683          	ld	a3,-16(a0)
 7cc:	a091                	j	810 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e7e463          	bltu	a5,a4,7d8 <free+0x3c>
 7d4:	00e6ea63          	bltu	a3,a4,7e8 <free+0x4c>
{
 7d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	fed7fae3          	bgeu	a5,a3,7ce <free+0x32>
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e6e463          	bltu	a3,a4,7e8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	fee7eae3          	bltu	a5,a4,7d8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7e8:	ff852583          	lw	a1,-8(a0)
 7ec:	6390                	ld	a2,0(a5)
 7ee:	02059813          	slli	a6,a1,0x20
 7f2:	01c85713          	srli	a4,a6,0x1c
 7f6:	9736                	add	a4,a4,a3
 7f8:	fae60de3          	beq	a2,a4,7b2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 800:	4790                	lw	a2,8(a5)
 802:	02061593          	slli	a1,a2,0x20
 806:	01c5d713          	srli	a4,a1,0x1c
 80a:	973e                	add	a4,a4,a5
 80c:	fae68ae3          	beq	a3,a4,7c0 <free+0x24>
    p->s.ptr = bp->s.ptr;
 810:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
}
 81a:	60a2                	ld	ra,8(sp)
 81c:	6402                	ld	s0,0(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f04a                	sd	s2,32(sp)
 82a:	ec4e                	sd	s3,24(sp)
 82c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	02051993          	slli	s3,a0,0x20
 832:	0209d993          	srli	s3,s3,0x20
 836:	09bd                	addi	s3,s3,15
 838:	0049d993          	srli	s3,s3,0x4
 83c:	2985                	addiw	s3,s3,1
 83e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 840:	00000517          	auipc	a0,0x0
 844:	7c053503          	ld	a0,1984(a0) # 1000 <freep>
 848:	c905                	beqz	a0,878 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	09377663          	bgeu	a4,s3,8da <malloc+0xb8>
 852:	f426                	sd	s1,40(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 85a:	8a4e                	mv	s4,s3
 85c:	6705                	lui	a4,0x1
 85e:	00e9f363          	bgeu	s3,a4,864 <malloc+0x42>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86c:	00000497          	auipc	s1,0x0
 870:	79448493          	addi	s1,s1,1940 # 1000 <freep>
  if(p == (char*)-1)
 874:	5afd                	li	s5,-1
 876:	a83d                	j	8b4 <malloc+0x92>
 878:	f426                	sd	s1,40(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	79078793          	addi	a5,a5,1936 # 1010 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	76f73c23          	sd	a5,1912(a4) # 1000 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 896:	b7d1                	j	85a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	a899                	j	8f2 <malloc+0xd0>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	ef9ff0ef          	jal	79c <free>
  return freep;
 8a8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8aa:	c125                	beqz	a0,90a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	03277163          	bgeu	a4,s2,8d2 <malloc+0xb0>
    if(p == freep)
 8b4:	6098                	ld	a4,0(s1)
 8b6:	853e                	mv	a0,a5
 8b8:	fef71ae3          	bne	a4,a5,8ac <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8bc:	8552                	mv	a0,s4
 8be:	b29ff0ef          	jal	3e6 <sbrk>
  if(p == (char*)-1)
 8c2:	fd551ee3          	bne	a0,s5,89e <malloc+0x7c>
        return 0;
 8c6:	4501                	li	a0,0
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	a03d                	j	8fe <malloc+0xdc>
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8da:	fae90fe3          	beq	s2,a4,898 <malloc+0x76>
        p->s.size -= nunits;
 8de:	4137073b          	subw	a4,a4,s3
 8e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e4:	02071693          	slli	a3,a4,0x20
 8e8:	01c6d713          	srli	a4,a3,0x1c
 8ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70a73723          	sd	a0,1806(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fa:	01078513          	addi	a0,a5,16
  }
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	7902                	ld	s2,32(sp)
 904:	69e2                	ld	s3,24(sp)
 906:	6121                	addi	sp,sp,64
 908:	8082                	ret
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	b7f5                	j	8fe <malloc+0xdc>
