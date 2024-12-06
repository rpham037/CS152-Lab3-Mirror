
_v2p_test:     file format elf32-i386


Disassembly of section .text:

00001000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1000:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1001:	31 c0                	xor    %eax,%eax
{
    1003:	89 e5                	mov    %esp,%ebp
    1005:	53                   	push   %ebx
    1006:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1009:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    1010:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1014:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1017:	83 c0 01             	add    $0x1,%eax
    101a:	84 d2                	test   %dl,%dl
    101c:	75 f2                	jne    1010 <strcpy+0x10>
    ;
  return os;
}
    101e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1021:	89 c8                	mov    %ecx,%eax
    1023:	c9                   	leave  
    1024:	c3                   	ret    
    1025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	8b 55 08             	mov    0x8(%ebp),%edx
    1037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    103a:	0f b6 02             	movzbl (%edx),%eax
    103d:	84 c0                	test   %al,%al
    103f:	75 17                	jne    1058 <strcmp+0x28>
    1041:	eb 3a                	jmp    107d <strcmp+0x4d>
    1043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1047:	90                   	nop
    1048:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    104c:	83 c2 01             	add    $0x1,%edx
    104f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1052:	84 c0                	test   %al,%al
    1054:	74 1a                	je     1070 <strcmp+0x40>
    p++, q++;
    1056:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    1058:	0f b6 19             	movzbl (%ecx),%ebx
    105b:	38 c3                	cmp    %al,%bl
    105d:	74 e9                	je     1048 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    105f:	29 d8                	sub    %ebx,%eax
}
    1061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1064:	c9                   	leave  
    1065:	c3                   	ret    
    1066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    106d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    1070:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1074:	31 c0                	xor    %eax,%eax
    1076:	29 d8                	sub    %ebx,%eax
}
    1078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    107b:	c9                   	leave  
    107c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    107d:	0f b6 19             	movzbl (%ecx),%ebx
    1080:	31 c0                	xor    %eax,%eax
    1082:	eb db                	jmp    105f <strcmp+0x2f>
    1084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    108f:	90                   	nop

00001090 <strlen>:

uint
strlen(char *s)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1096:	80 3a 00             	cmpb   $0x0,(%edx)
    1099:	74 15                	je     10b0 <strlen+0x20>
    109b:	31 c0                	xor    %eax,%eax
    109d:	8d 76 00             	lea    0x0(%esi),%esi
    10a0:	83 c0 01             	add    $0x1,%eax
    10a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    10a7:	89 c1                	mov    %eax,%ecx
    10a9:	75 f5                	jne    10a0 <strlen+0x10>
    ;
  return n;
}
    10ab:	89 c8                	mov    %ecx,%eax
    10ad:	5d                   	pop    %ebp
    10ae:	c3                   	ret    
    10af:	90                   	nop
  for(n = 0; s[n]; n++)
    10b0:	31 c9                	xor    %ecx,%ecx
}
    10b2:	5d                   	pop    %ebp
    10b3:	89 c8                	mov    %ecx,%eax
    10b5:	c3                   	ret    
    10b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10bd:	8d 76 00             	lea    0x0(%esi),%esi

000010c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	57                   	push   %edi
    10c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	89 d7                	mov    %edx,%edi
    10cf:	fc                   	cld    
    10d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
    10d5:	89 d0                	mov    %edx,%eax
    10d7:	c9                   	leave  
    10d8:	c3                   	ret    
    10d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000010e0 <strchr>:

char*
strchr(const char *s, char c)
{
    10e0:	55                   	push   %ebp
    10e1:	89 e5                	mov    %esp,%ebp
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    10ea:	0f b6 10             	movzbl (%eax),%edx
    10ed:	84 d2                	test   %dl,%dl
    10ef:	75 12                	jne    1103 <strchr+0x23>
    10f1:	eb 1d                	jmp    1110 <strchr+0x30>
    10f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10f7:	90                   	nop
    10f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    10fc:	83 c0 01             	add    $0x1,%eax
    10ff:	84 d2                	test   %dl,%dl
    1101:	74 0d                	je     1110 <strchr+0x30>
    if(*s == c)
    1103:	38 d1                	cmp    %dl,%cl
    1105:	75 f1                	jne    10f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1107:	5d                   	pop    %ebp
    1108:	c3                   	ret    
    1109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1110:	31 c0                	xor    %eax,%eax
}
    1112:	5d                   	pop    %ebp
    1113:	c3                   	ret    
    1114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    111b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    111f:	90                   	nop

00001120 <gets>:

char*
gets(char *buf, int max)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	57                   	push   %edi
    1124:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1125:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1128:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1129:	31 db                	xor    %ebx,%ebx
{
    112b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    112e:	eb 27                	jmp    1157 <gets+0x37>
    cc = read(0, &c, 1);
    1130:	83 ec 04             	sub    $0x4,%esp
    1133:	6a 01                	push   $0x1
    1135:	57                   	push   %edi
    1136:	6a 00                	push   $0x0
    1138:	e8 2e 01 00 00       	call   126b <read>
    if(cc < 1)
    113d:	83 c4 10             	add    $0x10,%esp
    1140:	85 c0                	test   %eax,%eax
    1142:	7e 1d                	jle    1161 <gets+0x41>
      break;
    buf[i++] = c;
    1144:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1148:	8b 55 08             	mov    0x8(%ebp),%edx
    114b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    114f:	3c 0a                	cmp    $0xa,%al
    1151:	74 1d                	je     1170 <gets+0x50>
    1153:	3c 0d                	cmp    $0xd,%al
    1155:	74 19                	je     1170 <gets+0x50>
  for(i=0; i+1 < max; ){
    1157:	89 de                	mov    %ebx,%esi
    1159:	83 c3 01             	add    $0x1,%ebx
    115c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    115f:	7c cf                	jl     1130 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1161:	8b 45 08             	mov    0x8(%ebp),%eax
    1164:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1168:	8d 65 f4             	lea    -0xc(%ebp),%esp
    116b:	5b                   	pop    %ebx
    116c:	5e                   	pop    %esi
    116d:	5f                   	pop    %edi
    116e:	5d                   	pop    %ebp
    116f:	c3                   	ret    
  buf[i] = '\0';
    1170:	8b 45 08             	mov    0x8(%ebp),%eax
    1173:	89 de                	mov    %ebx,%esi
    1175:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1179:	8d 65 f4             	lea    -0xc(%ebp),%esp
    117c:	5b                   	pop    %ebx
    117d:	5e                   	pop    %esi
    117e:	5f                   	pop    %edi
    117f:	5d                   	pop    %ebp
    1180:	c3                   	ret    
    1181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    118f:	90                   	nop

00001190 <stat>:

int
stat(char *n, struct stat *st)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	56                   	push   %esi
    1194:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1195:	83 ec 08             	sub    $0x8,%esp
    1198:	6a 00                	push   $0x0
    119a:	ff 75 08             	push   0x8(%ebp)
    119d:	e8 f1 00 00 00       	call   1293 <open>
  if(fd < 0)
    11a2:	83 c4 10             	add    $0x10,%esp
    11a5:	85 c0                	test   %eax,%eax
    11a7:	78 27                	js     11d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    11a9:	83 ec 08             	sub    $0x8,%esp
    11ac:	ff 75 0c             	push   0xc(%ebp)
    11af:	89 c3                	mov    %eax,%ebx
    11b1:	50                   	push   %eax
    11b2:	e8 f4 00 00 00       	call   12ab <fstat>
  close(fd);
    11b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    11ba:	89 c6                	mov    %eax,%esi
  close(fd);
    11bc:	e8 ba 00 00 00       	call   127b <close>
  return r;
    11c1:	83 c4 10             	add    $0x10,%esp
}
    11c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11c7:	89 f0                	mov    %esi,%eax
    11c9:	5b                   	pop    %ebx
    11ca:	5e                   	pop    %esi
    11cb:	5d                   	pop    %ebp
    11cc:	c3                   	ret    
    11cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    11d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11d5:	eb ed                	jmp    11c4 <stat+0x34>
    11d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11de:	66 90                	xchg   %ax,%ax

000011e0 <atoi>:

int
atoi(const char *s)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	53                   	push   %ebx
    11e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11e7:	0f be 02             	movsbl (%edx),%eax
    11ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
    11ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    11f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    11f5:	77 1e                	ja     1215 <atoi+0x35>
    11f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11fe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1200:	83 c2 01             	add    $0x1,%edx
    1203:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1206:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    120a:	0f be 02             	movsbl (%edx),%eax
    120d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1210:	80 fb 09             	cmp    $0x9,%bl
    1213:	76 eb                	jbe    1200 <atoi+0x20>
  return n;
}
    1215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1218:	89 c8                	mov    %ecx,%eax
    121a:	c9                   	leave  
    121b:	c3                   	ret    
    121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001220 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	57                   	push   %edi
    1224:	8b 45 10             	mov    0x10(%ebp),%eax
    1227:	8b 55 08             	mov    0x8(%ebp),%edx
    122a:	56                   	push   %esi
    122b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    122e:	85 c0                	test   %eax,%eax
    1230:	7e 13                	jle    1245 <memmove+0x25>
    1232:	01 d0                	add    %edx,%eax
  dst = vdst;
    1234:	89 d7                	mov    %edx,%edi
    1236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1240:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1241:	39 f8                	cmp    %edi,%eax
    1243:	75 fb                	jne    1240 <memmove+0x20>
  return vdst;
}
    1245:	5e                   	pop    %esi
    1246:	89 d0                	mov    %edx,%eax
    1248:	5f                   	pop    %edi
    1249:	5d                   	pop    %ebp
    124a:	c3                   	ret    

0000124b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    124b:	b8 01 00 00 00       	mov    $0x1,%eax
    1250:	cd 40                	int    $0x40
    1252:	c3                   	ret    

00001253 <exit>:
SYSCALL(exit)
    1253:	b8 02 00 00 00       	mov    $0x2,%eax
    1258:	cd 40                	int    $0x40
    125a:	c3                   	ret    

0000125b <wait>:
SYSCALL(wait)
    125b:	b8 03 00 00 00       	mov    $0x3,%eax
    1260:	cd 40                	int    $0x40
    1262:	c3                   	ret    

00001263 <pipe>:
SYSCALL(pipe)
    1263:	b8 04 00 00 00       	mov    $0x4,%eax
    1268:	cd 40                	int    $0x40
    126a:	c3                   	ret    

0000126b <read>:
SYSCALL(read)
    126b:	b8 05 00 00 00       	mov    $0x5,%eax
    1270:	cd 40                	int    $0x40
    1272:	c3                   	ret    

00001273 <write>:
SYSCALL(write)
    1273:	b8 10 00 00 00       	mov    $0x10,%eax
    1278:	cd 40                	int    $0x40
    127a:	c3                   	ret    

0000127b <close>:
SYSCALL(close)
    127b:	b8 15 00 00 00       	mov    $0x15,%eax
    1280:	cd 40                	int    $0x40
    1282:	c3                   	ret    

00001283 <kill>:
SYSCALL(kill)
    1283:	b8 06 00 00 00       	mov    $0x6,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <exec>:
SYSCALL(exec)
    128b:	b8 07 00 00 00       	mov    $0x7,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <open>:
SYSCALL(open)
    1293:	b8 0f 00 00 00       	mov    $0xf,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <mknod>:
SYSCALL(mknod)
    129b:	b8 11 00 00 00       	mov    $0x11,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <unlink>:
SYSCALL(unlink)
    12a3:	b8 12 00 00 00       	mov    $0x12,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <fstat>:
SYSCALL(fstat)
    12ab:	b8 08 00 00 00       	mov    $0x8,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <link>:
SYSCALL(link)
    12b3:	b8 13 00 00 00       	mov    $0x13,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <mkdir>:
SYSCALL(mkdir)
    12bb:	b8 14 00 00 00       	mov    $0x14,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <chdir>:
SYSCALL(chdir)
    12c3:	b8 09 00 00 00       	mov    $0x9,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <dup>:
SYSCALL(dup)
    12cb:	b8 0a 00 00 00       	mov    $0xa,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <getpid>:
SYSCALL(getpid)
    12d3:	b8 0b 00 00 00       	mov    $0xb,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <sbrk>:
SYSCALL(sbrk)
    12db:	b8 0c 00 00 00       	mov    $0xc,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <sleep>:
SYSCALL(sleep)
    12e3:	b8 0d 00 00 00       	mov    $0xd,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <uptime>:
SYSCALL(uptime)
    12eb:	b8 0e 00 00 00       	mov    $0xe,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <shm_open>:
SYSCALL(shm_open)
    12f3:	b8 16 00 00 00       	mov    $0x16,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <shm_close>:
SYSCALL(shm_close)	
    12fb:	b8 17 00 00 00       	mov    $0x17,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <v2p>:
SYSCALL(v2p)
    1303:	b8 18 00 00 00       	mov    $0x18,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    
    130b:	66 90                	xchg   %ax,%ax
    130d:	66 90                	xchg   %ax,%ax
    130f:	90                   	nop

00001310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	57                   	push   %edi
    1314:	56                   	push   %esi
    1315:	53                   	push   %ebx
    1316:	83 ec 3c             	sub    $0x3c,%esp
    1319:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    131c:	89 d1                	mov    %edx,%ecx
{
    131e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1321:	85 d2                	test   %edx,%edx
    1323:	0f 89 7f 00 00 00    	jns    13a8 <printint+0x98>
    1329:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    132d:	74 79                	je     13a8 <printint+0x98>
    neg = 1;
    132f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1336:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1338:	31 db                	xor    %ebx,%ebx
    133a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    133d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1340:	89 c8                	mov    %ecx,%eax
    1342:	31 d2                	xor    %edx,%edx
    1344:	89 cf                	mov    %ecx,%edi
    1346:	f7 75 c4             	divl   -0x3c(%ebp)
    1349:	0f b6 92 84 17 00 00 	movzbl 0x1784(%edx),%edx
    1350:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1353:	89 d8                	mov    %ebx,%eax
    1355:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1358:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    135b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    135e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1361:	76 dd                	jbe    1340 <printint+0x30>
  if(neg)
    1363:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1366:	85 c9                	test   %ecx,%ecx
    1368:	74 0c                	je     1376 <printint+0x66>
    buf[i++] = '-';
    136a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    136f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1371:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1376:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1379:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    137d:	eb 07                	jmp    1386 <printint+0x76>
    137f:	90                   	nop
    putc(fd, buf[i]);
    1380:	0f b6 13             	movzbl (%ebx),%edx
    1383:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1386:	83 ec 04             	sub    $0x4,%esp
    1389:	88 55 d7             	mov    %dl,-0x29(%ebp)
    138c:	6a 01                	push   $0x1
    138e:	56                   	push   %esi
    138f:	57                   	push   %edi
    1390:	e8 de fe ff ff       	call   1273 <write>
  while(--i >= 0)
    1395:	83 c4 10             	add    $0x10,%esp
    1398:	39 de                	cmp    %ebx,%esi
    139a:	75 e4                	jne    1380 <printint+0x70>
}
    139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    139f:	5b                   	pop    %ebx
    13a0:	5e                   	pop    %esi
    13a1:	5f                   	pop    %edi
    13a2:	5d                   	pop    %ebp
    13a3:	c3                   	ret    
    13a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    13a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    13af:	eb 87                	jmp    1338 <printint+0x28>
    13b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13bf:	90                   	nop

000013c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13c0:	55                   	push   %ebp
    13c1:	89 e5                	mov    %esp,%ebp
    13c3:	57                   	push   %edi
    13c4:	56                   	push   %esi
    13c5:	53                   	push   %ebx
    13c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    13cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    13cf:	0f b6 13             	movzbl (%ebx),%edx
    13d2:	84 d2                	test   %dl,%dl
    13d4:	74 6a                	je     1440 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    13d6:	8d 45 10             	lea    0x10(%ebp),%eax
    13d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    13dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    13df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    13e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    13e4:	eb 36                	jmp    141c <printf+0x5c>
    13e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ed:	8d 76 00             	lea    0x0(%esi),%esi
    13f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    13f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    13f8:	83 f8 25             	cmp    $0x25,%eax
    13fb:	74 15                	je     1412 <printf+0x52>
  write(fd, &c, 1);
    13fd:	83 ec 04             	sub    $0x4,%esp
    1400:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1403:	6a 01                	push   $0x1
    1405:	57                   	push   %edi
    1406:	56                   	push   %esi
    1407:	e8 67 fe ff ff       	call   1273 <write>
    140c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    140f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1412:	0f b6 13             	movzbl (%ebx),%edx
    1415:	83 c3 01             	add    $0x1,%ebx
    1418:	84 d2                	test   %dl,%dl
    141a:	74 24                	je     1440 <printf+0x80>
    c = fmt[i] & 0xff;
    141c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    141f:	85 c9                	test   %ecx,%ecx
    1421:	74 cd                	je     13f0 <printf+0x30>
      }
    } else if(state == '%'){
    1423:	83 f9 25             	cmp    $0x25,%ecx
    1426:	75 ea                	jne    1412 <printf+0x52>
      if(c == 'd'){
    1428:	83 f8 25             	cmp    $0x25,%eax
    142b:	0f 84 07 01 00 00    	je     1538 <printf+0x178>
    1431:	83 e8 63             	sub    $0x63,%eax
    1434:	83 f8 15             	cmp    $0x15,%eax
    1437:	77 17                	ja     1450 <printf+0x90>
    1439:	ff 24 85 2c 17 00 00 	jmp    *0x172c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1440:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1443:	5b                   	pop    %ebx
    1444:	5e                   	pop    %esi
    1445:	5f                   	pop    %edi
    1446:	5d                   	pop    %ebp
    1447:	c3                   	ret    
    1448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    144f:	90                   	nop
  write(fd, &c, 1);
    1450:	83 ec 04             	sub    $0x4,%esp
    1453:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1456:	6a 01                	push   $0x1
    1458:	57                   	push   %edi
    1459:	56                   	push   %esi
    145a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    145e:	e8 10 fe ff ff       	call   1273 <write>
        putc(fd, c);
    1463:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1467:	83 c4 0c             	add    $0xc,%esp
    146a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    146d:	6a 01                	push   $0x1
    146f:	57                   	push   %edi
    1470:	56                   	push   %esi
    1471:	e8 fd fd ff ff       	call   1273 <write>
        putc(fd, c);
    1476:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1479:	31 c9                	xor    %ecx,%ecx
    147b:	eb 95                	jmp    1412 <printf+0x52>
    147d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1480:	83 ec 0c             	sub    $0xc,%esp
    1483:	b9 10 00 00 00       	mov    $0x10,%ecx
    1488:	6a 00                	push   $0x0
    148a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    148d:	8b 10                	mov    (%eax),%edx
    148f:	89 f0                	mov    %esi,%eax
    1491:	e8 7a fe ff ff       	call   1310 <printint>
        ap++;
    1496:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    149a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    149d:	31 c9                	xor    %ecx,%ecx
    149f:	e9 6e ff ff ff       	jmp    1412 <printf+0x52>
    14a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    14a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    14ab:	8b 10                	mov    (%eax),%edx
        ap++;
    14ad:	83 c0 04             	add    $0x4,%eax
    14b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    14b3:	85 d2                	test   %edx,%edx
    14b5:	0f 84 8d 00 00 00    	je     1548 <printf+0x188>
        while(*s != 0){
    14bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    14be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    14c0:	84 c0                	test   %al,%al
    14c2:	0f 84 4a ff ff ff    	je     1412 <printf+0x52>
    14c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    14cb:	89 d3                	mov    %edx,%ebx
    14cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    14d0:	83 ec 04             	sub    $0x4,%esp
          s++;
    14d3:	83 c3 01             	add    $0x1,%ebx
    14d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    14d9:	6a 01                	push   $0x1
    14db:	57                   	push   %edi
    14dc:	56                   	push   %esi
    14dd:	e8 91 fd ff ff       	call   1273 <write>
        while(*s != 0){
    14e2:	0f b6 03             	movzbl (%ebx),%eax
    14e5:	83 c4 10             	add    $0x10,%esp
    14e8:	84 c0                	test   %al,%al
    14ea:	75 e4                	jne    14d0 <printf+0x110>
      state = 0;
    14ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    14ef:	31 c9                	xor    %ecx,%ecx
    14f1:	e9 1c ff ff ff       	jmp    1412 <printf+0x52>
    14f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    1500:	83 ec 0c             	sub    $0xc,%esp
    1503:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1508:	6a 01                	push   $0x1
    150a:	e9 7b ff ff ff       	jmp    148a <printf+0xca>
    150f:	90                   	nop
        putc(fd, *ap);
    1510:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1513:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1516:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1518:	6a 01                	push   $0x1
    151a:	57                   	push   %edi
    151b:	56                   	push   %esi
        putc(fd, *ap);
    151c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    151f:	e8 4f fd ff ff       	call   1273 <write>
        ap++;
    1524:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1528:	83 c4 10             	add    $0x10,%esp
      state = 0;
    152b:	31 c9                	xor    %ecx,%ecx
    152d:	e9 e0 fe ff ff       	jmp    1412 <printf+0x52>
    1532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1538:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    153b:	83 ec 04             	sub    $0x4,%esp
    153e:	e9 2a ff ff ff       	jmp    146d <printf+0xad>
    1543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1547:	90                   	nop
          s = "(null)";
    1548:	ba 24 17 00 00       	mov    $0x1724,%edx
        while(*s != 0){
    154d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1550:	b8 28 00 00 00       	mov    $0x28,%eax
    1555:	89 d3                	mov    %edx,%ebx
    1557:	e9 74 ff ff ff       	jmp    14d0 <printf+0x110>
    155c:	66 90                	xchg   %ax,%ax
    155e:	66 90                	xchg   %ax,%ax

00001560 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1560:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1561:	a1 48 1a 00 00       	mov    0x1a48,%eax
{
    1566:	89 e5                	mov    %esp,%ebp
    1568:	57                   	push   %edi
    1569:	56                   	push   %esi
    156a:	53                   	push   %ebx
    156b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    156e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1578:	89 c2                	mov    %eax,%edx
    157a:	8b 00                	mov    (%eax),%eax
    157c:	39 ca                	cmp    %ecx,%edx
    157e:	73 30                	jae    15b0 <free+0x50>
    1580:	39 c1                	cmp    %eax,%ecx
    1582:	72 04                	jb     1588 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1584:	39 c2                	cmp    %eax,%edx
    1586:	72 f0                	jb     1578 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1588:	8b 73 fc             	mov    -0x4(%ebx),%esi
    158b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    158e:	39 f8                	cmp    %edi,%eax
    1590:	74 30                	je     15c2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1592:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1595:	8b 42 04             	mov    0x4(%edx),%eax
    1598:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    159b:	39 f1                	cmp    %esi,%ecx
    159d:	74 3a                	je     15d9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    159f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    15a1:	5b                   	pop    %ebx
  freep = p;
    15a2:	89 15 48 1a 00 00    	mov    %edx,0x1a48
}
    15a8:	5e                   	pop    %esi
    15a9:	5f                   	pop    %edi
    15aa:	5d                   	pop    %ebp
    15ab:	c3                   	ret    
    15ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15b0:	39 c2                	cmp    %eax,%edx
    15b2:	72 c4                	jb     1578 <free+0x18>
    15b4:	39 c1                	cmp    %eax,%ecx
    15b6:	73 c0                	jae    1578 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    15b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    15be:	39 f8                	cmp    %edi,%eax
    15c0:	75 d0                	jne    1592 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    15c2:	03 70 04             	add    0x4(%eax),%esi
    15c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    15c8:	8b 02                	mov    (%edx),%eax
    15ca:	8b 00                	mov    (%eax),%eax
    15cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    15cf:	8b 42 04             	mov    0x4(%edx),%eax
    15d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    15d5:	39 f1                	cmp    %esi,%ecx
    15d7:	75 c6                	jne    159f <free+0x3f>
    p->s.size += bp->s.size;
    15d9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    15dc:	89 15 48 1a 00 00    	mov    %edx,0x1a48
    p->s.size += bp->s.size;
    15e2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    15e5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    15e8:	89 0a                	mov    %ecx,(%edx)
}
    15ea:	5b                   	pop    %ebx
    15eb:	5e                   	pop    %esi
    15ec:	5f                   	pop    %edi
    15ed:	5d                   	pop    %ebp
    15ee:	c3                   	ret    
    15ef:	90                   	nop

000015f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15f0:	55                   	push   %ebp
    15f1:	89 e5                	mov    %esp,%ebp
    15f3:	57                   	push   %edi
    15f4:	56                   	push   %esi
    15f5:	53                   	push   %ebx
    15f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    15fc:	8b 3d 48 1a 00 00    	mov    0x1a48,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1602:	8d 70 07             	lea    0x7(%eax),%esi
    1605:	c1 ee 03             	shr    $0x3,%esi
    1608:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    160b:	85 ff                	test   %edi,%edi
    160d:	0f 84 9d 00 00 00    	je     16b0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1613:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1615:	8b 4a 04             	mov    0x4(%edx),%ecx
    1618:	39 f1                	cmp    %esi,%ecx
    161a:	73 6a                	jae    1686 <malloc+0x96>
    161c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1621:	39 de                	cmp    %ebx,%esi
    1623:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1626:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    162d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1630:	eb 17                	jmp    1649 <malloc+0x59>
    1632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1638:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    163a:	8b 48 04             	mov    0x4(%eax),%ecx
    163d:	39 f1                	cmp    %esi,%ecx
    163f:	73 4f                	jae    1690 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1641:	8b 3d 48 1a 00 00    	mov    0x1a48,%edi
    1647:	89 c2                	mov    %eax,%edx
    1649:	39 d7                	cmp    %edx,%edi
    164b:	75 eb                	jne    1638 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    164d:	83 ec 0c             	sub    $0xc,%esp
    1650:	ff 75 e4             	push   -0x1c(%ebp)
    1653:	e8 83 fc ff ff       	call   12db <sbrk>
  if(p == (char*)-1)
    1658:	83 c4 10             	add    $0x10,%esp
    165b:	83 f8 ff             	cmp    $0xffffffff,%eax
    165e:	74 1c                	je     167c <malloc+0x8c>
  hp->s.size = nu;
    1660:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1663:	83 ec 0c             	sub    $0xc,%esp
    1666:	83 c0 08             	add    $0x8,%eax
    1669:	50                   	push   %eax
    166a:	e8 f1 fe ff ff       	call   1560 <free>
  return freep;
    166f:	8b 15 48 1a 00 00    	mov    0x1a48,%edx
      if((p = morecore(nunits)) == 0)
    1675:	83 c4 10             	add    $0x10,%esp
    1678:	85 d2                	test   %edx,%edx
    167a:	75 bc                	jne    1638 <malloc+0x48>
        return 0;
  }
}
    167c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    167f:	31 c0                	xor    %eax,%eax
}
    1681:	5b                   	pop    %ebx
    1682:	5e                   	pop    %esi
    1683:	5f                   	pop    %edi
    1684:	5d                   	pop    %ebp
    1685:	c3                   	ret    
    if(p->s.size >= nunits){
    1686:	89 d0                	mov    %edx,%eax
    1688:	89 fa                	mov    %edi,%edx
    168a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1690:	39 ce                	cmp    %ecx,%esi
    1692:	74 4c                	je     16e0 <malloc+0xf0>
        p->s.size -= nunits;
    1694:	29 f1                	sub    %esi,%ecx
    1696:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1699:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    169c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    169f:	89 15 48 1a 00 00    	mov    %edx,0x1a48
}
    16a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    16a8:	83 c0 08             	add    $0x8,%eax
}
    16ab:	5b                   	pop    %ebx
    16ac:	5e                   	pop    %esi
    16ad:	5f                   	pop    %edi
    16ae:	5d                   	pop    %ebp
    16af:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    16b0:	c7 05 48 1a 00 00 4c 	movl   $0x1a4c,0x1a48
    16b7:	1a 00 00 
    base.s.size = 0;
    16ba:	bf 4c 1a 00 00       	mov    $0x1a4c,%edi
    base.s.ptr = freep = prevp = &base;
    16bf:	c7 05 4c 1a 00 00 4c 	movl   $0x1a4c,0x1a4c
    16c6:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16c9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    16cb:	c7 05 50 1a 00 00 00 	movl   $0x0,0x1a50
    16d2:	00 00 00 
    if(p->s.size >= nunits){
    16d5:	e9 42 ff ff ff       	jmp    161c <malloc+0x2c>
    16da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    16e0:	8b 08                	mov    (%eax),%ecx
    16e2:	89 0a                	mov    %ecx,(%edx)
    16e4:	eb b9                	jmp    169f <malloc+0xaf>
    16e6:	66 90                	xchg   %ax,%ax
    16e8:	66 90                	xchg   %ax,%ax
    16ea:	66 90                	xchg   %ax,%ax
    16ec:	66 90                	xchg   %ax,%ax
    16ee:	66 90                	xchg   %ax,%ax

000016f0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    16f0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    16f1:	b9 01 00 00 00       	mov    $0x1,%ecx
    16f6:	89 e5                	mov    %esp,%ebp
    16f8:	8b 55 08             	mov    0x8(%ebp),%edx
    16fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16ff:	90                   	nop
    1700:	89 c8                	mov    %ecx,%eax
    1702:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1705:	85 c0                	test   %eax,%eax
    1707:	75 f7                	jne    1700 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1709:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    170e:	5d                   	pop    %ebp
    170f:	c3                   	ret    

00001710 <urelease>:

void urelease (struct uspinlock *lk) {
    1710:	55                   	push   %ebp
    1711:	89 e5                	mov    %esp,%ebp
    1713:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1716:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    171b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1721:	5d                   	pop    %ebp
    1722:	c3                   	ret    
