
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 be 39 10 80       	mov    $0x801039be,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 e0 8d 10 	movl   $0x80108de0,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 74 4f 00 00       	call   80104fc2 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 1d 11 80 7c 	movl   $0x80111d7c,0x80111dcc
80100055:	1d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 1d 11 80 7c 	movl   $0x80111d7c,0x80111dd0
8010005f:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 e7 8d 10 	movl   $0x80108de7,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 ed 4d 00 00       	call   80104e84 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000c9:	e8 15 4f 00 00       	call   80104fe3 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 44 4f 00 00       	call   8010504d <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 a7 4d 00 00       	call   80104ebe <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 1d 11 80       	mov    0x80111dcc,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017d:	e8 cb 4e 00 00       	call   8010504d <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 2e 4d 00 00       	call   80104ebe <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 ee 8d 10 80 	movl   $0x80108dee,(%esp)
801001ae:	e8 fa 04 00 00       	call   801006ad <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 0e 29 00 00       	call   80102af5 <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 5b 4d 00 00       	call   80104f5b <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 ff 8d 10 80 	movl   $0x80108dff,(%esp)
8010020b:	e8 9d 04 00 00       	call   801006ad <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 cb 28 00 00       	call   80102af5 <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 1b 4d 00 00       	call   80104f5b <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 06 8e 10 80 	movl   $0x80108e06,(%esp)
8010024b:	e8 5d 04 00 00       	call   801006ad <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 bb 4c 00 00       	call   80104f19 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100265:	e8 79 4d 00 00       	call   80104fe3 <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002d1:	e8 77 4d 00 00       	call   8010504d <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801002e8:	89 c2                	mov    %eax,%edx
801002ea:	ec                   	in     (%dx),%al
801002eb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ee:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801002f1:	c9                   	leave  
801002f2:	c3                   	ret    

801002f3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f3:	55                   	push   %ebp
801002f4:	89 e5                	mov    %esp,%ebp
801002f6:	83 ec 08             	sub    $0x8,%esp
801002f9:	8b 45 08             	mov    0x8(%ebp),%eax
801002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801002ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100303:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100306:	8a 45 f8             	mov    -0x8(%ebp),%al
80100309:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	c9                   	leave  
8010030e:	c3                   	ret    

8010030f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030f:	55                   	push   %ebp
80100310:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100312:	fa                   	cli    
}
80100313:	5d                   	pop    %ebp
80100314:	c3                   	ret    

80100315 <strcat>:
  int locking;
} cons;

char *
strcat(char *dest, const char *src)
{
80100315:	55                   	push   %ebp
80100316:	89 e5                	mov    %esp,%ebp
80100318:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
8010031b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80100322:	eb 03                	jmp    80100327 <strcat+0x12>
80100324:	ff 45 fc             	incl   -0x4(%ebp)
80100327:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010032a:	8b 45 08             	mov    0x8(%ebp),%eax
8010032d:	01 d0                	add    %edx,%eax
8010032f:	8a 00                	mov    (%eax),%al
80100331:	84 c0                	test   %al,%al
80100333:	75 ef                	jne    80100324 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
80100335:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010033c:	eb 1e                	jmp    8010035c <strcat+0x47>
        dest[i+j] = src[j];
8010033e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80100341:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100344:	01 d0                	add    %edx,%eax
80100346:	89 c2                	mov    %eax,%edx
80100348:	8b 45 08             	mov    0x8(%ebp),%eax
8010034b:	01 c2                	add    %eax,%edx
8010034d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80100350:	8b 45 0c             	mov    0xc(%ebp),%eax
80100353:	01 c8                	add    %ecx,%eax
80100355:	8a 00                	mov    (%eax),%al
80100357:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
80100359:	ff 45 f8             	incl   -0x8(%ebp)
8010035c:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010035f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100362:	01 d0                	add    %edx,%eax
80100364:	8a 00                	mov    (%eax),%al
80100366:	84 c0                	test   %al,%al
80100368:	75 d4                	jne    8010033e <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
8010036a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010036d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100370:	01 d0                	add    %edx,%eax
80100372:	89 c2                	mov    %eax,%edx
80100374:	8b 45 08             	mov    0x8(%ebp),%eax
80100377:	01 d0                	add    %edx,%eax
80100379:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
8010037c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010037f:	c9                   	leave  
80100380:	c3                   	ret    

80100381 <itoa>:

char* itoa(int num, char* str, int base)
{
80100381:	55                   	push   %ebp
80100382:	89 e5                	mov    %esp,%ebp
80100384:	83 ec 10             	sub    $0x10,%esp
    char temp;
    int rem, i = 0, j = 0;
80100387:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010038e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 
    if (num == 0)
80100395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100399:	75 26                	jne    801003c1 <itoa+0x40>
    {
        str[i++] = '0';
8010039b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010039e:	8d 50 01             	lea    0x1(%eax),%edx
801003a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
801003a4:	89 c2                	mov    %eax,%edx
801003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801003a9:	01 d0                	add    %edx,%eax
801003ab:	c6 00 30             	movb   $0x30,(%eax)
        str[i] = '\0';
801003ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
801003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801003b4:	01 d0                	add    %edx,%eax
801003b6:	c6 00 00             	movb   $0x0,(%eax)
        return str;
801003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801003bc:	e9 ab 00 00 00       	jmp    8010046c <itoa+0xeb>
    }
 
    while (num != 0)
801003c1:	eb 36                	jmp    801003f9 <itoa+0x78>
    {
        rem = num % base;
801003c3:	8b 45 08             	mov    0x8(%ebp),%eax
801003c6:	99                   	cltd   
801003c7:	f7 7d 10             	idivl  0x10(%ebp)
801003ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
        if(rem > 9)
801003cd:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
801003d1:	7e 04                	jle    801003d7 <itoa+0x56>
        {
            rem = rem - 10;
801003d3:	83 6d fc 0a          	subl   $0xa,-0x4(%ebp)
        }
        /* Add the digit as a string */
        str[i++] = rem + '0';
801003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801003da:	8d 50 01             	lea    0x1(%eax),%edx
801003dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
801003e0:	89 c2                	mov    %eax,%edx
801003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801003e5:	01 c2                	add    %eax,%edx
801003e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801003ea:	83 c0 30             	add    $0x30,%eax
801003ed:	88 02                	mov    %al,(%edx)
        num = num/base;
801003ef:	8b 45 08             	mov    0x8(%ebp),%eax
801003f2:	99                   	cltd   
801003f3:	f7 7d 10             	idivl  0x10(%ebp)
801003f6:	89 45 08             	mov    %eax,0x8(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
 
    while (num != 0)
801003f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801003fd:	75 c4                	jne    801003c3 <itoa+0x42>
        /* Add the digit as a string */
        str[i++] = rem + '0';
        num = num/base;
    }

    str[i] = '\0';
801003ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
80100402:	8b 45 0c             	mov    0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	c6 00 00             	movb   $0x0,(%eax)

    for(j = 0; j < i / 2; j++)
8010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100411:	eb 45                	jmp    80100458 <itoa+0xd7>
    {
        temp = str[j];
80100413:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100416:	8b 45 0c             	mov    0xc(%ebp),%eax
80100419:	01 d0                	add    %edx,%eax
8010041b:	8a 00                	mov    (%eax),%al
8010041d:	88 45 f3             	mov    %al,-0xd(%ebp)
        str[j] = str[i - j - 1];
80100420:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100423:	8b 45 0c             	mov    0xc(%ebp),%eax
80100426:	01 c2                	add    %eax,%edx
80100428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
8010042e:	29 c1                	sub    %eax,%ecx
80100430:	89 c8                	mov    %ecx,%eax
80100432:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100435:	8b 45 0c             	mov    0xc(%ebp),%eax
80100438:	01 c8                	add    %ecx,%eax
8010043a:	8a 00                	mov    (%eax),%al
8010043c:	88 02                	mov    %al,(%edx)
        str[i - j - 1] = temp;
8010043e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100441:	8b 55 f8             	mov    -0x8(%ebp),%edx
80100444:	29 c2                	sub    %eax,%edx
80100446:	89 d0                	mov    %edx,%eax
80100448:	8d 50 ff             	lea    -0x1(%eax),%edx
8010044b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010044e:	01 c2                	add    %eax,%edx
80100450:	8a 45 f3             	mov    -0xd(%ebp),%al
80100453:	88 02                	mov    %al,(%edx)
        num = num/base;
    }

    str[i] = '\0';

    for(j = 0; j < i / 2; j++)
80100455:	ff 45 f4             	incl   -0xc(%ebp)
80100458:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010045b:	89 c2                	mov    %eax,%edx
8010045d:	c1 ea 1f             	shr    $0x1f,%edx
80100460:	01 d0                	add    %edx,%eax
80100462:	d1 f8                	sar    %eax
80100464:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100467:	7f aa                	jg     80100413 <itoa+0x92>
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
 
    return str;
80100469:	8b 45 0c             	mov    0xc(%ebp),%eax
}
8010046c:	c9                   	leave  
8010046d:	c3                   	ret    

8010046e <printint>:

static void
printint(int xx, int base, int sign)
{
8010046e:	55                   	push   %ebp
8010046f:	89 e5                	mov    %esp,%ebp
80100471:	56                   	push   %esi
80100472:	53                   	push   %ebx
80100473:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010047a:	74 1c                	je     80100498 <printint+0x2a>
8010047c:	8b 45 08             	mov    0x8(%ebp),%eax
8010047f:	c1 e8 1f             	shr    $0x1f,%eax
80100482:	0f b6 c0             	movzbl %al,%eax
80100485:	89 45 10             	mov    %eax,0x10(%ebp)
80100488:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010048c:	74 0a                	je     80100498 <printint+0x2a>
    x = -xx;
8010048e:	8b 45 08             	mov    0x8(%ebp),%eax
80100491:	f7 d8                	neg    %eax
80100493:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100496:	eb 06                	jmp    8010049e <printint+0x30>
  else
    x = xx;
80100498:	8b 45 08             	mov    0x8(%ebp),%eax
8010049b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010049e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801004a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801004a8:	8d 41 01             	lea    0x1(%ecx),%eax
801004ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801004ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b4:	ba 00 00 00 00       	mov    $0x0,%edx
801004b9:	f7 f3                	div    %ebx
801004bb:	89 d0                	mov    %edx,%eax
801004bd:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
801004c3:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
801004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801004ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004cd:	ba 00 00 00 00       	mov    $0x0,%edx
801004d2:	f7 f6                	div    %esi
801004d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801004d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801004db:	75 c8                	jne    801004a5 <printint+0x37>

  if(sign)
801004dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801004e1:	74 10                	je     801004f3 <printint+0x85>
    buf[i++] = '-';
801004e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004e6:	8d 50 01             	lea    0x1(%eax),%edx
801004e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
801004ec:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801004f1:	eb 17                	jmp    8010050a <printint+0x9c>
801004f3:	eb 15                	jmp    8010050a <printint+0x9c>
    consputc(buf[i]);
801004f5:	8d 55 e0             	lea    -0x20(%ebp),%edx
801004f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004fb:	01 d0                	add    %edx,%eax
801004fd:	8a 00                	mov    (%eax),%al
801004ff:	0f be c0             	movsbl %al,%eax
80100502:	89 04 24             	mov    %eax,(%esp)
80100505:	e8 b7 03 00 00       	call   801008c1 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010050a:	ff 4d f4             	decl   -0xc(%ebp)
8010050d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100511:	79 e2                	jns    801004f5 <printint+0x87>
    consputc(buf[i]);
}
80100513:	83 c4 30             	add    $0x30,%esp
80100516:	5b                   	pop    %ebx
80100517:	5e                   	pop    %esi
80100518:	5d                   	pop    %ebp
80100519:	c3                   	ret    

8010051a <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010051a:	55                   	push   %ebp
8010051b:	89 e5                	mov    %esp,%ebp
8010051d:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100520:	a1 14 c6 10 80       	mov    0x8010c614,%eax
80100525:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100528:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052c:	74 0c                	je     8010053a <cprintf+0x20>
    acquire(&cons.lock);
8010052e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100535:	e8 a9 4a 00 00       	call   80104fe3 <acquire>

  if (fmt == 0)
8010053a:	8b 45 08             	mov    0x8(%ebp),%eax
8010053d:	85 c0                	test   %eax,%eax
8010053f:	75 0c                	jne    8010054d <cprintf+0x33>
    panic("null fmt");
80100541:	c7 04 24 0d 8e 10 80 	movl   $0x80108e0d,(%esp)
80100548:	e8 60 01 00 00       	call   801006ad <panic>

  argp = (uint*)(void*)(&fmt + 1);
8010054d:	8d 45 0c             	lea    0xc(%ebp),%eax
80100550:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010055a:	e9 1b 01 00 00       	jmp    8010067a <cprintf+0x160>
    if(c != '%'){
8010055f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100563:	74 10                	je     80100575 <cprintf+0x5b>
      consputc(c);
80100565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100568:	89 04 24             	mov    %eax,(%esp)
8010056b:	e8 51 03 00 00       	call   801008c1 <consputc>
      continue;
80100570:	e9 02 01 00 00       	jmp    80100677 <cprintf+0x15d>
    }
    c = fmt[++i] & 0xff;
80100575:	8b 55 08             	mov    0x8(%ebp),%edx
80100578:	ff 45 f4             	incl   -0xc(%ebp)
8010057b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010057e:	01 d0                	add    %edx,%eax
80100580:	8a 00                	mov    (%eax),%al
80100582:	0f be c0             	movsbl %al,%eax
80100585:	25 ff 00 00 00       	and    $0xff,%eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010058d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100591:	75 05                	jne    80100598 <cprintf+0x7e>
      break;
80100593:	e9 01 01 00 00       	jmp    80100699 <cprintf+0x17f>
    switch(c){
80100598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010059b:	83 f8 70             	cmp    $0x70,%eax
8010059e:	74 4f                	je     801005ef <cprintf+0xd5>
801005a0:	83 f8 70             	cmp    $0x70,%eax
801005a3:	7f 13                	jg     801005b8 <cprintf+0x9e>
801005a5:	83 f8 25             	cmp    $0x25,%eax
801005a8:	0f 84 a3 00 00 00    	je     80100651 <cprintf+0x137>
801005ae:	83 f8 64             	cmp    $0x64,%eax
801005b1:	74 14                	je     801005c7 <cprintf+0xad>
801005b3:	e9 a7 00 00 00       	jmp    8010065f <cprintf+0x145>
801005b8:	83 f8 73             	cmp    $0x73,%eax
801005bb:	74 57                	je     80100614 <cprintf+0xfa>
801005bd:	83 f8 78             	cmp    $0x78,%eax
801005c0:	74 2d                	je     801005ef <cprintf+0xd5>
801005c2:	e9 98 00 00 00       	jmp    8010065f <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
801005c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801005ca:	8d 50 04             	lea    0x4(%eax),%edx
801005cd:	89 55 f0             	mov    %edx,-0x10(%ebp)
801005d0:	8b 00                	mov    (%eax),%eax
801005d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801005d9:	00 
801005da:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801005e1:	00 
801005e2:	89 04 24             	mov    %eax,(%esp)
801005e5:	e8 84 fe ff ff       	call   8010046e <printint>
      break;
801005ea:	e9 88 00 00 00       	jmp    80100677 <cprintf+0x15d>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801005ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801005f2:	8d 50 04             	lea    0x4(%eax),%edx
801005f5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801005f8:	8b 00                	mov    (%eax),%eax
801005fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100601:	00 
80100602:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100609:	00 
8010060a:	89 04 24             	mov    %eax,(%esp)
8010060d:	e8 5c fe ff ff       	call   8010046e <printint>
      break;
80100612:	eb 63                	jmp    80100677 <cprintf+0x15d>
    case 's':
      if((s = (char*)*argp++) == 0)
80100614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100617:	8d 50 04             	lea    0x4(%eax),%edx
8010061a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010061d:	8b 00                	mov    (%eax),%eax
8010061f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100622:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100626:	75 09                	jne    80100631 <cprintf+0x117>
        s = "(null)";
80100628:	c7 45 ec 16 8e 10 80 	movl   $0x80108e16,-0x14(%ebp)
      for(; *s; s++)
8010062f:	eb 15                	jmp    80100646 <cprintf+0x12c>
80100631:	eb 13                	jmp    80100646 <cprintf+0x12c>
        consputc(*s);
80100633:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100636:	8a 00                	mov    (%eax),%al
80100638:	0f be c0             	movsbl %al,%eax
8010063b:	89 04 24             	mov    %eax,(%esp)
8010063e:	e8 7e 02 00 00       	call   801008c1 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100643:	ff 45 ec             	incl   -0x14(%ebp)
80100646:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100649:	8a 00                	mov    (%eax),%al
8010064b:	84 c0                	test   %al,%al
8010064d:	75 e4                	jne    80100633 <cprintf+0x119>
        consputc(*s);
      break;
8010064f:	eb 26                	jmp    80100677 <cprintf+0x15d>
    case '%':
      consputc('%');
80100651:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100658:	e8 64 02 00 00       	call   801008c1 <consputc>
      break;
8010065d:	eb 18                	jmp    80100677 <cprintf+0x15d>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010065f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100666:	e8 56 02 00 00       	call   801008c1 <consputc>
      consputc(c);
8010066b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010066e:	89 04 24             	mov    %eax,(%esp)
80100671:	e8 4b 02 00 00       	call   801008c1 <consputc>
      break;
80100676:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100677:	ff 45 f4             	incl   -0xc(%ebp)
8010067a:	8b 55 08             	mov    0x8(%ebp),%edx
8010067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100680:	01 d0                	add    %edx,%eax
80100682:	8a 00                	mov    (%eax),%al
80100684:	0f be c0             	movsbl %al,%eax
80100687:	25 ff 00 00 00       	and    $0xff,%eax
8010068c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010068f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100693:	0f 85 c6 fe ff ff    	jne    8010055f <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100699:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010069d:	74 0c                	je     801006ab <cprintf+0x191>
    release(&cons.lock);
8010069f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801006a6:	e8 a2 49 00 00       	call   8010504d <release>
}
801006ab:	c9                   	leave  
801006ac:	c3                   	ret    

801006ad <panic>:

void
panic(char *s)
{
801006ad:	55                   	push   %ebp
801006ae:	89 e5                	mov    %esp,%ebp
801006b0:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
801006b3:	e8 57 fc ff ff       	call   8010030f <cli>
  cons.locking = 0;
801006b8:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
801006bf:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801006c2:	e8 ca 2a 00 00       	call   80103191 <lapicid>
801006c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801006cb:	c7 04 24 1d 8e 10 80 	movl   $0x80108e1d,(%esp)
801006d2:	e8 43 fe ff ff       	call   8010051a <cprintf>
  cprintf(s);
801006d7:	8b 45 08             	mov    0x8(%ebp),%eax
801006da:	89 04 24             	mov    %eax,(%esp)
801006dd:	e8 38 fe ff ff       	call   8010051a <cprintf>
  cprintf("\n");
801006e2:	c7 04 24 31 8e 10 80 	movl   $0x80108e31,(%esp)
801006e9:	e8 2c fe ff ff       	call   8010051a <cprintf>
  getcallerpcs(&s, pcs);
801006ee:	8d 45 cc             	lea    -0x34(%ebp),%eax
801006f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801006f5:	8d 45 08             	lea    0x8(%ebp),%eax
801006f8:	89 04 24             	mov    %eax,(%esp)
801006fb:	e8 9a 49 00 00       	call   8010509a <getcallerpcs>
  for(i=0; i<10; i++)
80100700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100707:	eb 1a                	jmp    80100723 <panic+0x76>
    cprintf(" %p", pcs[i]);
80100709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010070c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100710:	89 44 24 04          	mov    %eax,0x4(%esp)
80100714:	c7 04 24 33 8e 10 80 	movl   $0x80108e33,(%esp)
8010071b:	e8 fa fd ff ff       	call   8010051a <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
80100720:	ff 45 f4             	incl   -0xc(%ebp)
80100723:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100727:	7e e0                	jle    80100709 <panic+0x5c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100729:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80100730:	00 00 00 
  for(;;)
    ;
80100733:	eb fe                	jmp    80100733 <panic+0x86>

80100735 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100735:	55                   	push   %ebp
80100736:	89 e5                	mov    %esp,%ebp
80100738:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010073b:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100742:	00 
80100743:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010074a:	e8 a4 fb ff ff       	call   801002f3 <outb>
  pos = inb(CRTPORT+1) << 8;
8010074f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100756:	e8 7d fb ff ff       	call   801002d8 <inb>
8010075b:	0f b6 c0             	movzbl %al,%eax
8010075e:	c1 e0 08             	shl    $0x8,%eax
80100761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100764:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010076b:	00 
8010076c:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100773:	e8 7b fb ff ff       	call   801002f3 <outb>
  pos |= inb(CRTPORT+1);
80100778:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010077f:	e8 54 fb ff ff       	call   801002d8 <inb>
80100784:	0f b6 c0             	movzbl %al,%eax
80100787:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010078a:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010078e:	75 1b                	jne    801007ab <cgaputc+0x76>
    pos += 80 - pos%80;
80100790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100793:	b9 50 00 00 00       	mov    $0x50,%ecx
80100798:	99                   	cltd   
80100799:	f7 f9                	idiv   %ecx
8010079b:	89 d0                	mov    %edx,%eax
8010079d:	ba 50 00 00 00       	mov    $0x50,%edx
801007a2:	29 c2                	sub    %eax,%edx
801007a4:	89 d0                	mov    %edx,%eax
801007a6:	01 45 f4             	add    %eax,-0xc(%ebp)
801007a9:	eb 34                	jmp    801007df <cgaputc+0xaa>
  else if(c == BACKSPACE){
801007ab:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b2:	75 0b                	jne    801007bf <cgaputc+0x8a>
    if(pos > 0) --pos;
801007b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801007b8:	7e 25                	jle    801007df <cgaputc+0xaa>
801007ba:	ff 4d f4             	decl   -0xc(%ebp)
801007bd:	eb 20                	jmp    801007df <cgaputc+0xaa>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801007bf:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c8:	8d 50 01             	lea    0x1(%eax),%edx
801007cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
801007ce:	01 c0                	add    %eax,%eax
801007d0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801007d3:	8b 45 08             	mov    0x8(%ebp),%eax
801007d6:	0f b6 c0             	movzbl %al,%eax
801007d9:	80 cc 07             	or     $0x7,%ah
801007dc:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801007df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801007e3:	78 09                	js     801007ee <cgaputc+0xb9>
801007e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801007ec:	7e 0c                	jle    801007fa <cgaputc+0xc5>
    panic("pos under/overflow");
801007ee:	c7 04 24 37 8e 10 80 	movl   $0x80108e37,(%esp)
801007f5:	e8 b3 fe ff ff       	call   801006ad <panic>

  if((pos/80) >= 24){  // Scroll up.
801007fa:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100801:	7e 53                	jle    80100856 <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100803:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100808:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010080e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100813:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
8010081a:	00 
8010081b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010081f:	89 04 24             	mov    %eax,(%esp)
80100822:	e8 e8 4a 00 00       	call   8010530f <memmove>
    pos -= 80;
80100827:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010082b:	b8 80 07 00 00       	mov    $0x780,%eax
80100830:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100833:	01 c0                	add    %eax,%eax
80100835:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010083b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010083e:	01 d2                	add    %edx,%edx
80100840:	01 ca                	add    %ecx,%edx
80100842:	89 44 24 08          	mov    %eax,0x8(%esp)
80100846:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010084d:	00 
8010084e:	89 14 24             	mov    %edx,(%esp)
80100851:	e8 f0 49 00 00       	call   80105246 <memset>
  }

  outb(CRTPORT, 14);
80100856:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
8010085d:	00 
8010085e:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100865:	e8 89 fa ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos>>8);
8010086a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010086d:	c1 f8 08             	sar    $0x8,%eax
80100870:	0f b6 c0             	movzbl %al,%eax
80100873:	89 44 24 04          	mov    %eax,0x4(%esp)
80100877:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010087e:	e8 70 fa ff ff       	call   801002f3 <outb>
  outb(CRTPORT, 15);
80100883:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010088a:	00 
8010088b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100892:	e8 5c fa ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos);
80100897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010089a:	0f b6 c0             	movzbl %al,%eax
8010089d:	89 44 24 04          	mov    %eax,0x4(%esp)
801008a1:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801008a8:	e8 46 fa ff ff       	call   801002f3 <outb>
  crt[pos] = ' ' | 0x0700;
801008ad:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b6:	01 c0                	add    %eax,%eax
801008b8:	01 d0                	add    %edx,%eax
801008ba:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801008bf:	c9                   	leave  
801008c0:	c3                   	ret    

801008c1 <consputc>:

void
consputc(int c)
{
801008c1:	55                   	push   %ebp
801008c2:	89 e5                	mov    %esp,%ebp
801008c4:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
801008c7:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
801008cc:	85 c0                	test   %eax,%eax
801008ce:	74 07                	je     801008d7 <consputc+0x16>
    cli();
801008d0:	e8 3a fa ff ff       	call   8010030f <cli>
    for(;;)
      ;
801008d5:	eb fe                	jmp    801008d5 <consputc+0x14>
  }

  if(c == BACKSPACE){
801008d7:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801008de:	75 26                	jne    80100906 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801008e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801008e7:	e8 8c 68 00 00       	call   80107178 <uartputc>
801008ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801008f3:	e8 80 68 00 00       	call   80107178 <uartputc>
801008f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801008ff:	e8 74 68 00 00       	call   80107178 <uartputc>
80100904:	eb 0b                	jmp    80100911 <consputc+0x50>
  } else
    uartputc(c);
80100906:	8b 45 08             	mov    0x8(%ebp),%eax
80100909:	89 04 24             	mov    %eax,(%esp)
8010090c:	e8 67 68 00 00       	call   80107178 <uartputc>
  cgaputc(c);
80100911:	8b 45 08             	mov    0x8(%ebp),%eax
80100914:	89 04 24             	mov    %eax,(%esp)
80100917:	e8 19 fe ff ff       	call   80100735 <cgaputc>
}
8010091c:	c9                   	leave  
8010091d:	c3                   	ret    

8010091e <copy_buf>:

#define C(x)  ((x)-'@')  // Control-x


void copy_buf(char *dst, char *src, int len)
{
8010091e:	55                   	push   %ebp
8010091f:	89 e5                	mov    %esp,%ebp
80100921:	83 ec 10             	sub    $0x10,%esp
  int i;

  for (i = 0; i < len; i++) {
80100924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010092b:	eb 17                	jmp    80100944 <copy_buf+0x26>
    dst[i] = src[i];
8010092d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100930:	8b 45 08             	mov    0x8(%ebp),%eax
80100933:	01 c2                	add    %eax,%edx
80100935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
80100938:	8b 45 0c             	mov    0xc(%ebp),%eax
8010093b:	01 c8                	add    %ecx,%eax
8010093d:	8a 00                	mov    (%eax),%al
8010093f:	88 02                	mov    %al,(%edx)

void copy_buf(char *dst, char *src, int len)
{
  int i;

  for (i = 0; i < len; i++) {
80100941:	ff 45 fc             	incl   -0x4(%ebp)
80100944:	8b 45 fc             	mov    -0x4(%ebp),%eax
80100947:	3b 45 10             	cmp    0x10(%ebp),%eax
8010094a:	7c e1                	jl     8010092d <copy_buf+0xf>
    dst[i] = src[i];
  }
}
8010094c:	c9                   	leave  
8010094d:	c3                   	ret    

8010094e <consoleintr>:

void
consoleintr(int (*getc)(void))
{
8010094e:	55                   	push   %ebp
8010094f:	89 e5                	mov    %esp,%ebp
80100951:	57                   	push   %edi
80100952:	56                   	push   %esi
80100953:	53                   	push   %ebx
80100954:	83 ec 5c             	sub    $0x5c,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
80100957:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010095e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  acquire(&cons.lock);
80100965:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010096c:	e8 72 46 00 00       	call   80104fe3 <acquire>
  while((c = getc()) >= 0){
80100971:	e9 2e 02 00 00       	jmp    80100ba4 <consoleintr+0x256>
    switch(c){
80100976:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100979:	83 f8 14             	cmp    $0x14,%eax
8010097c:	74 3b                	je     801009b9 <consoleintr+0x6b>
8010097e:	83 f8 14             	cmp    $0x14,%eax
80100981:	7f 13                	jg     80100996 <consoleintr+0x48>
80100983:	83 f8 08             	cmp    $0x8,%eax
80100986:	0f 84 5b 01 00 00    	je     80100ae7 <consoleintr+0x199>
8010098c:	83 f8 10             	cmp    $0x10,%eax
8010098f:	74 1c                	je     801009ad <consoleintr+0x5f>
80100991:	e9 81 01 00 00       	jmp    80100b17 <consoleintr+0x1c9>
80100996:	83 f8 15             	cmp    $0x15,%eax
80100999:	0f 84 20 01 00 00    	je     80100abf <consoleintr+0x171>
8010099f:	83 f8 7f             	cmp    $0x7f,%eax
801009a2:	0f 84 3f 01 00 00    	je     80100ae7 <consoleintr+0x199>
801009a8:	e9 6a 01 00 00       	jmp    80100b17 <consoleintr+0x1c9>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
801009ad:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
801009b4:	e9 eb 01 00 00       	jmp    80100ba4 <consoleintr+0x256>
    case C('T'):  // Process listing.
      inputs[active] = input;
801009b9:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
801009bf:	89 d0                	mov    %edx,%eax
801009c1:	c1 e0 02             	shl    $0x2,%eax
801009c4:	01 d0                	add    %edx,%eax
801009c6:	c1 e0 02             	shl    $0x2,%eax
801009c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801009d0:	29 c2                	sub    %eax,%edx
801009d2:	8d 82 20 22 11 80    	lea    -0x7feedde0(%edx),%eax
801009d8:	89 c2                	mov    %eax,%edx
801009da:	bb e0 1f 11 80       	mov    $0x80111fe0,%ebx
801009df:	b8 23 00 00 00       	mov    $0x23,%eax
801009e4:	89 d7                	mov    %edx,%edi
801009e6:	89 de                	mov    %ebx,%esi
801009e8:	89 c1                	mov    %eax,%ecx
801009ea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      active = (active + 1) % (NUM_VCS + 1);
801009ec:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
801009f1:	40                   	inc    %eax
801009f2:	b9 05 00 00 00       	mov    $0x5,%ecx
801009f7:	99                   	cltd   
801009f8:	f7 f9                	idiv   %ecx
801009fa:	89 d0                	mov    %edx,%eax
801009fc:	a3 c4 c5 10 80       	mov    %eax,0x8010c5c4
      input = inputs[active];
80100a01:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
80100a07:	89 d0                	mov    %edx,%eax
80100a09:	c1 e0 02             	shl    $0x2,%eax
80100a0c:	01 d0                	add    %edx,%eax
80100a0e:	c1 e0 02             	shl    $0x2,%eax
80100a11:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100a18:	29 c2                	sub    %eax,%edx
80100a1a:	8d 82 20 22 11 80    	lea    -0x7feedde0(%edx),%eax
80100a20:	ba e0 1f 11 80       	mov    $0x80111fe0,%edx
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	b8 23 00 00 00       	mov    $0x23,%eax
80100a2c:	89 d7                	mov    %edx,%edi
80100a2e:	89 de                	mov    %ebx,%esi
80100a30:	89 c1                	mov    %eax,%ecx
80100a32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      doconsoleswitch = 1;
80100a34:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      char fs[4];
      if(active > 0){
80100a3b:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
80100a40:	85 c0                	test   %eax,%eax
80100a42:	7e 4a                	jle    80100a8e <consoleintr+0x140>
        char active_string[32];
        itoa(active, active_string, 10);
80100a44:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
80100a49:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
80100a50:	00 
80100a51:	8d 55 b4             	lea    -0x4c(%ebp),%edx
80100a54:	89 54 24 04          	mov    %edx,0x4(%esp)
80100a58:	89 04 24             	mov    %eax,(%esp)
80100a5b:	e8 21 f9 ff ff       	call   80100381 <itoa>
        char vc[4];
        vc[0] = 'v';
80100a60:	c6 45 d4 76          	movb   $0x76,-0x2c(%ebp)
        vc[1] = 'c';
80100a64:	c6 45 d5 63          	movb   $0x63,-0x2b(%ebp)
        strcat(vc, active_string);
80100a68:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80100a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a6f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80100a72:	89 04 24             	mov    %eax,(%esp)
80100a75:	e8 9b f8 ff ff       	call   80100315 <strcat>
        getvcfs(vc, fs);
80100a7a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80100a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a81:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80100a84:	89 04 24             	mov    %eax,(%esp)
80100a87:	e8 51 82 00 00       	call   80108cdd <getvcfs>
80100a8c:	eb 08                	jmp    80100a96 <consoleintr+0x148>
      }else{
        fs[0] = '/';
80100a8e:	c6 45 d8 2f          	movb   $0x2f,-0x28(%ebp)
        fs[1] = '\0';
80100a92:	c6 45 d9 00          	movb   $0x0,-0x27(%ebp)
      }
      setactivefs(fs);
80100a96:	8d 45 d8             	lea    -0x28(%ebp),%eax
80100a99:	89 04 24             	mov    %eax,(%esp)
80100a9c:	e8 d1 82 00 00       	call   80108d72 <setactivefs>
      break;
80100aa1:	e9 fe 00 00 00       	jmp    80100ba4 <consoleintr+0x256>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100aa6:	a1 68 20 11 80       	mov    0x80112068,%eax
80100aab:	48                   	dec    %eax
80100aac:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
80100ab1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100ab8:	e8 04 fe ff ff       	call   801008c1 <consputc>
80100abd:	eb 01                	jmp    80100ac0 <consoleintr+0x172>
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100abf:	90                   	nop
80100ac0:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100ac6:	a1 64 20 11 80       	mov    0x80112064,%eax
80100acb:	39 c2                	cmp    %eax,%edx
80100acd:	74 13                	je     80100ae2 <consoleintr+0x194>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100acf:	a1 68 20 11 80       	mov    0x80112068,%eax
80100ad4:	48                   	dec    %eax
80100ad5:	83 e0 7f             	and    $0x7f,%eax
80100ad8:	8a 80 e0 1f 11 80    	mov    -0x7feee020(%eax),%al
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100ade:	3c 0a                	cmp    $0xa,%al
80100ae0:	75 c4                	jne    80100aa6 <consoleintr+0x158>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100ae2:	e9 bd 00 00 00       	jmp    80100ba4 <consoleintr+0x256>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100ae7:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100aed:	a1 64 20 11 80       	mov    0x80112064,%eax
80100af2:	39 c2                	cmp    %eax,%edx
80100af4:	74 1c                	je     80100b12 <consoleintr+0x1c4>
        input.e--;
80100af6:	a1 68 20 11 80       	mov    0x80112068,%eax
80100afb:	48                   	dec    %eax
80100afc:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
80100b01:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100b08:	e8 b4 fd ff ff       	call   801008c1 <consputc>
      }
      break;
80100b0d:	e9 92 00 00 00       	jmp    80100ba4 <consoleintr+0x256>
80100b12:	e9 8d 00 00 00       	jmp    80100ba4 <consoleintr+0x256>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b17:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100b1b:	0f 84 82 00 00 00    	je     80100ba3 <consoleintr+0x255>
80100b21:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100b27:	a1 60 20 11 80       	mov    0x80112060,%eax
80100b2c:	29 c2                	sub    %eax,%edx
80100b2e:	89 d0                	mov    %edx,%eax
80100b30:	83 f8 7f             	cmp    $0x7f,%eax
80100b33:	77 6e                	ja     80100ba3 <consoleintr+0x255>
        c = (c == '\r') ? '\n' : c;
80100b35:	83 7d dc 0d          	cmpl   $0xd,-0x24(%ebp)
80100b39:	74 05                	je     80100b40 <consoleintr+0x1f2>
80100b3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100b3e:	eb 05                	jmp    80100b45 <consoleintr+0x1f7>
80100b40:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b45:	89 45 dc             	mov    %eax,-0x24(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100b48:	a1 68 20 11 80       	mov    0x80112068,%eax
80100b4d:	8d 50 01             	lea    0x1(%eax),%edx
80100b50:	89 15 68 20 11 80    	mov    %edx,0x80112068
80100b56:	83 e0 7f             	and    $0x7f,%eax
80100b59:	89 c2                	mov    %eax,%edx
80100b5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100b5e:	88 82 e0 1f 11 80    	mov    %al,-0x7feee020(%edx)
        consputc(c);
80100b64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100b67:	89 04 24             	mov    %eax,(%esp)
80100b6a:	e8 52 fd ff ff       	call   801008c1 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b6f:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
80100b73:	74 18                	je     80100b8d <consoleintr+0x23f>
80100b75:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
80100b79:	74 12                	je     80100b8d <consoleintr+0x23f>
80100b7b:	a1 68 20 11 80       	mov    0x80112068,%eax
80100b80:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100b86:	83 ea 80             	sub    $0xffffff80,%edx
80100b89:	39 d0                	cmp    %edx,%eax
80100b8b:	75 16                	jne    80100ba3 <consoleintr+0x255>
          input.w = input.e;
80100b8d:	a1 68 20 11 80       	mov    0x80112068,%eax
80100b92:	a3 64 20 11 80       	mov    %eax,0x80112064
          wakeup(&input.r);
80100b97:	c7 04 24 60 20 11 80 	movl   $0x80112060,(%esp)
80100b9e:	e8 45 41 00 00       	call   80104ce8 <wakeup>
        }
      }
      break;
80100ba3:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ba7:	ff d0                	call   *%eax
80100ba9:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100bac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100bb0:	0f 89 c0 fd ff ff    	jns    80100976 <consoleintr+0x28>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100bb6:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100bbd:	e8 8b 44 00 00       	call   8010504d <release>
  if(doprocdump){
80100bc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100bc6:	74 05                	je     80100bcd <consoleintr+0x27f>
    procdump();  // now call procdump() wo. cons.lock held
80100bc8:	e8 be 41 00 00       	call   80104d8b <procdump>
  }
  if(doconsoleswitch){
80100bcd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100bd1:	74 15                	je     80100be8 <consoleintr+0x29a>
    cprintf("\nActive console now: %d\n", active);
80100bd3:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
80100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bdc:	c7 04 24 4a 8e 10 80 	movl   $0x80108e4a,(%esp)
80100be3:	e8 32 f9 ff ff       	call   8010051a <cprintf>
  }
}
80100be8:	83 c4 5c             	add    $0x5c,%esp
80100beb:	5b                   	pop    %ebx
80100bec:	5e                   	pop    %esi
80100bed:	5f                   	pop    %edi
80100bee:	5d                   	pop    %ebp
80100bef:	c3                   	ret    

80100bf0 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100bf0:	55                   	push   %ebp
80100bf1:	89 e5                	mov    %esp,%ebp
80100bf3:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80100bf9:	89 04 24             	mov    %eax,(%esp)
80100bfc:	e8 eb 10 00 00       	call   80101cec <iunlock>
  target = n;
80100c01:	8b 45 10             	mov    0x10(%ebp),%eax
80100c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100c07:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100c0e:	e8 d0 43 00 00       	call   80104fe3 <acquire>
  while(n > 0){
80100c13:	e9 b8 00 00 00       	jmp    80100cd0 <consoleread+0xe0>
    while((input.r == input.w) || (active != ip->minor-1)){
80100c18:	eb 41                	jmp    80100c5b <consoleread+0x6b>
      if(myproc()->killed){
80100c1a:	e8 b4 37 00 00       	call   801043d3 <myproc>
80100c1f:	8b 40 24             	mov    0x24(%eax),%eax
80100c22:	85 c0                	test   %eax,%eax
80100c24:	74 21                	je     80100c47 <consoleread+0x57>
        release(&cons.lock);
80100c26:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100c2d:	e8 1b 44 00 00       	call   8010504d <release>
        ilock(ip);
80100c32:	8b 45 08             	mov    0x8(%ebp),%eax
80100c35:	89 04 24             	mov    %eax,(%esp)
80100c38:	e8 a5 0f 00 00       	call   80101be2 <ilock>
        return -1;
80100c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c42:	e9 b4 00 00 00       	jmp    80100cfb <consoleread+0x10b>
      }
      sleep(&input.r, &cons.lock);
80100c47:	c7 44 24 04 e0 c5 10 	movl   $0x8010c5e0,0x4(%esp)
80100c4e:	80 
80100c4f:	c7 04 24 60 20 11 80 	movl   $0x80112060,(%esp)
80100c56:	e8 b9 3f 00 00       	call   80104c14 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while((input.r == input.w) || (active != ip->minor-1)){
80100c5b:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100c61:	a1 64 20 11 80       	mov    0x80112064,%eax
80100c66:	39 c2                	cmp    %eax,%edx
80100c68:	74 b0                	je     80100c1a <consoleread+0x2a>
80100c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80100c6d:	8b 40 54             	mov    0x54(%eax),%eax
80100c70:	98                   	cwtl   
80100c71:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c74:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
80100c79:	39 c2                	cmp    %eax,%edx
80100c7b:	75 9d                	jne    80100c1a <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100c7d:	a1 60 20 11 80       	mov    0x80112060,%eax
80100c82:	8d 50 01             	lea    0x1(%eax),%edx
80100c85:	89 15 60 20 11 80    	mov    %edx,0x80112060
80100c8b:	83 e0 7f             	and    $0x7f,%eax
80100c8e:	8a 80 e0 1f 11 80    	mov    -0x7feee020(%eax),%al
80100c94:	0f be c0             	movsbl %al,%eax
80100c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100c9a:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100c9e:	75 17                	jne    80100cb7 <consoleread+0xc7>
      if(n < target){
80100ca0:	8b 45 10             	mov    0x10(%ebp),%eax
80100ca3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ca6:	73 0d                	jae    80100cb5 <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ca8:	a1 60 20 11 80       	mov    0x80112060,%eax
80100cad:	48                   	dec    %eax
80100cae:	a3 60 20 11 80       	mov    %eax,0x80112060
      }
      break;
80100cb3:	eb 25                	jmp    80100cda <consoleread+0xea>
80100cb5:	eb 23                	jmp    80100cda <consoleread+0xea>
    }
    *dst++ = c;
80100cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cba:	8d 50 01             	lea    0x1(%eax),%edx
80100cbd:	89 55 0c             	mov    %edx,0xc(%ebp)
80100cc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100cc3:	88 10                	mov    %dl,(%eax)
    --n;
80100cc5:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100cc8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ccc:	75 02                	jne    80100cd0 <consoleread+0xe0>
      break;
80100cce:	eb 0a                	jmp    80100cda <consoleread+0xea>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100cd4:	0f 8f 3e ff ff ff    	jg     80100c18 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100cda:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100ce1:	e8 67 43 00 00       	call   8010504d <release>
  ilock(ip);
80100ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ce9:	89 04 24             	mov    %eax,(%esp)
80100cec:	e8 f1 0e 00 00       	call   80101be2 <ilock>

  return target - n;
80100cf1:	8b 45 10             	mov    0x10(%ebp),%eax
80100cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100cf7:	29 c2                	sub    %eax,%edx
80100cf9:	89 d0                	mov    %edx,%eax
}
80100cfb:	c9                   	leave  
80100cfc:	c3                   	ret    

80100cfd <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100cfd:	55                   	push   %ebp
80100cfe:	89 e5                	mov    %esp,%ebp
80100d00:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor-1){
80100d03:	8b 45 08             	mov    0x8(%ebp),%eax
80100d06:	8b 40 54             	mov    0x54(%eax),%eax
80100d09:	98                   	cwtl   
80100d0a:	8d 50 ff             	lea    -0x1(%eax),%edx
80100d0d:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
80100d12:	39 c2                	cmp    %eax,%edx
80100d14:	75 5a                	jne    80100d70 <consolewrite+0x73>
    iunlock(ip);
80100d16:	8b 45 08             	mov    0x8(%ebp),%eax
80100d19:	89 04 24             	mov    %eax,(%esp)
80100d1c:	e8 cb 0f 00 00       	call   80101cec <iunlock>
    acquire(&cons.lock);
80100d21:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100d28:	e8 b6 42 00 00       	call   80104fe3 <acquire>
    for(i = 0; i < n; i++)
80100d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100d34:	eb 1b                	jmp    80100d51 <consolewrite+0x54>
      consputc(buf[i] & 0xff);
80100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3c:	01 d0                	add    %edx,%eax
80100d3e:	8a 00                	mov    (%eax),%al
80100d40:	0f be c0             	movsbl %al,%eax
80100d43:	0f b6 c0             	movzbl %al,%eax
80100d46:	89 04 24             	mov    %eax,(%esp)
80100d49:	e8 73 fb ff ff       	call   801008c1 <consputc>
  int i;

  if (active == ip->minor-1){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100d4e:	ff 45 f4             	incl   -0xc(%ebp)
80100d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100d54:	3b 45 10             	cmp    0x10(%ebp),%eax
80100d57:	7c dd                	jl     80100d36 <consolewrite+0x39>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100d59:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100d60:	e8 e8 42 00 00       	call   8010504d <release>
    ilock(ip);
80100d65:	8b 45 08             	mov    0x8(%ebp),%eax
80100d68:	89 04 24             	mov    %eax,(%esp)
80100d6b:	e8 72 0e 00 00       	call   80101be2 <ilock>
  }
  return n;
80100d70:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100d73:	c9                   	leave  
80100d74:	c3                   	ret    

80100d75 <consoleinit>:

void
consoleinit(void)
{
80100d75:	55                   	push   %ebp
80100d76:	89 e5                	mov    %esp,%ebp
80100d78:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100d7b:	c7 44 24 04 63 8e 10 	movl   $0x80108e63,0x4(%esp)
80100d82:	80 
80100d83:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100d8a:	e8 33 42 00 00       	call   80104fc2 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100d8f:	c7 05 8c 2e 11 80 fd 	movl   $0x80100cfd,0x80112e8c
80100d96:	0c 10 80 
  devsw[CONSOLE].read = consoleread;
80100d99:	c7 05 88 2e 11 80 f0 	movl   $0x80100bf0,0x80112e88
80100da0:	0b 10 80 
  cons.locking = 1;
80100da3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100daa:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100dad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100db4:	00 
80100db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100dbc:	e8 e6 1e 00 00       	call   80102ca7 <ioapicenable>
}
80100dc1:	c9                   	leave  
80100dc2:	c3                   	ret    
	...

80100dc4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100dc4:	55                   	push   %ebp
80100dc5:	89 e5                	mov    %esp,%ebp
80100dc7:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100dcd:	e8 01 36 00 00       	call   801043d3 <myproc>
80100dd2:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100dd5:	e8 01 29 00 00       	call   801036db <begin_op>

  if((ip = namei(path)) == 0){
80100dda:	8b 45 08             	mov    0x8(%ebp),%eax
80100ddd:	89 04 24             	mov    %eax,(%esp)
80100de0:	e8 22 19 00 00       	call   80102707 <namei>
80100de5:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100de8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100dec:	75 1b                	jne    80100e09 <exec+0x45>
    end_op();
80100dee:	e8 6a 29 00 00       	call   8010375d <end_op>
    cprintf("exec: fail\n");
80100df3:	c7 04 24 6b 8e 10 80 	movl   $0x80108e6b,(%esp)
80100dfa:	e8 1b f7 ff ff       	call   8010051a <cprintf>
    return -1;
80100dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e04:	e9 f6 03 00 00       	jmp    801011ff <exec+0x43b>
  }
  ilock(ip);
80100e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100e0c:	89 04 24             	mov    %eax,(%esp)
80100e0f:	e8 ce 0d 00 00       	call   80101be2 <ilock>
  pgdir = 0;
80100e14:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e1b:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100e22:	00 
80100e23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100e2a:	00 
80100e2b:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100e31:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e35:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100e38:	89 04 24             	mov    %eax,(%esp)
80100e3b:	e8 39 12 00 00       	call   80102079 <readi>
80100e40:	83 f8 34             	cmp    $0x34,%eax
80100e43:	74 05                	je     80100e4a <exec+0x86>
    goto bad;
80100e45:	e9 89 03 00 00       	jmp    801011d3 <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100e4a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100e50:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100e55:	74 05                	je     80100e5c <exec+0x98>
    goto bad;
80100e57:	e9 77 03 00 00       	jmp    801011d3 <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100e5c:	e8 f9 72 00 00       	call   8010815a <setupkvm>
80100e61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100e68:	75 05                	jne    80100e6f <exec+0xab>
    goto bad;
80100e6a:	e9 64 03 00 00       	jmp    801011d3 <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100e6f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100e7d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100e83:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100e86:	e9 fb 00 00 00       	jmp    80100f86 <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e8e:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100e95:	00 
80100e96:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e9a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ea4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ea7:	89 04 24             	mov    %eax,(%esp)
80100eaa:	e8 ca 11 00 00       	call   80102079 <readi>
80100eaf:	83 f8 20             	cmp    $0x20,%eax
80100eb2:	74 05                	je     80100eb9 <exec+0xf5>
      goto bad;
80100eb4:	e9 1a 03 00 00       	jmp    801011d3 <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100eb9:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100ebf:	83 f8 01             	cmp    $0x1,%eax
80100ec2:	74 05                	je     80100ec9 <exec+0x105>
      continue;
80100ec4:	e9 b1 00 00 00       	jmp    80100f7a <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100ec9:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100ecf:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100ed5:	39 c2                	cmp    %eax,%edx
80100ed7:	73 05                	jae    80100ede <exec+0x11a>
      goto bad;
80100ed9:	e9 f5 02 00 00       	jmp    801011d3 <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ede:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ee4:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100eea:	01 c2                	add    %eax,%edx
80100eec:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ef2:	39 c2                	cmp    %eax,%edx
80100ef4:	73 05                	jae    80100efb <exec+0x137>
      goto bad;
80100ef6:	e9 d8 02 00 00       	jmp    801011d3 <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100efb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100f01:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100f07:	01 d0                	add    %edx,%eax
80100f09:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f10:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f17:	89 04 24             	mov    %eax,(%esp)
80100f1a:	e8 07 76 00 00       	call   80108526 <allocuvm>
80100f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100f26:	75 05                	jne    80100f2d <exec+0x169>
      goto bad;
80100f28:	e9 a6 02 00 00       	jmp    801011d3 <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100f2d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f33:	25 ff 0f 00 00       	and    $0xfff,%eax
80100f38:	85 c0                	test   %eax,%eax
80100f3a:	74 05                	je     80100f41 <exec+0x17d>
      goto bad;
80100f3c:	e9 92 02 00 00       	jmp    801011d3 <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f41:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100f47:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100f4d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f53:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100f57:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100f5b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100f5e:	89 54 24 08          	mov    %edx,0x8(%esp)
80100f62:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f69:	89 04 24             	mov    %eax,(%esp)
80100f6c:	e8 d2 74 00 00       	call   80108443 <loaduvm>
80100f71:	85 c0                	test   %eax,%eax
80100f73:	79 05                	jns    80100f7a <exec+0x1b6>
      goto bad;
80100f75:	e9 59 02 00 00       	jmp    801011d3 <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f7a:	ff 45 ec             	incl   -0x14(%ebp)
80100f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100f80:	83 c0 20             	add    $0x20,%eax
80100f83:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100f86:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100f8c:	0f b7 c0             	movzwl %ax,%eax
80100f8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100f92:	0f 8f f3 fe ff ff    	jg     80100e8b <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100f98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f9b:	89 04 24             	mov    %eax,(%esp)
80100f9e:	e8 3e 0e 00 00       	call   80101de1 <iunlockput>
  end_op();
80100fa3:	e8 b5 27 00 00       	call   8010375d <end_op>
  ip = 0;
80100fa8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fb2:	05 ff 0f 00 00       	add    $0xfff,%eax
80100fb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100fbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100fbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fc2:	05 00 20 00 00       	add    $0x2000,%eax
80100fc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fce:	89 44 24 04          	mov    %eax,0x4(%esp)
80100fd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100fd5:	89 04 24             	mov    %eax,(%esp)
80100fd8:	e8 49 75 00 00       	call   80108526 <allocuvm>
80100fdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100fe0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100fe4:	75 05                	jne    80100feb <exec+0x227>
    goto bad;
80100fe6:	e9 e8 01 00 00       	jmp    801011d3 <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100feb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fee:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ff7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ffa:	89 04 24             	mov    %eax,(%esp)
80100ffd:	e8 94 77 00 00       	call   80108796 <clearpteu>
  sp = sz;
80101002:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101005:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101008:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010100f:	e9 95 00 00 00       	jmp    801010a9 <exec+0x2e5>
    if(argc >= MAXARG)
80101014:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80101018:	76 05                	jbe    8010101f <exec+0x25b>
      goto bad;
8010101a:	e9 b4 01 00 00       	jmp    801011d3 <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010101f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101022:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010102c:	01 d0                	add    %edx,%eax
8010102e:	8b 00                	mov    (%eax),%eax
80101030:	89 04 24             	mov    %eax,(%esp)
80101033:	e8 61 44 00 00       	call   80105499 <strlen>
80101038:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010103b:	29 c2                	sub    %eax,%edx
8010103d:	89 d0                	mov    %edx,%eax
8010103f:	48                   	dec    %eax
80101040:	83 e0 fc             	and    $0xfffffffc,%eax
80101043:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101049:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101050:	8b 45 0c             	mov    0xc(%ebp),%eax
80101053:	01 d0                	add    %edx,%eax
80101055:	8b 00                	mov    (%eax),%eax
80101057:	89 04 24             	mov    %eax,(%esp)
8010105a:	e8 3a 44 00 00       	call   80105499 <strlen>
8010105f:	40                   	inc    %eax
80101060:	89 c2                	mov    %eax,%edx
80101062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101065:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
8010106c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010106f:	01 c8                	add    %ecx,%eax
80101071:	8b 00                	mov    (%eax),%eax
80101073:	89 54 24 0c          	mov    %edx,0xc(%esp)
80101077:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010107e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101082:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101085:	89 04 24             	mov    %eax,(%esp)
80101088:	e8 c1 78 00 00       	call   8010894e <copyout>
8010108d:	85 c0                	test   %eax,%eax
8010108f:	79 05                	jns    80101096 <exec+0x2d2>
      goto bad;
80101091:	e9 3d 01 00 00       	jmp    801011d3 <exec+0x40f>
    ustack[3+argc] = sp;
80101096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101099:	8d 50 03             	lea    0x3(%eax),%edx
8010109c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010109f:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
801010a6:	ff 45 e4             	incl   -0x1c(%ebp)
801010a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b6:	01 d0                	add    %edx,%eax
801010b8:	8b 00                	mov    (%eax),%eax
801010ba:	85 c0                	test   %eax,%eax
801010bc:	0f 85 52 ff ff ff    	jne    80101014 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
801010c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010c5:	83 c0 03             	add    $0x3,%eax
801010c8:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
801010cf:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
801010d3:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
801010da:	ff ff ff 
  ustack[1] = argc;
801010dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010e0:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010e9:	40                   	inc    %eax
801010ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801010f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010f4:	29 d0                	sub    %edx,%eax
801010f6:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
801010fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010ff:	83 c0 04             	add    $0x4,%eax
80101102:	c1 e0 02             	shl    $0x2,%eax
80101105:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010110b:	83 c0 04             	add    $0x4,%eax
8010110e:	c1 e0 02             	shl    $0x2,%eax
80101111:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101115:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
8010111b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010111f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101122:	89 44 24 04          	mov    %eax,0x4(%esp)
80101126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101129:	89 04 24             	mov    %eax,(%esp)
8010112c:	e8 1d 78 00 00       	call   8010894e <copyout>
80101131:	85 c0                	test   %eax,%eax
80101133:	79 05                	jns    8010113a <exec+0x376>
    goto bad;
80101135:	e9 99 00 00 00       	jmp    801011d3 <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010113a:	8b 45 08             	mov    0x8(%ebp),%eax
8010113d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101143:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101146:	eb 13                	jmp    8010115b <exec+0x397>
    if(*s == '/')
80101148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010114b:	8a 00                	mov    (%eax),%al
8010114d:	3c 2f                	cmp    $0x2f,%al
8010114f:	75 07                	jne    80101158 <exec+0x394>
      last = s+1;
80101151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101154:	40                   	inc    %eax
80101155:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101158:	ff 45 f4             	incl   -0xc(%ebp)
8010115b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010115e:	8a 00                	mov    (%eax),%al
80101160:	84 c0                	test   %al,%al
80101162:	75 e4                	jne    80101148 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101164:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101167:	8d 50 6c             	lea    0x6c(%eax),%edx
8010116a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101171:	00 
80101172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101175:	89 44 24 04          	mov    %eax,0x4(%esp)
80101179:	89 14 24             	mov    %edx,(%esp)
8010117c:	e8 d1 42 00 00       	call   80105452 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80101181:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101184:	8b 40 04             	mov    0x4(%eax),%eax
80101187:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
8010118a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010118d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101190:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80101193:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101196:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101199:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
8010119b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010119e:	8b 40 18             	mov    0x18(%eax),%eax
801011a1:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
801011a7:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801011aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
801011ad:	8b 40 18             	mov    0x18(%eax),%eax
801011b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801011b3:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
801011b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801011b9:	89 04 24             	mov    %eax,(%esp)
801011bc:	e8 73 70 00 00       	call   80108234 <switchuvm>
  freevm(oldpgdir);
801011c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801011c4:	89 04 24             	mov    %eax,(%esp)
801011c7:	e8 34 75 00 00       	call   80108700 <freevm>
  return 0;
801011cc:	b8 00 00 00 00       	mov    $0x0,%eax
801011d1:	eb 2c                	jmp    801011ff <exec+0x43b>

 bad:
  if(pgdir)
801011d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801011d7:	74 0b                	je     801011e4 <exec+0x420>
    freevm(pgdir);
801011d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011dc:	89 04 24             	mov    %eax,(%esp)
801011df:	e8 1c 75 00 00       	call   80108700 <freevm>
  if(ip){
801011e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801011e8:	74 10                	je     801011fa <exec+0x436>
    iunlockput(ip);
801011ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011ed:	89 04 24             	mov    %eax,(%esp)
801011f0:	e8 ec 0b 00 00       	call   80101de1 <iunlockput>
    end_op();
801011f5:	e8 63 25 00 00       	call   8010375d <end_op>
  }
  return -1;
801011fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011ff:	c9                   	leave  
80101200:	c3                   	ret    
80101201:	00 00                	add    %al,(%eax)
	...

80101204 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101204:	55                   	push   %ebp
80101205:	89 e5                	mov    %esp,%ebp
80101207:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
8010120a:	c7 44 24 04 77 8e 10 	movl   $0x80108e77,0x4(%esp)
80101211:	80 
80101212:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
80101219:	e8 a4 3d 00 00       	call   80104fc2 <initlock>
}
8010121e:	c9                   	leave  
8010121f:	c3                   	ret    

80101220 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101226:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
8010122d:	e8 b1 3d 00 00       	call   80104fe3 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101232:	c7 45 f4 14 25 11 80 	movl   $0x80112514,-0xc(%ebp)
80101239:	eb 29                	jmp    80101264 <filealloc+0x44>
    if(f->ref == 0){
8010123b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010123e:	8b 40 04             	mov    0x4(%eax),%eax
80101241:	85 c0                	test   %eax,%eax
80101243:	75 1b                	jne    80101260 <filealloc+0x40>
      f->ref = 1;
80101245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101248:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010124f:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
80101256:	e8 f2 3d 00 00       	call   8010504d <release>
      return f;
8010125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010125e:	eb 1e                	jmp    8010127e <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101260:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101264:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
8010126b:	72 ce                	jb     8010123b <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010126d:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
80101274:	e8 d4 3d 00 00       	call   8010504d <release>
  return 0;
80101279:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010127e:	c9                   	leave  
8010127f:	c3                   	ret    

80101280 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80101286:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
8010128d:	e8 51 3d 00 00       	call   80104fe3 <acquire>
  if(f->ref < 1)
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	8b 40 04             	mov    0x4(%eax),%eax
80101298:	85 c0                	test   %eax,%eax
8010129a:	7f 0c                	jg     801012a8 <filedup+0x28>
    panic("filedup");
8010129c:	c7 04 24 7e 8e 10 80 	movl   $0x80108e7e,(%esp)
801012a3:	e8 05 f4 ff ff       	call   801006ad <panic>
  f->ref++;
801012a8:	8b 45 08             	mov    0x8(%ebp),%eax
801012ab:	8b 40 04             	mov    0x4(%eax),%eax
801012ae:	8d 50 01             	lea    0x1(%eax),%edx
801012b1:	8b 45 08             	mov    0x8(%ebp),%eax
801012b4:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801012b7:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
801012be:	e8 8a 3d 00 00       	call   8010504d <release>
  return f;
801012c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801012c6:	c9                   	leave  
801012c7:	c3                   	ret    

801012c8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801012c8:	55                   	push   %ebp
801012c9:	89 e5                	mov    %esp,%ebp
801012cb:	57                   	push   %edi
801012cc:	56                   	push   %esi
801012cd:	53                   	push   %ebx
801012ce:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
801012d1:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
801012d8:	e8 06 3d 00 00       	call   80104fe3 <acquire>
  if(f->ref < 1)
801012dd:	8b 45 08             	mov    0x8(%ebp),%eax
801012e0:	8b 40 04             	mov    0x4(%eax),%eax
801012e3:	85 c0                	test   %eax,%eax
801012e5:	7f 0c                	jg     801012f3 <fileclose+0x2b>
    panic("fileclose");
801012e7:	c7 04 24 86 8e 10 80 	movl   $0x80108e86,(%esp)
801012ee:	e8 ba f3 ff ff       	call   801006ad <panic>
  if(--f->ref > 0){
801012f3:	8b 45 08             	mov    0x8(%ebp),%eax
801012f6:	8b 40 04             	mov    0x4(%eax),%eax
801012f9:	8d 50 ff             	lea    -0x1(%eax),%edx
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	89 50 04             	mov    %edx,0x4(%eax)
80101302:	8b 45 08             	mov    0x8(%ebp),%eax
80101305:	8b 40 04             	mov    0x4(%eax),%eax
80101308:	85 c0                	test   %eax,%eax
8010130a:	7e 0e                	jle    8010131a <fileclose+0x52>
    release(&ftable.lock);
8010130c:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
80101313:	e8 35 3d 00 00       	call   8010504d <release>
80101318:	eb 70                	jmp    8010138a <fileclose+0xc2>
    return;
  }
  ff = *f;
8010131a:	8b 45 08             	mov    0x8(%ebp),%eax
8010131d:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101320:	89 c3                	mov    %eax,%ebx
80101322:	b8 06 00 00 00       	mov    $0x6,%eax
80101327:	89 d7                	mov    %edx,%edi
80101329:	89 de                	mov    %ebx,%esi
8010132b:	89 c1                	mov    %eax,%ecx
8010132d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010132f:	8b 45 08             	mov    0x8(%ebp),%eax
80101332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101339:	8b 45 08             	mov    0x8(%ebp),%eax
8010133c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101342:	c7 04 24 e0 24 11 80 	movl   $0x801124e0,(%esp)
80101349:	e8 ff 3c 00 00       	call   8010504d <release>

  if(ff.type == FD_PIPE)
8010134e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101351:	83 f8 01             	cmp    $0x1,%eax
80101354:	75 17                	jne    8010136d <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
80101356:	8a 45 d9             	mov    -0x27(%ebp),%al
80101359:	0f be d0             	movsbl %al,%edx
8010135c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010135f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101363:	89 04 24             	mov    %eax,(%esp)
80101366:	e8 00 2d 00 00       	call   8010406b <pipeclose>
8010136b:	eb 1d                	jmp    8010138a <fileclose+0xc2>
  else if(ff.type == FD_INODE){
8010136d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101370:	83 f8 02             	cmp    $0x2,%eax
80101373:	75 15                	jne    8010138a <fileclose+0xc2>
    begin_op();
80101375:	e8 61 23 00 00       	call   801036db <begin_op>
    iput(ff.ip);
8010137a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010137d:	89 04 24             	mov    %eax,(%esp)
80101380:	e8 ab 09 00 00       	call   80101d30 <iput>
    end_op();
80101385:	e8 d3 23 00 00       	call   8010375d <end_op>
  }
}
8010138a:	83 c4 3c             	add    $0x3c,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    

80101392 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101392:	55                   	push   %ebp
80101393:	89 e5                	mov    %esp,%ebp
80101395:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	8b 00                	mov    (%eax),%eax
8010139d:	83 f8 02             	cmp    $0x2,%eax
801013a0:	75 38                	jne    801013da <filestat+0x48>
    ilock(f->ip);
801013a2:	8b 45 08             	mov    0x8(%ebp),%eax
801013a5:	8b 40 10             	mov    0x10(%eax),%eax
801013a8:	89 04 24             	mov    %eax,(%esp)
801013ab:	e8 32 08 00 00       	call   80101be2 <ilock>
    stati(f->ip, st);
801013b0:	8b 45 08             	mov    0x8(%ebp),%eax
801013b3:	8b 40 10             	mov    0x10(%eax),%eax
801013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bd:	89 04 24             	mov    %eax,(%esp)
801013c0:	e8 70 0c 00 00       	call   80102035 <stati>
    iunlock(f->ip);
801013c5:	8b 45 08             	mov    0x8(%ebp),%eax
801013c8:	8b 40 10             	mov    0x10(%eax),%eax
801013cb:	89 04 24             	mov    %eax,(%esp)
801013ce:	e8 19 09 00 00       	call   80101cec <iunlock>
    return 0;
801013d3:	b8 00 00 00 00       	mov    $0x0,%eax
801013d8:	eb 05                	jmp    801013df <filestat+0x4d>
  }
  return -1;
801013da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013df:	c9                   	leave  
801013e0:	c3                   	ret    

801013e1 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801013e1:	55                   	push   %ebp
801013e2:	89 e5                	mov    %esp,%ebp
801013e4:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801013e7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ea:	8a 40 08             	mov    0x8(%eax),%al
801013ed:	84 c0                	test   %al,%al
801013ef:	75 0a                	jne    801013fb <fileread+0x1a>
    return -1;
801013f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013f6:	e9 9f 00 00 00       	jmp    8010149a <fileread+0xb9>
  if(f->type == FD_PIPE)
801013fb:	8b 45 08             	mov    0x8(%ebp),%eax
801013fe:	8b 00                	mov    (%eax),%eax
80101400:	83 f8 01             	cmp    $0x1,%eax
80101403:	75 1e                	jne    80101423 <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101405:	8b 45 08             	mov    0x8(%ebp),%eax
80101408:	8b 40 0c             	mov    0xc(%eax),%eax
8010140b:	8b 55 10             	mov    0x10(%ebp),%edx
8010140e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101412:	8b 55 0c             	mov    0xc(%ebp),%edx
80101415:	89 54 24 04          	mov    %edx,0x4(%esp)
80101419:	89 04 24             	mov    %eax,(%esp)
8010141c:	e8 c8 2d 00 00       	call   801041e9 <piperead>
80101421:	eb 77                	jmp    8010149a <fileread+0xb9>
  if(f->type == FD_INODE){
80101423:	8b 45 08             	mov    0x8(%ebp),%eax
80101426:	8b 00                	mov    (%eax),%eax
80101428:	83 f8 02             	cmp    $0x2,%eax
8010142b:	75 61                	jne    8010148e <fileread+0xad>
    ilock(f->ip);
8010142d:	8b 45 08             	mov    0x8(%ebp),%eax
80101430:	8b 40 10             	mov    0x10(%eax),%eax
80101433:	89 04 24             	mov    %eax,(%esp)
80101436:	e8 a7 07 00 00       	call   80101be2 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010143b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010143e:	8b 45 08             	mov    0x8(%ebp),%eax
80101441:	8b 50 14             	mov    0x14(%eax),%edx
80101444:	8b 45 08             	mov    0x8(%ebp),%eax
80101447:	8b 40 10             	mov    0x10(%eax),%eax
8010144a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010144e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101452:	8b 55 0c             	mov    0xc(%ebp),%edx
80101455:	89 54 24 04          	mov    %edx,0x4(%esp)
80101459:	89 04 24             	mov    %eax,(%esp)
8010145c:	e8 18 0c 00 00       	call   80102079 <readi>
80101461:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101468:	7e 11                	jle    8010147b <fileread+0x9a>
      f->off += r;
8010146a:	8b 45 08             	mov    0x8(%ebp),%eax
8010146d:	8b 50 14             	mov    0x14(%eax),%edx
80101470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101473:	01 c2                	add    %eax,%edx
80101475:	8b 45 08             	mov    0x8(%ebp),%eax
80101478:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010147b:	8b 45 08             	mov    0x8(%ebp),%eax
8010147e:	8b 40 10             	mov    0x10(%eax),%eax
80101481:	89 04 24             	mov    %eax,(%esp)
80101484:	e8 63 08 00 00       	call   80101cec <iunlock>
    return r;
80101489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148c:	eb 0c                	jmp    8010149a <fileread+0xb9>
  }
  panic("fileread");
8010148e:	c7 04 24 90 8e 10 80 	movl   $0x80108e90,(%esp)
80101495:	e8 13 f2 ff ff       	call   801006ad <panic>
}
8010149a:	c9                   	leave  
8010149b:	c3                   	ret    

8010149c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010149c:	55                   	push   %ebp
8010149d:	89 e5                	mov    %esp,%ebp
8010149f:	53                   	push   %ebx
801014a0:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801014a3:	8b 45 08             	mov    0x8(%ebp),%eax
801014a6:	8a 40 09             	mov    0x9(%eax),%al
801014a9:	84 c0                	test   %al,%al
801014ab:	75 0a                	jne    801014b7 <filewrite+0x1b>
    return -1;
801014ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014b2:	e9 20 01 00 00       	jmp    801015d7 <filewrite+0x13b>
  if(f->type == FD_PIPE)
801014b7:	8b 45 08             	mov    0x8(%ebp),%eax
801014ba:	8b 00                	mov    (%eax),%eax
801014bc:	83 f8 01             	cmp    $0x1,%eax
801014bf:	75 21                	jne    801014e2 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801014c1:	8b 45 08             	mov    0x8(%ebp),%eax
801014c4:	8b 40 0c             	mov    0xc(%eax),%eax
801014c7:	8b 55 10             	mov    0x10(%ebp),%edx
801014ca:	89 54 24 08          	mov    %edx,0x8(%esp)
801014ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801014d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801014d5:	89 04 24             	mov    %eax,(%esp)
801014d8:	e8 20 2c 00 00       	call   801040fd <pipewrite>
801014dd:	e9 f5 00 00 00       	jmp    801015d7 <filewrite+0x13b>
  if(f->type == FD_INODE){
801014e2:	8b 45 08             	mov    0x8(%ebp),%eax
801014e5:	8b 00                	mov    (%eax),%eax
801014e7:	83 f8 02             	cmp    $0x2,%eax
801014ea:	0f 85 db 00 00 00    	jne    801015cb <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801014f0:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801014f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801014fe:	e9 a8 00 00 00       	jmp    801015ab <filewrite+0x10f>
      int n1 = n - i;
80101503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101506:	8b 55 10             	mov    0x10(%ebp),%edx
80101509:	29 c2                	sub    %eax,%edx
8010150b:	89 d0                	mov    %edx,%eax
8010150d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101513:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101516:	7e 06                	jle    8010151e <filewrite+0x82>
        n1 = max;
80101518:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010151b:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010151e:	e8 b8 21 00 00       	call   801036db <begin_op>
      ilock(f->ip);
80101523:	8b 45 08             	mov    0x8(%ebp),%eax
80101526:	8b 40 10             	mov    0x10(%eax),%eax
80101529:	89 04 24             	mov    %eax,(%esp)
8010152c:	e8 b1 06 00 00       	call   80101be2 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101531:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101534:	8b 45 08             	mov    0x8(%ebp),%eax
80101537:	8b 50 14             	mov    0x14(%eax),%edx
8010153a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010153d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101540:	01 c3                	add    %eax,%ebx
80101542:	8b 45 08             	mov    0x8(%ebp),%eax
80101545:	8b 40 10             	mov    0x10(%eax),%eax
80101548:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010154c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101550:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101554:	89 04 24             	mov    %eax,(%esp)
80101557:	e8 81 0c 00 00       	call   801021dd <writei>
8010155c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010155f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101563:	7e 11                	jle    80101576 <filewrite+0xda>
        f->off += r;
80101565:	8b 45 08             	mov    0x8(%ebp),%eax
80101568:	8b 50 14             	mov    0x14(%eax),%edx
8010156b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010156e:	01 c2                	add    %eax,%edx
80101570:	8b 45 08             	mov    0x8(%ebp),%eax
80101573:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101576:	8b 45 08             	mov    0x8(%ebp),%eax
80101579:	8b 40 10             	mov    0x10(%eax),%eax
8010157c:	89 04 24             	mov    %eax,(%esp)
8010157f:	e8 68 07 00 00       	call   80101cec <iunlock>
      end_op();
80101584:	e8 d4 21 00 00       	call   8010375d <end_op>

      if(r < 0)
80101589:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010158d:	79 02                	jns    80101591 <filewrite+0xf5>
        break;
8010158f:	eb 26                	jmp    801015b7 <filewrite+0x11b>
      if(r != n1)
80101591:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101594:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101597:	74 0c                	je     801015a5 <filewrite+0x109>
        panic("short filewrite");
80101599:	c7 04 24 99 8e 10 80 	movl   $0x80108e99,(%esp)
801015a0:	e8 08 f1 ff ff       	call   801006ad <panic>
      i += r;
801015a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801015a8:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801015b1:	0f 8c 4c ff ff ff    	jl     80101503 <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ba:	3b 45 10             	cmp    0x10(%ebp),%eax
801015bd:	75 05                	jne    801015c4 <filewrite+0x128>
801015bf:	8b 45 10             	mov    0x10(%ebp),%eax
801015c2:	eb 05                	jmp    801015c9 <filewrite+0x12d>
801015c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015c9:	eb 0c                	jmp    801015d7 <filewrite+0x13b>
  }
  panic("filewrite");
801015cb:	c7 04 24 a9 8e 10 80 	movl   $0x80108ea9,(%esp)
801015d2:	e8 d6 f0 ff ff       	call   801006ad <panic>
}
801015d7:	83 c4 24             	add    $0x24,%esp
801015da:	5b                   	pop    %ebx
801015db:	5d                   	pop    %ebp
801015dc:	c3                   	ret    
801015dd:	00 00                	add    %al,(%eax)
	...

801015e0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801015e6:	8b 45 08             	mov    0x8(%ebp),%eax
801015e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801015f0:	00 
801015f1:	89 04 24             	mov    %eax,(%esp)
801015f4:	e8 bc eb ff ff       	call   801001b5 <bread>
801015f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ff:	83 c0 5c             	add    $0x5c,%eax
80101602:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101609:	00 
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 f6 3c 00 00       	call   8010530f <memmove>
  brelse(bp);
80101619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161c:	89 04 24             	mov    %eax,(%esp)
8010161f:	e8 08 ec ff ff       	call   8010022c <brelse>
}
80101624:	c9                   	leave  
80101625:	c3                   	ret    

80101626 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101626:	55                   	push   %ebp
80101627:	89 e5                	mov    %esp,%ebp
80101629:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010162c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010162f:	8b 45 08             	mov    0x8(%ebp),%eax
80101632:	89 54 24 04          	mov    %edx,0x4(%esp)
80101636:	89 04 24             	mov    %eax,(%esp)
80101639:	e8 77 eb ff ff       	call   801001b5 <bread>
8010163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101644:	83 c0 5c             	add    $0x5c,%eax
80101647:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010164e:	00 
8010164f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101656:	00 
80101657:	89 04 24             	mov    %eax,(%esp)
8010165a:	e8 e7 3b 00 00       	call   80105246 <memset>
  log_write(bp);
8010165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101662:	89 04 24             	mov    %eax,(%esp)
80101665:	e8 75 22 00 00       	call   801038df <log_write>
  brelse(bp);
8010166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010166d:	89 04 24             	mov    %eax,(%esp)
80101670:	e8 b7 eb ff ff       	call   8010022c <brelse>
}
80101675:	c9                   	leave  
80101676:	c3                   	ret    

80101677 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101677:	55                   	push   %ebp
80101678:	89 e5                	mov    %esp,%ebp
8010167a:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010167d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010168b:	e9 03 01 00 00       	jmp    80101793 <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
80101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101693:	85 c0                	test   %eax,%eax
80101695:	79 05                	jns    8010169c <balloc+0x25>
80101697:	05 ff 0f 00 00       	add    $0xfff,%eax
8010169c:	c1 f8 0c             	sar    $0xc,%eax
8010169f:	89 c2                	mov    %eax,%edx
801016a1:	a1 f8 2e 11 80       	mov    0x80112ef8,%eax
801016a6:	01 d0                	add    %edx,%eax
801016a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ac:	8b 45 08             	mov    0x8(%ebp),%eax
801016af:	89 04 24             	mov    %eax,(%esp)
801016b2:	e8 fe ea ff ff       	call   801001b5 <bread>
801016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801016c1:	e9 9b 00 00 00       	jmp    80101761 <balloc+0xea>
      m = 1 << (bi % 8);
801016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c9:	25 07 00 00 80       	and    $0x80000007,%eax
801016ce:	85 c0                	test   %eax,%eax
801016d0:	79 05                	jns    801016d7 <balloc+0x60>
801016d2:	48                   	dec    %eax
801016d3:	83 c8 f8             	or     $0xfffffff8,%eax
801016d6:	40                   	inc    %eax
801016d7:	ba 01 00 00 00       	mov    $0x1,%edx
801016dc:	88 c1                	mov    %al,%cl
801016de:	d3 e2                	shl    %cl,%edx
801016e0:	89 d0                	mov    %edx,%eax
801016e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e8:	85 c0                	test   %eax,%eax
801016ea:	79 03                	jns    801016ef <balloc+0x78>
801016ec:	83 c0 07             	add    $0x7,%eax
801016ef:	c1 f8 03             	sar    $0x3,%eax
801016f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016f5:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
801016f9:	0f b6 c0             	movzbl %al,%eax
801016fc:	23 45 e8             	and    -0x18(%ebp),%eax
801016ff:	85 c0                	test   %eax,%eax
80101701:	75 5b                	jne    8010175e <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101706:	85 c0                	test   %eax,%eax
80101708:	79 03                	jns    8010170d <balloc+0x96>
8010170a:	83 c0 07             	add    $0x7,%eax
8010170d:	c1 f8 03             	sar    $0x3,%eax
80101710:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101713:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101717:	88 d1                	mov    %dl,%cl
80101719:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010171c:	09 ca                	or     %ecx,%edx
8010171e:	88 d1                	mov    %dl,%cl
80101720:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101723:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101727:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 ad 21 00 00       	call   801038df <log_write>
        brelse(bp);
80101732:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101735:	89 04 24             	mov    %eax,(%esp)
80101738:	e8 ef ea ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
8010173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101740:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101743:	01 c2                	add    %eax,%edx
80101745:	8b 45 08             	mov    0x8(%ebp),%eax
80101748:	89 54 24 04          	mov    %edx,0x4(%esp)
8010174c:	89 04 24             	mov    %eax,(%esp)
8010174f:	e8 d2 fe ff ff       	call   80101626 <bzero>
        return b + bi;
80101754:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101757:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010175a:	01 d0                	add    %edx,%eax
8010175c:	eb 51                	jmp    801017af <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010175e:	ff 45 f0             	incl   -0x10(%ebp)
80101761:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101768:	7f 17                	jg     80101781 <balloc+0x10a>
8010176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101770:	01 d0                	add    %edx,%eax
80101772:	89 c2                	mov    %eax,%edx
80101774:	a1 e0 2e 11 80       	mov    0x80112ee0,%eax
80101779:	39 c2                	cmp    %eax,%edx
8010177b:	0f 82 45 ff ff ff    	jb     801016c6 <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101781:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101784:	89 04 24             	mov    %eax,(%esp)
80101787:	e8 a0 ea ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010178c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101793:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101796:	a1 e0 2e 11 80       	mov    0x80112ee0,%eax
8010179b:	39 c2                	cmp    %eax,%edx
8010179d:	0f 82 ed fe ff ff    	jb     80101690 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801017a3:	c7 04 24 b4 8e 10 80 	movl   $0x80108eb4,(%esp)
801017aa:	e8 fe ee ff ff       	call   801006ad <panic>
}
801017af:	c9                   	leave  
801017b0:	c3                   	ret    

801017b1 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801017b1:	55                   	push   %ebp
801017b2:	89 e5                	mov    %esp,%ebp
801017b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801017b7:	c7 44 24 04 e0 2e 11 	movl   $0x80112ee0,0x4(%esp)
801017be:	80 
801017bf:	8b 45 08             	mov    0x8(%ebp),%eax
801017c2:	89 04 24             	mov    %eax,(%esp)
801017c5:	e8 16 fe ff ff       	call   801015e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801017cd:	c1 e8 0c             	shr    $0xc,%eax
801017d0:	89 c2                	mov    %eax,%edx
801017d2:	a1 f8 2e 11 80       	mov    0x80112ef8,%eax
801017d7:	01 c2                	add    %eax,%edx
801017d9:	8b 45 08             	mov    0x8(%ebp),%eax
801017dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801017e0:	89 04 24             	mov    %eax,(%esp)
801017e3:	e8 cd e9 ff ff       	call   801001b5 <bread>
801017e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801017ee:	25 ff 0f 00 00       	and    $0xfff,%eax
801017f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f9:	25 07 00 00 80       	and    $0x80000007,%eax
801017fe:	85 c0                	test   %eax,%eax
80101800:	79 05                	jns    80101807 <bfree+0x56>
80101802:	48                   	dec    %eax
80101803:	83 c8 f8             	or     $0xfffffff8,%eax
80101806:	40                   	inc    %eax
80101807:	ba 01 00 00 00       	mov    $0x1,%edx
8010180c:	88 c1                	mov    %al,%cl
8010180e:	d3 e2                	shl    %cl,%edx
80101810:	89 d0                	mov    %edx,%eax
80101812:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101815:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101818:	85 c0                	test   %eax,%eax
8010181a:	79 03                	jns    8010181f <bfree+0x6e>
8010181c:	83 c0 07             	add    $0x7,%eax
8010181f:	c1 f8 03             	sar    $0x3,%eax
80101822:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101825:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101829:	0f b6 c0             	movzbl %al,%eax
8010182c:	23 45 ec             	and    -0x14(%ebp),%eax
8010182f:	85 c0                	test   %eax,%eax
80101831:	75 0c                	jne    8010183f <bfree+0x8e>
    panic("freeing free block");
80101833:	c7 04 24 ca 8e 10 80 	movl   $0x80108eca,(%esp)
8010183a:	e8 6e ee ff ff       	call   801006ad <panic>
  bp->data[bi/8] &= ~m;
8010183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101842:	85 c0                	test   %eax,%eax
80101844:	79 03                	jns    80101849 <bfree+0x98>
80101846:	83 c0 07             	add    $0x7,%eax
80101849:	c1 f8 03             	sar    $0x3,%eax
8010184c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010184f:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101853:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101856:	f7 d1                	not    %ecx
80101858:	21 ca                	and    %ecx,%edx
8010185a:	88 d1                	mov    %dl,%cl
8010185c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010185f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101866:	89 04 24             	mov    %eax,(%esp)
80101869:	e8 71 20 00 00       	call   801038df <log_write>
  brelse(bp);
8010186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101871:	89 04 24             	mov    %eax,(%esp)
80101874:	e8 b3 e9 ff ff       	call   8010022c <brelse>
}
80101879:	c9                   	leave  
8010187a:	c3                   	ret    

8010187b <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010187b:	55                   	push   %ebp
8010187c:	89 e5                	mov    %esp,%ebp
8010187e:	57                   	push   %edi
8010187f:	56                   	push   %esi
80101880:	53                   	push   %ebx
80101881:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
80101884:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010188b:	c7 44 24 04 dd 8e 10 	movl   $0x80108edd,0x4(%esp)
80101892:	80 
80101893:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
8010189a:	e8 23 37 00 00       	call   80104fc2 <initlock>
  for(i = 0; i < NINODE; i++) {
8010189f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801018a6:	eb 2b                	jmp    801018d3 <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
801018a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801018ab:	89 d0                	mov    %edx,%eax
801018ad:	c1 e0 03             	shl    $0x3,%eax
801018b0:	01 d0                	add    %edx,%eax
801018b2:	c1 e0 04             	shl    $0x4,%eax
801018b5:	83 c0 30             	add    $0x30,%eax
801018b8:	05 00 2f 11 80       	add    $0x80112f00,%eax
801018bd:	83 c0 10             	add    $0x10,%eax
801018c0:	c7 44 24 04 e4 8e 10 	movl   $0x80108ee4,0x4(%esp)
801018c7:	80 
801018c8:	89 04 24             	mov    %eax,(%esp)
801018cb:	e8 b4 35 00 00       	call   80104e84 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801018d0:	ff 45 e4             	incl   -0x1c(%ebp)
801018d3:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801018d7:	7e cf                	jle    801018a8 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801018d9:	c7 44 24 04 e0 2e 11 	movl   $0x80112ee0,0x4(%esp)
801018e0:	80 
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	89 04 24             	mov    %eax,(%esp)
801018e7:	e8 f4 fc ff ff       	call   801015e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018ec:	a1 f8 2e 11 80       	mov    0x80112ef8,%eax
801018f1:	8b 3d f4 2e 11 80    	mov    0x80112ef4,%edi
801018f7:	8b 35 f0 2e 11 80    	mov    0x80112ef0,%esi
801018fd:	8b 1d ec 2e 11 80    	mov    0x80112eec,%ebx
80101903:	8b 0d e8 2e 11 80    	mov    0x80112ee8,%ecx
80101909:	8b 15 e4 2e 11 80    	mov    0x80112ee4,%edx
8010190f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101912:	8b 15 e0 2e 11 80    	mov    0x80112ee0,%edx
80101918:	89 44 24 1c          	mov    %eax,0x1c(%esp)
8010191c:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101920:	89 74 24 14          	mov    %esi,0x14(%esp)
80101924:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101928:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010192c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010192f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101933:	89 d0                	mov    %edx,%eax
80101935:	89 44 24 04          	mov    %eax,0x4(%esp)
80101939:	c7 04 24 ec 8e 10 80 	movl   $0x80108eec,(%esp)
80101940:	e8 d5 eb ff ff       	call   8010051a <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101945:	83 c4 4c             	add    $0x4c,%esp
80101948:	5b                   	pop    %ebx
80101949:	5e                   	pop    %esi
8010194a:	5f                   	pop    %edi
8010194b:	5d                   	pop    %ebp
8010194c:	c3                   	ret    

8010194d <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010194d:	55                   	push   %ebp
8010194e:	89 e5                	mov    %esp,%ebp
80101950:	83 ec 28             	sub    $0x28,%esp
80101953:	8b 45 0c             	mov    0xc(%ebp),%eax
80101956:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010195a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101961:	e9 9b 00 00 00       	jmp    80101a01 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
80101966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101969:	c1 e8 03             	shr    $0x3,%eax
8010196c:	89 c2                	mov    %eax,%edx
8010196e:	a1 f4 2e 11 80       	mov    0x80112ef4,%eax
80101973:	01 d0                	add    %edx,%eax
80101975:	89 44 24 04          	mov    %eax,0x4(%esp)
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	89 04 24             	mov    %eax,(%esp)
8010197f:	e8 31 e8 ff ff       	call   801001b5 <bread>
80101984:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101990:	83 e0 07             	and    $0x7,%eax
80101993:	c1 e0 06             	shl    $0x6,%eax
80101996:	01 d0                	add    %edx,%eax
80101998:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010199e:	8b 00                	mov    (%eax),%eax
801019a0:	66 85 c0             	test   %ax,%ax
801019a3:	75 4e                	jne    801019f3 <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
801019a5:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801019ac:	00 
801019ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801019b4:	00 
801019b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019b8:	89 04 24             	mov    %eax,(%esp)
801019bb:	e8 86 38 00 00       	call   80105246 <memset>
      dip->type = type;
801019c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801019c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c6:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cc:	89 04 24             	mov    %eax,(%esp)
801019cf:	e8 0b 1f 00 00       	call   801038df <log_write>
      brelse(bp);
801019d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d7:	89 04 24             	mov    %eax,(%esp)
801019da:	e8 4d e8 ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
801019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e6:	8b 45 08             	mov    0x8(%ebp),%eax
801019e9:	89 04 24             	mov    %eax,(%esp)
801019ec:	e8 ea 00 00 00       	call   80101adb <iget>
801019f1:	eb 2a                	jmp    80101a1d <ialloc+0xd0>
    }
    brelse(bp);
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	89 04 24             	mov    %eax,(%esp)
801019f9:	e8 2e e8 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801019fe:	ff 45 f4             	incl   -0xc(%ebp)
80101a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101a04:	a1 e8 2e 11 80       	mov    0x80112ee8,%eax
80101a09:	39 c2                	cmp    %eax,%edx
80101a0b:	0f 82 55 ff ff ff    	jb     80101966 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101a11:	c7 04 24 3f 8f 10 80 	movl   $0x80108f3f,(%esp)
80101a18:	e8 90 ec ff ff       	call   801006ad <panic>
}
80101a1d:	c9                   	leave  
80101a1e:	c3                   	ret    

80101a1f <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101a1f:	55                   	push   %ebp
80101a20:	89 e5                	mov    %esp,%ebp
80101a22:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a25:	8b 45 08             	mov    0x8(%ebp),%eax
80101a28:	8b 40 04             	mov    0x4(%eax),%eax
80101a2b:	c1 e8 03             	shr    $0x3,%eax
80101a2e:	89 c2                	mov    %eax,%edx
80101a30:	a1 f4 2e 11 80       	mov    0x80112ef4,%eax
80101a35:	01 c2                	add    %eax,%edx
80101a37:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3a:	8b 00                	mov    (%eax),%eax
80101a3c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a40:	89 04 24             	mov    %eax,(%esp)
80101a43:	e8 6d e7 ff ff       	call   801001b5 <bread>
80101a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 04             	mov    0x4(%eax),%eax
80101a57:	83 e0 07             	and    $0x7,%eax
80101a5a:	c1 e0 06             	shl    $0x6,%eax
80101a5d:	01 d0                	add    %edx,%eax
80101a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	8b 40 50             	mov    0x50(%eax),%eax
80101a68:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a6b:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	66 8b 40 52          	mov    0x52(%eax),%ax
80101a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a78:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	8b 40 54             	mov    0x54(%eax),%eax
80101a82:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a85:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	66 8b 40 56          	mov    0x56(%eax),%ax
80101a90:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a93:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	8b 50 58             	mov    0x58(%eax),%edx
80101a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa0:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8d 50 5c             	lea    0x5c(%eax),%edx
80101aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aac:	83 c0 0c             	add    $0xc,%eax
80101aaf:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101ab6:	00 
80101ab7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101abb:	89 04 24             	mov    %eax,(%esp)
80101abe:	e8 4c 38 00 00       	call   8010530f <memmove>
  log_write(bp);
80101ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac6:	89 04 24             	mov    %eax,(%esp)
80101ac9:	e8 11 1e 00 00       	call   801038df <log_write>
  brelse(bp);
80101ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ad1:	89 04 24             	mov    %eax,(%esp)
80101ad4:	e8 53 e7 ff ff       	call   8010022c <brelse>
}
80101ad9:	c9                   	leave  
80101ada:	c3                   	ret    

80101adb <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101adb:	55                   	push   %ebp
80101adc:	89 e5                	mov    %esp,%ebp
80101ade:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101ae1:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101ae8:	e8 f6 34 00 00       	call   80104fe3 <acquire>

  // Is the inode already cached?
  empty = 0;
80101aed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101af4:	c7 45 f4 34 2f 11 80 	movl   $0x80112f34,-0xc(%ebp)
80101afb:	eb 5c                	jmp    80101b59 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b00:	8b 40 08             	mov    0x8(%eax),%eax
80101b03:	85 c0                	test   %eax,%eax
80101b05:	7e 35                	jle    80101b3c <iget+0x61>
80101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b0a:	8b 00                	mov    (%eax),%eax
80101b0c:	3b 45 08             	cmp    0x8(%ebp),%eax
80101b0f:	75 2b                	jne    80101b3c <iget+0x61>
80101b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b14:	8b 40 04             	mov    0x4(%eax),%eax
80101b17:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101b1a:	75 20                	jne    80101b3c <iget+0x61>
      ip->ref++;
80101b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b1f:	8b 40 08             	mov    0x8(%eax),%eax
80101b22:	8d 50 01             	lea    0x1(%eax),%edx
80101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b28:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101b2b:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101b32:	e8 16 35 00 00       	call   8010504d <release>
      return ip;
80101b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b3a:	eb 72                	jmp    80101bae <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101b3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101b40:	75 10                	jne    80101b52 <iget+0x77>
80101b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b45:	8b 40 08             	mov    0x8(%eax),%eax
80101b48:	85 c0                	test   %eax,%eax
80101b4a:	75 06                	jne    80101b52 <iget+0x77>
      empty = ip;
80101b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b52:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101b59:	81 7d f4 54 4b 11 80 	cmpl   $0x80114b54,-0xc(%ebp)
80101b60:	72 9b                	jb     80101afd <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101b62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101b66:	75 0c                	jne    80101b74 <iget+0x99>
    panic("iget: no inodes");
80101b68:	c7 04 24 51 8f 10 80 	movl   $0x80108f51,(%esp)
80101b6f:	e8 39 eb ff ff       	call   801006ad <panic>

  ip = empty;
80101b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b7d:	8b 55 08             	mov    0x8(%ebp),%edx
80101b80:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b85:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b88:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b98:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101b9f:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101ba6:	e8 a2 34 00 00       	call   8010504d <release>

  return ip;
80101bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101bae:	c9                   	leave  
80101baf:	c3                   	ret    

80101bb0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101bb6:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101bbd:	e8 21 34 00 00       	call   80104fe3 <acquire>
  ip->ref++;
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	8b 40 08             	mov    0x8(%eax),%eax
80101bc8:	8d 50 01             	lea    0x1(%eax),%edx
80101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bce:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bd1:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101bd8:	e8 70 34 00 00       	call   8010504d <release>
  return ip;
80101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101be0:	c9                   	leave  
80101be1:	c3                   	ret    

80101be2 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101be2:	55                   	push   %ebp
80101be3:	89 e5                	mov    %esp,%ebp
80101be5:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101bec:	74 0a                	je     80101bf8 <ilock+0x16>
80101bee:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf1:	8b 40 08             	mov    0x8(%eax),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	7f 0c                	jg     80101c04 <ilock+0x22>
    panic("ilock");
80101bf8:	c7 04 24 61 8f 10 80 	movl   $0x80108f61,(%esp)
80101bff:	e8 a9 ea ff ff       	call   801006ad <panic>

  acquiresleep(&ip->lock);
80101c04:	8b 45 08             	mov    0x8(%ebp),%eax
80101c07:	83 c0 0c             	add    $0xc,%eax
80101c0a:	89 04 24             	mov    %eax,(%esp)
80101c0d:	e8 ac 32 00 00       	call   80104ebe <acquiresleep>

  if(ip->valid == 0){
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c18:	85 c0                	test   %eax,%eax
80101c1a:	0f 85 ca 00 00 00    	jne    80101cea <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c20:	8b 45 08             	mov    0x8(%ebp),%eax
80101c23:	8b 40 04             	mov    0x4(%eax),%eax
80101c26:	c1 e8 03             	shr    $0x3,%eax
80101c29:	89 c2                	mov    %eax,%edx
80101c2b:	a1 f4 2e 11 80       	mov    0x80112ef4,%eax
80101c30:	01 c2                	add    %eax,%edx
80101c32:	8b 45 08             	mov    0x8(%ebp),%eax
80101c35:	8b 00                	mov    (%eax),%eax
80101c37:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c3b:	89 04 24             	mov    %eax,(%esp)
80101c3e:	e8 72 e5 ff ff       	call   801001b5 <bread>
80101c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c49:	8d 50 5c             	lea    0x5c(%eax),%edx
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 40 04             	mov    0x4(%eax),%eax
80101c52:	83 e0 07             	and    $0x7,%eax
80101c55:	c1 e0 06             	shl    $0x6,%eax
80101c58:	01 d0                	add    %edx,%eax
80101c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c60:	8b 00                	mov    (%eax),%eax
80101c62:	8b 55 08             	mov    0x8(%ebp),%edx
80101c65:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c6c:	66 8b 40 02          	mov    0x2(%eax),%ax
80101c70:	8b 55 08             	mov    0x8(%ebp),%edx
80101c73:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c7a:	8b 40 04             	mov    0x4(%eax),%eax
80101c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80101c80:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c87:	66 8b 40 06          	mov    0x6(%eax),%ax
80101c8b:	8b 55 08             	mov    0x8(%ebp),%edx
80101c8e:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c95:	8b 50 08             	mov    0x8(%eax),%edx
80101c98:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9b:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca1:	8d 50 0c             	lea    0xc(%eax),%edx
80101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca7:	83 c0 5c             	add    $0x5c,%eax
80101caa:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101cb1:	00 
80101cb2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb6:	89 04 24             	mov    %eax,(%esp)
80101cb9:	e8 51 36 00 00       	call   8010530f <memmove>
    brelse(bp);
80101cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc1:	89 04 24             	mov    %eax,(%esp)
80101cc4:	e8 63 e5 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd6:	8b 40 50             	mov    0x50(%eax),%eax
80101cd9:	66 85 c0             	test   %ax,%ax
80101cdc:	75 0c                	jne    80101cea <ilock+0x108>
      panic("ilock: no type");
80101cde:	c7 04 24 67 8f 10 80 	movl   $0x80108f67,(%esp)
80101ce5:	e8 c3 e9 ff ff       	call   801006ad <panic>
  }
}
80101cea:	c9                   	leave  
80101ceb:	c3                   	ret    

80101cec <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101cec:	55                   	push   %ebp
80101ced:	89 e5                	mov    %esp,%ebp
80101cef:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101cf6:	74 1c                	je     80101d14 <iunlock+0x28>
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	83 c0 0c             	add    $0xc,%eax
80101cfe:	89 04 24             	mov    %eax,(%esp)
80101d01:	e8 55 32 00 00       	call   80104f5b <holdingsleep>
80101d06:	85 c0                	test   %eax,%eax
80101d08:	74 0a                	je     80101d14 <iunlock+0x28>
80101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0d:	8b 40 08             	mov    0x8(%eax),%eax
80101d10:	85 c0                	test   %eax,%eax
80101d12:	7f 0c                	jg     80101d20 <iunlock+0x34>
    panic("iunlock");
80101d14:	c7 04 24 76 8f 10 80 	movl   $0x80108f76,(%esp)
80101d1b:	e8 8d e9 ff ff       	call   801006ad <panic>

  releasesleep(&ip->lock);
80101d20:	8b 45 08             	mov    0x8(%ebp),%eax
80101d23:	83 c0 0c             	add    $0xc,%eax
80101d26:	89 04 24             	mov    %eax,(%esp)
80101d29:	e8 eb 31 00 00       	call   80104f19 <releasesleep>
}
80101d2e:	c9                   	leave  
80101d2f:	c3                   	ret    

80101d30 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	83 c0 0c             	add    $0xc,%eax
80101d3c:	89 04 24             	mov    %eax,(%esp)
80101d3f:	e8 7a 31 00 00       	call   80104ebe <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d4a:	85 c0                	test   %eax,%eax
80101d4c:	74 5c                	je     80101daa <iput+0x7a>
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	66 8b 40 56          	mov    0x56(%eax),%ax
80101d55:	66 85 c0             	test   %ax,%ax
80101d58:	75 50                	jne    80101daa <iput+0x7a>
    acquire(&icache.lock);
80101d5a:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101d61:	e8 7d 32 00 00       	call   80104fe3 <acquire>
    int r = ip->ref;
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	8b 40 08             	mov    0x8(%eax),%eax
80101d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101d6f:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101d76:	e8 d2 32 00 00       	call   8010504d <release>
    if(r == 1){
80101d7b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101d7f:	75 29                	jne    80101daa <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101d81:	8b 45 08             	mov    0x8(%ebp),%eax
80101d84:	89 04 24             	mov    %eax,(%esp)
80101d87:	e8 86 01 00 00       	call   80101f12 <itrunc>
      ip->type = 0;
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	89 04 24             	mov    %eax,(%esp)
80101d9b:	e8 7f fc ff ff       	call   80101a1f <iupdate>
      ip->valid = 0;
80101da0:	8b 45 08             	mov    0x8(%ebp),%eax
80101da3:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	83 c0 0c             	add    $0xc,%eax
80101db0:	89 04 24             	mov    %eax,(%esp)
80101db3:	e8 61 31 00 00       	call   80104f19 <releasesleep>

  acquire(&icache.lock);
80101db8:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101dbf:	e8 1f 32 00 00       	call   80104fe3 <acquire>
  ip->ref--;
80101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc7:	8b 40 08             	mov    0x8(%eax),%eax
80101dca:	8d 50 ff             	lea    -0x1(%eax),%edx
80101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101dd3:	c7 04 24 00 2f 11 80 	movl   $0x80112f00,(%esp)
80101dda:	e8 6e 32 00 00       	call   8010504d <release>
}
80101ddf:	c9                   	leave  
80101de0:	c3                   	ret    

80101de1 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101de1:	55                   	push   %ebp
80101de2:	89 e5                	mov    %esp,%ebp
80101de4:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101de7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dea:	89 04 24             	mov    %eax,(%esp)
80101ded:	e8 fa fe ff ff       	call   80101cec <iunlock>
  iput(ip);
80101df2:	8b 45 08             	mov    0x8(%ebp),%eax
80101df5:	89 04 24             	mov    %eax,(%esp)
80101df8:	e8 33 ff ff ff       	call   80101d30 <iput>
}
80101dfd:	c9                   	leave  
80101dfe:	c3                   	ret    

80101dff <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101dff:	55                   	push   %ebp
80101e00:	89 e5                	mov    %esp,%ebp
80101e02:	53                   	push   %ebx
80101e03:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e06:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101e0a:	77 3e                	ja     80101e4a <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e12:	83 c2 14             	add    $0x14,%edx
80101e15:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e20:	75 20                	jne    80101e42 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e22:	8b 45 08             	mov    0x8(%ebp),%eax
80101e25:	8b 00                	mov    (%eax),%eax
80101e27:	89 04 24             	mov    %eax,(%esp)
80101e2a:	e8 48 f8 ff ff       	call   80101677 <balloc>
80101e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e32:	8b 45 08             	mov    0x8(%ebp),%eax
80101e35:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e38:	8d 4a 14             	lea    0x14(%edx),%ecx
80101e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e3e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e45:	e9 c2 00 00 00       	jmp    80101f0c <bmap+0x10d>
  }
  bn -= NDIRECT;
80101e4a:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101e4e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e52:	0f 87 a8 00 00 00    	ja     80101f00 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e68:	75 1c                	jne    80101e86 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6d:	8b 00                	mov    (%eax),%eax
80101e6f:	89 04 24             	mov    %eax,(%esp)
80101e72:	e8 00 f8 ff ff       	call   80101677 <balloc>
80101e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e80:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101e86:	8b 45 08             	mov    0x8(%ebp),%eax
80101e89:	8b 00                	mov    (%eax),%eax
80101e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e92:	89 04 24             	mov    %eax,(%esp)
80101e95:	e8 1b e3 ff ff       	call   801001b5 <bread>
80101e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea0:	83 c0 5c             	add    $0x5c,%eax
80101ea3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb3:	01 d0                	add    %edx,%eax
80101eb5:	8b 00                	mov    (%eax),%eax
80101eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ebe:	75 30                	jne    80101ef0 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ecd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	8b 00                	mov    (%eax),%eax
80101ed5:	89 04 24             	mov    %eax,(%esp)
80101ed8:	e8 9a f7 ff ff       	call   80101677 <balloc>
80101edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ee3:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee8:	89 04 24             	mov    %eax,(%esp)
80101eeb:	e8 ef 19 00 00       	call   801038df <log_write>
    }
    brelse(bp);
80101ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef3:	89 04 24             	mov    %eax,(%esp)
80101ef6:	e8 31 e3 ff ff       	call   8010022c <brelse>
    return addr;
80101efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101efe:	eb 0c                	jmp    80101f0c <bmap+0x10d>
  }

  panic("bmap: out of range");
80101f00:	c7 04 24 7e 8f 10 80 	movl   $0x80108f7e,(%esp)
80101f07:	e8 a1 e7 ff ff       	call   801006ad <panic>
}
80101f0c:	83 c4 24             	add    $0x24,%esp
80101f0f:	5b                   	pop    %ebx
80101f10:	5d                   	pop    %ebp
80101f11:	c3                   	ret    

80101f12 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f12:	55                   	push   %ebp
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f1f:	eb 43                	jmp    80101f64 <itrunc+0x52>
    if(ip->addrs[i]){
80101f21:	8b 45 08             	mov    0x8(%ebp),%eax
80101f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f27:	83 c2 14             	add    $0x14,%edx
80101f2a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101f2e:	85 c0                	test   %eax,%eax
80101f30:	74 2f                	je     80101f61 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f38:	83 c2 14             	add    $0x14,%edx
80101f3b:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 00                	mov    (%eax),%eax
80101f44:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f48:	89 04 24             	mov    %eax,(%esp)
80101f4b:	e8 61 f8 ff ff       	call   801017b1 <bfree>
      ip->addrs[i] = 0;
80101f50:	8b 45 08             	mov    0x8(%ebp),%eax
80101f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f56:	83 c2 14             	add    $0x14,%edx
80101f59:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101f60:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f61:	ff 45 f4             	incl   -0xc(%ebp)
80101f64:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101f68:	7e b7                	jle    80101f21 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6d:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 84 a3 00 00 00    	je     8010201e <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7e:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	8b 00                	mov    (%eax),%eax
80101f89:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f8d:	89 04 24             	mov    %eax,(%esp)
80101f90:	e8 20 e2 ff ff       	call   801001b5 <bread>
80101f95:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f9b:	83 c0 5c             	add    $0x5c,%eax
80101f9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101fa1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101fa8:	eb 3a                	jmp    80101fe4 <itrunc+0xd2>
      if(a[j])
80101faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fb7:	01 d0                	add    %edx,%eax
80101fb9:	8b 00                	mov    (%eax),%eax
80101fbb:	85 c0                	test   %eax,%eax
80101fbd:	74 22                	je     80101fe1 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fcc:	01 d0                	add    %edx,%eax
80101fce:	8b 10                	mov    (%eax),%edx
80101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd3:	8b 00                	mov    (%eax),%eax
80101fd5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fd9:	89 04 24             	mov    %eax,(%esp)
80101fdc:	e8 d0 f7 ff ff       	call   801017b1 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101fe1:	ff 45 f0             	incl   -0x10(%ebp)
80101fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe7:	83 f8 7f             	cmp    $0x7f,%eax
80101fea:	76 be                	jbe    80101faa <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fef:	89 04 24             	mov    %eax,(%esp)
80101ff2:	e8 35 e2 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80102000:	8b 45 08             	mov    0x8(%ebp),%eax
80102003:	8b 00                	mov    (%eax),%eax
80102005:	89 54 24 04          	mov    %edx,0x4(%esp)
80102009:	89 04 24             	mov    %eax,(%esp)
8010200c:	e8 a0 f7 ff ff       	call   801017b1 <bfree>
    ip->addrs[NDIRECT] = 0;
80102011:	8b 45 08             	mov    0x8(%ebp),%eax
80102014:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010201b:	00 00 00 
  }

  ip->size = 0;
8010201e:	8b 45 08             	mov    0x8(%ebp),%eax
80102021:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80102028:	8b 45 08             	mov    0x8(%ebp),%eax
8010202b:	89 04 24             	mov    %eax,(%esp)
8010202e:	e8 ec f9 ff ff       	call   80101a1f <iupdate>
}
80102033:	c9                   	leave  
80102034:	c3                   	ret    

80102035 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102035:	55                   	push   %ebp
80102036:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102038:	8b 45 08             	mov    0x8(%ebp),%eax
8010203b:	8b 00                	mov    (%eax),%eax
8010203d:	89 c2                	mov    %eax,%edx
8010203f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102042:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102045:	8b 45 08             	mov    0x8(%ebp),%eax
80102048:	8b 50 04             	mov    0x4(%eax),%edx
8010204b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010204e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102051:	8b 45 08             	mov    0x8(%ebp),%eax
80102054:	8b 40 50             	mov    0x50(%eax),%eax
80102057:	8b 55 0c             	mov    0xc(%ebp),%edx
8010205a:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
8010205d:	8b 45 08             	mov    0x8(%ebp),%eax
80102060:	66 8b 40 56          	mov    0x56(%eax),%ax
80102064:	8b 55 0c             	mov    0xc(%ebp),%edx
80102067:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
8010206b:	8b 45 08             	mov    0x8(%ebp),%eax
8010206e:	8b 50 58             	mov    0x58(%eax),%edx
80102071:	8b 45 0c             	mov    0xc(%ebp),%eax
80102074:	89 50 10             	mov    %edx,0x10(%eax)
}
80102077:	5d                   	pop    %ebp
80102078:	c3                   	ret    

80102079 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102079:	55                   	push   %ebp
8010207a:	89 e5                	mov    %esp,%ebp
8010207c:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
80102082:	8b 40 50             	mov    0x50(%eax),%eax
80102085:	66 83 f8 03          	cmp    $0x3,%ax
80102089:	75 60                	jne    801020eb <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010208b:	8b 45 08             	mov    0x8(%ebp),%eax
8010208e:	66 8b 40 52          	mov    0x52(%eax),%ax
80102092:	66 85 c0             	test   %ax,%ax
80102095:	78 20                	js     801020b7 <readi+0x3e>
80102097:	8b 45 08             	mov    0x8(%ebp),%eax
8010209a:	66 8b 40 52          	mov    0x52(%eax),%ax
8010209e:	66 83 f8 09          	cmp    $0x9,%ax
801020a2:	7f 13                	jg     801020b7 <readi+0x3e>
801020a4:	8b 45 08             	mov    0x8(%ebp),%eax
801020a7:	66 8b 40 52          	mov    0x52(%eax),%ax
801020ab:	98                   	cwtl   
801020ac:	8b 04 c5 80 2e 11 80 	mov    -0x7feed180(,%eax,8),%eax
801020b3:	85 c0                	test   %eax,%eax
801020b5:	75 0a                	jne    801020c1 <readi+0x48>
      return -1;
801020b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020bc:	e9 1a 01 00 00       	jmp    801021db <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
801020c1:	8b 45 08             	mov    0x8(%ebp),%eax
801020c4:	66 8b 40 52          	mov    0x52(%eax),%ax
801020c8:	98                   	cwtl   
801020c9:	8b 04 c5 80 2e 11 80 	mov    -0x7feed180(,%eax,8),%eax
801020d0:	8b 55 14             	mov    0x14(%ebp),%edx
801020d3:	89 54 24 08          	mov    %edx,0x8(%esp)
801020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801020da:	89 54 24 04          	mov    %edx,0x4(%esp)
801020de:	8b 55 08             	mov    0x8(%ebp),%edx
801020e1:	89 14 24             	mov    %edx,(%esp)
801020e4:	ff d0                	call   *%eax
801020e6:	e9 f0 00 00 00       	jmp    801021db <readi+0x162>
  }

  if(off > ip->size || off + n < off)
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
801020ee:	8b 40 58             	mov    0x58(%eax),%eax
801020f1:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f4:	72 0d                	jb     80102103 <readi+0x8a>
801020f6:	8b 45 14             	mov    0x14(%ebp),%eax
801020f9:	8b 55 10             	mov    0x10(%ebp),%edx
801020fc:	01 d0                	add    %edx,%eax
801020fe:	3b 45 10             	cmp    0x10(%ebp),%eax
80102101:	73 0a                	jae    8010210d <readi+0x94>
    return -1;
80102103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102108:	e9 ce 00 00 00       	jmp    801021db <readi+0x162>
  if(off + n > ip->size)
8010210d:	8b 45 14             	mov    0x14(%ebp),%eax
80102110:	8b 55 10             	mov    0x10(%ebp),%edx
80102113:	01 c2                	add    %eax,%edx
80102115:	8b 45 08             	mov    0x8(%ebp),%eax
80102118:	8b 40 58             	mov    0x58(%eax),%eax
8010211b:	39 c2                	cmp    %eax,%edx
8010211d:	76 0c                	jbe    8010212b <readi+0xb2>
    n = ip->size - off;
8010211f:	8b 45 08             	mov    0x8(%ebp),%eax
80102122:	8b 40 58             	mov    0x58(%eax),%eax
80102125:	2b 45 10             	sub    0x10(%ebp),%eax
80102128:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010212b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102132:	e9 95 00 00 00       	jmp    801021cc <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102137:	8b 45 10             	mov    0x10(%ebp),%eax
8010213a:	c1 e8 09             	shr    $0x9,%eax
8010213d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102141:	8b 45 08             	mov    0x8(%ebp),%eax
80102144:	89 04 24             	mov    %eax,(%esp)
80102147:	e8 b3 fc ff ff       	call   80101dff <bmap>
8010214c:	8b 55 08             	mov    0x8(%ebp),%edx
8010214f:	8b 12                	mov    (%edx),%edx
80102151:	89 44 24 04          	mov    %eax,0x4(%esp)
80102155:	89 14 24             	mov    %edx,(%esp)
80102158:	e8 58 e0 ff ff       	call   801001b5 <bread>
8010215d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102160:	8b 45 10             	mov    0x10(%ebp),%eax
80102163:	25 ff 01 00 00       	and    $0x1ff,%eax
80102168:	89 c2                	mov    %eax,%edx
8010216a:	b8 00 02 00 00       	mov    $0x200,%eax
8010216f:	29 d0                	sub    %edx,%eax
80102171:	89 c1                	mov    %eax,%ecx
80102173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102176:	8b 55 14             	mov    0x14(%ebp),%edx
80102179:	29 c2                	sub    %eax,%edx
8010217b:	89 c8                	mov    %ecx,%eax
8010217d:	39 d0                	cmp    %edx,%eax
8010217f:	76 02                	jbe    80102183 <readi+0x10a>
80102181:	89 d0                	mov    %edx,%eax
80102183:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102186:	8b 45 10             	mov    0x10(%ebp),%eax
80102189:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218e:	8d 50 50             	lea    0x50(%eax),%edx
80102191:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102194:	01 d0                	add    %edx,%eax
80102196:	8d 50 0c             	lea    0xc(%eax),%edx
80102199:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219c:	89 44 24 08          	mov    %eax,0x8(%esp)
801021a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801021a7:	89 04 24             	mov    %eax,(%esp)
801021aa:	e8 60 31 00 00       	call   8010530f <memmove>
    brelse(bp);
801021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021b2:	89 04 24             	mov    %eax,(%esp)
801021b5:	e8 72 e0 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021bd:	01 45 f4             	add    %eax,-0xc(%ebp)
801021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c3:	01 45 10             	add    %eax,0x10(%ebp)
801021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c9:	01 45 0c             	add    %eax,0xc(%ebp)
801021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021cf:	3b 45 14             	cmp    0x14(%ebp),%eax
801021d2:	0f 82 5f ff ff ff    	jb     80102137 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801021d8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021db:	c9                   	leave  
801021dc:	c3                   	ret    

801021dd <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021dd:	55                   	push   %ebp
801021de:	89 e5                	mov    %esp,%ebp
801021e0:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801021e3:	8b 45 08             	mov    0x8(%ebp),%eax
801021e6:	8b 40 50             	mov    0x50(%eax),%eax
801021e9:	66 83 f8 03          	cmp    $0x3,%ax
801021ed:	75 60                	jne    8010224f <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801021ef:	8b 45 08             	mov    0x8(%ebp),%eax
801021f2:	66 8b 40 52          	mov    0x52(%eax),%ax
801021f6:	66 85 c0             	test   %ax,%ax
801021f9:	78 20                	js     8010221b <writei+0x3e>
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
801021fe:	66 8b 40 52          	mov    0x52(%eax),%ax
80102202:	66 83 f8 09          	cmp    $0x9,%ax
80102206:	7f 13                	jg     8010221b <writei+0x3e>
80102208:	8b 45 08             	mov    0x8(%ebp),%eax
8010220b:	66 8b 40 52          	mov    0x52(%eax),%ax
8010220f:	98                   	cwtl   
80102210:	8b 04 c5 84 2e 11 80 	mov    -0x7feed17c(,%eax,8),%eax
80102217:	85 c0                	test   %eax,%eax
80102219:	75 0a                	jne    80102225 <writei+0x48>
      return -1;
8010221b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102220:	e9 45 01 00 00       	jmp    8010236a <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102225:	8b 45 08             	mov    0x8(%ebp),%eax
80102228:	66 8b 40 52          	mov    0x52(%eax),%ax
8010222c:	98                   	cwtl   
8010222d:	8b 04 c5 84 2e 11 80 	mov    -0x7feed17c(,%eax,8),%eax
80102234:	8b 55 14             	mov    0x14(%ebp),%edx
80102237:	89 54 24 08          	mov    %edx,0x8(%esp)
8010223b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010223e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102242:	8b 55 08             	mov    0x8(%ebp),%edx
80102245:	89 14 24             	mov    %edx,(%esp)
80102248:	ff d0                	call   *%eax
8010224a:	e9 1b 01 00 00       	jmp    8010236a <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
8010224f:	8b 45 08             	mov    0x8(%ebp),%eax
80102252:	8b 40 58             	mov    0x58(%eax),%eax
80102255:	3b 45 10             	cmp    0x10(%ebp),%eax
80102258:	72 0d                	jb     80102267 <writei+0x8a>
8010225a:	8b 45 14             	mov    0x14(%ebp),%eax
8010225d:	8b 55 10             	mov    0x10(%ebp),%edx
80102260:	01 d0                	add    %edx,%eax
80102262:	3b 45 10             	cmp    0x10(%ebp),%eax
80102265:	73 0a                	jae    80102271 <writei+0x94>
    return -1;
80102267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010226c:	e9 f9 00 00 00       	jmp    8010236a <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80102271:	8b 45 14             	mov    0x14(%ebp),%eax
80102274:	8b 55 10             	mov    0x10(%ebp),%edx
80102277:	01 d0                	add    %edx,%eax
80102279:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010227e:	76 0a                	jbe    8010228a <writei+0xad>
    return -1;
80102280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102285:	e9 e0 00 00 00       	jmp    8010236a <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010228a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102291:	e9 a0 00 00 00       	jmp    80102336 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102296:	8b 45 10             	mov    0x10(%ebp),%eax
80102299:	c1 e8 09             	shr    $0x9,%eax
8010229c:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a0:	8b 45 08             	mov    0x8(%ebp),%eax
801022a3:	89 04 24             	mov    %eax,(%esp)
801022a6:	e8 54 fb ff ff       	call   80101dff <bmap>
801022ab:	8b 55 08             	mov    0x8(%ebp),%edx
801022ae:	8b 12                	mov    (%edx),%edx
801022b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b4:	89 14 24             	mov    %edx,(%esp)
801022b7:	e8 f9 de ff ff       	call   801001b5 <bread>
801022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022bf:	8b 45 10             	mov    0x10(%ebp),%eax
801022c2:	25 ff 01 00 00       	and    $0x1ff,%eax
801022c7:	89 c2                	mov    %eax,%edx
801022c9:	b8 00 02 00 00       	mov    $0x200,%eax
801022ce:	29 d0                	sub    %edx,%eax
801022d0:	89 c1                	mov    %eax,%ecx
801022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d5:	8b 55 14             	mov    0x14(%ebp),%edx
801022d8:	29 c2                	sub    %eax,%edx
801022da:	89 c8                	mov    %ecx,%eax
801022dc:	39 d0                	cmp    %edx,%eax
801022de:	76 02                	jbe    801022e2 <writei+0x105>
801022e0:	89 d0                	mov    %edx,%eax
801022e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801022e5:	8b 45 10             	mov    0x10(%ebp),%eax
801022e8:	25 ff 01 00 00       	and    $0x1ff,%eax
801022ed:	8d 50 50             	lea    0x50(%eax),%edx
801022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f3:	01 d0                	add    %edx,%eax
801022f5:	8d 50 0c             	lea    0xc(%eax),%edx
801022f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801022ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102302:	89 44 24 04          	mov    %eax,0x4(%esp)
80102306:	89 14 24             	mov    %edx,(%esp)
80102309:	e8 01 30 00 00       	call   8010530f <memmove>
    log_write(bp);
8010230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102311:	89 04 24             	mov    %eax,(%esp)
80102314:	e8 c6 15 00 00       	call   801038df <log_write>
    brelse(bp);
80102319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010231c:	89 04 24             	mov    %eax,(%esp)
8010231f:	e8 08 df ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102327:	01 45 f4             	add    %eax,-0xc(%ebp)
8010232a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010232d:	01 45 10             	add    %eax,0x10(%ebp)
80102330:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102333:	01 45 0c             	add    %eax,0xc(%ebp)
80102336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102339:	3b 45 14             	cmp    0x14(%ebp),%eax
8010233c:	0f 82 54 ff ff ff    	jb     80102296 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102342:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102346:	74 1f                	je     80102367 <writei+0x18a>
80102348:	8b 45 08             	mov    0x8(%ebp),%eax
8010234b:	8b 40 58             	mov    0x58(%eax),%eax
8010234e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102351:	73 14                	jae    80102367 <writei+0x18a>
    ip->size = off;
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
80102356:	8b 55 10             	mov    0x10(%ebp),%edx
80102359:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
8010235c:	8b 45 08             	mov    0x8(%ebp),%eax
8010235f:	89 04 24             	mov    %eax,(%esp)
80102362:	e8 b8 f6 ff ff       	call   80101a1f <iupdate>
  }
  return n;
80102367:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010236a:	c9                   	leave  
8010236b:	c3                   	ret    

8010236c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010236c:	55                   	push   %ebp
8010236d:	89 e5                	mov    %esp,%ebp
8010236f:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102372:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102379:	00 
8010237a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010237d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102381:	8b 45 08             	mov    0x8(%ebp),%eax
80102384:	89 04 24             	mov    %eax,(%esp)
80102387:	e8 22 30 00 00       	call   801053ae <strncmp>
}
8010238c:	c9                   	leave  
8010238d:	c3                   	ret    

8010238e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010238e:	55                   	push   %ebp
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102394:	8b 45 08             	mov    0x8(%ebp),%eax
80102397:	8b 40 50             	mov    0x50(%eax),%eax
8010239a:	66 83 f8 01          	cmp    $0x1,%ax
8010239e:	74 0c                	je     801023ac <dirlookup+0x1e>
    panic("dirlookup not DIR");
801023a0:	c7 04 24 91 8f 10 80 	movl   $0x80108f91,(%esp)
801023a7:	e8 01 e3 ff ff       	call   801006ad <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023b3:	e9 86 00 00 00       	jmp    8010243e <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801023bf:	00 
801023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801023c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801023ce:	8b 45 08             	mov    0x8(%ebp),%eax
801023d1:	89 04 24             	mov    %eax,(%esp)
801023d4:	e8 a0 fc ff ff       	call   80102079 <readi>
801023d9:	83 f8 10             	cmp    $0x10,%eax
801023dc:	74 0c                	je     801023ea <dirlookup+0x5c>
      panic("dirlookup read");
801023de:	c7 04 24 a3 8f 10 80 	movl   $0x80108fa3,(%esp)
801023e5:	e8 c3 e2 ff ff       	call   801006ad <panic>
    if(de.inum == 0)
801023ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023ed:	66 85 c0             	test   %ax,%ax
801023f0:	75 02                	jne    801023f4 <dirlookup+0x66>
      continue;
801023f2:	eb 46                	jmp    8010243a <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
801023f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023f7:	83 c0 02             	add    $0x2,%eax
801023fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801023fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102401:	89 04 24             	mov    %eax,(%esp)
80102404:	e8 63 ff ff ff       	call   8010236c <namecmp>
80102409:	85 c0                	test   %eax,%eax
8010240b:	75 2d                	jne    8010243a <dirlookup+0xac>
      // entry matches path element
      if(poff)
8010240d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102411:	74 08                	je     8010241b <dirlookup+0x8d>
        *poff = off;
80102413:	8b 45 10             	mov    0x10(%ebp),%eax
80102416:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102419:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010241b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010241e:	0f b7 c0             	movzwl %ax,%eax
80102421:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102424:	8b 45 08             	mov    0x8(%ebp),%eax
80102427:	8b 00                	mov    (%eax),%eax
80102429:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010242c:	89 54 24 04          	mov    %edx,0x4(%esp)
80102430:	89 04 24             	mov    %eax,(%esp)
80102433:	e8 a3 f6 ff ff       	call   80101adb <iget>
80102438:	eb 18                	jmp    80102452 <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010243a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010243e:	8b 45 08             	mov    0x8(%ebp),%eax
80102441:	8b 40 58             	mov    0x58(%eax),%eax
80102444:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102447:	0f 87 6b ff ff ff    	ja     801023b8 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010244d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102452:	c9                   	leave  
80102453:	c3                   	ret    

80102454 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102454:	55                   	push   %ebp
80102455:	89 e5                	mov    %esp,%ebp
80102457:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010245a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102461:	00 
80102462:	8b 45 0c             	mov    0xc(%ebp),%eax
80102465:	89 44 24 04          	mov    %eax,0x4(%esp)
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
8010246c:	89 04 24             	mov    %eax,(%esp)
8010246f:	e8 1a ff ff ff       	call   8010238e <dirlookup>
80102474:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010247b:	74 15                	je     80102492 <dirlink+0x3e>
    iput(ip);
8010247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102480:	89 04 24             	mov    %eax,(%esp)
80102483:	e8 a8 f8 ff ff       	call   80101d30 <iput>
    return -1;
80102488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010248d:	e9 b6 00 00 00       	jmp    80102548 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102499:	eb 45                	jmp    801024e0 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010249e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801024a5:	00 
801024a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801024aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801024b1:	8b 45 08             	mov    0x8(%ebp),%eax
801024b4:	89 04 24             	mov    %eax,(%esp)
801024b7:	e8 bd fb ff ff       	call   80102079 <readi>
801024bc:	83 f8 10             	cmp    $0x10,%eax
801024bf:	74 0c                	je     801024cd <dirlink+0x79>
      panic("dirlink read");
801024c1:	c7 04 24 b2 8f 10 80 	movl   $0x80108fb2,(%esp)
801024c8:	e8 e0 e1 ff ff       	call   801006ad <panic>
    if(de.inum == 0)
801024cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801024d0:	66 85 c0             	test   %ax,%ax
801024d3:	75 02                	jne    801024d7 <dirlink+0x83>
      break;
801024d5:	eb 16                	jmp    801024ed <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024da:	83 c0 10             	add    $0x10,%eax
801024dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801024e3:	8b 45 08             	mov    0x8(%ebp),%eax
801024e6:	8b 40 58             	mov    0x58(%eax),%eax
801024e9:	39 c2                	cmp    %eax,%edx
801024eb:	72 ae                	jb     8010249b <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801024ed:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801024f4:	00 
801024f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801024f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801024fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024ff:	83 c0 02             	add    $0x2,%eax
80102502:	89 04 24             	mov    %eax,(%esp)
80102505:	e8 f2 2e 00 00       	call   801053fc <strncpy>
  de.inum = inum;
8010250a:	8b 45 10             	mov    0x10(%ebp),%eax
8010250d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102514:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010251b:	00 
8010251c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102520:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102523:	89 44 24 04          	mov    %eax,0x4(%esp)
80102527:	8b 45 08             	mov    0x8(%ebp),%eax
8010252a:	89 04 24             	mov    %eax,(%esp)
8010252d:	e8 ab fc ff ff       	call   801021dd <writei>
80102532:	83 f8 10             	cmp    $0x10,%eax
80102535:	74 0c                	je     80102543 <dirlink+0xef>
    panic("dirlink");
80102537:	c7 04 24 bf 8f 10 80 	movl   $0x80108fbf,(%esp)
8010253e:	e8 6a e1 ff ff       	call   801006ad <panic>

  return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102548:	c9                   	leave  
80102549:	c3                   	ret    

8010254a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010254a:	55                   	push   %ebp
8010254b:	89 e5                	mov    %esp,%ebp
8010254d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102550:	eb 03                	jmp    80102555 <skipelem+0xb>
    path++;
80102552:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102555:	8b 45 08             	mov    0x8(%ebp),%eax
80102558:	8a 00                	mov    (%eax),%al
8010255a:	3c 2f                	cmp    $0x2f,%al
8010255c:	74 f4                	je     80102552 <skipelem+0x8>
    path++;
  if(*path == 0)
8010255e:	8b 45 08             	mov    0x8(%ebp),%eax
80102561:	8a 00                	mov    (%eax),%al
80102563:	84 c0                	test   %al,%al
80102565:	75 0a                	jne    80102571 <skipelem+0x27>
    return 0;
80102567:	b8 00 00 00 00       	mov    $0x0,%eax
8010256c:	e9 81 00 00 00       	jmp    801025f2 <skipelem+0xa8>
  s = path;
80102571:	8b 45 08             	mov    0x8(%ebp),%eax
80102574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102577:	eb 03                	jmp    8010257c <skipelem+0x32>
    path++;
80102579:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010257c:	8b 45 08             	mov    0x8(%ebp),%eax
8010257f:	8a 00                	mov    (%eax),%al
80102581:	3c 2f                	cmp    $0x2f,%al
80102583:	74 09                	je     8010258e <skipelem+0x44>
80102585:	8b 45 08             	mov    0x8(%ebp),%eax
80102588:	8a 00                	mov    (%eax),%al
8010258a:	84 c0                	test   %al,%al
8010258c:	75 eb                	jne    80102579 <skipelem+0x2f>
    path++;
  len = path - s;
8010258e:	8b 55 08             	mov    0x8(%ebp),%edx
80102591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102594:	29 c2                	sub    %eax,%edx
80102596:	89 d0                	mov    %edx,%eax
80102598:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010259b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010259f:	7e 1c                	jle    801025bd <skipelem+0x73>
    memmove(name, s, DIRSIZ);
801025a1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801025a8:	00 
801025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801025b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801025b3:	89 04 24             	mov    %eax,(%esp)
801025b6:	e8 54 2d 00 00       	call   8010530f <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025bb:	eb 29                	jmp    801025e6 <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801025bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025c0:	89 44 24 08          	mov    %eax,0x8(%esp)
801025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801025cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801025ce:	89 04 24             	mov    %eax,(%esp)
801025d1:	e8 39 2d 00 00       	call   8010530f <memmove>
    name[len] = 0;
801025d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801025dc:	01 d0                	add    %edx,%eax
801025de:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025e1:	eb 03                	jmp    801025e6 <skipelem+0x9c>
    path++;
801025e3:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025e6:	8b 45 08             	mov    0x8(%ebp),%eax
801025e9:	8a 00                	mov    (%eax),%al
801025eb:	3c 2f                	cmp    $0x2f,%al
801025ed:	74 f4                	je     801025e3 <skipelem+0x99>
    path++;
  return path;
801025ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    

801025f4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025fa:	8b 45 08             	mov    0x8(%ebp),%eax
801025fd:	8a 00                	mov    (%eax),%al
801025ff:	3c 2f                	cmp    $0x2f,%al
80102601:	75 1c                	jne    8010261f <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102603:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260a:	00 
8010260b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102612:	e8 c4 f4 ff ff       	call   80101adb <iget>
80102617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010261a:	e9 ac 00 00 00       	jmp    801026cb <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010261f:	e8 af 1d 00 00       	call   801043d3 <myproc>
80102624:	8b 40 68             	mov    0x68(%eax),%eax
80102627:	89 04 24             	mov    %eax,(%esp)
8010262a:	e8 81 f5 ff ff       	call   80101bb0 <idup>
8010262f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102632:	e9 94 00 00 00       	jmp    801026cb <namex+0xd7>
    ilock(ip);
80102637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010263a:	89 04 24             	mov    %eax,(%esp)
8010263d:	e8 a0 f5 ff ff       	call   80101be2 <ilock>
    if(ip->type != T_DIR){
80102642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102645:	8b 40 50             	mov    0x50(%eax),%eax
80102648:	66 83 f8 01          	cmp    $0x1,%ax
8010264c:	74 15                	je     80102663 <namex+0x6f>
      iunlockput(ip);
8010264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102651:	89 04 24             	mov    %eax,(%esp)
80102654:	e8 88 f7 ff ff       	call   80101de1 <iunlockput>
      return 0;
80102659:	b8 00 00 00 00       	mov    $0x0,%eax
8010265e:	e9 a2 00 00 00       	jmp    80102705 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
80102663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102667:	74 1c                	je     80102685 <namex+0x91>
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8a 00                	mov    (%eax),%al
8010266e:	84 c0                	test   %al,%al
80102670:	75 13                	jne    80102685 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
80102672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102675:	89 04 24             	mov    %eax,(%esp)
80102678:	e8 6f f6 ff ff       	call   80101cec <iunlock>
      return ip;
8010267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102680:	e9 80 00 00 00       	jmp    80102705 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102685:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010268c:	00 
8010268d:	8b 45 10             	mov    0x10(%ebp),%eax
80102690:	89 44 24 04          	mov    %eax,0x4(%esp)
80102694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102697:	89 04 24             	mov    %eax,(%esp)
8010269a:	e8 ef fc ff ff       	call   8010238e <dirlookup>
8010269f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801026a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026a6:	75 12                	jne    801026ba <namex+0xc6>
      iunlockput(ip);
801026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026ab:	89 04 24             	mov    %eax,(%esp)
801026ae:	e8 2e f7 ff ff       	call   80101de1 <iunlockput>
      return 0;
801026b3:	b8 00 00 00 00       	mov    $0x0,%eax
801026b8:	eb 4b                	jmp    80102705 <namex+0x111>
    }
    iunlockput(ip);
801026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026bd:	89 04 24             	mov    %eax,(%esp)
801026c0:	e8 1c f7 ff ff       	call   80101de1 <iunlockput>
    ip = next;
801026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801026cb:	8b 45 10             	mov    0x10(%ebp),%eax
801026ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801026d2:	8b 45 08             	mov    0x8(%ebp),%eax
801026d5:	89 04 24             	mov    %eax,(%esp)
801026d8:	e8 6d fe ff ff       	call   8010254a <skipelem>
801026dd:	89 45 08             	mov    %eax,0x8(%ebp)
801026e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026e4:	0f 85 4d ff ff ff    	jne    80102637 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026ee:	74 12                	je     80102702 <namex+0x10e>
    iput(ip);
801026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f3:	89 04 24             	mov    %eax,(%esp)
801026f6:	e8 35 f6 ff ff       	call   80101d30 <iput>
    return 0;
801026fb:	b8 00 00 00 00       	mov    $0x0,%eax
80102700:	eb 03                	jmp    80102705 <namex+0x111>
  }
  return ip;
80102702:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102705:	c9                   	leave  
80102706:	c3                   	ret    

80102707 <namei>:

struct inode*
namei(char *path)
{
80102707:	55                   	push   %ebp
80102708:	89 e5                	mov    %esp,%ebp
8010270a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010270d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102710:	89 44 24 08          	mov    %eax,0x8(%esp)
80102714:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010271b:	00 
8010271c:	8b 45 08             	mov    0x8(%ebp),%eax
8010271f:	89 04 24             	mov    %eax,(%esp)
80102722:	e8 cd fe ff ff       	call   801025f4 <namex>
}
80102727:	c9                   	leave  
80102728:	c3                   	ret    

80102729 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102729:	55                   	push   %ebp
8010272a:	89 e5                	mov    %esp,%ebp
8010272c:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010272f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102732:	89 44 24 08          	mov    %eax,0x8(%esp)
80102736:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010273d:	00 
8010273e:	8b 45 08             	mov    0x8(%ebp),%eax
80102741:	89 04 24             	mov    %eax,(%esp)
80102744:	e8 ab fe ff ff       	call   801025f4 <namex>
}
80102749:	c9                   	leave  
8010274a:	c3                   	ret    
	...

8010274c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010274c:	55                   	push   %ebp
8010274d:	89 e5                	mov    %esp,%ebp
8010274f:	83 ec 14             	sub    $0x14,%esp
80102752:	8b 45 08             	mov    0x8(%ebp),%eax
80102755:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102759:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010275c:	89 c2                	mov    %eax,%edx
8010275e:	ec                   	in     (%dx),%al
8010275f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102762:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102765:	c9                   	leave  
80102766:	c3                   	ret    

80102767 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102767:	55                   	push   %ebp
80102768:	89 e5                	mov    %esp,%ebp
8010276a:	57                   	push   %edi
8010276b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010276c:	8b 55 08             	mov    0x8(%ebp),%edx
8010276f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102772:	8b 45 10             	mov    0x10(%ebp),%eax
80102775:	89 cb                	mov    %ecx,%ebx
80102777:	89 df                	mov    %ebx,%edi
80102779:	89 c1                	mov    %eax,%ecx
8010277b:	fc                   	cld    
8010277c:	f3 6d                	rep insl (%dx),%es:(%edi)
8010277e:	89 c8                	mov    %ecx,%eax
80102780:	89 fb                	mov    %edi,%ebx
80102782:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102785:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102788:	5b                   	pop    %ebx
80102789:	5f                   	pop    %edi
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    

8010278c <outb>:

static inline void
outb(ushort port, uchar data)
{
8010278c:	55                   	push   %ebp
8010278d:	89 e5                	mov    %esp,%ebp
8010278f:	83 ec 08             	sub    $0x8,%esp
80102792:	8b 45 08             	mov    0x8(%ebp),%eax
80102795:	8b 55 0c             	mov    0xc(%ebp),%edx
80102798:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010279c:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010279f:	8a 45 f8             	mov    -0x8(%ebp),%al
801027a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801027a5:	ee                   	out    %al,(%dx)
}
801027a6:	c9                   	leave  
801027a7:	c3                   	ret    

801027a8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801027a8:	55                   	push   %ebp
801027a9:	89 e5                	mov    %esp,%ebp
801027ab:	56                   	push   %esi
801027ac:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801027ad:	8b 55 08             	mov    0x8(%ebp),%edx
801027b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b3:	8b 45 10             	mov    0x10(%ebp),%eax
801027b6:	89 cb                	mov    %ecx,%ebx
801027b8:	89 de                	mov    %ebx,%esi
801027ba:	89 c1                	mov    %eax,%ecx
801027bc:	fc                   	cld    
801027bd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801027bf:	89 c8                	mov    %ecx,%eax
801027c1:	89 f3                	mov    %esi,%ebx
801027c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801027c6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801027c9:	5b                   	pop    %ebx
801027ca:	5e                   	pop    %esi
801027cb:	5d                   	pop    %ebp
801027cc:	c3                   	ret    

801027cd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801027cd:	55                   	push   %ebp
801027ce:	89 e5                	mov    %esp,%ebp
801027d0:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027d3:	90                   	nop
801027d4:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027db:	e8 6c ff ff ff       	call   8010274c <inb>
801027e0:	0f b6 c0             	movzbl %al,%eax
801027e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
801027e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027e9:	25 c0 00 00 00       	and    $0xc0,%eax
801027ee:	83 f8 40             	cmp    $0x40,%eax
801027f1:	75 e1                	jne    801027d4 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801027f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027f7:	74 11                	je     8010280a <idewait+0x3d>
801027f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027fc:	83 e0 21             	and    $0x21,%eax
801027ff:	85 c0                	test   %eax,%eax
80102801:	74 07                	je     8010280a <idewait+0x3d>
    return -1;
80102803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102808:	eb 05                	jmp    8010280f <idewait+0x42>
  return 0;
8010280a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010280f:	c9                   	leave  
80102810:	c3                   	ret    

80102811 <ideinit>:

void
ideinit(void)
{
80102811:	55                   	push   %ebp
80102812:	89 e5                	mov    %esp,%ebp
80102814:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102817:	c7 44 24 04 c7 8f 10 	movl   $0x80108fc7,0x4(%esp)
8010281e:	80 
8010281f:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102826:	e8 97 27 00 00       	call   80104fc2 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010282b:	a1 20 52 11 80       	mov    0x80115220,%eax
80102830:	48                   	dec    %eax
80102831:	89 44 24 04          	mov    %eax,0x4(%esp)
80102835:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010283c:	e8 66 04 00 00       	call   80102ca7 <ioapicenable>
  idewait(0);
80102841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102848:	e8 80 ff ff ff       	call   801027cd <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010284d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102854:	00 
80102855:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010285c:	e8 2b ff ff ff       	call   8010278c <outb>
  for(i=0; i<1000; i++){
80102861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102868:	eb 1f                	jmp    80102889 <ideinit+0x78>
    if(inb(0x1f7) != 0){
8010286a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102871:	e8 d6 fe ff ff       	call   8010274c <inb>
80102876:	84 c0                	test   %al,%al
80102878:	74 0c                	je     80102886 <ideinit+0x75>
      havedisk1 = 1;
8010287a:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102881:	00 00 00 
      break;
80102884:	eb 0c                	jmp    80102892 <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102886:	ff 45 f4             	incl   -0xc(%ebp)
80102889:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102890:	7e d8                	jle    8010286a <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102892:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102899:	00 
8010289a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801028a1:	e8 e6 fe ff ff       	call   8010278c <outb>
}
801028a6:	c9                   	leave  
801028a7:	c3                   	ret    

801028a8 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801028a8:	55                   	push   %ebp
801028a9:	89 e5                	mov    %esp,%ebp
801028ab:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801028ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028b2:	75 0c                	jne    801028c0 <idestart+0x18>
    panic("idestart");
801028b4:	c7 04 24 cb 8f 10 80 	movl   $0x80108fcb,(%esp)
801028bb:	e8 ed dd ff ff       	call   801006ad <panic>
  if(b->blockno >= FSSIZE)
801028c0:	8b 45 08             	mov    0x8(%ebp),%eax
801028c3:	8b 40 08             	mov    0x8(%eax),%eax
801028c6:	3d 1f 4e 00 00       	cmp    $0x4e1f,%eax
801028cb:	76 0c                	jbe    801028d9 <idestart+0x31>
    panic("incorrect blockno");
801028cd:	c7 04 24 d4 8f 10 80 	movl   $0x80108fd4,(%esp)
801028d4:	e8 d4 dd ff ff       	call   801006ad <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801028d9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801028e0:	8b 45 08             	mov    0x8(%ebp),%eax
801028e3:	8b 50 08             	mov    0x8(%eax),%edx
801028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e9:	0f af c2             	imul   %edx,%eax
801028ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
801028ef:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801028f3:	75 07                	jne    801028fc <idestart+0x54>
801028f5:	b8 20 00 00 00       	mov    $0x20,%eax
801028fa:	eb 05                	jmp    80102901 <idestart+0x59>
801028fc:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102901:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102904:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102908:	75 07                	jne    80102911 <idestart+0x69>
8010290a:	b8 30 00 00 00       	mov    $0x30,%eax
8010290f:	eb 05                	jmp    80102916 <idestart+0x6e>
80102911:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102916:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102919:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010291d:	7e 0c                	jle    8010292b <idestart+0x83>
8010291f:	c7 04 24 cb 8f 10 80 	movl   $0x80108fcb,(%esp)
80102926:	e8 82 dd ff ff       	call   801006ad <panic>

  idewait(0);
8010292b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102932:	e8 96 fe ff ff       	call   801027cd <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102937:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010293e:	00 
8010293f:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102946:	e8 41 fe ff ff       	call   8010278c <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
8010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294e:	0f b6 c0             	movzbl %al,%eax
80102951:	89 44 24 04          	mov    %eax,0x4(%esp)
80102955:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010295c:	e8 2b fe ff ff       	call   8010278c <outb>
  outb(0x1f3, sector & 0xff);
80102961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102964:	0f b6 c0             	movzbl %al,%eax
80102967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010296b:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102972:	e8 15 fe ff ff       	call   8010278c <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
80102977:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010297a:	c1 f8 08             	sar    $0x8,%eax
8010297d:	0f b6 c0             	movzbl %al,%eax
80102980:	89 44 24 04          	mov    %eax,0x4(%esp)
80102984:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010298b:	e8 fc fd ff ff       	call   8010278c <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102993:	c1 f8 10             	sar    $0x10,%eax
80102996:	0f b6 c0             	movzbl %al,%eax
80102999:	89 44 24 04          	mov    %eax,0x4(%esp)
8010299d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801029a4:	e8 e3 fd ff ff       	call   8010278c <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801029a9:	8b 45 08             	mov    0x8(%ebp),%eax
801029ac:	8b 40 04             	mov    0x4(%eax),%eax
801029af:	83 e0 01             	and    $0x1,%eax
801029b2:	c1 e0 04             	shl    $0x4,%eax
801029b5:	88 c2                	mov    %al,%dl
801029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029ba:	c1 f8 18             	sar    $0x18,%eax
801029bd:	83 e0 0f             	and    $0xf,%eax
801029c0:	09 d0                	or     %edx,%eax
801029c2:	83 c8 e0             	or     $0xffffffe0,%eax
801029c5:	0f b6 c0             	movzbl %al,%eax
801029c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029cc:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801029d3:	e8 b4 fd ff ff       	call   8010278c <outb>
  if(b->flags & B_DIRTY){
801029d8:	8b 45 08             	mov    0x8(%ebp),%eax
801029db:	8b 00                	mov    (%eax),%eax
801029dd:	83 e0 04             	and    $0x4,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	74 36                	je     80102a1a <idestart+0x172>
    outb(0x1f7, write_cmd);
801029e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801029e7:	0f b6 c0             	movzbl %al,%eax
801029ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ee:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801029f5:	e8 92 fd ff ff       	call   8010278c <outb>
    outsl(0x1f0, b->data, BSIZE/4);
801029fa:	8b 45 08             	mov    0x8(%ebp),%eax
801029fd:	83 c0 5c             	add    $0x5c,%eax
80102a00:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102a07:	00 
80102a08:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0c:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102a13:	e8 90 fd ff ff       	call   801027a8 <outsl>
80102a18:	eb 16                	jmp    80102a30 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a1d:	0f b6 c0             	movzbl %al,%eax
80102a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a24:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102a2b:	e8 5c fd ff ff       	call   8010278c <outb>
  }
}
80102a30:	c9                   	leave  
80102a31:	c3                   	ret    

80102a32 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a32:	55                   	push   %ebp
80102a33:	89 e5                	mov    %esp,%ebp
80102a35:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a38:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102a3f:	e8 9f 25 00 00       	call   80104fe3 <acquire>

  if((b = idequeue) == 0){
80102a44:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a50:	75 11                	jne    80102a63 <ideintr+0x31>
    release(&idelock);
80102a52:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102a59:	e8 ef 25 00 00       	call   8010504d <release>
    return;
80102a5e:	e9 90 00 00 00       	jmp    80102af3 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a66:	8b 40 58             	mov    0x58(%eax),%eax
80102a69:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a71:	8b 00                	mov    (%eax),%eax
80102a73:	83 e0 04             	and    $0x4,%eax
80102a76:	85 c0                	test   %eax,%eax
80102a78:	75 2e                	jne    80102aa8 <ideintr+0x76>
80102a7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a81:	e8 47 fd ff ff       	call   801027cd <idewait>
80102a86:	85 c0                	test   %eax,%eax
80102a88:	78 1e                	js     80102aa8 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8d:	83 c0 5c             	add    $0x5c,%eax
80102a90:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102a97:	00 
80102a98:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a9c:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102aa3:	e8 bf fc ff ff       	call   80102767 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aab:	8b 00                	mov    (%eax),%eax
80102aad:	83 c8 02             	or     $0x2,%eax
80102ab0:	89 c2                	mov    %eax,%edx
80102ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab5:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aba:	8b 00                	mov    (%eax),%eax
80102abc:	83 e0 fb             	and    $0xfffffffb,%eax
80102abf:	89 c2                	mov    %eax,%edx
80102ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac4:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac9:	89 04 24             	mov    %eax,(%esp)
80102acc:	e8 17 22 00 00       	call   80104ce8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ad1:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102ad6:	85 c0                	test   %eax,%eax
80102ad8:	74 0d                	je     80102ae7 <ideintr+0xb5>
    idestart(idequeue);
80102ada:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102adf:	89 04 24             	mov    %eax,(%esp)
80102ae2:	e8 c1 fd ff ff       	call   801028a8 <idestart>

  release(&idelock);
80102ae7:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102aee:	e8 5a 25 00 00       	call   8010504d <release>
}
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    

80102af5 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102afb:	8b 45 08             	mov    0x8(%ebp),%eax
80102afe:	83 c0 0c             	add    $0xc,%eax
80102b01:	89 04 24             	mov    %eax,(%esp)
80102b04:	e8 52 24 00 00       	call   80104f5b <holdingsleep>
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	75 0c                	jne    80102b19 <iderw+0x24>
    panic("iderw: buf not locked");
80102b0d:	c7 04 24 e6 8f 10 80 	movl   $0x80108fe6,(%esp)
80102b14:	e8 94 db ff ff       	call   801006ad <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b19:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1c:	8b 00                	mov    (%eax),%eax
80102b1e:	83 e0 06             	and    $0x6,%eax
80102b21:	83 f8 02             	cmp    $0x2,%eax
80102b24:	75 0c                	jne    80102b32 <iderw+0x3d>
    panic("iderw: nothing to do");
80102b26:	c7 04 24 fc 8f 10 80 	movl   $0x80108ffc,(%esp)
80102b2d:	e8 7b db ff ff       	call   801006ad <panic>
  if(b->dev != 0 && !havedisk1)
80102b32:	8b 45 08             	mov    0x8(%ebp),%eax
80102b35:	8b 40 04             	mov    0x4(%eax),%eax
80102b38:	85 c0                	test   %eax,%eax
80102b3a:	74 15                	je     80102b51 <iderw+0x5c>
80102b3c:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	75 0c                	jne    80102b51 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102b45:	c7 04 24 11 90 10 80 	movl   $0x80109011,(%esp)
80102b4c:	e8 5c db ff ff       	call   801006ad <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b51:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102b58:	e8 86 24 00 00       	call   80104fe3 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b60:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b67:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102b6e:	eb 0b                	jmp    80102b7b <iderw+0x86>
80102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b73:	8b 00                	mov    (%eax),%eax
80102b75:	83 c0 58             	add    $0x58,%eax
80102b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7e:	8b 00                	mov    (%eax),%eax
80102b80:	85 c0                	test   %eax,%eax
80102b82:	75 ec                	jne    80102b70 <iderw+0x7b>
    ;
  *pp = b;
80102b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b87:	8b 55 08             	mov    0x8(%ebp),%edx
80102b8a:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b8c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102b91:	3b 45 08             	cmp    0x8(%ebp),%eax
80102b94:	75 0d                	jne    80102ba3 <iderw+0xae>
    idestart(b);
80102b96:	8b 45 08             	mov    0x8(%ebp),%eax
80102b99:	89 04 24             	mov    %eax,(%esp)
80102b9c:	e8 07 fd ff ff       	call   801028a8 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ba1:	eb 15                	jmp    80102bb8 <iderw+0xc3>
80102ba3:	eb 13                	jmp    80102bb8 <iderw+0xc3>
    sleep(b, &idelock);
80102ba5:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102bac:	80 
80102bad:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb0:	89 04 24             	mov    %eax,(%esp)
80102bb3:	e8 5c 20 00 00       	call   80104c14 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbb:	8b 00                	mov    (%eax),%eax
80102bbd:	83 e0 06             	and    $0x6,%eax
80102bc0:	83 f8 02             	cmp    $0x2,%eax
80102bc3:	75 e0                	jne    80102ba5 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102bc5:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102bcc:	e8 7c 24 00 00       	call   8010504d <release>
}
80102bd1:	c9                   	leave  
80102bd2:	c3                   	ret    
	...

80102bd4 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102bd4:	55                   	push   %ebp
80102bd5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bd7:	a1 54 4b 11 80       	mov    0x80114b54,%eax
80102bdc:	8b 55 08             	mov    0x8(%ebp),%edx
80102bdf:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102be1:	a1 54 4b 11 80       	mov    0x80114b54,%eax
80102be6:	8b 40 10             	mov    0x10(%eax),%eax
}
80102be9:	5d                   	pop    %ebp
80102bea:	c3                   	ret    

80102beb <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102beb:	55                   	push   %ebp
80102bec:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bee:	a1 54 4b 11 80       	mov    0x80114b54,%eax
80102bf3:	8b 55 08             	mov    0x8(%ebp),%edx
80102bf6:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102bf8:	a1 54 4b 11 80       	mov    0x80114b54,%eax
80102bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80102c00:	89 50 10             	mov    %edx,0x10(%eax)
}
80102c03:	5d                   	pop    %ebp
80102c04:	c3                   	ret    

80102c05 <ioapicinit>:

void
ioapicinit(void)
{
80102c05:	55                   	push   %ebp
80102c06:	89 e5                	mov    %esp,%ebp
80102c08:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c0b:	c7 05 54 4b 11 80 00 	movl   $0xfec00000,0x80114b54
80102c12:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102c1c:	e8 b3 ff ff ff       	call   80102bd4 <ioapicread>
80102c21:	c1 e8 10             	shr    $0x10,%eax
80102c24:	25 ff 00 00 00       	and    $0xff,%eax
80102c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102c2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102c33:	e8 9c ff ff ff       	call   80102bd4 <ioapicread>
80102c38:	c1 e8 18             	shr    $0x18,%eax
80102c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c3e:	a0 80 4c 11 80       	mov    0x80114c80,%al
80102c43:	0f b6 c0             	movzbl %al,%eax
80102c46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102c49:	74 0c                	je     80102c57 <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c4b:	c7 04 24 30 90 10 80 	movl   $0x80109030,(%esp)
80102c52:	e8 c3 d8 ff ff       	call   8010051a <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c5e:	eb 3d                	jmp    80102c9d <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c63:	83 c0 20             	add    $0x20,%eax
80102c66:	0d 00 00 01 00       	or     $0x10000,%eax
80102c6b:	89 c2                	mov    %eax,%edx
80102c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c70:	83 c0 08             	add    $0x8,%eax
80102c73:	01 c0                	add    %eax,%eax
80102c75:	89 54 24 04          	mov    %edx,0x4(%esp)
80102c79:	89 04 24             	mov    %eax,(%esp)
80102c7c:	e8 6a ff ff ff       	call   80102beb <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c84:	83 c0 08             	add    $0x8,%eax
80102c87:	01 c0                	add    %eax,%eax
80102c89:	40                   	inc    %eax
80102c8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102c91:	00 
80102c92:	89 04 24             	mov    %eax,(%esp)
80102c95:	e8 51 ff ff ff       	call   80102beb <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c9a:	ff 45 f4             	incl   -0xc(%ebp)
80102c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ca3:	7e bb                	jle    80102c60 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ca5:	c9                   	leave  
80102ca6:	c3                   	ret    

80102ca7 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ca7:	55                   	push   %ebp
80102ca8:	89 e5                	mov    %esp,%ebp
80102caa:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102cad:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb0:	83 c0 20             	add    $0x20,%eax
80102cb3:	89 c2                	mov    %eax,%edx
80102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb8:	83 c0 08             	add    $0x8,%eax
80102cbb:	01 c0                	add    %eax,%eax
80102cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80102cc1:	89 04 24             	mov    %eax,(%esp)
80102cc4:	e8 22 ff ff ff       	call   80102beb <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ccc:	c1 e0 18             	shl    $0x18,%eax
80102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd2:	83 c2 08             	add    $0x8,%edx
80102cd5:	01 d2                	add    %edx,%edx
80102cd7:	42                   	inc    %edx
80102cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cdc:	89 14 24             	mov    %edx,(%esp)
80102cdf:	e8 07 ff ff ff       	call   80102beb <ioapicwrite>
}
80102ce4:	c9                   	leave  
80102ce5:	c3                   	ret    
	...

80102ce8 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102cee:	c7 44 24 04 62 90 10 	movl   $0x80109062,0x4(%esp)
80102cf5:	80 
80102cf6:	c7 04 24 60 4b 11 80 	movl   $0x80114b60,(%esp)
80102cfd:	e8 c0 22 00 00       	call   80104fc2 <initlock>
  kmem.use_lock = 0;
80102d02:	c7 05 94 4b 11 80 00 	movl   $0x0,0x80114b94
80102d09:	00 00 00 
  freerange(vstart, vend);
80102d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d13:	8b 45 08             	mov    0x8(%ebp),%eax
80102d16:	89 04 24             	mov    %eax,(%esp)
80102d19:	e8 26 00 00 00       	call   80102d44 <freerange>
}
80102d1e:	c9                   	leave  
80102d1f:	c3                   	ret    

80102d20 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d29:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d30:	89 04 24             	mov    %eax,(%esp)
80102d33:	e8 0c 00 00 00       	call   80102d44 <freerange>
  kmem.use_lock = 1;
80102d38:	c7 05 94 4b 11 80 01 	movl   $0x1,0x80114b94
80102d3f:	00 00 00 
}
80102d42:	c9                   	leave  
80102d43:	c3                   	ret    

80102d44 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4d:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d5a:	eb 12                	jmp    80102d6e <freerange+0x2a>
    kfree(p);
80102d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d5f:	89 04 24             	mov    %eax,(%esp)
80102d62:	e8 16 00 00 00       	call   80102d7d <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d67:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d71:	05 00 10 00 00       	add    $0x1000,%eax
80102d76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102d79:	76 e1                	jbe    80102d5c <freerange+0x18>
    kfree(p);
}
80102d7b:	c9                   	leave  
80102d7c:	c3                   	ret    

80102d7d <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d7d:	55                   	push   %ebp
80102d7e:	89 e5                	mov    %esp,%ebp
80102d80:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d83:	8b 45 08             	mov    0x8(%ebp),%eax
80102d86:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d8b:	85 c0                	test   %eax,%eax
80102d8d:	75 18                	jne    80102da7 <kfree+0x2a>
80102d8f:	81 7d 08 c8 79 11 80 	cmpl   $0x801179c8,0x8(%ebp)
80102d96:	72 0f                	jb     80102da7 <kfree+0x2a>
80102d98:	8b 45 08             	mov    0x8(%ebp),%eax
80102d9b:	05 00 00 00 80       	add    $0x80000000,%eax
80102da0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102da5:	76 0c                	jbe    80102db3 <kfree+0x36>
    panic("kfree");
80102da7:	c7 04 24 67 90 10 80 	movl   $0x80109067,(%esp)
80102dae:	e8 fa d8 ff ff       	call   801006ad <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102db3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102dba:	00 
80102dbb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102dc2:	00 
80102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102dc6:	89 04 24             	mov    %eax,(%esp)
80102dc9:	e8 78 24 00 00       	call   80105246 <memset>

  if(kmem.use_lock)
80102dce:	a1 94 4b 11 80       	mov    0x80114b94,%eax
80102dd3:	85 c0                	test   %eax,%eax
80102dd5:	74 0c                	je     80102de3 <kfree+0x66>
    acquire(&kmem.lock);
80102dd7:	c7 04 24 60 4b 11 80 	movl   $0x80114b60,(%esp)
80102dde:	e8 00 22 00 00       	call   80104fe3 <acquire>
  r = (struct run*)v;
80102de3:	8b 45 08             	mov    0x8(%ebp),%eax
80102de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102de9:	8b 15 98 4b 11 80    	mov    0x80114b98,%edx
80102def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df2:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df7:	a3 98 4b 11 80       	mov    %eax,0x80114b98
  if(kmem.use_lock)
80102dfc:	a1 94 4b 11 80       	mov    0x80114b94,%eax
80102e01:	85 c0                	test   %eax,%eax
80102e03:	74 0c                	je     80102e11 <kfree+0x94>
    release(&kmem.lock);
80102e05:	c7 04 24 60 4b 11 80 	movl   $0x80114b60,(%esp)
80102e0c:	e8 3c 22 00 00       	call   8010504d <release>
}
80102e11:	c9                   	leave  
80102e12:	c3                   	ret    

80102e13 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e13:	55                   	push   %ebp
80102e14:	89 e5                	mov    %esp,%ebp
80102e16:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102e19:	a1 94 4b 11 80       	mov    0x80114b94,%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	74 0c                	je     80102e2e <kalloc+0x1b>
    acquire(&kmem.lock);
80102e22:	c7 04 24 60 4b 11 80 	movl   $0x80114b60,(%esp)
80102e29:	e8 b5 21 00 00       	call   80104fe3 <acquire>
  r = kmem.freelist;
80102e2e:	a1 98 4b 11 80       	mov    0x80114b98,%eax
80102e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e3a:	74 0a                	je     80102e46 <kalloc+0x33>
    kmem.freelist = r->next;
80102e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e3f:	8b 00                	mov    (%eax),%eax
80102e41:	a3 98 4b 11 80       	mov    %eax,0x80114b98
  if(kmem.use_lock)
80102e46:	a1 94 4b 11 80       	mov    0x80114b94,%eax
80102e4b:	85 c0                	test   %eax,%eax
80102e4d:	74 0c                	je     80102e5b <kalloc+0x48>
    release(&kmem.lock);
80102e4f:	c7 04 24 60 4b 11 80 	movl   $0x80114b60,(%esp)
80102e56:	e8 f2 21 00 00       	call   8010504d <release>
  return (char*)r;
80102e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e5e:	c9                   	leave  
80102e5f:	c3                   	ret    

80102e60 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 14             	sub    $0x14,%esp
80102e66:	8b 45 08             	mov    0x8(%ebp),%eax
80102e69:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e70:	89 c2                	mov    %eax,%edx
80102e72:	ec                   	in     (%dx),%al
80102e73:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e76:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102e79:	c9                   	leave  
80102e7a:	c3                   	ret    

80102e7b <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e7b:	55                   	push   %ebp
80102e7c:	89 e5                	mov    %esp,%ebp
80102e7e:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e81:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102e88:	e8 d3 ff ff ff       	call   80102e60 <inb>
80102e8d:	0f b6 c0             	movzbl %al,%eax
80102e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e96:	83 e0 01             	and    $0x1,%eax
80102e99:	85 c0                	test   %eax,%eax
80102e9b:	75 0a                	jne    80102ea7 <kbdgetc+0x2c>
    return -1;
80102e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ea2:	e9 21 01 00 00       	jmp    80102fc8 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102ea7:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102eae:	e8 ad ff ff ff       	call   80102e60 <inb>
80102eb3:	0f b6 c0             	movzbl %al,%eax
80102eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102eb9:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ec0:	75 17                	jne    80102ed9 <kbdgetc+0x5e>
    shift |= E0ESC;
80102ec2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ec7:	83 c8 40             	or     $0x40,%eax
80102eca:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ecf:	b8 00 00 00 00       	mov    $0x0,%eax
80102ed4:	e9 ef 00 00 00       	jmp    80102fc8 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102edc:	25 80 00 00 00       	and    $0x80,%eax
80102ee1:	85 c0                	test   %eax,%eax
80102ee3:	74 44                	je     80102f29 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ee5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102eea:	83 e0 40             	and    $0x40,%eax
80102eed:	85 c0                	test   %eax,%eax
80102eef:	75 08                	jne    80102ef9 <kbdgetc+0x7e>
80102ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ef4:	83 e0 7f             	and    $0x7f,%eax
80102ef7:	eb 03                	jmp    80102efc <kbdgetc+0x81>
80102ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f02:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f07:	8a 00                	mov    (%eax),%al
80102f09:	83 c8 40             	or     $0x40,%eax
80102f0c:	0f b6 c0             	movzbl %al,%eax
80102f0f:	f7 d0                	not    %eax
80102f11:	89 c2                	mov    %eax,%edx
80102f13:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f18:	21 d0                	and    %edx,%eax
80102f1a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102f1f:	b8 00 00 00 00       	mov    $0x0,%eax
80102f24:	e9 9f 00 00 00       	jmp    80102fc8 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102f29:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f2e:	83 e0 40             	and    $0x40,%eax
80102f31:	85 c0                	test   %eax,%eax
80102f33:	74 14                	je     80102f49 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f35:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f3c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f41:	83 e0 bf             	and    $0xffffffbf,%eax
80102f44:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f4c:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f51:	8a 00                	mov    (%eax),%al
80102f53:	0f b6 d0             	movzbl %al,%edx
80102f56:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f5b:	09 d0                	or     %edx,%eax
80102f5d:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f65:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102f6a:	8a 00                	mov    (%eax),%al
80102f6c:	0f b6 d0             	movzbl %al,%edx
80102f6f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f74:	31 d0                	xor    %edx,%eax
80102f76:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f7b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f80:	83 e0 03             	and    $0x3,%eax
80102f83:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f8d:	01 d0                	add    %edx,%eax
80102f8f:	8a 00                	mov    (%eax),%al
80102f91:	0f b6 c0             	movzbl %al,%eax
80102f94:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f97:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f9c:	83 e0 08             	and    $0x8,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	74 22                	je     80102fc5 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102fa3:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fa7:	76 0c                	jbe    80102fb5 <kbdgetc+0x13a>
80102fa9:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102fad:	77 06                	ja     80102fb5 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102faf:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fb3:	eb 10                	jmp    80102fc5 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102fb5:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fb9:	76 0a                	jbe    80102fc5 <kbdgetc+0x14a>
80102fbb:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102fbf:	77 04                	ja     80102fc5 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102fc1:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fc8:	c9                   	leave  
80102fc9:	c3                   	ret    

80102fca <kbdintr>:

void
kbdintr(void)
{
80102fca:	55                   	push   %ebp
80102fcb:	89 e5                	mov    %esp,%ebp
80102fcd:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102fd0:	c7 04 24 7b 2e 10 80 	movl   $0x80102e7b,(%esp)
80102fd7:	e8 72 d9 ff ff       	call   8010094e <consoleintr>
}
80102fdc:	c9                   	leave  
80102fdd:	c3                   	ret    
	...

80102fe0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 14             	sub    $0x14,%esp
80102fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80102fe9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ff0:	89 c2                	mov    %eax,%edx
80102ff2:	ec                   	in     (%dx),%al
80102ff3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ff6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102ff9:	c9                   	leave  
80102ffa:	c3                   	ret    

80102ffb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ffb:	55                   	push   %ebp
80102ffc:	89 e5                	mov    %esp,%ebp
80102ffe:	83 ec 08             	sub    $0x8,%esp
80103001:	8b 45 08             	mov    0x8(%ebp),%eax
80103004:	8b 55 0c             	mov    0xc(%ebp),%edx
80103007:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010300b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010300e:	8a 45 f8             	mov    -0x8(%ebp),%al
80103011:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103014:	ee                   	out    %al,(%dx)
}
80103015:	c9                   	leave  
80103016:	c3                   	ret    

80103017 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103017:	55                   	push   %ebp
80103018:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010301a:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
8010301f:	8b 55 08             	mov    0x8(%ebp),%edx
80103022:	c1 e2 02             	shl    $0x2,%edx
80103025:	01 c2                	add    %eax,%edx
80103027:	8b 45 0c             	mov    0xc(%ebp),%eax
8010302a:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010302c:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
80103031:	83 c0 20             	add    $0x20,%eax
80103034:	8b 00                	mov    (%eax),%eax
}
80103036:	5d                   	pop    %ebp
80103037:	c3                   	ret    

80103038 <lapicinit>:

void
lapicinit(void)
{
80103038:	55                   	push   %ebp
80103039:	89 e5                	mov    %esp,%ebp
8010303b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
8010303e:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
80103043:	85 c0                	test   %eax,%eax
80103045:	75 05                	jne    8010304c <lapicinit+0x14>
    return;
80103047:	e9 43 01 00 00       	jmp    8010318f <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010304c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80103053:	00 
80103054:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
8010305b:	e8 b7 ff ff ff       	call   80103017 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103060:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80103067:	00 
80103068:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
8010306f:	e8 a3 ff ff ff       	call   80103017 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103074:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
8010307b:	00 
8010307c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103083:	e8 8f ff ff ff       	call   80103017 <lapicw>
  lapicw(TICR, 10000000);
80103088:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
8010308f:	00 
80103090:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80103097:	e8 7b ff ff ff       	call   80103017 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010309c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030a3:	00 
801030a4:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
801030ab:	e8 67 ff ff ff       	call   80103017 <lapicw>
  lapicw(LINT1, MASKED);
801030b0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030b7:	00 
801030b8:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
801030bf:	e8 53 ff ff ff       	call   80103017 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030c4:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
801030c9:	83 c0 30             	add    $0x30,%eax
801030cc:	8b 00                	mov    (%eax),%eax
801030ce:	c1 e8 10             	shr    $0x10,%eax
801030d1:	0f b6 c0             	movzbl %al,%eax
801030d4:	83 f8 03             	cmp    $0x3,%eax
801030d7:	76 14                	jbe    801030ed <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
801030d9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030e0:	00 
801030e1:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
801030e8:	e8 2a ff ff ff       	call   80103017 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030ed:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
801030f4:	00 
801030f5:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
801030fc:	e8 16 ff ff ff       	call   80103017 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103101:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103108:	00 
80103109:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103110:	e8 02 ff ff ff       	call   80103017 <lapicw>
  lapicw(ESR, 0);
80103115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010311c:	00 
8010311d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103124:	e8 ee fe ff ff       	call   80103017 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103130:	00 
80103131:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103138:	e8 da fe ff ff       	call   80103017 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010313d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103144:	00 
80103145:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010314c:	e8 c6 fe ff ff       	call   80103017 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103151:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103158:	00 
80103159:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103160:	e8 b2 fe ff ff       	call   80103017 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80103165:	90                   	nop
80103166:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
8010316b:	05 00 03 00 00       	add    $0x300,%eax
80103170:	8b 00                	mov    (%eax),%eax
80103172:	25 00 10 00 00       	and    $0x1000,%eax
80103177:	85 c0                	test   %eax,%eax
80103179:	75 eb                	jne    80103166 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010317b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103182:	00 
80103183:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010318a:	e8 88 fe ff ff       	call   80103017 <lapicw>
}
8010318f:	c9                   	leave  
80103190:	c3                   	ret    

80103191 <lapicid>:

int
lapicid(void)
{
80103191:	55                   	push   %ebp
80103192:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103194:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
80103199:	85 c0                	test   %eax,%eax
8010319b:	75 07                	jne    801031a4 <lapicid+0x13>
    return 0;
8010319d:	b8 00 00 00 00       	mov    $0x0,%eax
801031a2:	eb 0d                	jmp    801031b1 <lapicid+0x20>
  return lapic[ID] >> 24;
801031a4:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
801031a9:	83 c0 20             	add    $0x20,%eax
801031ac:	8b 00                	mov    (%eax),%eax
801031ae:	c1 e8 18             	shr    $0x18,%eax
}
801031b1:	5d                   	pop    %ebp
801031b2:	c3                   	ret    

801031b3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031b3:	55                   	push   %ebp
801031b4:	89 e5                	mov    %esp,%ebp
801031b6:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
801031b9:	a1 9c 4b 11 80       	mov    0x80114b9c,%eax
801031be:	85 c0                	test   %eax,%eax
801031c0:	74 14                	je     801031d6 <lapiceoi+0x23>
    lapicw(EOI, 0);
801031c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801031c9:	00 
801031ca:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
801031d1:	e8 41 fe ff ff       	call   80103017 <lapicw>
}
801031d6:	c9                   	leave  
801031d7:	c3                   	ret    

801031d8 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031d8:	55                   	push   %ebp
801031d9:	89 e5                	mov    %esp,%ebp
}
801031db:	5d                   	pop    %ebp
801031dc:	c3                   	ret    

801031dd <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031dd:	55                   	push   %ebp
801031de:	89 e5                	mov    %esp,%ebp
801031e0:	83 ec 1c             	sub    $0x1c,%esp
801031e3:	8b 45 08             	mov    0x8(%ebp),%eax
801031e6:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031e9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801031f0:	00 
801031f1:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801031f8:	e8 fe fd ff ff       	call   80102ffb <outb>
  outb(CMOS_PORT+1, 0x0A);
801031fd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103204:	00 
80103205:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010320c:	e8 ea fd ff ff       	call   80102ffb <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103211:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103218:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010321b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103220:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103223:	8d 50 02             	lea    0x2(%eax),%edx
80103226:	8b 45 0c             	mov    0xc(%ebp),%eax
80103229:	c1 e8 04             	shr    $0x4,%eax
8010322c:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010322f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103233:	c1 e0 18             	shl    $0x18,%eax
80103236:	89 44 24 04          	mov    %eax,0x4(%esp)
8010323a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103241:	e8 d1 fd ff ff       	call   80103017 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103246:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010324d:	00 
8010324e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103255:	e8 bd fd ff ff       	call   80103017 <lapicw>
  microdelay(200);
8010325a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103261:	e8 72 ff ff ff       	call   801031d8 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103266:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010326d:	00 
8010326e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103275:	e8 9d fd ff ff       	call   80103017 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010327a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103281:	e8 52 ff ff ff       	call   801031d8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010328d:	eb 3f                	jmp    801032ce <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
8010328f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103293:	c1 e0 18             	shl    $0x18,%eax
80103296:	89 44 24 04          	mov    %eax,0x4(%esp)
8010329a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801032a1:	e8 71 fd ff ff       	call   80103017 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801032a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801032a9:	c1 e8 0c             	shr    $0xc,%eax
801032ac:	80 cc 06             	or     $0x6,%ah
801032af:	89 44 24 04          	mov    %eax,0x4(%esp)
801032b3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801032ba:	e8 58 fd ff ff       	call   80103017 <lapicw>
    microdelay(200);
801032bf:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801032c6:	e8 0d ff ff ff       	call   801031d8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801032cb:	ff 45 fc             	incl   -0x4(%ebp)
801032ce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801032d2:	7e bb                	jle    8010328f <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801032d4:	c9                   	leave  
801032d5:	c3                   	ret    

801032d6 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801032d6:	55                   	push   %ebp
801032d7:	89 e5                	mov    %esp,%ebp
801032d9:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801032dc:	8b 45 08             	mov    0x8(%ebp),%eax
801032df:	0f b6 c0             	movzbl %al,%eax
801032e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801032e6:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801032ed:	e8 09 fd ff ff       	call   80102ffb <outb>
  microdelay(200);
801032f2:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801032f9:	e8 da fe ff ff       	call   801031d8 <microdelay>

  return inb(CMOS_RETURN);
801032fe:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103305:	e8 d6 fc ff ff       	call   80102fe0 <inb>
8010330a:	0f b6 c0             	movzbl %al,%eax
}
8010330d:	c9                   	leave  
8010330e:	c3                   	ret    

8010330f <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010330f:	55                   	push   %ebp
80103310:	89 e5                	mov    %esp,%ebp
80103312:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103315:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010331c:	e8 b5 ff ff ff       	call   801032d6 <cmos_read>
80103321:	8b 55 08             	mov    0x8(%ebp),%edx
80103324:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103326:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010332d:	e8 a4 ff ff ff       	call   801032d6 <cmos_read>
80103332:	8b 55 08             	mov    0x8(%ebp),%edx
80103335:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103338:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010333f:	e8 92 ff ff ff       	call   801032d6 <cmos_read>
80103344:	8b 55 08             	mov    0x8(%ebp),%edx
80103347:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010334a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103351:	e8 80 ff ff ff       	call   801032d6 <cmos_read>
80103356:	8b 55 08             	mov    0x8(%ebp),%edx
80103359:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010335c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103363:	e8 6e ff ff ff       	call   801032d6 <cmos_read>
80103368:	8b 55 08             	mov    0x8(%ebp),%edx
8010336b:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010336e:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103375:	e8 5c ff ff ff       	call   801032d6 <cmos_read>
8010337a:	8b 55 08             	mov    0x8(%ebp),%edx
8010337d:	89 42 14             	mov    %eax,0x14(%edx)
}
80103380:	c9                   	leave  
80103381:	c3                   	ret    

80103382 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103382:	55                   	push   %ebp
80103383:	89 e5                	mov    %esp,%ebp
80103385:	57                   	push   %edi
80103386:	56                   	push   %esi
80103387:	53                   	push   %ebx
80103388:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010338b:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103392:	e8 3f ff ff ff       	call   801032d6 <cmos_read>
80103397:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010339d:	83 e0 04             	and    $0x4,%eax
801033a0:	85 c0                	test   %eax,%eax
801033a2:	0f 94 c0             	sete   %al
801033a5:	0f b6 c0             	movzbl %al,%eax
801033a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801033ab:	8d 45 c8             	lea    -0x38(%ebp),%eax
801033ae:	89 04 24             	mov    %eax,(%esp)
801033b1:	e8 59 ff ff ff       	call   8010330f <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801033b6:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801033bd:	e8 14 ff ff ff       	call   801032d6 <cmos_read>
801033c2:	25 80 00 00 00       	and    $0x80,%eax
801033c7:	85 c0                	test   %eax,%eax
801033c9:	74 02                	je     801033cd <cmostime+0x4b>
        continue;
801033cb:	eb 36                	jmp    80103403 <cmostime+0x81>
    fill_rtcdate(&t2);
801033cd:	8d 45 b0             	lea    -0x50(%ebp),%eax
801033d0:	89 04 24             	mov    %eax,(%esp)
801033d3:	e8 37 ff ff ff       	call   8010330f <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033d8:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801033df:	00 
801033e0:	8d 45 b0             	lea    -0x50(%ebp),%eax
801033e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801033e7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801033ea:	89 04 24             	mov    %eax,(%esp)
801033ed:	e8 cb 1e 00 00       	call   801052bd <memcmp>
801033f2:	85 c0                	test   %eax,%eax
801033f4:	75 0d                	jne    80103403 <cmostime+0x81>
      break;
801033f6:	90                   	nop
  }

  // convert
  if(bcd) {
801033f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801033fb:	0f 84 ac 00 00 00    	je     801034ad <cmostime+0x12b>
80103401:	eb 02                	jmp    80103405 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103403:	eb a6                	jmp    801033ab <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103405:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103408:	c1 e8 04             	shr    $0x4,%eax
8010340b:	89 c2                	mov    %eax,%edx
8010340d:	89 d0                	mov    %edx,%eax
8010340f:	c1 e0 02             	shl    $0x2,%eax
80103412:	01 d0                	add    %edx,%eax
80103414:	01 c0                	add    %eax,%eax
80103416:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103419:	83 e2 0f             	and    $0xf,%edx
8010341c:	01 d0                	add    %edx,%eax
8010341e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103421:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103424:	c1 e8 04             	shr    $0x4,%eax
80103427:	89 c2                	mov    %eax,%edx
80103429:	89 d0                	mov    %edx,%eax
8010342b:	c1 e0 02             	shl    $0x2,%eax
8010342e:	01 d0                	add    %edx,%eax
80103430:	01 c0                	add    %eax,%eax
80103432:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103435:	83 e2 0f             	and    $0xf,%edx
80103438:	01 d0                	add    %edx,%eax
8010343a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
8010343d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103440:	c1 e8 04             	shr    $0x4,%eax
80103443:	89 c2                	mov    %eax,%edx
80103445:	89 d0                	mov    %edx,%eax
80103447:	c1 e0 02             	shl    $0x2,%eax
8010344a:	01 d0                	add    %edx,%eax
8010344c:	01 c0                	add    %eax,%eax
8010344e:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103451:	83 e2 0f             	and    $0xf,%edx
80103454:	01 d0                	add    %edx,%eax
80103456:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010345c:	c1 e8 04             	shr    $0x4,%eax
8010345f:	89 c2                	mov    %eax,%edx
80103461:	89 d0                	mov    %edx,%eax
80103463:	c1 e0 02             	shl    $0x2,%eax
80103466:	01 d0                	add    %edx,%eax
80103468:	01 c0                	add    %eax,%eax
8010346a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010346d:	83 e2 0f             	and    $0xf,%edx
80103470:	01 d0                	add    %edx,%eax
80103472:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103475:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103478:	c1 e8 04             	shr    $0x4,%eax
8010347b:	89 c2                	mov    %eax,%edx
8010347d:	89 d0                	mov    %edx,%eax
8010347f:	c1 e0 02             	shl    $0x2,%eax
80103482:	01 d0                	add    %edx,%eax
80103484:	01 c0                	add    %eax,%eax
80103486:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103489:	83 e2 0f             	and    $0xf,%edx
8010348c:	01 d0                	add    %edx,%eax
8010348e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
80103491:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103494:	c1 e8 04             	shr    $0x4,%eax
80103497:	89 c2                	mov    %eax,%edx
80103499:	89 d0                	mov    %edx,%eax
8010349b:	c1 e0 02             	shl    $0x2,%eax
8010349e:	01 d0                	add    %edx,%eax
801034a0:	01 c0                	add    %eax,%eax
801034a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801034a5:	83 e2 0f             	and    $0xf,%edx
801034a8:	01 d0                	add    %edx,%eax
801034aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
801034ad:	8b 45 08             	mov    0x8(%ebp),%eax
801034b0:	89 c2                	mov    %eax,%edx
801034b2:	8d 5d c8             	lea    -0x38(%ebp),%ebx
801034b5:	b8 06 00 00 00       	mov    $0x6,%eax
801034ba:	89 d7                	mov    %edx,%edi
801034bc:	89 de                	mov    %ebx,%esi
801034be:	89 c1                	mov    %eax,%ecx
801034c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801034c2:	8b 45 08             	mov    0x8(%ebp),%eax
801034c5:	8b 40 14             	mov    0x14(%eax),%eax
801034c8:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801034ce:	8b 45 08             	mov    0x8(%ebp),%eax
801034d1:	89 50 14             	mov    %edx,0x14(%eax)
}
801034d4:	83 c4 5c             	add    $0x5c,%esp
801034d7:	5b                   	pop    %ebx
801034d8:	5e                   	pop    %esi
801034d9:	5f                   	pop    %edi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    

801034dc <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801034dc:	55                   	push   %ebp
801034dd:	89 e5                	mov    %esp,%ebp
801034df:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034e2:	c7 44 24 04 6d 90 10 	movl   $0x8010906d,0x4(%esp)
801034e9:	80 
801034ea:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801034f1:	e8 cc 1a 00 00       	call   80104fc2 <initlock>
  readsb(dev, &sb);
801034f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801034fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103500:	89 04 24             	mov    %eax,(%esp)
80103503:	e8 d8 e0 ff ff       	call   801015e0 <readsb>
  log.start = sb.logstart;
80103508:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010350b:	a3 d4 4b 11 80       	mov    %eax,0x80114bd4
  log.size = sb.nlog;
80103510:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103513:	a3 d8 4b 11 80       	mov    %eax,0x80114bd8
  log.dev = dev;
80103518:	8b 45 08             	mov    0x8(%ebp),%eax
8010351b:	a3 e4 4b 11 80       	mov    %eax,0x80114be4
  recover_from_log();
80103520:	e8 95 01 00 00       	call   801036ba <recover_from_log>
}
80103525:	c9                   	leave  
80103526:	c3                   	ret    

80103527 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103527:	55                   	push   %ebp
80103528:	89 e5                	mov    %esp,%ebp
8010352a:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010352d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103534:	e9 89 00 00 00       	jmp    801035c2 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103539:	8b 15 d4 4b 11 80    	mov    0x80114bd4,%edx
8010353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103542:	01 d0                	add    %edx,%eax
80103544:	40                   	inc    %eax
80103545:	89 c2                	mov    %eax,%edx
80103547:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
8010354c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103550:	89 04 24             	mov    %eax,(%esp)
80103553:	e8 5d cc ff ff       	call   801001b5 <bread>
80103558:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010355e:	83 c0 10             	add    $0x10,%eax
80103561:	8b 04 85 ac 4b 11 80 	mov    -0x7feeb454(,%eax,4),%eax
80103568:	89 c2                	mov    %eax,%edx
8010356a:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
8010356f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103573:	89 04 24             	mov    %eax,(%esp)
80103576:	e8 3a cc ff ff       	call   801001b5 <bread>
8010357b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010357e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103581:	8d 50 5c             	lea    0x5c(%eax),%edx
80103584:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103587:	83 c0 5c             	add    $0x5c,%eax
8010358a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103591:	00 
80103592:	89 54 24 04          	mov    %edx,0x4(%esp)
80103596:	89 04 24             	mov    %eax,(%esp)
80103599:	e8 71 1d 00 00       	call   8010530f <memmove>
    bwrite(dbuf);  // write dst to disk
8010359e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a1:	89 04 24             	mov    %eax,(%esp)
801035a4:	e8 43 cc ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801035a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035ac:	89 04 24             	mov    %eax,(%esp)
801035af:	e8 78 cc ff ff       	call   8010022c <brelse>
    brelse(dbuf);
801035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035b7:	89 04 24             	mov    %eax,(%esp)
801035ba:	e8 6d cc ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035bf:	ff 45 f4             	incl   -0xc(%ebp)
801035c2:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
801035c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ca:	0f 8f 69 ff ff ff    	jg     80103539 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801035d0:	c9                   	leave  
801035d1:	c3                   	ret    

801035d2 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035d2:	55                   	push   %ebp
801035d3:	89 e5                	mov    %esp,%ebp
801035d5:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801035d8:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
801035dd:	89 c2                	mov    %eax,%edx
801035df:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
801035e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e8:	89 04 24             	mov    %eax,(%esp)
801035eb:	e8 c5 cb ff ff       	call   801001b5 <bread>
801035f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801035f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035f6:	83 c0 5c             	add    $0x5c,%eax
801035f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801035fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ff:	8b 00                	mov    (%eax),%eax
80103601:	a3 e8 4b 11 80       	mov    %eax,0x80114be8
  for (i = 0; i < log.lh.n; i++) {
80103606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010360d:	eb 1a                	jmp    80103629 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
8010360f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103612:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103615:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103619:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010361c:	83 c2 10             	add    $0x10,%edx
8010361f:	89 04 95 ac 4b 11 80 	mov    %eax,-0x7feeb454(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103626:	ff 45 f4             	incl   -0xc(%ebp)
80103629:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
8010362e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103631:	7f dc                	jg     8010360f <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103636:	89 04 24             	mov    %eax,(%esp)
80103639:	e8 ee cb ff ff       	call   8010022c <brelse>
}
8010363e:	c9                   	leave  
8010363f:	c3                   	ret    

80103640 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103646:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
8010364b:	89 c2                	mov    %eax,%edx
8010364d:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
80103652:	89 54 24 04          	mov    %edx,0x4(%esp)
80103656:	89 04 24             	mov    %eax,(%esp)
80103659:	e8 57 cb ff ff       	call   801001b5 <bread>
8010365e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103664:	83 c0 5c             	add    $0x5c,%eax
80103667:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010366a:	8b 15 e8 4b 11 80    	mov    0x80114be8,%edx
80103670:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103673:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103675:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010367c:	eb 1a                	jmp    80103698 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
8010367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103681:	83 c0 10             	add    $0x10,%eax
80103684:	8b 0c 85 ac 4b 11 80 	mov    -0x7feeb454(,%eax,4),%ecx
8010368b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010368e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103691:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103695:	ff 45 f4             	incl   -0xc(%ebp)
80103698:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
8010369d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036a0:	7f dc                	jg     8010367e <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801036a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036a5:	89 04 24             	mov    %eax,(%esp)
801036a8:	e8 3f cb ff ff       	call   801001ec <bwrite>
  brelse(buf);
801036ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b0:	89 04 24             	mov    %eax,(%esp)
801036b3:	e8 74 cb ff ff       	call   8010022c <brelse>
}
801036b8:	c9                   	leave  
801036b9:	c3                   	ret    

801036ba <recover_from_log>:

static void
recover_from_log(void)
{
801036ba:	55                   	push   %ebp
801036bb:	89 e5                	mov    %esp,%ebp
801036bd:	83 ec 08             	sub    $0x8,%esp
  read_head();
801036c0:	e8 0d ff ff ff       	call   801035d2 <read_head>
  install_trans(); // if committed, copy from log to disk
801036c5:	e8 5d fe ff ff       	call   80103527 <install_trans>
  log.lh.n = 0;
801036ca:	c7 05 e8 4b 11 80 00 	movl   $0x0,0x80114be8
801036d1:	00 00 00 
  write_head(); // clear the log
801036d4:	e8 67 ff ff ff       	call   80103640 <write_head>
}
801036d9:	c9                   	leave  
801036da:	c3                   	ret    

801036db <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801036db:	55                   	push   %ebp
801036dc:	89 e5                	mov    %esp,%ebp
801036de:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801036e1:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801036e8:	e8 f6 18 00 00       	call   80104fe3 <acquire>
  while(1){
    if(log.committing){
801036ed:	a1 e0 4b 11 80       	mov    0x80114be0,%eax
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 16                	je     8010370c <begin_op+0x31>
      sleep(&log, &log.lock);
801036f6:	c7 44 24 04 a0 4b 11 	movl   $0x80114ba0,0x4(%esp)
801036fd:	80 
801036fe:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103705:	e8 0a 15 00 00       	call   80104c14 <sleep>
8010370a:	eb 4d                	jmp    80103759 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010370c:	8b 15 e8 4b 11 80    	mov    0x80114be8,%edx
80103712:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
80103717:	8d 48 01             	lea    0x1(%eax),%ecx
8010371a:	89 c8                	mov    %ecx,%eax
8010371c:	c1 e0 02             	shl    $0x2,%eax
8010371f:	01 c8                	add    %ecx,%eax
80103721:	01 c0                	add    %eax,%eax
80103723:	01 d0                	add    %edx,%eax
80103725:	83 f8 1e             	cmp    $0x1e,%eax
80103728:	7e 16                	jle    80103740 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010372a:	c7 44 24 04 a0 4b 11 	movl   $0x80114ba0,0x4(%esp)
80103731:	80 
80103732:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103739:	e8 d6 14 00 00       	call   80104c14 <sleep>
8010373e:	eb 19                	jmp    80103759 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
80103740:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
80103745:	40                   	inc    %eax
80103746:	a3 dc 4b 11 80       	mov    %eax,0x80114bdc
      release(&log.lock);
8010374b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103752:	e8 f6 18 00 00       	call   8010504d <release>
      break;
80103757:	eb 02                	jmp    8010375b <begin_op+0x80>
    }
  }
80103759:	eb 92                	jmp    801036ed <begin_op+0x12>
}
8010375b:	c9                   	leave  
8010375c:	c3                   	ret    

8010375d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010375d:	55                   	push   %ebp
8010375e:	89 e5                	mov    %esp,%ebp
80103760:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010376a:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103771:	e8 6d 18 00 00       	call   80104fe3 <acquire>
  log.outstanding -= 1;
80103776:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
8010377b:	48                   	dec    %eax
8010377c:	a3 dc 4b 11 80       	mov    %eax,0x80114bdc
  if(log.committing)
80103781:	a1 e0 4b 11 80       	mov    0x80114be0,%eax
80103786:	85 c0                	test   %eax,%eax
80103788:	74 0c                	je     80103796 <end_op+0x39>
    panic("log.committing");
8010378a:	c7 04 24 71 90 10 80 	movl   $0x80109071,(%esp)
80103791:	e8 17 cf ff ff       	call   801006ad <panic>
  if(log.outstanding == 0){
80103796:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
8010379b:	85 c0                	test   %eax,%eax
8010379d:	75 13                	jne    801037b2 <end_op+0x55>
    do_commit = 1;
8010379f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037a6:	c7 05 e0 4b 11 80 01 	movl   $0x1,0x80114be0
801037ad:	00 00 00 
801037b0:	eb 0c                	jmp    801037be <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801037b2:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801037b9:	e8 2a 15 00 00       	call   80104ce8 <wakeup>
  }
  release(&log.lock);
801037be:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801037c5:	e8 83 18 00 00       	call   8010504d <release>

  if(do_commit){
801037ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037ce:	74 33                	je     80103803 <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801037d0:	e8 db 00 00 00       	call   801038b0 <commit>
    acquire(&log.lock);
801037d5:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801037dc:	e8 02 18 00 00       	call   80104fe3 <acquire>
    log.committing = 0;
801037e1:	c7 05 e0 4b 11 80 00 	movl   $0x0,0x80114be0
801037e8:	00 00 00 
    wakeup(&log);
801037eb:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801037f2:	e8 f1 14 00 00       	call   80104ce8 <wakeup>
    release(&log.lock);
801037f7:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801037fe:	e8 4a 18 00 00       	call   8010504d <release>
  }
}
80103803:	c9                   	leave  
80103804:	c3                   	ret    

80103805 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103805:	55                   	push   %ebp
80103806:	89 e5                	mov    %esp,%ebp
80103808:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010380b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103812:	e9 89 00 00 00       	jmp    801038a0 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103817:	8b 15 d4 4b 11 80    	mov    0x80114bd4,%edx
8010381d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103820:	01 d0                	add    %edx,%eax
80103822:	40                   	inc    %eax
80103823:	89 c2                	mov    %eax,%edx
80103825:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
8010382a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010382e:	89 04 24             	mov    %eax,(%esp)
80103831:	e8 7f c9 ff ff       	call   801001b5 <bread>
80103836:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383c:	83 c0 10             	add    $0x10,%eax
8010383f:	8b 04 85 ac 4b 11 80 	mov    -0x7feeb454(,%eax,4),%eax
80103846:	89 c2                	mov    %eax,%edx
80103848:	a1 e4 4b 11 80       	mov    0x80114be4,%eax
8010384d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103851:	89 04 24             	mov    %eax,(%esp)
80103854:	e8 5c c9 ff ff       	call   801001b5 <bread>
80103859:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010385f:	8d 50 5c             	lea    0x5c(%eax),%edx
80103862:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103865:	83 c0 5c             	add    $0x5c,%eax
80103868:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010386f:	00 
80103870:	89 54 24 04          	mov    %edx,0x4(%esp)
80103874:	89 04 24             	mov    %eax,(%esp)
80103877:	e8 93 1a 00 00       	call   8010530f <memmove>
    bwrite(to);  // write the log
8010387c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387f:	89 04 24             	mov    %eax,(%esp)
80103882:	e8 65 c9 ff ff       	call   801001ec <bwrite>
    brelse(from);
80103887:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010388a:	89 04 24             	mov    %eax,(%esp)
8010388d:	e8 9a c9 ff ff       	call   8010022c <brelse>
    brelse(to);
80103892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103895:	89 04 24             	mov    %eax,(%esp)
80103898:	e8 8f c9 ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010389d:	ff 45 f4             	incl   -0xc(%ebp)
801038a0:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
801038a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038a8:	0f 8f 69 ff ff ff    	jg     80103817 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
801038ae:	c9                   	leave  
801038af:	c3                   	ret    

801038b0 <commit>:

static void
commit()
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801038b6:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
801038bb:	85 c0                	test   %eax,%eax
801038bd:	7e 1e                	jle    801038dd <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801038bf:	e8 41 ff ff ff       	call   80103805 <write_log>
    write_head();    // Write header to disk -- the real commit
801038c4:	e8 77 fd ff ff       	call   80103640 <write_head>
    install_trans(); // Now install writes to home locations
801038c9:	e8 59 fc ff ff       	call   80103527 <install_trans>
    log.lh.n = 0;
801038ce:	c7 05 e8 4b 11 80 00 	movl   $0x0,0x80114be8
801038d5:	00 00 00 
    write_head();    // Erase the transaction from the log
801038d8:	e8 63 fd ff ff       	call   80103640 <write_head>
  }
}
801038dd:	c9                   	leave  
801038de:	c3                   	ret    

801038df <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038df:	55                   	push   %ebp
801038e0:	89 e5                	mov    %esp,%ebp
801038e2:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038e5:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
801038ea:	83 f8 1d             	cmp    $0x1d,%eax
801038ed:	7f 10                	jg     801038ff <log_write+0x20>
801038ef:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
801038f4:	8b 15 d8 4b 11 80    	mov    0x80114bd8,%edx
801038fa:	4a                   	dec    %edx
801038fb:	39 d0                	cmp    %edx,%eax
801038fd:	7c 0c                	jl     8010390b <log_write+0x2c>
    panic("too big a transaction");
801038ff:	c7 04 24 80 90 10 80 	movl   $0x80109080,(%esp)
80103906:	e8 a2 cd ff ff       	call   801006ad <panic>
  if (log.outstanding < 1)
8010390b:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
80103910:	85 c0                	test   %eax,%eax
80103912:	7f 0c                	jg     80103920 <log_write+0x41>
    panic("log_write outside of trans");
80103914:	c7 04 24 96 90 10 80 	movl   $0x80109096,(%esp)
8010391b:	e8 8d cd ff ff       	call   801006ad <panic>

  acquire(&log.lock);
80103920:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103927:	e8 b7 16 00 00       	call   80104fe3 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010392c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103933:	eb 1e                	jmp    80103953 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	83 c0 10             	add    $0x10,%eax
8010393b:	8b 04 85 ac 4b 11 80 	mov    -0x7feeb454(,%eax,4),%eax
80103942:	89 c2                	mov    %eax,%edx
80103944:	8b 45 08             	mov    0x8(%ebp),%eax
80103947:	8b 40 08             	mov    0x8(%eax),%eax
8010394a:	39 c2                	cmp    %eax,%edx
8010394c:	75 02                	jne    80103950 <log_write+0x71>
      break;
8010394e:	eb 0d                	jmp    8010395d <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103950:	ff 45 f4             	incl   -0xc(%ebp)
80103953:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
80103958:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010395b:	7f d8                	jg     80103935 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
8010395d:	8b 45 08             	mov    0x8(%ebp),%eax
80103960:	8b 40 08             	mov    0x8(%eax),%eax
80103963:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103966:	83 c2 10             	add    $0x10,%edx
80103969:	89 04 95 ac 4b 11 80 	mov    %eax,-0x7feeb454(,%edx,4)
  if (i == log.lh.n)
80103970:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
80103975:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103978:	75 0b                	jne    80103985 <log_write+0xa6>
    log.lh.n++;
8010397a:	a1 e8 4b 11 80       	mov    0x80114be8,%eax
8010397f:	40                   	inc    %eax
80103980:	a3 e8 4b 11 80       	mov    %eax,0x80114be8
  b->flags |= B_DIRTY; // prevent eviction
80103985:	8b 45 08             	mov    0x8(%ebp),%eax
80103988:	8b 00                	mov    (%eax),%eax
8010398a:	83 c8 04             	or     $0x4,%eax
8010398d:	89 c2                	mov    %eax,%edx
8010398f:	8b 45 08             	mov    0x8(%ebp),%eax
80103992:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103994:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
8010399b:	e8 ad 16 00 00       	call   8010504d <release>
}
801039a0:	c9                   	leave  
801039a1:	c3                   	ret    
	...

801039a4 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039aa:	8b 55 08             	mov    0x8(%ebp),%edx
801039ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801039b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039b3:	f0 87 02             	lock xchg %eax,(%edx)
801039b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801039b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801039bc:	c9                   	leave  
801039bd:	c3                   	ret    

801039be <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801039be:	55                   	push   %ebp
801039bf:	89 e5                	mov    %esp,%ebp
801039c1:	83 e4 f0             	and    $0xfffffff0,%esp
801039c4:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801039c7:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801039ce:	80 
801039cf:	c7 04 24 c8 79 11 80 	movl   $0x801179c8,(%esp)
801039d6:	e8 0d f3 ff ff       	call   80102ce8 <kinit1>
  kvmalloc();      // kernel page table
801039db:	e8 23 48 00 00       	call   80108203 <kvmalloc>
  mpinit();        // detect other processors
801039e0:	e8 c4 03 00 00       	call   80103da9 <mpinit>
  lapicinit();     // interrupt controller
801039e5:	e8 4e f6 ff ff       	call   80103038 <lapicinit>
  seginit();       // segment descriptors
801039ea:	e8 fc 42 00 00       	call   80107ceb <seginit>
  picinit();       // disable pic
801039ef:	e8 04 05 00 00       	call   80103ef8 <picinit>
  ioapicinit();    // another interrupt controller
801039f4:	e8 0c f2 ff ff       	call   80102c05 <ioapicinit>
  consoleinit();   // console hardware
801039f9:	e8 77 d3 ff ff       	call   80100d75 <consoleinit>
  uartinit();      // serial port
801039fe:	e8 74 36 00 00       	call   80107077 <uartinit>
  pinit();         // process table
80103a03:	e8 e6 08 00 00       	call   801042ee <pinit>
  tvinit();        // trap vectors
80103a08:	e8 53 32 00 00       	call   80106c60 <tvinit>
  binit();         // buffer cache
80103a0d:	e8 22 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a12:	e8 ed d7 ff ff       	call   80101204 <fileinit>
  ideinit();       // disk 
80103a17:	e8 f5 ed ff ff       	call   80102811 <ideinit>
  startothers();   // start other processors
80103a1c:	e8 83 00 00 00       	call   80103aa4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a21:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103a28:	8e 
80103a29:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103a30:	e8 eb f2 ff ff       	call   80102d20 <kinit2>
  userinit();      // first user process
80103a35:	e8 c1 0a 00 00       	call   801044fb <userinit>
  mpmain();        // finish this processor's setup
80103a3a:	e8 1a 00 00 00       	call   80103a59 <mpmain>

80103a3f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103a3f:	55                   	push   %ebp
80103a40:	89 e5                	mov    %esp,%ebp
80103a42:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103a45:	e8 d0 47 00 00       	call   8010821a <switchkvm>
  seginit();
80103a4a:	e8 9c 42 00 00       	call   80107ceb <seginit>
  lapicinit();
80103a4f:	e8 e4 f5 ff ff       	call   80103038 <lapicinit>
  mpmain();
80103a54:	e8 00 00 00 00       	call   80103a59 <mpmain>

80103a59 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	53                   	push   %ebx
80103a5d:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103a60:	e8 a5 08 00 00       	call   8010430a <cpuid>
80103a65:	89 c3                	mov    %eax,%ebx
80103a67:	e8 9e 08 00 00       	call   8010430a <cpuid>
80103a6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a74:	c7 04 24 b1 90 10 80 	movl   $0x801090b1,(%esp)
80103a7b:	e8 9a ca ff ff       	call   8010051a <cprintf>
  idtinit();       // load idt register
80103a80:	e8 38 33 00 00       	call   80106dbd <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103a85:	e8 c5 08 00 00       	call   8010434f <mycpu>
80103a8a:	05 a0 00 00 00       	add    $0xa0,%eax
80103a8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103a96:	00 
80103a97:	89 04 24             	mov    %eax,(%esp)
80103a9a:	e8 05 ff ff ff       	call   801039a4 <xchg>
  scheduler();     // start running processes
80103a9f:	e8 a6 0f 00 00       	call   80104a4a <scheduler>

80103aa4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103aaa:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103ab1:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
80103aba:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103ac1:	80 
80103ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac5:	89 04 24             	mov    %eax,(%esp)
80103ac8:	e8 42 18 00 00       	call   8010530f <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103acd:	c7 45 f4 a0 4c 11 80 	movl   $0x80114ca0,-0xc(%ebp)
80103ad4:	eb 75                	jmp    80103b4b <startothers+0xa7>
    if(c == mycpu())  // We've started already.
80103ad6:	e8 74 08 00 00       	call   8010434f <mycpu>
80103adb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ade:	75 02                	jne    80103ae2 <startothers+0x3e>
      continue;
80103ae0:	eb 62                	jmp    80103b44 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ae2:	e8 2c f3 ff ff       	call   80102e13 <kalloc>
80103ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aed:	83 e8 04             	sub    $0x4,%eax
80103af0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103af3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103af9:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103afe:	83 e8 08             	sub    $0x8,%eax
80103b01:	c7 00 3f 3a 10 80    	movl   $0x80103a3f,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b0a:	8d 50 f4             	lea    -0xc(%eax),%edx
80103b0d:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103b12:	05 00 00 00 80       	add    $0x80000000,%eax
80103b17:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b1c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b25:	8a 00                	mov    (%eax),%al
80103b27:	0f b6 c0             	movzbl %al,%eax
80103b2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80103b2e:	89 04 24             	mov    %eax,(%esp)
80103b31:	e8 a7 f6 ff ff       	call   801031dd <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b36:	90                   	nop
80103b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3a:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103b40:	85 c0                	test   %eax,%eax
80103b42:	74 f3                	je     80103b37 <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b44:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103b4b:	a1 20 52 11 80       	mov    0x80115220,%eax
80103b50:	89 c2                	mov    %eax,%edx
80103b52:	89 d0                	mov    %edx,%eax
80103b54:	c1 e0 02             	shl    $0x2,%eax
80103b57:	01 d0                	add    %edx,%eax
80103b59:	01 c0                	add    %eax,%eax
80103b5b:	01 d0                	add    %edx,%eax
80103b5d:	c1 e0 04             	shl    $0x4,%eax
80103b60:	05 a0 4c 11 80       	add    $0x80114ca0,%eax
80103b65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b68:	0f 87 68 ff ff ff    	ja     80103ad6 <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b6e:	c9                   	leave  
80103b6f:	c3                   	ret    

80103b70 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 14             	sub    $0x14,%esp
80103b76:	8b 45 08             	mov    0x8(%ebp),%eax
80103b79:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b80:	89 c2                	mov    %eax,%edx
80103b82:	ec                   	in     (%dx),%al
80103b83:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b86:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103b89:	c9                   	leave  
80103b8a:	c3                   	ret    

80103b8b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b8b:	55                   	push   %ebp
80103b8c:	89 e5                	mov    %esp,%ebp
80103b8e:	83 ec 08             	sub    $0x8,%esp
80103b91:	8b 45 08             	mov    0x8(%ebp),%eax
80103b94:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b97:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103b9b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b9e:	8a 45 f8             	mov    -0x8(%ebp),%al
80103ba1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ba4:	ee                   	out    %al,(%dx)
}
80103ba5:	c9                   	leave  
80103ba6:	c3                   	ret    

80103ba7 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103ba7:	55                   	push   %ebp
80103ba8:	89 e5                	mov    %esp,%ebp
80103baa:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103bad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bbb:	eb 13                	jmp    80103bd0 <sum+0x29>
    sum += addr[i];
80103bbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc3:	01 d0                	add    %edx,%eax
80103bc5:	8a 00                	mov    (%eax),%al
80103bc7:	0f b6 c0             	movzbl %al,%eax
80103bca:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103bcd:	ff 45 fc             	incl   -0x4(%ebp)
80103bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bd3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bd6:	7c e5                	jl     80103bbd <sum+0x16>
    sum += addr[i];
  return sum;
80103bd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bdb:	c9                   	leave  
80103bdc:	c3                   	ret    

80103bdd <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bdd:	55                   	push   %ebp
80103bde:	89 e5                	mov    %esp,%ebp
80103be0:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103be3:	8b 45 08             	mov    0x8(%ebp),%eax
80103be6:	05 00 00 00 80       	add    $0x80000000,%eax
80103beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103bee:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf4:	01 d0                	add    %edx,%eax
80103bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bff:	eb 3f                	jmp    80103c40 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c01:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c08:	00 
80103c09:	c7 44 24 04 c8 90 10 	movl   $0x801090c8,0x4(%esp)
80103c10:	80 
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	89 04 24             	mov    %eax,(%esp)
80103c17:	e8 a1 16 00 00       	call   801052bd <memcmp>
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	75 1c                	jne    80103c3c <mpsearch1+0x5f>
80103c20:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103c27:	00 
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	89 04 24             	mov    %eax,(%esp)
80103c2e:	e8 74 ff ff ff       	call   80103ba7 <sum>
80103c33:	84 c0                	test   %al,%al
80103c35:	75 05                	jne    80103c3c <mpsearch1+0x5f>
      return (struct mp*)p;
80103c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3a:	eb 11                	jmp    80103c4d <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c3c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c46:	72 b9                	jb     80103c01 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c4d:	c9                   	leave  
80103c4e:	c3                   	ret    

80103c4f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c4f:	55                   	push   %ebp
80103c50:	89 e5                	mov    %esp,%ebp
80103c52:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c55:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5f:	83 c0 0f             	add    $0xf,%eax
80103c62:	8a 00                	mov    (%eax),%al
80103c64:	0f b6 c0             	movzbl %al,%eax
80103c67:	c1 e0 08             	shl    $0x8,%eax
80103c6a:	89 c2                	mov    %eax,%edx
80103c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6f:	83 c0 0e             	add    $0xe,%eax
80103c72:	8a 00                	mov    (%eax),%al
80103c74:	0f b6 c0             	movzbl %al,%eax
80103c77:	09 d0                	or     %edx,%eax
80103c79:	c1 e0 04             	shl    $0x4,%eax
80103c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c83:	74 21                	je     80103ca6 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103c85:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103c8c:	00 
80103c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c90:	89 04 24             	mov    %eax,(%esp)
80103c93:	e8 45 ff ff ff       	call   80103bdd <mpsearch1>
80103c98:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c9f:	74 4e                	je     80103cef <mpsearch+0xa0>
      return mp;
80103ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ca4:	eb 5d                	jmp    80103d03 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	83 c0 14             	add    $0x14,%eax
80103cac:	8a 00                	mov    (%eax),%al
80103cae:	0f b6 c0             	movzbl %al,%eax
80103cb1:	c1 e0 08             	shl    $0x8,%eax
80103cb4:	89 c2                	mov    %eax,%edx
80103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb9:	83 c0 13             	add    $0x13,%eax
80103cbc:	8a 00                	mov    (%eax),%al
80103cbe:	0f b6 c0             	movzbl %al,%eax
80103cc1:	09 d0                	or     %edx,%eax
80103cc3:	c1 e0 0a             	shl    $0xa,%eax
80103cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ccc:	2d 00 04 00 00       	sub    $0x400,%eax
80103cd1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103cd8:	00 
80103cd9:	89 04 24             	mov    %eax,(%esp)
80103cdc:	e8 fc fe ff ff       	call   80103bdd <mpsearch1>
80103ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ce4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ce8:	74 05                	je     80103cef <mpsearch+0xa0>
      return mp;
80103cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ced:	eb 14                	jmp    80103d03 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cef:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103cf6:	00 
80103cf7:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103cfe:	e8 da fe ff ff       	call   80103bdd <mpsearch1>
}
80103d03:	c9                   	leave  
80103d04:	c3                   	ret    

80103d05 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d05:	55                   	push   %ebp
80103d06:	89 e5                	mov    %esp,%ebp
80103d08:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d0b:	e8 3f ff ff ff       	call   80103c4f <mpsearch>
80103d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d17:	74 0a                	je     80103d23 <mpconfig+0x1e>
80103d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1c:	8b 40 04             	mov    0x4(%eax),%eax
80103d1f:	85 c0                	test   %eax,%eax
80103d21:	75 07                	jne    80103d2a <mpconfig+0x25>
    return 0;
80103d23:	b8 00 00 00 00       	mov    $0x0,%eax
80103d28:	eb 7d                	jmp    80103da7 <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2d:	8b 40 04             	mov    0x4(%eax),%eax
80103d30:	05 00 00 00 80       	add    $0x80000000,%eax
80103d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103d3f:	00 
80103d40:	c7 44 24 04 cd 90 10 	movl   $0x801090cd,0x4(%esp)
80103d47:	80 
80103d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4b:	89 04 24             	mov    %eax,(%esp)
80103d4e:	e8 6a 15 00 00       	call   801052bd <memcmp>
80103d53:	85 c0                	test   %eax,%eax
80103d55:	74 07                	je     80103d5e <mpconfig+0x59>
    return 0;
80103d57:	b8 00 00 00 00       	mov    $0x0,%eax
80103d5c:	eb 49                	jmp    80103da7 <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d61:	8a 40 06             	mov    0x6(%eax),%al
80103d64:	3c 01                	cmp    $0x1,%al
80103d66:	74 11                	je     80103d79 <mpconfig+0x74>
80103d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6b:	8a 40 06             	mov    0x6(%eax),%al
80103d6e:	3c 04                	cmp    $0x4,%al
80103d70:	74 07                	je     80103d79 <mpconfig+0x74>
    return 0;
80103d72:	b8 00 00 00 00       	mov    $0x0,%eax
80103d77:	eb 2e                	jmp    80103da7 <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7c:	8b 40 04             	mov    0x4(%eax),%eax
80103d7f:	0f b7 c0             	movzwl %ax,%eax
80103d82:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d89:	89 04 24             	mov    %eax,(%esp)
80103d8c:	e8 16 fe ff ff       	call   80103ba7 <sum>
80103d91:	84 c0                	test   %al,%al
80103d93:	74 07                	je     80103d9c <mpconfig+0x97>
    return 0;
80103d95:	b8 00 00 00 00       	mov    $0x0,%eax
80103d9a:	eb 0b                	jmp    80103da7 <mpconfig+0xa2>
  *pmp = mp;
80103d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da2:	89 10                	mov    %edx,(%eax)
  return conf;
80103da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103da7:	c9                   	leave  
80103da8:	c3                   	ret    

80103da9 <mpinit>:

void
mpinit(void)
{
80103da9:	55                   	push   %ebp
80103daa:	89 e5                	mov    %esp,%ebp
80103dac:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103daf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103db2:	89 04 24             	mov    %eax,(%esp)
80103db5:	e8 4b ff ff ff       	call   80103d05 <mpconfig>
80103dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103dc1:	75 0c                	jne    80103dcf <mpinit+0x26>
    panic("Expect to run on an SMP");
80103dc3:	c7 04 24 d2 90 10 80 	movl   $0x801090d2,(%esp)
80103dca:	e8 de c8 ff ff       	call   801006ad <panic>
  ismp = 1;
80103dcf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dd9:	8b 40 24             	mov    0x24(%eax),%eax
80103ddc:	a3 9c 4b 11 80       	mov    %eax,0x80114b9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103de4:	83 c0 2c             	add    $0x2c,%eax
80103de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ded:	8b 40 04             	mov    0x4(%eax),%eax
80103df0:	0f b7 d0             	movzwl %ax,%edx
80103df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103df6:	01 d0                	add    %edx,%eax
80103df8:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103dfb:	eb 7d                	jmp    80103e7a <mpinit+0xd1>
    switch(*p){
80103dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e00:	8a 00                	mov    (%eax),%al
80103e02:	0f b6 c0             	movzbl %al,%eax
80103e05:	83 f8 04             	cmp    $0x4,%eax
80103e08:	77 68                	ja     80103e72 <mpinit+0xc9>
80103e0a:	8b 04 85 0c 91 10 80 	mov    -0x7fef6ef4(,%eax,4),%eax
80103e11:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103e19:	a1 20 52 11 80       	mov    0x80115220,%eax
80103e1e:	83 f8 07             	cmp    $0x7,%eax
80103e21:	7f 2c                	jg     80103e4f <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103e23:	8b 15 20 52 11 80    	mov    0x80115220,%edx
80103e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e2c:	8a 48 01             	mov    0x1(%eax),%cl
80103e2f:	89 d0                	mov    %edx,%eax
80103e31:	c1 e0 02             	shl    $0x2,%eax
80103e34:	01 d0                	add    %edx,%eax
80103e36:	01 c0                	add    %eax,%eax
80103e38:	01 d0                	add    %edx,%eax
80103e3a:	c1 e0 04             	shl    $0x4,%eax
80103e3d:	05 a0 4c 11 80       	add    $0x80114ca0,%eax
80103e42:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103e44:	a1 20 52 11 80       	mov    0x80115220,%eax
80103e49:	40                   	inc    %eax
80103e4a:	a3 20 52 11 80       	mov    %eax,0x80115220
      }
      p += sizeof(struct mpproc);
80103e4f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e53:	eb 25                	jmp    80103e7a <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e58:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e5e:	8a 40 01             	mov    0x1(%eax),%al
80103e61:	a2 80 4c 11 80       	mov    %al,0x80114c80
      p += sizeof(struct mpioapic);
80103e66:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e6a:	eb 0e                	jmp    80103e7a <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e6c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e70:	eb 08                	jmp    80103e7a <mpinit+0xd1>
    default:
      ismp = 0;
80103e72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103e79:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e7d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103e80:	0f 82 77 ff ff ff    	jb     80103dfd <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103e86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e8a:	75 0c                	jne    80103e98 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103e8c:	c7 04 24 ec 90 10 80 	movl   $0x801090ec,(%esp)
80103e93:	e8 15 c8 ff ff       	call   801006ad <panic>

  if(mp->imcrp){
80103e98:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e9b:	8a 40 0c             	mov    0xc(%eax),%al
80103e9e:	84 c0                	test   %al,%al
80103ea0:	74 36                	je     80103ed8 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ea2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103ea9:	00 
80103eaa:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103eb1:	e8 d5 fc ff ff       	call   80103b8b <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103eb6:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ebd:	e8 ae fc ff ff       	call   80103b70 <inb>
80103ec2:	83 c8 01             	or     $0x1,%eax
80103ec5:	0f b6 c0             	movzbl %al,%eax
80103ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ecc:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ed3:	e8 b3 fc ff ff       	call   80103b8b <outb>
  }
}
80103ed8:	c9                   	leave  
80103ed9:	c3                   	ret    
	...

80103edc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103edc:	55                   	push   %ebp
80103edd:	89 e5                	mov    %esp,%ebp
80103edf:	83 ec 08             	sub    $0x8,%esp
80103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ee8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103eec:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eef:	8a 45 f8             	mov    -0x8(%ebp),%al
80103ef2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ef5:	ee                   	out    %al,(%dx)
}
80103ef6:	c9                   	leave  
80103ef7:	c3                   	ret    

80103ef8 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103ef8:	55                   	push   %ebp
80103ef9:	89 e5                	mov    %esp,%ebp
80103efb:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103efe:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103f05:	00 
80103f06:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f0d:	e8 ca ff ff ff       	call   80103edc <outb>
  outb(IO_PIC2+1, 0xFF);
80103f12:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103f19:	00 
80103f1a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f21:	e8 b6 ff ff ff       	call   80103edc <outb>
}
80103f26:	c9                   	leave  
80103f27:	c3                   	ret    

80103f28 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f28:	55                   	push   %ebp
80103f29:	89 e5                	mov    %esp,%ebp
80103f2b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f35:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f41:	8b 10                	mov    (%eax),%edx
80103f43:	8b 45 08             	mov    0x8(%ebp),%eax
80103f46:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f48:	e8 d3 d2 ff ff       	call   80101220 <filealloc>
80103f4d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f50:	89 02                	mov    %eax,(%edx)
80103f52:	8b 45 08             	mov    0x8(%ebp),%eax
80103f55:	8b 00                	mov    (%eax),%eax
80103f57:	85 c0                	test   %eax,%eax
80103f59:	0f 84 c8 00 00 00    	je     80104027 <pipealloc+0xff>
80103f5f:	e8 bc d2 ff ff       	call   80101220 <filealloc>
80103f64:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f67:	89 02                	mov    %eax,(%edx)
80103f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6c:	8b 00                	mov    (%eax),%eax
80103f6e:	85 c0                	test   %eax,%eax
80103f70:	0f 84 b1 00 00 00    	je     80104027 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f76:	e8 98 ee ff ff       	call   80102e13 <kalloc>
80103f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f82:	75 05                	jne    80103f89 <pipealloc+0x61>
    goto bad;
80103f84:	e9 9e 00 00 00       	jmp    80104027 <pipealloc+0xff>
  p->readopen = 1;
80103f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f93:	00 00 00 
  p->writeopen = 1;
80103f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f99:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fa0:	00 00 00 
  p->nwrite = 0;
80103fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa6:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fad:	00 00 00 
  p->nread = 0;
80103fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb3:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fba:	00 00 00 
  initlock(&p->lock, "pipe");
80103fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc0:	c7 44 24 04 20 91 10 	movl   $0x80109120,0x4(%esp)
80103fc7:	80 
80103fc8:	89 04 24             	mov    %eax,(%esp)
80103fcb:	e8 f2 0f 00 00       	call   80104fc2 <initlock>
  (*f0)->type = FD_PIPE;
80103fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd3:	8b 00                	mov    (%eax),%eax
80103fd5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	8b 00                	mov    (%eax),%eax
80103fe0:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe7:	8b 00                	mov    (%eax),%eax
80103fe9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103fed:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff0:	8b 00                	mov    (%eax),%eax
80103ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ff5:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffb:	8b 00                	mov    (%eax),%eax
80103ffd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104003:	8b 45 0c             	mov    0xc(%ebp),%eax
80104006:	8b 00                	mov    (%eax),%eax
80104008:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010400c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400f:	8b 00                	mov    (%eax),%eax
80104011:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104015:	8b 45 0c             	mov    0xc(%ebp),%eax
80104018:	8b 00                	mov    (%eax),%eax
8010401a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010401d:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104020:	b8 00 00 00 00       	mov    $0x0,%eax
80104025:	eb 42                	jmp    80104069 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104027:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010402b:	74 0b                	je     80104038 <pipealloc+0x110>
    kfree((char*)p);
8010402d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104030:	89 04 24             	mov    %eax,(%esp)
80104033:	e8 45 ed ff ff       	call   80102d7d <kfree>
  if(*f0)
80104038:	8b 45 08             	mov    0x8(%ebp),%eax
8010403b:	8b 00                	mov    (%eax),%eax
8010403d:	85 c0                	test   %eax,%eax
8010403f:	74 0d                	je     8010404e <pipealloc+0x126>
    fileclose(*f0);
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	8b 00                	mov    (%eax),%eax
80104046:	89 04 24             	mov    %eax,(%esp)
80104049:	e8 7a d2 ff ff       	call   801012c8 <fileclose>
  if(*f1)
8010404e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104051:	8b 00                	mov    (%eax),%eax
80104053:	85 c0                	test   %eax,%eax
80104055:	74 0d                	je     80104064 <pipealloc+0x13c>
    fileclose(*f1);
80104057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010405a:	8b 00                	mov    (%eax),%eax
8010405c:	89 04 24             	mov    %eax,(%esp)
8010405f:	e8 64 d2 ff ff       	call   801012c8 <fileclose>
  return -1;
80104064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104069:	c9                   	leave  
8010406a:	c3                   	ret    

8010406b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010406b:	55                   	push   %ebp
8010406c:	89 e5                	mov    %esp,%ebp
8010406e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104071:	8b 45 08             	mov    0x8(%ebp),%eax
80104074:	89 04 24             	mov    %eax,(%esp)
80104077:	e8 67 0f 00 00       	call   80104fe3 <acquire>
  if(writable){
8010407c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104080:	74 1f                	je     801040a1 <pipeclose+0x36>
    p->writeopen = 0;
80104082:	8b 45 08             	mov    0x8(%ebp),%eax
80104085:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010408c:	00 00 00 
    wakeup(&p->nread);
8010408f:	8b 45 08             	mov    0x8(%ebp),%eax
80104092:	05 34 02 00 00       	add    $0x234,%eax
80104097:	89 04 24             	mov    %eax,(%esp)
8010409a:	e8 49 0c 00 00       	call   80104ce8 <wakeup>
8010409f:	eb 1d                	jmp    801040be <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040a1:	8b 45 08             	mov    0x8(%ebp),%eax
801040a4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040ab:	00 00 00 
    wakeup(&p->nwrite);
801040ae:	8b 45 08             	mov    0x8(%ebp),%eax
801040b1:	05 38 02 00 00       	add    $0x238,%eax
801040b6:	89 04 24             	mov    %eax,(%esp)
801040b9:	e8 2a 0c 00 00       	call   80104ce8 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040be:	8b 45 08             	mov    0x8(%ebp),%eax
801040c1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040c7:	85 c0                	test   %eax,%eax
801040c9:	75 25                	jne    801040f0 <pipeclose+0x85>
801040cb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ce:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040d4:	85 c0                	test   %eax,%eax
801040d6:	75 18                	jne    801040f0 <pipeclose+0x85>
    release(&p->lock);
801040d8:	8b 45 08             	mov    0x8(%ebp),%eax
801040db:	89 04 24             	mov    %eax,(%esp)
801040de:	e8 6a 0f 00 00       	call   8010504d <release>
    kfree((char*)p);
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
801040e6:	89 04 24             	mov    %eax,(%esp)
801040e9:	e8 8f ec ff ff       	call   80102d7d <kfree>
801040ee:	eb 0b                	jmp    801040fb <pipeclose+0x90>
  } else
    release(&p->lock);
801040f0:	8b 45 08             	mov    0x8(%ebp),%eax
801040f3:	89 04 24             	mov    %eax,(%esp)
801040f6:	e8 52 0f 00 00       	call   8010504d <release>
}
801040fb:	c9                   	leave  
801040fc:	c3                   	ret    

801040fd <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801040fd:	55                   	push   %ebp
801040fe:	89 e5                	mov    %esp,%ebp
80104100:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104103:	8b 45 08             	mov    0x8(%ebp),%eax
80104106:	89 04 24             	mov    %eax,(%esp)
80104109:	e8 d5 0e 00 00       	call   80104fe3 <acquire>
  for(i = 0; i < n; i++){
8010410e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104115:	e9 a3 00 00 00       	jmp    801041bd <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010411a:	eb 56                	jmp    80104172 <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
8010411c:	8b 45 08             	mov    0x8(%ebp),%eax
8010411f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104125:	85 c0                	test   %eax,%eax
80104127:	74 0c                	je     80104135 <pipewrite+0x38>
80104129:	e8 a5 02 00 00       	call   801043d3 <myproc>
8010412e:	8b 40 24             	mov    0x24(%eax),%eax
80104131:	85 c0                	test   %eax,%eax
80104133:	74 15                	je     8010414a <pipewrite+0x4d>
        release(&p->lock);
80104135:	8b 45 08             	mov    0x8(%ebp),%eax
80104138:	89 04 24             	mov    %eax,(%esp)
8010413b:	e8 0d 0f 00 00       	call   8010504d <release>
        return -1;
80104140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104145:	e9 9d 00 00 00       	jmp    801041e7 <pipewrite+0xea>
      }
      wakeup(&p->nread);
8010414a:	8b 45 08             	mov    0x8(%ebp),%eax
8010414d:	05 34 02 00 00       	add    $0x234,%eax
80104152:	89 04 24             	mov    %eax,(%esp)
80104155:	e8 8e 0b 00 00       	call   80104ce8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010415a:	8b 45 08             	mov    0x8(%ebp),%eax
8010415d:	8b 55 08             	mov    0x8(%ebp),%edx
80104160:	81 c2 38 02 00 00    	add    $0x238,%edx
80104166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010416a:	89 14 24             	mov    %edx,(%esp)
8010416d:	e8 a2 0a 00 00       	call   80104c14 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104172:	8b 45 08             	mov    0x8(%ebp),%eax
80104175:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010417b:	8b 45 08             	mov    0x8(%ebp),%eax
8010417e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104184:	05 00 02 00 00       	add    $0x200,%eax
80104189:	39 c2                	cmp    %eax,%edx
8010418b:	74 8f                	je     8010411c <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010418d:	8b 45 08             	mov    0x8(%ebp),%eax
80104190:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104196:	8d 48 01             	lea    0x1(%eax),%ecx
80104199:	8b 55 08             	mov    0x8(%ebp),%edx
8010419c:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041a2:	25 ff 01 00 00       	and    $0x1ff,%eax
801041a7:	89 c1                	mov    %eax,%ecx
801041a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801041af:	01 d0                	add    %edx,%eax
801041b1:	8a 10                	mov    (%eax),%dl
801041b3:	8b 45 08             	mov    0x8(%ebp),%eax
801041b6:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041ba:	ff 45 f4             	incl   -0xc(%ebp)
801041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c0:	3b 45 10             	cmp    0x10(%ebp),%eax
801041c3:	0f 8c 51 ff ff ff    	jl     8010411a <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041c9:	8b 45 08             	mov    0x8(%ebp),%eax
801041cc:	05 34 02 00 00       	add    $0x234,%eax
801041d1:	89 04 24             	mov    %eax,(%esp)
801041d4:	e8 0f 0b 00 00       	call   80104ce8 <wakeup>
  release(&p->lock);
801041d9:	8b 45 08             	mov    0x8(%ebp),%eax
801041dc:	89 04 24             	mov    %eax,(%esp)
801041df:	e8 69 0e 00 00       	call   8010504d <release>
  return n;
801041e4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801041e7:	c9                   	leave  
801041e8:	c3                   	ret    

801041e9 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801041e9:	55                   	push   %ebp
801041ea:	89 e5                	mov    %esp,%ebp
801041ec:	53                   	push   %ebx
801041ed:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041f0:	8b 45 08             	mov    0x8(%ebp),%eax
801041f3:	89 04 24             	mov    %eax,(%esp)
801041f6:	e8 e8 0d 00 00       	call   80104fe3 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801041fb:	eb 39                	jmp    80104236 <piperead+0x4d>
    if(myproc()->killed){
801041fd:	e8 d1 01 00 00       	call   801043d3 <myproc>
80104202:	8b 40 24             	mov    0x24(%eax),%eax
80104205:	85 c0                	test   %eax,%eax
80104207:	74 15                	je     8010421e <piperead+0x35>
      release(&p->lock);
80104209:	8b 45 08             	mov    0x8(%ebp),%eax
8010420c:	89 04 24             	mov    %eax,(%esp)
8010420f:	e8 39 0e 00 00       	call   8010504d <release>
      return -1;
80104214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104219:	e9 b3 00 00 00       	jmp    801042d1 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010421e:	8b 45 08             	mov    0x8(%ebp),%eax
80104221:	8b 55 08             	mov    0x8(%ebp),%edx
80104224:	81 c2 34 02 00 00    	add    $0x234,%edx
8010422a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010422e:	89 14 24             	mov    %edx,(%esp)
80104231:	e8 de 09 00 00       	call   80104c14 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104236:	8b 45 08             	mov    0x8(%ebp),%eax
80104239:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010423f:	8b 45 08             	mov    0x8(%ebp),%eax
80104242:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104248:	39 c2                	cmp    %eax,%edx
8010424a:	75 0d                	jne    80104259 <piperead+0x70>
8010424c:	8b 45 08             	mov    0x8(%ebp),%eax
8010424f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104255:	85 c0                	test   %eax,%eax
80104257:	75 a4                	jne    801041fd <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104260:	eb 49                	jmp    801042ab <piperead+0xc2>
    if(p->nread == p->nwrite)
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010426b:	8b 45 08             	mov    0x8(%ebp),%eax
8010426e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104274:	39 c2                	cmp    %eax,%edx
80104276:	75 02                	jne    8010427a <piperead+0x91>
      break;
80104278:	eb 39                	jmp    801042b3 <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010427a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010427d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104280:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
80104286:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010428c:	8d 48 01             	lea    0x1(%eax),%ecx
8010428f:	8b 55 08             	mov    0x8(%ebp),%edx
80104292:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104298:	25 ff 01 00 00       	and    $0x1ff,%eax
8010429d:	89 c2                	mov    %eax,%edx
8010429f:	8b 45 08             	mov    0x8(%ebp),%eax
801042a2:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
801042a6:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042a8:	ff 45 f4             	incl   -0xc(%ebp)
801042ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801042b1:	7c af                	jl     80104262 <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042b3:	8b 45 08             	mov    0x8(%ebp),%eax
801042b6:	05 38 02 00 00       	add    $0x238,%eax
801042bb:	89 04 24             	mov    %eax,(%esp)
801042be:	e8 25 0a 00 00       	call   80104ce8 <wakeup>
  release(&p->lock);
801042c3:	8b 45 08             	mov    0x8(%ebp),%eax
801042c6:	89 04 24             	mov    %eax,(%esp)
801042c9:	e8 7f 0d 00 00       	call   8010504d <release>
  return i;
801042ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042d1:	83 c4 24             	add    $0x24,%esp
801042d4:	5b                   	pop    %ebx
801042d5:	5d                   	pop    %ebp
801042d6:	c3                   	ret    
	...

801042d8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801042d8:	55                   	push   %ebp
801042d9:	89 e5                	mov    %esp,%ebp
801042db:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042de:	9c                   	pushf  
801042df:	58                   	pop    %eax
801042e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801042e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801042e6:	c9                   	leave  
801042e7:	c3                   	ret    

801042e8 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801042e8:	55                   	push   %ebp
801042e9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801042eb:	fb                   	sti    
}
801042ec:	5d                   	pop    %ebp
801042ed:	c3                   	ret    

801042ee <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801042ee:	55                   	push   %ebp
801042ef:	89 e5                	mov    %esp,%ebp
801042f1:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801042f4:	c7 44 24 04 28 91 10 	movl   $0x80109128,0x4(%esp)
801042fb:	80 
801042fc:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104303:	e8 ba 0c 00 00       	call   80104fc2 <initlock>
}
80104308:	c9                   	leave  
80104309:	c3                   	ret    

8010430a <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010430a:	55                   	push   %ebp
8010430b:	89 e5                	mov    %esp,%ebp
8010430d:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104310:	e8 3a 00 00 00       	call   8010434f <mycpu>
80104315:	89 c2                	mov    %eax,%edx
80104317:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
8010431c:	29 c2                	sub    %eax,%edx
8010431e:	89 d0                	mov    %edx,%eax
80104320:	c1 f8 04             	sar    $0x4,%eax
80104323:	89 c1                	mov    %eax,%ecx
80104325:	89 ca                	mov    %ecx,%edx
80104327:	c1 e2 03             	shl    $0x3,%edx
8010432a:	01 ca                	add    %ecx,%edx
8010432c:	89 d0                	mov    %edx,%eax
8010432e:	c1 e0 05             	shl    $0x5,%eax
80104331:	29 d0                	sub    %edx,%eax
80104333:	c1 e0 02             	shl    $0x2,%eax
80104336:	01 c8                	add    %ecx,%eax
80104338:	c1 e0 03             	shl    $0x3,%eax
8010433b:	01 c8                	add    %ecx,%eax
8010433d:	89 c2                	mov    %eax,%edx
8010433f:	c1 e2 0f             	shl    $0xf,%edx
80104342:	29 c2                	sub    %eax,%edx
80104344:	c1 e2 02             	shl    $0x2,%edx
80104347:	01 ca                	add    %ecx,%edx
80104349:	89 d0                	mov    %edx,%eax
8010434b:	f7 d8                	neg    %eax
}
8010434d:	c9                   	leave  
8010434e:	c3                   	ret    

8010434f <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
8010434f:	55                   	push   %ebp
80104350:	89 e5                	mov    %esp,%ebp
80104352:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
80104355:	e8 7e ff ff ff       	call   801042d8 <readeflags>
8010435a:	25 00 02 00 00       	and    $0x200,%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	74 0c                	je     8010436f <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
80104363:	c7 04 24 30 91 10 80 	movl   $0x80109130,(%esp)
8010436a:	e8 3e c3 ff ff       	call   801006ad <panic>
  
  apicid = lapicid();
8010436f:	e8 1d ee ff ff       	call   80103191 <lapicid>
80104374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010437e:	eb 3b                	jmp    801043bb <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
80104380:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104383:	89 d0                	mov    %edx,%eax
80104385:	c1 e0 02             	shl    $0x2,%eax
80104388:	01 d0                	add    %edx,%eax
8010438a:	01 c0                	add    %eax,%eax
8010438c:	01 d0                	add    %edx,%eax
8010438e:	c1 e0 04             	shl    $0x4,%eax
80104391:	05 a0 4c 11 80       	add    $0x80114ca0,%eax
80104396:	8a 00                	mov    (%eax),%al
80104398:	0f b6 c0             	movzbl %al,%eax
8010439b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010439e:	75 18                	jne    801043b8 <mycpu+0x69>
      return &cpus[i];
801043a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a3:	89 d0                	mov    %edx,%eax
801043a5:	c1 e0 02             	shl    $0x2,%eax
801043a8:	01 d0                	add    %edx,%eax
801043aa:	01 c0                	add    %eax,%eax
801043ac:	01 d0                	add    %edx,%eax
801043ae:	c1 e0 04             	shl    $0x4,%eax
801043b1:	05 a0 4c 11 80       	add    $0x80114ca0,%eax
801043b6:	eb 19                	jmp    801043d1 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801043b8:	ff 45 f4             	incl   -0xc(%ebp)
801043bb:	a1 20 52 11 80       	mov    0x80115220,%eax
801043c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801043c3:	7c bb                	jl     80104380 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801043c5:	c7 04 24 56 91 10 80 	movl   $0x80109156,(%esp)
801043cc:	e8 dc c2 ff ff       	call   801006ad <panic>
}
801043d1:	c9                   	leave  
801043d2:	c3                   	ret    

801043d3 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801043d3:	55                   	push   %ebp
801043d4:	89 e5                	mov    %esp,%ebp
801043d6:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801043d9:	e8 64 0d 00 00       	call   80105142 <pushcli>
  c = mycpu();
801043de:	e8 6c ff ff ff       	call   8010434f <mycpu>
801043e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801043e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801043ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801043f2:	e8 95 0d 00 00       	call   8010518c <popcli>
  return p;
801043f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    

801043fc <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043fc:	55                   	push   %ebp
801043fd:	89 e5                	mov    %esp,%ebp
801043ff:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104402:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104409:	e8 d5 0b 00 00       	call   80104fe3 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010440e:	c7 45 f4 74 52 11 80 	movl   $0x80115274,-0xc(%ebp)
80104415:	eb 50                	jmp    80104467 <allocproc+0x6b>
    if(p->state == UNUSED)
80104417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441a:	8b 40 0c             	mov    0xc(%eax),%eax
8010441d:	85 c0                	test   %eax,%eax
8010441f:	75 42                	jne    80104463 <allocproc+0x67>
      goto found;
80104421:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104425:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010442c:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104431:	8d 50 01             	lea    0x1(%eax),%edx
80104434:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
8010443a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010443d:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104440:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104447:	e8 01 0c 00 00       	call   8010504d <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010444c:	e8 c2 e9 ff ff       	call   80102e13 <kalloc>
80104451:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104454:	89 42 08             	mov    %eax,0x8(%edx)
80104457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445a:	8b 40 08             	mov    0x8(%eax),%eax
8010445d:	85 c0                	test   %eax,%eax
8010445f:	75 33                	jne    80104494 <allocproc+0x98>
80104461:	eb 20                	jmp    80104483 <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104463:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104467:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
8010446e:	72 a7                	jb     80104417 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80104470:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104477:	e8 d1 0b 00 00       	call   8010504d <release>
  return 0;
8010447c:	b8 00 00 00 00       	mov    $0x0,%eax
80104481:	eb 76                	jmp    801044f9 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104486:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010448d:	b8 00 00 00 00       	mov    $0x0,%eax
80104492:	eb 65                	jmp    801044f9 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
80104494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104497:	8b 40 08             	mov    0x8(%eax),%eax
8010449a:	05 00 10 00 00       	add    $0x1000,%eax
8010449f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044a2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044ac:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044af:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044b3:	ba 1c 6c 10 80       	mov    $0x80106c1c,%edx
801044b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044bb:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044bd:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044c7:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cd:	8b 40 1c             	mov    0x1c(%eax),%eax
801044d0:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801044d7:	00 
801044d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044df:	00 
801044e0:	89 04 24             	mov    %eax,(%esp)
801044e3:	e8 5e 0d 00 00       	call   80105246 <memset>
  p->context->eip = (uint)forkret;
801044e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044eb:	8b 40 1c             	mov    0x1c(%eax),%eax
801044ee:	ba d5 4b 10 80       	mov    $0x80104bd5,%edx
801044f3:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044f9:	c9                   	leave  
801044fa:	c3                   	ret    

801044fb <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044fb:	55                   	push   %ebp
801044fc:	89 e5                	mov    %esp,%ebp
801044fe:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104501:	e8 f6 fe ff ff       	call   801043fc <allocproc>
80104506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450c:	a3 60 c6 10 80       	mov    %eax,0x8010c660
  if((p->pgdir = setupkvm()) == 0)
80104511:	e8 44 3c 00 00       	call   8010815a <setupkvm>
80104516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104519:	89 42 04             	mov    %eax,0x4(%edx)
8010451c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451f:	8b 40 04             	mov    0x4(%eax),%eax
80104522:	85 c0                	test   %eax,%eax
80104524:	75 0c                	jne    80104532 <userinit+0x37>
    panic("userinit: out of memory?");
80104526:	c7 04 24 66 91 10 80 	movl   $0x80109166,(%esp)
8010452d:	e8 7b c1 ff ff       	call   801006ad <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104532:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453a:	8b 40 04             	mov    0x4(%eax),%eax
8010453d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104541:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
80104548:	80 
80104549:	89 04 24             	mov    %eax,(%esp)
8010454c:	e8 6a 3e 00 00       	call   801083bb <inituvm>
  p->sz = PGSIZE;
80104551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104554:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455d:	8b 40 18             	mov    0x18(%eax),%eax
80104560:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104567:	00 
80104568:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010456f:	00 
80104570:	89 04 24             	mov    %eax,(%esp)
80104573:	e8 ce 0c 00 00       	call   80105246 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457b:	8b 40 18             	mov    0x18(%eax),%eax
8010457e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 40 18             	mov    0x18(%eax),%eax
8010458a:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	8b 50 18             	mov    0x18(%eax),%edx
80104596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104599:	8b 40 18             	mov    0x18(%eax),%eax
8010459c:	8b 40 2c             	mov    0x2c(%eax),%eax
8010459f:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 50 18             	mov    0x18(%eax),%edx
801045a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ac:	8b 40 18             	mov    0x18(%eax),%eax
801045af:	8b 40 2c             	mov    0x2c(%eax),%eax
801045b2:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	8b 40 18             	mov    0x18(%eax),%eax
801045bc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c6:	8b 40 18             	mov    0x18(%eax),%eax
801045c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d3:	8b 40 18             	mov    0x18(%eax),%eax
801045d6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e0:	83 c0 6c             	add    $0x6c,%eax
801045e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045ea:	00 
801045eb:	c7 44 24 04 7f 91 10 	movl   $0x8010917f,0x4(%esp)
801045f2:	80 
801045f3:	89 04 24             	mov    %eax,(%esp)
801045f6:	e8 57 0e 00 00       	call   80105452 <safestrcpy>
  p->cwd = namei("/");
801045fb:	c7 04 24 88 91 10 80 	movl   $0x80109188,(%esp)
80104602:	e8 00 e1 ff ff       	call   80102707 <namei>
80104607:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010460a:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010460d:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104614:	e8 ca 09 00 00       	call   80104fe3 <acquire>

  p->state = RUNNABLE;
80104619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104623:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
8010462a:	e8 1e 0a 00 00       	call   8010504d <release>
}
8010462f:	c9                   	leave  
80104630:	c3                   	ret    

80104631 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104631:	55                   	push   %ebp
80104632:	89 e5                	mov    %esp,%ebp
80104634:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
80104637:	e8 97 fd ff ff       	call   801043d3 <myproc>
8010463c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
8010463f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104642:	8b 00                	mov    (%eax),%eax
80104644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104647:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010464b:	7e 31                	jle    8010467e <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010464d:	8b 55 08             	mov    0x8(%ebp),%edx
80104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104653:	01 c2                	add    %eax,%edx
80104655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104658:	8b 40 04             	mov    0x4(%eax),%eax
8010465b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010465f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104662:	89 54 24 04          	mov    %edx,0x4(%esp)
80104666:	89 04 24             	mov    %eax,(%esp)
80104669:	e8 b8 3e 00 00       	call   80108526 <allocuvm>
8010466e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104675:	75 3e                	jne    801046b5 <growproc+0x84>
      return -1;
80104677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467c:	eb 4f                	jmp    801046cd <growproc+0x9c>
  } else if(n < 0){
8010467e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104682:	79 31                	jns    801046b5 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104684:	8b 55 08             	mov    0x8(%ebp),%edx
80104687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468a:	01 c2                	add    %eax,%edx
8010468c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010468f:	8b 40 04             	mov    0x4(%eax),%eax
80104692:	89 54 24 08          	mov    %edx,0x8(%esp)
80104696:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104699:	89 54 24 04          	mov    %edx,0x4(%esp)
8010469d:	89 04 24             	mov    %eax,(%esp)
801046a0:	e8 97 3f 00 00       	call   8010863c <deallocuvm>
801046a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046ac:	75 07                	jne    801046b5 <growproc+0x84>
      return -1;
801046ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b3:	eb 18                	jmp    801046cd <growproc+0x9c>
  }
  curproc->sz = sz;
801046b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046bb:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801046bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046c0:	89 04 24             	mov    %eax,(%esp)
801046c3:	e8 6c 3b 00 00       	call   80108234 <switchuvm>
  return 0;
801046c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046cd:	c9                   	leave  
801046ce:	c3                   	ret    

801046cf <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046cf:	55                   	push   %ebp
801046d0:	89 e5                	mov    %esp,%ebp
801046d2:	57                   	push   %edi
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801046d8:	e8 f6 fc ff ff       	call   801043d3 <myproc>
801046dd:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801046e0:	e8 17 fd ff ff       	call   801043fc <allocproc>
801046e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801046e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801046ec:	75 0a                	jne    801046f8 <fork+0x29>
    return -1;
801046ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f3:	e9 35 01 00 00       	jmp    8010482d <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801046f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fb:	8b 10                	mov    (%eax),%edx
801046fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104700:	8b 40 04             	mov    0x4(%eax),%eax
80104703:	89 54 24 04          	mov    %edx,0x4(%esp)
80104707:	89 04 24             	mov    %eax,(%esp)
8010470a:	e8 cd 40 00 00       	call   801087dc <copyuvm>
8010470f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104712:	89 42 04             	mov    %eax,0x4(%edx)
80104715:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104718:	8b 40 04             	mov    0x4(%eax),%eax
8010471b:	85 c0                	test   %eax,%eax
8010471d:	75 2c                	jne    8010474b <fork+0x7c>
    kfree(np->kstack);
8010471f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104722:	8b 40 08             	mov    0x8(%eax),%eax
80104725:	89 04 24             	mov    %eax,(%esp)
80104728:	e8 50 e6 ff ff       	call   80102d7d <kfree>
    np->kstack = 0;
8010472d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104730:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104737:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010473a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104746:	e9 e2 00 00 00       	jmp    8010482d <fork+0x15e>
  }
  np->sz = curproc->sz;
8010474b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474e:	8b 10                	mov    (%eax),%edx
80104750:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104753:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104755:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104758:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010475b:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
8010475e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104761:	8b 50 18             	mov    0x18(%eax),%edx
80104764:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104767:	8b 40 18             	mov    0x18(%eax),%eax
8010476a:	89 c3                	mov    %eax,%ebx
8010476c:	b8 13 00 00 00       	mov    $0x13,%eax
80104771:	89 d7                	mov    %edx,%edi
80104773:	89 de                	mov    %ebx,%esi
80104775:	89 c1                	mov    %eax,%ecx
80104777:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104779:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010477c:	8b 40 18             	mov    0x18(%eax),%eax
8010477f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104786:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010478d:	eb 36                	jmp    801047c5 <fork+0xf6>
    if(curproc->ofile[i])
8010478f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104792:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104795:	83 c2 08             	add    $0x8,%edx
80104798:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010479c:	85 c0                	test   %eax,%eax
8010479e:	74 22                	je     801047c2 <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801047a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047a6:	83 c2 08             	add    $0x8,%edx
801047a9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047ad:	89 04 24             	mov    %eax,(%esp)
801047b0:	e8 cb ca ff ff       	call   80101280 <filedup>
801047b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047bb:	83 c1 08             	add    $0x8,%ecx
801047be:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047c2:	ff 45 e4             	incl   -0x1c(%ebp)
801047c5:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047c9:	7e c4                	jle    8010478f <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801047cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ce:	8b 40 68             	mov    0x68(%eax),%eax
801047d1:	89 04 24             	mov    %eax,(%esp)
801047d4:	e8 d7 d3 ff ff       	call   80101bb0 <idup>
801047d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047dc:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801047df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e2:	8d 50 6c             	lea    0x6c(%eax),%edx
801047e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047e8:	83 c0 6c             	add    $0x6c,%eax
801047eb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801047f2:	00 
801047f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801047f7:	89 04 24             	mov    %eax,(%esp)
801047fa:	e8 53 0c 00 00       	call   80105452 <safestrcpy>

  pid = np->pid;
801047ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104802:	8b 40 10             	mov    0x10(%eax),%eax
80104805:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104808:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
8010480f:	e8 cf 07 00 00       	call   80104fe3 <acquire>

  np->state = RUNNABLE;
80104814:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104817:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010481e:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104825:	e8 23 08 00 00       	call   8010504d <release>

  return pid;
8010482a:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
8010482d:	83 c4 2c             	add    $0x2c,%esp
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5f                   	pop    %edi
80104833:	5d                   	pop    %ebp
80104834:	c3                   	ret    

80104835 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104835:	55                   	push   %ebp
80104836:	89 e5                	mov    %esp,%ebp
80104838:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
8010483b:	e8 93 fb ff ff       	call   801043d3 <myproc>
80104840:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104843:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80104848:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010484b:	75 0c                	jne    80104859 <exit+0x24>
    panic("init exiting");
8010484d:	c7 04 24 8a 91 10 80 	movl   $0x8010918a,(%esp)
80104854:	e8 54 be ff ff       	call   801006ad <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104859:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104860:	eb 3a                	jmp    8010489c <exit+0x67>
    if(curproc->ofile[fd]){
80104862:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104865:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104868:	83 c2 08             	add    $0x8,%edx
8010486b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010486f:	85 c0                	test   %eax,%eax
80104871:	74 26                	je     80104899 <exit+0x64>
      fileclose(curproc->ofile[fd]);
80104873:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104876:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104879:	83 c2 08             	add    $0x8,%edx
8010487c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104880:	89 04 24             	mov    %eax,(%esp)
80104883:	e8 40 ca ff ff       	call   801012c8 <fileclose>
      curproc->ofile[fd] = 0;
80104888:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010488e:	83 c2 08             	add    $0x8,%edx
80104891:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104898:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104899:	ff 45 f0             	incl   -0x10(%ebp)
8010489c:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048a0:	7e c0                	jle    80104862 <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801048a2:	e8 34 ee ff ff       	call   801036db <begin_op>
  iput(curproc->cwd);
801048a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048aa:	8b 40 68             	mov    0x68(%eax),%eax
801048ad:	89 04 24             	mov    %eax,(%esp)
801048b0:	e8 7b d4 ff ff       	call   80101d30 <iput>
  end_op();
801048b5:	e8 a3 ee ff ff       	call   8010375d <end_op>
  curproc->cwd = 0;
801048ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048bd:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048c4:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
801048cb:	e8 13 07 00 00       	call   80104fe3 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801048d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048d3:	8b 40 14             	mov    0x14(%eax),%eax
801048d6:	89 04 24             	mov    %eax,(%esp)
801048d9:	e8 cc 03 00 00       	call   80104caa <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048de:	c7 45 f4 74 52 11 80 	movl   $0x80115274,-0xc(%ebp)
801048e5:	eb 33                	jmp    8010491a <exit+0xe5>
    if(p->parent == curproc){
801048e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ea:	8b 40 14             	mov    0x14(%eax),%eax
801048ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801048f0:	75 24                	jne    80104916 <exit+0xe1>
      p->parent = initproc;
801048f2:	8b 15 60 c6 10 80    	mov    0x8010c660,%edx
801048f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fb:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104901:	8b 40 0c             	mov    0xc(%eax),%eax
80104904:	83 f8 05             	cmp    $0x5,%eax
80104907:	75 0d                	jne    80104916 <exit+0xe1>
        wakeup1(initproc);
80104909:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 94 03 00 00       	call   80104caa <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104916:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010491a:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104921:	72 c4                	jb     801048e7 <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104923:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104926:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010492d:	e8 c3 01 00 00       	call   80104af5 <sched>
  panic("zombie exit");
80104932:	c7 04 24 97 91 10 80 	movl   $0x80109197,(%esp)
80104939:	e8 6f bd ff ff       	call   801006ad <panic>

8010493e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010493e:	55                   	push   %ebp
8010493f:	89 e5                	mov    %esp,%ebp
80104941:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104944:	e8 8a fa ff ff       	call   801043d3 <myproc>
80104949:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010494c:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104953:	e8 8b 06 00 00       	call   80104fe3 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104958:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010495f:	c7 45 f4 74 52 11 80 	movl   $0x80115274,-0xc(%ebp)
80104966:	e9 95 00 00 00       	jmp    80104a00 <wait+0xc2>
      if(p->parent != curproc)
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496e:	8b 40 14             	mov    0x14(%eax),%eax
80104971:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104974:	74 05                	je     8010497b <wait+0x3d>
        continue;
80104976:	e9 81 00 00 00       	jmp    801049fc <wait+0xbe>
      havekids = 1;
8010497b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104985:	8b 40 0c             	mov    0xc(%eax),%eax
80104988:	83 f8 05             	cmp    $0x5,%eax
8010498b:	75 6f                	jne    801049fc <wait+0xbe>
        // Found one.
        pid = p->pid;
8010498d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104990:	8b 40 10             	mov    0x10(%eax),%eax
80104993:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104999:	8b 40 08             	mov    0x8(%eax),%eax
8010499c:	89 04 24             	mov    %eax,(%esp)
8010499f:	e8 d9 e3 ff ff       	call   80102d7d <kfree>
        p->kstack = 0;
801049a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b1:	8b 40 04             	mov    0x4(%eax),%eax
801049b4:	89 04 24             	mov    %eax,(%esp)
801049b7:	e8 44 3d 00 00       	call   80108700 <freevm>
        p->pid = 0;
801049bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801049c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049da:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801049e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801049eb:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
801049f2:	e8 56 06 00 00       	call   8010504d <release>
        return pid;
801049f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049fa:	eb 4c                	jmp    80104a48 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049fc:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a00:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104a07:	0f 82 5e ff ff ff    	jb     8010496b <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a11:	74 0a                	je     80104a1d <wait+0xdf>
80104a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a16:	8b 40 24             	mov    0x24(%eax),%eax
80104a19:	85 c0                	test   %eax,%eax
80104a1b:	74 13                	je     80104a30 <wait+0xf2>
      release(&ptable.lock);
80104a1d:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104a24:	e8 24 06 00 00       	call   8010504d <release>
      return -1;
80104a29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a2e:	eb 18                	jmp    80104a48 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a30:	c7 44 24 04 40 52 11 	movl   $0x80115240,0x4(%esp)
80104a37:	80 
80104a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a3b:	89 04 24             	mov    %eax,(%esp)
80104a3e:	e8 d1 01 00 00       	call   80104c14 <sleep>
  }
80104a43:	e9 10 ff ff ff       	jmp    80104958 <wait+0x1a>
}
80104a48:	c9                   	leave  
80104a49:	c3                   	ret    

80104a4a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a4a:	55                   	push   %ebp
80104a4b:	89 e5                	mov    %esp,%ebp
80104a4d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104a50:	e8 fa f8 ff ff       	call   8010434f <mycpu>
80104a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a5b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a62:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a65:	e8 7e f8 ff ff       	call   801042e8 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a6a:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104a71:	e8 6d 05 00 00       	call   80104fe3 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a76:	c7 45 f4 74 52 11 80 	movl   $0x80115274,-0xc(%ebp)
80104a7d:	eb 5c                	jmp    80104adb <scheduler+0x91>
      if(p->state != RUNNABLE)
80104a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a82:	8b 40 0c             	mov    0xc(%eax),%eax
80104a85:	83 f8 03             	cmp    $0x3,%eax
80104a88:	74 02                	je     80104a8c <scheduler+0x42>
        continue;
80104a8a:	eb 4b                	jmp    80104ad7 <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a92:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9b:	89 04 24             	mov    %eax,(%esp)
80104a9e:	e8 91 37 00 00       	call   80108234 <switchuvm>
      p->state = RUNNING;
80104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab0:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ab6:	83 c2 04             	add    $0x4,%edx
80104ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104abd:	89 14 24             	mov    %edx,(%esp)
80104ac0:	e8 fb 09 00 00       	call   801054c0 <swtch>
      switchkvm();
80104ac5:	e8 50 37 00 00       	call   8010821a <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104acd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104ad4:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad7:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104adb:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104ae2:	72 9b                	jb     80104a7f <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104ae4:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104aeb:	e8 5d 05 00 00       	call   8010504d <release>

  }
80104af0:	e9 70 ff ff ff       	jmp    80104a65 <scheduler+0x1b>

80104af5 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104af5:	55                   	push   %ebp
80104af6:	89 e5                	mov    %esp,%ebp
80104af8:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104afb:	e8 d3 f8 ff ff       	call   801043d3 <myproc>
80104b00:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104b03:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104b0a:	e8 02 06 00 00       	call   80105111 <holding>
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	75 0c                	jne    80104b1f <sched+0x2a>
    panic("sched ptable.lock");
80104b13:	c7 04 24 a3 91 10 80 	movl   $0x801091a3,(%esp)
80104b1a:	e8 8e bb ff ff       	call   801006ad <panic>
  if(mycpu()->ncli != 1)
80104b1f:	e8 2b f8 ff ff       	call   8010434f <mycpu>
80104b24:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b2a:	83 f8 01             	cmp    $0x1,%eax
80104b2d:	74 0c                	je     80104b3b <sched+0x46>
    panic("sched locks");
80104b2f:	c7 04 24 b5 91 10 80 	movl   $0x801091b5,(%esp)
80104b36:	e8 72 bb ff ff       	call   801006ad <panic>
  if(p->state == RUNNING)
80104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b41:	83 f8 04             	cmp    $0x4,%eax
80104b44:	75 0c                	jne    80104b52 <sched+0x5d>
    panic("sched running");
80104b46:	c7 04 24 c1 91 10 80 	movl   $0x801091c1,(%esp)
80104b4d:	e8 5b bb ff ff       	call   801006ad <panic>
  if(readeflags()&FL_IF)
80104b52:	e8 81 f7 ff ff       	call   801042d8 <readeflags>
80104b57:	25 00 02 00 00       	and    $0x200,%eax
80104b5c:	85 c0                	test   %eax,%eax
80104b5e:	74 0c                	je     80104b6c <sched+0x77>
    panic("sched interruptible");
80104b60:	c7 04 24 cf 91 10 80 	movl   $0x801091cf,(%esp)
80104b67:	e8 41 bb ff ff       	call   801006ad <panic>
  intena = mycpu()->intena;
80104b6c:	e8 de f7 ff ff       	call   8010434f <mycpu>
80104b71:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104b7a:	e8 d0 f7 ff ff       	call   8010434f <mycpu>
80104b7f:	8b 40 04             	mov    0x4(%eax),%eax
80104b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b85:	83 c2 1c             	add    $0x1c,%edx
80104b88:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b8c:	89 14 24             	mov    %edx,(%esp)
80104b8f:	e8 2c 09 00 00       	call   801054c0 <swtch>
  mycpu()->intena = intena;
80104b94:	e8 b6 f7 ff ff       	call   8010434f <mycpu>
80104b99:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b9c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    

80104ba4 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104baa:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104bb1:	e8 2d 04 00 00       	call   80104fe3 <acquire>
  myproc()->state = RUNNABLE;
80104bb6:	e8 18 f8 ff ff       	call   801043d3 <myproc>
80104bbb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104bc2:	e8 2e ff ff ff       	call   80104af5 <sched>
  release(&ptable.lock);
80104bc7:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104bce:	e8 7a 04 00 00       	call   8010504d <release>
}
80104bd3:	c9                   	leave  
80104bd4:	c3                   	ret    

80104bd5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104bd5:	55                   	push   %ebp
80104bd6:	89 e5                	mov    %esp,%ebp
80104bd8:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104bdb:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104be2:	e8 66 04 00 00       	call   8010504d <release>

  if (first) {
80104be7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104bec:	85 c0                	test   %eax,%eax
80104bee:	74 22                	je     80104c12 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104bf0:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104bf7:	00 00 00 
    iinit(ROOTDEV);
80104bfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c01:	e8 75 cc ff ff       	call   8010187b <iinit>
    initlog(ROOTDEV);
80104c06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c0d:	e8 ca e8 ff ff       	call   801034dc <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104c12:	c9                   	leave  
80104c13:	c3                   	ret    

80104c14 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104c1a:	e8 b4 f7 ff ff       	call   801043d3 <myproc>
80104c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c26:	75 0c                	jne    80104c34 <sleep+0x20>
    panic("sleep");
80104c28:	c7 04 24 e3 91 10 80 	movl   $0x801091e3,(%esp)
80104c2f:	e8 79 ba ff ff       	call   801006ad <panic>

  if(lk == 0)
80104c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c38:	75 0c                	jne    80104c46 <sleep+0x32>
    panic("sleep without lk");
80104c3a:	c7 04 24 e9 91 10 80 	movl   $0x801091e9,(%esp)
80104c41:	e8 67 ba ff ff       	call   801006ad <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104c46:	81 7d 0c 40 52 11 80 	cmpl   $0x80115240,0xc(%ebp)
80104c4d:	74 17                	je     80104c66 <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104c4f:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104c56:	e8 88 03 00 00       	call   80104fe3 <acquire>
    release(lk);
80104c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5e:	89 04 24             	mov    %eax,(%esp)
80104c61:	e8 e7 03 00 00       	call   8010504d <release>
  }
  // Go to sleep.
  p->chan = chan;
80104c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c69:	8b 55 08             	mov    0x8(%ebp),%edx
80104c6c:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c72:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104c79:	e8 77 fe ff ff       	call   80104af5 <sched>

  // Tidy up.
  p->chan = 0;
80104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c81:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c88:	81 7d 0c 40 52 11 80 	cmpl   $0x80115240,0xc(%ebp)
80104c8f:	74 17                	je     80104ca8 <sleep+0x94>
    release(&ptable.lock);
80104c91:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104c98:	e8 b0 03 00 00       	call   8010504d <release>
    acquire(lk);
80104c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ca0:	89 04 24             	mov    %eax,(%esp)
80104ca3:	e8 3b 03 00 00       	call   80104fe3 <acquire>
  }
}
80104ca8:	c9                   	leave  
80104ca9:	c3                   	ret    

80104caa <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104caa:	55                   	push   %ebp
80104cab:	89 e5                	mov    %esp,%ebp
80104cad:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cb0:	c7 45 fc 74 52 11 80 	movl   $0x80115274,-0x4(%ebp)
80104cb7:	eb 24                	jmp    80104cdd <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cbc:	8b 40 0c             	mov    0xc(%eax),%eax
80104cbf:	83 f8 02             	cmp    $0x2,%eax
80104cc2:	75 15                	jne    80104cd9 <wakeup1+0x2f>
80104cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cc7:	8b 40 20             	mov    0x20(%eax),%eax
80104cca:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ccd:	75 0a                	jne    80104cd9 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd9:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104cdd:	81 7d fc 74 71 11 80 	cmpl   $0x80117174,-0x4(%ebp)
80104ce4:	72 d3                	jb     80104cb9 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104ce6:	c9                   	leave  
80104ce7:	c3                   	ret    

80104ce8 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ce8:	55                   	push   %ebp
80104ce9:	89 e5                	mov    %esp,%ebp
80104ceb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104cee:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104cf5:	e8 e9 02 00 00       	call   80104fe3 <acquire>
  wakeup1(chan);
80104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfd:	89 04 24             	mov    %eax,(%esp)
80104d00:	e8 a5 ff ff ff       	call   80104caa <wakeup1>
  release(&ptable.lock);
80104d05:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104d0c:	e8 3c 03 00 00       	call   8010504d <release>
}
80104d11:	c9                   	leave  
80104d12:	c3                   	ret    

80104d13 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d13:	55                   	push   %ebp
80104d14:	89 e5                	mov    %esp,%ebp
80104d16:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d19:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104d20:	e8 be 02 00 00       	call   80104fe3 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d25:	c7 45 f4 74 52 11 80 	movl   $0x80115274,-0xc(%ebp)
80104d2c:	eb 41                	jmp    80104d6f <kill+0x5c>
    if(p->pid == pid){
80104d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d31:	8b 40 10             	mov    0x10(%eax),%eax
80104d34:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d37:	75 32                	jne    80104d6b <kill+0x58>
      p->killed = 1;
80104d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d46:	8b 40 0c             	mov    0xc(%eax),%eax
80104d49:	83 f8 02             	cmp    $0x2,%eax
80104d4c:	75 0a                	jne    80104d58 <kill+0x45>
        p->state = RUNNABLE;
80104d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d51:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d58:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104d5f:	e8 e9 02 00 00       	call   8010504d <release>
      return 0;
80104d64:	b8 00 00 00 00       	mov    $0x0,%eax
80104d69:	eb 1e                	jmp    80104d89 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d6b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104d6f:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104d76:	72 b6                	jb     80104d2e <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104d78:	c7 04 24 40 52 11 80 	movl   $0x80115240,(%esp)
80104d7f:	e8 c9 02 00 00       	call   8010504d <release>
  return -1;
80104d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    

80104d8b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d8b:	55                   	push   %ebp
80104d8c:	89 e5                	mov    %esp,%ebp
80104d8e:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d91:	c7 45 f0 74 52 11 80 	movl   $0x80115274,-0x10(%ebp)
80104d98:	e9 d5 00 00 00       	jmp    80104e72 <procdump+0xe7>
    if(p->state == UNUSED)
80104d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104da0:	8b 40 0c             	mov    0xc(%eax),%eax
80104da3:	85 c0                	test   %eax,%eax
80104da5:	75 05                	jne    80104dac <procdump+0x21>
      continue;
80104da7:	e9 c2 00 00 00       	jmp    80104e6e <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104daf:	8b 40 0c             	mov    0xc(%eax),%eax
80104db2:	83 f8 05             	cmp    $0x5,%eax
80104db5:	77 23                	ja     80104dda <procdump+0x4f>
80104db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dba:	8b 40 0c             	mov    0xc(%eax),%eax
80104dbd:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	74 12                	je     80104dda <procdump+0x4f>
      state = states[p->state];
80104dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dcb:	8b 40 0c             	mov    0xc(%eax),%eax
80104dce:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104dd8:	eb 07                	jmp    80104de1 <procdump+0x56>
    else
      state = "???";
80104dda:	c7 45 ec fa 91 10 80 	movl   $0x801091fa,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104de4:	8d 50 6c             	lea    0x6c(%eax),%edx
80104de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dea:	8b 40 10             	mov    0x10(%eax),%eax
80104ded:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104df1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104df4:	89 54 24 08          	mov    %edx,0x8(%esp)
80104df8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dfc:	c7 04 24 fe 91 10 80 	movl   $0x801091fe,(%esp)
80104e03:	e8 12 b7 ff ff       	call   8010051a <cprintf>
    if(p->state == SLEEPING){
80104e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e0b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e0e:	83 f8 02             	cmp    $0x2,%eax
80104e11:	75 4f                	jne    80104e62 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e16:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e19:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1c:	83 c0 08             	add    $0x8,%eax
80104e1f:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104e22:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e26:	89 04 24             	mov    %eax,(%esp)
80104e29:	e8 6c 02 00 00       	call   8010509a <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104e35:	eb 1a                	jmp    80104e51 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e42:	c7 04 24 07 92 10 80 	movl   $0x80109207,(%esp)
80104e49:	e8 cc b6 ff ff       	call   8010051a <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104e4e:	ff 45 f4             	incl   -0xc(%ebp)
80104e51:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e55:	7f 0b                	jg     80104e62 <procdump+0xd7>
80104e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e5e:	85 c0                	test   %eax,%eax
80104e60:	75 d5                	jne    80104e37 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e62:	c7 04 24 0b 92 10 80 	movl   $0x8010920b,(%esp)
80104e69:	e8 ac b6 ff ff       	call   8010051a <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e6e:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104e72:	81 7d f0 74 71 11 80 	cmpl   $0x80117174,-0x10(%ebp)
80104e79:	0f 82 1e ff ff ff    	jb     80104d9d <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104e7f:	c9                   	leave  
80104e80:	c3                   	ret    
80104e81:	00 00                	add    %al,(%eax)
	...

80104e84 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8d:	83 c0 04             	add    $0x4,%eax
80104e90:	c7 44 24 04 37 92 10 	movl   $0x80109237,0x4(%esp)
80104e97:	80 
80104e98:	89 04 24             	mov    %eax,(%esp)
80104e9b:	e8 22 01 00 00       	call   80104fc2 <initlock>
  lk->name = name;
80104ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ea6:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80104eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb5:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104ebc:	c9                   	leave  
80104ebd:	c3                   	ret    

80104ebe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ebe:	55                   	push   %ebp
80104ebf:	89 e5                	mov    %esp,%ebp
80104ec1:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec7:	83 c0 04             	add    $0x4,%eax
80104eca:	89 04 24             	mov    %eax,(%esp)
80104ecd:	e8 11 01 00 00       	call   80104fe3 <acquire>
  while (lk->locked) {
80104ed2:	eb 15                	jmp    80104ee9 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed7:	83 c0 04             	add    $0x4,%eax
80104eda:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ede:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee1:	89 04 24             	mov    %eax,(%esp)
80104ee4:	e8 2b fd ff ff       	call   80104c14 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80104eec:	8b 00                	mov    (%eax),%eax
80104eee:	85 c0                	test   %eax,%eax
80104ef0:	75 e2                	jne    80104ed4 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104efb:	e8 d3 f4 ff ff       	call   801043d3 <myproc>
80104f00:	8b 50 10             	mov    0x10(%eax),%edx
80104f03:	8b 45 08             	mov    0x8(%ebp),%eax
80104f06:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104f09:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0c:	83 c0 04             	add    $0x4,%eax
80104f0f:	89 04 24             	mov    %eax,(%esp)
80104f12:	e8 36 01 00 00       	call   8010504d <release>
}
80104f17:	c9                   	leave  
80104f18:	c3                   	ret    

80104f19 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
80104f1c:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f22:	83 c0 04             	add    $0x4,%eax
80104f25:	89 04 24             	mov    %eax,(%esp)
80104f28:	e8 b6 00 00 00       	call   80104fe3 <acquire>
  lk->locked = 0;
80104f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104f36:	8b 45 08             	mov    0x8(%ebp),%eax
80104f39:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104f40:	8b 45 08             	mov    0x8(%ebp),%eax
80104f43:	89 04 24             	mov    %eax,(%esp)
80104f46:	e8 9d fd ff ff       	call   80104ce8 <wakeup>
  release(&lk->lk);
80104f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4e:	83 c0 04             	add    $0x4,%eax
80104f51:	89 04 24             	mov    %eax,(%esp)
80104f54:	e8 f4 00 00 00       	call   8010504d <release>
}
80104f59:	c9                   	leave  
80104f5a:	c3                   	ret    

80104f5b <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f5b:	55                   	push   %ebp
80104f5c:	89 e5                	mov    %esp,%ebp
80104f5e:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104f61:	8b 45 08             	mov    0x8(%ebp),%eax
80104f64:	83 c0 04             	add    $0x4,%eax
80104f67:	89 04 24             	mov    %eax,(%esp)
80104f6a:	e8 74 00 00 00       	call   80104fe3 <acquire>
  r = lk->locked;
80104f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f72:	8b 00                	mov    (%eax),%eax
80104f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104f77:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7a:	83 c0 04             	add    $0x4,%eax
80104f7d:	89 04 24             	mov    %eax,(%esp)
80104f80:	e8 c8 00 00 00       	call   8010504d <release>
  return r;
80104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104f88:	c9                   	leave  
80104f89:	c3                   	ret    
	...

80104f8c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f8c:	55                   	push   %ebp
80104f8d:	89 e5                	mov    %esp,%ebp
80104f8f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f92:	9c                   	pushf  
80104f93:	58                   	pop    %eax
80104f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f9a:	c9                   	leave  
80104f9b:	c3                   	ret    

80104f9c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f9c:	55                   	push   %ebp
80104f9d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f9f:	fa                   	cli    
}
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    

80104fa2 <sti>:

static inline void
sti(void)
{
80104fa2:	55                   	push   %ebp
80104fa3:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104fa5:	fb                   	sti    
}
80104fa6:	5d                   	pop    %ebp
80104fa7:	c3                   	ret    

80104fa8 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104fa8:	55                   	push   %ebp
80104fa9:	89 e5                	mov    %esp,%ebp
80104fab:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104fae:	8b 55 08             	mov    0x8(%ebp),%edx
80104fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fb7:	f0 87 02             	lock xchg %eax,(%edx)
80104fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    

80104fc2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fc2:	55                   	push   %ebp
80104fc3:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fcb:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104fce:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    

80104fe3 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104fe3:	55                   	push   %ebp
80104fe4:	89 e5                	mov    %esp,%ebp
80104fe6:	53                   	push   %ebx
80104fe7:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104fea:	e8 53 01 00 00       	call   80105142 <pushcli>
  if(holding(lk))
80104fef:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff2:	89 04 24             	mov    %eax,(%esp)
80104ff5:	e8 17 01 00 00       	call   80105111 <holding>
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	74 0c                	je     8010500a <acquire+0x27>
    panic("acquire");
80104ffe:	c7 04 24 42 92 10 80 	movl   $0x80109242,(%esp)
80105005:	e8 a3 b6 ff ff       	call   801006ad <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010500a:	90                   	nop
8010500b:	8b 45 08             	mov    0x8(%ebp),%eax
8010500e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105015:	00 
80105016:	89 04 24             	mov    %eax,(%esp)
80105019:	e8 8a ff ff ff       	call   80104fa8 <xchg>
8010501e:	85 c0                	test   %eax,%eax
80105020:	75 e9                	jne    8010500b <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80105022:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010502a:	e8 20 f3 ff ff       	call   8010434f <mycpu>
8010502f:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105032:	8b 45 08             	mov    0x8(%ebp),%eax
80105035:	83 c0 0c             	add    $0xc,%eax
80105038:	89 44 24 04          	mov    %eax,0x4(%esp)
8010503c:	8d 45 08             	lea    0x8(%ebp),%eax
8010503f:	89 04 24             	mov    %eax,(%esp)
80105042:	e8 53 00 00 00       	call   8010509a <getcallerpcs>
}
80105047:	83 c4 14             	add    $0x14,%esp
8010504a:	5b                   	pop    %ebx
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    

8010504d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010504d:	55                   	push   %ebp
8010504e:	89 e5                	mov    %esp,%ebp
80105050:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105053:	8b 45 08             	mov    0x8(%ebp),%eax
80105056:	89 04 24             	mov    %eax,(%esp)
80105059:	e8 b3 00 00 00       	call   80105111 <holding>
8010505e:	85 c0                	test   %eax,%eax
80105060:	75 0c                	jne    8010506e <release+0x21>
    panic("release");
80105062:	c7 04 24 4a 92 10 80 	movl   $0x8010924a,(%esp)
80105069:	e8 3f b6 ff ff       	call   801006ad <panic>

  lk->pcs[0] = 0;
8010506e:	8b 45 08             	mov    0x8(%ebp),%eax
80105071:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105078:	8b 45 08             	mov    0x8(%ebp),%eax
8010507b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105082:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105087:	8b 45 08             	mov    0x8(%ebp),%eax
8010508a:	8b 55 08             	mov    0x8(%ebp),%edx
8010508d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105093:	e8 f4 00 00 00       	call   8010518c <popcli>
}
80105098:	c9                   	leave  
80105099:	c3                   	ret    

8010509a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010509a:	55                   	push   %ebp
8010509b:	89 e5                	mov    %esp,%ebp
8010509d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801050a0:	8b 45 08             	mov    0x8(%ebp),%eax
801050a3:	83 e8 08             	sub    $0x8,%eax
801050a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801050a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801050b0:	eb 37                	jmp    801050e9 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801050b6:	74 37                	je     801050ef <getcallerpcs+0x55>
801050b8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801050bf:	76 2e                	jbe    801050ef <getcallerpcs+0x55>
801050c1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801050c5:	74 28                	je     801050ef <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d4:	01 c2                	add    %eax,%edx
801050d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d9:	8b 40 04             	mov    0x4(%eax),%eax
801050dc:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801050de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050e1:	8b 00                	mov    (%eax),%eax
801050e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050e6:	ff 45 f8             	incl   -0x8(%ebp)
801050e9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050ed:	7e c3                	jle    801050b2 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050ef:	eb 18                	jmp    80105109 <getcallerpcs+0x6f>
    pcs[i] = 0;
801050f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050fe:	01 d0                	add    %edx,%eax
80105100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105106:	ff 45 f8             	incl   -0x8(%ebp)
80105109:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010510d:	7e e2                	jle    801050f1 <getcallerpcs+0x57>
    pcs[i] = 0;
}
8010510f:	c9                   	leave  
80105110:	c3                   	ret    

80105111 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105111:	55                   	push   %ebp
80105112:	89 e5                	mov    %esp,%ebp
80105114:	53                   	push   %ebx
80105115:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105118:	8b 45 08             	mov    0x8(%ebp),%eax
8010511b:	8b 00                	mov    (%eax),%eax
8010511d:	85 c0                	test   %eax,%eax
8010511f:	74 16                	je     80105137 <holding+0x26>
80105121:	8b 45 08             	mov    0x8(%ebp),%eax
80105124:	8b 58 08             	mov    0x8(%eax),%ebx
80105127:	e8 23 f2 ff ff       	call   8010434f <mycpu>
8010512c:	39 c3                	cmp    %eax,%ebx
8010512e:	75 07                	jne    80105137 <holding+0x26>
80105130:	b8 01 00 00 00       	mov    $0x1,%eax
80105135:	eb 05                	jmp    8010513c <holding+0x2b>
80105137:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010513c:	83 c4 04             	add    $0x4,%esp
8010513f:	5b                   	pop    %ebx
80105140:	5d                   	pop    %ebp
80105141:	c3                   	ret    

80105142 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105142:	55                   	push   %ebp
80105143:	89 e5                	mov    %esp,%ebp
80105145:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105148:	e8 3f fe ff ff       	call   80104f8c <readeflags>
8010514d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105150:	e8 47 fe ff ff       	call   80104f9c <cli>
  if(mycpu()->ncli == 0)
80105155:	e8 f5 f1 ff ff       	call   8010434f <mycpu>
8010515a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105160:	85 c0                	test   %eax,%eax
80105162:	75 14                	jne    80105178 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80105164:	e8 e6 f1 ff ff       	call   8010434f <mycpu>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	81 e2 00 02 00 00    	and    $0x200,%edx
80105172:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105178:	e8 d2 f1 ff ff       	call   8010434f <mycpu>
8010517d:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105183:	42                   	inc    %edx
80105184:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    

8010518c <popcli>:

void
popcli(void)
{
8010518c:	55                   	push   %ebp
8010518d:	89 e5                	mov    %esp,%ebp
8010518f:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105192:	e8 f5 fd ff ff       	call   80104f8c <readeflags>
80105197:	25 00 02 00 00       	and    $0x200,%eax
8010519c:	85 c0                	test   %eax,%eax
8010519e:	74 0c                	je     801051ac <popcli+0x20>
    panic("popcli - interruptible");
801051a0:	c7 04 24 52 92 10 80 	movl   $0x80109252,(%esp)
801051a7:	e8 01 b5 ff ff       	call   801006ad <panic>
  if(--mycpu()->ncli < 0)
801051ac:	e8 9e f1 ff ff       	call   8010434f <mycpu>
801051b1:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051b7:	4a                   	dec    %edx
801051b8:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801051be:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801051c4:	85 c0                	test   %eax,%eax
801051c6:	79 0c                	jns    801051d4 <popcli+0x48>
    panic("popcli");
801051c8:	c7 04 24 69 92 10 80 	movl   $0x80109269,(%esp)
801051cf:	e8 d9 b4 ff ff       	call   801006ad <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051d4:	e8 76 f1 ff ff       	call   8010434f <mycpu>
801051d9:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801051df:	85 c0                	test   %eax,%eax
801051e1:	75 14                	jne    801051f7 <popcli+0x6b>
801051e3:	e8 67 f1 ff ff       	call   8010434f <mycpu>
801051e8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051ee:	85 c0                	test   %eax,%eax
801051f0:	74 05                	je     801051f7 <popcli+0x6b>
    sti();
801051f2:	e8 ab fd ff ff       	call   80104fa2 <sti>
}
801051f7:	c9                   	leave  
801051f8:	c3                   	ret    
801051f9:	00 00                	add    %al,(%eax)
	...

801051fc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801051fc:	55                   	push   %ebp
801051fd:	89 e5                	mov    %esp,%ebp
801051ff:	57                   	push   %edi
80105200:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105201:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105204:	8b 55 10             	mov    0x10(%ebp),%edx
80105207:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520a:	89 cb                	mov    %ecx,%ebx
8010520c:	89 df                	mov    %ebx,%edi
8010520e:	89 d1                	mov    %edx,%ecx
80105210:	fc                   	cld    
80105211:	f3 aa                	rep stos %al,%es:(%edi)
80105213:	89 ca                	mov    %ecx,%edx
80105215:	89 fb                	mov    %edi,%ebx
80105217:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010521a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010521d:	5b                   	pop    %ebx
8010521e:	5f                   	pop    %edi
8010521f:	5d                   	pop    %ebp
80105220:	c3                   	ret    

80105221 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105221:	55                   	push   %ebp
80105222:	89 e5                	mov    %esp,%ebp
80105224:	57                   	push   %edi
80105225:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105226:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105229:	8b 55 10             	mov    0x10(%ebp),%edx
8010522c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522f:	89 cb                	mov    %ecx,%ebx
80105231:	89 df                	mov    %ebx,%edi
80105233:	89 d1                	mov    %edx,%ecx
80105235:	fc                   	cld    
80105236:	f3 ab                	rep stos %eax,%es:(%edi)
80105238:	89 ca                	mov    %ecx,%edx
8010523a:	89 fb                	mov    %edi,%ebx
8010523c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010523f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105242:	5b                   	pop    %ebx
80105243:	5f                   	pop    %edi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    

80105246 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105246:	55                   	push   %ebp
80105247:	89 e5                	mov    %esp,%ebp
80105249:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010524c:	8b 45 08             	mov    0x8(%ebp),%eax
8010524f:	83 e0 03             	and    $0x3,%eax
80105252:	85 c0                	test   %eax,%eax
80105254:	75 49                	jne    8010529f <memset+0x59>
80105256:	8b 45 10             	mov    0x10(%ebp),%eax
80105259:	83 e0 03             	and    $0x3,%eax
8010525c:	85 c0                	test   %eax,%eax
8010525e:	75 3f                	jne    8010529f <memset+0x59>
    c &= 0xFF;
80105260:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105267:	8b 45 10             	mov    0x10(%ebp),%eax
8010526a:	c1 e8 02             	shr    $0x2,%eax
8010526d:	89 c2                	mov    %eax,%edx
8010526f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105272:	c1 e0 18             	shl    $0x18,%eax
80105275:	89 c1                	mov    %eax,%ecx
80105277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527a:	c1 e0 10             	shl    $0x10,%eax
8010527d:	09 c1                	or     %eax,%ecx
8010527f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105282:	c1 e0 08             	shl    $0x8,%eax
80105285:	09 c8                	or     %ecx,%eax
80105287:	0b 45 0c             	or     0xc(%ebp),%eax
8010528a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010528e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105292:	8b 45 08             	mov    0x8(%ebp),%eax
80105295:	89 04 24             	mov    %eax,(%esp)
80105298:	e8 84 ff ff ff       	call   80105221 <stosl>
8010529d:	eb 19                	jmp    801052b8 <memset+0x72>
  } else
    stosb(dst, c, n);
8010529f:	8b 45 10             	mov    0x10(%ebp),%eax
801052a2:	89 44 24 08          	mov    %eax,0x8(%esp)
801052a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ad:	8b 45 08             	mov    0x8(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 44 ff ff ff       	call   801051fc <stosb>
  return dst;
801052b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052bb:	c9                   	leave  
801052bc:	c3                   	ret    

801052bd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052bd:	55                   	push   %ebp
801052be:	89 e5                	mov    %esp,%ebp
801052c0:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801052c3:	8b 45 08             	mov    0x8(%ebp),%eax
801052c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801052cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801052cf:	eb 2a                	jmp    801052fb <memcmp+0x3e>
    if(*s1 != *s2)
801052d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d4:	8a 10                	mov    (%eax),%dl
801052d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052d9:	8a 00                	mov    (%eax),%al
801052db:	38 c2                	cmp    %al,%dl
801052dd:	74 16                	je     801052f5 <memcmp+0x38>
      return *s1 - *s2;
801052df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e2:	8a 00                	mov    (%eax),%al
801052e4:	0f b6 d0             	movzbl %al,%edx
801052e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ea:	8a 00                	mov    (%eax),%al
801052ec:	0f b6 c0             	movzbl %al,%eax
801052ef:	29 c2                	sub    %eax,%edx
801052f1:	89 d0                	mov    %edx,%eax
801052f3:	eb 18                	jmp    8010530d <memcmp+0x50>
    s1++, s2++;
801052f5:	ff 45 fc             	incl   -0x4(%ebp)
801052f8:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052fb:	8b 45 10             	mov    0x10(%ebp),%eax
801052fe:	8d 50 ff             	lea    -0x1(%eax),%edx
80105301:	89 55 10             	mov    %edx,0x10(%ebp)
80105304:	85 c0                	test   %eax,%eax
80105306:	75 c9                	jne    801052d1 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105308:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010530d:	c9                   	leave  
8010530e:	c3                   	ret    

8010530f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010530f:	55                   	push   %ebp
80105310:	89 e5                	mov    %esp,%ebp
80105312:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105315:	8b 45 0c             	mov    0xc(%ebp),%eax
80105318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010531b:	8b 45 08             	mov    0x8(%ebp),%eax
8010531e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105321:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105324:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105327:	73 3a                	jae    80105363 <memmove+0x54>
80105329:	8b 45 10             	mov    0x10(%ebp),%eax
8010532c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010532f:	01 d0                	add    %edx,%eax
80105331:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105334:	76 2d                	jbe    80105363 <memmove+0x54>
    s += n;
80105336:	8b 45 10             	mov    0x10(%ebp),%eax
80105339:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010533c:	8b 45 10             	mov    0x10(%ebp),%eax
8010533f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105342:	eb 10                	jmp    80105354 <memmove+0x45>
      *--d = *--s;
80105344:	ff 4d f8             	decl   -0x8(%ebp)
80105347:	ff 4d fc             	decl   -0x4(%ebp)
8010534a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010534d:	8a 10                	mov    (%eax),%dl
8010534f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105352:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105354:	8b 45 10             	mov    0x10(%ebp),%eax
80105357:	8d 50 ff             	lea    -0x1(%eax),%edx
8010535a:	89 55 10             	mov    %edx,0x10(%ebp)
8010535d:	85 c0                	test   %eax,%eax
8010535f:	75 e3                	jne    80105344 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105361:	eb 25                	jmp    80105388 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105363:	eb 16                	jmp    8010537b <memmove+0x6c>
      *d++ = *s++;
80105365:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105368:	8d 50 01             	lea    0x1(%eax),%edx
8010536b:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010536e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105371:	8d 4a 01             	lea    0x1(%edx),%ecx
80105374:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105377:	8a 12                	mov    (%edx),%dl
80105379:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010537b:	8b 45 10             	mov    0x10(%ebp),%eax
8010537e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105381:	89 55 10             	mov    %edx,0x10(%ebp)
80105384:	85 c0                	test   %eax,%eax
80105386:	75 dd                	jne    80105365 <memmove+0x56>
      *d++ = *s++;

  return dst;
80105388:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010538b:	c9                   	leave  
8010538c:	c3                   	ret    

8010538d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010538d:	55                   	push   %ebp
8010538e:	89 e5                	mov    %esp,%ebp
80105390:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105393:	8b 45 10             	mov    0x10(%ebp),%eax
80105396:	89 44 24 08          	mov    %eax,0x8(%esp)
8010539a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539d:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a1:	8b 45 08             	mov    0x8(%ebp),%eax
801053a4:	89 04 24             	mov    %eax,(%esp)
801053a7:	e8 63 ff ff ff       	call   8010530f <memmove>
}
801053ac:	c9                   	leave  
801053ad:	c3                   	ret    

801053ae <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801053ae:	55                   	push   %ebp
801053af:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801053b1:	eb 09                	jmp    801053bc <strncmp+0xe>
    n--, p++, q++;
801053b3:	ff 4d 10             	decl   0x10(%ebp)
801053b6:	ff 45 08             	incl   0x8(%ebp)
801053b9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801053bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053c0:	74 17                	je     801053d9 <strncmp+0x2b>
801053c2:	8b 45 08             	mov    0x8(%ebp),%eax
801053c5:	8a 00                	mov    (%eax),%al
801053c7:	84 c0                	test   %al,%al
801053c9:	74 0e                	je     801053d9 <strncmp+0x2b>
801053cb:	8b 45 08             	mov    0x8(%ebp),%eax
801053ce:	8a 10                	mov    (%eax),%dl
801053d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d3:	8a 00                	mov    (%eax),%al
801053d5:	38 c2                	cmp    %al,%dl
801053d7:	74 da                	je     801053b3 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801053d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053dd:	75 07                	jne    801053e6 <strncmp+0x38>
    return 0;
801053df:	b8 00 00 00 00       	mov    $0x0,%eax
801053e4:	eb 14                	jmp    801053fa <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
801053e6:	8b 45 08             	mov    0x8(%ebp),%eax
801053e9:	8a 00                	mov    (%eax),%al
801053eb:	0f b6 d0             	movzbl %al,%edx
801053ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f1:	8a 00                	mov    (%eax),%al
801053f3:	0f b6 c0             	movzbl %al,%eax
801053f6:	29 c2                	sub    %eax,%edx
801053f8:	89 d0                	mov    %edx,%eax
}
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    

801053fc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053fc:	55                   	push   %ebp
801053fd:	89 e5                	mov    %esp,%ebp
801053ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105402:	8b 45 08             	mov    0x8(%ebp),%eax
80105405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105408:	90                   	nop
80105409:	8b 45 10             	mov    0x10(%ebp),%eax
8010540c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010540f:	89 55 10             	mov    %edx,0x10(%ebp)
80105412:	85 c0                	test   %eax,%eax
80105414:	7e 1c                	jle    80105432 <strncpy+0x36>
80105416:	8b 45 08             	mov    0x8(%ebp),%eax
80105419:	8d 50 01             	lea    0x1(%eax),%edx
8010541c:	89 55 08             	mov    %edx,0x8(%ebp)
8010541f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105422:	8d 4a 01             	lea    0x1(%edx),%ecx
80105425:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105428:	8a 12                	mov    (%edx),%dl
8010542a:	88 10                	mov    %dl,(%eax)
8010542c:	8a 00                	mov    (%eax),%al
8010542e:	84 c0                	test   %al,%al
80105430:	75 d7                	jne    80105409 <strncpy+0xd>
    ;
  while(n-- > 0)
80105432:	eb 0c                	jmp    80105440 <strncpy+0x44>
    *s++ = 0;
80105434:	8b 45 08             	mov    0x8(%ebp),%eax
80105437:	8d 50 01             	lea    0x1(%eax),%edx
8010543a:	89 55 08             	mov    %edx,0x8(%ebp)
8010543d:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105440:	8b 45 10             	mov    0x10(%ebp),%eax
80105443:	8d 50 ff             	lea    -0x1(%eax),%edx
80105446:	89 55 10             	mov    %edx,0x10(%ebp)
80105449:	85 c0                	test   %eax,%eax
8010544b:	7f e7                	jg     80105434 <strncpy+0x38>
    *s++ = 0;
  return os;
8010544d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105450:	c9                   	leave  
80105451:	c3                   	ret    

80105452 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105452:	55                   	push   %ebp
80105453:	89 e5                	mov    %esp,%ebp
80105455:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105458:	8b 45 08             	mov    0x8(%ebp),%eax
8010545b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010545e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105462:	7f 05                	jg     80105469 <safestrcpy+0x17>
    return os;
80105464:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105467:	eb 2e                	jmp    80105497 <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
80105469:	ff 4d 10             	decl   0x10(%ebp)
8010546c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105470:	7e 1c                	jle    8010548e <safestrcpy+0x3c>
80105472:	8b 45 08             	mov    0x8(%ebp),%eax
80105475:	8d 50 01             	lea    0x1(%eax),%edx
80105478:	89 55 08             	mov    %edx,0x8(%ebp)
8010547b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010547e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105481:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105484:	8a 12                	mov    (%edx),%dl
80105486:	88 10                	mov    %dl,(%eax)
80105488:	8a 00                	mov    (%eax),%al
8010548a:	84 c0                	test   %al,%al
8010548c:	75 db                	jne    80105469 <safestrcpy+0x17>
    ;
  *s = 0;
8010548e:	8b 45 08             	mov    0x8(%ebp),%eax
80105491:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105494:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105497:	c9                   	leave  
80105498:	c3                   	ret    

80105499 <strlen>:

int
strlen(const char *s)
{
80105499:	55                   	push   %ebp
8010549a:	89 e5                	mov    %esp,%ebp
8010549c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010549f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801054a6:	eb 03                	jmp    801054ab <strlen+0x12>
801054a8:	ff 45 fc             	incl   -0x4(%ebp)
801054ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054ae:	8b 45 08             	mov    0x8(%ebp),%eax
801054b1:	01 d0                	add    %edx,%eax
801054b3:	8a 00                	mov    (%eax),%al
801054b5:	84 c0                	test   %al,%al
801054b7:	75 ef                	jne    801054a8 <strlen+0xf>
    ;
  return n;
801054b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054bc:	c9                   	leave  
801054bd:	c3                   	ret    
	...

801054c0 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801054c0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054c4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801054c8:	55                   	push   %ebp
  pushl %ebx
801054c9:	53                   	push   %ebx
  pushl %esi
801054ca:	56                   	push   %esi
  pushl %edi
801054cb:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054cc:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054ce:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801054d0:	5f                   	pop    %edi
  popl %esi
801054d1:	5e                   	pop    %esi
  popl %ebx
801054d2:	5b                   	pop    %ebx
  popl %ebp
801054d3:	5d                   	pop    %ebp
  ret
801054d4:	c3                   	ret    
801054d5:	00 00                	add    %al,(%eax)
	...

801054d8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054d8:	55                   	push   %ebp
801054d9:	89 e5                	mov    %esp,%ebp
801054db:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801054de:	e8 f0 ee ff ff       	call   801043d3 <myproc>
801054e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e9:	8b 00                	mov    (%eax),%eax
801054eb:	3b 45 08             	cmp    0x8(%ebp),%eax
801054ee:	76 0f                	jbe    801054ff <fetchint+0x27>
801054f0:	8b 45 08             	mov    0x8(%ebp),%eax
801054f3:	8d 50 04             	lea    0x4(%eax),%edx
801054f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f9:	8b 00                	mov    (%eax),%eax
801054fb:	39 c2                	cmp    %eax,%edx
801054fd:	76 07                	jbe    80105506 <fetchint+0x2e>
    return -1;
801054ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105504:	eb 0f                	jmp    80105515 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105506:	8b 45 08             	mov    0x8(%ebp),%eax
80105509:	8b 10                	mov    (%eax),%edx
8010550b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550e:	89 10                	mov    %edx,(%eax)
  return 0;
80105510:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105515:	c9                   	leave  
80105516:	c3                   	ret    

80105517 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105517:	55                   	push   %ebp
80105518:	89 e5                	mov    %esp,%ebp
8010551a:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
8010551d:	e8 b1 ee ff ff       	call   801043d3 <myproc>
80105522:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105528:	8b 00                	mov    (%eax),%eax
8010552a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010552d:	77 07                	ja     80105536 <fetchstr+0x1f>
    return -1;
8010552f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105534:	eb 41                	jmp    80105577 <fetchstr+0x60>
  *pp = (char*)addr;
80105536:	8b 55 08             	mov    0x8(%ebp),%edx
80105539:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553c:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
8010553e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105541:	8b 00                	mov    (%eax),%eax
80105543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105546:	8b 45 0c             	mov    0xc(%ebp),%eax
80105549:	8b 00                	mov    (%eax),%eax
8010554b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010554e:	eb 1a                	jmp    8010556a <fetchstr+0x53>
    if(*s == 0)
80105550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105553:	8a 00                	mov    (%eax),%al
80105555:	84 c0                	test   %al,%al
80105557:	75 0e                	jne    80105567 <fetchstr+0x50>
      return s - *pp;
80105559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010555f:	8b 00                	mov    (%eax),%eax
80105561:	29 c2                	sub    %eax,%edx
80105563:	89 d0                	mov    %edx,%eax
80105565:	eb 10                	jmp    80105577 <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105567:	ff 45 f4             	incl   -0xc(%ebp)
8010556a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105570:	72 de                	jb     80105550 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80105572:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105577:	c9                   	leave  
80105578:	c3                   	ret    

80105579 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105579:	55                   	push   %ebp
8010557a:	89 e5                	mov    %esp,%ebp
8010557c:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010557f:	e8 4f ee ff ff       	call   801043d3 <myproc>
80105584:	8b 40 18             	mov    0x18(%eax),%eax
80105587:	8b 50 44             	mov    0x44(%eax),%edx
8010558a:	8b 45 08             	mov    0x8(%ebp),%eax
8010558d:	c1 e0 02             	shl    $0x2,%eax
80105590:	01 d0                	add    %edx,%eax
80105592:	8d 50 04             	lea    0x4(%eax),%edx
80105595:	8b 45 0c             	mov    0xc(%ebp),%eax
80105598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559c:	89 14 24             	mov    %edx,(%esp)
8010559f:	e8 34 ff ff ff       	call   801054d8 <fetchint>
}
801055a4:	c9                   	leave  
801055a5:	c3                   	ret    

801055a6 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055a6:	55                   	push   %ebp
801055a7:	89 e5                	mov    %esp,%ebp
801055a9:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
801055ac:	e8 22 ee ff ff       	call   801043d3 <myproc>
801055b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801055b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055bb:	8b 45 08             	mov    0x8(%ebp),%eax
801055be:	89 04 24             	mov    %eax,(%esp)
801055c1:	e8 b3 ff ff ff       	call   80105579 <argint>
801055c6:	85 c0                	test   %eax,%eax
801055c8:	79 07                	jns    801055d1 <argptr+0x2b>
    return -1;
801055ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cf:	eb 3d                	jmp    8010560e <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055d5:	78 21                	js     801055f8 <argptr+0x52>
801055d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055da:	89 c2                	mov    %eax,%edx
801055dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055df:	8b 00                	mov    (%eax),%eax
801055e1:	39 c2                	cmp    %eax,%edx
801055e3:	73 13                	jae    801055f8 <argptr+0x52>
801055e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e8:	89 c2                	mov    %eax,%edx
801055ea:	8b 45 10             	mov    0x10(%ebp),%eax
801055ed:	01 c2                	add    %eax,%edx
801055ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f2:	8b 00                	mov    (%eax),%eax
801055f4:	39 c2                	cmp    %eax,%edx
801055f6:	76 07                	jbe    801055ff <argptr+0x59>
    return -1;
801055f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fd:	eb 0f                	jmp    8010560e <argptr+0x68>
  *pp = (char*)i;
801055ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105602:	89 c2                	mov    %eax,%edx
80105604:	8b 45 0c             	mov    0xc(%ebp),%eax
80105607:	89 10                	mov    %edx,(%eax)
  return 0;
80105609:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561d:	8b 45 08             	mov    0x8(%ebp),%eax
80105620:	89 04 24             	mov    %eax,(%esp)
80105623:	e8 51 ff ff ff       	call   80105579 <argint>
80105628:	85 c0                	test   %eax,%eax
8010562a:	79 07                	jns    80105633 <argstr+0x23>
    return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 12                	jmp    80105645 <argstr+0x35>
  return fetchstr(addr, pp);
80105633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105636:	8b 55 0c             	mov    0xc(%ebp),%edx
80105639:	89 54 24 04          	mov    %edx,0x4(%esp)
8010563d:	89 04 24             	mov    %eax,(%esp)
80105640:	e8 d2 fe ff ff       	call   80105517 <fetchstr>
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    

80105647 <syscall>:
[SYS_getcwd]      sys_getcwd, 
};

void
syscall(void)
{
80105647:	55                   	push   %ebp
80105648:	89 e5                	mov    %esp,%ebp
8010564a:	53                   	push   %ebx
8010564b:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
8010564e:	e8 80 ed ff ff       	call   801043d3 <myproc>
80105653:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105659:	8b 40 18             	mov    0x18(%eax),%eax
8010565c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010565f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105666:	7e 2d                	jle    80105695 <syscall+0x4e>
80105668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566b:	83 f8 26             	cmp    $0x26,%eax
8010566e:	77 25                	ja     80105695 <syscall+0x4e>
80105670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105673:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
8010567a:	85 c0                	test   %eax,%eax
8010567c:	74 17                	je     80105695 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
8010567e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105681:	8b 58 18             	mov    0x18(%eax),%ebx
80105684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105687:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
8010568e:	ff d0                	call   *%eax
80105690:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105693:	eb 34                	jmp    801056c9 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105698:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010569b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569e:	8b 40 10             	mov    0x10(%eax),%eax
801056a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
801056a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b0:	c7 04 24 70 92 10 80 	movl   $0x80109270,(%esp)
801056b7:	e8 5e ae ff ff       	call   8010051a <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801056bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056bf:	8b 40 18             	mov    0x18(%eax),%eax
801056c2:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801056c9:	83 c4 24             	add    $0x24,%esp
801056cc:	5b                   	pop    %ebx
801056cd:	5d                   	pop    %ebp
801056ce:	c3                   	ret    
	...

801056d0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056dd:	8b 45 08             	mov    0x8(%ebp),%eax
801056e0:	89 04 24             	mov    %eax,(%esp)
801056e3:	e8 91 fe ff ff       	call   80105579 <argint>
801056e8:	85 c0                	test   %eax,%eax
801056ea:	79 07                	jns    801056f3 <argfd+0x23>
    return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f1:	eb 4f                	jmp    80105742 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f6:	85 c0                	test   %eax,%eax
801056f8:	78 20                	js     8010571a <argfd+0x4a>
801056fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fd:	83 f8 0f             	cmp    $0xf,%eax
80105700:	7f 18                	jg     8010571a <argfd+0x4a>
80105702:	e8 cc ec ff ff       	call   801043d3 <myproc>
80105707:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010570a:	83 c2 08             	add    $0x8,%edx
8010570d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105711:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105714:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105718:	75 07                	jne    80105721 <argfd+0x51>
    return -1;
8010571a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571f:	eb 21                	jmp    80105742 <argfd+0x72>
  if(pfd)
80105721:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105725:	74 08                	je     8010572f <argfd+0x5f>
    *pfd = fd;
80105727:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010572a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010572d:	89 10                	mov    %edx,(%eax)
  if(pf)
8010572f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105733:	74 08                	je     8010573d <argfd+0x6d>
    *pf = f;
80105735:	8b 45 10             	mov    0x10(%ebp),%eax
80105738:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010573b:	89 10                	mov    %edx,(%eax)
  return 0;
8010573d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105742:	c9                   	leave  
80105743:	c3                   	ret    

80105744 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010574a:	e8 84 ec ff ff       	call   801043d3 <myproc>
8010574f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105752:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105759:	eb 29                	jmp    80105784 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
8010575b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105761:	83 c2 08             	add    $0x8,%edx
80105764:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105768:	85 c0                	test   %eax,%eax
8010576a:	75 15                	jne    80105781 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
8010576c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105772:	8d 4a 08             	lea    0x8(%edx),%ecx
80105775:	8b 55 08             	mov    0x8(%ebp),%edx
80105778:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010577c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577f:	eb 0e                	jmp    8010578f <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105781:	ff 45 f4             	incl   -0xc(%ebp)
80105784:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105788:	7e d1                	jle    8010575b <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010578a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578f:	c9                   	leave  
80105790:	c3                   	ret    

80105791 <sys_dup>:

int
sys_dup(void)
{
80105791:	55                   	push   %ebp
80105792:	89 e5                	mov    %esp,%ebp
80105794:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105797:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010579a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010579e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057a5:	00 
801057a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ad:	e8 1e ff ff ff       	call   801056d0 <argfd>
801057b2:	85 c0                	test   %eax,%eax
801057b4:	79 07                	jns    801057bd <sys_dup+0x2c>
    return -1;
801057b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bb:	eb 29                	jmp    801057e6 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c0:	89 04 24             	mov    %eax,(%esp)
801057c3:	e8 7c ff ff ff       	call   80105744 <fdalloc>
801057c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057cf:	79 07                	jns    801057d8 <sys_dup+0x47>
    return -1;
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d6:	eb 0e                	jmp    801057e6 <sys_dup+0x55>
  filedup(f);
801057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057db:	89 04 24             	mov    %eax,(%esp)
801057de:	e8 9d ba ff ff       	call   80101280 <filedup>
  return fd;
801057e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057e6:	c9                   	leave  
801057e7:	c3                   	ret    

801057e8 <sys_read>:

int
sys_read(void)
{
801057e8:	55                   	push   %ebp
801057e9:	89 e5                	mov    %esp,%ebp
801057eb:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f1:	89 44 24 08          	mov    %eax,0x8(%esp)
801057f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057fc:	00 
801057fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105804:	e8 c7 fe ff ff       	call   801056d0 <argfd>
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 35                	js     80105842 <sys_read+0x5a>
8010580d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105810:	89 44 24 04          	mov    %eax,0x4(%esp)
80105814:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010581b:	e8 59 fd ff ff       	call   80105579 <argint>
80105820:	85 c0                	test   %eax,%eax
80105822:	78 1e                	js     80105842 <sys_read+0x5a>
80105824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105827:	89 44 24 08          	mov    %eax,0x8(%esp)
8010582b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010582e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105832:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105839:	e8 68 fd ff ff       	call   801055a6 <argptr>
8010583e:	85 c0                	test   %eax,%eax
80105840:	79 07                	jns    80105849 <sys_read+0x61>
    return -1;
80105842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105847:	eb 19                	jmp    80105862 <sys_read+0x7a>
  return fileread(f, p, n);
80105849:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010584c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010584f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105852:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105856:	89 54 24 04          	mov    %edx,0x4(%esp)
8010585a:	89 04 24             	mov    %eax,(%esp)
8010585d:	e8 7f bb ff ff       	call   801013e1 <fileread>
}
80105862:	c9                   	leave  
80105863:	c3                   	ret    

80105864 <sys_write>:

int
sys_write(void)
{
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010586a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010586d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105871:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105878:	00 
80105879:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105880:	e8 4b fe ff ff       	call   801056d0 <argfd>
80105885:	85 c0                	test   %eax,%eax
80105887:	78 35                	js     801058be <sys_write+0x5a>
80105889:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010588c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105890:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105897:	e8 dd fc ff ff       	call   80105579 <argint>
8010589c:	85 c0                	test   %eax,%eax
8010589e:	78 1e                	js     801058be <sys_write+0x5a>
801058a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801058a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058b5:	e8 ec fc ff ff       	call   801055a6 <argptr>
801058ba:	85 c0                	test   %eax,%eax
801058bc:	79 07                	jns    801058c5 <sys_write+0x61>
    return -1;
801058be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c3:	eb 19                	jmp    801058de <sys_write+0x7a>
  return filewrite(f, p, n);
801058c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801058d6:	89 04 24             	mov    %eax,(%esp)
801058d9:	e8 be bb ff ff       	call   8010149c <filewrite>
}
801058de:	c9                   	leave  
801058df:	c3                   	ret    

801058e0 <sys_close>:

int
sys_close(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801058e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058fb:	e8 d0 fd ff ff       	call   801056d0 <argfd>
80105900:	85 c0                	test   %eax,%eax
80105902:	79 07                	jns    8010590b <sys_close+0x2b>
    return -1;
80105904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105909:	eb 23                	jmp    8010592e <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
8010590b:	e8 c3 ea ff ff       	call   801043d3 <myproc>
80105910:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105913:	83 c2 08             	add    $0x8,%edx
80105916:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010591d:	00 
  fileclose(f);
8010591e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105921:	89 04 24             	mov    %eax,(%esp)
80105924:	e8 9f b9 ff ff       	call   801012c8 <fileclose>
  return 0;
80105929:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010592e:	c9                   	leave  
8010592f:	c3                   	ret    

80105930 <sys_fstat>:

int
sys_fstat(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105939:	89 44 24 08          	mov    %eax,0x8(%esp)
8010593d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105944:	00 
80105945:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010594c:	e8 7f fd ff ff       	call   801056d0 <argfd>
80105951:	85 c0                	test   %eax,%eax
80105953:	78 1f                	js     80105974 <sys_fstat+0x44>
80105955:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010595c:	00 
8010595d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105960:	89 44 24 04          	mov    %eax,0x4(%esp)
80105964:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010596b:	e8 36 fc ff ff       	call   801055a6 <argptr>
80105970:	85 c0                	test   %eax,%eax
80105972:	79 07                	jns    8010597b <sys_fstat+0x4b>
    return -1;
80105974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105979:	eb 12                	jmp    8010598d <sys_fstat+0x5d>
  return filestat(f, st);
8010597b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010597e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105981:	89 54 24 04          	mov    %edx,0x4(%esp)
80105985:	89 04 24             	mov    %eax,(%esp)
80105988:	e8 05 ba ff ff       	call   80101392 <filestat>
}
8010598d:	c9                   	leave  
8010598e:	c3                   	ret    

8010598f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010598f:	55                   	push   %ebp
80105990:	89 e5                	mov    %esp,%ebp
80105992:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105995:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105998:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059a3:	e8 68 fc ff ff       	call   80105610 <argstr>
801059a8:	85 c0                	test   %eax,%eax
801059aa:	78 17                	js     801059c3 <sys_link+0x34>
801059ac:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059af:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059ba:	e8 51 fc ff ff       	call   80105610 <argstr>
801059bf:	85 c0                	test   %eax,%eax
801059c1:	79 0a                	jns    801059cd <sys_link+0x3e>
    return -1;
801059c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c8:	e9 3d 01 00 00       	jmp    80105b0a <sys_link+0x17b>

  begin_op();
801059cd:	e8 09 dd ff ff       	call   801036db <begin_op>
  if((ip = namei(old)) == 0){
801059d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801059d5:	89 04 24             	mov    %eax,(%esp)
801059d8:	e8 2a cd ff ff       	call   80102707 <namei>
801059dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059e4:	75 0f                	jne    801059f5 <sys_link+0x66>
    end_op();
801059e6:	e8 72 dd ff ff       	call   8010375d <end_op>
    return -1;
801059eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f0:	e9 15 01 00 00       	jmp    80105b0a <sys_link+0x17b>
  }

  ilock(ip);
801059f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f8:	89 04 24             	mov    %eax,(%esp)
801059fb:	e8 e2 c1 ff ff       	call   80101be2 <ilock>
  if(ip->type == T_DIR){
80105a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a03:	8b 40 50             	mov    0x50(%eax),%eax
80105a06:	66 83 f8 01          	cmp    $0x1,%ax
80105a0a:	75 1a                	jne    80105a26 <sys_link+0x97>
    iunlockput(ip);
80105a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0f:	89 04 24             	mov    %eax,(%esp)
80105a12:	e8 ca c3 ff ff       	call   80101de1 <iunlockput>
    end_op();
80105a17:	e8 41 dd ff ff       	call   8010375d <end_op>
    return -1;
80105a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a21:	e9 e4 00 00 00       	jmp    80105b0a <sys_link+0x17b>
  }

  ip->nlink++;
80105a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a29:	66 8b 40 56          	mov    0x56(%eax),%ax
80105a2d:	40                   	inc    %eax
80105a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a31:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a38:	89 04 24             	mov    %eax,(%esp)
80105a3b:	e8 df bf ff ff       	call   80101a1f <iupdate>
  iunlock(ip);
80105a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a43:	89 04 24             	mov    %eax,(%esp)
80105a46:	e8 a1 c2 ff ff       	call   80101cec <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a4e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a51:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a55:	89 04 24             	mov    %eax,(%esp)
80105a58:	e8 cc cc ff ff       	call   80102729 <nameiparent>
80105a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a64:	75 02                	jne    80105a68 <sys_link+0xd9>
    goto bad;
80105a66:	eb 68                	jmp    80105ad0 <sys_link+0x141>
  ilock(dp);
80105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6b:	89 04 24             	mov    %eax,(%esp)
80105a6e:	e8 6f c1 ff ff       	call   80101be2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a76:	8b 10                	mov    (%eax),%edx
80105a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7b:	8b 00                	mov    (%eax),%eax
80105a7d:	39 c2                	cmp    %eax,%edx
80105a7f:	75 20                	jne    80105aa1 <sys_link+0x112>
80105a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a84:	8b 40 04             	mov    0x4(%eax),%eax
80105a87:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a8b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a95:	89 04 24             	mov    %eax,(%esp)
80105a98:	e8 b7 c9 ff ff       	call   80102454 <dirlink>
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	79 0d                	jns    80105aae <sys_link+0x11f>
    iunlockput(dp);
80105aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa4:	89 04 24             	mov    %eax,(%esp)
80105aa7:	e8 35 c3 ff ff       	call   80101de1 <iunlockput>
    goto bad;
80105aac:	eb 22                	jmp    80105ad0 <sys_link+0x141>
  }
  iunlockput(dp);
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	89 04 24             	mov    %eax,(%esp)
80105ab4:	e8 28 c3 ff ff       	call   80101de1 <iunlockput>
  iput(ip);
80105ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abc:	89 04 24             	mov    %eax,(%esp)
80105abf:	e8 6c c2 ff ff       	call   80101d30 <iput>

  end_op();
80105ac4:	e8 94 dc ff ff       	call   8010375d <end_op>

  return 0;
80105ac9:	b8 00 00 00 00       	mov    $0x0,%eax
80105ace:	eb 3a                	jmp    80105b0a <sys_link+0x17b>

bad:
  ilock(ip);
80105ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad3:	89 04 24             	mov    %eax,(%esp)
80105ad6:	e8 07 c1 ff ff       	call   80101be2 <ilock>
  ip->nlink--;
80105adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ade:	66 8b 40 56          	mov    0x56(%eax),%ax
80105ae2:	48                   	dec    %eax
80105ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ae6:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aed:	89 04 24             	mov    %eax,(%esp)
80105af0:	e8 2a bf ff ff       	call   80101a1f <iupdate>
  iunlockput(ip);
80105af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af8:	89 04 24             	mov    %eax,(%esp)
80105afb:	e8 e1 c2 ff ff       	call   80101de1 <iunlockput>
  end_op();
80105b00:	e8 58 dc ff ff       	call   8010375d <end_op>
  return -1;
80105b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b0a:	c9                   	leave  
80105b0b:	c3                   	ret    

80105b0c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105b0c:	55                   	push   %ebp
80105b0d:	89 e5                	mov    %esp,%ebp
80105b0f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b12:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b19:	eb 4a                	jmp    80105b65 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b25:	00 
80105b26:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b2a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b31:	8b 45 08             	mov    0x8(%ebp),%eax
80105b34:	89 04 24             	mov    %eax,(%esp)
80105b37:	e8 3d c5 ff ff       	call   80102079 <readi>
80105b3c:	83 f8 10             	cmp    $0x10,%eax
80105b3f:	74 0c                	je     80105b4d <isdirempty+0x41>
      panic("isdirempty: readi");
80105b41:	c7 04 24 8c 92 10 80 	movl   $0x8010928c,(%esp)
80105b48:	e8 60 ab ff ff       	call   801006ad <panic>
    if(de.inum != 0)
80105b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b50:	66 85 c0             	test   %ax,%ax
80105b53:	74 07                	je     80105b5c <isdirempty+0x50>
      return 0;
80105b55:	b8 00 00 00 00       	mov    $0x0,%eax
80105b5a:	eb 1b                	jmp    80105b77 <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5f:	83 c0 10             	add    $0x10,%eax
80105b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b68:	8b 45 08             	mov    0x8(%ebp),%eax
80105b6b:	8b 40 58             	mov    0x58(%eax),%eax
80105b6e:	39 c2                	cmp    %eax,%edx
80105b70:	72 a9                	jb     80105b1b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105b72:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b77:	c9                   	leave  
80105b78:	c3                   	ret    

80105b79 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b79:	55                   	push   %ebp
80105b7a:	89 e5                	mov    %esp,%ebp
80105b7c:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b7f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b82:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b8d:	e8 7e fa ff ff       	call   80105610 <argstr>
80105b92:	85 c0                	test   %eax,%eax
80105b94:	79 0a                	jns    80105ba0 <sys_unlink+0x27>
    return -1;
80105b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9b:	e9 a9 01 00 00       	jmp    80105d49 <sys_unlink+0x1d0>

  begin_op();
80105ba0:	e8 36 db ff ff       	call   801036db <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ba8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105bab:	89 54 24 04          	mov    %edx,0x4(%esp)
80105baf:	89 04 24             	mov    %eax,(%esp)
80105bb2:	e8 72 cb ff ff       	call   80102729 <nameiparent>
80105bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bbe:	75 0f                	jne    80105bcf <sys_unlink+0x56>
    end_op();
80105bc0:	e8 98 db ff ff       	call   8010375d <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bca:	e9 7a 01 00 00       	jmp    80105d49 <sys_unlink+0x1d0>
  }

  ilock(dp);
80105bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd2:	89 04 24             	mov    %eax,(%esp)
80105bd5:	e8 08 c0 ff ff       	call   80101be2 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bda:	c7 44 24 04 9e 92 10 	movl   $0x8010929e,0x4(%esp)
80105be1:	80 
80105be2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105be5:	89 04 24             	mov    %eax,(%esp)
80105be8:	e8 7f c7 ff ff       	call   8010236c <namecmp>
80105bed:	85 c0                	test   %eax,%eax
80105bef:	0f 84 3f 01 00 00    	je     80105d34 <sys_unlink+0x1bb>
80105bf5:	c7 44 24 04 a0 92 10 	movl   $0x801092a0,0x4(%esp)
80105bfc:	80 
80105bfd:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c00:	89 04 24             	mov    %eax,(%esp)
80105c03:	e8 64 c7 ff ff       	call   8010236c <namecmp>
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	0f 84 24 01 00 00    	je     80105d34 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c10:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105c13:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c17:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c21:	89 04 24             	mov    %eax,(%esp)
80105c24:	e8 65 c7 ff ff       	call   8010238e <dirlookup>
80105c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c30:	75 05                	jne    80105c37 <sys_unlink+0xbe>
    goto bad;
80105c32:	e9 fd 00 00 00       	jmp    80105d34 <sys_unlink+0x1bb>
  ilock(ip);
80105c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3a:	89 04 24             	mov    %eax,(%esp)
80105c3d:	e8 a0 bf ff ff       	call   80101be2 <ilock>

  if(ip->nlink < 1)
80105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c45:	66 8b 40 56          	mov    0x56(%eax),%ax
80105c49:	66 85 c0             	test   %ax,%ax
80105c4c:	7f 0c                	jg     80105c5a <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105c4e:	c7 04 24 a3 92 10 80 	movl   $0x801092a3,(%esp)
80105c55:	e8 53 aa ff ff       	call   801006ad <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5d:	8b 40 50             	mov    0x50(%eax),%eax
80105c60:	66 83 f8 01          	cmp    $0x1,%ax
80105c64:	75 1f                	jne    80105c85 <sys_unlink+0x10c>
80105c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c69:	89 04 24             	mov    %eax,(%esp)
80105c6c:	e8 9b fe ff ff       	call   80105b0c <isdirempty>
80105c71:	85 c0                	test   %eax,%eax
80105c73:	75 10                	jne    80105c85 <sys_unlink+0x10c>
    iunlockput(ip);
80105c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c78:	89 04 24             	mov    %eax,(%esp)
80105c7b:	e8 61 c1 ff ff       	call   80101de1 <iunlockput>
    goto bad;
80105c80:	e9 af 00 00 00       	jmp    80105d34 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105c85:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c8c:	00 
80105c8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c94:	00 
80105c95:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c98:	89 04 24             	mov    %eax,(%esp)
80105c9b:	e8 a6 f5 ff ff       	call   80105246 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105ca3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105caa:	00 
80105cab:	89 44 24 08          	mov    %eax,0x8(%esp)
80105caf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb9:	89 04 24             	mov    %eax,(%esp)
80105cbc:	e8 1c c5 ff ff       	call   801021dd <writei>
80105cc1:	83 f8 10             	cmp    $0x10,%eax
80105cc4:	74 0c                	je     80105cd2 <sys_unlink+0x159>
    panic("unlink: writei");
80105cc6:	c7 04 24 b5 92 10 80 	movl   $0x801092b5,(%esp)
80105ccd:	e8 db a9 ff ff       	call   801006ad <panic>
  if(ip->type == T_DIR){
80105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd5:	8b 40 50             	mov    0x50(%eax),%eax
80105cd8:	66 83 f8 01          	cmp    $0x1,%ax
80105cdc:	75 1a                	jne    80105cf8 <sys_unlink+0x17f>
    dp->nlink--;
80105cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce1:	66 8b 40 56          	mov    0x56(%eax),%ax
80105ce5:	48                   	dec    %eax
80105ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ce9:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf0:	89 04 24             	mov    %eax,(%esp)
80105cf3:	e8 27 bd ff ff       	call   80101a1f <iupdate>
  }
  iunlockput(dp);
80105cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfb:	89 04 24             	mov    %eax,(%esp)
80105cfe:	e8 de c0 ff ff       	call   80101de1 <iunlockput>

  ip->nlink--;
80105d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d06:	66 8b 40 56          	mov    0x56(%eax),%ax
80105d0a:	48                   	dec    %eax
80105d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d0e:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d15:	89 04 24             	mov    %eax,(%esp)
80105d18:	e8 02 bd ff ff       	call   80101a1f <iupdate>
  iunlockput(ip);
80105d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d20:	89 04 24             	mov    %eax,(%esp)
80105d23:	e8 b9 c0 ff ff       	call   80101de1 <iunlockput>

  end_op();
80105d28:	e8 30 da ff ff       	call   8010375d <end_op>

  return 0;
80105d2d:	b8 00 00 00 00       	mov    $0x0,%eax
80105d32:	eb 15                	jmp    80105d49 <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d37:	89 04 24             	mov    %eax,(%esp)
80105d3a:	e8 a2 c0 ff ff       	call   80101de1 <iunlockput>
  end_op();
80105d3f:	e8 19 da ff ff       	call   8010375d <end_op>
  return -1;
80105d44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d49:	c9                   	leave  
80105d4a:	c3                   	ret    

80105d4b <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d4b:	55                   	push   %ebp
80105d4c:	89 e5                	mov    %esp,%ebp
80105d4e:	83 ec 48             	sub    $0x48,%esp
80105d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d54:	8b 55 10             	mov    0x10(%ebp),%edx
80105d57:	8b 45 14             	mov    0x14(%ebp),%eax
80105d5a:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d5e:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d62:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d66:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d69:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80105d70:	89 04 24             	mov    %eax,(%esp)
80105d73:	e8 b1 c9 ff ff       	call   80102729 <nameiparent>
80105d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d7f:	75 0a                	jne    80105d8b <create+0x40>
    return 0;
80105d81:	b8 00 00 00 00       	mov    $0x0,%eax
80105d86:	e9 79 01 00 00       	jmp    80105f04 <create+0x1b9>
  ilock(dp);
80105d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8e:	89 04 24             	mov    %eax,(%esp)
80105d91:	e8 4c be ff ff       	call   80101be2 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d96:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d99:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d9d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105da0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da7:	89 04 24             	mov    %eax,(%esp)
80105daa:	e8 df c5 ff ff       	call   8010238e <dirlookup>
80105daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105db2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105db6:	74 46                	je     80105dfe <create+0xb3>
    iunlockput(dp);
80105db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbb:	89 04 24             	mov    %eax,(%esp)
80105dbe:	e8 1e c0 ff ff       	call   80101de1 <iunlockput>
    ilock(ip);
80105dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc6:	89 04 24             	mov    %eax,(%esp)
80105dc9:	e8 14 be ff ff       	call   80101be2 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105dce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105dd3:	75 14                	jne    80105de9 <create+0x9e>
80105dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd8:	8b 40 50             	mov    0x50(%eax),%eax
80105ddb:	66 83 f8 02          	cmp    $0x2,%ax
80105ddf:	75 08                	jne    80105de9 <create+0x9e>
      return ip;
80105de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de4:	e9 1b 01 00 00       	jmp    80105f04 <create+0x1b9>
    iunlockput(ip);
80105de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dec:	89 04 24             	mov    %eax,(%esp)
80105def:	e8 ed bf ff ff       	call   80101de1 <iunlockput>
    return 0;
80105df4:	b8 00 00 00 00       	mov    $0x0,%eax
80105df9:	e9 06 01 00 00       	jmp    80105f04 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105dfe:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e05:	8b 00                	mov    (%eax),%eax
80105e07:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e0b:	89 04 24             	mov    %eax,(%esp)
80105e0e:	e8 3a bb ff ff       	call   8010194d <ialloc>
80105e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e1a:	75 0c                	jne    80105e28 <create+0xdd>
    panic("create: ialloc");
80105e1c:	c7 04 24 c4 92 10 80 	movl   $0x801092c4,(%esp)
80105e23:	e8 85 a8 ff ff       	call   801006ad <panic>

  ilock(ip);
80105e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2b:	89 04 24             	mov    %eax,(%esp)
80105e2e:	e8 af bd ff ff       	call   80101be2 <ilock>
  ip->major = major;
80105e33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e36:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105e39:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105e3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e40:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e43:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4a:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e53:	89 04 24             	mov    %eax,(%esp)
80105e56:	e8 c4 bb ff ff       	call   80101a1f <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e5b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e60:	75 68                	jne    80105eca <create+0x17f>
    dp->nlink++;  // for ".."
80105e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e65:	66 8b 40 56          	mov    0x56(%eax),%ax
80105e69:	40                   	inc    %eax
80105e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e6d:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e74:	89 04 24             	mov    %eax,(%esp)
80105e77:	e8 a3 bb ff ff       	call   80101a1f <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7f:	8b 40 04             	mov    0x4(%eax),%eax
80105e82:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e86:	c7 44 24 04 9e 92 10 	movl   $0x8010929e,0x4(%esp)
80105e8d:	80 
80105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e91:	89 04 24             	mov    %eax,(%esp)
80105e94:	e8 bb c5 ff ff       	call   80102454 <dirlink>
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	78 21                	js     80105ebe <create+0x173>
80105e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea0:	8b 40 04             	mov    0x4(%eax),%eax
80105ea3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ea7:	c7 44 24 04 a0 92 10 	movl   $0x801092a0,0x4(%esp)
80105eae:	80 
80105eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb2:	89 04 24             	mov    %eax,(%esp)
80105eb5:	e8 9a c5 ff ff       	call   80102454 <dirlink>
80105eba:	85 c0                	test   %eax,%eax
80105ebc:	79 0c                	jns    80105eca <create+0x17f>
      panic("create dots");
80105ebe:	c7 04 24 d3 92 10 80 	movl   $0x801092d3,(%esp)
80105ec5:	e8 e3 a7 ff ff       	call   801006ad <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ecd:	8b 40 04             	mov    0x4(%eax),%eax
80105ed0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed4:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ede:	89 04 24             	mov    %eax,(%esp)
80105ee1:	e8 6e c5 ff ff       	call   80102454 <dirlink>
80105ee6:	85 c0                	test   %eax,%eax
80105ee8:	79 0c                	jns    80105ef6 <create+0x1ab>
    panic("create: dirlink");
80105eea:	c7 04 24 df 92 10 80 	movl   $0x801092df,(%esp)
80105ef1:	e8 b7 a7 ff ff       	call   801006ad <panic>

  iunlockput(dp);
80105ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef9:	89 04 24             	mov    %eax,(%esp)
80105efc:	e8 e0 be ff ff       	call   80101de1 <iunlockput>

  return ip;
80105f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f04:	c9                   	leave  
80105f05:	c3                   	ret    

80105f06 <sys_open>:

int
sys_open(void)
{
80105f06:	55                   	push   %ebp
80105f07:	89 e5                	mov    %esp,%ebp
80105f09:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f0c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f1a:	e8 f1 f6 ff ff       	call   80105610 <argstr>
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	78 17                	js     80105f3a <sys_open+0x34>
80105f23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f26:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f31:	e8 43 f6 ff ff       	call   80105579 <argint>
80105f36:	85 c0                	test   %eax,%eax
80105f38:	79 0a                	jns    80105f44 <sys_open+0x3e>
    return -1;
80105f3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3f:	e9 5b 01 00 00       	jmp    8010609f <sys_open+0x199>

  begin_op();
80105f44:	e8 92 d7 ff ff       	call   801036db <begin_op>

  if(omode & O_CREATE){
80105f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f4c:	25 00 02 00 00       	and    $0x200,%eax
80105f51:	85 c0                	test   %eax,%eax
80105f53:	74 3b                	je     80105f90 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f58:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f5f:	00 
80105f60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f67:	00 
80105f68:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f6f:	00 
80105f70:	89 04 24             	mov    %eax,(%esp)
80105f73:	e8 d3 fd ff ff       	call   80105d4b <create>
80105f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f7f:	75 6a                	jne    80105feb <sys_open+0xe5>
      end_op();
80105f81:	e8 d7 d7 ff ff       	call   8010375d <end_op>
      return -1;
80105f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8b:	e9 0f 01 00 00       	jmp    8010609f <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f93:	89 04 24             	mov    %eax,(%esp)
80105f96:	e8 6c c7 ff ff       	call   80102707 <namei>
80105f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fa2:	75 0f                	jne    80105fb3 <sys_open+0xad>
      end_op();
80105fa4:	e8 b4 d7 ff ff       	call   8010375d <end_op>
      return -1;
80105fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fae:	e9 ec 00 00 00       	jmp    8010609f <sys_open+0x199>
    }
    ilock(ip);
80105fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb6:	89 04 24             	mov    %eax,(%esp)
80105fb9:	e8 24 bc ff ff       	call   80101be2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc1:	8b 40 50             	mov    0x50(%eax),%eax
80105fc4:	66 83 f8 01          	cmp    $0x1,%ax
80105fc8:	75 21                	jne    80105feb <sys_open+0xe5>
80105fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	74 1a                	je     80105feb <sys_open+0xe5>
      iunlockput(ip);
80105fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd4:	89 04 24             	mov    %eax,(%esp)
80105fd7:	e8 05 be ff ff       	call   80101de1 <iunlockput>
      end_op();
80105fdc:	e8 7c d7 ff ff       	call   8010375d <end_op>
      return -1;
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe6:	e9 b4 00 00 00       	jmp    8010609f <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105feb:	e8 30 b2 ff ff       	call   80101220 <filealloc>
80105ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ff3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ff7:	74 14                	je     8010600d <sys_open+0x107>
80105ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffc:	89 04 24             	mov    %eax,(%esp)
80105fff:	e8 40 f7 ff ff       	call   80105744 <fdalloc>
80106004:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106007:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010600b:	79 28                	jns    80106035 <sys_open+0x12f>
    if(f)
8010600d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106011:	74 0b                	je     8010601e <sys_open+0x118>
      fileclose(f);
80106013:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106016:	89 04 24             	mov    %eax,(%esp)
80106019:	e8 aa b2 ff ff       	call   801012c8 <fileclose>
    iunlockput(ip);
8010601e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106021:	89 04 24             	mov    %eax,(%esp)
80106024:	e8 b8 bd ff ff       	call   80101de1 <iunlockput>
    end_op();
80106029:	e8 2f d7 ff ff       	call   8010375d <end_op>
    return -1;
8010602e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106033:	eb 6a                	jmp    8010609f <sys_open+0x199>
  }
  iunlock(ip);
80106035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106038:	89 04 24             	mov    %eax,(%esp)
8010603b:	e8 ac bc ff ff       	call   80101cec <iunlock>
  end_op();
80106040:	e8 18 d7 ff ff       	call   8010375d <end_op>

  f->type = FD_INODE;
80106045:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106048:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010604e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106051:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106054:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106057:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106064:	83 e0 01             	and    $0x1,%eax
80106067:	85 c0                	test   %eax,%eax
80106069:	0f 94 c0             	sete   %al
8010606c:	88 c2                	mov    %al,%dl
8010606e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106071:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106077:	83 e0 01             	and    $0x1,%eax
8010607a:	85 c0                	test   %eax,%eax
8010607c:	75 0a                	jne    80106088 <sys_open+0x182>
8010607e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106081:	83 e0 02             	and    $0x2,%eax
80106084:	85 c0                	test   %eax,%eax
80106086:	74 07                	je     8010608f <sys_open+0x189>
80106088:	b8 01 00 00 00       	mov    $0x1,%eax
8010608d:	eb 05                	jmp    80106094 <sys_open+0x18e>
8010608f:	b8 00 00 00 00       	mov    $0x0,%eax
80106094:	88 c2                	mov    %al,%dl
80106096:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106099:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010609c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010609f:	c9                   	leave  
801060a0:	c3                   	ret    

801060a1 <sys_mkdir>:

int
sys_mkdir(void)
{
801060a1:	55                   	push   %ebp
801060a2:	89 e5                	mov    %esp,%ebp
801060a4:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801060a7:	e8 2f d6 ff ff       	call   801036db <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060af:	89 44 24 04          	mov    %eax,0x4(%esp)
801060b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ba:	e8 51 f5 ff ff       	call   80105610 <argstr>
801060bf:	85 c0                	test   %eax,%eax
801060c1:	78 2c                	js     801060ef <sys_mkdir+0x4e>
801060c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801060cd:	00 
801060ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801060d5:	00 
801060d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801060dd:	00 
801060de:	89 04 24             	mov    %eax,(%esp)
801060e1:	e8 65 fc ff ff       	call   80105d4b <create>
801060e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ed:	75 0c                	jne    801060fb <sys_mkdir+0x5a>
    end_op();
801060ef:	e8 69 d6 ff ff       	call   8010375d <end_op>
    return -1;
801060f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f9:	eb 15                	jmp    80106110 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801060fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fe:	89 04 24             	mov    %eax,(%esp)
80106101:	e8 db bc ff ff       	call   80101de1 <iunlockput>
  end_op();
80106106:	e8 52 d6 ff ff       	call   8010375d <end_op>
  return 0;
8010610b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106110:	c9                   	leave  
80106111:	c3                   	ret    

80106112 <sys_mknod>:

int
sys_mknod(void)
{
80106112:	55                   	push   %ebp
80106113:	89 e5                	mov    %esp,%ebp
80106115:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106118:	e8 be d5 ff ff       	call   801036db <begin_op>
  if((argstr(0, &path)) < 0 ||
8010611d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106120:	89 44 24 04          	mov    %eax,0x4(%esp)
80106124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010612b:	e8 e0 f4 ff ff       	call   80105610 <argstr>
80106130:	85 c0                	test   %eax,%eax
80106132:	78 5e                	js     80106192 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106134:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106142:	e8 32 f4 ff ff       	call   80105579 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80106147:	85 c0                	test   %eax,%eax
80106149:	78 47                	js     80106192 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010614b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010614e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106152:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106159:	e8 1b f4 ff ff       	call   80105579 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010615e:	85 c0                	test   %eax,%eax
80106160:	78 30                	js     80106192 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106162:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106165:	0f bf c8             	movswl %ax,%ecx
80106168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010616b:	0f bf d0             	movswl %ax,%edx
8010616e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106171:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106175:	89 54 24 08          	mov    %edx,0x8(%esp)
80106179:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106180:	00 
80106181:	89 04 24             	mov    %eax,(%esp)
80106184:	e8 c2 fb ff ff       	call   80105d4b <create>
80106189:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010618c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106190:	75 0c                	jne    8010619e <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106192:	e8 c6 d5 ff ff       	call   8010375d <end_op>
    return -1;
80106197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619c:	eb 15                	jmp    801061b3 <sys_mknod+0xa1>
  }
  iunlockput(ip);
8010619e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a1:	89 04 24             	mov    %eax,(%esp)
801061a4:	e8 38 bc ff ff       	call   80101de1 <iunlockput>
  end_op();
801061a9:	e8 af d5 ff ff       	call   8010375d <end_op>
  return 0;
801061ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061b3:	c9                   	leave  
801061b4:	c3                   	ret    

801061b5 <sys_chdir>:

int
sys_chdir(void)
{
801061b5:	55                   	push   %ebp
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801061bb:	e8 13 e2 ff ff       	call   801043d3 <myproc>
801061c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801061c3:	e8 13 d5 ff ff       	call   801036db <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801061c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801061cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061d6:	e8 35 f4 ff ff       	call   80105610 <argstr>
801061db:	85 c0                	test   %eax,%eax
801061dd:	78 14                	js     801061f3 <sys_chdir+0x3e>
801061df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061e2:	89 04 24             	mov    %eax,(%esp)
801061e5:	e8 1d c5 ff ff       	call   80102707 <namei>
801061ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061f1:	75 0c                	jne    801061ff <sys_chdir+0x4a>
    end_op();
801061f3:	e8 65 d5 ff ff       	call   8010375d <end_op>
    return -1;
801061f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fd:	eb 5a                	jmp    80106259 <sys_chdir+0xa4>
  }
  ilock(ip);
801061ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106202:	89 04 24             	mov    %eax,(%esp)
80106205:	e8 d8 b9 ff ff       	call   80101be2 <ilock>
  if(ip->type != T_DIR){
8010620a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620d:	8b 40 50             	mov    0x50(%eax),%eax
80106210:	66 83 f8 01          	cmp    $0x1,%ax
80106214:	74 17                	je     8010622d <sys_chdir+0x78>
    iunlockput(ip);
80106216:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106219:	89 04 24             	mov    %eax,(%esp)
8010621c:	e8 c0 bb ff ff       	call   80101de1 <iunlockput>
    end_op();
80106221:	e8 37 d5 ff ff       	call   8010375d <end_op>
    return -1;
80106226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622b:	eb 2c                	jmp    80106259 <sys_chdir+0xa4>
  }
  iunlock(ip);
8010622d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106230:	89 04 24             	mov    %eax,(%esp)
80106233:	e8 b4 ba ff ff       	call   80101cec <iunlock>
  iput(curproc->cwd);
80106238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623b:	8b 40 68             	mov    0x68(%eax),%eax
8010623e:	89 04 24             	mov    %eax,(%esp)
80106241:	e8 ea ba ff ff       	call   80101d30 <iput>
  end_op();
80106246:	e8 12 d5 ff ff       	call   8010375d <end_op>
  curproc->cwd = ip;
8010624b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106251:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106254:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106259:	c9                   	leave  
8010625a:	c3                   	ret    

8010625b <sys_exec>:

int
sys_exec(void)
{
8010625b:	55                   	push   %ebp
8010625c:	89 e5                	mov    %esp,%ebp
8010625e:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106264:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106267:	89 44 24 04          	mov    %eax,0x4(%esp)
8010626b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106272:	e8 99 f3 ff ff       	call   80105610 <argstr>
80106277:	85 c0                	test   %eax,%eax
80106279:	78 1a                	js     80106295 <sys_exec+0x3a>
8010627b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106281:	89 44 24 04          	mov    %eax,0x4(%esp)
80106285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010628c:	e8 e8 f2 ff ff       	call   80105579 <argint>
80106291:	85 c0                	test   %eax,%eax
80106293:	79 0a                	jns    8010629f <sys_exec+0x44>
    return -1;
80106295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629a:	e9 c7 00 00 00       	jmp    80106366 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
8010629f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801062a6:	00 
801062a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801062ae:	00 
801062af:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062b5:	89 04 24             	mov    %eax,(%esp)
801062b8:	e8 89 ef ff ff       	call   80105246 <memset>
  for(i=0;; i++){
801062bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801062c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c7:	83 f8 1f             	cmp    $0x1f,%eax
801062ca:	76 0a                	jbe    801062d6 <sys_exec+0x7b>
      return -1;
801062cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d1:	e9 90 00 00 00       	jmp    80106366 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801062d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d9:	c1 e0 02             	shl    $0x2,%eax
801062dc:	89 c2                	mov    %eax,%edx
801062de:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801062e4:	01 c2                	add    %eax,%edx
801062e6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801062ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801062f0:	89 14 24             	mov    %edx,(%esp)
801062f3:	e8 e0 f1 ff ff       	call   801054d8 <fetchint>
801062f8:	85 c0                	test   %eax,%eax
801062fa:	79 07                	jns    80106303 <sys_exec+0xa8>
      return -1;
801062fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106301:	eb 63                	jmp    80106366 <sys_exec+0x10b>
    if(uarg == 0){
80106303:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	75 26                	jne    80106333 <sys_exec+0xd8>
      argv[i] = 0;
8010630d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106310:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106317:	00 00 00 00 
      break;
8010631b:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010631c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631f:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106325:	89 54 24 04          	mov    %edx,0x4(%esp)
80106329:	89 04 24             	mov    %eax,(%esp)
8010632c:	e8 93 aa ff ff       	call   80100dc4 <exec>
80106331:	eb 33                	jmp    80106366 <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106333:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106339:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010633c:	c1 e2 02             	shl    $0x2,%edx
8010633f:	01 c2                	add    %eax,%edx
80106341:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106347:	89 54 24 04          	mov    %edx,0x4(%esp)
8010634b:	89 04 24             	mov    %eax,(%esp)
8010634e:	e8 c4 f1 ff ff       	call   80105517 <fetchstr>
80106353:	85 c0                	test   %eax,%eax
80106355:	79 07                	jns    8010635e <sys_exec+0x103>
      return -1;
80106357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635c:	eb 08                	jmp    80106366 <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010635e:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106361:	e9 5e ff ff ff       	jmp    801062c4 <sys_exec+0x69>
  return exec(path, argv);
}
80106366:	c9                   	leave  
80106367:	c3                   	ret    

80106368 <sys_pipe>:

int
sys_pipe(void)
{
80106368:	55                   	push   %ebp
80106369:	89 e5                	mov    %esp,%ebp
8010636b:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010636e:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106375:	00 
80106376:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010637d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106384:	e8 1d f2 ff ff       	call   801055a6 <argptr>
80106389:	85 c0                	test   %eax,%eax
8010638b:	79 0a                	jns    80106397 <sys_pipe+0x2f>
    return -1;
8010638d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106392:	e9 9a 00 00 00       	jmp    80106431 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
80106397:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010639a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010639e:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063a1:	89 04 24             	mov    %eax,(%esp)
801063a4:	e8 7f db ff ff       	call   80103f28 <pipealloc>
801063a9:	85 c0                	test   %eax,%eax
801063ab:	79 07                	jns    801063b4 <sys_pipe+0x4c>
    return -1;
801063ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b2:	eb 7d                	jmp    80106431 <sys_pipe+0xc9>
  fd0 = -1;
801063b4:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063be:	89 04 24             	mov    %eax,(%esp)
801063c1:	e8 7e f3 ff ff       	call   80105744 <fdalloc>
801063c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063cd:	78 14                	js     801063e3 <sys_pipe+0x7b>
801063cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063d2:	89 04 24             	mov    %eax,(%esp)
801063d5:	e8 6a f3 ff ff       	call   80105744 <fdalloc>
801063da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063e1:	79 36                	jns    80106419 <sys_pipe+0xb1>
    if(fd0 >= 0)
801063e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063e7:	78 13                	js     801063fc <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801063e9:	e8 e5 df ff ff       	call   801043d3 <myproc>
801063ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063f1:	83 c2 08             	add    $0x8,%edx
801063f4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063fb:	00 
    fileclose(rf);
801063fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063ff:	89 04 24             	mov    %eax,(%esp)
80106402:	e8 c1 ae ff ff       	call   801012c8 <fileclose>
    fileclose(wf);
80106407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010640a:	89 04 24             	mov    %eax,(%esp)
8010640d:	e8 b6 ae ff ff       	call   801012c8 <fileclose>
    return -1;
80106412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106417:	eb 18                	jmp    80106431 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
80106419:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010641c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010641f:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106421:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106424:	8d 50 04             	lea    0x4(%eax),%edx
80106427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642a:	89 02                	mov    %eax,(%edx)
  return 0;
8010642c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106431:	c9                   	leave  
80106432:	c3                   	ret    

80106433 <name_of_inode>:

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
80106433:	55                   	push   %ebp
80106434:	89 e5                	mov    %esp,%ebp
80106436:	83 ec 38             	sub    $0x38,%esp
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
80106439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106440:	eb 6a                	jmp    801064ac <name_of_inode+0x79>
        if (readi(parent, (char*)&de, off, sizeof(de)) != sizeof(de))
80106442:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106449:	00 
8010644a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644d:	89 44 24 08          	mov    %eax,0x8(%esp)
80106451:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106454:	89 44 24 04          	mov    %eax,0x4(%esp)
80106458:	8b 45 0c             	mov    0xc(%ebp),%eax
8010645b:	89 04 24             	mov    %eax,(%esp)
8010645e:	e8 16 bc ff ff       	call   80102079 <readi>
80106463:	83 f8 10             	cmp    $0x10,%eax
80106466:	74 0c                	je     80106474 <name_of_inode+0x41>
            panic("couldn't read dir entry");
80106468:	c7 04 24 ef 92 10 80 	movl   $0x801092ef,(%esp)
8010646f:	e8 39 a2 ff ff       	call   801006ad <panic>
        if (de.inum == ip->inum) {
80106474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106477:	0f b7 d0             	movzwl %ax,%edx
8010647a:	8b 45 08             	mov    0x8(%ebp),%eax
8010647d:	8b 40 04             	mov    0x4(%eax),%eax
80106480:	39 c2                	cmp    %eax,%edx
80106482:	75 24                	jne    801064a8 <name_of_inode+0x75>
            safestrcpy(buf, de.name, DIRSIZ);
80106484:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010648b:	00 
8010648c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010648f:	83 c0 02             	add    $0x2,%eax
80106492:	89 44 24 04          	mov    %eax,0x4(%esp)
80106496:	8b 45 10             	mov    0x10(%ebp),%eax
80106499:	89 04 24             	mov    %eax,(%esp)
8010649c:	e8 b1 ef ff ff       	call   80105452 <safestrcpy>
            return 0;
801064a1:	b8 00 00 00 00       	mov    $0x0,%eax
801064a6:	eb 14                	jmp    801064bc <name_of_inode+0x89>

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
801064a8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801064ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801064af:	8b 40 58             	mov    0x58(%eax),%eax
801064b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064b5:	77 8b                	ja     80106442 <name_of_inode+0xf>
        if (de.inum == ip->inum) {
            safestrcpy(buf, de.name, DIRSIZ);
            return 0;
        }
    }
    return -1;
801064b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064bc:	c9                   	leave  
801064bd:	c3                   	ret    

801064be <name_for_inode>:

int
name_for_inode(char* buf, int n, struct inode *ip) {
801064be:	55                   	push   %ebp
801064bf:	89 e5                	mov    %esp,%ebp
801064c1:	53                   	push   %ebx
801064c2:	83 ec 34             	sub    $0x34,%esp
    int path_offset;
    struct inode *parent;
    char node_name[DIRSIZ];
    if (ip->inum == namei("/")->inum) { //namei is inefficient but iget isn't exported for some reason
801064c5:	8b 45 10             	mov    0x10(%ebp),%eax
801064c8:	8b 58 04             	mov    0x4(%eax),%ebx
801064cb:	c7 04 24 07 93 10 80 	movl   $0x80109307,(%esp)
801064d2:	e8 30 c2 ff ff       	call   80102707 <namei>
801064d7:	8b 40 04             	mov    0x4(%eax),%eax
801064da:	39 c3                	cmp    %eax,%ebx
801064dc:	75 10                	jne    801064ee <name_for_inode+0x30>
        buf[0] = '/';
801064de:	8b 45 08             	mov    0x8(%ebp),%eax
801064e1:	c6 00 2f             	movb   $0x2f,(%eax)
        return 1;
801064e4:	b8 01 00 00 00       	mov    $0x1,%eax
801064e9:	e9 1d 01 00 00       	jmp    8010660b <name_for_inode+0x14d>
    } else if (ip->type == T_DIR) {
801064ee:	8b 45 10             	mov    0x10(%ebp),%eax
801064f1:	8b 40 50             	mov    0x50(%eax),%eax
801064f4:	66 83 f8 01          	cmp    $0x1,%ax
801064f8:	0f 85 dd 00 00 00    	jne    801065db <name_for_inode+0x11d>
        parent = dirlookup(ip, "..", 0);
801064fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106505:	00 
80106506:	c7 44 24 04 a0 92 10 	movl   $0x801092a0,0x4(%esp)
8010650d:	80 
8010650e:	8b 45 10             	mov    0x10(%ebp),%eax
80106511:	89 04 24             	mov    %eax,(%esp)
80106514:	e8 75 be ff ff       	call   8010238e <dirlookup>
80106519:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ilock(parent);
8010651c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651f:	89 04 24             	mov    %eax,(%esp)
80106522:	e8 bb b6 ff ff       	call   80101be2 <ilock>
        if (name_of_inode(ip, parent, node_name)) {
80106527:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010652a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010652e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106531:	89 44 24 04          	mov    %eax,0x4(%esp)
80106535:	8b 45 10             	mov    0x10(%ebp),%eax
80106538:	89 04 24             	mov    %eax,(%esp)
8010653b:	e8 f3 fe ff ff       	call   80106433 <name_of_inode>
80106540:	85 c0                	test   %eax,%eax
80106542:	74 0c                	je     80106550 <name_for_inode+0x92>
            panic("could not find name of inode in parent!");
80106544:	c7 04 24 0c 93 10 80 	movl   $0x8010930c,(%esp)
8010654b:	e8 5d a1 ff ff       	call   801006ad <panic>
        }
        path_offset = name_for_inode(buf, n, parent);
80106550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106553:	89 44 24 08          	mov    %eax,0x8(%esp)
80106557:	8b 45 0c             	mov    0xc(%ebp),%eax
8010655a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010655e:	8b 45 08             	mov    0x8(%ebp),%eax
80106561:	89 04 24             	mov    %eax,(%esp)
80106564:	e8 55 ff ff ff       	call   801064be <name_for_inode>
80106569:	89 45 f0             	mov    %eax,-0x10(%ebp)
        safestrcpy(buf + path_offset, node_name, n - path_offset);
8010656c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010656f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106572:	29 c2                	sub    %eax,%edx
80106574:	89 d0                	mov    %edx,%eax
80106576:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106579:	8b 55 08             	mov    0x8(%ebp),%edx
8010657c:	01 ca                	add    %ecx,%edx
8010657e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106582:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106585:	89 44 24 04          	mov    %eax,0x4(%esp)
80106589:	89 14 24             	mov    %edx,(%esp)
8010658c:	e8 c1 ee ff ff       	call   80105452 <safestrcpy>
        path_offset += strlen(node_name);
80106591:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106594:	89 04 24             	mov    %eax,(%esp)
80106597:	e8 fd ee ff ff       	call   80105499 <strlen>
8010659c:	01 45 f0             	add    %eax,-0x10(%ebp)
        if (path_offset == n - 1) {
8010659f:	8b 45 0c             	mov    0xc(%ebp),%eax
801065a2:	48                   	dec    %eax
801065a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801065a6:	75 10                	jne    801065b8 <name_for_inode+0xfa>
            buf[path_offset] = '\0';
801065a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065ab:	8b 45 08             	mov    0x8(%ebp),%eax
801065ae:	01 d0                	add    %edx,%eax
801065b0:	c6 00 00             	movb   $0x0,(%eax)
            return n;
801065b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801065b6:	eb 53                	jmp    8010660b <name_for_inode+0x14d>
        } else {
            buf[path_offset++] = '/';
801065b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065bb:	8d 50 01             	lea    0x1(%eax),%edx
801065be:	89 55 f0             	mov    %edx,-0x10(%ebp)
801065c1:	89 c2                	mov    %eax,%edx
801065c3:	8b 45 08             	mov    0x8(%ebp),%eax
801065c6:	01 d0                	add    %edx,%eax
801065c8:	c6 00 2f             	movb   $0x2f,(%eax)
        }
        iput(parent); //free
801065cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ce:	89 04 24             	mov    %eax,(%esp)
801065d1:	e8 5a b7 ff ff       	call   80101d30 <iput>
        return path_offset;
801065d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d9:	eb 30                	jmp    8010660b <name_for_inode+0x14d>
    } else if (ip->type == T_DEV || ip->type == T_FILE) {
801065db:	8b 45 10             	mov    0x10(%ebp),%eax
801065de:	8b 40 50             	mov    0x50(%eax),%eax
801065e1:	66 83 f8 03          	cmp    $0x3,%ax
801065e5:	74 0c                	je     801065f3 <name_for_inode+0x135>
801065e7:	8b 45 10             	mov    0x10(%ebp),%eax
801065ea:	8b 40 50             	mov    0x50(%eax),%eax
801065ed:	66 83 f8 02          	cmp    $0x2,%ax
801065f1:	75 0c                	jne    801065ff <name_for_inode+0x141>
        panic("process cwd is a device node / file, not a directory!");
801065f3:	c7 04 24 34 93 10 80 	movl   $0x80109334,(%esp)
801065fa:	e8 ae a0 ff ff       	call   801006ad <panic>
    } else {
        panic("unknown inode type");
801065ff:	c7 04 24 6a 93 10 80 	movl   $0x8010936a,(%esp)
80106606:	e8 a2 a0 ff ff       	call   801006ad <panic>
    }
}
8010660b:	83 c4 34             	add    $0x34,%esp
8010660e:	5b                   	pop    %ebx
8010660f:	5d                   	pop    %ebp
80106610:	c3                   	ret    

80106611 <sys_getcwd>:

int
sys_getcwd(void)
{
80106611:	55                   	push   %ebp
80106612:	89 e5                	mov    %esp,%ebp
80106614:	83 ec 28             	sub    $0x28,%esp
    char *p;
    int n;
    if(argint(1, &n) < 0 || argptr(0, &p, n) < 0)
80106617:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010661a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010661e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106625:	e8 4f ef ff ff       	call   80105579 <argint>
8010662a:	85 c0                	test   %eax,%eax
8010662c:	78 1e                	js     8010664c <sys_getcwd+0x3b>
8010662e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106631:	89 44 24 08          	mov    %eax,0x8(%esp)
80106635:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106643:	e8 5e ef ff ff       	call   801055a6 <argptr>
80106648:	85 c0                	test   %eax,%eax
8010664a:	79 07                	jns    80106653 <sys_getcwd+0x42>
        return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106651:	eb 1e                	jmp    80106671 <sys_getcwd+0x60>
    return name_for_inode(p, n, myproc()->cwd);
80106653:	e8 7b dd ff ff       	call   801043d3 <myproc>
80106658:	8b 48 68             	mov    0x68(%eax),%ecx
8010665b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010665e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106661:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106665:	89 54 24 04          	mov    %edx,0x4(%esp)
80106669:	89 04 24             	mov    %eax,(%esp)
8010666c:	e8 4d fe ff ff       	call   801064be <name_for_inode>
}
80106671:	c9                   	leave  
80106672:	c3                   	ret    
	...

80106674 <sys_fork>:
#include "container.h"


int
sys_fork(void)
{
80106674:	55                   	push   %ebp
80106675:	89 e5                	mov    %esp,%ebp
80106677:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010667a:	e8 50 e0 ff ff       	call   801046cf <fork>
}
8010667f:	c9                   	leave  
80106680:	c3                   	ret    

80106681 <sys_exit>:

int
sys_exit(void)
{
80106681:	55                   	push   %ebp
80106682:	89 e5                	mov    %esp,%ebp
80106684:	83 ec 08             	sub    $0x8,%esp
  exit();
80106687:	e8 a9 e1 ff ff       	call   80104835 <exit>
  return 0;  // not reached
8010668c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106691:	c9                   	leave  
80106692:	c3                   	ret    

80106693 <sys_wait>:

int
sys_wait(void)
{
80106693:	55                   	push   %ebp
80106694:	89 e5                	mov    %esp,%ebp
80106696:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106699:	e8 a0 e2 ff ff       	call   8010493e <wait>
}
8010669e:	c9                   	leave  
8010669f:	c3                   	ret    

801066a0 <sys_kill>:

int
sys_kill(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801066a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801066ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066b4:	e8 c0 ee ff ff       	call   80105579 <argint>
801066b9:	85 c0                	test   %eax,%eax
801066bb:	79 07                	jns    801066c4 <sys_kill+0x24>
    return -1;
801066bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c2:	eb 0b                	jmp    801066cf <sys_kill+0x2f>
  return kill(pid);
801066c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c7:	89 04 24             	mov    %eax,(%esp)
801066ca:	e8 44 e6 ff ff       	call   80104d13 <kill>
}
801066cf:	c9                   	leave  
801066d0:	c3                   	ret    

801066d1 <sys_getpid>:

int
sys_getpid(void)
{
801066d1:	55                   	push   %ebp
801066d2:	89 e5                	mov    %esp,%ebp
801066d4:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801066d7:	e8 f7 dc ff ff       	call   801043d3 <myproc>
801066dc:	8b 40 10             	mov    0x10(%eax),%eax
}
801066df:	c9                   	leave  
801066e0:	c3                   	ret    

801066e1 <sys_sbrk>:

int
sys_sbrk(void)
{
801066e1:	55                   	push   %ebp
801066e2:	89 e5                	mov    %esp,%ebp
801066e4:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801066ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066f5:	e8 7f ee ff ff       	call   80105579 <argint>
801066fa:	85 c0                	test   %eax,%eax
801066fc:	79 07                	jns    80106705 <sys_sbrk+0x24>
    return -1;
801066fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106703:	eb 23                	jmp    80106728 <sys_sbrk+0x47>
  addr = myproc()->sz;
80106705:	e8 c9 dc ff ff       	call   801043d3 <myproc>
8010670a:	8b 00                	mov    (%eax),%eax
8010670c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010670f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106712:	89 04 24             	mov    %eax,(%esp)
80106715:	e8 17 df ff ff       	call   80104631 <growproc>
8010671a:	85 c0                	test   %eax,%eax
8010671c:	79 07                	jns    80106725 <sys_sbrk+0x44>
    return -1;
8010671e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106723:	eb 03                	jmp    80106728 <sys_sbrk+0x47>
  return addr;
80106725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106728:	c9                   	leave  
80106729:	c3                   	ret    

8010672a <sys_sleep>:

int
sys_sleep(void)
{
8010672a:	55                   	push   %ebp
8010672b:	89 e5                	mov    %esp,%ebp
8010672d:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106730:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106733:	89 44 24 04          	mov    %eax,0x4(%esp)
80106737:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010673e:	e8 36 ee ff ff       	call   80105579 <argint>
80106743:	85 c0                	test   %eax,%eax
80106745:	79 07                	jns    8010674e <sys_sleep+0x24>
    return -1;
80106747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674c:	eb 6b                	jmp    801067b9 <sys_sleep+0x8f>
  acquire(&tickslock);
8010674e:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106755:	e8 89 e8 ff ff       	call   80104fe3 <acquire>
  ticks0 = ticks;
8010675a:	a1 c0 79 11 80       	mov    0x801179c0,%eax
8010675f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106762:	eb 33                	jmp    80106797 <sys_sleep+0x6d>
    if(myproc()->killed){
80106764:	e8 6a dc ff ff       	call   801043d3 <myproc>
80106769:	8b 40 24             	mov    0x24(%eax),%eax
8010676c:	85 c0                	test   %eax,%eax
8010676e:	74 13                	je     80106783 <sys_sleep+0x59>
      release(&tickslock);
80106770:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106777:	e8 d1 e8 ff ff       	call   8010504d <release>
      return -1;
8010677c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106781:	eb 36                	jmp    801067b9 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
80106783:	c7 44 24 04 80 71 11 	movl   $0x80117180,0x4(%esp)
8010678a:	80 
8010678b:	c7 04 24 c0 79 11 80 	movl   $0x801179c0,(%esp)
80106792:	e8 7d e4 ff ff       	call   80104c14 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106797:	a1 c0 79 11 80       	mov    0x801179c0,%eax
8010679c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010679f:	89 c2                	mov    %eax,%edx
801067a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067a4:	39 c2                	cmp    %eax,%edx
801067a6:	72 bc                	jb     80106764 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801067a8:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
801067af:	e8 99 e8 ff ff       	call   8010504d <release>
  return 0;
801067b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067b9:	c9                   	leave  
801067ba:	c3                   	ret    

801067bb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801067bb:	55                   	push   %ebp
801067bc:	89 e5                	mov    %esp,%ebp
801067be:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
801067c1:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
801067c8:	e8 16 e8 ff ff       	call   80104fe3 <acquire>
  xticks = ticks;
801067cd:	a1 c0 79 11 80       	mov    0x801179c0,%eax
801067d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801067d5:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
801067dc:	e8 6c e8 ff ff       	call   8010504d <release>
  return xticks;
801067e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067e4:	c9                   	leave  
801067e5:	c3                   	ret    

801067e6 <sys_getname>:

int
sys_getname(void)
{
801067e6:	55                   	push   %ebp
801067e7:	89 e5                	mov    %esp,%ebp
801067e9:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801067ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067fa:	e8 7a ed ff ff       	call   80105579 <argint>
801067ff:	85 c0                	test   %eax,%eax
80106801:	78 17                	js     8010681a <sys_getname+0x34>
80106803:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106806:	89 44 24 04          	mov    %eax,0x4(%esp)
8010680a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106811:	e8 fa ed ff ff       	call   80105610 <argstr>
80106816:	85 c0                	test   %eax,%eax
80106818:	79 07                	jns    80106821 <sys_getname+0x3b>
    return -1;
8010681a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681f:	eb 12                	jmp    80106833 <sys_getname+0x4d>
  }

  return getname(index, name);
80106821:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106827:	89 54 24 04          	mov    %edx,0x4(%esp)
8010682b:	89 04 24             	mov    %eax,(%esp)
8010682e:	e8 fd 21 00 00       	call   80108a30 <getname>
}
80106833:	c9                   	leave  
80106834:	c3                   	ret    

80106835 <sys_setname>:

int
sys_setname(void)
{
80106835:	55                   	push   %ebp
80106836:	89 e5                	mov    %esp,%ebp
80106838:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
8010683b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106842:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106849:	e8 2b ed ff ff       	call   80105579 <argint>
8010684e:	85 c0                	test   %eax,%eax
80106850:	78 17                	js     80106869 <sys_setname+0x34>
80106852:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106855:	89 44 24 04          	mov    %eax,0x4(%esp)
80106859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106860:	e8 ab ed ff ff       	call   80105610 <argstr>
80106865:	85 c0                	test   %eax,%eax
80106867:	79 07                	jns    80106870 <sys_setname+0x3b>
    return -1;
80106869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010686e:	eb 12                	jmp    80106882 <sys_setname+0x4d>
  }

  return setname(index, name);
80106870:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106876:	89 54 24 04          	mov    %edx,0x4(%esp)
8010687a:	89 04 24             	mov    %eax,(%esp)
8010687d:	e8 00 22 00 00       	call   80108a82 <setname>
}
80106882:	c9                   	leave  
80106883:	c3                   	ret    

80106884 <sys_getmaxproc>:

int
sys_getmaxproc(void)
{
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010688a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010688d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106898:	e8 dc ec ff ff       	call   80105579 <argint>
8010689d:	85 c0                	test   %eax,%eax
8010689f:	79 07                	jns    801068a8 <sys_getmaxproc+0x24>
    return -1;
801068a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068a6:	eb 0b                	jmp    801068b3 <sys_getmaxproc+0x2f>
  }

  return getmaxproc(index);
801068a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ab:	89 04 24             	mov    %eax,(%esp)
801068ae:	e8 3d 22 00 00       	call   80108af0 <getmaxproc>
}
801068b3:	c9                   	leave  
801068b4:	c3                   	ret    

801068b5 <sys_setmaxproc>:

int
sys_setmaxproc(void)
{
801068b5:	55                   	push   %ebp
801068b6:	89 e5                	mov    %esp,%ebp
801068b8:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
801068bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068be:	89 44 24 04          	mov    %eax,0x4(%esp)
801068c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068c9:	e8 ab ec ff ff       	call   80105579 <argint>
801068ce:	85 c0                	test   %eax,%eax
801068d0:	78 17                	js     801068e9 <sys_setmaxproc+0x34>
801068d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801068d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801068e0:	e8 94 ec ff ff       	call   80105579 <argint>
801068e5:	85 c0                	test   %eax,%eax
801068e7:	74 07                	je     801068f0 <sys_setmaxproc+0x3b>
    return -1;
801068e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ee:	eb 12                	jmp    80106902 <sys_setmaxproc+0x4d>
  }

  return setmaxproc(index, max);
801068f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801068f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801068fa:	89 04 24             	mov    %eax,(%esp)
801068fd:	e8 10 22 00 00       	call   80108b12 <setmaxproc>
}
80106902:	c9                   	leave  
80106903:	c3                   	ret    

80106904 <sys_getmaxmem>:

int
sys_getmaxmem(void)
{
80106904:	55                   	push   %ebp
80106905:	89 e5                	mov    %esp,%ebp
80106907:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010690a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010690d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106911:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106918:	e8 5c ec ff ff       	call   80105579 <argint>
8010691d:	85 c0                	test   %eax,%eax
8010691f:	79 07                	jns    80106928 <sys_getmaxmem+0x24>
    return -1;
80106921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106926:	eb 0b                	jmp    80106933 <sys_getmaxmem+0x2f>
  }

  return getmaxmem(index);
80106928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010692b:	89 04 24             	mov    %eax,(%esp)
8010692e:	e8 0a 22 00 00       	call   80108b3d <getmaxmem>
}
80106933:	c9                   	leave  
80106934:	c3                   	ret    

80106935 <sys_setmaxmem>:

int
sys_setmaxmem(void)
{
80106935:	55                   	push   %ebp
80106936:	89 e5                	mov    %esp,%ebp
80106938:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
8010693b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010693e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106949:	e8 2b ec ff ff       	call   80105579 <argint>
8010694e:	85 c0                	test   %eax,%eax
80106950:	78 17                	js     80106969 <sys_setmaxmem+0x34>
80106952:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106955:	89 44 24 04          	mov    %eax,0x4(%esp)
80106959:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106960:	e8 14 ec ff ff       	call   80105579 <argint>
80106965:	85 c0                	test   %eax,%eax
80106967:	74 07                	je     80106970 <sys_setmaxmem+0x3b>
    return -1;
80106969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696e:	eb 12                	jmp    80106982 <sys_setmaxmem+0x4d>
  }

  return setmaxmem(index, max);
80106970:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106976:	89 54 24 04          	mov    %edx,0x4(%esp)
8010697a:	89 04 24             	mov    %eax,(%esp)
8010697d:	e8 dd 21 00 00       	call   80108b5f <setmaxmem>
}
80106982:	c9                   	leave  
80106983:	c3                   	ret    

80106984 <sys_getmaxdisk>:

int
sys_getmaxdisk(void)
{
80106984:	55                   	push   %ebp
80106985:	89 e5                	mov    %esp,%ebp
80106987:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010698a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010698d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106991:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106998:	e8 dc eb ff ff       	call   80105579 <argint>
8010699d:	85 c0                	test   %eax,%eax
8010699f:	79 07                	jns    801069a8 <sys_getmaxdisk+0x24>
    return -1;
801069a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a6:	eb 0b                	jmp    801069b3 <sys_getmaxdisk+0x2f>
  }

  return getmaxdisk(index);
801069a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069ab:	89 04 24             	mov    %eax,(%esp)
801069ae:	e8 d7 21 00 00       	call   80108b8a <getmaxdisk>
}
801069b3:	c9                   	leave  
801069b4:	c3                   	ret    

801069b5 <sys_setmaxdisk>:

int
sys_setmaxdisk(void)
{
801069b5:	55                   	push   %ebp
801069b6:	89 e5                	mov    %esp,%ebp
801069b8:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
801069bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069be:	89 44 24 04          	mov    %eax,0x4(%esp)
801069c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069c9:	e8 ab eb ff ff       	call   80105579 <argint>
801069ce:	85 c0                	test   %eax,%eax
801069d0:	78 17                	js     801069e9 <sys_setmaxdisk+0x34>
801069d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801069d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801069e0:	e8 94 eb ff ff       	call   80105579 <argint>
801069e5:	85 c0                	test   %eax,%eax
801069e7:	74 07                	je     801069f0 <sys_setmaxdisk+0x3b>
    return -1;
801069e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ee:	eb 12                	jmp    80106a02 <sys_setmaxdisk+0x4d>
  }

  return setmaxdisk(index, max);
801069f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801069fa:	89 04 24             	mov    %eax,(%esp)
801069fd:	e8 a9 21 00 00       	call   80108bab <setmaxdisk>
}
80106a02:	c9                   	leave  
80106a03:	c3                   	ret    

80106a04 <sys_getusedmem>:

int
sys_getusedmem(void)
{
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a18:	e8 5c eb ff ff       	call   80105579 <argint>
80106a1d:	85 c0                	test   %eax,%eax
80106a1f:	79 07                	jns    80106a28 <sys_getusedmem+0x24>
    return -1;
80106a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a26:	eb 0b                	jmp    80106a33 <sys_getusedmem+0x2f>
  }

  return getusedmem(index);
80106a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a2b:	89 04 24             	mov    %eax,(%esp)
80106a2e:	e8 a2 21 00 00       	call   80108bd5 <getusedmem>
}
80106a33:	c9                   	leave  
80106a34:	c3                   	ret    

80106a35 <sys_setusedmem>:

int
sys_setusedmem(void)
{
80106a35:	55                   	push   %ebp
80106a36:	89 e5                	mov    %esp,%ebp
80106a38:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a49:	e8 2b eb ff ff       	call   80105579 <argint>
80106a4e:	85 c0                	test   %eax,%eax
80106a50:	78 17                	js     80106a69 <sys_setusedmem+0x34>
80106a52:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a55:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a60:	e8 14 eb ff ff       	call   80105579 <argint>
80106a65:	85 c0                	test   %eax,%eax
80106a67:	74 07                	je     80106a70 <sys_setusedmem+0x3b>
    return -1;
80106a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6e:	eb 12                	jmp    80106a82 <sys_setusedmem+0x4d>
  }

  return setusedmem(index, max);
80106a70:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a76:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a7a:	89 04 24             	mov    %eax,(%esp)
80106a7d:	e8 75 21 00 00       	call   80108bf7 <setusedmem>
}
80106a82:	c9                   	leave  
80106a83:	c3                   	ret    

80106a84 <sys_getuseddisk>:

int
sys_getuseddisk(void)
{
80106a84:	55                   	push   %ebp
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106a8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a98:	e8 dc ea ff ff       	call   80105579 <argint>
80106a9d:	85 c0                	test   %eax,%eax
80106a9f:	79 07                	jns    80106aa8 <sys_getuseddisk+0x24>
    return -1;
80106aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa6:	eb 0b                	jmp    80106ab3 <sys_getuseddisk+0x2f>
  }

  return getuseddisk(index);
80106aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aab:	89 04 24             	mov    %eax,(%esp)
80106aae:	e8 6f 21 00 00       	call   80108c22 <getuseddisk>
}
80106ab3:	c9                   	leave  
80106ab4:	c3                   	ret    

80106ab5 <sys_setuseddisk>:

int
sys_setuseddisk(void)
{
80106ab5:	55                   	push   %ebp
80106ab6:	89 e5                	mov    %esp,%ebp
80106ab8:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106abb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ac9:	e8 ab ea ff ff       	call   80105579 <argint>
80106ace:	85 c0                	test   %eax,%eax
80106ad0:	78 17                	js     80106ae9 <sys_setuseddisk+0x34>
80106ad2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ad9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ae0:	e8 94 ea ff ff       	call   80105579 <argint>
80106ae5:	85 c0                	test   %eax,%eax
80106ae7:	74 07                	je     80106af0 <sys_setuseddisk+0x3b>
    return -1;
80106ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aee:	eb 12                	jmp    80106b02 <sys_setuseddisk+0x4d>
  }

  return setuseddisk(index, max);
80106af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106afa:	89 04 24             	mov    %eax,(%esp)
80106afd:	e8 42 21 00 00       	call   80108c44 <setuseddisk>
}
80106b02:	c9                   	leave  
80106b03:	c3                   	ret    

80106b04 <sys_setvc>:


int
sys_setvc(void){
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *vc;

  if(argint(0, &index) < 0 || argstr(1, &vc) < 0){
80106b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b18:	e8 5c ea ff ff       	call   80105579 <argint>
80106b1d:	85 c0                	test   %eax,%eax
80106b1f:	78 17                	js     80106b38 <sys_setvc+0x34>
80106b21:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b24:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b2f:	e8 dc ea ff ff       	call   80105610 <argstr>
80106b34:	85 c0                	test   %eax,%eax
80106b36:	79 07                	jns    80106b3f <sys_setvc+0x3b>
    return -1;
80106b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3d:	eb 12                	jmp    80106b51 <sys_setvc+0x4d>
  }

  return setvc(index, vc);
80106b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b45:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b49:	89 04 24             	mov    %eax,(%esp)
80106b4c:	e8 1e 21 00 00       	call   80108c6f <setvc>
}
80106b51:	c9                   	leave  
80106b52:	c3                   	ret    

80106b53 <sys_setactivefs>:

int
sys_setactivefs(void){
80106b53:	55                   	push   %ebp
80106b54:	89 e5                	mov    %esp,%ebp
80106b56:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b67:	e8 a4 ea ff ff       	call   80105610 <argstr>
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	79 07                	jns    80106b77 <sys_setactivefs+0x24>
    return -1;
80106b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b75:	eb 0b                	jmp    80106b82 <sys_setactivefs+0x2f>
  }

  return setactivefs(fs);
80106b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b7a:	89 04 24             	mov    %eax,(%esp)
80106b7d:	e8 f0 21 00 00       	call   80108d72 <setactivefs>
}
80106b82:	c9                   	leave  
80106b83:	c3                   	ret    

80106b84 <sys_getactivefs>:

int
sys_getactivefs(void){
80106b84:	55                   	push   %ebp
80106b85:	89 e5                	mov    %esp,%ebp
80106b87:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106b8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b98:	e8 73 ea ff ff       	call   80105610 <argstr>
80106b9d:	85 c0                	test   %eax,%eax
80106b9f:	79 07                	jns    80106ba8 <sys_getactivefs+0x24>
    return -1;
80106ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba6:	eb 0b                	jmp    80106bb3 <sys_getactivefs+0x2f>
  }

  return getactivefs(fs);
80106ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bab:	89 04 24             	mov    %eax,(%esp)
80106bae:	e8 f8 21 00 00       	call   80108dab <getactivefs>
}
80106bb3:	c9                   	leave  
80106bb4:	c3                   	ret    

80106bb5 <sys_getvcfs>:


int
sys_getvcfs(void){
80106bb5:	55                   	push   %ebp
80106bb6:	89 e5                	mov    %esp,%ebp
80106bb8:	83 ec 28             	sub    $0x28,%esp
  char *vc;
  char *fs;

  if(argstr(0, &vc) < 0 || argstr(1, &fs) < 0){
80106bbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bc9:	e8 42 ea ff ff       	call   80105610 <argstr>
80106bce:	85 c0                	test   %eax,%eax
80106bd0:	78 17                	js     80106be9 <sys_getvcfs+0x34>
80106bd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106be0:	e8 2b ea ff ff       	call   80105610 <argstr>
80106be5:	85 c0                	test   %eax,%eax
80106be7:	79 07                	jns    80106bf0 <sys_getvcfs+0x3b>
    return -1;
80106be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bee:	eb 12                	jmp    80106c02 <sys_getvcfs+0x4d>
  }

  return getvcfs(vc, fs);
80106bf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bfa:	89 04 24             	mov    %eax,(%esp)
80106bfd:	e8 db 20 00 00       	call   80108cdd <getvcfs>
}
80106c02:	c9                   	leave  
80106c03:	c3                   	ret    

80106c04 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c04:	1e                   	push   %ds
  pushl %es
80106c05:	06                   	push   %es
  pushl %fs
80106c06:	0f a0                	push   %fs
  pushl %gs
80106c08:	0f a8                	push   %gs
  pushal
80106c0a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c0b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c0f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c11:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c13:	54                   	push   %esp
  call trap
80106c14:	e8 c0 01 00 00       	call   80106dd9 <trap>
  addl $4, %esp
80106c19:	83 c4 04             	add    $0x4,%esp

80106c1c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c1c:	61                   	popa   
  popl %gs
80106c1d:	0f a9                	pop    %gs
  popl %fs
80106c1f:	0f a1                	pop    %fs
  popl %es
80106c21:	07                   	pop    %es
  popl %ds
80106c22:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c23:	83 c4 08             	add    $0x8,%esp
  iret
80106c26:	cf                   	iret   
	...

80106c28 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106c28:	55                   	push   %ebp
80106c29:	89 e5                	mov    %esp,%ebp
80106c2b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c31:	48                   	dec    %eax
80106c32:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c36:	8b 45 08             	mov    0x8(%ebp),%eax
80106c39:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c3d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c40:	c1 e8 10             	shr    $0x10,%eax
80106c43:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106c47:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c4a:	0f 01 18             	lidtl  (%eax)
}
80106c4d:	c9                   	leave  
80106c4e:	c3                   	ret    

80106c4f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106c4f:	55                   	push   %ebp
80106c50:	89 e5                	mov    %esp,%ebp
80106c52:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c55:	0f 20 d0             	mov    %cr2,%eax
80106c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106c5e:	c9                   	leave  
80106c5f:	c3                   	ret    

80106c60 <tvinit>:

uint ticks;

void
tvinit(void)
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c6d:	e9 b8 00 00 00       	jmp    80106d2a <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c75:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
80106c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c7f:	66 89 04 d5 c0 71 11 	mov    %ax,-0x7fee8e40(,%edx,8)
80106c86:	80 
80106c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c8a:	66 c7 04 c5 c2 71 11 	movw   $0x8,-0x7fee8e3e(,%eax,8)
80106c91:	80 08 00 
80106c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c97:	8a 14 c5 c4 71 11 80 	mov    -0x7fee8e3c(,%eax,8),%dl
80106c9e:	83 e2 e0             	and    $0xffffffe0,%edx
80106ca1:	88 14 c5 c4 71 11 80 	mov    %dl,-0x7fee8e3c(,%eax,8)
80106ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cab:	8a 14 c5 c4 71 11 80 	mov    -0x7fee8e3c(,%eax,8),%dl
80106cb2:	83 e2 1f             	and    $0x1f,%edx
80106cb5:	88 14 c5 c4 71 11 80 	mov    %dl,-0x7fee8e3c(,%eax,8)
80106cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cbf:	8a 14 c5 c5 71 11 80 	mov    -0x7fee8e3b(,%eax,8),%dl
80106cc6:	83 e2 f0             	and    $0xfffffff0,%edx
80106cc9:	83 ca 0e             	or     $0xe,%edx
80106ccc:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd6:	8a 14 c5 c5 71 11 80 	mov    -0x7fee8e3b(,%eax,8),%dl
80106cdd:	83 e2 ef             	and    $0xffffffef,%edx
80106ce0:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cea:	8a 14 c5 c5 71 11 80 	mov    -0x7fee8e3b(,%eax,8),%dl
80106cf1:	83 e2 9f             	and    $0xffffff9f,%edx
80106cf4:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfe:	8a 14 c5 c5 71 11 80 	mov    -0x7fee8e3b(,%eax,8),%dl
80106d05:	83 ca 80             	or     $0xffffff80,%edx
80106d08:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d12:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
80106d19:	c1 e8 10             	shr    $0x10,%eax
80106d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d1f:	66 89 04 d5 c6 71 11 	mov    %ax,-0x7fee8e3a(,%edx,8)
80106d26:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106d27:	ff 45 f4             	incl   -0xc(%ebp)
80106d2a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106d31:	0f 8e 3b ff ff ff    	jle    80106c72 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d37:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
80106d3c:	66 a3 c0 73 11 80    	mov    %ax,0x801173c0
80106d42:	66 c7 05 c2 73 11 80 	movw   $0x8,0x801173c2
80106d49:	08 00 
80106d4b:	a0 c4 73 11 80       	mov    0x801173c4,%al
80106d50:	83 e0 e0             	and    $0xffffffe0,%eax
80106d53:	a2 c4 73 11 80       	mov    %al,0x801173c4
80106d58:	a0 c4 73 11 80       	mov    0x801173c4,%al
80106d5d:	83 e0 1f             	and    $0x1f,%eax
80106d60:	a2 c4 73 11 80       	mov    %al,0x801173c4
80106d65:	a0 c5 73 11 80       	mov    0x801173c5,%al
80106d6a:	83 c8 0f             	or     $0xf,%eax
80106d6d:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106d72:	a0 c5 73 11 80       	mov    0x801173c5,%al
80106d77:	83 e0 ef             	and    $0xffffffef,%eax
80106d7a:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106d7f:	a0 c5 73 11 80       	mov    0x801173c5,%al
80106d84:	83 c8 60             	or     $0x60,%eax
80106d87:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106d8c:	a0 c5 73 11 80       	mov    0x801173c5,%al
80106d91:	83 c8 80             	or     $0xffffff80,%eax
80106d94:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106d99:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
80106d9e:	c1 e8 10             	shr    $0x10,%eax
80106da1:	66 a3 c6 73 11 80    	mov    %ax,0x801173c6

  initlock(&tickslock, "time");
80106da7:	c7 44 24 04 80 93 10 	movl   $0x80109380,0x4(%esp)
80106dae:	80 
80106daf:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106db6:	e8 07 e2 ff ff       	call   80104fc2 <initlock>
}
80106dbb:	c9                   	leave  
80106dbc:	c3                   	ret    

80106dbd <idtinit>:

void
idtinit(void)
{
80106dbd:	55                   	push   %ebp
80106dbe:	89 e5                	mov    %esp,%ebp
80106dc0:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106dc3:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106dca:	00 
80106dcb:	c7 04 24 c0 71 11 80 	movl   $0x801171c0,(%esp)
80106dd2:	e8 51 fe ff ff       	call   80106c28 <lidt>
}
80106dd7:	c9                   	leave  
80106dd8:	c3                   	ret    

80106dd9 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106dd9:	55                   	push   %ebp
80106dda:	89 e5                	mov    %esp,%ebp
80106ddc:	57                   	push   %edi
80106ddd:	56                   	push   %esi
80106dde:	53                   	push   %ebx
80106ddf:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106de2:	8b 45 08             	mov    0x8(%ebp),%eax
80106de5:	8b 40 30             	mov    0x30(%eax),%eax
80106de8:	83 f8 40             	cmp    $0x40,%eax
80106deb:	75 3c                	jne    80106e29 <trap+0x50>
    if(myproc()->killed)
80106ded:	e8 e1 d5 ff ff       	call   801043d3 <myproc>
80106df2:	8b 40 24             	mov    0x24(%eax),%eax
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 05                	je     80106dfe <trap+0x25>
      exit();
80106df9:	e8 37 da ff ff       	call   80104835 <exit>
    myproc()->tf = tf;
80106dfe:	e8 d0 d5 ff ff       	call   801043d3 <myproc>
80106e03:	8b 55 08             	mov    0x8(%ebp),%edx
80106e06:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106e09:	e8 39 e8 ff ff       	call   80105647 <syscall>
    if(myproc()->killed)
80106e0e:	e8 c0 d5 ff ff       	call   801043d3 <myproc>
80106e13:	8b 40 24             	mov    0x24(%eax),%eax
80106e16:	85 c0                	test   %eax,%eax
80106e18:	74 0a                	je     80106e24 <trap+0x4b>
      exit();
80106e1a:	e8 16 da ff ff       	call   80104835 <exit>
    return;
80106e1f:	e9 13 02 00 00       	jmp    80107037 <trap+0x25e>
80106e24:	e9 0e 02 00 00       	jmp    80107037 <trap+0x25e>
  }

  switch(tf->trapno){
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2c:	8b 40 30             	mov    0x30(%eax),%eax
80106e2f:	83 e8 20             	sub    $0x20,%eax
80106e32:	83 f8 1f             	cmp    $0x1f,%eax
80106e35:	0f 87 ae 00 00 00    	ja     80106ee9 <trap+0x110>
80106e3b:	8b 04 85 28 94 10 80 	mov    -0x7fef6bd8(,%eax,4),%eax
80106e42:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106e44:	e8 c1 d4 ff ff       	call   8010430a <cpuid>
80106e49:	85 c0                	test   %eax,%eax
80106e4b:	75 2f                	jne    80106e7c <trap+0xa3>
      acquire(&tickslock);
80106e4d:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106e54:	e8 8a e1 ff ff       	call   80104fe3 <acquire>
      ticks++;
80106e59:	a1 c0 79 11 80       	mov    0x801179c0,%eax
80106e5e:	40                   	inc    %eax
80106e5f:	a3 c0 79 11 80       	mov    %eax,0x801179c0
      // myproc()->ticks++;
      wakeup(&ticks);
80106e64:	c7 04 24 c0 79 11 80 	movl   $0x801179c0,(%esp)
80106e6b:	e8 78 de ff ff       	call   80104ce8 <wakeup>
      release(&tickslock);
80106e70:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106e77:	e8 d1 e1 ff ff       	call   8010504d <release>
    }
    lapiceoi();
80106e7c:	e8 32 c3 ff ff       	call   801031b3 <lapiceoi>
    break;
80106e81:	e9 35 01 00 00       	jmp    80106fbb <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106e86:	e8 a7 bb ff ff       	call   80102a32 <ideintr>
    lapiceoi();
80106e8b:	e8 23 c3 ff ff       	call   801031b3 <lapiceoi>
    break;
80106e90:	e9 26 01 00 00       	jmp    80106fbb <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106e95:	e8 30 c1 ff ff       	call   80102fca <kbdintr>
    lapiceoi();
80106e9a:	e8 14 c3 ff ff       	call   801031b3 <lapiceoi>
    break;
80106e9f:	e9 17 01 00 00       	jmp    80106fbb <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106ea4:	e8 70 03 00 00       	call   80107219 <uartintr>
    lapiceoi();
80106ea9:	e8 05 c3 ff ff       	call   801031b3 <lapiceoi>
    break;
80106eae:	e9 08 01 00 00       	jmp    80106fbb <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb6:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebc:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ebf:	0f b7 d8             	movzwl %ax,%ebx
80106ec2:	e8 43 d4 ff ff       	call   8010430a <cpuid>
80106ec7:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ed3:	c7 04 24 88 93 10 80 	movl   $0x80109388,(%esp)
80106eda:	e8 3b 96 ff ff       	call   8010051a <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106edf:	e8 cf c2 ff ff       	call   801031b3 <lapiceoi>
    break;
80106ee4:	e9 d2 00 00 00       	jmp    80106fbb <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106ee9:	e8 e5 d4 ff ff       	call   801043d3 <myproc>
80106eee:	85 c0                	test   %eax,%eax
80106ef0:	74 10                	je     80106f02 <trap+0x129>
80106ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef5:	8b 40 3c             	mov    0x3c(%eax),%eax
80106ef8:	0f b7 c0             	movzwl %ax,%eax
80106efb:	83 e0 03             	and    $0x3,%eax
80106efe:	85 c0                	test   %eax,%eax
80106f00:	75 40                	jne    80106f42 <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f02:	e8 48 fd ff ff       	call   80106c4f <rcr2>
80106f07:	89 c3                	mov    %eax,%ebx
80106f09:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0c:	8b 70 38             	mov    0x38(%eax),%esi
80106f0f:	e8 f6 d3 ff ff       	call   8010430a <cpuid>
80106f14:	8b 55 08             	mov    0x8(%ebp),%edx
80106f17:	8b 52 30             	mov    0x30(%edx),%edx
80106f1a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106f1e:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106f22:	89 44 24 08          	mov    %eax,0x8(%esp)
80106f26:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f2a:	c7 04 24 ac 93 10 80 	movl   $0x801093ac,(%esp)
80106f31:	e8 e4 95 ff ff       	call   8010051a <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106f36:	c7 04 24 de 93 10 80 	movl   $0x801093de,(%esp)
80106f3d:	e8 6b 97 ff ff       	call   801006ad <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f42:	e8 08 fd ff ff       	call   80106c4f <rcr2>
80106f47:	89 c6                	mov    %eax,%esi
80106f49:	8b 45 08             	mov    0x8(%ebp),%eax
80106f4c:	8b 40 38             	mov    0x38(%eax),%eax
80106f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f52:	e8 b3 d3 ff ff       	call   8010430a <cpuid>
80106f57:	89 c3                	mov    %eax,%ebx
80106f59:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5c:	8b 78 34             	mov    0x34(%eax),%edi
80106f5f:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106f62:	8b 45 08             	mov    0x8(%ebp),%eax
80106f65:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106f68:	e8 66 d4 ff ff       	call   801043d3 <myproc>
80106f6d:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f70:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106f73:	e8 5b d4 ff ff       	call   801043d3 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f78:	8b 40 10             	mov    0x10(%eax),%eax
80106f7b:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106f7f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f82:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106f86:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106f8a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106f8d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80106f91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106f95:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106f98:	89 54 24 08          	mov    %edx,0x8(%esp)
80106f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fa0:	c7 04 24 e4 93 10 80 	movl   $0x801093e4,(%esp)
80106fa7:	e8 6e 95 ff ff       	call   8010051a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106fac:	e8 22 d4 ff ff       	call   801043d3 <myproc>
80106fb1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106fb8:	eb 01                	jmp    80106fbb <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106fba:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fbb:	e8 13 d4 ff ff       	call   801043d3 <myproc>
80106fc0:	85 c0                	test   %eax,%eax
80106fc2:	74 22                	je     80106fe6 <trap+0x20d>
80106fc4:	e8 0a d4 ff ff       	call   801043d3 <myproc>
80106fc9:	8b 40 24             	mov    0x24(%eax),%eax
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	74 16                	je     80106fe6 <trap+0x20d>
80106fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd3:	8b 40 3c             	mov    0x3c(%eax),%eax
80106fd6:	0f b7 c0             	movzwl %ax,%eax
80106fd9:	83 e0 03             	and    $0x3,%eax
80106fdc:	83 f8 03             	cmp    $0x3,%eax
80106fdf:	75 05                	jne    80106fe6 <trap+0x20d>
    exit();
80106fe1:	e8 4f d8 ff ff       	call   80104835 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106fe6:	e8 e8 d3 ff ff       	call   801043d3 <myproc>
80106feb:	85 c0                	test   %eax,%eax
80106fed:	74 1d                	je     8010700c <trap+0x233>
80106fef:	e8 df d3 ff ff       	call   801043d3 <myproc>
80106ff4:	8b 40 0c             	mov    0xc(%eax),%eax
80106ff7:	83 f8 04             	cmp    $0x4,%eax
80106ffa:	75 10                	jne    8010700c <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fff:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107002:	83 f8 20             	cmp    $0x20,%eax
80107005:	75 05                	jne    8010700c <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80107007:	e8 98 db ff ff       	call   80104ba4 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010700c:	e8 c2 d3 ff ff       	call   801043d3 <myproc>
80107011:	85 c0                	test   %eax,%eax
80107013:	74 22                	je     80107037 <trap+0x25e>
80107015:	e8 b9 d3 ff ff       	call   801043d3 <myproc>
8010701a:	8b 40 24             	mov    0x24(%eax),%eax
8010701d:	85 c0                	test   %eax,%eax
8010701f:	74 16                	je     80107037 <trap+0x25e>
80107021:	8b 45 08             	mov    0x8(%ebp),%eax
80107024:	8b 40 3c             	mov    0x3c(%eax),%eax
80107027:	0f b7 c0             	movzwl %ax,%eax
8010702a:	83 e0 03             	and    $0x3,%eax
8010702d:	83 f8 03             	cmp    $0x3,%eax
80107030:	75 05                	jne    80107037 <trap+0x25e>
    exit();
80107032:	e8 fe d7 ff ff       	call   80104835 <exit>
}
80107037:	83 c4 3c             	add    $0x3c,%esp
8010703a:	5b                   	pop    %ebx
8010703b:	5e                   	pop    %esi
8010703c:	5f                   	pop    %edi
8010703d:	5d                   	pop    %ebp
8010703e:	c3                   	ret    
	...

80107040 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 14             	sub    $0x14,%esp
80107046:	8b 45 08             	mov    0x8(%ebp),%eax
80107049:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010704d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107050:	89 c2                	mov    %eax,%edx
80107052:	ec                   	in     (%dx),%al
80107053:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107056:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80107059:	c9                   	leave  
8010705a:	c3                   	ret    

8010705b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010705b:	55                   	push   %ebp
8010705c:	89 e5                	mov    %esp,%ebp
8010705e:	83 ec 08             	sub    $0x8,%esp
80107061:	8b 45 08             	mov    0x8(%ebp),%eax
80107064:	8b 55 0c             	mov    0xc(%ebp),%edx
80107067:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010706b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010706e:	8a 45 f8             	mov    -0x8(%ebp),%al
80107071:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107074:	ee                   	out    %al,(%dx)
}
80107075:	c9                   	leave  
80107076:	c3                   	ret    

80107077 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107077:	55                   	push   %ebp
80107078:	89 e5                	mov    %esp,%ebp
8010707a:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010707d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107084:	00 
80107085:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010708c:	e8 ca ff ff ff       	call   8010705b <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107091:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107098:	00 
80107099:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801070a0:	e8 b6 ff ff ff       	call   8010705b <outb>
  outb(COM1+0, 115200/9600);
801070a5:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801070ac:	00 
801070ad:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070b4:	e8 a2 ff ff ff       	call   8010705b <outb>
  outb(COM1+1, 0);
801070b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070c0:	00 
801070c1:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801070c8:	e8 8e ff ff ff       	call   8010705b <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801070cd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801070d4:	00 
801070d5:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801070dc:	e8 7a ff ff ff       	call   8010705b <outb>
  outb(COM1+4, 0);
801070e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070e8:	00 
801070e9:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801070f0:	e8 66 ff ff ff       	call   8010705b <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801070f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801070fc:	00 
801070fd:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107104:	e8 52 ff ff ff       	call   8010705b <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107109:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107110:	e8 2b ff ff ff       	call   80107040 <inb>
80107115:	3c ff                	cmp    $0xff,%al
80107117:	75 02                	jne    8010711b <uartinit+0xa4>
    return;
80107119:	eb 5b                	jmp    80107176 <uartinit+0xff>
  uart = 1;
8010711b:	c7 05 64 c6 10 80 01 	movl   $0x1,0x8010c664
80107122:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107125:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010712c:	e8 0f ff ff ff       	call   80107040 <inb>
  inb(COM1+0);
80107131:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107138:	e8 03 ff ff ff       	call   80107040 <inb>
  ioapicenable(IRQ_COM1, 0);
8010713d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107144:	00 
80107145:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010714c:	e8 56 bb ff ff       	call   80102ca7 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107151:	c7 45 f4 a8 94 10 80 	movl   $0x801094a8,-0xc(%ebp)
80107158:	eb 13                	jmp    8010716d <uartinit+0xf6>
    uartputc(*p);
8010715a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010715d:	8a 00                	mov    (%eax),%al
8010715f:	0f be c0             	movsbl %al,%eax
80107162:	89 04 24             	mov    %eax,(%esp)
80107165:	e8 0e 00 00 00       	call   80107178 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010716a:	ff 45 f4             	incl   -0xc(%ebp)
8010716d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107170:	8a 00                	mov    (%eax),%al
80107172:	84 c0                	test   %al,%al
80107174:	75 e4                	jne    8010715a <uartinit+0xe3>
    uartputc(*p);
}
80107176:	c9                   	leave  
80107177:	c3                   	ret    

80107178 <uartputc>:

void
uartputc(int c)
{
80107178:	55                   	push   %ebp
80107179:	89 e5                	mov    %esp,%ebp
8010717b:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010717e:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80107183:	85 c0                	test   %eax,%eax
80107185:	75 02                	jne    80107189 <uartputc+0x11>
    return;
80107187:	eb 4a                	jmp    801071d3 <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107190:	eb 0f                	jmp    801071a1 <uartputc+0x29>
    microdelay(10);
80107192:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107199:	e8 3a c0 ff ff       	call   801031d8 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010719e:	ff 45 f4             	incl   -0xc(%ebp)
801071a1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801071a5:	7f 16                	jg     801071bd <uartputc+0x45>
801071a7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801071ae:	e8 8d fe ff ff       	call   80107040 <inb>
801071b3:	0f b6 c0             	movzbl %al,%eax
801071b6:	83 e0 20             	and    $0x20,%eax
801071b9:	85 c0                	test   %eax,%eax
801071bb:	74 d5                	je     80107192 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801071bd:	8b 45 08             	mov    0x8(%ebp),%eax
801071c0:	0f b6 c0             	movzbl %al,%eax
801071c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801071c7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801071ce:	e8 88 fe ff ff       	call   8010705b <outb>
}
801071d3:	c9                   	leave  
801071d4:	c3                   	ret    

801071d5 <uartgetc>:

static int
uartgetc(void)
{
801071d5:	55                   	push   %ebp
801071d6:	89 e5                	mov    %esp,%ebp
801071d8:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801071db:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801071e0:	85 c0                	test   %eax,%eax
801071e2:	75 07                	jne    801071eb <uartgetc+0x16>
    return -1;
801071e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e9:	eb 2c                	jmp    80107217 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801071eb:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801071f2:	e8 49 fe ff ff       	call   80107040 <inb>
801071f7:	0f b6 c0             	movzbl %al,%eax
801071fa:	83 e0 01             	and    $0x1,%eax
801071fd:	85 c0                	test   %eax,%eax
801071ff:	75 07                	jne    80107208 <uartgetc+0x33>
    return -1;
80107201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107206:	eb 0f                	jmp    80107217 <uartgetc+0x42>
  return inb(COM1+0);
80107208:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010720f:	e8 2c fe ff ff       	call   80107040 <inb>
80107214:	0f b6 c0             	movzbl %al,%eax
}
80107217:	c9                   	leave  
80107218:	c3                   	ret    

80107219 <uartintr>:

void
uartintr(void)
{
80107219:	55                   	push   %ebp
8010721a:	89 e5                	mov    %esp,%ebp
8010721c:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010721f:	c7 04 24 d5 71 10 80 	movl   $0x801071d5,(%esp)
80107226:	e8 23 97 ff ff       	call   8010094e <consoleintr>
}
8010722b:	c9                   	leave  
8010722c:	c3                   	ret    
8010722d:	00 00                	add    %al,(%eax)
	...

80107230 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $0
80107232:	6a 00                	push   $0x0
  jmp alltraps
80107234:	e9 cb f9 ff ff       	jmp    80106c04 <alltraps>

80107239 <vector1>:
.globl vector1
vector1:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $1
8010723b:	6a 01                	push   $0x1
  jmp alltraps
8010723d:	e9 c2 f9 ff ff       	jmp    80106c04 <alltraps>

80107242 <vector2>:
.globl vector2
vector2:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $2
80107244:	6a 02                	push   $0x2
  jmp alltraps
80107246:	e9 b9 f9 ff ff       	jmp    80106c04 <alltraps>

8010724b <vector3>:
.globl vector3
vector3:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $3
8010724d:	6a 03                	push   $0x3
  jmp alltraps
8010724f:	e9 b0 f9 ff ff       	jmp    80106c04 <alltraps>

80107254 <vector4>:
.globl vector4
vector4:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $4
80107256:	6a 04                	push   $0x4
  jmp alltraps
80107258:	e9 a7 f9 ff ff       	jmp    80106c04 <alltraps>

8010725d <vector5>:
.globl vector5
vector5:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $5
8010725f:	6a 05                	push   $0x5
  jmp alltraps
80107261:	e9 9e f9 ff ff       	jmp    80106c04 <alltraps>

80107266 <vector6>:
.globl vector6
vector6:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $6
80107268:	6a 06                	push   $0x6
  jmp alltraps
8010726a:	e9 95 f9 ff ff       	jmp    80106c04 <alltraps>

8010726f <vector7>:
.globl vector7
vector7:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $7
80107271:	6a 07                	push   $0x7
  jmp alltraps
80107273:	e9 8c f9 ff ff       	jmp    80106c04 <alltraps>

80107278 <vector8>:
.globl vector8
vector8:
  pushl $8
80107278:	6a 08                	push   $0x8
  jmp alltraps
8010727a:	e9 85 f9 ff ff       	jmp    80106c04 <alltraps>

8010727f <vector9>:
.globl vector9
vector9:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $9
80107281:	6a 09                	push   $0x9
  jmp alltraps
80107283:	e9 7c f9 ff ff       	jmp    80106c04 <alltraps>

80107288 <vector10>:
.globl vector10
vector10:
  pushl $10
80107288:	6a 0a                	push   $0xa
  jmp alltraps
8010728a:	e9 75 f9 ff ff       	jmp    80106c04 <alltraps>

8010728f <vector11>:
.globl vector11
vector11:
  pushl $11
8010728f:	6a 0b                	push   $0xb
  jmp alltraps
80107291:	e9 6e f9 ff ff       	jmp    80106c04 <alltraps>

80107296 <vector12>:
.globl vector12
vector12:
  pushl $12
80107296:	6a 0c                	push   $0xc
  jmp alltraps
80107298:	e9 67 f9 ff ff       	jmp    80106c04 <alltraps>

8010729d <vector13>:
.globl vector13
vector13:
  pushl $13
8010729d:	6a 0d                	push   $0xd
  jmp alltraps
8010729f:	e9 60 f9 ff ff       	jmp    80106c04 <alltraps>

801072a4 <vector14>:
.globl vector14
vector14:
  pushl $14
801072a4:	6a 0e                	push   $0xe
  jmp alltraps
801072a6:	e9 59 f9 ff ff       	jmp    80106c04 <alltraps>

801072ab <vector15>:
.globl vector15
vector15:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $15
801072ad:	6a 0f                	push   $0xf
  jmp alltraps
801072af:	e9 50 f9 ff ff       	jmp    80106c04 <alltraps>

801072b4 <vector16>:
.globl vector16
vector16:
  pushl $0
801072b4:	6a 00                	push   $0x0
  pushl $16
801072b6:	6a 10                	push   $0x10
  jmp alltraps
801072b8:	e9 47 f9 ff ff       	jmp    80106c04 <alltraps>

801072bd <vector17>:
.globl vector17
vector17:
  pushl $17
801072bd:	6a 11                	push   $0x11
  jmp alltraps
801072bf:	e9 40 f9 ff ff       	jmp    80106c04 <alltraps>

801072c4 <vector18>:
.globl vector18
vector18:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $18
801072c6:	6a 12                	push   $0x12
  jmp alltraps
801072c8:	e9 37 f9 ff ff       	jmp    80106c04 <alltraps>

801072cd <vector19>:
.globl vector19
vector19:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $19
801072cf:	6a 13                	push   $0x13
  jmp alltraps
801072d1:	e9 2e f9 ff ff       	jmp    80106c04 <alltraps>

801072d6 <vector20>:
.globl vector20
vector20:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $20
801072d8:	6a 14                	push   $0x14
  jmp alltraps
801072da:	e9 25 f9 ff ff       	jmp    80106c04 <alltraps>

801072df <vector21>:
.globl vector21
vector21:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $21
801072e1:	6a 15                	push   $0x15
  jmp alltraps
801072e3:	e9 1c f9 ff ff       	jmp    80106c04 <alltraps>

801072e8 <vector22>:
.globl vector22
vector22:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $22
801072ea:	6a 16                	push   $0x16
  jmp alltraps
801072ec:	e9 13 f9 ff ff       	jmp    80106c04 <alltraps>

801072f1 <vector23>:
.globl vector23
vector23:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $23
801072f3:	6a 17                	push   $0x17
  jmp alltraps
801072f5:	e9 0a f9 ff ff       	jmp    80106c04 <alltraps>

801072fa <vector24>:
.globl vector24
vector24:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $24
801072fc:	6a 18                	push   $0x18
  jmp alltraps
801072fe:	e9 01 f9 ff ff       	jmp    80106c04 <alltraps>

80107303 <vector25>:
.globl vector25
vector25:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $25
80107305:	6a 19                	push   $0x19
  jmp alltraps
80107307:	e9 f8 f8 ff ff       	jmp    80106c04 <alltraps>

8010730c <vector26>:
.globl vector26
vector26:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $26
8010730e:	6a 1a                	push   $0x1a
  jmp alltraps
80107310:	e9 ef f8 ff ff       	jmp    80106c04 <alltraps>

80107315 <vector27>:
.globl vector27
vector27:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $27
80107317:	6a 1b                	push   $0x1b
  jmp alltraps
80107319:	e9 e6 f8 ff ff       	jmp    80106c04 <alltraps>

8010731e <vector28>:
.globl vector28
vector28:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $28
80107320:	6a 1c                	push   $0x1c
  jmp alltraps
80107322:	e9 dd f8 ff ff       	jmp    80106c04 <alltraps>

80107327 <vector29>:
.globl vector29
vector29:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $29
80107329:	6a 1d                	push   $0x1d
  jmp alltraps
8010732b:	e9 d4 f8 ff ff       	jmp    80106c04 <alltraps>

80107330 <vector30>:
.globl vector30
vector30:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $30
80107332:	6a 1e                	push   $0x1e
  jmp alltraps
80107334:	e9 cb f8 ff ff       	jmp    80106c04 <alltraps>

80107339 <vector31>:
.globl vector31
vector31:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $31
8010733b:	6a 1f                	push   $0x1f
  jmp alltraps
8010733d:	e9 c2 f8 ff ff       	jmp    80106c04 <alltraps>

80107342 <vector32>:
.globl vector32
vector32:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $32
80107344:	6a 20                	push   $0x20
  jmp alltraps
80107346:	e9 b9 f8 ff ff       	jmp    80106c04 <alltraps>

8010734b <vector33>:
.globl vector33
vector33:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $33
8010734d:	6a 21                	push   $0x21
  jmp alltraps
8010734f:	e9 b0 f8 ff ff       	jmp    80106c04 <alltraps>

80107354 <vector34>:
.globl vector34
vector34:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $34
80107356:	6a 22                	push   $0x22
  jmp alltraps
80107358:	e9 a7 f8 ff ff       	jmp    80106c04 <alltraps>

8010735d <vector35>:
.globl vector35
vector35:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $35
8010735f:	6a 23                	push   $0x23
  jmp alltraps
80107361:	e9 9e f8 ff ff       	jmp    80106c04 <alltraps>

80107366 <vector36>:
.globl vector36
vector36:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $36
80107368:	6a 24                	push   $0x24
  jmp alltraps
8010736a:	e9 95 f8 ff ff       	jmp    80106c04 <alltraps>

8010736f <vector37>:
.globl vector37
vector37:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $37
80107371:	6a 25                	push   $0x25
  jmp alltraps
80107373:	e9 8c f8 ff ff       	jmp    80106c04 <alltraps>

80107378 <vector38>:
.globl vector38
vector38:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $38
8010737a:	6a 26                	push   $0x26
  jmp alltraps
8010737c:	e9 83 f8 ff ff       	jmp    80106c04 <alltraps>

80107381 <vector39>:
.globl vector39
vector39:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $39
80107383:	6a 27                	push   $0x27
  jmp alltraps
80107385:	e9 7a f8 ff ff       	jmp    80106c04 <alltraps>

8010738a <vector40>:
.globl vector40
vector40:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $40
8010738c:	6a 28                	push   $0x28
  jmp alltraps
8010738e:	e9 71 f8 ff ff       	jmp    80106c04 <alltraps>

80107393 <vector41>:
.globl vector41
vector41:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $41
80107395:	6a 29                	push   $0x29
  jmp alltraps
80107397:	e9 68 f8 ff ff       	jmp    80106c04 <alltraps>

8010739c <vector42>:
.globl vector42
vector42:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $42
8010739e:	6a 2a                	push   $0x2a
  jmp alltraps
801073a0:	e9 5f f8 ff ff       	jmp    80106c04 <alltraps>

801073a5 <vector43>:
.globl vector43
vector43:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $43
801073a7:	6a 2b                	push   $0x2b
  jmp alltraps
801073a9:	e9 56 f8 ff ff       	jmp    80106c04 <alltraps>

801073ae <vector44>:
.globl vector44
vector44:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $44
801073b0:	6a 2c                	push   $0x2c
  jmp alltraps
801073b2:	e9 4d f8 ff ff       	jmp    80106c04 <alltraps>

801073b7 <vector45>:
.globl vector45
vector45:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $45
801073b9:	6a 2d                	push   $0x2d
  jmp alltraps
801073bb:	e9 44 f8 ff ff       	jmp    80106c04 <alltraps>

801073c0 <vector46>:
.globl vector46
vector46:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $46
801073c2:	6a 2e                	push   $0x2e
  jmp alltraps
801073c4:	e9 3b f8 ff ff       	jmp    80106c04 <alltraps>

801073c9 <vector47>:
.globl vector47
vector47:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $47
801073cb:	6a 2f                	push   $0x2f
  jmp alltraps
801073cd:	e9 32 f8 ff ff       	jmp    80106c04 <alltraps>

801073d2 <vector48>:
.globl vector48
vector48:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $48
801073d4:	6a 30                	push   $0x30
  jmp alltraps
801073d6:	e9 29 f8 ff ff       	jmp    80106c04 <alltraps>

801073db <vector49>:
.globl vector49
vector49:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $49
801073dd:	6a 31                	push   $0x31
  jmp alltraps
801073df:	e9 20 f8 ff ff       	jmp    80106c04 <alltraps>

801073e4 <vector50>:
.globl vector50
vector50:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $50
801073e6:	6a 32                	push   $0x32
  jmp alltraps
801073e8:	e9 17 f8 ff ff       	jmp    80106c04 <alltraps>

801073ed <vector51>:
.globl vector51
vector51:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $51
801073ef:	6a 33                	push   $0x33
  jmp alltraps
801073f1:	e9 0e f8 ff ff       	jmp    80106c04 <alltraps>

801073f6 <vector52>:
.globl vector52
vector52:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $52
801073f8:	6a 34                	push   $0x34
  jmp alltraps
801073fa:	e9 05 f8 ff ff       	jmp    80106c04 <alltraps>

801073ff <vector53>:
.globl vector53
vector53:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $53
80107401:	6a 35                	push   $0x35
  jmp alltraps
80107403:	e9 fc f7 ff ff       	jmp    80106c04 <alltraps>

80107408 <vector54>:
.globl vector54
vector54:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $54
8010740a:	6a 36                	push   $0x36
  jmp alltraps
8010740c:	e9 f3 f7 ff ff       	jmp    80106c04 <alltraps>

80107411 <vector55>:
.globl vector55
vector55:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $55
80107413:	6a 37                	push   $0x37
  jmp alltraps
80107415:	e9 ea f7 ff ff       	jmp    80106c04 <alltraps>

8010741a <vector56>:
.globl vector56
vector56:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $56
8010741c:	6a 38                	push   $0x38
  jmp alltraps
8010741e:	e9 e1 f7 ff ff       	jmp    80106c04 <alltraps>

80107423 <vector57>:
.globl vector57
vector57:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $57
80107425:	6a 39                	push   $0x39
  jmp alltraps
80107427:	e9 d8 f7 ff ff       	jmp    80106c04 <alltraps>

8010742c <vector58>:
.globl vector58
vector58:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $58
8010742e:	6a 3a                	push   $0x3a
  jmp alltraps
80107430:	e9 cf f7 ff ff       	jmp    80106c04 <alltraps>

80107435 <vector59>:
.globl vector59
vector59:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $59
80107437:	6a 3b                	push   $0x3b
  jmp alltraps
80107439:	e9 c6 f7 ff ff       	jmp    80106c04 <alltraps>

8010743e <vector60>:
.globl vector60
vector60:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $60
80107440:	6a 3c                	push   $0x3c
  jmp alltraps
80107442:	e9 bd f7 ff ff       	jmp    80106c04 <alltraps>

80107447 <vector61>:
.globl vector61
vector61:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $61
80107449:	6a 3d                	push   $0x3d
  jmp alltraps
8010744b:	e9 b4 f7 ff ff       	jmp    80106c04 <alltraps>

80107450 <vector62>:
.globl vector62
vector62:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $62
80107452:	6a 3e                	push   $0x3e
  jmp alltraps
80107454:	e9 ab f7 ff ff       	jmp    80106c04 <alltraps>

80107459 <vector63>:
.globl vector63
vector63:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $63
8010745b:	6a 3f                	push   $0x3f
  jmp alltraps
8010745d:	e9 a2 f7 ff ff       	jmp    80106c04 <alltraps>

80107462 <vector64>:
.globl vector64
vector64:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $64
80107464:	6a 40                	push   $0x40
  jmp alltraps
80107466:	e9 99 f7 ff ff       	jmp    80106c04 <alltraps>

8010746b <vector65>:
.globl vector65
vector65:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $65
8010746d:	6a 41                	push   $0x41
  jmp alltraps
8010746f:	e9 90 f7 ff ff       	jmp    80106c04 <alltraps>

80107474 <vector66>:
.globl vector66
vector66:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $66
80107476:	6a 42                	push   $0x42
  jmp alltraps
80107478:	e9 87 f7 ff ff       	jmp    80106c04 <alltraps>

8010747d <vector67>:
.globl vector67
vector67:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $67
8010747f:	6a 43                	push   $0x43
  jmp alltraps
80107481:	e9 7e f7 ff ff       	jmp    80106c04 <alltraps>

80107486 <vector68>:
.globl vector68
vector68:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $68
80107488:	6a 44                	push   $0x44
  jmp alltraps
8010748a:	e9 75 f7 ff ff       	jmp    80106c04 <alltraps>

8010748f <vector69>:
.globl vector69
vector69:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $69
80107491:	6a 45                	push   $0x45
  jmp alltraps
80107493:	e9 6c f7 ff ff       	jmp    80106c04 <alltraps>

80107498 <vector70>:
.globl vector70
vector70:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $70
8010749a:	6a 46                	push   $0x46
  jmp alltraps
8010749c:	e9 63 f7 ff ff       	jmp    80106c04 <alltraps>

801074a1 <vector71>:
.globl vector71
vector71:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $71
801074a3:	6a 47                	push   $0x47
  jmp alltraps
801074a5:	e9 5a f7 ff ff       	jmp    80106c04 <alltraps>

801074aa <vector72>:
.globl vector72
vector72:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $72
801074ac:	6a 48                	push   $0x48
  jmp alltraps
801074ae:	e9 51 f7 ff ff       	jmp    80106c04 <alltraps>

801074b3 <vector73>:
.globl vector73
vector73:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $73
801074b5:	6a 49                	push   $0x49
  jmp alltraps
801074b7:	e9 48 f7 ff ff       	jmp    80106c04 <alltraps>

801074bc <vector74>:
.globl vector74
vector74:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $74
801074be:	6a 4a                	push   $0x4a
  jmp alltraps
801074c0:	e9 3f f7 ff ff       	jmp    80106c04 <alltraps>

801074c5 <vector75>:
.globl vector75
vector75:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $75
801074c7:	6a 4b                	push   $0x4b
  jmp alltraps
801074c9:	e9 36 f7 ff ff       	jmp    80106c04 <alltraps>

801074ce <vector76>:
.globl vector76
vector76:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $76
801074d0:	6a 4c                	push   $0x4c
  jmp alltraps
801074d2:	e9 2d f7 ff ff       	jmp    80106c04 <alltraps>

801074d7 <vector77>:
.globl vector77
vector77:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $77
801074d9:	6a 4d                	push   $0x4d
  jmp alltraps
801074db:	e9 24 f7 ff ff       	jmp    80106c04 <alltraps>

801074e0 <vector78>:
.globl vector78
vector78:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $78
801074e2:	6a 4e                	push   $0x4e
  jmp alltraps
801074e4:	e9 1b f7 ff ff       	jmp    80106c04 <alltraps>

801074e9 <vector79>:
.globl vector79
vector79:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $79
801074eb:	6a 4f                	push   $0x4f
  jmp alltraps
801074ed:	e9 12 f7 ff ff       	jmp    80106c04 <alltraps>

801074f2 <vector80>:
.globl vector80
vector80:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $80
801074f4:	6a 50                	push   $0x50
  jmp alltraps
801074f6:	e9 09 f7 ff ff       	jmp    80106c04 <alltraps>

801074fb <vector81>:
.globl vector81
vector81:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $81
801074fd:	6a 51                	push   $0x51
  jmp alltraps
801074ff:	e9 00 f7 ff ff       	jmp    80106c04 <alltraps>

80107504 <vector82>:
.globl vector82
vector82:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $82
80107506:	6a 52                	push   $0x52
  jmp alltraps
80107508:	e9 f7 f6 ff ff       	jmp    80106c04 <alltraps>

8010750d <vector83>:
.globl vector83
vector83:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $83
8010750f:	6a 53                	push   $0x53
  jmp alltraps
80107511:	e9 ee f6 ff ff       	jmp    80106c04 <alltraps>

80107516 <vector84>:
.globl vector84
vector84:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $84
80107518:	6a 54                	push   $0x54
  jmp alltraps
8010751a:	e9 e5 f6 ff ff       	jmp    80106c04 <alltraps>

8010751f <vector85>:
.globl vector85
vector85:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $85
80107521:	6a 55                	push   $0x55
  jmp alltraps
80107523:	e9 dc f6 ff ff       	jmp    80106c04 <alltraps>

80107528 <vector86>:
.globl vector86
vector86:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $86
8010752a:	6a 56                	push   $0x56
  jmp alltraps
8010752c:	e9 d3 f6 ff ff       	jmp    80106c04 <alltraps>

80107531 <vector87>:
.globl vector87
vector87:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $87
80107533:	6a 57                	push   $0x57
  jmp alltraps
80107535:	e9 ca f6 ff ff       	jmp    80106c04 <alltraps>

8010753a <vector88>:
.globl vector88
vector88:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $88
8010753c:	6a 58                	push   $0x58
  jmp alltraps
8010753e:	e9 c1 f6 ff ff       	jmp    80106c04 <alltraps>

80107543 <vector89>:
.globl vector89
vector89:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $89
80107545:	6a 59                	push   $0x59
  jmp alltraps
80107547:	e9 b8 f6 ff ff       	jmp    80106c04 <alltraps>

8010754c <vector90>:
.globl vector90
vector90:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $90
8010754e:	6a 5a                	push   $0x5a
  jmp alltraps
80107550:	e9 af f6 ff ff       	jmp    80106c04 <alltraps>

80107555 <vector91>:
.globl vector91
vector91:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $91
80107557:	6a 5b                	push   $0x5b
  jmp alltraps
80107559:	e9 a6 f6 ff ff       	jmp    80106c04 <alltraps>

8010755e <vector92>:
.globl vector92
vector92:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $92
80107560:	6a 5c                	push   $0x5c
  jmp alltraps
80107562:	e9 9d f6 ff ff       	jmp    80106c04 <alltraps>

80107567 <vector93>:
.globl vector93
vector93:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $93
80107569:	6a 5d                	push   $0x5d
  jmp alltraps
8010756b:	e9 94 f6 ff ff       	jmp    80106c04 <alltraps>

80107570 <vector94>:
.globl vector94
vector94:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $94
80107572:	6a 5e                	push   $0x5e
  jmp alltraps
80107574:	e9 8b f6 ff ff       	jmp    80106c04 <alltraps>

80107579 <vector95>:
.globl vector95
vector95:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $95
8010757b:	6a 5f                	push   $0x5f
  jmp alltraps
8010757d:	e9 82 f6 ff ff       	jmp    80106c04 <alltraps>

80107582 <vector96>:
.globl vector96
vector96:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $96
80107584:	6a 60                	push   $0x60
  jmp alltraps
80107586:	e9 79 f6 ff ff       	jmp    80106c04 <alltraps>

8010758b <vector97>:
.globl vector97
vector97:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $97
8010758d:	6a 61                	push   $0x61
  jmp alltraps
8010758f:	e9 70 f6 ff ff       	jmp    80106c04 <alltraps>

80107594 <vector98>:
.globl vector98
vector98:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $98
80107596:	6a 62                	push   $0x62
  jmp alltraps
80107598:	e9 67 f6 ff ff       	jmp    80106c04 <alltraps>

8010759d <vector99>:
.globl vector99
vector99:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $99
8010759f:	6a 63                	push   $0x63
  jmp alltraps
801075a1:	e9 5e f6 ff ff       	jmp    80106c04 <alltraps>

801075a6 <vector100>:
.globl vector100
vector100:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $100
801075a8:	6a 64                	push   $0x64
  jmp alltraps
801075aa:	e9 55 f6 ff ff       	jmp    80106c04 <alltraps>

801075af <vector101>:
.globl vector101
vector101:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $101
801075b1:	6a 65                	push   $0x65
  jmp alltraps
801075b3:	e9 4c f6 ff ff       	jmp    80106c04 <alltraps>

801075b8 <vector102>:
.globl vector102
vector102:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $102
801075ba:	6a 66                	push   $0x66
  jmp alltraps
801075bc:	e9 43 f6 ff ff       	jmp    80106c04 <alltraps>

801075c1 <vector103>:
.globl vector103
vector103:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $103
801075c3:	6a 67                	push   $0x67
  jmp alltraps
801075c5:	e9 3a f6 ff ff       	jmp    80106c04 <alltraps>

801075ca <vector104>:
.globl vector104
vector104:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $104
801075cc:	6a 68                	push   $0x68
  jmp alltraps
801075ce:	e9 31 f6 ff ff       	jmp    80106c04 <alltraps>

801075d3 <vector105>:
.globl vector105
vector105:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $105
801075d5:	6a 69                	push   $0x69
  jmp alltraps
801075d7:	e9 28 f6 ff ff       	jmp    80106c04 <alltraps>

801075dc <vector106>:
.globl vector106
vector106:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $106
801075de:	6a 6a                	push   $0x6a
  jmp alltraps
801075e0:	e9 1f f6 ff ff       	jmp    80106c04 <alltraps>

801075e5 <vector107>:
.globl vector107
vector107:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $107
801075e7:	6a 6b                	push   $0x6b
  jmp alltraps
801075e9:	e9 16 f6 ff ff       	jmp    80106c04 <alltraps>

801075ee <vector108>:
.globl vector108
vector108:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $108
801075f0:	6a 6c                	push   $0x6c
  jmp alltraps
801075f2:	e9 0d f6 ff ff       	jmp    80106c04 <alltraps>

801075f7 <vector109>:
.globl vector109
vector109:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $109
801075f9:	6a 6d                	push   $0x6d
  jmp alltraps
801075fb:	e9 04 f6 ff ff       	jmp    80106c04 <alltraps>

80107600 <vector110>:
.globl vector110
vector110:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $110
80107602:	6a 6e                	push   $0x6e
  jmp alltraps
80107604:	e9 fb f5 ff ff       	jmp    80106c04 <alltraps>

80107609 <vector111>:
.globl vector111
vector111:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $111
8010760b:	6a 6f                	push   $0x6f
  jmp alltraps
8010760d:	e9 f2 f5 ff ff       	jmp    80106c04 <alltraps>

80107612 <vector112>:
.globl vector112
vector112:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $112
80107614:	6a 70                	push   $0x70
  jmp alltraps
80107616:	e9 e9 f5 ff ff       	jmp    80106c04 <alltraps>

8010761b <vector113>:
.globl vector113
vector113:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $113
8010761d:	6a 71                	push   $0x71
  jmp alltraps
8010761f:	e9 e0 f5 ff ff       	jmp    80106c04 <alltraps>

80107624 <vector114>:
.globl vector114
vector114:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $114
80107626:	6a 72                	push   $0x72
  jmp alltraps
80107628:	e9 d7 f5 ff ff       	jmp    80106c04 <alltraps>

8010762d <vector115>:
.globl vector115
vector115:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $115
8010762f:	6a 73                	push   $0x73
  jmp alltraps
80107631:	e9 ce f5 ff ff       	jmp    80106c04 <alltraps>

80107636 <vector116>:
.globl vector116
vector116:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $116
80107638:	6a 74                	push   $0x74
  jmp alltraps
8010763a:	e9 c5 f5 ff ff       	jmp    80106c04 <alltraps>

8010763f <vector117>:
.globl vector117
vector117:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $117
80107641:	6a 75                	push   $0x75
  jmp alltraps
80107643:	e9 bc f5 ff ff       	jmp    80106c04 <alltraps>

80107648 <vector118>:
.globl vector118
vector118:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $118
8010764a:	6a 76                	push   $0x76
  jmp alltraps
8010764c:	e9 b3 f5 ff ff       	jmp    80106c04 <alltraps>

80107651 <vector119>:
.globl vector119
vector119:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $119
80107653:	6a 77                	push   $0x77
  jmp alltraps
80107655:	e9 aa f5 ff ff       	jmp    80106c04 <alltraps>

8010765a <vector120>:
.globl vector120
vector120:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $120
8010765c:	6a 78                	push   $0x78
  jmp alltraps
8010765e:	e9 a1 f5 ff ff       	jmp    80106c04 <alltraps>

80107663 <vector121>:
.globl vector121
vector121:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $121
80107665:	6a 79                	push   $0x79
  jmp alltraps
80107667:	e9 98 f5 ff ff       	jmp    80106c04 <alltraps>

8010766c <vector122>:
.globl vector122
vector122:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $122
8010766e:	6a 7a                	push   $0x7a
  jmp alltraps
80107670:	e9 8f f5 ff ff       	jmp    80106c04 <alltraps>

80107675 <vector123>:
.globl vector123
vector123:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $123
80107677:	6a 7b                	push   $0x7b
  jmp alltraps
80107679:	e9 86 f5 ff ff       	jmp    80106c04 <alltraps>

8010767e <vector124>:
.globl vector124
vector124:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $124
80107680:	6a 7c                	push   $0x7c
  jmp alltraps
80107682:	e9 7d f5 ff ff       	jmp    80106c04 <alltraps>

80107687 <vector125>:
.globl vector125
vector125:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $125
80107689:	6a 7d                	push   $0x7d
  jmp alltraps
8010768b:	e9 74 f5 ff ff       	jmp    80106c04 <alltraps>

80107690 <vector126>:
.globl vector126
vector126:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $126
80107692:	6a 7e                	push   $0x7e
  jmp alltraps
80107694:	e9 6b f5 ff ff       	jmp    80106c04 <alltraps>

80107699 <vector127>:
.globl vector127
vector127:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $127
8010769b:	6a 7f                	push   $0x7f
  jmp alltraps
8010769d:	e9 62 f5 ff ff       	jmp    80106c04 <alltraps>

801076a2 <vector128>:
.globl vector128
vector128:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $128
801076a4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801076a9:	e9 56 f5 ff ff       	jmp    80106c04 <alltraps>

801076ae <vector129>:
.globl vector129
vector129:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $129
801076b0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801076b5:	e9 4a f5 ff ff       	jmp    80106c04 <alltraps>

801076ba <vector130>:
.globl vector130
vector130:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $130
801076bc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801076c1:	e9 3e f5 ff ff       	jmp    80106c04 <alltraps>

801076c6 <vector131>:
.globl vector131
vector131:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $131
801076c8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801076cd:	e9 32 f5 ff ff       	jmp    80106c04 <alltraps>

801076d2 <vector132>:
.globl vector132
vector132:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $132
801076d4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801076d9:	e9 26 f5 ff ff       	jmp    80106c04 <alltraps>

801076de <vector133>:
.globl vector133
vector133:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $133
801076e0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801076e5:	e9 1a f5 ff ff       	jmp    80106c04 <alltraps>

801076ea <vector134>:
.globl vector134
vector134:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $134
801076ec:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801076f1:	e9 0e f5 ff ff       	jmp    80106c04 <alltraps>

801076f6 <vector135>:
.globl vector135
vector135:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $135
801076f8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801076fd:	e9 02 f5 ff ff       	jmp    80106c04 <alltraps>

80107702 <vector136>:
.globl vector136
vector136:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $136
80107704:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107709:	e9 f6 f4 ff ff       	jmp    80106c04 <alltraps>

8010770e <vector137>:
.globl vector137
vector137:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $137
80107710:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107715:	e9 ea f4 ff ff       	jmp    80106c04 <alltraps>

8010771a <vector138>:
.globl vector138
vector138:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $138
8010771c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107721:	e9 de f4 ff ff       	jmp    80106c04 <alltraps>

80107726 <vector139>:
.globl vector139
vector139:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $139
80107728:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010772d:	e9 d2 f4 ff ff       	jmp    80106c04 <alltraps>

80107732 <vector140>:
.globl vector140
vector140:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $140
80107734:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107739:	e9 c6 f4 ff ff       	jmp    80106c04 <alltraps>

8010773e <vector141>:
.globl vector141
vector141:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $141
80107740:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107745:	e9 ba f4 ff ff       	jmp    80106c04 <alltraps>

8010774a <vector142>:
.globl vector142
vector142:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $142
8010774c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107751:	e9 ae f4 ff ff       	jmp    80106c04 <alltraps>

80107756 <vector143>:
.globl vector143
vector143:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $143
80107758:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010775d:	e9 a2 f4 ff ff       	jmp    80106c04 <alltraps>

80107762 <vector144>:
.globl vector144
vector144:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $144
80107764:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107769:	e9 96 f4 ff ff       	jmp    80106c04 <alltraps>

8010776e <vector145>:
.globl vector145
vector145:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $145
80107770:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107775:	e9 8a f4 ff ff       	jmp    80106c04 <alltraps>

8010777a <vector146>:
.globl vector146
vector146:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $146
8010777c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107781:	e9 7e f4 ff ff       	jmp    80106c04 <alltraps>

80107786 <vector147>:
.globl vector147
vector147:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $147
80107788:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010778d:	e9 72 f4 ff ff       	jmp    80106c04 <alltraps>

80107792 <vector148>:
.globl vector148
vector148:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $148
80107794:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107799:	e9 66 f4 ff ff       	jmp    80106c04 <alltraps>

8010779e <vector149>:
.globl vector149
vector149:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $149
801077a0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801077a5:	e9 5a f4 ff ff       	jmp    80106c04 <alltraps>

801077aa <vector150>:
.globl vector150
vector150:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $150
801077ac:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801077b1:	e9 4e f4 ff ff       	jmp    80106c04 <alltraps>

801077b6 <vector151>:
.globl vector151
vector151:
  pushl $0
801077b6:	6a 00                	push   $0x0
  pushl $151
801077b8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801077bd:	e9 42 f4 ff ff       	jmp    80106c04 <alltraps>

801077c2 <vector152>:
.globl vector152
vector152:
  pushl $0
801077c2:	6a 00                	push   $0x0
  pushl $152
801077c4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801077c9:	e9 36 f4 ff ff       	jmp    80106c04 <alltraps>

801077ce <vector153>:
.globl vector153
vector153:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $153
801077d0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801077d5:	e9 2a f4 ff ff       	jmp    80106c04 <alltraps>

801077da <vector154>:
.globl vector154
vector154:
  pushl $0
801077da:	6a 00                	push   $0x0
  pushl $154
801077dc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801077e1:	e9 1e f4 ff ff       	jmp    80106c04 <alltraps>

801077e6 <vector155>:
.globl vector155
vector155:
  pushl $0
801077e6:	6a 00                	push   $0x0
  pushl $155
801077e8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801077ed:	e9 12 f4 ff ff       	jmp    80106c04 <alltraps>

801077f2 <vector156>:
.globl vector156
vector156:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $156
801077f4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801077f9:	e9 06 f4 ff ff       	jmp    80106c04 <alltraps>

801077fe <vector157>:
.globl vector157
vector157:
  pushl $0
801077fe:	6a 00                	push   $0x0
  pushl $157
80107800:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107805:	e9 fa f3 ff ff       	jmp    80106c04 <alltraps>

8010780a <vector158>:
.globl vector158
vector158:
  pushl $0
8010780a:	6a 00                	push   $0x0
  pushl $158
8010780c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107811:	e9 ee f3 ff ff       	jmp    80106c04 <alltraps>

80107816 <vector159>:
.globl vector159
vector159:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $159
80107818:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010781d:	e9 e2 f3 ff ff       	jmp    80106c04 <alltraps>

80107822 <vector160>:
.globl vector160
vector160:
  pushl $0
80107822:	6a 00                	push   $0x0
  pushl $160
80107824:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107829:	e9 d6 f3 ff ff       	jmp    80106c04 <alltraps>

8010782e <vector161>:
.globl vector161
vector161:
  pushl $0
8010782e:	6a 00                	push   $0x0
  pushl $161
80107830:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107835:	e9 ca f3 ff ff       	jmp    80106c04 <alltraps>

8010783a <vector162>:
.globl vector162
vector162:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $162
8010783c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107841:	e9 be f3 ff ff       	jmp    80106c04 <alltraps>

80107846 <vector163>:
.globl vector163
vector163:
  pushl $0
80107846:	6a 00                	push   $0x0
  pushl $163
80107848:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010784d:	e9 b2 f3 ff ff       	jmp    80106c04 <alltraps>

80107852 <vector164>:
.globl vector164
vector164:
  pushl $0
80107852:	6a 00                	push   $0x0
  pushl $164
80107854:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107859:	e9 a6 f3 ff ff       	jmp    80106c04 <alltraps>

8010785e <vector165>:
.globl vector165
vector165:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $165
80107860:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107865:	e9 9a f3 ff ff       	jmp    80106c04 <alltraps>

8010786a <vector166>:
.globl vector166
vector166:
  pushl $0
8010786a:	6a 00                	push   $0x0
  pushl $166
8010786c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107871:	e9 8e f3 ff ff       	jmp    80106c04 <alltraps>

80107876 <vector167>:
.globl vector167
vector167:
  pushl $0
80107876:	6a 00                	push   $0x0
  pushl $167
80107878:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010787d:	e9 82 f3 ff ff       	jmp    80106c04 <alltraps>

80107882 <vector168>:
.globl vector168
vector168:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $168
80107884:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107889:	e9 76 f3 ff ff       	jmp    80106c04 <alltraps>

8010788e <vector169>:
.globl vector169
vector169:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $169
80107890:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107895:	e9 6a f3 ff ff       	jmp    80106c04 <alltraps>

8010789a <vector170>:
.globl vector170
vector170:
  pushl $0
8010789a:	6a 00                	push   $0x0
  pushl $170
8010789c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801078a1:	e9 5e f3 ff ff       	jmp    80106c04 <alltraps>

801078a6 <vector171>:
.globl vector171
vector171:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $171
801078a8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801078ad:	e9 52 f3 ff ff       	jmp    80106c04 <alltraps>

801078b2 <vector172>:
.globl vector172
vector172:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $172
801078b4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801078b9:	e9 46 f3 ff ff       	jmp    80106c04 <alltraps>

801078be <vector173>:
.globl vector173
vector173:
  pushl $0
801078be:	6a 00                	push   $0x0
  pushl $173
801078c0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801078c5:	e9 3a f3 ff ff       	jmp    80106c04 <alltraps>

801078ca <vector174>:
.globl vector174
vector174:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $174
801078cc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801078d1:	e9 2e f3 ff ff       	jmp    80106c04 <alltraps>

801078d6 <vector175>:
.globl vector175
vector175:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $175
801078d8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801078dd:	e9 22 f3 ff ff       	jmp    80106c04 <alltraps>

801078e2 <vector176>:
.globl vector176
vector176:
  pushl $0
801078e2:	6a 00                	push   $0x0
  pushl $176
801078e4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801078e9:	e9 16 f3 ff ff       	jmp    80106c04 <alltraps>

801078ee <vector177>:
.globl vector177
vector177:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $177
801078f0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801078f5:	e9 0a f3 ff ff       	jmp    80106c04 <alltraps>

801078fa <vector178>:
.globl vector178
vector178:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $178
801078fc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107901:	e9 fe f2 ff ff       	jmp    80106c04 <alltraps>

80107906 <vector179>:
.globl vector179
vector179:
  pushl $0
80107906:	6a 00                	push   $0x0
  pushl $179
80107908:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010790d:	e9 f2 f2 ff ff       	jmp    80106c04 <alltraps>

80107912 <vector180>:
.globl vector180
vector180:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $180
80107914:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107919:	e9 e6 f2 ff ff       	jmp    80106c04 <alltraps>

8010791e <vector181>:
.globl vector181
vector181:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $181
80107920:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107925:	e9 da f2 ff ff       	jmp    80106c04 <alltraps>

8010792a <vector182>:
.globl vector182
vector182:
  pushl $0
8010792a:	6a 00                	push   $0x0
  pushl $182
8010792c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107931:	e9 ce f2 ff ff       	jmp    80106c04 <alltraps>

80107936 <vector183>:
.globl vector183
vector183:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $183
80107938:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010793d:	e9 c2 f2 ff ff       	jmp    80106c04 <alltraps>

80107942 <vector184>:
.globl vector184
vector184:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $184
80107944:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107949:	e9 b6 f2 ff ff       	jmp    80106c04 <alltraps>

8010794e <vector185>:
.globl vector185
vector185:
  pushl $0
8010794e:	6a 00                	push   $0x0
  pushl $185
80107950:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107955:	e9 aa f2 ff ff       	jmp    80106c04 <alltraps>

8010795a <vector186>:
.globl vector186
vector186:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $186
8010795c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107961:	e9 9e f2 ff ff       	jmp    80106c04 <alltraps>

80107966 <vector187>:
.globl vector187
vector187:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $187
80107968:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010796d:	e9 92 f2 ff ff       	jmp    80106c04 <alltraps>

80107972 <vector188>:
.globl vector188
vector188:
  pushl $0
80107972:	6a 00                	push   $0x0
  pushl $188
80107974:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107979:	e9 86 f2 ff ff       	jmp    80106c04 <alltraps>

8010797e <vector189>:
.globl vector189
vector189:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $189
80107980:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107985:	e9 7a f2 ff ff       	jmp    80106c04 <alltraps>

8010798a <vector190>:
.globl vector190
vector190:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $190
8010798c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107991:	e9 6e f2 ff ff       	jmp    80106c04 <alltraps>

80107996 <vector191>:
.globl vector191
vector191:
  pushl $0
80107996:	6a 00                	push   $0x0
  pushl $191
80107998:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010799d:	e9 62 f2 ff ff       	jmp    80106c04 <alltraps>

801079a2 <vector192>:
.globl vector192
vector192:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $192
801079a4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801079a9:	e9 56 f2 ff ff       	jmp    80106c04 <alltraps>

801079ae <vector193>:
.globl vector193
vector193:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $193
801079b0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801079b5:	e9 4a f2 ff ff       	jmp    80106c04 <alltraps>

801079ba <vector194>:
.globl vector194
vector194:
  pushl $0
801079ba:	6a 00                	push   $0x0
  pushl $194
801079bc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801079c1:	e9 3e f2 ff ff       	jmp    80106c04 <alltraps>

801079c6 <vector195>:
.globl vector195
vector195:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $195
801079c8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801079cd:	e9 32 f2 ff ff       	jmp    80106c04 <alltraps>

801079d2 <vector196>:
.globl vector196
vector196:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $196
801079d4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801079d9:	e9 26 f2 ff ff       	jmp    80106c04 <alltraps>

801079de <vector197>:
.globl vector197
vector197:
  pushl $0
801079de:	6a 00                	push   $0x0
  pushl $197
801079e0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801079e5:	e9 1a f2 ff ff       	jmp    80106c04 <alltraps>

801079ea <vector198>:
.globl vector198
vector198:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $198
801079ec:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801079f1:	e9 0e f2 ff ff       	jmp    80106c04 <alltraps>

801079f6 <vector199>:
.globl vector199
vector199:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $199
801079f8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801079fd:	e9 02 f2 ff ff       	jmp    80106c04 <alltraps>

80107a02 <vector200>:
.globl vector200
vector200:
  pushl $0
80107a02:	6a 00                	push   $0x0
  pushl $200
80107a04:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107a09:	e9 f6 f1 ff ff       	jmp    80106c04 <alltraps>

80107a0e <vector201>:
.globl vector201
vector201:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $201
80107a10:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107a15:	e9 ea f1 ff ff       	jmp    80106c04 <alltraps>

80107a1a <vector202>:
.globl vector202
vector202:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $202
80107a1c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107a21:	e9 de f1 ff ff       	jmp    80106c04 <alltraps>

80107a26 <vector203>:
.globl vector203
vector203:
  pushl $0
80107a26:	6a 00                	push   $0x0
  pushl $203
80107a28:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107a2d:	e9 d2 f1 ff ff       	jmp    80106c04 <alltraps>

80107a32 <vector204>:
.globl vector204
vector204:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $204
80107a34:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a39:	e9 c6 f1 ff ff       	jmp    80106c04 <alltraps>

80107a3e <vector205>:
.globl vector205
vector205:
  pushl $0
80107a3e:	6a 00                	push   $0x0
  pushl $205
80107a40:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a45:	e9 ba f1 ff ff       	jmp    80106c04 <alltraps>

80107a4a <vector206>:
.globl vector206
vector206:
  pushl $0
80107a4a:	6a 00                	push   $0x0
  pushl $206
80107a4c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a51:	e9 ae f1 ff ff       	jmp    80106c04 <alltraps>

80107a56 <vector207>:
.globl vector207
vector207:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $207
80107a58:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a5d:	e9 a2 f1 ff ff       	jmp    80106c04 <alltraps>

80107a62 <vector208>:
.globl vector208
vector208:
  pushl $0
80107a62:	6a 00                	push   $0x0
  pushl $208
80107a64:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107a69:	e9 96 f1 ff ff       	jmp    80106c04 <alltraps>

80107a6e <vector209>:
.globl vector209
vector209:
  pushl $0
80107a6e:	6a 00                	push   $0x0
  pushl $209
80107a70:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107a75:	e9 8a f1 ff ff       	jmp    80106c04 <alltraps>

80107a7a <vector210>:
.globl vector210
vector210:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $210
80107a7c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a81:	e9 7e f1 ff ff       	jmp    80106c04 <alltraps>

80107a86 <vector211>:
.globl vector211
vector211:
  pushl $0
80107a86:	6a 00                	push   $0x0
  pushl $211
80107a88:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a8d:	e9 72 f1 ff ff       	jmp    80106c04 <alltraps>

80107a92 <vector212>:
.globl vector212
vector212:
  pushl $0
80107a92:	6a 00                	push   $0x0
  pushl $212
80107a94:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a99:	e9 66 f1 ff ff       	jmp    80106c04 <alltraps>

80107a9e <vector213>:
.globl vector213
vector213:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $213
80107aa0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107aa5:	e9 5a f1 ff ff       	jmp    80106c04 <alltraps>

80107aaa <vector214>:
.globl vector214
vector214:
  pushl $0
80107aaa:	6a 00                	push   $0x0
  pushl $214
80107aac:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107ab1:	e9 4e f1 ff ff       	jmp    80106c04 <alltraps>

80107ab6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107ab6:	6a 00                	push   $0x0
  pushl $215
80107ab8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107abd:	e9 42 f1 ff ff       	jmp    80106c04 <alltraps>

80107ac2 <vector216>:
.globl vector216
vector216:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $216
80107ac4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107ac9:	e9 36 f1 ff ff       	jmp    80106c04 <alltraps>

80107ace <vector217>:
.globl vector217
vector217:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $217
80107ad0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ad5:	e9 2a f1 ff ff       	jmp    80106c04 <alltraps>

80107ada <vector218>:
.globl vector218
vector218:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $218
80107adc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ae1:	e9 1e f1 ff ff       	jmp    80106c04 <alltraps>

80107ae6 <vector219>:
.globl vector219
vector219:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $219
80107ae8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107aed:	e9 12 f1 ff ff       	jmp    80106c04 <alltraps>

80107af2 <vector220>:
.globl vector220
vector220:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $220
80107af4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107af9:	e9 06 f1 ff ff       	jmp    80106c04 <alltraps>

80107afe <vector221>:
.globl vector221
vector221:
  pushl $0
80107afe:	6a 00                	push   $0x0
  pushl $221
80107b00:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107b05:	e9 fa f0 ff ff       	jmp    80106c04 <alltraps>

80107b0a <vector222>:
.globl vector222
vector222:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $222
80107b0c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107b11:	e9 ee f0 ff ff       	jmp    80106c04 <alltraps>

80107b16 <vector223>:
.globl vector223
vector223:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $223
80107b18:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107b1d:	e9 e2 f0 ff ff       	jmp    80106c04 <alltraps>

80107b22 <vector224>:
.globl vector224
vector224:
  pushl $0
80107b22:	6a 00                	push   $0x0
  pushl $224
80107b24:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107b29:	e9 d6 f0 ff ff       	jmp    80106c04 <alltraps>

80107b2e <vector225>:
.globl vector225
vector225:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $225
80107b30:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b35:	e9 ca f0 ff ff       	jmp    80106c04 <alltraps>

80107b3a <vector226>:
.globl vector226
vector226:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $226
80107b3c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b41:	e9 be f0 ff ff       	jmp    80106c04 <alltraps>

80107b46 <vector227>:
.globl vector227
vector227:
  pushl $0
80107b46:	6a 00                	push   $0x0
  pushl $227
80107b48:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b4d:	e9 b2 f0 ff ff       	jmp    80106c04 <alltraps>

80107b52 <vector228>:
.globl vector228
vector228:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $228
80107b54:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b59:	e9 a6 f0 ff ff       	jmp    80106c04 <alltraps>

80107b5e <vector229>:
.globl vector229
vector229:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $229
80107b60:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107b65:	e9 9a f0 ff ff       	jmp    80106c04 <alltraps>

80107b6a <vector230>:
.globl vector230
vector230:
  pushl $0
80107b6a:	6a 00                	push   $0x0
  pushl $230
80107b6c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107b71:	e9 8e f0 ff ff       	jmp    80106c04 <alltraps>

80107b76 <vector231>:
.globl vector231
vector231:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $231
80107b78:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107b7d:	e9 82 f0 ff ff       	jmp    80106c04 <alltraps>

80107b82 <vector232>:
.globl vector232
vector232:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $232
80107b84:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b89:	e9 76 f0 ff ff       	jmp    80106c04 <alltraps>

80107b8e <vector233>:
.globl vector233
vector233:
  pushl $0
80107b8e:	6a 00                	push   $0x0
  pushl $233
80107b90:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b95:	e9 6a f0 ff ff       	jmp    80106c04 <alltraps>

80107b9a <vector234>:
.globl vector234
vector234:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $234
80107b9c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107ba1:	e9 5e f0 ff ff       	jmp    80106c04 <alltraps>

80107ba6 <vector235>:
.globl vector235
vector235:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $235
80107ba8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107bad:	e9 52 f0 ff ff       	jmp    80106c04 <alltraps>

80107bb2 <vector236>:
.globl vector236
vector236:
  pushl $0
80107bb2:	6a 00                	push   $0x0
  pushl $236
80107bb4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107bb9:	e9 46 f0 ff ff       	jmp    80106c04 <alltraps>

80107bbe <vector237>:
.globl vector237
vector237:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $237
80107bc0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107bc5:	e9 3a f0 ff ff       	jmp    80106c04 <alltraps>

80107bca <vector238>:
.globl vector238
vector238:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $238
80107bcc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107bd1:	e9 2e f0 ff ff       	jmp    80106c04 <alltraps>

80107bd6 <vector239>:
.globl vector239
vector239:
  pushl $0
80107bd6:	6a 00                	push   $0x0
  pushl $239
80107bd8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107bdd:	e9 22 f0 ff ff       	jmp    80106c04 <alltraps>

80107be2 <vector240>:
.globl vector240
vector240:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $240
80107be4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107be9:	e9 16 f0 ff ff       	jmp    80106c04 <alltraps>

80107bee <vector241>:
.globl vector241
vector241:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $241
80107bf0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107bf5:	e9 0a f0 ff ff       	jmp    80106c04 <alltraps>

80107bfa <vector242>:
.globl vector242
vector242:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $242
80107bfc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107c01:	e9 fe ef ff ff       	jmp    80106c04 <alltraps>

80107c06 <vector243>:
.globl vector243
vector243:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $243
80107c08:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107c0d:	e9 f2 ef ff ff       	jmp    80106c04 <alltraps>

80107c12 <vector244>:
.globl vector244
vector244:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $244
80107c14:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107c19:	e9 e6 ef ff ff       	jmp    80106c04 <alltraps>

80107c1e <vector245>:
.globl vector245
vector245:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $245
80107c20:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107c25:	e9 da ef ff ff       	jmp    80106c04 <alltraps>

80107c2a <vector246>:
.globl vector246
vector246:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $246
80107c2c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c31:	e9 ce ef ff ff       	jmp    80106c04 <alltraps>

80107c36 <vector247>:
.globl vector247
vector247:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $247
80107c38:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c3d:	e9 c2 ef ff ff       	jmp    80106c04 <alltraps>

80107c42 <vector248>:
.globl vector248
vector248:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $248
80107c44:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c49:	e9 b6 ef ff ff       	jmp    80106c04 <alltraps>

80107c4e <vector249>:
.globl vector249
vector249:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $249
80107c50:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c55:	e9 aa ef ff ff       	jmp    80106c04 <alltraps>

80107c5a <vector250>:
.globl vector250
vector250:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $250
80107c5c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c61:	e9 9e ef ff ff       	jmp    80106c04 <alltraps>

80107c66 <vector251>:
.globl vector251
vector251:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $251
80107c68:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c6d:	e9 92 ef ff ff       	jmp    80106c04 <alltraps>

80107c72 <vector252>:
.globl vector252
vector252:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $252
80107c74:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107c79:	e9 86 ef ff ff       	jmp    80106c04 <alltraps>

80107c7e <vector253>:
.globl vector253
vector253:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $253
80107c80:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c85:	e9 7a ef ff ff       	jmp    80106c04 <alltraps>

80107c8a <vector254>:
.globl vector254
vector254:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $254
80107c8c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c91:	e9 6e ef ff ff       	jmp    80106c04 <alltraps>

80107c96 <vector255>:
.globl vector255
vector255:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $255
80107c98:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c9d:	e9 62 ef ff ff       	jmp    80106c04 <alltraps>
	...

80107ca4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ca4:	55                   	push   %ebp
80107ca5:	89 e5                	mov    %esp,%ebp
80107ca7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107caa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cad:	48                   	dec    %eax
80107cae:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107cb5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107cbc:	c1 e8 10             	shr    $0x10,%eax
80107cbf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107cc3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107cc6:	0f 01 10             	lgdtl  (%eax)
}
80107cc9:	c9                   	leave  
80107cca:	c3                   	ret    

80107ccb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ccb:	55                   	push   %ebp
80107ccc:	89 e5                	mov    %esp,%ebp
80107cce:	83 ec 04             	sub    $0x4,%esp
80107cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107cdb:	0f 00 d8             	ltr    %ax
}
80107cde:	c9                   	leave  
80107cdf:	c3                   	ret    

80107ce0 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce6:	0f 22 d8             	mov    %eax,%cr3
}
80107ce9:	5d                   	pop    %ebp
80107cea:	c3                   	ret    

80107ceb <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107ceb:	55                   	push   %ebp
80107cec:	89 e5                	mov    %esp,%ebp
80107cee:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107cf1:	e8 14 c6 ff ff       	call   8010430a <cpuid>
80107cf6:	89 c2                	mov    %eax,%edx
80107cf8:	89 d0                	mov    %edx,%eax
80107cfa:	c1 e0 02             	shl    $0x2,%eax
80107cfd:	01 d0                	add    %edx,%eax
80107cff:	01 c0                	add    %eax,%eax
80107d01:	01 d0                	add    %edx,%eax
80107d03:	c1 e0 04             	shl    $0x4,%eax
80107d06:	05 a0 4c 11 80       	add    $0x80114ca0,%eax
80107d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d11:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d23:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2a:	8a 50 7d             	mov    0x7d(%eax),%dl
80107d2d:	83 e2 f0             	and    $0xfffffff0,%edx
80107d30:	83 ca 0a             	or     $0xa,%edx
80107d33:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d39:	8a 50 7d             	mov    0x7d(%eax),%dl
80107d3c:	83 ca 10             	or     $0x10,%edx
80107d3f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d45:	8a 50 7d             	mov    0x7d(%eax),%dl
80107d48:	83 e2 9f             	and    $0xffffff9f,%edx
80107d4b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d51:	8a 50 7d             	mov    0x7d(%eax),%dl
80107d54:	83 ca 80             	or     $0xffffff80,%edx
80107d57:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107d60:	83 ca 0f             	or     $0xf,%edx
80107d63:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d69:	8a 50 7e             	mov    0x7e(%eax),%dl
80107d6c:	83 e2 ef             	and    $0xffffffef,%edx
80107d6f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d75:	8a 50 7e             	mov    0x7e(%eax),%dl
80107d78:	83 e2 df             	and    $0xffffffdf,%edx
80107d7b:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d81:	8a 50 7e             	mov    0x7e(%eax),%dl
80107d84:	83 ca 40             	or     $0x40,%edx
80107d87:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107d90:	83 ca 80             	or     $0xffffff80,%edx
80107d93:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d99:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107da7:	ff ff 
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107db3:	00 00 
80107db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db8:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc2:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107dc8:	83 e2 f0             	and    $0xfffffff0,%edx
80107dcb:	83 ca 02             	or     $0x2,%edx
80107dce:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd7:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107ddd:	83 ca 10             	or     $0x10,%edx
80107de0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de9:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107def:	83 e2 9f             	and    $0xffffff9f,%edx
80107df2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfb:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107e01:	83 ca 80             	or     $0xffffff80,%edx
80107e04:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0d:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107e13:	83 ca 0f             	or     $0xf,%edx
80107e16:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1f:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107e25:	83 e2 ef             	and    $0xffffffef,%edx
80107e28:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e31:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107e37:	83 e2 df             	and    $0xffffffdf,%edx
80107e3a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e43:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107e49:	83 ca 40             	or     $0x40,%edx
80107e4c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e55:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107e5b:	83 ca 80             	or     $0xffffff80,%edx
80107e5e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e67:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e71:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107e78:	ff ff 
80107e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7d:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107e84:	00 00 
80107e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e89:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e93:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107e99:	83 e2 f0             	and    $0xfffffff0,%edx
80107e9c:	83 ca 0a             	or     $0xa,%edx
80107e9f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea8:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107eae:	83 ca 10             	or     $0x10,%edx
80107eb1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eba:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107ec0:	83 ca 60             	or     $0x60,%edx
80107ec3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecc:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107ed2:	83 ca 80             	or     $0xffffff80,%edx
80107ed5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ede:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107ee4:	83 ca 0f             	or     $0xf,%edx
80107ee7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef0:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107ef6:	83 e2 ef             	and    $0xffffffef,%edx
80107ef9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f02:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107f08:	83 e2 df             	and    $0xffffffdf,%edx
80107f0b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f14:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107f1a:	83 ca 40             	or     $0x40,%edx
80107f1d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f26:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107f2c:	83 ca 80             	or     $0xffffff80,%edx
80107f2f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f38:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f42:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107f49:	ff ff 
80107f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107f55:	00 00 
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f64:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107f6a:	83 e2 f0             	and    $0xfffffff0,%edx
80107f6d:	83 ca 02             	or     $0x2,%edx
80107f70:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f79:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107f7f:	83 ca 10             	or     $0x10,%edx
80107f82:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107f91:	83 ca 60             	or     $0x60,%edx
80107f94:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9d:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107fa3:	83 ca 80             	or     $0xffffff80,%edx
80107fa6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faf:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107fb5:	83 ca 0f             	or     $0xf,%edx
80107fb8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107fc7:	83 e2 ef             	and    $0xffffffef,%edx
80107fca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107fd9:	83 e2 df             	and    $0xffffffdf,%edx
80107fdc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107feb:	83 ca 40             	or     $0x40,%edx
80107fee:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107ffd:	83 ca 80             	or     $0xffffff80,%edx
80108000:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108009:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80108010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108013:	83 c0 70             	add    $0x70,%eax
80108016:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010801d:	00 
8010801e:	89 04 24             	mov    %eax,(%esp)
80108021:	e8 7e fc ff ff       	call   80107ca4 <lgdt>
}
80108026:	c9                   	leave  
80108027:	c3                   	ret    

80108028 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108028:	55                   	push   %ebp
80108029:	89 e5                	mov    %esp,%ebp
8010802b:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010802e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108031:	c1 e8 16             	shr    $0x16,%eax
80108034:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010803b:	8b 45 08             	mov    0x8(%ebp),%eax
8010803e:	01 d0                	add    %edx,%eax
80108040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108046:	8b 00                	mov    (%eax),%eax
80108048:	83 e0 01             	and    $0x1,%eax
8010804b:	85 c0                	test   %eax,%eax
8010804d:	74 14                	je     80108063 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010804f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108052:	8b 00                	mov    (%eax),%eax
80108054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108059:	05 00 00 00 80       	add    $0x80000000,%eax
8010805e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108061:	eb 48                	jmp    801080ab <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108067:	74 0e                	je     80108077 <walkpgdir+0x4f>
80108069:	e8 a5 ad ff ff       	call   80102e13 <kalloc>
8010806e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108075:	75 07                	jne    8010807e <walkpgdir+0x56>
      return 0;
80108077:	b8 00 00 00 00       	mov    $0x0,%eax
8010807c:	eb 44                	jmp    801080c2 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010807e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108085:	00 
80108086:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010808d:	00 
8010808e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108091:	89 04 24             	mov    %eax,(%esp)
80108094:	e8 ad d1 ff ff       	call   80105246 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	05 00 00 00 80       	add    $0x80000000,%eax
801080a1:	83 c8 07             	or     $0x7,%eax
801080a4:	89 c2                	mov    %eax,%edx
801080a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080a9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ae:	c1 e8 0c             	shr    $0xc,%eax
801080b1:	25 ff 03 00 00       	and    $0x3ff,%eax
801080b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	01 d0                	add    %edx,%eax
}
801080c2:	c9                   	leave  
801080c3:	c3                   	ret    

801080c4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801080c4:	55                   	push   %ebp
801080c5:	89 e5                	mov    %esp,%ebp
801080c7:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801080ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801080cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801080d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801080d8:	8b 45 10             	mov    0x10(%ebp),%eax
801080db:	01 d0                	add    %edx,%eax
801080dd:	48                   	dec    %eax
801080de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801080e6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801080ed:	00 
801080ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801080f5:	8b 45 08             	mov    0x8(%ebp),%eax
801080f8:	89 04 24             	mov    %eax,(%esp)
801080fb:	e8 28 ff ff ff       	call   80108028 <walkpgdir>
80108100:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108103:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108107:	75 07                	jne    80108110 <mappages+0x4c>
      return -1;
80108109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010810e:	eb 48                	jmp    80108158 <mappages+0x94>
    if(*pte & PTE_P)
80108110:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108113:	8b 00                	mov    (%eax),%eax
80108115:	83 e0 01             	and    $0x1,%eax
80108118:	85 c0                	test   %eax,%eax
8010811a:	74 0c                	je     80108128 <mappages+0x64>
      panic("remap");
8010811c:	c7 04 24 b0 94 10 80 	movl   $0x801094b0,(%esp)
80108123:	e8 85 85 ff ff       	call   801006ad <panic>
    *pte = pa | perm | PTE_P;
80108128:	8b 45 18             	mov    0x18(%ebp),%eax
8010812b:	0b 45 14             	or     0x14(%ebp),%eax
8010812e:	83 c8 01             	or     $0x1,%eax
80108131:	89 c2                	mov    %eax,%edx
80108133:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108136:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010813e:	75 08                	jne    80108148 <mappages+0x84>
      break;
80108140:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108141:	b8 00 00 00 00       	mov    $0x0,%eax
80108146:	eb 10                	jmp    80108158 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108148:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010814f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108156:	eb 8e                	jmp    801080e6 <mappages+0x22>
  return 0;
}
80108158:	c9                   	leave  
80108159:	c3                   	ret    

8010815a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010815a:	55                   	push   %ebp
8010815b:	89 e5                	mov    %esp,%ebp
8010815d:	53                   	push   %ebx
8010815e:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108161:	e8 ad ac ff ff       	call   80102e13 <kalloc>
80108166:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010816d:	75 0a                	jne    80108179 <setupkvm+0x1f>
    return 0;
8010816f:	b8 00 00 00 00       	mov    $0x0,%eax
80108174:	e9 84 00 00 00       	jmp    801081fd <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80108179:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108180:	00 
80108181:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108188:	00 
80108189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818c:	89 04 24             	mov    %eax,(%esp)
8010818f:	e8 b2 d0 ff ff       	call   80105246 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108194:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010819b:	eb 54                	jmp    801081f1 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010819d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a0:	8b 48 0c             	mov    0xc(%eax),%ecx
801081a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a6:	8b 50 04             	mov    0x4(%eax),%edx
801081a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ac:	8b 58 08             	mov    0x8(%eax),%ebx
801081af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b2:	8b 40 04             	mov    0x4(%eax),%eax
801081b5:	29 c3                	sub    %eax,%ebx
801081b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ba:	8b 00                	mov    (%eax),%eax
801081bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801081c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801081c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801081c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801081cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cf:	89 04 24             	mov    %eax,(%esp)
801081d2:	e8 ed fe ff ff       	call   801080c4 <mappages>
801081d7:	85 c0                	test   %eax,%eax
801081d9:	79 12                	jns    801081ed <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801081db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081de:	89 04 24             	mov    %eax,(%esp)
801081e1:	e8 1a 05 00 00       	call   80108700 <freevm>
      return 0;
801081e6:	b8 00 00 00 00       	mov    $0x0,%eax
801081eb:	eb 10                	jmp    801081fd <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081ed:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801081f1:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801081f8:	72 a3                	jb     8010819d <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
801081fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801081fd:	83 c4 34             	add    $0x34,%esp
80108200:	5b                   	pop    %ebx
80108201:	5d                   	pop    %ebp
80108202:	c3                   	ret    

80108203 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108203:	55                   	push   %ebp
80108204:	89 e5                	mov    %esp,%ebp
80108206:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108209:	e8 4c ff ff ff       	call   8010815a <setupkvm>
8010820e:	a3 c4 79 11 80       	mov    %eax,0x801179c4
  switchkvm();
80108213:	e8 02 00 00 00       	call   8010821a <switchkvm>
}
80108218:	c9                   	leave  
80108219:	c3                   	ret    

8010821a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010821a:	55                   	push   %ebp
8010821b:	89 e5                	mov    %esp,%ebp
8010821d:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108220:	a1 c4 79 11 80       	mov    0x801179c4,%eax
80108225:	05 00 00 00 80       	add    $0x80000000,%eax
8010822a:	89 04 24             	mov    %eax,(%esp)
8010822d:	e8 ae fa ff ff       	call   80107ce0 <lcr3>
}
80108232:	c9                   	leave  
80108233:	c3                   	ret    

80108234 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108234:	55                   	push   %ebp
80108235:	89 e5                	mov    %esp,%ebp
80108237:	57                   	push   %edi
80108238:	56                   	push   %esi
80108239:	53                   	push   %ebx
8010823a:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
8010823d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108241:	75 0c                	jne    8010824f <switchuvm+0x1b>
    panic("switchuvm: no process");
80108243:	c7 04 24 b6 94 10 80 	movl   $0x801094b6,(%esp)
8010824a:	e8 5e 84 ff ff       	call   801006ad <panic>
  if(p->kstack == 0)
8010824f:	8b 45 08             	mov    0x8(%ebp),%eax
80108252:	8b 40 08             	mov    0x8(%eax),%eax
80108255:	85 c0                	test   %eax,%eax
80108257:	75 0c                	jne    80108265 <switchuvm+0x31>
    panic("switchuvm: no kstack");
80108259:	c7 04 24 cc 94 10 80 	movl   $0x801094cc,(%esp)
80108260:	e8 48 84 ff ff       	call   801006ad <panic>
  if(p->pgdir == 0)
80108265:	8b 45 08             	mov    0x8(%ebp),%eax
80108268:	8b 40 04             	mov    0x4(%eax),%eax
8010826b:	85 c0                	test   %eax,%eax
8010826d:	75 0c                	jne    8010827b <switchuvm+0x47>
    panic("switchuvm: no pgdir");
8010826f:	c7 04 24 e1 94 10 80 	movl   $0x801094e1,(%esp)
80108276:	e8 32 84 ff ff       	call   801006ad <panic>

  pushcli();
8010827b:	e8 c2 ce ff ff       	call   80105142 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108280:	e8 ca c0 ff ff       	call   8010434f <mycpu>
80108285:	89 c3                	mov    %eax,%ebx
80108287:	e8 c3 c0 ff ff       	call   8010434f <mycpu>
8010828c:	83 c0 08             	add    $0x8,%eax
8010828f:	89 c6                	mov    %eax,%esi
80108291:	e8 b9 c0 ff ff       	call   8010434f <mycpu>
80108296:	83 c0 08             	add    $0x8,%eax
80108299:	c1 e8 10             	shr    $0x10,%eax
8010829c:	89 c7                	mov    %eax,%edi
8010829e:	e8 ac c0 ff ff       	call   8010434f <mycpu>
801082a3:	83 c0 08             	add    $0x8,%eax
801082a6:	c1 e8 18             	shr    $0x18,%eax
801082a9:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801082b0:	67 00 
801082b2:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801082b9:	89 f9                	mov    %edi,%ecx
801082bb:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801082c1:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801082c7:	83 e2 f0             	and    $0xfffffff0,%edx
801082ca:	83 ca 09             	or     $0x9,%edx
801082cd:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801082d3:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801082d9:	83 ca 10             	or     $0x10,%edx
801082dc:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801082e2:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801082e8:	83 e2 9f             	and    $0xffffff9f,%edx
801082eb:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801082f1:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801082f7:	83 ca 80             	or     $0xffffff80,%edx
801082fa:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108300:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108306:	83 e2 f0             	and    $0xfffffff0,%edx
80108309:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010830f:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108315:	83 e2 ef             	and    $0xffffffef,%edx
80108318:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010831e:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108324:	83 e2 df             	and    $0xffffffdf,%edx
80108327:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010832d:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108333:	83 ca 40             	or     $0x40,%edx
80108336:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010833c:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108342:	83 e2 7f             	and    $0x7f,%edx
80108345:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010834b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108351:	e8 f9 bf ff ff       	call   8010434f <mycpu>
80108356:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010835c:	83 e2 ef             	and    $0xffffffef,%edx
8010835f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108365:	e8 e5 bf ff ff       	call   8010434f <mycpu>
8010836a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108370:	e8 da bf ff ff       	call   8010434f <mycpu>
80108375:	8b 55 08             	mov    0x8(%ebp),%edx
80108378:	8b 52 08             	mov    0x8(%edx),%edx
8010837b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108381:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108384:	e8 c6 bf ff ff       	call   8010434f <mycpu>
80108389:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
8010838f:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80108396:	e8 30 f9 ff ff       	call   80107ccb <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010839b:	8b 45 08             	mov    0x8(%ebp),%eax
8010839e:	8b 40 04             	mov    0x4(%eax),%eax
801083a1:	05 00 00 00 80       	add    $0x80000000,%eax
801083a6:	89 04 24             	mov    %eax,(%esp)
801083a9:	e8 32 f9 ff ff       	call   80107ce0 <lcr3>
  popcli();
801083ae:	e8 d9 cd ff ff       	call   8010518c <popcli>
}
801083b3:	83 c4 1c             	add    $0x1c,%esp
801083b6:	5b                   	pop    %ebx
801083b7:	5e                   	pop    %esi
801083b8:	5f                   	pop    %edi
801083b9:	5d                   	pop    %ebp
801083ba:	c3                   	ret    

801083bb <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801083bb:	55                   	push   %ebp
801083bc:	89 e5                	mov    %esp,%ebp
801083be:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
801083c1:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801083c8:	76 0c                	jbe    801083d6 <inituvm+0x1b>
    panic("inituvm: more than a page");
801083ca:	c7 04 24 f5 94 10 80 	movl   $0x801094f5,(%esp)
801083d1:	e8 d7 82 ff ff       	call   801006ad <panic>
  mem = kalloc();
801083d6:	e8 38 aa ff ff       	call   80102e13 <kalloc>
801083db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801083de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083e5:	00 
801083e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083ed:	00 
801083ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f1:	89 04 24             	mov    %eax,(%esp)
801083f4:	e8 4d ce ff ff       	call   80105246 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801083f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083fc:	05 00 00 00 80       	add    $0x80000000,%eax
80108401:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108408:	00 
80108409:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010840d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108414:	00 
80108415:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010841c:	00 
8010841d:	8b 45 08             	mov    0x8(%ebp),%eax
80108420:	89 04 24             	mov    %eax,(%esp)
80108423:	e8 9c fc ff ff       	call   801080c4 <mappages>
  memmove(mem, init, sz);
80108428:	8b 45 10             	mov    0x10(%ebp),%eax
8010842b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010842f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108432:	89 44 24 04          	mov    %eax,0x4(%esp)
80108436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108439:	89 04 24             	mov    %eax,(%esp)
8010843c:	e8 ce ce ff ff       	call   8010530f <memmove>
}
80108441:	c9                   	leave  
80108442:	c3                   	ret    

80108443 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108443:	55                   	push   %ebp
80108444:	89 e5                	mov    %esp,%ebp
80108446:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108451:	85 c0                	test   %eax,%eax
80108453:	74 0c                	je     80108461 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80108455:	c7 04 24 10 95 10 80 	movl   $0x80109510,(%esp)
8010845c:	e8 4c 82 ff ff       	call   801006ad <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108461:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108468:	e9 a6 00 00 00       	jmp    80108513 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010846d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108470:	8b 55 0c             	mov    0xc(%ebp),%edx
80108473:	01 d0                	add    %edx,%eax
80108475:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010847c:	00 
8010847d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108481:	8b 45 08             	mov    0x8(%ebp),%eax
80108484:	89 04 24             	mov    %eax,(%esp)
80108487:	e8 9c fb ff ff       	call   80108028 <walkpgdir>
8010848c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010848f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108493:	75 0c                	jne    801084a1 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80108495:	c7 04 24 33 95 10 80 	movl   $0x80109533,(%esp)
8010849c:	e8 0c 82 ff ff       	call   801006ad <panic>
    pa = PTE_ADDR(*pte);
801084a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084a4:	8b 00                	mov    (%eax),%eax
801084a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801084ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b1:	8b 55 18             	mov    0x18(%ebp),%edx
801084b4:	29 c2                	sub    %eax,%edx
801084b6:	89 d0                	mov    %edx,%eax
801084b8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801084bd:	77 0f                	ja     801084ce <loaduvm+0x8b>
      n = sz - i;
801084bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c2:	8b 55 18             	mov    0x18(%ebp),%edx
801084c5:	29 c2                	sub    %eax,%edx
801084c7:	89 d0                	mov    %edx,%eax
801084c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084cc:	eb 07                	jmp    801084d5 <loaduvm+0x92>
    else
      n = PGSIZE;
801084ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801084d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d8:	8b 55 14             	mov    0x14(%ebp),%edx
801084db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801084de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084e1:	05 00 00 00 80       	add    $0x80000000,%eax
801084e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801084e9:	89 54 24 0c          	mov    %edx,0xc(%esp)
801084ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801084f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801084f5:	8b 45 10             	mov    0x10(%ebp),%eax
801084f8:	89 04 24             	mov    %eax,(%esp)
801084fb:	e8 79 9b ff ff       	call   80102079 <readi>
80108500:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108503:	74 07                	je     8010850c <loaduvm+0xc9>
      return -1;
80108505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010850a:	eb 18                	jmp    80108524 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010850c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108516:	3b 45 18             	cmp    0x18(%ebp),%eax
80108519:	0f 82 4e ff ff ff    	jb     8010846d <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010851f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108524:	c9                   	leave  
80108525:	c3                   	ret    

80108526 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108526:	55                   	push   %ebp
80108527:	89 e5                	mov    %esp,%ebp
80108529:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010852c:	8b 45 10             	mov    0x10(%ebp),%eax
8010852f:	85 c0                	test   %eax,%eax
80108531:	79 0a                	jns    8010853d <allocuvm+0x17>
    return 0;
80108533:	b8 00 00 00 00       	mov    $0x0,%eax
80108538:	e9 fd 00 00 00       	jmp    8010863a <allocuvm+0x114>
  if(newsz < oldsz)
8010853d:	8b 45 10             	mov    0x10(%ebp),%eax
80108540:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108543:	73 08                	jae    8010854d <allocuvm+0x27>
    return oldsz;
80108545:	8b 45 0c             	mov    0xc(%ebp),%eax
80108548:	e9 ed 00 00 00       	jmp    8010863a <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
8010854d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108550:	05 ff 0f 00 00       	add    $0xfff,%eax
80108555:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010855a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010855d:	e9 c9 00 00 00       	jmp    8010862b <allocuvm+0x105>
    mem = kalloc();
80108562:	e8 ac a8 ff ff       	call   80102e13 <kalloc>
80108567:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010856a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010856e:	75 2f                	jne    8010859f <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80108570:	c7 04 24 51 95 10 80 	movl   $0x80109551,(%esp)
80108577:	e8 9e 7f ff ff       	call   8010051a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010857c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010857f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108583:	8b 45 10             	mov    0x10(%ebp),%eax
80108586:	89 44 24 04          	mov    %eax,0x4(%esp)
8010858a:	8b 45 08             	mov    0x8(%ebp),%eax
8010858d:	89 04 24             	mov    %eax,(%esp)
80108590:	e8 a7 00 00 00       	call   8010863c <deallocuvm>
      return 0;
80108595:	b8 00 00 00 00       	mov    $0x0,%eax
8010859a:	e9 9b 00 00 00       	jmp    8010863a <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
8010859f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085a6:	00 
801085a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801085ae:	00 
801085af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085b2:	89 04 24             	mov    %eax,(%esp)
801085b5:	e8 8c cc ff ff       	call   80105246 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801085ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085bd:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801085c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c6:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801085cd:	00 
801085ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
801085d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085d9:	00 
801085da:	89 44 24 04          	mov    %eax,0x4(%esp)
801085de:	8b 45 08             	mov    0x8(%ebp),%eax
801085e1:	89 04 24             	mov    %eax,(%esp)
801085e4:	e8 db fa ff ff       	call   801080c4 <mappages>
801085e9:	85 c0                	test   %eax,%eax
801085eb:	79 37                	jns    80108624 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
801085ed:	c7 04 24 69 95 10 80 	movl   $0x80109569,(%esp)
801085f4:	e8 21 7f ff ff       	call   8010051a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801085f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801085fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80108600:	8b 45 10             	mov    0x10(%ebp),%eax
80108603:	89 44 24 04          	mov    %eax,0x4(%esp)
80108607:	8b 45 08             	mov    0x8(%ebp),%eax
8010860a:	89 04 24             	mov    %eax,(%esp)
8010860d:	e8 2a 00 00 00       	call   8010863c <deallocuvm>
      kfree(mem);
80108612:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108615:	89 04 24             	mov    %eax,(%esp)
80108618:	e8 60 a7 ff ff       	call   80102d7d <kfree>
      return 0;
8010861d:	b8 00 00 00 00       	mov    $0x0,%eax
80108622:	eb 16                	jmp    8010863a <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108624:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010862b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010862e:	3b 45 10             	cmp    0x10(%ebp),%eax
80108631:	0f 82 2b ff ff ff    	jb     80108562 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80108637:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010863a:	c9                   	leave  
8010863b:	c3                   	ret    

8010863c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010863c:	55                   	push   %ebp
8010863d:	89 e5                	mov    %esp,%ebp
8010863f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108642:	8b 45 10             	mov    0x10(%ebp),%eax
80108645:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108648:	72 08                	jb     80108652 <deallocuvm+0x16>
    return oldsz;
8010864a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010864d:	e9 ac 00 00 00       	jmp    801086fe <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80108652:	8b 45 10             	mov    0x10(%ebp),%eax
80108655:	05 ff 0f 00 00       	add    $0xfff,%eax
8010865a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010865f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108662:	e9 88 00 00 00       	jmp    801086ef <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010866a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108671:	00 
80108672:	89 44 24 04          	mov    %eax,0x4(%esp)
80108676:	8b 45 08             	mov    0x8(%ebp),%eax
80108679:	89 04 24             	mov    %eax,(%esp)
8010867c:	e8 a7 f9 ff ff       	call   80108028 <walkpgdir>
80108681:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108684:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108688:	75 14                	jne    8010869e <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010868a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868d:	c1 e8 16             	shr    $0x16,%eax
80108690:	40                   	inc    %eax
80108691:	c1 e0 16             	shl    $0x16,%eax
80108694:	2d 00 10 00 00       	sub    $0x1000,%eax
80108699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010869c:	eb 4a                	jmp    801086e8 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
8010869e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a1:	8b 00                	mov    (%eax),%eax
801086a3:	83 e0 01             	and    $0x1,%eax
801086a6:	85 c0                	test   %eax,%eax
801086a8:	74 3e                	je     801086e8 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801086aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ad:	8b 00                	mov    (%eax),%eax
801086af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801086b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086bb:	75 0c                	jne    801086c9 <deallocuvm+0x8d>
        panic("kfree");
801086bd:	c7 04 24 85 95 10 80 	movl   $0x80109585,(%esp)
801086c4:	e8 e4 7f ff ff       	call   801006ad <panic>
      char *v = P2V(pa);
801086c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086cc:	05 00 00 00 80       	add    $0x80000000,%eax
801086d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801086d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086d7:	89 04 24             	mov    %eax,(%esp)
801086da:	e8 9e a6 ff ff       	call   80102d7d <kfree>
      *pte = 0;
801086df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801086e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086f5:	0f 82 6c ff ff ff    	jb     80108667 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801086fb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801086fe:	c9                   	leave  
801086ff:	c3                   	ret    

80108700 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108700:	55                   	push   %ebp
80108701:	89 e5                	mov    %esp,%ebp
80108703:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108706:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010870a:	75 0c                	jne    80108718 <freevm+0x18>
    panic("freevm: no pgdir");
8010870c:	c7 04 24 8b 95 10 80 	movl   $0x8010958b,(%esp)
80108713:	e8 95 7f ff ff       	call   801006ad <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108718:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010871f:	00 
80108720:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108727:	80 
80108728:	8b 45 08             	mov    0x8(%ebp),%eax
8010872b:	89 04 24             	mov    %eax,(%esp)
8010872e:	e8 09 ff ff ff       	call   8010863c <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010873a:	eb 44                	jmp    80108780 <freevm+0x80>
    if(pgdir[i] & PTE_P){
8010873c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108746:	8b 45 08             	mov    0x8(%ebp),%eax
80108749:	01 d0                	add    %edx,%eax
8010874b:	8b 00                	mov    (%eax),%eax
8010874d:	83 e0 01             	and    $0x1,%eax
80108750:	85 c0                	test   %eax,%eax
80108752:	74 29                	je     8010877d <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108757:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010875e:	8b 45 08             	mov    0x8(%ebp),%eax
80108761:	01 d0                	add    %edx,%eax
80108763:	8b 00                	mov    (%eax),%eax
80108765:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010876a:	05 00 00 00 80       	add    $0x80000000,%eax
8010876f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108775:	89 04 24             	mov    %eax,(%esp)
80108778:	e8 00 a6 ff ff       	call   80102d7d <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010877d:	ff 45 f4             	incl   -0xc(%ebp)
80108780:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108787:	76 b3                	jbe    8010873c <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108789:	8b 45 08             	mov    0x8(%ebp),%eax
8010878c:	89 04 24             	mov    %eax,(%esp)
8010878f:	e8 e9 a5 ff ff       	call   80102d7d <kfree>
}
80108794:	c9                   	leave  
80108795:	c3                   	ret    

80108796 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108796:	55                   	push   %ebp
80108797:	89 e5                	mov    %esp,%ebp
80108799:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010879c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087a3:	00 
801087a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801087a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801087ab:	8b 45 08             	mov    0x8(%ebp),%eax
801087ae:	89 04 24             	mov    %eax,(%esp)
801087b1:	e8 72 f8 ff ff       	call   80108028 <walkpgdir>
801087b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801087b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801087bd:	75 0c                	jne    801087cb <clearpteu+0x35>
    panic("clearpteu");
801087bf:	c7 04 24 9c 95 10 80 	movl   $0x8010959c,(%esp)
801087c6:	e8 e2 7e ff ff       	call   801006ad <panic>
  *pte &= ~PTE_U;
801087cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ce:	8b 00                	mov    (%eax),%eax
801087d0:	83 e0 fb             	and    $0xfffffffb,%eax
801087d3:	89 c2                	mov    %eax,%edx
801087d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d8:	89 10                	mov    %edx,(%eax)
}
801087da:	c9                   	leave  
801087db:	c3                   	ret    

801087dc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801087dc:	55                   	push   %ebp
801087dd:	89 e5                	mov    %esp,%ebp
801087df:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801087e2:	e8 73 f9 ff ff       	call   8010815a <setupkvm>
801087e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087ee:	75 0a                	jne    801087fa <copyuvm+0x1e>
    return 0;
801087f0:	b8 00 00 00 00       	mov    $0x0,%eax
801087f5:	e9 f8 00 00 00       	jmp    801088f2 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
801087fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108801:	e9 cb 00 00 00       	jmp    801088d1 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108809:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108810:	00 
80108811:	89 44 24 04          	mov    %eax,0x4(%esp)
80108815:	8b 45 08             	mov    0x8(%ebp),%eax
80108818:	89 04 24             	mov    %eax,(%esp)
8010881b:	e8 08 f8 ff ff       	call   80108028 <walkpgdir>
80108820:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108823:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108827:	75 0c                	jne    80108835 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108829:	c7 04 24 a6 95 10 80 	movl   $0x801095a6,(%esp)
80108830:	e8 78 7e ff ff       	call   801006ad <panic>
    if(!(*pte & PTE_P))
80108835:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108838:	8b 00                	mov    (%eax),%eax
8010883a:	83 e0 01             	and    $0x1,%eax
8010883d:	85 c0                	test   %eax,%eax
8010883f:	75 0c                	jne    8010884d <copyuvm+0x71>
      panic("copyuvm: page not present");
80108841:	c7 04 24 c0 95 10 80 	movl   $0x801095c0,(%esp)
80108848:	e8 60 7e ff ff       	call   801006ad <panic>
    pa = PTE_ADDR(*pte);
8010884d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108850:	8b 00                	mov    (%eax),%eax
80108852:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108857:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010885a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010885d:	8b 00                	mov    (%eax),%eax
8010885f:	25 ff 0f 00 00       	and    $0xfff,%eax
80108864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108867:	e8 a7 a5 ff ff       	call   80102e13 <kalloc>
8010886c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010886f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108873:	75 02                	jne    80108877 <copyuvm+0x9b>
      goto bad;
80108875:	eb 6b                	jmp    801088e2 <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108877:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010887a:	05 00 00 00 80       	add    $0x80000000,%eax
8010887f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108886:	00 
80108887:	89 44 24 04          	mov    %eax,0x4(%esp)
8010888b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010888e:	89 04 24             	mov    %eax,(%esp)
80108891:	e8 79 ca ff ff       	call   8010530f <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108896:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108899:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010889c:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801088a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a5:	89 54 24 10          	mov    %edx,0x10(%esp)
801088a9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801088ad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088b4:	00 
801088b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801088b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088bc:	89 04 24             	mov    %eax,(%esp)
801088bf:	e8 00 f8 ff ff       	call   801080c4 <mappages>
801088c4:	85 c0                	test   %eax,%eax
801088c6:	79 02                	jns    801088ca <copyuvm+0xee>
      goto bad;
801088c8:	eb 18                	jmp    801088e2 <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801088ca:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088d7:	0f 82 29 ff ff ff    	jb     80108806 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
801088dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e0:	eb 10                	jmp    801088f2 <copyuvm+0x116>

bad:
  freevm(d);
801088e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e5:	89 04 24             	mov    %eax,(%esp)
801088e8:	e8 13 fe ff ff       	call   80108700 <freevm>
  return 0;
801088ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088f2:	c9                   	leave  
801088f3:	c3                   	ret    

801088f4 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801088f4:	55                   	push   %ebp
801088f5:	89 e5                	mov    %esp,%ebp
801088f7:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108901:	00 
80108902:	8b 45 0c             	mov    0xc(%ebp),%eax
80108905:	89 44 24 04          	mov    %eax,0x4(%esp)
80108909:	8b 45 08             	mov    0x8(%ebp),%eax
8010890c:	89 04 24             	mov    %eax,(%esp)
8010890f:	e8 14 f7 ff ff       	call   80108028 <walkpgdir>
80108914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891a:	8b 00                	mov    (%eax),%eax
8010891c:	83 e0 01             	and    $0x1,%eax
8010891f:	85 c0                	test   %eax,%eax
80108921:	75 07                	jne    8010892a <uva2ka+0x36>
    return 0;
80108923:	b8 00 00 00 00       	mov    $0x0,%eax
80108928:	eb 22                	jmp    8010894c <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010892a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892d:	8b 00                	mov    (%eax),%eax
8010892f:	83 e0 04             	and    $0x4,%eax
80108932:	85 c0                	test   %eax,%eax
80108934:	75 07                	jne    8010893d <uva2ka+0x49>
    return 0;
80108936:	b8 00 00 00 00       	mov    $0x0,%eax
8010893b:	eb 0f                	jmp    8010894c <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
8010893d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108940:	8b 00                	mov    (%eax),%eax
80108942:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108947:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010894c:	c9                   	leave  
8010894d:	c3                   	ret    

8010894e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010894e:	55                   	push   %ebp
8010894f:	89 e5                	mov    %esp,%ebp
80108951:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108954:	8b 45 10             	mov    0x10(%ebp),%eax
80108957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010895a:	e9 87 00 00 00       	jmp    801089e6 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010895f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108967:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010896a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010896d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108971:	8b 45 08             	mov    0x8(%ebp),%eax
80108974:	89 04 24             	mov    %eax,(%esp)
80108977:	e8 78 ff ff ff       	call   801088f4 <uva2ka>
8010897c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010897f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108983:	75 07                	jne    8010898c <copyout+0x3e>
      return -1;
80108985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010898a:	eb 69                	jmp    801089f5 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010898c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010898f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108992:	29 c2                	sub    %eax,%edx
80108994:	89 d0                	mov    %edx,%eax
80108996:	05 00 10 00 00       	add    $0x1000,%eax
8010899b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010899e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089a1:	3b 45 14             	cmp    0x14(%ebp),%eax
801089a4:	76 06                	jbe    801089ac <copyout+0x5e>
      n = len;
801089a6:	8b 45 14             	mov    0x14(%ebp),%eax
801089a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801089ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089af:	8b 55 0c             	mov    0xc(%ebp),%edx
801089b2:	29 c2                	sub    %eax,%edx
801089b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089b7:	01 c2                	add    %eax,%edx
801089b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801089c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801089c7:	89 14 24             	mov    %edx,(%esp)
801089ca:	e8 40 c9 ff ff       	call   8010530f <memmove>
    len -= n;
801089cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089d2:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801089d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089d8:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801089db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089de:	05 00 10 00 00       	add    $0x1000,%eax
801089e3:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801089e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801089ea:	0f 85 6f ff ff ff    	jne    8010895f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801089f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089f5:	c9                   	leave  
801089f6:	c3                   	ret    
	...

801089f8 <strcmp>:

#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
801089f8:	55                   	push   %ebp
801089f9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
801089fb:	eb 06                	jmp    80108a03 <strcmp+0xb>
    p++, q++;
801089fd:	ff 45 08             	incl   0x8(%ebp)
80108a00:	ff 45 0c             	incl   0xc(%ebp)
#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80108a03:	8b 45 08             	mov    0x8(%ebp),%eax
80108a06:	8a 00                	mov    (%eax),%al
80108a08:	84 c0                	test   %al,%al
80108a0a:	74 0e                	je     80108a1a <strcmp+0x22>
80108a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80108a0f:	8a 10                	mov    (%eax),%dl
80108a11:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a14:	8a 00                	mov    (%eax),%al
80108a16:	38 c2                	cmp    %al,%dl
80108a18:	74 e3                	je     801089fd <strcmp+0x5>
    p++, q++;
  return (char)*p - (char)*q;
80108a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80108a1d:	8a 00                	mov    (%eax),%al
80108a1f:	0f be d0             	movsbl %al,%edx
80108a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a25:	8a 00                	mov    (%eax),%al
80108a27:	0f be c0             	movsbl %al,%eax
80108a2a:	29 c2                	sub    %eax,%edx
80108a2c:	89 d0                	mov    %edx,%eax
}
80108a2e:	5d                   	pop    %ebp
80108a2f:	c3                   	ret    

80108a30 <getname>:

int getname(int index, char* name){
80108a30:	55                   	push   %ebp
80108a31:	89 e5                	mov    %esp,%ebp
80108a33:	53                   	push   %ebx
80108a34:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108a37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((*name++ = cabinet.tuperwares[index].name[i++]) != 0);
80108a3e:	90                   	nop
80108a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a42:	8d 42 01             	lea    0x1(%edx),%eax
80108a45:	89 45 0c             	mov    %eax,0xc(%ebp)
80108a48:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80108a4b:	8d 43 01             	lea    0x1(%ebx),%eax
80108a4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108a51:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108a54:	89 c8                	mov    %ecx,%eax
80108a56:	c1 e0 02             	shl    $0x2,%eax
80108a59:	01 c8                	add    %ecx,%eax
80108a5b:	01 c0                	add    %eax,%eax
80108a5d:	01 c8                	add    %ecx,%eax
80108a5f:	01 c0                	add    %eax,%eax
80108a61:	01 c8                	add    %ecx,%eax
80108a63:	c1 e0 02             	shl    $0x2,%eax
80108a66:	01 d8                	add    %ebx,%eax
80108a68:	05 80 20 11 80       	add    $0x80112080,%eax
80108a6d:	8a 00                	mov    (%eax),%al
80108a6f:	88 02                	mov    %al,(%edx)
80108a71:	8a 02                	mov    (%edx),%al
80108a73:	84 c0                	test   %al,%al
80108a75:	75 c8                	jne    80108a3f <getname+0xf>

    return 0;
80108a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a7c:	83 c4 10             	add    $0x10,%esp
80108a7f:	5b                   	pop    %ebx
80108a80:	5d                   	pop    %ebp
80108a81:	c3                   	ret    

80108a82 <setname>:

int setname(int index, char* name){
80108a82:	55                   	push   %ebp
80108a83:	89 e5                	mov    %esp,%ebp
80108a85:	53                   	push   %ebx
80108a86:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108a89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].name[i++] = *name++) != 0);
80108a90:	90                   	nop
80108a91:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108a94:	8d 42 01             	lea    0x1(%edx),%eax
80108a97:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a9d:	8d 48 01             	lea    0x1(%eax),%ecx
80108aa0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108aa3:	8a 18                	mov    (%eax),%bl
80108aa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108aa8:	89 c8                	mov    %ecx,%eax
80108aaa:	c1 e0 02             	shl    $0x2,%eax
80108aad:	01 c8                	add    %ecx,%eax
80108aaf:	01 c0                	add    %eax,%eax
80108ab1:	01 c8                	add    %ecx,%eax
80108ab3:	01 c0                	add    %eax,%eax
80108ab5:	01 c8                	add    %ecx,%eax
80108ab7:	c1 e0 02             	shl    $0x2,%eax
80108aba:	01 d0                	add    %edx,%eax
80108abc:	05 80 20 11 80       	add    $0x80112080,%eax
80108ac1:	88 18                	mov    %bl,(%eax)
80108ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108ac6:	89 c8                	mov    %ecx,%eax
80108ac8:	c1 e0 02             	shl    $0x2,%eax
80108acb:	01 c8                	add    %ecx,%eax
80108acd:	01 c0                	add    %eax,%eax
80108acf:	01 c8                	add    %ecx,%eax
80108ad1:	01 c0                	add    %eax,%eax
80108ad3:	01 c8                	add    %ecx,%eax
80108ad5:	c1 e0 02             	shl    $0x2,%eax
80108ad8:	01 d0                	add    %edx,%eax
80108ada:	05 80 20 11 80       	add    $0x80112080,%eax
80108adf:	8a 00                	mov    (%eax),%al
80108ae1:	84 c0                	test   %al,%al
80108ae3:	75 ac                	jne    80108a91 <setname+0xf>

    return 0;
80108ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108aea:	83 c4 10             	add    $0x10,%esp
80108aed:	5b                   	pop    %ebx
80108aee:	5d                   	pop    %ebp
80108aef:	c3                   	ret    

80108af0 <getmaxproc>:

int getmaxproc(int index){
80108af0:	55                   	push   %ebp
80108af1:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_proc;
80108af3:	8b 55 08             	mov    0x8(%ebp),%edx
80108af6:	89 d0                	mov    %edx,%eax
80108af8:	c1 e0 02             	shl    $0x2,%eax
80108afb:	01 d0                	add    %edx,%eax
80108afd:	01 c0                	add    %eax,%eax
80108aff:	01 d0                	add    %edx,%eax
80108b01:	01 c0                	add    %eax,%eax
80108b03:	01 d0                	add    %edx,%eax
80108b05:	c1 e0 02             	shl    $0x2,%eax
80108b08:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108b0d:	8b 40 08             	mov    0x8(%eax),%eax
}
80108b10:	5d                   	pop    %ebp
80108b11:	c3                   	ret    

80108b12 <setmaxproc>:

int setmaxproc(int index, int max_proc){
80108b12:	55                   	push   %ebp
80108b13:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_proc = max_proc;
80108b15:	8b 55 08             	mov    0x8(%ebp),%edx
80108b18:	89 d0                	mov    %edx,%eax
80108b1a:	c1 e0 02             	shl    $0x2,%eax
80108b1d:	01 d0                	add    %edx,%eax
80108b1f:	01 c0                	add    %eax,%eax
80108b21:	01 d0                	add    %edx,%eax
80108b23:	01 c0                	add    %eax,%eax
80108b25:	01 d0                	add    %edx,%eax
80108b27:	c1 e0 02             	shl    $0x2,%eax
80108b2a:	8d 90 c0 20 11 80    	lea    -0x7feedf40(%eax),%edx
80108b30:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b33:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b3b:	5d                   	pop    %ebp
80108b3c:	c3                   	ret    

80108b3d <getmaxmem>:

int getmaxmem(int index){
80108b3d:	55                   	push   %ebp
80108b3e:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_mem;
80108b40:	8b 55 08             	mov    0x8(%ebp),%edx
80108b43:	89 d0                	mov    %edx,%eax
80108b45:	c1 e0 02             	shl    $0x2,%eax
80108b48:	01 d0                	add    %edx,%eax
80108b4a:	01 c0                	add    %eax,%eax
80108b4c:	01 d0                	add    %edx,%eax
80108b4e:	01 c0                	add    %eax,%eax
80108b50:	01 d0                	add    %edx,%eax
80108b52:	c1 e0 02             	shl    $0x2,%eax
80108b55:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108b5a:	8b 40 0c             	mov    0xc(%eax),%eax
}
80108b5d:	5d                   	pop    %ebp
80108b5e:	c3                   	ret    

80108b5f <setmaxmem>:

int setmaxmem(int index, int max_mem){
80108b5f:	55                   	push   %ebp
80108b60:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_mem = max_mem;
80108b62:	8b 55 08             	mov    0x8(%ebp),%edx
80108b65:	89 d0                	mov    %edx,%eax
80108b67:	c1 e0 02             	shl    $0x2,%eax
80108b6a:	01 d0                	add    %edx,%eax
80108b6c:	01 c0                	add    %eax,%eax
80108b6e:	01 d0                	add    %edx,%eax
80108b70:	01 c0                	add    %eax,%eax
80108b72:	01 d0                	add    %edx,%eax
80108b74:	c1 e0 02             	shl    $0x2,%eax
80108b77:	8d 90 c0 20 11 80    	lea    -0x7feedf40(%eax),%edx
80108b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b80:	89 42 0c             	mov    %eax,0xc(%edx)
    return 0;
80108b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b88:	5d                   	pop    %ebp
80108b89:	c3                   	ret    

80108b8a <getmaxdisk>:

int getmaxdisk(int index){
80108b8a:	55                   	push   %ebp
80108b8b:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_disk;
80108b8d:	8b 55 08             	mov    0x8(%ebp),%edx
80108b90:	89 d0                	mov    %edx,%eax
80108b92:	c1 e0 02             	shl    $0x2,%eax
80108b95:	01 d0                	add    %edx,%eax
80108b97:	01 c0                	add    %eax,%eax
80108b99:	01 d0                	add    %edx,%eax
80108b9b:	01 c0                	add    %eax,%eax
80108b9d:	01 d0                	add    %edx,%eax
80108b9f:	c1 e0 02             	shl    $0x2,%eax
80108ba2:	05 d0 20 11 80       	add    $0x801120d0,%eax
80108ba7:	8b 00                	mov    (%eax),%eax
}
80108ba9:	5d                   	pop    %ebp
80108baa:	c3                   	ret    

80108bab <setmaxdisk>:

int setmaxdisk(int index, int max_disk){
80108bab:	55                   	push   %ebp
80108bac:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_disk = max_disk;
80108bae:	8b 55 08             	mov    0x8(%ebp),%edx
80108bb1:	89 d0                	mov    %edx,%eax
80108bb3:	c1 e0 02             	shl    $0x2,%eax
80108bb6:	01 d0                	add    %edx,%eax
80108bb8:	01 c0                	add    %eax,%eax
80108bba:	01 d0                	add    %edx,%eax
80108bbc:	01 c0                	add    %eax,%eax
80108bbe:	01 d0                	add    %edx,%eax
80108bc0:	c1 e0 02             	shl    $0x2,%eax
80108bc3:	8d 90 d0 20 11 80    	lea    -0x7feedf30(%eax),%edx
80108bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bcc:	89 02                	mov    %eax,(%edx)
    return 0;
80108bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bd3:	5d                   	pop    %ebp
80108bd4:	c3                   	ret    

80108bd5 <getusedmem>:

int getusedmem(int index){
80108bd5:	55                   	push   %ebp
80108bd6:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_mem;
80108bd8:	8b 55 08             	mov    0x8(%ebp),%edx
80108bdb:	89 d0                	mov    %edx,%eax
80108bdd:	c1 e0 02             	shl    $0x2,%eax
80108be0:	01 d0                	add    %edx,%eax
80108be2:	01 c0                	add    %eax,%eax
80108be4:	01 d0                	add    %edx,%eax
80108be6:	01 c0                	add    %eax,%eax
80108be8:	01 d0                	add    %edx,%eax
80108bea:	c1 e0 02             	shl    $0x2,%eax
80108bed:	05 d0 20 11 80       	add    $0x801120d0,%eax
80108bf2:	8b 40 04             	mov    0x4(%eax),%eax
}
80108bf5:	5d                   	pop    %ebp
80108bf6:	c3                   	ret    

80108bf7 <setusedmem>:

int setusedmem(int index, int used_mem){
80108bf7:	55                   	push   %ebp
80108bf8:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_mem = used_mem;
80108bfa:	8b 55 08             	mov    0x8(%ebp),%edx
80108bfd:	89 d0                	mov    %edx,%eax
80108bff:	c1 e0 02             	shl    $0x2,%eax
80108c02:	01 d0                	add    %edx,%eax
80108c04:	01 c0                	add    %eax,%eax
80108c06:	01 d0                	add    %edx,%eax
80108c08:	01 c0                	add    %eax,%eax
80108c0a:	01 d0                	add    %edx,%eax
80108c0c:	c1 e0 02             	shl    $0x2,%eax
80108c0f:	8d 90 d0 20 11 80    	lea    -0x7feedf30(%eax),%edx
80108c15:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c18:	89 42 04             	mov    %eax,0x4(%edx)
    return 0;
80108c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c20:	5d                   	pop    %ebp
80108c21:	c3                   	ret    

80108c22 <getuseddisk>:

int getuseddisk(int index){
80108c22:	55                   	push   %ebp
80108c23:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_disk;
80108c25:	8b 55 08             	mov    0x8(%ebp),%edx
80108c28:	89 d0                	mov    %edx,%eax
80108c2a:	c1 e0 02             	shl    $0x2,%eax
80108c2d:	01 d0                	add    %edx,%eax
80108c2f:	01 c0                	add    %eax,%eax
80108c31:	01 d0                	add    %edx,%eax
80108c33:	01 c0                	add    %eax,%eax
80108c35:	01 d0                	add    %edx,%eax
80108c37:	c1 e0 02             	shl    $0x2,%eax
80108c3a:	05 d0 20 11 80       	add    $0x801120d0,%eax
80108c3f:	8b 40 08             	mov    0x8(%eax),%eax
}
80108c42:	5d                   	pop    %ebp
80108c43:	c3                   	ret    

80108c44 <setuseddisk>:

int setuseddisk(int index, int used_disk){
80108c44:	55                   	push   %ebp
80108c45:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_disk = used_disk;
80108c47:	8b 55 08             	mov    0x8(%ebp),%edx
80108c4a:	89 d0                	mov    %edx,%eax
80108c4c:	c1 e0 02             	shl    $0x2,%eax
80108c4f:	01 d0                	add    %edx,%eax
80108c51:	01 c0                	add    %eax,%eax
80108c53:	01 d0                	add    %edx,%eax
80108c55:	01 c0                	add    %eax,%eax
80108c57:	01 d0                	add    %edx,%eax
80108c59:	c1 e0 02             	shl    $0x2,%eax
80108c5c:	8d 90 d0 20 11 80    	lea    -0x7feedf30(%eax),%edx
80108c62:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c65:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c6d:	5d                   	pop    %ebp
80108c6e:	c3                   	ret    

80108c6f <setvc>:

int setvc(int index, char* vc){
80108c6f:	55                   	push   %ebp
80108c70:	89 e5                	mov    %esp,%ebp
80108c72:	53                   	push   %ebx
80108c73:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108c76:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].vc[i++] = *vc++) != 0);
80108c7d:	90                   	nop
80108c7e:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108c81:	8d 42 01             	lea    0x1(%edx),%eax
80108c84:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108c87:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c8a:	8d 48 01             	lea    0x1(%eax),%ecx
80108c8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108c90:	8a 18                	mov    (%eax),%bl
80108c92:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108c95:	89 c8                	mov    %ecx,%eax
80108c97:	c1 e0 02             	shl    $0x2,%eax
80108c9a:	01 c8                	add    %ecx,%eax
80108c9c:	01 c0                	add    %eax,%eax
80108c9e:	01 c8                	add    %ecx,%eax
80108ca0:	01 c0                	add    %eax,%eax
80108ca2:	01 c8                	add    %ecx,%eax
80108ca4:	c1 e0 02             	shl    $0x2,%eax
80108ca7:	01 d0                	add    %edx,%eax
80108ca9:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108cae:	88 18                	mov    %bl,(%eax)
80108cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108cb3:	89 c8                	mov    %ecx,%eax
80108cb5:	c1 e0 02             	shl    $0x2,%eax
80108cb8:	01 c8                	add    %ecx,%eax
80108cba:	01 c0                	add    %eax,%eax
80108cbc:	01 c8                	add    %ecx,%eax
80108cbe:	01 c0                	add    %eax,%eax
80108cc0:	01 c8                	add    %ecx,%eax
80108cc2:	c1 e0 02             	shl    $0x2,%eax
80108cc5:	01 d0                	add    %edx,%eax
80108cc7:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108ccc:	8a 00                	mov    (%eax),%al
80108cce:	84 c0                	test   %al,%al
80108cd0:	75 ac                	jne    80108c7e <setvc+0xf>

    return 0;
80108cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cd7:	83 c4 10             	add    $0x10,%esp
80108cda:	5b                   	pop    %ebx
80108cdb:	5d                   	pop    %ebp
80108cdc:	c3                   	ret    

80108cdd <getvcfs>:

int getvcfs(char *vc, char *fs){
80108cdd:	55                   	push   %ebp
80108cde:	89 e5                	mov    %esp,%ebp
80108ce0:	53                   	push   %ebx
80108ce1:	83 ec 18             	sub    $0x18,%esp
    int i, j = 0;
80108ce4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(i = 0; i < NUM_VCS; i++){
80108ceb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80108cf2:	eb 6d                	jmp    80108d61 <getvcfs+0x84>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
80108cf4:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108cf7:	89 d0                	mov    %edx,%eax
80108cf9:	c1 e0 02             	shl    $0x2,%eax
80108cfc:	01 d0                	add    %edx,%eax
80108cfe:	01 c0                	add    %eax,%eax
80108d00:	01 d0                	add    %edx,%eax
80108d02:	01 c0                	add    %eax,%eax
80108d04:	01 d0                	add    %edx,%eax
80108d06:	c1 e0 02             	shl    $0x2,%eax
80108d09:	83 c0 20             	add    $0x20,%eax
80108d0c:	8d 90 80 20 11 80    	lea    -0x7feedf80(%eax),%edx
80108d12:	8b 45 08             	mov    0x8(%ebp),%eax
80108d15:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d19:	89 14 24             	mov    %edx,(%esp)
80108d1c:	e8 d7 fc ff ff       	call   801089f8 <strcmp>
80108d21:	85 c0                	test   %eax,%eax
80108d23:	75 39                	jne    80108d5e <getvcfs+0x81>
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
80108d25:	90                   	nop
80108d26:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d29:	8d 42 01             	lea    0x1(%edx),%eax
80108d2c:	89 45 0c             	mov    %eax,0xc(%ebp)
80108d2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108d32:	8d 43 01             	lea    0x1(%ebx),%eax
80108d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80108d3b:	89 c8                	mov    %ecx,%eax
80108d3d:	c1 e0 02             	shl    $0x2,%eax
80108d40:	01 c8                	add    %ecx,%eax
80108d42:	01 c0                	add    %eax,%eax
80108d44:	01 c8                	add    %ecx,%eax
80108d46:	01 c0                	add    %eax,%eax
80108d48:	01 c8                	add    %ecx,%eax
80108d4a:	c1 e0 02             	shl    $0x2,%eax
80108d4d:	01 d8                	add    %ebx,%eax
80108d4f:	05 80 20 11 80       	add    $0x80112080,%eax
80108d54:	8a 00                	mov    (%eax),%al
80108d56:	88 02                	mov    %al,(%edx)
80108d58:	8a 02                	mov    (%edx),%al
80108d5a:	84 c0                	test   %al,%al
80108d5c:	75 c8                	jne    80108d26 <getvcfs+0x49>
    return 0;
}

int getvcfs(char *vc, char *fs){
    int i, j = 0;
    for(i = 0; i < NUM_VCS; i++){
80108d5e:	ff 45 f8             	incl   -0x8(%ebp)
80108d61:	83 7d f8 03          	cmpl   $0x3,-0x8(%ebp)
80108d65:	7e 8d                	jle    80108cf4 <getvcfs+0x17>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
        }
    }return 0;
80108d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d6c:	83 c4 18             	add    $0x18,%esp
80108d6f:	5b                   	pop    %ebx
80108d70:	5d                   	pop    %ebp
80108d71:	c3                   	ret    

80108d72 <setactivefs>:

int setactivefs(char *fs){
80108d72:	55                   	push   %ebp
80108d73:	89 e5                	mov    %esp,%ebp
80108d75:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((cabinet.active_fs[i++] = *fs++) != 0);
80108d7f:	90                   	nop
80108d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108d83:	8d 50 01             	lea    0x1(%eax),%edx
80108d86:	89 55 fc             	mov    %edx,-0x4(%ebp)
80108d89:	8b 55 08             	mov    0x8(%ebp),%edx
80108d8c:	8d 4a 01             	lea    0x1(%edx),%ecx
80108d8f:	89 4d 08             	mov    %ecx,0x8(%ebp)
80108d92:	8a 12                	mov    (%edx),%dl
80108d94:	88 90 f0 21 11 80    	mov    %dl,-0x7feede10(%eax)
80108d9a:	8a 80 f0 21 11 80    	mov    -0x7feede10(%eax),%al
80108da0:	84 c0                	test   %al,%al
80108da2:	75 dc                	jne    80108d80 <setactivefs+0xe>

    return 0;
80108da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108da9:	c9                   	leave  
80108daa:	c3                   	ret    

80108dab <getactivefs>:

int getactivefs(char *fs){
80108dab:	55                   	push   %ebp
80108dac:	89 e5                	mov    %esp,%ebp
80108dae:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108db1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((*fs++ = cabinet.active_fs[i++]) != 0);
80108db8:	90                   	nop
80108db9:	8b 45 08             	mov    0x8(%ebp),%eax
80108dbc:	8d 50 01             	lea    0x1(%eax),%edx
80108dbf:	89 55 08             	mov    %edx,0x8(%ebp)
80108dc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108dc5:	8d 4a 01             	lea    0x1(%edx),%ecx
80108dc8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80108dcb:	8a 92 f0 21 11 80    	mov    -0x7feede10(%edx),%dl
80108dd1:	88 10                	mov    %dl,(%eax)
80108dd3:	8a 00                	mov    (%eax),%al
80108dd5:	84 c0                	test   %al,%al
80108dd7:	75 e0                	jne    80108db9 <getactivefs+0xe>

    return 0;
80108dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108dde:	c9                   	leave  
80108ddf:	c3                   	ret    
