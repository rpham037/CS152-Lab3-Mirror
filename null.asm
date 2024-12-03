
_null:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

int main(int argc, char *argv[])
{
int *i = 0;

(*i)++;
    1000:	a1 00 00 00 00       	mov    0x0,%eax
    1005:	0f 0b                	ud2    
    1007:	66 90                	xchg   %ax,%ax
    1009:	66 90                	xchg   %ax,%ax
    100b:	66 90                	xchg   %ax,%ax
    100d:	66 90                	xchg   %ax,%ax
    100f:	90                   	nop

00001010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1010:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1011:	31 c0                	xor    %eax,%eax
{
    1013:	89 e5                	mov    %esp,%ebp
    1015:	53                   	push   %ebx
    1016:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1019:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    1020:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1024:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1027:	83 c0 01             	add    $0x1,%eax
    102a:	84 d2                	test   %dl,%dl
    102c:	75 f2                	jne    1020 <strcpy+0x10>
    ;
  return os;
}
    102e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1031:	89 c8                	mov    %ecx,%eax
    1033:	c9                   	leave  
    1034:	c3                   	ret    
    1035:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	53                   	push   %ebx
    1044:	8b 55 08             	mov    0x8(%ebp),%edx
    1047:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    104a:	0f b6 02             	movzbl (%edx),%eax
    104d:	84 c0                	test   %al,%al
    104f:	75 17                	jne    1068 <strcmp+0x28>
    1051:	eb 3a                	jmp    108d <strcmp+0x4d>
    1053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1057:	90                   	nop
    1058:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    105c:	83 c2 01             	add    $0x1,%edx
    105f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1062:	84 c0                	test   %al,%al
    1064:	74 1a                	je     1080 <strcmp+0x40>
    p++, q++;
    1066:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    1068:	0f b6 19             	movzbl (%ecx),%ebx
    106b:	38 c3                	cmp    %al,%bl
    106d:	74 e9                	je     1058 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    106f:	29 d8                	sub    %ebx,%eax
}
    1071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1074:	c9                   	leave  
    1075:	c3                   	ret    
    1076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    107d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    1080:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1084:	31 c0                	xor    %eax,%eax
    1086:	29 d8                	sub    %ebx,%eax
}
    1088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    108b:	c9                   	leave  
    108c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    108d:	0f b6 19             	movzbl (%ecx),%ebx
    1090:	31 c0                	xor    %eax,%eax
    1092:	eb db                	jmp    106f <strcmp+0x2f>
    1094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    109f:	90                   	nop

000010a0 <strlen>:

uint
strlen(char *s)
{
    10a0:	55                   	push   %ebp
    10a1:	89 e5                	mov    %esp,%ebp
    10a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    10a6:	80 3a 00             	cmpb   $0x0,(%edx)
    10a9:	74 15                	je     10c0 <strlen+0x20>
    10ab:	31 c0                	xor    %eax,%eax
    10ad:	8d 76 00             	lea    0x0(%esi),%esi
    10b0:	83 c0 01             	add    $0x1,%eax
    10b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    10b7:	89 c1                	mov    %eax,%ecx
    10b9:	75 f5                	jne    10b0 <strlen+0x10>
    ;
  return n;
}
    10bb:	89 c8                	mov    %ecx,%eax
    10bd:	5d                   	pop    %ebp
    10be:	c3                   	ret    
    10bf:	90                   	nop
  for(n = 0; s[n]; n++)
    10c0:	31 c9                	xor    %ecx,%ecx
}
    10c2:	5d                   	pop    %ebp
    10c3:	89 c8                	mov    %ecx,%eax
    10c5:	c3                   	ret    
    10c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10cd:	8d 76 00             	lea    0x0(%esi),%esi

000010d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d0:	55                   	push   %ebp
    10d1:	89 e5                	mov    %esp,%ebp
    10d3:	57                   	push   %edi
    10d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10da:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dd:	89 d7                	mov    %edx,%edi
    10df:	fc                   	cld    
    10e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
    10e5:	89 d0                	mov    %edx,%eax
    10e7:	c9                   	leave  
    10e8:	c3                   	ret    
    10e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000010f0 <strchr>:

char*
strchr(const char *s, char c)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	8b 45 08             	mov    0x8(%ebp),%eax
    10f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    10fa:	0f b6 10             	movzbl (%eax),%edx
    10fd:	84 d2                	test   %dl,%dl
    10ff:	75 12                	jne    1113 <strchr+0x23>
    1101:	eb 1d                	jmp    1120 <strchr+0x30>
    1103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1107:	90                   	nop
    1108:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    110c:	83 c0 01             	add    $0x1,%eax
    110f:	84 d2                	test   %dl,%dl
    1111:	74 0d                	je     1120 <strchr+0x30>
    if(*s == c)
    1113:	38 d1                	cmp    %dl,%cl
    1115:	75 f1                	jne    1108 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1117:	5d                   	pop    %ebp
    1118:	c3                   	ret    
    1119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1120:	31 c0                	xor    %eax,%eax
}
    1122:	5d                   	pop    %ebp
    1123:	c3                   	ret    
    1124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    112b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    112f:	90                   	nop

00001130 <gets>:

char*
gets(char *buf, int max)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	57                   	push   %edi
    1134:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1135:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1138:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1139:	31 db                	xor    %ebx,%ebx
{
    113b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    113e:	eb 27                	jmp    1167 <gets+0x37>
    cc = read(0, &c, 1);
    1140:	83 ec 04             	sub    $0x4,%esp
    1143:	6a 01                	push   $0x1
    1145:	57                   	push   %edi
    1146:	6a 00                	push   $0x0
    1148:	e8 2e 01 00 00       	call   127b <read>
    if(cc < 1)
    114d:	83 c4 10             	add    $0x10,%esp
    1150:	85 c0                	test   %eax,%eax
    1152:	7e 1d                	jle    1171 <gets+0x41>
      break;
    buf[i++] = c;
    1154:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1158:	8b 55 08             	mov    0x8(%ebp),%edx
    115b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    115f:	3c 0a                	cmp    $0xa,%al
    1161:	74 1d                	je     1180 <gets+0x50>
    1163:	3c 0d                	cmp    $0xd,%al
    1165:	74 19                	je     1180 <gets+0x50>
  for(i=0; i+1 < max; ){
    1167:	89 de                	mov    %ebx,%esi
    1169:	83 c3 01             	add    $0x1,%ebx
    116c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    116f:	7c cf                	jl     1140 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1178:	8d 65 f4             	lea    -0xc(%ebp),%esp
    117b:	5b                   	pop    %ebx
    117c:	5e                   	pop    %esi
    117d:	5f                   	pop    %edi
    117e:	5d                   	pop    %ebp
    117f:	c3                   	ret    
  buf[i] = '\0';
    1180:	8b 45 08             	mov    0x8(%ebp),%eax
    1183:	89 de                	mov    %ebx,%esi
    1185:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1189:	8d 65 f4             	lea    -0xc(%ebp),%esp
    118c:	5b                   	pop    %ebx
    118d:	5e                   	pop    %esi
    118e:	5f                   	pop    %edi
    118f:	5d                   	pop    %ebp
    1190:	c3                   	ret    
    1191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    119f:	90                   	nop

000011a0 <stat>:

int
stat(char *n, struct stat *st)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	56                   	push   %esi
    11a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11a5:	83 ec 08             	sub    $0x8,%esp
    11a8:	6a 00                	push   $0x0
    11aa:	ff 75 08             	push   0x8(%ebp)
    11ad:	e8 f1 00 00 00       	call   12a3 <open>
  if(fd < 0)
    11b2:	83 c4 10             	add    $0x10,%esp
    11b5:	85 c0                	test   %eax,%eax
    11b7:	78 27                	js     11e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    11b9:	83 ec 08             	sub    $0x8,%esp
    11bc:	ff 75 0c             	push   0xc(%ebp)
    11bf:	89 c3                	mov    %eax,%ebx
    11c1:	50                   	push   %eax
    11c2:	e8 f4 00 00 00       	call   12bb <fstat>
  close(fd);
    11c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    11ca:	89 c6                	mov    %eax,%esi
  close(fd);
    11cc:	e8 ba 00 00 00       	call   128b <close>
  return r;
    11d1:	83 c4 10             	add    $0x10,%esp
}
    11d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11d7:	89 f0                	mov    %esi,%eax
    11d9:	5b                   	pop    %ebx
    11da:	5e                   	pop    %esi
    11db:	5d                   	pop    %ebp
    11dc:	c3                   	ret    
    11dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    11e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11e5:	eb ed                	jmp    11d4 <stat+0x34>
    11e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ee:	66 90                	xchg   %ax,%ax

000011f0 <atoi>:

int
atoi(const char *s)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	53                   	push   %ebx
    11f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11f7:	0f be 02             	movsbl (%edx),%eax
    11fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
    11fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1200:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1205:	77 1e                	ja     1225 <atoi+0x35>
    1207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    120e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1210:	83 c2 01             	add    $0x1,%edx
    1213:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1216:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    121a:	0f be 02             	movsbl (%edx),%eax
    121d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1220:	80 fb 09             	cmp    $0x9,%bl
    1223:	76 eb                	jbe    1210 <atoi+0x20>
  return n;
}
    1225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1228:	89 c8                	mov    %ecx,%eax
    122a:	c9                   	leave  
    122b:	c3                   	ret    
    122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001230 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1230:	55                   	push   %ebp
    1231:	89 e5                	mov    %esp,%ebp
    1233:	57                   	push   %edi
    1234:	8b 45 10             	mov    0x10(%ebp),%eax
    1237:	8b 55 08             	mov    0x8(%ebp),%edx
    123a:	56                   	push   %esi
    123b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    123e:	85 c0                	test   %eax,%eax
    1240:	7e 13                	jle    1255 <memmove+0x25>
    1242:	01 d0                	add    %edx,%eax
  dst = vdst;
    1244:	89 d7                	mov    %edx,%edi
    1246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    124d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1250:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1251:	39 f8                	cmp    %edi,%eax
    1253:	75 fb                	jne    1250 <memmove+0x20>
  return vdst;
}
    1255:	5e                   	pop    %esi
    1256:	89 d0                	mov    %edx,%eax
    1258:	5f                   	pop    %edi
    1259:	5d                   	pop    %ebp
    125a:	c3                   	ret    

0000125b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    125b:	b8 01 00 00 00       	mov    $0x1,%eax
    1260:	cd 40                	int    $0x40
    1262:	c3                   	ret    

00001263 <exit>:
SYSCALL(exit)
    1263:	b8 02 00 00 00       	mov    $0x2,%eax
    1268:	cd 40                	int    $0x40
    126a:	c3                   	ret    

0000126b <wait>:
SYSCALL(wait)
    126b:	b8 03 00 00 00       	mov    $0x3,%eax
    1270:	cd 40                	int    $0x40
    1272:	c3                   	ret    

00001273 <pipe>:
SYSCALL(pipe)
    1273:	b8 04 00 00 00       	mov    $0x4,%eax
    1278:	cd 40                	int    $0x40
    127a:	c3                   	ret    

0000127b <read>:
SYSCALL(read)
    127b:	b8 05 00 00 00       	mov    $0x5,%eax
    1280:	cd 40                	int    $0x40
    1282:	c3                   	ret    

00001283 <write>:
SYSCALL(write)
    1283:	b8 10 00 00 00       	mov    $0x10,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <close>:
SYSCALL(close)
    128b:	b8 15 00 00 00       	mov    $0x15,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <kill>:
SYSCALL(kill)
    1293:	b8 06 00 00 00       	mov    $0x6,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <exec>:
SYSCALL(exec)
    129b:	b8 07 00 00 00       	mov    $0x7,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <open>:
SYSCALL(open)
    12a3:	b8 0f 00 00 00       	mov    $0xf,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <mknod>:
SYSCALL(mknod)
    12ab:	b8 11 00 00 00       	mov    $0x11,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <unlink>:
SYSCALL(unlink)
    12b3:	b8 12 00 00 00       	mov    $0x12,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <fstat>:
SYSCALL(fstat)
    12bb:	b8 08 00 00 00       	mov    $0x8,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <link>:
SYSCALL(link)
    12c3:	b8 13 00 00 00       	mov    $0x13,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <mkdir>:
SYSCALL(mkdir)
    12cb:	b8 14 00 00 00       	mov    $0x14,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <chdir>:
SYSCALL(chdir)
    12d3:	b8 09 00 00 00       	mov    $0x9,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <dup>:
SYSCALL(dup)
    12db:	b8 0a 00 00 00       	mov    $0xa,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <getpid>:
SYSCALL(getpid)
    12e3:	b8 0b 00 00 00       	mov    $0xb,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <sbrk>:
SYSCALL(sbrk)
    12eb:	b8 0c 00 00 00       	mov    $0xc,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <sleep>:
SYSCALL(sleep)
    12f3:	b8 0d 00 00 00       	mov    $0xd,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <uptime>:
SYSCALL(uptime)
    12fb:	b8 0e 00 00 00       	mov    $0xe,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <shm_open>:
SYSCALL(shm_open)
    1303:	b8 16 00 00 00       	mov    $0x16,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <shm_close>:
SYSCALL(shm_close)	
    130b:	b8 17 00 00 00       	mov    $0x17,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    
    1313:	66 90                	xchg   %ax,%ax
    1315:	66 90                	xchg   %ax,%ax
    1317:	66 90                	xchg   %ax,%ax
    1319:	66 90                	xchg   %ax,%ax
    131b:	66 90                	xchg   %ax,%ax
    131d:	66 90                	xchg   %ax,%ax
    131f:	90                   	nop

00001320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1320:	55                   	push   %ebp
    1321:	89 e5                	mov    %esp,%ebp
    1323:	57                   	push   %edi
    1324:	56                   	push   %esi
    1325:	53                   	push   %ebx
    1326:	83 ec 3c             	sub    $0x3c,%esp
    1329:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    132c:	89 d1                	mov    %edx,%ecx
{
    132e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1331:	85 d2                	test   %edx,%edx
    1333:	0f 89 7f 00 00 00    	jns    13b8 <printint+0x98>
    1339:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    133d:	74 79                	je     13b8 <printint+0x98>
    neg = 1;
    133f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1346:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1348:	31 db                	xor    %ebx,%ebx
    134a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    134d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1350:	89 c8                	mov    %ecx,%eax
    1352:	31 d2                	xor    %edx,%edx
    1354:	89 cf                	mov    %ecx,%edi
    1356:	f7 75 c4             	divl   -0x3c(%ebp)
    1359:	0f b6 92 94 17 00 00 	movzbl 0x1794(%edx),%edx
    1360:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1363:	89 d8                	mov    %ebx,%eax
    1365:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1368:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    136b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    136e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1371:	76 dd                	jbe    1350 <printint+0x30>
  if(neg)
    1373:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1376:	85 c9                	test   %ecx,%ecx
    1378:	74 0c                	je     1386 <printint+0x66>
    buf[i++] = '-';
    137a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    137f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1381:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1386:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1389:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    138d:	eb 07                	jmp    1396 <printint+0x76>
    138f:	90                   	nop
    putc(fd, buf[i]);
    1390:	0f b6 13             	movzbl (%ebx),%edx
    1393:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1396:	83 ec 04             	sub    $0x4,%esp
    1399:	88 55 d7             	mov    %dl,-0x29(%ebp)
    139c:	6a 01                	push   $0x1
    139e:	56                   	push   %esi
    139f:	57                   	push   %edi
    13a0:	e8 de fe ff ff       	call   1283 <write>
  while(--i >= 0)
    13a5:	83 c4 10             	add    $0x10,%esp
    13a8:	39 de                	cmp    %ebx,%esi
    13aa:	75 e4                	jne    1390 <printint+0x70>
}
    13ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13af:	5b                   	pop    %ebx
    13b0:	5e                   	pop    %esi
    13b1:	5f                   	pop    %edi
    13b2:	5d                   	pop    %ebp
    13b3:	c3                   	ret    
    13b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    13b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    13bf:	eb 87                	jmp    1348 <printint+0x28>
    13c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13cf:	90                   	nop

000013d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	57                   	push   %edi
    13d4:	56                   	push   %esi
    13d5:	53                   	push   %ebx
    13d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    13dc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    13df:	0f b6 13             	movzbl (%ebx),%edx
    13e2:	84 d2                	test   %dl,%dl
    13e4:	74 6a                	je     1450 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    13e6:	8d 45 10             	lea    0x10(%ebp),%eax
    13e9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    13ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    13ef:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    13f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    13f4:	eb 36                	jmp    142c <printf+0x5c>
    13f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13fd:	8d 76 00             	lea    0x0(%esi),%esi
    1400:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1403:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    1408:	83 f8 25             	cmp    $0x25,%eax
    140b:	74 15                	je     1422 <printf+0x52>
  write(fd, &c, 1);
    140d:	83 ec 04             	sub    $0x4,%esp
    1410:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1413:	6a 01                	push   $0x1
    1415:	57                   	push   %edi
    1416:	56                   	push   %esi
    1417:	e8 67 fe ff ff       	call   1283 <write>
    141c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    141f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1422:	0f b6 13             	movzbl (%ebx),%edx
    1425:	83 c3 01             	add    $0x1,%ebx
    1428:	84 d2                	test   %dl,%dl
    142a:	74 24                	je     1450 <printf+0x80>
    c = fmt[i] & 0xff;
    142c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    142f:	85 c9                	test   %ecx,%ecx
    1431:	74 cd                	je     1400 <printf+0x30>
      }
    } else if(state == '%'){
    1433:	83 f9 25             	cmp    $0x25,%ecx
    1436:	75 ea                	jne    1422 <printf+0x52>
      if(c == 'd'){
    1438:	83 f8 25             	cmp    $0x25,%eax
    143b:	0f 84 07 01 00 00    	je     1548 <printf+0x178>
    1441:	83 e8 63             	sub    $0x63,%eax
    1444:	83 f8 15             	cmp    $0x15,%eax
    1447:	77 17                	ja     1460 <printf+0x90>
    1449:	ff 24 85 3c 17 00 00 	jmp    *0x173c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1450:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1453:	5b                   	pop    %ebx
    1454:	5e                   	pop    %esi
    1455:	5f                   	pop    %edi
    1456:	5d                   	pop    %ebp
    1457:	c3                   	ret    
    1458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    145f:	90                   	nop
  write(fd, &c, 1);
    1460:	83 ec 04             	sub    $0x4,%esp
    1463:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1466:	6a 01                	push   $0x1
    1468:	57                   	push   %edi
    1469:	56                   	push   %esi
    146a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    146e:	e8 10 fe ff ff       	call   1283 <write>
        putc(fd, c);
    1473:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1477:	83 c4 0c             	add    $0xc,%esp
    147a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    147d:	6a 01                	push   $0x1
    147f:	57                   	push   %edi
    1480:	56                   	push   %esi
    1481:	e8 fd fd ff ff       	call   1283 <write>
        putc(fd, c);
    1486:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1489:	31 c9                	xor    %ecx,%ecx
    148b:	eb 95                	jmp    1422 <printf+0x52>
    148d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1490:	83 ec 0c             	sub    $0xc,%esp
    1493:	b9 10 00 00 00       	mov    $0x10,%ecx
    1498:	6a 00                	push   $0x0
    149a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    149d:	8b 10                	mov    (%eax),%edx
    149f:	89 f0                	mov    %esi,%eax
    14a1:	e8 7a fe ff ff       	call   1320 <printint>
        ap++;
    14a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    14aa:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14ad:	31 c9                	xor    %ecx,%ecx
    14af:	e9 6e ff ff ff       	jmp    1422 <printf+0x52>
    14b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    14b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    14bb:	8b 10                	mov    (%eax),%edx
        ap++;
    14bd:	83 c0 04             	add    $0x4,%eax
    14c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    14c3:	85 d2                	test   %edx,%edx
    14c5:	0f 84 8d 00 00 00    	je     1558 <printf+0x188>
        while(*s != 0){
    14cb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    14ce:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    14d0:	84 c0                	test   %al,%al
    14d2:	0f 84 4a ff ff ff    	je     1422 <printf+0x52>
    14d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    14db:	89 d3                	mov    %edx,%ebx
    14dd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    14e0:	83 ec 04             	sub    $0x4,%esp
          s++;
    14e3:	83 c3 01             	add    $0x1,%ebx
    14e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    14e9:	6a 01                	push   $0x1
    14eb:	57                   	push   %edi
    14ec:	56                   	push   %esi
    14ed:	e8 91 fd ff ff       	call   1283 <write>
        while(*s != 0){
    14f2:	0f b6 03             	movzbl (%ebx),%eax
    14f5:	83 c4 10             	add    $0x10,%esp
    14f8:	84 c0                	test   %al,%al
    14fa:	75 e4                	jne    14e0 <printf+0x110>
      state = 0;
    14fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    14ff:	31 c9                	xor    %ecx,%ecx
    1501:	e9 1c ff ff ff       	jmp    1422 <printf+0x52>
    1506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    150d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    1510:	83 ec 0c             	sub    $0xc,%esp
    1513:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1518:	6a 01                	push   $0x1
    151a:	e9 7b ff ff ff       	jmp    149a <printf+0xca>
    151f:	90                   	nop
        putc(fd, *ap);
    1520:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1523:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1526:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1528:	6a 01                	push   $0x1
    152a:	57                   	push   %edi
    152b:	56                   	push   %esi
        putc(fd, *ap);
    152c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    152f:	e8 4f fd ff ff       	call   1283 <write>
        ap++;
    1534:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1538:	83 c4 10             	add    $0x10,%esp
      state = 0;
    153b:	31 c9                	xor    %ecx,%ecx
    153d:	e9 e0 fe ff ff       	jmp    1422 <printf+0x52>
    1542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1548:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    154b:	83 ec 04             	sub    $0x4,%esp
    154e:	e9 2a ff ff ff       	jmp    147d <printf+0xad>
    1553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1557:	90                   	nop
          s = "(null)";
    1558:	ba 34 17 00 00       	mov    $0x1734,%edx
        while(*s != 0){
    155d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1560:	b8 28 00 00 00       	mov    $0x28,%eax
    1565:	89 d3                	mov    %edx,%ebx
    1567:	e9 74 ff ff ff       	jmp    14e0 <printf+0x110>
    156c:	66 90                	xchg   %ax,%ax
    156e:	66 90                	xchg   %ax,%ax

00001570 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1570:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1571:	a1 6c 1a 00 00       	mov    0x1a6c,%eax
{
    1576:	89 e5                	mov    %esp,%ebp
    1578:	57                   	push   %edi
    1579:	56                   	push   %esi
    157a:	53                   	push   %ebx
    157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    157e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1588:	89 c2                	mov    %eax,%edx
    158a:	8b 00                	mov    (%eax),%eax
    158c:	39 ca                	cmp    %ecx,%edx
    158e:	73 30                	jae    15c0 <free+0x50>
    1590:	39 c1                	cmp    %eax,%ecx
    1592:	72 04                	jb     1598 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1594:	39 c2                	cmp    %eax,%edx
    1596:	72 f0                	jb     1588 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1598:	8b 73 fc             	mov    -0x4(%ebx),%esi
    159b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    159e:	39 f8                	cmp    %edi,%eax
    15a0:	74 30                	je     15d2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    15a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    15a5:	8b 42 04             	mov    0x4(%edx),%eax
    15a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    15ab:	39 f1                	cmp    %esi,%ecx
    15ad:	74 3a                	je     15e9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    15af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    15b1:	5b                   	pop    %ebx
  freep = p;
    15b2:	89 15 6c 1a 00 00    	mov    %edx,0x1a6c
}
    15b8:	5e                   	pop    %esi
    15b9:	5f                   	pop    %edi
    15ba:	5d                   	pop    %ebp
    15bb:	c3                   	ret    
    15bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15c0:	39 c2                	cmp    %eax,%edx
    15c2:	72 c4                	jb     1588 <free+0x18>
    15c4:	39 c1                	cmp    %eax,%ecx
    15c6:	73 c0                	jae    1588 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    15c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    15ce:	39 f8                	cmp    %edi,%eax
    15d0:	75 d0                	jne    15a2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    15d2:	03 70 04             	add    0x4(%eax),%esi
    15d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    15d8:	8b 02                	mov    (%edx),%eax
    15da:	8b 00                	mov    (%eax),%eax
    15dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    15df:	8b 42 04             	mov    0x4(%edx),%eax
    15e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    15e5:	39 f1                	cmp    %esi,%ecx
    15e7:	75 c6                	jne    15af <free+0x3f>
    p->s.size += bp->s.size;
    15e9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    15ec:	89 15 6c 1a 00 00    	mov    %edx,0x1a6c
    p->s.size += bp->s.size;
    15f2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    15f5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    15f8:	89 0a                	mov    %ecx,(%edx)
}
    15fa:	5b                   	pop    %ebx
    15fb:	5e                   	pop    %esi
    15fc:	5f                   	pop    %edi
    15fd:	5d                   	pop    %ebp
    15fe:	c3                   	ret    
    15ff:	90                   	nop

00001600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1600:	55                   	push   %ebp
    1601:	89 e5                	mov    %esp,%ebp
    1603:	57                   	push   %edi
    1604:	56                   	push   %esi
    1605:	53                   	push   %ebx
    1606:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1609:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    160c:	8b 3d 6c 1a 00 00    	mov    0x1a6c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1612:	8d 70 07             	lea    0x7(%eax),%esi
    1615:	c1 ee 03             	shr    $0x3,%esi
    1618:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    161b:	85 ff                	test   %edi,%edi
    161d:	0f 84 9d 00 00 00    	je     16c0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1623:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1625:	8b 4a 04             	mov    0x4(%edx),%ecx
    1628:	39 f1                	cmp    %esi,%ecx
    162a:	73 6a                	jae    1696 <malloc+0x96>
    162c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1631:	39 de                	cmp    %ebx,%esi
    1633:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1636:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    163d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1640:	eb 17                	jmp    1659 <malloc+0x59>
    1642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1648:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    164a:	8b 48 04             	mov    0x4(%eax),%ecx
    164d:	39 f1                	cmp    %esi,%ecx
    164f:	73 4f                	jae    16a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1651:	8b 3d 6c 1a 00 00    	mov    0x1a6c,%edi
    1657:	89 c2                	mov    %eax,%edx
    1659:	39 d7                	cmp    %edx,%edi
    165b:	75 eb                	jne    1648 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    165d:	83 ec 0c             	sub    $0xc,%esp
    1660:	ff 75 e4             	push   -0x1c(%ebp)
    1663:	e8 83 fc ff ff       	call   12eb <sbrk>
  if(p == (char*)-1)
    1668:	83 c4 10             	add    $0x10,%esp
    166b:	83 f8 ff             	cmp    $0xffffffff,%eax
    166e:	74 1c                	je     168c <malloc+0x8c>
  hp->s.size = nu;
    1670:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1673:	83 ec 0c             	sub    $0xc,%esp
    1676:	83 c0 08             	add    $0x8,%eax
    1679:	50                   	push   %eax
    167a:	e8 f1 fe ff ff       	call   1570 <free>
  return freep;
    167f:	8b 15 6c 1a 00 00    	mov    0x1a6c,%edx
      if((p = morecore(nunits)) == 0)
    1685:	83 c4 10             	add    $0x10,%esp
    1688:	85 d2                	test   %edx,%edx
    168a:	75 bc                	jne    1648 <malloc+0x48>
        return 0;
  }
}
    168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    168f:	31 c0                	xor    %eax,%eax
}
    1691:	5b                   	pop    %ebx
    1692:	5e                   	pop    %esi
    1693:	5f                   	pop    %edi
    1694:	5d                   	pop    %ebp
    1695:	c3                   	ret    
    if(p->s.size >= nunits){
    1696:	89 d0                	mov    %edx,%eax
    1698:	89 fa                	mov    %edi,%edx
    169a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    16a0:	39 ce                	cmp    %ecx,%esi
    16a2:	74 4c                	je     16f0 <malloc+0xf0>
        p->s.size -= nunits;
    16a4:	29 f1                	sub    %esi,%ecx
    16a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    16a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    16ac:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    16af:	89 15 6c 1a 00 00    	mov    %edx,0x1a6c
}
    16b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    16b8:	83 c0 08             	add    $0x8,%eax
}
    16bb:	5b                   	pop    %ebx
    16bc:	5e                   	pop    %esi
    16bd:	5f                   	pop    %edi
    16be:	5d                   	pop    %ebp
    16bf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    16c0:	c7 05 6c 1a 00 00 70 	movl   $0x1a70,0x1a6c
    16c7:	1a 00 00 
    base.s.size = 0;
    16ca:	bf 70 1a 00 00       	mov    $0x1a70,%edi
    base.s.ptr = freep = prevp = &base;
    16cf:	c7 05 70 1a 00 00 70 	movl   $0x1a70,0x1a70
    16d6:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    16db:	c7 05 74 1a 00 00 00 	movl   $0x0,0x1a74
    16e2:	00 00 00 
    if(p->s.size >= nunits){
    16e5:	e9 42 ff ff ff       	jmp    162c <malloc+0x2c>
    16ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    16f0:	8b 08                	mov    (%eax),%ecx
    16f2:	89 0a                	mov    %ecx,(%edx)
    16f4:	eb b9                	jmp    16af <malloc+0xaf>
    16f6:	66 90                	xchg   %ax,%ax
    16f8:	66 90                	xchg   %ax,%ax
    16fa:	66 90                	xchg   %ax,%ax
    16fc:	66 90                	xchg   %ax,%ax
    16fe:	66 90                	xchg   %ax,%ax

00001700 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1700:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1701:	b9 01 00 00 00       	mov    $0x1,%ecx
    1706:	89 e5                	mov    %esp,%ebp
    1708:	8b 55 08             	mov    0x8(%ebp),%edx
    170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    170f:	90                   	nop
    1710:	89 c8                	mov    %ecx,%eax
    1712:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1715:	85 c0                	test   %eax,%eax
    1717:	75 f7                	jne    1710 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1719:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    171e:	5d                   	pop    %ebp
    171f:	c3                   	ret    

00001720 <urelease>:

void urelease (struct uspinlock *lk) {
    1720:	55                   	push   %ebp
    1721:	89 e5                	mov    %esp,%ebp
    1723:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1726:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    172b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1731:	5d                   	pop    %ebp
    1732:	c3                   	ret    
