
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 02 38 10 80       	mov    $0x80103802,%eax
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
8010003a:	c7 44 24 04 40 87 10 	movl   $0x80108740,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 b8 4d 00 00       	call   80104e06 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 0d 11 80 7c 	movl   $0x80110d7c,0x80110dcc
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 0d 11 80 7c 	movl   $0x80110d7c,0x80110dd0
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 0d 11 80    	mov    0x80110dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 0d 11 80 	movl   $0x80110d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 47 87 10 	movl   $0x80108747,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 31 4c 00 00       	call   80104cc8 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 0d 11 80       	mov    %eax,0x80110dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
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
801000c2:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000c9:	e8 59 4d 00 00       	call   80104e27 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
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
801000fd:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100104:	e8 88 4d 00 00       	call   80104e91 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 eb 4b 00 00       	call   80104d02 <acquiresleep>
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
80100128:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 0d 11 80       	mov    0x80110dcc,%eax
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
80100176:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017d:	e8 0f 4d 00 00       	call   80104e91 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 72 4b 00 00       	call   80104d02 <acquiresleep>
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
8010019e:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 4e 87 10 80 	movl   $0x8010874e,(%esp)
801001ae:	e8 a1 03 00 00       	call   80100554 <panic>
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
801001e2:	e8 52 27 00 00       	call   80102939 <iderw>
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
801001fb:	e8 9f 4b 00 00       	call   80104d9f <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 5f 87 10 80 	movl   $0x8010875f,(%esp)
8010020b:	e8 44 03 00 00       	call   80100554 <panic>
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
80100225:	e8 0f 27 00 00       	call   80102939 <iderw>
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
8010023b:	e8 5f 4b 00 00       	call   80104d9f <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 66 87 10 80 	movl   $0x80108766,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 ff 4a 00 00       	call   80104d5d <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100265:	e8 bd 4b 00 00       	call   80104e27 <acquire>
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
801002a1:	8b 15 d0 0d 11 80    	mov    0x80110dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 0d 11 80 	movl   $0x80110d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 0d 11 80       	mov    %eax,0x80110dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002d1:	e8 bb 4b 00 00       	call   80104e91 <release>
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

80100315 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100315:	55                   	push   %ebp
80100316:	89 e5                	mov    %esp,%ebp
80100318:	56                   	push   %esi
80100319:	53                   	push   %ebx
8010031a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100321:	74 1c                	je     8010033f <printint+0x2a>
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	c1 e8 1f             	shr    $0x1f,%eax
80100329:	0f b6 c0             	movzbl %al,%eax
8010032c:	89 45 10             	mov    %eax,0x10(%ebp)
8010032f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100333:	74 0a                	je     8010033f <printint+0x2a>
    x = -xx;
80100335:	8b 45 08             	mov    0x8(%ebp),%eax
80100338:	f7 d8                	neg    %eax
8010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033d:	eb 06                	jmp    80100345 <printint+0x30>
  else
    x = xx;
8010033f:	8b 45 08             	mov    0x8(%ebp),%eax
80100342:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034f:	8d 41 01             	lea    0x1(%ecx),%eax
80100352:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 f3                	div    %ebx
80100362:	89 d0                	mov    %edx,%eax
80100364:	8a 80 04 90 10 80    	mov    -0x7fef6ffc(%eax),%al
8010036a:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036e:	8b 75 0c             	mov    0xc(%ebp),%esi
80100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100374:	ba 00 00 00 00       	mov    $0x0,%edx
80100379:	f7 f6                	div    %esi
8010037b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100382:	75 c8                	jne    8010034c <printint+0x37>

  if(sign)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 10                	je     8010039a <printint+0x85>
    buf[i++] = '-';
8010038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038d:	8d 50 01             	lea    0x1(%eax),%edx
80100390:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100393:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100398:	eb 17                	jmp    801003b1 <printint+0x9c>
8010039a:	eb 15                	jmp    801003b1 <printint+0x9c>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	8a 00                	mov    (%eax),%al
801003a6:	0f be c0             	movsbl %al,%eax
801003a9:	89 04 24             	mov    %eax,(%esp)
801003ac:	e8 b7 03 00 00       	call   80100768 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b1:	ff 4d f4             	decl   -0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 e2                	jns    8010039c <printint+0x87>
    consputc(buf[i]);
}
801003ba:	83 c4 30             	add    $0x30,%esp
801003bd:	5b                   	pop    %ebx
801003be:	5e                   	pop    %esi
801003bf:	5d                   	pop    %ebp
801003c0:	c3                   	ret    

801003c1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c1:	55                   	push   %ebp
801003c2:	89 e5                	mov    %esp,%ebp
801003c4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c7:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d3:	74 0c                	je     801003e1 <cprintf+0x20>
    acquire(&cons.lock);
801003d5:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003dc:	e8 46 4a 00 00       	call   80104e27 <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 6d 87 10 80 	movl   $0x8010876d,(%esp)
801003ef:	e8 60 01 00 00       	call   80100554 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100401:	e9 1b 01 00 00       	jmp    80100521 <cprintf+0x160>
    if(c != '%'){
80100406:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040a:	74 10                	je     8010041c <cprintf+0x5b>
      consputc(c);
8010040c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010040f:	89 04 24             	mov    %eax,(%esp)
80100412:	e8 51 03 00 00       	call   80100768 <consputc>
      continue;
80100417:	e9 02 01 00 00       	jmp    8010051e <cprintf+0x15d>
    }
    c = fmt[++i] & 0xff;
8010041c:	8b 55 08             	mov    0x8(%ebp),%edx
8010041f:	ff 45 f4             	incl   -0xc(%ebp)
80100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100425:	01 d0                	add    %edx,%eax
80100427:	8a 00                	mov    (%eax),%al
80100429:	0f be c0             	movsbl %al,%eax
8010042c:	25 ff 00 00 00       	and    $0xff,%eax
80100431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100438:	75 05                	jne    8010043f <cprintf+0x7e>
      break;
8010043a:	e9 01 01 00 00       	jmp    80100540 <cprintf+0x17f>
    switch(c){
8010043f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100442:	83 f8 70             	cmp    $0x70,%eax
80100445:	74 4f                	je     80100496 <cprintf+0xd5>
80100447:	83 f8 70             	cmp    $0x70,%eax
8010044a:	7f 13                	jg     8010045f <cprintf+0x9e>
8010044c:	83 f8 25             	cmp    $0x25,%eax
8010044f:	0f 84 a3 00 00 00    	je     801004f8 <cprintf+0x137>
80100455:	83 f8 64             	cmp    $0x64,%eax
80100458:	74 14                	je     8010046e <cprintf+0xad>
8010045a:	e9 a7 00 00 00       	jmp    80100506 <cprintf+0x145>
8010045f:	83 f8 73             	cmp    $0x73,%eax
80100462:	74 57                	je     801004bb <cprintf+0xfa>
80100464:	83 f8 78             	cmp    $0x78,%eax
80100467:	74 2d                	je     80100496 <cprintf+0xd5>
80100469:	e9 98 00 00 00       	jmp    80100506 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
8010046e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100471:	8d 50 04             	lea    0x4(%eax),%edx
80100474:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100477:	8b 00                	mov    (%eax),%eax
80100479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100480:	00 
80100481:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100488:	00 
80100489:	89 04 24             	mov    %eax,(%esp)
8010048c:	e8 84 fe ff ff       	call   80100315 <printint>
      break;
80100491:	e9 88 00 00 00       	jmp    8010051e <cprintf+0x15d>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004a8:	00 
801004a9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b0:	00 
801004b1:	89 04 24             	mov    %eax,(%esp)
801004b4:	e8 5c fe ff ff       	call   80100315 <printint>
      break;
801004b9:	eb 63                	jmp    8010051e <cprintf+0x15d>
    case 's':
      if((s = (char*)*argp++) == 0)
801004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004be:	8d 50 04             	lea    0x4(%eax),%edx
801004c1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c4:	8b 00                	mov    (%eax),%eax
801004c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cd:	75 09                	jne    801004d8 <cprintf+0x117>
        s = "(null)";
801004cf:	c7 45 ec 76 87 10 80 	movl   $0x80108776,-0x14(%ebp)
      for(; *s; s++)
801004d6:	eb 15                	jmp    801004ed <cprintf+0x12c>
801004d8:	eb 13                	jmp    801004ed <cprintf+0x12c>
        consputc(*s);
801004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dd:	8a 00                	mov    (%eax),%al
801004df:	0f be c0             	movsbl %al,%eax
801004e2:	89 04 24             	mov    %eax,(%esp)
801004e5:	e8 7e 02 00 00       	call   80100768 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004ea:	ff 45 ec             	incl   -0x14(%ebp)
801004ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f0:	8a 00                	mov    (%eax),%al
801004f2:	84 c0                	test   %al,%al
801004f4:	75 e4                	jne    801004da <cprintf+0x119>
        consputc(*s);
      break;
801004f6:	eb 26                	jmp    8010051e <cprintf+0x15d>
    case '%':
      consputc('%');
801004f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ff:	e8 64 02 00 00       	call   80100768 <consputc>
      break;
80100504:	eb 18                	jmp    8010051e <cprintf+0x15d>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100506:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050d:	e8 56 02 00 00       	call   80100768 <consputc>
      consputc(c);
80100512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100515:	89 04 24             	mov    %eax,(%esp)
80100518:	e8 4b 02 00 00       	call   80100768 <consputc>
      break;
8010051d:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010051e:	ff 45 f4             	incl   -0xc(%ebp)
80100521:	8b 55 08             	mov    0x8(%ebp),%edx
80100524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100527:	01 d0                	add    %edx,%eax
80100529:	8a 00                	mov    (%eax),%al
8010052b:	0f be c0             	movsbl %al,%eax
8010052e:	25 ff 00 00 00       	and    $0xff,%eax
80100533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053a:	0f 85 c6 fe ff ff    	jne    80100406 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100540:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100544:	74 0c                	je     80100552 <cprintf+0x191>
    release(&cons.lock);
80100546:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010054d:	e8 3f 49 00 00       	call   80104e91 <release>
}
80100552:	c9                   	leave  
80100553:	c3                   	ret    

80100554 <panic>:

void
panic(char *s)
{
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
8010055a:	e8 b0 fd ff ff       	call   8010030f <cli>
  cons.locking = 0;
8010055f:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
80100566:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100569:	e8 67 2a 00 00       	call   80102fd5 <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 7d 87 10 80 	movl   $0x8010877d,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 91 87 10 80 	movl   $0x80108791,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 37 49 00 00       	call   80104ede <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 93 87 10 80 	movl   $0x80108793,(%esp)
801005c2:	e8 fa fd ff ff       	call   801003c1 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c7:	ff 45 f4             	incl   -0xc(%ebp)
801005ca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005ce:	7e e0                	jle    801005b0 <panic+0x5c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005d0:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005d7:	00 00 00 
  for(;;)
    ;
801005da:	eb fe                	jmp    801005da <panic+0x86>

801005dc <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005dc:	55                   	push   %ebp
801005dd:	89 e5                	mov    %esp,%ebp
801005df:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005e2:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e9:	00 
801005ea:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005f1:	e8 fd fc ff ff       	call   801002f3 <outb>
  pos = inb(CRTPORT+1) << 8;
801005f6:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005fd:	e8 d6 fc ff ff       	call   801002d8 <inb>
80100602:	0f b6 c0             	movzbl %al,%eax
80100605:	c1 e0 08             	shl    $0x8,%eax
80100608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010060b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100612:	00 
80100613:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010061a:	e8 d4 fc ff ff       	call   801002f3 <outb>
  pos |= inb(CRTPORT+1);
8010061f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100626:	e8 ad fc ff ff       	call   801002d8 <inb>
8010062b:	0f b6 c0             	movzbl %al,%eax
8010062e:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100631:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100635:	75 1b                	jne    80100652 <cgaputc+0x76>
    pos += 80 - pos%80;
80100637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010063a:	b9 50 00 00 00       	mov    $0x50,%ecx
8010063f:	99                   	cltd   
80100640:	f7 f9                	idiv   %ecx
80100642:	89 d0                	mov    %edx,%eax
80100644:	ba 50 00 00 00       	mov    $0x50,%edx
80100649:	29 c2                	sub    %eax,%edx
8010064b:	89 d0                	mov    %edx,%eax
8010064d:	01 45 f4             	add    %eax,-0xc(%ebp)
80100650:	eb 34                	jmp    80100686 <cgaputc+0xaa>
  else if(c == BACKSPACE){
80100652:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100659:	75 0b                	jne    80100666 <cgaputc+0x8a>
    if(pos > 0) --pos;
8010065b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010065f:	7e 25                	jle    80100686 <cgaputc+0xaa>
80100661:	ff 4d f4             	decl   -0xc(%ebp)
80100664:	eb 20                	jmp    80100686 <cgaputc+0xaa>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100666:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010066f:	8d 50 01             	lea    0x1(%eax),%edx
80100672:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100675:	01 c0                	add    %eax,%eax
80100677:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067a:	8b 45 08             	mov    0x8(%ebp),%eax
8010067d:	0f b6 c0             	movzbl %al,%eax
80100680:	80 cc 07             	or     $0x7,%ah
80100683:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	78 09                	js     80100695 <cgaputc+0xb9>
8010068c:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100693:	7e 0c                	jle    801006a1 <cgaputc+0xc5>
    panic("pos under/overflow");
80100695:	c7 04 24 97 87 10 80 	movl   $0x80108797,(%esp)
8010069c:	e8 b3 fe ff ff       	call   80100554 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006a1:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a8:	7e 53                	jle    801006fd <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006aa:	a1 00 90 10 80       	mov    0x80109000,%eax
801006af:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b5:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ba:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c1:	00 
801006c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801006c6:	89 04 24             	mov    %eax,(%esp)
801006c9:	e8 85 4a 00 00       	call   80105153 <memmove>
    pos -= 80;
801006ce:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d2:	b8 80 07 00 00       	mov    $0x780,%eax
801006d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006da:	01 c0                	add    %eax,%eax
801006dc:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801006e5:	01 d2                	add    %edx,%edx
801006e7:	01 ca                	add    %ecx,%edx
801006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801006ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f4:	00 
801006f5:	89 14 24             	mov    %edx,(%esp)
801006f8:	e8 8d 49 00 00       	call   8010508a <memset>
  }

  outb(CRTPORT, 14);
801006fd:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100704:	00 
80100705:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010070c:	e8 e2 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos>>8);
80100711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100714:	c1 f8 08             	sar    $0x8,%eax
80100717:	0f b6 c0             	movzbl %al,%eax
8010071a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010071e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100725:	e8 c9 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT, 15);
8010072a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100731:	00 
80100732:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100739:	e8 b5 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos);
8010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	89 44 24 04          	mov    %eax,0x4(%esp)
80100748:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074f:	e8 9f fb ff ff       	call   801002f3 <outb>
  crt[pos] = ' ' | 0x0700;
80100754:	8b 15 00 90 10 80    	mov    0x80109000,%edx
8010075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010075d:	01 c0                	add    %eax,%eax
8010075f:	01 d0                	add    %edx,%eax
80100761:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100766:	c9                   	leave  
80100767:	c3                   	ret    

80100768 <consputc>:

void
consputc(int c)
{
80100768:	55                   	push   %ebp
80100769:	89 e5                	mov    %esp,%ebp
8010076b:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010076e:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100773:	85 c0                	test   %eax,%eax
80100775:	74 07                	je     8010077e <consputc+0x16>
    cli();
80100777:	e8 93 fb ff ff       	call   8010030f <cli>
    for(;;)
      ;
8010077c:	eb fe                	jmp    8010077c <consputc+0x14>
  }

  if(c == BACKSPACE){
8010077e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100785:	75 26                	jne    801007ad <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 ed 64 00 00       	call   80106c80 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 e1 64 00 00       	call   80106c80 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 d5 64 00 00       	call   80106c80 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 c8 64 00 00       	call   80106c80 <uartputc>
  cgaputc(c);
801007b8:	8b 45 08             	mov    0x8(%ebp),%eax
801007bb:	89 04 24             	mov    %eax,(%esp)
801007be:	e8 19 fe ff ff       	call   801005dc <cgaputc>
}
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <copy_buf>:

#define C(x)  ((x)-'@')  // Control-x


void copy_buf(char *dst, char *src, int len)
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 10             	sub    $0x10,%esp
  int i;

  for (i = 0; i < len; i++) {
801007cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801007d2:	eb 17                	jmp    801007eb <copy_buf+0x26>
    dst[i] = src[i];
801007d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801007d7:	8b 45 08             	mov    0x8(%ebp),%eax
801007da:	01 c2                	add    %eax,%edx
801007dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
801007df:	8b 45 0c             	mov    0xc(%ebp),%eax
801007e2:	01 c8                	add    %ecx,%eax
801007e4:	8a 00                	mov    (%eax),%al
801007e6:	88 02                	mov    %al,(%edx)

void copy_buf(char *dst, char *src, int len)
{
  int i;

  for (i = 0; i < len; i++) {
801007e8:	ff 45 fc             	incl   -0x4(%ebp)
801007eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801007ee:	3b 45 10             	cmp    0x10(%ebp),%eax
801007f1:	7c e1                	jl     801007d4 <copy_buf+0xf>
    dst[i] = src[i];
  }
}
801007f3:	c9                   	leave  
801007f4:	c3                   	ret    

801007f5 <consoleintr>:

void
consoleintr(int (*getc)(void))
{
801007f5:	55                   	push   %ebp
801007f6:	89 e5                	mov    %esp,%ebp
801007f8:	57                   	push   %edi
801007f9:	56                   	push   %esi
801007fa:	53                   	push   %ebx
801007fb:	83 ec 2c             	sub    $0x2c,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
801007fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100805:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  acquire(&cons.lock);
8010080c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100813:	e8 0f 46 00 00       	call   80104e27 <acquire>
  while((c = getc()) >= 0){
80100818:	e9 ca 01 00 00       	jmp    801009e7 <consoleintr+0x1f2>
    switch(c){
8010081d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100820:	83 f8 14             	cmp    $0x14,%eax
80100823:	74 3b                	je     80100860 <consoleintr+0x6b>
80100825:	83 f8 14             	cmp    $0x14,%eax
80100828:	7f 13                	jg     8010083d <consoleintr+0x48>
8010082a:	83 f8 08             	cmp    $0x8,%eax
8010082d:	0f 84 f5 00 00 00    	je     80100928 <consoleintr+0x133>
80100833:	83 f8 10             	cmp    $0x10,%eax
80100836:	74 1c                	je     80100854 <consoleintr+0x5f>
80100838:	e9 1b 01 00 00       	jmp    80100958 <consoleintr+0x163>
8010083d:	83 f8 15             	cmp    $0x15,%eax
80100840:	0f 84 ba 00 00 00    	je     80100900 <consoleintr+0x10b>
80100846:	83 f8 7f             	cmp    $0x7f,%eax
80100849:	0f 84 d9 00 00 00    	je     80100928 <consoleintr+0x133>
8010084f:	e9 04 01 00 00       	jmp    80100958 <consoleintr+0x163>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100854:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
8010085b:	e9 87 01 00 00       	jmp    801009e7 <consoleintr+0x1f2>
    case C('T'):  // Process listing.
      inputs[active] = input;
80100860:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
80100866:	89 d0                	mov    %edx,%eax
80100868:	c1 e0 02             	shl    $0x2,%eax
8010086b:	01 d0                	add    %edx,%eax
8010086d:	c1 e0 02             	shl    $0x2,%eax
80100870:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80100877:	29 c2                	sub    %eax,%edx
80100879:	8d 82 80 10 11 80    	lea    -0x7feeef80(%edx),%eax
8010087f:	89 c2                	mov    %eax,%edx
80100881:	bb e0 0f 11 80       	mov    $0x80110fe0,%ebx
80100886:	b8 23 00 00 00       	mov    $0x23,%eax
8010088b:	89 d7                	mov    %edx,%edi
8010088d:	89 de                	mov    %ebx,%esi
8010088f:	89 c1                	mov    %eax,%ecx
80100891:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      active = (active + 1) % (NUM_VCS + 1);
80100893:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80100898:	40                   	inc    %eax
80100899:	b9 05 00 00 00       	mov    $0x5,%ecx
8010089e:	99                   	cltd   
8010089f:	f7 f9                	idiv   %ecx
801008a1:	89 d0                	mov    %edx,%eax
801008a3:	a3 c4 b5 10 80       	mov    %eax,0x8010b5c4
      input = inputs[active];
801008a8:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
801008ae:	89 d0                	mov    %edx,%eax
801008b0:	c1 e0 02             	shl    $0x2,%eax
801008b3:	01 d0                	add    %edx,%eax
801008b5:	c1 e0 02             	shl    $0x2,%eax
801008b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008bf:	29 c2                	sub    %eax,%edx
801008c1:	8d 82 80 10 11 80    	lea    -0x7feeef80(%edx),%eax
801008c7:	ba e0 0f 11 80       	mov    $0x80110fe0,%edx
801008cc:	89 c3                	mov    %eax,%ebx
801008ce:	b8 23 00 00 00       	mov    $0x23,%eax
801008d3:	89 d7                	mov    %edx,%edi
801008d5:	89 de                	mov    %ebx,%esi
801008d7:	89 c1                	mov    %eax,%ecx
801008d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      doconsoleswitch = 1;
801008db:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      break;
801008e2:	e9 00 01 00 00       	jmp    801009e7 <consoleintr+0x1f2>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008e7:	a1 68 10 11 80       	mov    0x80111068,%eax
801008ec:	48                   	dec    %eax
801008ed:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
801008f2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008f9:	e8 6a fe ff ff       	call   80100768 <consputc>
801008fe:	eb 01                	jmp    80100901 <consoleintr+0x10c>
      active = (active + 1) % (NUM_VCS + 1);
      input = inputs[active];
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	90                   	nop
80100901:	8b 15 68 10 11 80    	mov    0x80111068,%edx
80100907:	a1 64 10 11 80       	mov    0x80111064,%eax
8010090c:	39 c2                	cmp    %eax,%edx
8010090e:	74 13                	je     80100923 <consoleintr+0x12e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100910:	a1 68 10 11 80       	mov    0x80111068,%eax
80100915:	48                   	dec    %eax
80100916:	83 e0 7f             	and    $0x7f,%eax
80100919:	8a 80 e0 0f 11 80    	mov    -0x7feef020(%eax),%al
      active = (active + 1) % (NUM_VCS + 1);
      input = inputs[active];
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010091f:	3c 0a                	cmp    $0xa,%al
80100921:	75 c4                	jne    801008e7 <consoleintr+0xf2>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100923:	e9 bf 00 00 00       	jmp    801009e7 <consoleintr+0x1f2>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100928:	8b 15 68 10 11 80    	mov    0x80111068,%edx
8010092e:	a1 64 10 11 80       	mov    0x80111064,%eax
80100933:	39 c2                	cmp    %eax,%edx
80100935:	74 1c                	je     80100953 <consoleintr+0x15e>
        input.e--;
80100937:	a1 68 10 11 80       	mov    0x80111068,%eax
8010093c:	48                   	dec    %eax
8010093d:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
80100942:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100949:	e8 1a fe ff ff       	call   80100768 <consputc>
      }
      break;
8010094e:	e9 94 00 00 00       	jmp    801009e7 <consoleintr+0x1f2>
80100953:	e9 8f 00 00 00       	jmp    801009e7 <consoleintr+0x1f2>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100958:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010095c:	0f 84 84 00 00 00    	je     801009e6 <consoleintr+0x1f1>
80100962:	8b 15 68 10 11 80    	mov    0x80111068,%edx
80100968:	a1 60 10 11 80       	mov    0x80111060,%eax
8010096d:	29 c2                	sub    %eax,%edx
8010096f:	89 d0                	mov    %edx,%eax
80100971:	83 f8 7f             	cmp    $0x7f,%eax
80100974:	77 70                	ja     801009e6 <consoleintr+0x1f1>
        c = (c == '\r') ? '\n' : c;
80100976:	83 7d dc 0d          	cmpl   $0xd,-0x24(%ebp)
8010097a:	74 05                	je     80100981 <consoleintr+0x18c>
8010097c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010097f:	eb 05                	jmp    80100986 <consoleintr+0x191>
80100981:	b8 0a 00 00 00       	mov    $0xa,%eax
80100986:	89 45 dc             	mov    %eax,-0x24(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100989:	a1 68 10 11 80       	mov    0x80111068,%eax
8010098e:	8d 50 01             	lea    0x1(%eax),%edx
80100991:	89 15 68 10 11 80    	mov    %edx,0x80111068
80100997:	83 e0 7f             	and    $0x7f,%eax
8010099a:	89 c2                	mov    %eax,%edx
8010099c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010099f:	88 82 e0 0f 11 80    	mov    %al,-0x7feef020(%edx)
        consputc(c);
801009a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801009a8:	89 04 24             	mov    %eax,(%esp)
801009ab:	e8 b8 fd ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009b0:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
801009b4:	74 18                	je     801009ce <consoleintr+0x1d9>
801009b6:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
801009ba:	74 12                	je     801009ce <consoleintr+0x1d9>
801009bc:	a1 68 10 11 80       	mov    0x80111068,%eax
801009c1:	8b 15 60 10 11 80    	mov    0x80111060,%edx
801009c7:	83 ea 80             	sub    $0xffffff80,%edx
801009ca:	39 d0                	cmp    %edx,%eax
801009cc:	75 18                	jne    801009e6 <consoleintr+0x1f1>
          input.w = input.e;
801009ce:	a1 68 10 11 80       	mov    0x80111068,%eax
801009d3:	a3 64 10 11 80       	mov    %eax,0x80111064
          wakeup(&input.r);
801009d8:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
801009df:	e8 48 41 00 00       	call   80104b2c <wakeup>
        }
      }
      break;
801009e4:	eb 00                	jmp    801009e6 <consoleintr+0x1f1>
801009e6:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009e7:	8b 45 08             	mov    0x8(%ebp),%eax
801009ea:	ff d0                	call   *%eax
801009ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
801009ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801009f3:	0f 89 24 fe ff ff    	jns    8010081d <consoleintr+0x28>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009f9:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a00:	e8 8c 44 00 00       	call   80104e91 <release>
  if(doprocdump){
80100a05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a09:	74 05                	je     80100a10 <consoleintr+0x21b>
    procdump();  // now call procdump() wo. cons.lock held
80100a0b:	e8 bf 41 00 00       	call   80104bcf <procdump>
  }
  if(doconsoleswitch){
80100a10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100a14:	74 15                	je     80100a2b <consoleintr+0x236>
    cprintf("\nActive console now: %d\n", active);
80100a16:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80100a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a1f:	c7 04 24 aa 87 10 80 	movl   $0x801087aa,(%esp)
80100a26:	e8 96 f9 ff ff       	call   801003c1 <cprintf>
  }
}
80100a2b:	83 c4 2c             	add    $0x2c,%esp
80100a2e:	5b                   	pop    %ebx
80100a2f:	5e                   	pop    %esi
80100a30:	5f                   	pop    %edi
80100a31:	5d                   	pop    %ebp
80100a32:	c3                   	ret    

80100a33 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a33:	55                   	push   %ebp
80100a34:	89 e5                	mov    %esp,%ebp
80100a36:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100a39:	8b 45 08             	mov    0x8(%ebp),%eax
80100a3c:	89 04 24             	mov    %eax,(%esp)
80100a3f:	e8 ec 10 00 00       	call   80101b30 <iunlock>
  target = n;
80100a44:	8b 45 10             	mov    0x10(%ebp),%eax
80100a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a51:	e8 d1 43 00 00       	call   80104e27 <acquire>
  while(n > 0){
80100a56:	e9 b8 00 00 00       	jmp    80100b13 <consoleread+0xe0>
    while((input.r == input.w) || (active != ip->minor-1)){
80100a5b:	eb 41                	jmp    80100a9e <consoleread+0x6b>
      if(myproc()->killed){
80100a5d:	e8 b5 37 00 00       	call   80104217 <myproc>
80100a62:	8b 40 24             	mov    0x24(%eax),%eax
80100a65:	85 c0                	test   %eax,%eax
80100a67:	74 21                	je     80100a8a <consoleread+0x57>
        release(&cons.lock);
80100a69:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a70:	e8 1c 44 00 00       	call   80104e91 <release>
        ilock(ip);
80100a75:	8b 45 08             	mov    0x8(%ebp),%eax
80100a78:	89 04 24             	mov    %eax,(%esp)
80100a7b:	e8 a6 0f 00 00       	call   80101a26 <ilock>
        return -1;
80100a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a85:	e9 b4 00 00 00       	jmp    80100b3e <consoleread+0x10b>
      }
      sleep(&input.r, &cons.lock);
80100a8a:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80100a91:	80 
80100a92:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100a99:	e8 ba 3f 00 00       	call   80104a58 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while((input.r == input.w) || (active != ip->minor-1)){
80100a9e:	8b 15 60 10 11 80    	mov    0x80111060,%edx
80100aa4:	a1 64 10 11 80       	mov    0x80111064,%eax
80100aa9:	39 c2                	cmp    %eax,%edx
80100aab:	74 b0                	je     80100a5d <consoleread+0x2a>
80100aad:	8b 45 08             	mov    0x8(%ebp),%eax
80100ab0:	8b 40 54             	mov    0x54(%eax),%eax
80100ab3:	98                   	cwtl   
80100ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ab7:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80100abc:	39 c2                	cmp    %eax,%edx
80100abe:	75 9d                	jne    80100a5d <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac0:	a1 60 10 11 80       	mov    0x80111060,%eax
80100ac5:	8d 50 01             	lea    0x1(%eax),%edx
80100ac8:	89 15 60 10 11 80    	mov    %edx,0x80111060
80100ace:	83 e0 7f             	and    $0x7f,%eax
80100ad1:	8a 80 e0 0f 11 80    	mov    -0x7feef020(%eax),%al
80100ad7:	0f be c0             	movsbl %al,%eax
80100ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100add:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ae1:	75 17                	jne    80100afa <consoleread+0xc7>
      if(n < target){
80100ae3:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ae9:	73 0d                	jae    80100af8 <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aeb:	a1 60 10 11 80       	mov    0x80111060,%eax
80100af0:	48                   	dec    %eax
80100af1:	a3 60 10 11 80       	mov    %eax,0x80111060
      }
      break;
80100af6:	eb 25                	jmp    80100b1d <consoleread+0xea>
80100af8:	eb 23                	jmp    80100b1d <consoleread+0xea>
    }
    *dst++ = c;
80100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afd:	8d 50 01             	lea    0x1(%eax),%edx
80100b00:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b06:	88 10                	mov    %dl,(%eax)
    --n;
80100b08:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100b0b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0f:	75 02                	jne    80100b13 <consoleread+0xe0>
      break;
80100b11:	eb 0a                	jmp    80100b1d <consoleread+0xea>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b17:	0f 8f 3e ff ff ff    	jg     80100a5b <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100b1d:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100b24:	e8 68 43 00 00       	call   80104e91 <release>
  ilock(ip);
80100b29:	8b 45 08             	mov    0x8(%ebp),%eax
80100b2c:	89 04 24             	mov    %eax,(%esp)
80100b2f:	e8 f2 0e 00 00       	call   80101a26 <ilock>

  return target - n;
80100b34:	8b 45 10             	mov    0x10(%ebp),%eax
80100b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b3a:	29 c2                	sub    %eax,%edx
80100b3c:	89 d0                	mov    %edx,%eax
}
80100b3e:	c9                   	leave  
80100b3f:	c3                   	ret    

80100b40 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b40:	55                   	push   %ebp
80100b41:	89 e5                	mov    %esp,%ebp
80100b43:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor-1){
80100b46:	8b 45 08             	mov    0x8(%ebp),%eax
80100b49:	8b 40 54             	mov    0x54(%eax),%eax
80100b4c:	98                   	cwtl   
80100b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b50:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80100b55:	39 c2                	cmp    %eax,%edx
80100b57:	75 5a                	jne    80100bb3 <consolewrite+0x73>
    iunlock(ip);
80100b59:	8b 45 08             	mov    0x8(%ebp),%eax
80100b5c:	89 04 24             	mov    %eax,(%esp)
80100b5f:	e8 cc 0f 00 00       	call   80101b30 <iunlock>
    acquire(&cons.lock);
80100b64:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100b6b:	e8 b7 42 00 00       	call   80104e27 <acquire>
    for(i = 0; i < n; i++)
80100b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b77:	eb 1b                	jmp    80100b94 <consolewrite+0x54>
      consputc(buf[i] & 0xff);
80100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b7f:	01 d0                	add    %edx,%eax
80100b81:	8a 00                	mov    (%eax),%al
80100b83:	0f be c0             	movsbl %al,%eax
80100b86:	0f b6 c0             	movzbl %al,%eax
80100b89:	89 04 24             	mov    %eax,(%esp)
80100b8c:	e8 d7 fb ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor-1){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100b91:	ff 45 f4             	incl   -0xc(%ebp)
80100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b97:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9a:	7c dd                	jl     80100b79 <consolewrite+0x39>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100b9c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100ba3:	e8 e9 42 00 00       	call   80104e91 <release>
    ilock(ip);
80100ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80100bab:	89 04 24             	mov    %eax,(%esp)
80100bae:	e8 73 0e 00 00       	call   80101a26 <ilock>
  }
  return n;
80100bb3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bb6:	c9                   	leave  
80100bb7:	c3                   	ret    

80100bb8 <consoleinit>:

void
consoleinit(void)
{
80100bb8:	55                   	push   %ebp
80100bb9:	89 e5                	mov    %esp,%ebp
80100bbb:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100bbe:	c7 44 24 04 c3 87 10 	movl   $0x801087c3,0x4(%esp)
80100bc5:	80 
80100bc6:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100bcd:	e8 34 42 00 00       	call   80104e06 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100bd2:	c7 05 ec 1c 11 80 40 	movl   $0x80100b40,0x80111cec
80100bd9:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bdc:	c7 05 e8 1c 11 80 33 	movl   $0x80100a33,0x80111ce8
80100be3:	0a 10 80 
  cons.locking = 1;
80100be6:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100bed:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100bf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100bf7:	00 
80100bf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100bff:	e8 e7 1e 00 00       	call   80102aeb <ioapicenable>
}
80100c04:	c9                   	leave  
80100c05:	c3                   	ret    
	...

80100c08 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c08:	55                   	push   %ebp
80100c09:	89 e5                	mov    %esp,%ebp
80100c0b:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c11:	e8 01 36 00 00       	call   80104217 <myproc>
80100c16:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100c19:	e8 01 29 00 00       	call   8010351f <begin_op>

  if((ip = namei(path)) == 0){
80100c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80100c21:	89 04 24             	mov    %eax,(%esp)
80100c24:	e8 22 19 00 00       	call   8010254b <namei>
80100c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c2c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c30:	75 1b                	jne    80100c4d <exec+0x45>
    end_op();
80100c32:	e8 6a 29 00 00       	call   801035a1 <end_op>
    cprintf("exec: fail\n");
80100c37:	c7 04 24 cb 87 10 80 	movl   $0x801087cb,(%esp)
80100c3e:	e8 7e f7 ff ff       	call   801003c1 <cprintf>
    return -1;
80100c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c48:	e9 f6 03 00 00       	jmp    80101043 <exec+0x43b>
  }
  ilock(ip);
80100c4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c50:	89 04 24             	mov    %eax,(%esp)
80100c53:	e8 ce 0d 00 00       	call   80101a26 <ilock>
  pgdir = 0;
80100c58:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c5f:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100c66:	00 
80100c67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100c6e:	00 
80100c6f:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c75:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c7c:	89 04 24             	mov    %eax,(%esp)
80100c7f:	e8 39 12 00 00       	call   80101ebd <readi>
80100c84:	83 f8 34             	cmp    $0x34,%eax
80100c87:	74 05                	je     80100c8e <exec+0x86>
    goto bad;
80100c89:	e9 89 03 00 00       	jmp    80101017 <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100c8e:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c94:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c99:	74 05                	je     80100ca0 <exec+0x98>
    goto bad;
80100c9b:	e9 77 03 00 00       	jmp    80101017 <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100ca0:	e8 bd 6f 00 00       	call   80107c62 <setupkvm>
80100ca5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100ca8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cac:	75 05                	jne    80100cb3 <exec+0xab>
    goto bad;
80100cae:	e9 64 03 00 00       	jmp    80101017 <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100cb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cc1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100cc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cca:	e9 fb 00 00 00       	jmp    80100dca <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cd2:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100cd9:	00 
80100cda:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cde:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ceb:	89 04 24             	mov    %eax,(%esp)
80100cee:	e8 ca 11 00 00       	call   80101ebd <readi>
80100cf3:	83 f8 20             	cmp    $0x20,%eax
80100cf6:	74 05                	je     80100cfd <exec+0xf5>
      goto bad;
80100cf8:	e9 1a 03 00 00       	jmp    80101017 <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100cfd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d03:	83 f8 01             	cmp    $0x1,%eax
80100d06:	74 05                	je     80100d0d <exec+0x105>
      continue;
80100d08:	e9 b1 00 00 00       	jmp    80100dbe <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100d0d:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d13:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d19:	39 c2                	cmp    %eax,%edx
80100d1b:	73 05                	jae    80100d22 <exec+0x11a>
      goto bad;
80100d1d:	e9 f5 02 00 00       	jmp    80101017 <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d22:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d28:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d2e:	01 c2                	add    %eax,%edx
80100d30:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d36:	39 c2                	cmp    %eax,%edx
80100d38:	73 05                	jae    80100d3f <exec+0x137>
      goto bad;
80100d3a:	e9 d8 02 00 00       	jmp    80101017 <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d3f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d45:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d4b:	01 d0                	add    %edx,%eax
80100d4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d54:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d5b:	89 04 24             	mov    %eax,(%esp)
80100d5e:	e8 cb 72 00 00       	call   8010802e <allocuvm>
80100d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d6a:	75 05                	jne    80100d71 <exec+0x169>
      goto bad;
80100d6c:	e9 a6 02 00 00       	jmp    80101017 <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100d71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d77:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d7c:	85 c0                	test   %eax,%eax
80100d7e:	74 05                	je     80100d85 <exec+0x17d>
      goto bad;
80100d80:	e9 92 02 00 00       	jmp    80101017 <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d85:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100d8b:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d91:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d97:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100d9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d9f:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100da2:	89 54 24 08          	mov    %edx,0x8(%esp)
80100da6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100daa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100dad:	89 04 24             	mov    %eax,(%esp)
80100db0:	e8 96 71 00 00       	call   80107f4b <loaduvm>
80100db5:	85 c0                	test   %eax,%eax
80100db7:	79 05                	jns    80100dbe <exec+0x1b6>
      goto bad;
80100db9:	e9 59 02 00 00       	jmp    80101017 <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dbe:	ff 45 ec             	incl   -0x14(%ebp)
80100dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dc4:	83 c0 20             	add    $0x20,%eax
80100dc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dca:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100dd0:	0f b7 c0             	movzwl %ax,%eax
80100dd3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dd6:	0f 8f f3 fe ff ff    	jg     80100ccf <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ddc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ddf:	89 04 24             	mov    %eax,(%esp)
80100de2:	e8 3e 0e 00 00       	call   80101c25 <iunlockput>
  end_op();
80100de7:	e8 b5 27 00 00       	call   801035a1 <end_op>
  ip = 0;
80100dec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100df6:	05 ff 0f 00 00       	add    $0xfff,%eax
80100dfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e06:	05 00 20 00 00       	add    $0x2000,%eax
80100e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e19:	89 04 24             	mov    %eax,(%esp)
80100e1c:	e8 0d 72 00 00       	call   8010802e <allocuvm>
80100e21:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e28:	75 05                	jne    80100e2f <exec+0x227>
    goto bad;
80100e2a:	e9 e8 01 00 00       	jmp    80101017 <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e32:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e37:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e3e:	89 04 24             	mov    %eax,(%esp)
80100e41:	e8 58 74 00 00       	call   8010829e <clearpteu>
  sp = sz;
80100e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e49:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e53:	e9 95 00 00 00       	jmp    80100eed <exec+0x2e5>
    if(argc >= MAXARG)
80100e58:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e5c:	76 05                	jbe    80100e63 <exec+0x25b>
      goto bad;
80100e5e:	e9 b4 01 00 00       	jmp    80101017 <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e70:	01 d0                	add    %edx,%eax
80100e72:	8b 00                	mov    (%eax),%eax
80100e74:	89 04 24             	mov    %eax,(%esp)
80100e77:	e8 61 44 00 00       	call   801052dd <strlen>
80100e7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e7f:	29 c2                	sub    %eax,%edx
80100e81:	89 d0                	mov    %edx,%eax
80100e83:	48                   	dec    %eax
80100e84:	83 e0 fc             	and    $0xfffffffc,%eax
80100e87:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e94:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e97:	01 d0                	add    %edx,%eax
80100e99:	8b 00                	mov    (%eax),%eax
80100e9b:	89 04 24             	mov    %eax,(%esp)
80100e9e:	e8 3a 44 00 00       	call   801052dd <strlen>
80100ea3:	40                   	inc    %eax
80100ea4:	89 c2                	mov    %eax,%edx
80100ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb3:	01 c8                	add    %ecx,%eax
80100eb5:	8b 00                	mov    (%eax),%eax
80100eb7:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100ebb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ec6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ec9:	89 04 24             	mov    %eax,(%esp)
80100ecc:	e8 85 75 00 00       	call   80108456 <copyout>
80100ed1:	85 c0                	test   %eax,%eax
80100ed3:	79 05                	jns    80100eda <exec+0x2d2>
      goto bad;
80100ed5:	e9 3d 01 00 00       	jmp    80101017 <exec+0x40f>
    ustack[3+argc] = sp;
80100eda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edd:	8d 50 03             	lea    0x3(%eax),%edx
80100ee0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee3:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100eea:	ff 45 e4             	incl   -0x1c(%ebp)
80100eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efa:	01 d0                	add    %edx,%eax
80100efc:	8b 00                	mov    (%eax),%eax
80100efe:	85 c0                	test   %eax,%eax
80100f00:	0f 85 52 ff ff ff    	jne    80100e58 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f09:	83 c0 03             	add    $0x3,%eax
80100f0c:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f13:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f17:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f1e:	ff ff ff 
  ustack[1] = argc;
80100f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f24:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2d:	40                   	inc    %eax
80100f2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f35:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f38:	29 d0                	sub    %edx,%eax
80100f3a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f43:	83 c0 04             	add    $0x4,%eax
80100f46:	c1 e0 02             	shl    $0x2,%eax
80100f49:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4f:	83 c0 04             	add    $0x4,%eax
80100f52:	c1 e0 02             	shl    $0x2,%eax
80100f55:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100f59:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f63:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f66:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f6d:	89 04 24             	mov    %eax,(%esp)
80100f70:	e8 e1 74 00 00       	call   80108456 <copyout>
80100f75:	85 c0                	test   %eax,%eax
80100f77:	79 05                	jns    80100f7e <exec+0x376>
    goto bad;
80100f79:	e9 99 00 00 00       	jmp    80101017 <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80100f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f8a:	eb 13                	jmp    80100f9f <exec+0x397>
    if(*s == '/')
80100f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8f:	8a 00                	mov    (%eax),%al
80100f91:	3c 2f                	cmp    $0x2f,%al
80100f93:	75 07                	jne    80100f9c <exec+0x394>
      last = s+1;
80100f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f98:	40                   	inc    %eax
80100f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f9c:	ff 45 f4             	incl   -0xc(%ebp)
80100f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa2:	8a 00                	mov    (%eax),%al
80100fa4:	84 c0                	test   %al,%al
80100fa6:	75 e4                	jne    80100f8c <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fa8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fab:	8d 50 6c             	lea    0x6c(%eax),%edx
80100fae:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100fb5:	00 
80100fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100fbd:	89 14 24             	mov    %edx,(%esp)
80100fc0:	e8 d1 42 00 00       	call   80105296 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fc8:	8b 40 04             	mov    0x4(%eax),%eax
80100fcb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fd1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fd4:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100fd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fda:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fdd:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fe2:	8b 40 18             	mov    0x18(%eax),%eax
80100fe5:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100feb:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ff1:	8b 40 18             	mov    0x18(%eax),%eax
80100ff4:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ff7:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ffa:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ffd:	89 04 24             	mov    %eax,(%esp)
80101000:	e8 37 6d 00 00       	call   80107d3c <switchuvm>
  freevm(oldpgdir);
80101005:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101008:	89 04 24             	mov    %eax,(%esp)
8010100b:	e8 f8 71 00 00       	call   80108208 <freevm>
  return 0;
80101010:	b8 00 00 00 00       	mov    $0x0,%eax
80101015:	eb 2c                	jmp    80101043 <exec+0x43b>

 bad:
  if(pgdir)
80101017:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010101b:	74 0b                	je     80101028 <exec+0x420>
    freevm(pgdir);
8010101d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101020:	89 04 24             	mov    %eax,(%esp)
80101023:	e8 e0 71 00 00       	call   80108208 <freevm>
  if(ip){
80101028:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010102c:	74 10                	je     8010103e <exec+0x436>
    iunlockput(ip);
8010102e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101031:	89 04 24             	mov    %eax,(%esp)
80101034:	e8 ec 0b 00 00       	call   80101c25 <iunlockput>
    end_op();
80101039:	e8 63 25 00 00       	call   801035a1 <end_op>
  }
  return -1;
8010103e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101043:	c9                   	leave  
80101044:	c3                   	ret    
80101045:	00 00                	add    %al,(%eax)
	...

80101048 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101048:	55                   	push   %ebp
80101049:	89 e5                	mov    %esp,%ebp
8010104b:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
8010104e:	c7 44 24 04 d7 87 10 	movl   $0x801087d7,0x4(%esp)
80101055:	80 
80101056:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
8010105d:	e8 a4 3d 00 00       	call   80104e06 <initlock>
}
80101062:	c9                   	leave  
80101063:	c3                   	ret    

80101064 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101064:	55                   	push   %ebp
80101065:	89 e5                	mov    %esp,%ebp
80101067:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
8010106a:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
80101071:	e8 b1 3d 00 00       	call   80104e27 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101076:	c7 45 f4 74 13 11 80 	movl   $0x80111374,-0xc(%ebp)
8010107d:	eb 29                	jmp    801010a8 <filealloc+0x44>
    if(f->ref == 0){
8010107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101082:	8b 40 04             	mov    0x4(%eax),%eax
80101085:	85 c0                	test   %eax,%eax
80101087:	75 1b                	jne    801010a4 <filealloc+0x40>
      f->ref = 1;
80101089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010108c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101093:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
8010109a:	e8 f2 3d 00 00       	call   80104e91 <release>
      return f;
8010109f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010a2:	eb 1e                	jmp    801010c2 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010a4:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801010a8:	81 7d f4 d4 1c 11 80 	cmpl   $0x80111cd4,-0xc(%ebp)
801010af:	72 ce                	jb     8010107f <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801010b1:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
801010b8:	e8 d4 3d 00 00       	call   80104e91 <release>
  return 0;
801010bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010c2:	c9                   	leave  
801010c3:	c3                   	ret    

801010c4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010c4:	55                   	push   %ebp
801010c5:	89 e5                	mov    %esp,%ebp
801010c7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801010ca:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
801010d1:	e8 51 3d 00 00       	call   80104e27 <acquire>
  if(f->ref < 1)
801010d6:	8b 45 08             	mov    0x8(%ebp),%eax
801010d9:	8b 40 04             	mov    0x4(%eax),%eax
801010dc:	85 c0                	test   %eax,%eax
801010de:	7f 0c                	jg     801010ec <filedup+0x28>
    panic("filedup");
801010e0:	c7 04 24 de 87 10 80 	movl   $0x801087de,(%esp)
801010e7:	e8 68 f4 ff ff       	call   80100554 <panic>
  f->ref++;
801010ec:	8b 45 08             	mov    0x8(%ebp),%eax
801010ef:	8b 40 04             	mov    0x4(%eax),%eax
801010f2:	8d 50 01             	lea    0x1(%eax),%edx
801010f5:	8b 45 08             	mov    0x8(%ebp),%eax
801010f8:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010fb:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
80101102:	e8 8a 3d 00 00       	call   80104e91 <release>
  return f;
80101107:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010110a:	c9                   	leave  
8010110b:	c3                   	ret    

8010110c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010110c:	55                   	push   %ebp
8010110d:	89 e5                	mov    %esp,%ebp
8010110f:	57                   	push   %edi
80101110:	56                   	push   %esi
80101111:	53                   	push   %ebx
80101112:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101115:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
8010111c:	e8 06 3d 00 00       	call   80104e27 <acquire>
  if(f->ref < 1)
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	8b 40 04             	mov    0x4(%eax),%eax
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 0c                	jg     80101137 <fileclose+0x2b>
    panic("fileclose");
8010112b:	c7 04 24 e6 87 10 80 	movl   $0x801087e6,(%esp)
80101132:	e8 1d f4 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 04             	mov    0x4(%eax),%eax
8010113d:	8d 50 ff             	lea    -0x1(%eax),%edx
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	89 50 04             	mov    %edx,0x4(%eax)
80101146:	8b 45 08             	mov    0x8(%ebp),%eax
80101149:	8b 40 04             	mov    0x4(%eax),%eax
8010114c:	85 c0                	test   %eax,%eax
8010114e:	7e 0e                	jle    8010115e <fileclose+0x52>
    release(&ftable.lock);
80101150:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
80101157:	e8 35 3d 00 00       	call   80104e91 <release>
8010115c:	eb 70                	jmp    801011ce <fileclose+0xc2>
    return;
  }
  ff = *f;
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101164:	89 c3                	mov    %eax,%ebx
80101166:	b8 06 00 00 00       	mov    $0x6,%eax
8010116b:	89 d7                	mov    %edx,%edi
8010116d:	89 de                	mov    %ebx,%esi
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101186:	c7 04 24 40 13 11 80 	movl   $0x80111340,(%esp)
8010118d:	e8 ff 3c 00 00       	call   80104e91 <release>

  if(ff.type == FD_PIPE)
80101192:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101195:	83 f8 01             	cmp    $0x1,%eax
80101198:	75 17                	jne    801011b1 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
8010119a:	8a 45 d9             	mov    -0x27(%ebp),%al
8010119d:	0f be d0             	movsbl %al,%edx
801011a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a3:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a7:	89 04 24             	mov    %eax,(%esp)
801011aa:	e8 00 2d 00 00       	call   80103eaf <pipeclose>
801011af:	eb 1d                	jmp    801011ce <fileclose+0xc2>
  else if(ff.type == FD_INODE){
801011b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801011b4:	83 f8 02             	cmp    $0x2,%eax
801011b7:	75 15                	jne    801011ce <fileclose+0xc2>
    begin_op();
801011b9:	e8 61 23 00 00       	call   8010351f <begin_op>
    iput(ff.ip);
801011be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c1:	89 04 24             	mov    %eax,(%esp)
801011c4:	e8 ab 09 00 00       	call   80101b74 <iput>
    end_op();
801011c9:	e8 d3 23 00 00       	call   801035a1 <end_op>
  }
}
801011ce:	83 c4 3c             	add    $0x3c,%esp
801011d1:	5b                   	pop    %ebx
801011d2:	5e                   	pop    %esi
801011d3:	5f                   	pop    %edi
801011d4:	5d                   	pop    %ebp
801011d5:	c3                   	ret    

801011d6 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011d6:	55                   	push   %ebp
801011d7:	89 e5                	mov    %esp,%ebp
801011d9:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 00                	mov    (%eax),%eax
801011e1:	83 f8 02             	cmp    $0x2,%eax
801011e4:	75 38                	jne    8010121e <filestat+0x48>
    ilock(f->ip);
801011e6:	8b 45 08             	mov    0x8(%ebp),%eax
801011e9:	8b 40 10             	mov    0x10(%eax),%eax
801011ec:	89 04 24             	mov    %eax,(%esp)
801011ef:	e8 32 08 00 00       	call   80101a26 <ilock>
    stati(f->ip, st);
801011f4:	8b 45 08             	mov    0x8(%ebp),%eax
801011f7:	8b 40 10             	mov    0x10(%eax),%eax
801011fa:	8b 55 0c             	mov    0xc(%ebp),%edx
801011fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101201:	89 04 24             	mov    %eax,(%esp)
80101204:	e8 70 0c 00 00       	call   80101e79 <stati>
    iunlock(f->ip);
80101209:	8b 45 08             	mov    0x8(%ebp),%eax
8010120c:	8b 40 10             	mov    0x10(%eax),%eax
8010120f:	89 04 24             	mov    %eax,(%esp)
80101212:	e8 19 09 00 00       	call   80101b30 <iunlock>
    return 0;
80101217:	b8 00 00 00 00       	mov    $0x0,%eax
8010121c:	eb 05                	jmp    80101223 <filestat+0x4d>
  }
  return -1;
8010121e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101223:	c9                   	leave  
80101224:	c3                   	ret    

80101225 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101225:	55                   	push   %ebp
80101226:	89 e5                	mov    %esp,%ebp
80101228:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010122b:	8b 45 08             	mov    0x8(%ebp),%eax
8010122e:	8a 40 08             	mov    0x8(%eax),%al
80101231:	84 c0                	test   %al,%al
80101233:	75 0a                	jne    8010123f <fileread+0x1a>
    return -1;
80101235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123a:	e9 9f 00 00 00       	jmp    801012de <fileread+0xb9>
  if(f->type == FD_PIPE)
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	8b 00                	mov    (%eax),%eax
80101244:	83 f8 01             	cmp    $0x1,%eax
80101247:	75 1e                	jne    80101267 <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 0c             	mov    0xc(%eax),%eax
8010124f:	8b 55 10             	mov    0x10(%ebp),%edx
80101252:	89 54 24 08          	mov    %edx,0x8(%esp)
80101256:	8b 55 0c             	mov    0xc(%ebp),%edx
80101259:	89 54 24 04          	mov    %edx,0x4(%esp)
8010125d:	89 04 24             	mov    %eax,(%esp)
80101260:	e8 c8 2d 00 00       	call   8010402d <piperead>
80101265:	eb 77                	jmp    801012de <fileread+0xb9>
  if(f->type == FD_INODE){
80101267:	8b 45 08             	mov    0x8(%ebp),%eax
8010126a:	8b 00                	mov    (%eax),%eax
8010126c:	83 f8 02             	cmp    $0x2,%eax
8010126f:	75 61                	jne    801012d2 <fileread+0xad>
    ilock(f->ip);
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 40 10             	mov    0x10(%eax),%eax
80101277:	89 04 24             	mov    %eax,(%esp)
8010127a:	e8 a7 07 00 00       	call   80101a26 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010127f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 50 14             	mov    0x14(%eax),%edx
80101288:	8b 45 08             	mov    0x8(%ebp),%eax
8010128b:	8b 40 10             	mov    0x10(%eax),%eax
8010128e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101292:	89 54 24 08          	mov    %edx,0x8(%esp)
80101296:	8b 55 0c             	mov    0xc(%ebp),%edx
80101299:	89 54 24 04          	mov    %edx,0x4(%esp)
8010129d:	89 04 24             	mov    %eax,(%esp)
801012a0:	e8 18 0c 00 00       	call   80101ebd <readi>
801012a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012ac:	7e 11                	jle    801012bf <fileread+0x9a>
      f->off += r;
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	8b 50 14             	mov    0x14(%eax),%edx
801012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b7:	01 c2                	add    %eax,%edx
801012b9:	8b 45 08             	mov    0x8(%ebp),%eax
801012bc:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012bf:	8b 45 08             	mov    0x8(%ebp),%eax
801012c2:	8b 40 10             	mov    0x10(%eax),%eax
801012c5:	89 04 24             	mov    %eax,(%esp)
801012c8:	e8 63 08 00 00       	call   80101b30 <iunlock>
    return r;
801012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d0:	eb 0c                	jmp    801012de <fileread+0xb9>
  }
  panic("fileread");
801012d2:	c7 04 24 f0 87 10 80 	movl   $0x801087f0,(%esp)
801012d9:	e8 76 f2 ff ff       	call   80100554 <panic>
}
801012de:	c9                   	leave  
801012df:	c3                   	ret    

801012e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	53                   	push   %ebx
801012e4:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801012e7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ea:	8a 40 09             	mov    0x9(%eax),%al
801012ed:	84 c0                	test   %al,%al
801012ef:	75 0a                	jne    801012fb <filewrite+0x1b>
    return -1;
801012f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f6:	e9 20 01 00 00       	jmp    8010141b <filewrite+0x13b>
  if(f->type == FD_PIPE)
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	8b 00                	mov    (%eax),%eax
80101300:	83 f8 01             	cmp    $0x1,%eax
80101303:	75 21                	jne    80101326 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101305:	8b 45 08             	mov    0x8(%ebp),%eax
80101308:	8b 40 0c             	mov    0xc(%eax),%eax
8010130b:	8b 55 10             	mov    0x10(%ebp),%edx
8010130e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101312:	8b 55 0c             	mov    0xc(%ebp),%edx
80101315:	89 54 24 04          	mov    %edx,0x4(%esp)
80101319:	89 04 24             	mov    %eax,(%esp)
8010131c:	e8 20 2c 00 00       	call   80103f41 <pipewrite>
80101321:	e9 f5 00 00 00       	jmp    8010141b <filewrite+0x13b>
  if(f->type == FD_INODE){
80101326:	8b 45 08             	mov    0x8(%ebp),%eax
80101329:	8b 00                	mov    (%eax),%eax
8010132b:	83 f8 02             	cmp    $0x2,%eax
8010132e:	0f 85 db 00 00 00    	jne    8010140f <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101334:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010133b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101342:	e9 a8 00 00 00       	jmp    801013ef <filewrite+0x10f>
      int n1 = n - i;
80101347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134a:	8b 55 10             	mov    0x10(%ebp),%edx
8010134d:	29 c2                	sub    %eax,%edx
8010134f:	89 d0                	mov    %edx,%eax
80101351:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101354:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101357:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010135a:	7e 06                	jle    80101362 <filewrite+0x82>
        n1 = max;
8010135c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010135f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101362:	e8 b8 21 00 00       	call   8010351f <begin_op>
      ilock(f->ip);
80101367:	8b 45 08             	mov    0x8(%ebp),%eax
8010136a:	8b 40 10             	mov    0x10(%eax),%eax
8010136d:	89 04 24             	mov    %eax,(%esp)
80101370:	e8 b1 06 00 00       	call   80101a26 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101378:	8b 45 08             	mov    0x8(%ebp),%eax
8010137b:	8b 50 14             	mov    0x14(%eax),%edx
8010137e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101381:	8b 45 0c             	mov    0xc(%ebp),%eax
80101384:	01 c3                	add    %eax,%ebx
80101386:	8b 45 08             	mov    0x8(%ebp),%eax
80101389:	8b 40 10             	mov    0x10(%eax),%eax
8010138c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101390:	89 54 24 08          	mov    %edx,0x8(%esp)
80101394:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101398:	89 04 24             	mov    %eax,(%esp)
8010139b:	e8 81 0c 00 00       	call   80102021 <writei>
801013a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a7:	7e 11                	jle    801013ba <filewrite+0xda>
        f->off += r;
801013a9:	8b 45 08             	mov    0x8(%ebp),%eax
801013ac:	8b 50 14             	mov    0x14(%eax),%edx
801013af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b2:	01 c2                	add    %eax,%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013ba:	8b 45 08             	mov    0x8(%ebp),%eax
801013bd:	8b 40 10             	mov    0x10(%eax),%eax
801013c0:	89 04 24             	mov    %eax,(%esp)
801013c3:	e8 68 07 00 00       	call   80101b30 <iunlock>
      end_op();
801013c8:	e8 d4 21 00 00       	call   801035a1 <end_op>

      if(r < 0)
801013cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d1:	79 02                	jns    801013d5 <filewrite+0xf5>
        break;
801013d3:	eb 26                	jmp    801013fb <filewrite+0x11b>
      if(r != n1)
801013d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013db:	74 0c                	je     801013e9 <filewrite+0x109>
        panic("short filewrite");
801013dd:	c7 04 24 f9 87 10 80 	movl   $0x801087f9,(%esp)
801013e4:	e8 6b f1 ff ff       	call   80100554 <panic>
      i += r;
801013e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ec:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f5:	0f 8c 4c ff ff ff    	jl     80101347 <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fe:	3b 45 10             	cmp    0x10(%ebp),%eax
80101401:	75 05                	jne    80101408 <filewrite+0x128>
80101403:	8b 45 10             	mov    0x10(%ebp),%eax
80101406:	eb 05                	jmp    8010140d <filewrite+0x12d>
80101408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010140d:	eb 0c                	jmp    8010141b <filewrite+0x13b>
  }
  panic("filewrite");
8010140f:	c7 04 24 09 88 10 80 	movl   $0x80108809,(%esp)
80101416:	e8 39 f1 ff ff       	call   80100554 <panic>
}
8010141b:	83 c4 24             	add    $0x24,%esp
8010141e:	5b                   	pop    %ebx
8010141f:	5d                   	pop    %ebp
80101420:	c3                   	ret    
80101421:	00 00                	add    %al,(%eax)
	...

80101424 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101424:	55                   	push   %ebp
80101425:	89 e5                	mov    %esp,%ebp
80101427:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010142a:	8b 45 08             	mov    0x8(%ebp),%eax
8010142d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101434:	00 
80101435:	89 04 24             	mov    %eax,(%esp)
80101438:	e8 78 ed ff ff       	call   801001b5 <bread>
8010143d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101443:	83 c0 5c             	add    $0x5c,%eax
80101446:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010144d:	00 
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	8b 45 0c             	mov    0xc(%ebp),%eax
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 f6 3c 00 00       	call   80105153 <memmove>
  brelse(bp);
8010145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 c4 ed ff ff       	call   8010022c <brelse>
}
80101468:	c9                   	leave  
80101469:	c3                   	ret    

8010146a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010146a:	55                   	push   %ebp
8010146b:	89 e5                	mov    %esp,%ebp
8010146d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101470:	8b 55 0c             	mov    0xc(%ebp),%edx
80101473:	8b 45 08             	mov    0x8(%ebp),%eax
80101476:	89 54 24 04          	mov    %edx,0x4(%esp)
8010147a:	89 04 24             	mov    %eax,(%esp)
8010147d:	e8 33 ed ff ff       	call   801001b5 <bread>
80101482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101488:	83 c0 5c             	add    $0x5c,%eax
8010148b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101492:	00 
80101493:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010149a:	00 
8010149b:	89 04 24             	mov    %eax,(%esp)
8010149e:	e8 e7 3b 00 00       	call   8010508a <memset>
  log_write(bp);
801014a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a6:	89 04 24             	mov    %eax,(%esp)
801014a9:	e8 75 22 00 00       	call   80103723 <log_write>
  brelse(bp);
801014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b1:	89 04 24             	mov    %eax,(%esp)
801014b4:	e8 73 ed ff ff       	call   8010022c <brelse>
}
801014b9:	c9                   	leave  
801014ba:	c3                   	ret    

801014bb <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014bb:	55                   	push   %ebp
801014bc:	89 e5                	mov    %esp,%ebp
801014be:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014cf:	e9 03 01 00 00       	jmp    801015d7 <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
801014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d7:	85 c0                	test   %eax,%eax
801014d9:	79 05                	jns    801014e0 <balloc+0x25>
801014db:	05 ff 0f 00 00       	add    $0xfff,%eax
801014e0:	c1 f8 0c             	sar    $0xc,%eax
801014e3:	89 c2                	mov    %eax,%edx
801014e5:	a1 58 1d 11 80       	mov    0x80111d58,%eax
801014ea:	01 d0                	add    %edx,%eax
801014ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f0:	8b 45 08             	mov    0x8(%ebp),%eax
801014f3:	89 04 24             	mov    %eax,(%esp)
801014f6:	e8 ba ec ff ff       	call   801001b5 <bread>
801014fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101505:	e9 9b 00 00 00       	jmp    801015a5 <balloc+0xea>
      m = 1 << (bi % 8);
8010150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150d:	25 07 00 00 80       	and    $0x80000007,%eax
80101512:	85 c0                	test   %eax,%eax
80101514:	79 05                	jns    8010151b <balloc+0x60>
80101516:	48                   	dec    %eax
80101517:	83 c8 f8             	or     $0xfffffff8,%eax
8010151a:	40                   	inc    %eax
8010151b:	ba 01 00 00 00       	mov    $0x1,%edx
80101520:	88 c1                	mov    %al,%cl
80101522:	d3 e2                	shl    %cl,%edx
80101524:	89 d0                	mov    %edx,%eax
80101526:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152c:	85 c0                	test   %eax,%eax
8010152e:	79 03                	jns    80101533 <balloc+0x78>
80101530:	83 c0 07             	add    $0x7,%eax
80101533:	c1 f8 03             	sar    $0x3,%eax
80101536:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101539:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
8010153d:	0f b6 c0             	movzbl %al,%eax
80101540:	23 45 e8             	and    -0x18(%ebp),%eax
80101543:	85 c0                	test   %eax,%eax
80101545:	75 5b                	jne    801015a2 <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154a:	85 c0                	test   %eax,%eax
8010154c:	79 03                	jns    80101551 <balloc+0x96>
8010154e:	83 c0 07             	add    $0x7,%eax
80101551:	c1 f8 03             	sar    $0x3,%eax
80101554:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101557:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
8010155b:	88 d1                	mov    %dl,%cl
8010155d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101560:	09 ca                	or     %ecx,%edx
80101562:	88 d1                	mov    %dl,%cl
80101564:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101567:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010156b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010156e:	89 04 24             	mov    %eax,(%esp)
80101571:	e8 ad 21 00 00       	call   80103723 <log_write>
        brelse(bp);
80101576:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101579:	89 04 24             	mov    %eax,(%esp)
8010157c:	e8 ab ec ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101584:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101587:	01 c2                	add    %eax,%edx
80101589:	8b 45 08             	mov    0x8(%ebp),%eax
8010158c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101590:	89 04 24             	mov    %eax,(%esp)
80101593:	e8 d2 fe ff ff       	call   8010146a <bzero>
        return b + bi;
80101598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159e:	01 d0                	add    %edx,%eax
801015a0:	eb 51                	jmp    801015f3 <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015a2:	ff 45 f0             	incl   -0x10(%ebp)
801015a5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015ac:	7f 17                	jg     801015c5 <balloc+0x10a>
801015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b4:	01 d0                	add    %edx,%eax
801015b6:	89 c2                	mov    %eax,%edx
801015b8:	a1 40 1d 11 80       	mov    0x80111d40,%eax
801015bd:	39 c2                	cmp    %eax,%edx
801015bf:	0f 82 45 ff ff ff    	jb     8010150a <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015c8:	89 04 24             	mov    %eax,(%esp)
801015cb:	e8 5c ec ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015d0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015da:	a1 40 1d 11 80       	mov    0x80111d40,%eax
801015df:	39 c2                	cmp    %eax,%edx
801015e1:	0f 82 ed fe ff ff    	jb     801014d4 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015e7:	c7 04 24 14 88 10 80 	movl   $0x80108814,(%esp)
801015ee:	e8 61 ef ff ff       	call   80100554 <panic>
}
801015f3:	c9                   	leave  
801015f4:	c3                   	ret    

801015f5 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015f5:	55                   	push   %ebp
801015f6:	89 e5                	mov    %esp,%ebp
801015f8:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015fb:	c7 44 24 04 40 1d 11 	movl   $0x80111d40,0x4(%esp)
80101602:	80 
80101603:	8b 45 08             	mov    0x8(%ebp),%eax
80101606:	89 04 24             	mov    %eax,(%esp)
80101609:	e8 16 fe ff ff       	call   80101424 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010160e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101611:	c1 e8 0c             	shr    $0xc,%eax
80101614:	89 c2                	mov    %eax,%edx
80101616:	a1 58 1d 11 80       	mov    0x80111d58,%eax
8010161b:	01 c2                	add    %eax,%edx
8010161d:	8b 45 08             	mov    0x8(%ebp),%eax
80101620:	89 54 24 04          	mov    %edx,0x4(%esp)
80101624:	89 04 24             	mov    %eax,(%esp)
80101627:	e8 89 eb ff ff       	call   801001b5 <bread>
8010162c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010162f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101632:	25 ff 0f 00 00       	and    $0xfff,%eax
80101637:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163d:	25 07 00 00 80       	and    $0x80000007,%eax
80101642:	85 c0                	test   %eax,%eax
80101644:	79 05                	jns    8010164b <bfree+0x56>
80101646:	48                   	dec    %eax
80101647:	83 c8 f8             	or     $0xfffffff8,%eax
8010164a:	40                   	inc    %eax
8010164b:	ba 01 00 00 00       	mov    $0x1,%edx
80101650:	88 c1                	mov    %al,%cl
80101652:	d3 e2                	shl    %cl,%edx
80101654:	89 d0                	mov    %edx,%eax
80101656:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165c:	85 c0                	test   %eax,%eax
8010165e:	79 03                	jns    80101663 <bfree+0x6e>
80101660:	83 c0 07             	add    $0x7,%eax
80101663:	c1 f8 03             	sar    $0x3,%eax
80101666:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101669:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
8010166d:	0f b6 c0             	movzbl %al,%eax
80101670:	23 45 ec             	and    -0x14(%ebp),%eax
80101673:	85 c0                	test   %eax,%eax
80101675:	75 0c                	jne    80101683 <bfree+0x8e>
    panic("freeing free block");
80101677:	c7 04 24 2a 88 10 80 	movl   $0x8010882a,(%esp)
8010167e:	e8 d1 ee ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
80101683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101686:	85 c0                	test   %eax,%eax
80101688:	79 03                	jns    8010168d <bfree+0x98>
8010168a:	83 c0 07             	add    $0x7,%eax
8010168d:	c1 f8 03             	sar    $0x3,%eax
80101690:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101693:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101697:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010169a:	f7 d1                	not    %ecx
8010169c:	21 ca                	and    %ecx,%edx
8010169e:	88 d1                	mov    %dl,%cl
801016a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a3:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016aa:	89 04 24             	mov    %eax,(%esp)
801016ad:	e8 71 20 00 00       	call   80103723 <log_write>
  brelse(bp);
801016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b5:	89 04 24             	mov    %eax,(%esp)
801016b8:	e8 6f eb ff ff       	call   8010022c <brelse>
}
801016bd:	c9                   	leave  
801016be:	c3                   	ret    

801016bf <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016bf:	55                   	push   %ebp
801016c0:	89 e5                	mov    %esp,%ebp
801016c2:	57                   	push   %edi
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801016c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016cf:	c7 44 24 04 3d 88 10 	movl   $0x8010883d,0x4(%esp)
801016d6:	80 
801016d7:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
801016de:	e8 23 37 00 00       	call   80104e06 <initlock>
  for(i = 0; i < NINODE; i++) {
801016e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ea:	eb 2b                	jmp    80101717 <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
801016ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016ef:	89 d0                	mov    %edx,%eax
801016f1:	c1 e0 03             	shl    $0x3,%eax
801016f4:	01 d0                	add    %edx,%eax
801016f6:	c1 e0 04             	shl    $0x4,%eax
801016f9:	83 c0 30             	add    $0x30,%eax
801016fc:	05 60 1d 11 80       	add    $0x80111d60,%eax
80101701:	83 c0 10             	add    $0x10,%eax
80101704:	c7 44 24 04 44 88 10 	movl   $0x80108844,0x4(%esp)
8010170b:	80 
8010170c:	89 04 24             	mov    %eax,(%esp)
8010170f:	e8 b4 35 00 00       	call   80104cc8 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101714:	ff 45 e4             	incl   -0x1c(%ebp)
80101717:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010171b:	7e cf                	jle    801016ec <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010171d:	c7 44 24 04 40 1d 11 	movl   $0x80111d40,0x4(%esp)
80101724:	80 
80101725:	8b 45 08             	mov    0x8(%ebp),%eax
80101728:	89 04 24             	mov    %eax,(%esp)
8010172b:	e8 f4 fc ff ff       	call   80101424 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101730:	a1 58 1d 11 80       	mov    0x80111d58,%eax
80101735:	8b 3d 54 1d 11 80    	mov    0x80111d54,%edi
8010173b:	8b 35 50 1d 11 80    	mov    0x80111d50,%esi
80101741:	8b 1d 4c 1d 11 80    	mov    0x80111d4c,%ebx
80101747:	8b 0d 48 1d 11 80    	mov    0x80111d48,%ecx
8010174d:	8b 15 44 1d 11 80    	mov    0x80111d44,%edx
80101753:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101756:	8b 15 40 1d 11 80    	mov    0x80111d40,%edx
8010175c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101760:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101764:	89 74 24 14          	mov    %esi,0x14(%esp)
80101768:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010176c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101773:	89 44 24 08          	mov    %eax,0x8(%esp)
80101777:	89 d0                	mov    %edx,%eax
80101779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010177d:	c7 04 24 4c 88 10 80 	movl   $0x8010884c,(%esp)
80101784:	e8 38 ec ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101789:	83 c4 4c             	add    $0x4c,%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5f                   	pop    %edi
8010178f:	5d                   	pop    %ebp
80101790:	c3                   	ret    

80101791 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101791:	55                   	push   %ebp
80101792:	89 e5                	mov    %esp,%ebp
80101794:	83 ec 28             	sub    $0x28,%esp
80101797:	8b 45 0c             	mov    0xc(%ebp),%eax
8010179a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010179e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801017a5:	e9 9b 00 00 00       	jmp    80101845 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
801017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ad:	c1 e8 03             	shr    $0x3,%eax
801017b0:	89 c2                	mov    %eax,%edx
801017b2:	a1 54 1d 11 80       	mov    0x80111d54,%eax
801017b7:	01 d0                	add    %edx,%eax
801017b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801017bd:	8b 45 08             	mov    0x8(%ebp),%eax
801017c0:	89 04 24             	mov    %eax,(%esp)
801017c3:	e8 ed e9 ff ff       	call   801001b5 <bread>
801017c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ce:	8d 50 5c             	lea    0x5c(%eax),%edx
801017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d4:	83 e0 07             	and    $0x7,%eax
801017d7:	c1 e0 06             	shl    $0x6,%eax
801017da:	01 d0                	add    %edx,%eax
801017dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017e2:	8b 00                	mov    (%eax),%eax
801017e4:	66 85 c0             	test   %ax,%ax
801017e7:	75 4e                	jne    80101837 <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
801017e9:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801017f0:	00 
801017f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801017f8:	00 
801017f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017fc:	89 04 24             	mov    %eax,(%esp)
801017ff:	e8 86 38 00 00       	call   8010508a <memset>
      dip->type = type;
80101804:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010180a:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
8010180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101810:	89 04 24             	mov    %eax,(%esp)
80101813:	e8 0b 1f 00 00       	call   80103723 <log_write>
      brelse(bp);
80101818:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181b:	89 04 24             	mov    %eax,(%esp)
8010181e:	e8 09 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101826:	89 44 24 04          	mov    %eax,0x4(%esp)
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	89 04 24             	mov    %eax,(%esp)
80101830:	e8 ea 00 00 00       	call   8010191f <iget>
80101835:	eb 2a                	jmp    80101861 <ialloc+0xd0>
    }
    brelse(bp);
80101837:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183a:	89 04 24             	mov    %eax,(%esp)
8010183d:	e8 ea e9 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101842:	ff 45 f4             	incl   -0xc(%ebp)
80101845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101848:	a1 48 1d 11 80       	mov    0x80111d48,%eax
8010184d:	39 c2                	cmp    %eax,%edx
8010184f:	0f 82 55 ff ff ff    	jb     801017aa <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101855:	c7 04 24 9f 88 10 80 	movl   $0x8010889f,(%esp)
8010185c:	e8 f3 ec ff ff       	call   80100554 <panic>
}
80101861:	c9                   	leave  
80101862:	c3                   	ret    

80101863 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101863:	55                   	push   %ebp
80101864:	89 e5                	mov    %esp,%ebp
80101866:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101869:	8b 45 08             	mov    0x8(%ebp),%eax
8010186c:	8b 40 04             	mov    0x4(%eax),%eax
8010186f:	c1 e8 03             	shr    $0x3,%eax
80101872:	89 c2                	mov    %eax,%edx
80101874:	a1 54 1d 11 80       	mov    0x80111d54,%eax
80101879:	01 c2                	add    %eax,%edx
8010187b:	8b 45 08             	mov    0x8(%ebp),%eax
8010187e:	8b 00                	mov    (%eax),%eax
80101880:	89 54 24 04          	mov    %edx,0x4(%esp)
80101884:	89 04 24             	mov    %eax,(%esp)
80101887:	e8 29 e9 ff ff       	call   801001b5 <bread>
8010188c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101892:	8d 50 5c             	lea    0x5c(%eax),%edx
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	8b 40 04             	mov    0x4(%eax),%eax
8010189b:	83 e0 07             	and    $0x7,%eax
8010189e:	c1 e0 06             	shl    $0x6,%eax
801018a1:	01 d0                	add    %edx,%eax
801018a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801018a6:	8b 45 08             	mov    0x8(%ebp),%eax
801018a9:	8b 40 50             	mov    0x50(%eax),%eax
801018ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018af:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	66 8b 40 52          	mov    0x52(%eax),%ax
801018b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018bc:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801018c0:	8b 45 08             	mov    0x8(%ebp),%eax
801018c3:	8b 40 54             	mov    0x54(%eax),%eax
801018c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018c9:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801018cd:	8b 45 08             	mov    0x8(%ebp),%eax
801018d0:	66 8b 40 56          	mov    0x56(%eax),%ax
801018d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801018d7:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801018db:	8b 45 08             	mov    0x8(%ebp),%eax
801018de:	8b 50 58             	mov    0x58(%eax),%edx
801018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e4:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8d 50 5c             	lea    0x5c(%eax),%edx
801018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f0:	83 c0 0c             	add    $0xc,%eax
801018f3:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801018fa:	00 
801018fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801018ff:	89 04 24             	mov    %eax,(%esp)
80101902:	e8 4c 38 00 00       	call   80105153 <memmove>
  log_write(bp);
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	89 04 24             	mov    %eax,(%esp)
8010190d:	e8 11 1e 00 00       	call   80103723 <log_write>
  brelse(bp);
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	89 04 24             	mov    %eax,(%esp)
80101918:	e8 0f e9 ff ff       	call   8010022c <brelse>
}
8010191d:	c9                   	leave  
8010191e:	c3                   	ret    

8010191f <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010191f:	55                   	push   %ebp
80101920:	89 e5                	mov    %esp,%ebp
80101922:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101925:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
8010192c:	e8 f6 34 00 00       	call   80104e27 <acquire>

  // Is the inode already cached?
  empty = 0;
80101931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101938:	c7 45 f4 94 1d 11 80 	movl   $0x80111d94,-0xc(%ebp)
8010193f:	eb 5c                	jmp    8010199d <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101944:	8b 40 08             	mov    0x8(%eax),%eax
80101947:	85 c0                	test   %eax,%eax
80101949:	7e 35                	jle    80101980 <iget+0x61>
8010194b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194e:	8b 00                	mov    (%eax),%eax
80101950:	3b 45 08             	cmp    0x8(%ebp),%eax
80101953:	75 2b                	jne    80101980 <iget+0x61>
80101955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101958:	8b 40 04             	mov    0x4(%eax),%eax
8010195b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010195e:	75 20                	jne    80101980 <iget+0x61>
      ip->ref++;
80101960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101963:	8b 40 08             	mov    0x8(%eax),%eax
80101966:	8d 50 01             	lea    0x1(%eax),%edx
80101969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010196f:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101976:	e8 16 35 00 00       	call   80104e91 <release>
      return ip;
8010197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197e:	eb 72                	jmp    801019f2 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101984:	75 10                	jne    80101996 <iget+0x77>
80101986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101989:	8b 40 08             	mov    0x8(%eax),%eax
8010198c:	85 c0                	test   %eax,%eax
8010198e:	75 06                	jne    80101996 <iget+0x77>
      empty = ip;
80101990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101993:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101996:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010199d:	81 7d f4 b4 39 11 80 	cmpl   $0x801139b4,-0xc(%ebp)
801019a4:	72 9b                	jb     80101941 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019aa:	75 0c                	jne    801019b8 <iget+0x99>
    panic("iget: no inodes");
801019ac:	c7 04 24 b1 88 10 80 	movl   $0x801088b1,(%esp)
801019b3:	e8 9c eb ff ff       	call   80100554 <panic>

  ip = empty;
801019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c1:	8b 55 08             	mov    0x8(%ebp),%edx
801019c4:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801019cc:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dc:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019e3:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
801019ea:	e8 a2 34 00 00       	call   80104e91 <release>

  return ip;
801019ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019f2:	c9                   	leave  
801019f3:	c3                   	ret    

801019f4 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019f4:	55                   	push   %ebp
801019f5:	89 e5                	mov    %esp,%ebp
801019f7:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801019fa:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101a01:	e8 21 34 00 00       	call   80104e27 <acquire>
  ip->ref++;
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	8b 40 08             	mov    0x8(%eax),%eax
80101a0c:	8d 50 01             	lea    0x1(%eax),%edx
80101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a12:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a15:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101a1c:	e8 70 34 00 00       	call   80104e91 <release>
  return ip;
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a24:	c9                   	leave  
80101a25:	c3                   	ret    

80101a26 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a26:	55                   	push   %ebp
80101a27:	89 e5                	mov    %esp,%ebp
80101a29:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a30:	74 0a                	je     80101a3c <ilock+0x16>
80101a32:	8b 45 08             	mov    0x8(%ebp),%eax
80101a35:	8b 40 08             	mov    0x8(%eax),%eax
80101a38:	85 c0                	test   %eax,%eax
80101a3a:	7f 0c                	jg     80101a48 <ilock+0x22>
    panic("ilock");
80101a3c:	c7 04 24 c1 88 10 80 	movl   $0x801088c1,(%esp)
80101a43:	e8 0c eb ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
80101a48:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4b:	83 c0 0c             	add    $0xc,%eax
80101a4e:	89 04 24             	mov    %eax,(%esp)
80101a51:	e8 ac 32 00 00       	call   80104d02 <acquiresleep>

  if(ip->valid == 0){
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a5c:	85 c0                	test   %eax,%eax
80101a5e:	0f 85 ca 00 00 00    	jne    80101b2e <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	8b 40 04             	mov    0x4(%eax),%eax
80101a6a:	c1 e8 03             	shr    $0x3,%eax
80101a6d:	89 c2                	mov    %eax,%edx
80101a6f:	a1 54 1d 11 80       	mov    0x80111d54,%eax
80101a74:	01 c2                	add    %eax,%edx
80101a76:	8b 45 08             	mov    0x8(%ebp),%eax
80101a79:	8b 00                	mov    (%eax),%eax
80101a7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a7f:	89 04 24             	mov    %eax,(%esp)
80101a82:	e8 2e e7 ff ff       	call   801001b5 <bread>
80101a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a8d:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	8b 40 04             	mov    0x4(%eax),%eax
80101a96:	83 e0 07             	and    $0x7,%eax
80101a99:	c1 e0 06             	shl    $0x6,%eax
80101a9c:	01 d0                	add    %edx,%eax
80101a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa4:	8b 00                	mov    (%eax),%eax
80101aa6:	8b 55 08             	mov    0x8(%ebp),%edx
80101aa9:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab0:	66 8b 40 02          	mov    0x2(%eax),%ax
80101ab4:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab7:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abe:	8b 40 04             	mov    0x4(%eax),%eax
80101ac1:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac4:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101acb:	66 8b 40 06          	mov    0x6(%eax),%ax
80101acf:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad2:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad9:	8b 50 08             	mov    0x8(%eax),%edx
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae5:	8d 50 0c             	lea    0xc(%eax),%edx
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	83 c0 5c             	add    $0x5c,%eax
80101aee:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101af5:	00 
80101af6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afa:	89 04 24             	mov    %eax,(%esp)
80101afd:	e8 51 36 00 00       	call   80105153 <memmove>
    brelse(bp);
80101b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b05:	89 04 24             	mov    %eax,(%esp)
80101b08:	e8 1f e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	8b 40 50             	mov    0x50(%eax),%eax
80101b1d:	66 85 c0             	test   %ax,%ax
80101b20:	75 0c                	jne    80101b2e <ilock+0x108>
      panic("ilock: no type");
80101b22:	c7 04 24 c7 88 10 80 	movl   $0x801088c7,(%esp)
80101b29:	e8 26 ea ff ff       	call   80100554 <panic>
  }
}
80101b2e:	c9                   	leave  
80101b2f:	c3                   	ret    

80101b30 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b3a:	74 1c                	je     80101b58 <iunlock+0x28>
80101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3f:	83 c0 0c             	add    $0xc,%eax
80101b42:	89 04 24             	mov    %eax,(%esp)
80101b45:	e8 55 32 00 00       	call   80104d9f <holdingsleep>
80101b4a:	85 c0                	test   %eax,%eax
80101b4c:	74 0a                	je     80101b58 <iunlock+0x28>
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	8b 40 08             	mov    0x8(%eax),%eax
80101b54:	85 c0                	test   %eax,%eax
80101b56:	7f 0c                	jg     80101b64 <iunlock+0x34>
    panic("iunlock");
80101b58:	c7 04 24 d6 88 10 80 	movl   $0x801088d6,(%esp)
80101b5f:	e8 f0 e9 ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101b64:	8b 45 08             	mov    0x8(%ebp),%eax
80101b67:	83 c0 0c             	add    $0xc,%eax
80101b6a:	89 04 24             	mov    %eax,(%esp)
80101b6d:	e8 eb 31 00 00       	call   80104d5d <releasesleep>
}
80101b72:	c9                   	leave  
80101b73:	c3                   	ret    

80101b74 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7d:	83 c0 0c             	add    $0xc,%eax
80101b80:	89 04 24             	mov    %eax,(%esp)
80101b83:	e8 7a 31 00 00       	call   80104d02 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b88:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b8e:	85 c0                	test   %eax,%eax
80101b90:	74 5c                	je     80101bee <iput+0x7a>
80101b92:	8b 45 08             	mov    0x8(%ebp),%eax
80101b95:	66 8b 40 56          	mov    0x56(%eax),%ax
80101b99:	66 85 c0             	test   %ax,%ax
80101b9c:	75 50                	jne    80101bee <iput+0x7a>
    acquire(&icache.lock);
80101b9e:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101ba5:	e8 7d 32 00 00       	call   80104e27 <acquire>
    int r = ip->ref;
80101baa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bad:	8b 40 08             	mov    0x8(%eax),%eax
80101bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bb3:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101bba:	e8 d2 32 00 00       	call   80104e91 <release>
    if(r == 1){
80101bbf:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bc3:	75 29                	jne    80101bee <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 86 01 00 00       	call   80101d56 <itrunc>
      ip->type = 0;
80101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd3:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdc:	89 04 24             	mov    %eax,(%esp)
80101bdf:	e8 7f fc ff ff       	call   80101863 <iupdate>
      ip->valid = 0;
80101be4:	8b 45 08             	mov    0x8(%ebp),%eax
80101be7:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bee:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf1:	83 c0 0c             	add    $0xc,%eax
80101bf4:	89 04 24             	mov    %eax,(%esp)
80101bf7:	e8 61 31 00 00       	call   80104d5d <releasesleep>

  acquire(&icache.lock);
80101bfc:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101c03:	e8 1f 32 00 00       	call   80104e27 <acquire>
  ip->ref--;
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	8b 40 08             	mov    0x8(%eax),%eax
80101c0e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c17:	c7 04 24 60 1d 11 80 	movl   $0x80111d60,(%esp)
80101c1e:	e8 6e 32 00 00       	call   80104e91 <release>
}
80101c23:	c9                   	leave  
80101c24:	c3                   	ret    

80101c25 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c25:	55                   	push   %ebp
80101c26:	89 e5                	mov    %esp,%ebp
80101c28:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2e:	89 04 24             	mov    %eax,(%esp)
80101c31:	e8 fa fe ff ff       	call   80101b30 <iunlock>
  iput(ip);
80101c36:	8b 45 08             	mov    0x8(%ebp),%eax
80101c39:	89 04 24             	mov    %eax,(%esp)
80101c3c:	e8 33 ff ff ff       	call   80101b74 <iput>
}
80101c41:	c9                   	leave  
80101c42:	c3                   	ret    

80101c43 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c43:	55                   	push   %ebp
80101c44:	89 e5                	mov    %esp,%ebp
80101c46:	53                   	push   %ebx
80101c47:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c4a:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c4e:	77 3e                	ja     80101c8e <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c56:	83 c2 14             	add    $0x14,%edx
80101c59:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c64:	75 20                	jne    80101c86 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 00                	mov    (%eax),%eax
80101c6b:	89 04 24             	mov    %eax,(%esp)
80101c6e:	e8 48 f8 ff ff       	call   801014bb <balloc>
80101c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c7c:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c82:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c89:	e9 c2 00 00 00       	jmp    80101d50 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101c8e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c92:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c96:	0f 87 a8 00 00 00    	ja     80101d44 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cac:	75 1c                	jne    80101cca <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 00                	mov    (%eax),%eax
80101cb3:	89 04 24             	mov    %eax,(%esp)
80101cb6:	e8 00 f8 ff ff       	call   801014bb <balloc>
80101cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cc4:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccd:	8b 00                	mov    (%eax),%eax
80101ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cd6:	89 04 24             	mov    %eax,(%esp)
80101cd9:	e8 d7 e4 ff ff       	call   801001b5 <bread>
80101cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce4:	83 c0 5c             	add    $0x5c,%eax
80101ce7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ced:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf7:	01 d0                	add    %edx,%eax
80101cf9:	8b 00                	mov    (%eax),%eax
80101cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d02:	75 30                	jne    80101d34 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101d04:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d11:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d14:	8b 45 08             	mov    0x8(%ebp),%eax
80101d17:	8b 00                	mov    (%eax),%eax
80101d19:	89 04 24             	mov    %eax,(%esp)
80101d1c:	e8 9a f7 ff ff       	call   801014bb <balloc>
80101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d27:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2c:	89 04 24             	mov    %eax,(%esp)
80101d2f:	e8 ef 19 00 00       	call   80103723 <log_write>
    }
    brelse(bp);
80101d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d37:	89 04 24             	mov    %eax,(%esp)
80101d3a:	e8 ed e4 ff ff       	call   8010022c <brelse>
    return addr;
80101d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d42:	eb 0c                	jmp    80101d50 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101d44:	c7 04 24 de 88 10 80 	movl   $0x801088de,(%esp)
80101d4b:	e8 04 e8 ff ff       	call   80100554 <panic>
}
80101d50:	83 c4 24             	add    $0x24,%esp
80101d53:	5b                   	pop    %ebx
80101d54:	5d                   	pop    %ebp
80101d55:	c3                   	ret    

80101d56 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d56:	55                   	push   %ebp
80101d57:	89 e5                	mov    %esp,%ebp
80101d59:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d63:	eb 43                	jmp    80101da8 <itrunc+0x52>
    if(ip->addrs[i]){
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6b:	83 c2 14             	add    $0x14,%edx
80101d6e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d72:	85 c0                	test   %eax,%eax
80101d74:	74 2f                	je     80101da5 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101d76:	8b 45 08             	mov    0x8(%ebp),%eax
80101d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7c:	83 c2 14             	add    $0x14,%edx
80101d7f:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 00                	mov    (%eax),%eax
80101d88:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d8c:	89 04 24             	mov    %eax,(%esp)
80101d8f:	e8 61 f8 ff ff       	call   801015f5 <bfree>
      ip->addrs[i] = 0;
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9a:	83 c2 14             	add    $0x14,%edx
80101d9d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101da4:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101da5:	ff 45 f4             	incl   -0xc(%ebp)
80101da8:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dac:	7e b7                	jle    80101d65 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101db7:	85 c0                	test   %eax,%eax
80101db9:	0f 84 a3 00 00 00    	je     80101e62 <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc2:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcb:	8b 00                	mov    (%eax),%eax
80101dcd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dd1:	89 04 24             	mov    %eax,(%esp)
80101dd4:	e8 dc e3 ff ff       	call   801001b5 <bread>
80101dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ddf:	83 c0 5c             	add    $0x5c,%eax
80101de2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101de5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dec:	eb 3a                	jmp    80101e28 <itrunc+0xd2>
      if(a[j])
80101dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dfb:	01 d0                	add    %edx,%eax
80101dfd:	8b 00                	mov    (%eax),%eax
80101dff:	85 c0                	test   %eax,%eax
80101e01:	74 22                	je     80101e25 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e10:	01 d0                	add    %edx,%eax
80101e12:	8b 10                	mov    (%eax),%edx
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	8b 00                	mov    (%eax),%eax
80101e19:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e1d:	89 04 24             	mov    %eax,(%esp)
80101e20:	e8 d0 f7 ff ff       	call   801015f5 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e25:	ff 45 f0             	incl   -0x10(%ebp)
80101e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e2b:	83 f8 7f             	cmp    $0x7f,%eax
80101e2e:	76 be                	jbe    80101dee <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e33:	89 04 24             	mov    %eax,(%esp)
80101e36:	e8 f1 e3 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3e:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	8b 00                	mov    (%eax),%eax
80101e49:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e4d:	89 04 24             	mov    %eax,(%esp)
80101e50:	e8 a0 f7 ff ff       	call   801015f5 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e5f:	00 00 00 
  }

  ip->size = 0;
80101e62:	8b 45 08             	mov    0x8(%ebp),%eax
80101e65:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6f:	89 04 24             	mov    %eax,(%esp)
80101e72:	e8 ec f9 ff ff       	call   80101863 <iupdate>
}
80101e77:	c9                   	leave  
80101e78:	c3                   	ret    

80101e79 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e79:	55                   	push   %ebp
80101e7a:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7f:	8b 00                	mov    (%eax),%eax
80101e81:	89 c2                	mov    %eax,%edx
80101e83:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e86:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e89:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8c:	8b 50 04             	mov    0x4(%eax),%edx
80101e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e92:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e95:	8b 45 08             	mov    0x8(%ebp),%eax
80101e98:	8b 40 50             	mov    0x50(%eax),%eax
80101e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e9e:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	66 8b 40 56          	mov    0x56(%eax),%ax
80101ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
80101eab:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb2:	8b 50 58             	mov    0x58(%eax),%edx
80101eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb8:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ebb:	5d                   	pop    %ebp
80101ebc:	c3                   	ret    

80101ebd <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ebd:	55                   	push   %ebp
80101ebe:	89 e5                	mov    %esp,%ebp
80101ec0:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	8b 40 50             	mov    0x50(%eax),%eax
80101ec9:	66 83 f8 03          	cmp    $0x3,%ax
80101ecd:	75 60                	jne    80101f2f <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ed6:	66 85 c0             	test   %ax,%ax
80101ed9:	78 20                	js     80101efb <readi+0x3e>
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ede:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ee2:	66 83 f8 09          	cmp    $0x9,%ax
80101ee6:	7f 13                	jg     80101efb <readi+0x3e>
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	66 8b 40 52          	mov    0x52(%eax),%ax
80101eef:	98                   	cwtl   
80101ef0:	8b 04 c5 e0 1c 11 80 	mov    -0x7feee320(,%eax,8),%eax
80101ef7:	85 c0                	test   %eax,%eax
80101ef9:	75 0a                	jne    80101f05 <readi+0x48>
      return -1;
80101efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f00:	e9 1a 01 00 00       	jmp    8010201f <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101f05:	8b 45 08             	mov    0x8(%ebp),%eax
80101f08:	66 8b 40 52          	mov    0x52(%eax),%ax
80101f0c:	98                   	cwtl   
80101f0d:	8b 04 c5 e0 1c 11 80 	mov    -0x7feee320(,%eax,8),%eax
80101f14:	8b 55 14             	mov    0x14(%ebp),%edx
80101f17:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f1e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f22:	8b 55 08             	mov    0x8(%ebp),%edx
80101f25:	89 14 24             	mov    %edx,(%esp)
80101f28:	ff d0                	call   *%eax
80101f2a:	e9 f0 00 00 00       	jmp    8010201f <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f32:	8b 40 58             	mov    0x58(%eax),%eax
80101f35:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f38:	72 0d                	jb     80101f47 <readi+0x8a>
80101f3a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f3d:	8b 55 10             	mov    0x10(%ebp),%edx
80101f40:	01 d0                	add    %edx,%eax
80101f42:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f45:	73 0a                	jae    80101f51 <readi+0x94>
    return -1;
80101f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4c:	e9 ce 00 00 00       	jmp    8010201f <readi+0x162>
  if(off + n > ip->size)
80101f51:	8b 45 14             	mov    0x14(%ebp),%eax
80101f54:	8b 55 10             	mov    0x10(%ebp),%edx
80101f57:	01 c2                	add    %eax,%edx
80101f59:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5c:	8b 40 58             	mov    0x58(%eax),%eax
80101f5f:	39 c2                	cmp    %eax,%edx
80101f61:	76 0c                	jbe    80101f6f <readi+0xb2>
    n = ip->size - off;
80101f63:	8b 45 08             	mov    0x8(%ebp),%eax
80101f66:	8b 40 58             	mov    0x58(%eax),%eax
80101f69:	2b 45 10             	sub    0x10(%ebp),%eax
80101f6c:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f76:	e9 95 00 00 00       	jmp    80102010 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f7b:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7e:	c1 e8 09             	shr    $0x9,%eax
80101f81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f85:	8b 45 08             	mov    0x8(%ebp),%eax
80101f88:	89 04 24             	mov    %eax,(%esp)
80101f8b:	e8 b3 fc ff ff       	call   80101c43 <bmap>
80101f90:	8b 55 08             	mov    0x8(%ebp),%edx
80101f93:	8b 12                	mov    (%edx),%edx
80101f95:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f99:	89 14 24             	mov    %edx,(%esp)
80101f9c:	e8 14 e2 ff ff       	call   801001b5 <bread>
80101fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa4:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fac:	89 c2                	mov    %eax,%edx
80101fae:	b8 00 02 00 00       	mov    $0x200,%eax
80101fb3:	29 d0                	sub    %edx,%eax
80101fb5:	89 c1                	mov    %eax,%ecx
80101fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fba:	8b 55 14             	mov    0x14(%ebp),%edx
80101fbd:	29 c2                	sub    %eax,%edx
80101fbf:	89 c8                	mov    %ecx,%eax
80101fc1:	39 d0                	cmp    %edx,%eax
80101fc3:	76 02                	jbe    80101fc7 <readi+0x10a>
80101fc5:	89 d0                	mov    %edx,%eax
80101fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fca:	8b 45 10             	mov    0x10(%ebp),%eax
80101fcd:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fd2:	8d 50 50             	lea    0x50(%eax),%edx
80101fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd8:	01 d0                	add    %edx,%eax
80101fda:	8d 50 0c             	lea    0xc(%eax),%edx
80101fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fe0:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fe4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101feb:	89 04 24             	mov    %eax,(%esp)
80101fee:	e8 60 31 00 00       	call   80105153 <memmove>
    brelse(bp);
80101ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff6:	89 04 24             	mov    %eax,(%esp)
80101ff9:	e8 2e e2 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102001:	01 45 f4             	add    %eax,-0xc(%ebp)
80102004:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102007:	01 45 10             	add    %eax,0x10(%ebp)
8010200a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200d:	01 45 0c             	add    %eax,0xc(%ebp)
80102010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102013:	3b 45 14             	cmp    0x14(%ebp),%eax
80102016:	0f 82 5f ff ff ff    	jb     80101f7b <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010201c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010201f:	c9                   	leave  
80102020:	c3                   	ret    

80102021 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102021:	55                   	push   %ebp
80102022:	89 e5                	mov    %esp,%ebp
80102024:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102027:	8b 45 08             	mov    0x8(%ebp),%eax
8010202a:	8b 40 50             	mov    0x50(%eax),%eax
8010202d:	66 83 f8 03          	cmp    $0x3,%ax
80102031:	75 60                	jne    80102093 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102033:	8b 45 08             	mov    0x8(%ebp),%eax
80102036:	66 8b 40 52          	mov    0x52(%eax),%ax
8010203a:	66 85 c0             	test   %ax,%ax
8010203d:	78 20                	js     8010205f <writei+0x3e>
8010203f:	8b 45 08             	mov    0x8(%ebp),%eax
80102042:	66 8b 40 52          	mov    0x52(%eax),%ax
80102046:	66 83 f8 09          	cmp    $0x9,%ax
8010204a:	7f 13                	jg     8010205f <writei+0x3e>
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	66 8b 40 52          	mov    0x52(%eax),%ax
80102053:	98                   	cwtl   
80102054:	8b 04 c5 e4 1c 11 80 	mov    -0x7feee31c(,%eax,8),%eax
8010205b:	85 c0                	test   %eax,%eax
8010205d:	75 0a                	jne    80102069 <writei+0x48>
      return -1;
8010205f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102064:	e9 45 01 00 00       	jmp    801021ae <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102069:	8b 45 08             	mov    0x8(%ebp),%eax
8010206c:	66 8b 40 52          	mov    0x52(%eax),%ax
80102070:	98                   	cwtl   
80102071:	8b 04 c5 e4 1c 11 80 	mov    -0x7feee31c(,%eax,8),%eax
80102078:	8b 55 14             	mov    0x14(%ebp),%edx
8010207b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010207f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102082:	89 54 24 04          	mov    %edx,0x4(%esp)
80102086:	8b 55 08             	mov    0x8(%ebp),%edx
80102089:	89 14 24             	mov    %edx,(%esp)
8010208c:	ff d0                	call   *%eax
8010208e:	e9 1b 01 00 00       	jmp    801021ae <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80102093:	8b 45 08             	mov    0x8(%ebp),%eax
80102096:	8b 40 58             	mov    0x58(%eax),%eax
80102099:	3b 45 10             	cmp    0x10(%ebp),%eax
8010209c:	72 0d                	jb     801020ab <writei+0x8a>
8010209e:	8b 45 14             	mov    0x14(%ebp),%eax
801020a1:	8b 55 10             	mov    0x10(%ebp),%edx
801020a4:	01 d0                	add    %edx,%eax
801020a6:	3b 45 10             	cmp    0x10(%ebp),%eax
801020a9:	73 0a                	jae    801020b5 <writei+0x94>
    return -1;
801020ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b0:	e9 f9 00 00 00       	jmp    801021ae <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
801020b5:	8b 45 14             	mov    0x14(%ebp),%eax
801020b8:	8b 55 10             	mov    0x10(%ebp),%edx
801020bb:	01 d0                	add    %edx,%eax
801020bd:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020c2:	76 0a                	jbe    801020ce <writei+0xad>
    return -1;
801020c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c9:	e9 e0 00 00 00       	jmp    801021ae <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020d5:	e9 a0 00 00 00       	jmp    8010217a <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020da:	8b 45 10             	mov    0x10(%ebp),%eax
801020dd:	c1 e8 09             	shr    $0x9,%eax
801020e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801020e4:	8b 45 08             	mov    0x8(%ebp),%eax
801020e7:	89 04 24             	mov    %eax,(%esp)
801020ea:	e8 54 fb ff ff       	call   80101c43 <bmap>
801020ef:	8b 55 08             	mov    0x8(%ebp),%edx
801020f2:	8b 12                	mov    (%edx),%edx
801020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f8:	89 14 24             	mov    %edx,(%esp)
801020fb:	e8 b5 e0 ff ff       	call   801001b5 <bread>
80102100:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102103:	8b 45 10             	mov    0x10(%ebp),%eax
80102106:	25 ff 01 00 00       	and    $0x1ff,%eax
8010210b:	89 c2                	mov    %eax,%edx
8010210d:	b8 00 02 00 00       	mov    $0x200,%eax
80102112:	29 d0                	sub    %edx,%eax
80102114:	89 c1                	mov    %eax,%ecx
80102116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102119:	8b 55 14             	mov    0x14(%ebp),%edx
8010211c:	29 c2                	sub    %eax,%edx
8010211e:	89 c8                	mov    %ecx,%eax
80102120:	39 d0                	cmp    %edx,%eax
80102122:	76 02                	jbe    80102126 <writei+0x105>
80102124:	89 d0                	mov    %edx,%eax
80102126:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102129:	8b 45 10             	mov    0x10(%ebp),%eax
8010212c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102131:	8d 50 50             	lea    0x50(%eax),%edx
80102134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102137:	01 d0                	add    %edx,%eax
80102139:	8d 50 0c             	lea    0xc(%eax),%edx
8010213c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010213f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102143:	8b 45 0c             	mov    0xc(%ebp),%eax
80102146:	89 44 24 04          	mov    %eax,0x4(%esp)
8010214a:	89 14 24             	mov    %edx,(%esp)
8010214d:	e8 01 30 00 00       	call   80105153 <memmove>
    log_write(bp);
80102152:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102155:	89 04 24             	mov    %eax,(%esp)
80102158:	e8 c6 15 00 00       	call   80103723 <log_write>
    brelse(bp);
8010215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102160:	89 04 24             	mov    %eax,(%esp)
80102163:	e8 c4 e0 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102171:	01 45 10             	add    %eax,0x10(%ebp)
80102174:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102177:	01 45 0c             	add    %eax,0xc(%ebp)
8010217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010217d:	3b 45 14             	cmp    0x14(%ebp),%eax
80102180:	0f 82 54 ff ff ff    	jb     801020da <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102186:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010218a:	74 1f                	je     801021ab <writei+0x18a>
8010218c:	8b 45 08             	mov    0x8(%ebp),%eax
8010218f:	8b 40 58             	mov    0x58(%eax),%eax
80102192:	3b 45 10             	cmp    0x10(%ebp),%eax
80102195:	73 14                	jae    801021ab <writei+0x18a>
    ip->size = off;
80102197:	8b 45 08             	mov    0x8(%ebp),%eax
8010219a:	8b 55 10             	mov    0x10(%ebp),%edx
8010219d:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021a0:	8b 45 08             	mov    0x8(%ebp),%eax
801021a3:	89 04 24             	mov    %eax,(%esp)
801021a6:	e8 b8 f6 ff ff       	call   80101863 <iupdate>
  }
  return n;
801021ab:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021ae:	c9                   	leave  
801021af:	c3                   	ret    

801021b0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801021b6:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021bd:	00 
801021be:	8b 45 0c             	mov    0xc(%ebp),%eax
801021c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c5:	8b 45 08             	mov    0x8(%ebp),%eax
801021c8:	89 04 24             	mov    %eax,(%esp)
801021cb:	e8 22 30 00 00       	call   801051f2 <strncmp>
}
801021d0:	c9                   	leave  
801021d1:	c3                   	ret    

801021d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d2:	55                   	push   %ebp
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8b 40 50             	mov    0x50(%eax),%eax
801021de:	66 83 f8 01          	cmp    $0x1,%ax
801021e2:	74 0c                	je     801021f0 <dirlookup+0x1e>
    panic("dirlookup not DIR");
801021e4:	c7 04 24 f1 88 10 80 	movl   $0x801088f1,(%esp)
801021eb:	e8 64 e3 ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f7:	e9 86 00 00 00       	jmp    80102282 <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fc:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102203:	00 
80102204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102207:	89 44 24 08          	mov    %eax,0x8(%esp)
8010220b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010220e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102212:	8b 45 08             	mov    0x8(%ebp),%eax
80102215:	89 04 24             	mov    %eax,(%esp)
80102218:	e8 a0 fc ff ff       	call   80101ebd <readi>
8010221d:	83 f8 10             	cmp    $0x10,%eax
80102220:	74 0c                	je     8010222e <dirlookup+0x5c>
      panic("dirlookup read");
80102222:	c7 04 24 03 89 10 80 	movl   $0x80108903,(%esp)
80102229:	e8 26 e3 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
8010222e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102231:	66 85 c0             	test   %ax,%ax
80102234:	75 02                	jne    80102238 <dirlookup+0x66>
      continue;
80102236:	eb 46                	jmp    8010227e <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
80102238:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223b:	83 c0 02             	add    $0x2,%eax
8010223e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102242:	8b 45 0c             	mov    0xc(%ebp),%eax
80102245:	89 04 24             	mov    %eax,(%esp)
80102248:	e8 63 ff ff ff       	call   801021b0 <namecmp>
8010224d:	85 c0                	test   %eax,%eax
8010224f:	75 2d                	jne    8010227e <dirlookup+0xac>
      // entry matches path element
      if(poff)
80102251:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102255:	74 08                	je     8010225f <dirlookup+0x8d>
        *poff = off;
80102257:	8b 45 10             	mov    0x10(%ebp),%eax
8010225a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010225d:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010225f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102262:	0f b7 c0             	movzwl %ax,%eax
80102265:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102268:	8b 45 08             	mov    0x8(%ebp),%eax
8010226b:	8b 00                	mov    (%eax),%eax
8010226d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102270:	89 54 24 04          	mov    %edx,0x4(%esp)
80102274:	89 04 24             	mov    %eax,(%esp)
80102277:	e8 a3 f6 ff ff       	call   8010191f <iget>
8010227c:	eb 18                	jmp    80102296 <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010227e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102282:	8b 45 08             	mov    0x8(%ebp),%eax
80102285:	8b 40 58             	mov    0x58(%eax),%eax
80102288:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010228b:	0f 87 6b ff ff ff    	ja     801021fc <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102291:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102296:	c9                   	leave  
80102297:	c3                   	ret    

80102298 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102298:	55                   	push   %ebp
80102299:	89 e5                	mov    %esp,%ebp
8010229b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010229e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801022a5:	00 
801022a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801022a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ad:	8b 45 08             	mov    0x8(%ebp),%eax
801022b0:	89 04 24             	mov    %eax,(%esp)
801022b3:	e8 1a ff ff ff       	call   801021d2 <dirlookup>
801022b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022bf:	74 15                	je     801022d6 <dirlink+0x3e>
    iput(ip);
801022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022c4:	89 04 24             	mov    %eax,(%esp)
801022c7:	e8 a8 f8 ff ff       	call   80101b74 <iput>
    return -1;
801022cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d1:	e9 b6 00 00 00       	jmp    8010238c <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022dd:	eb 45                	jmp    80102324 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022e9:	00 
801022ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801022ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f5:	8b 45 08             	mov    0x8(%ebp),%eax
801022f8:	89 04 24             	mov    %eax,(%esp)
801022fb:	e8 bd fb ff ff       	call   80101ebd <readi>
80102300:	83 f8 10             	cmp    $0x10,%eax
80102303:	74 0c                	je     80102311 <dirlink+0x79>
      panic("dirlink read");
80102305:	c7 04 24 12 89 10 80 	movl   $0x80108912,(%esp)
8010230c:	e8 43 e2 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
80102311:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102314:	66 85 c0             	test   %ax,%ax
80102317:	75 02                	jne    8010231b <dirlink+0x83>
      break;
80102319:	eb 16                	jmp    80102331 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231e:	83 c0 10             	add    $0x10,%eax
80102321:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102324:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102327:	8b 45 08             	mov    0x8(%ebp),%eax
8010232a:	8b 40 58             	mov    0x58(%eax),%eax
8010232d:	39 c2                	cmp    %eax,%edx
8010232f:	72 ae                	jb     801022df <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102331:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102338:	00 
80102339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010233c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102340:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102343:	83 c0 02             	add    $0x2,%eax
80102346:	89 04 24             	mov    %eax,(%esp)
80102349:	e8 f2 2e 00 00       	call   80105240 <strncpy>
  de.inum = inum;
8010234e:	8b 45 10             	mov    0x10(%ebp),%eax
80102351:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102358:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010235f:	00 
80102360:	89 44 24 08          	mov    %eax,0x8(%esp)
80102364:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102367:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236b:	8b 45 08             	mov    0x8(%ebp),%eax
8010236e:	89 04 24             	mov    %eax,(%esp)
80102371:	e8 ab fc ff ff       	call   80102021 <writei>
80102376:	83 f8 10             	cmp    $0x10,%eax
80102379:	74 0c                	je     80102387 <dirlink+0xef>
    panic("dirlink");
8010237b:	c7 04 24 1f 89 10 80 	movl   $0x8010891f,(%esp)
80102382:	e8 cd e1 ff ff       	call   80100554 <panic>

  return 0;
80102387:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010238c:	c9                   	leave  
8010238d:	c3                   	ret    

8010238e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010238e:	55                   	push   %ebp
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102394:	eb 03                	jmp    80102399 <skipelem+0xb>
    path++;
80102396:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	8a 00                	mov    (%eax),%al
8010239e:	3c 2f                	cmp    $0x2f,%al
801023a0:	74 f4                	je     80102396 <skipelem+0x8>
    path++;
  if(*path == 0)
801023a2:	8b 45 08             	mov    0x8(%ebp),%eax
801023a5:	8a 00                	mov    (%eax),%al
801023a7:	84 c0                	test   %al,%al
801023a9:	75 0a                	jne    801023b5 <skipelem+0x27>
    return 0;
801023ab:	b8 00 00 00 00       	mov    $0x0,%eax
801023b0:	e9 81 00 00 00       	jmp    80102436 <skipelem+0xa8>
  s = path;
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
801023b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023bb:	eb 03                	jmp    801023c0 <skipelem+0x32>
    path++;
801023bd:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023c0:	8b 45 08             	mov    0x8(%ebp),%eax
801023c3:	8a 00                	mov    (%eax),%al
801023c5:	3c 2f                	cmp    $0x2f,%al
801023c7:	74 09                	je     801023d2 <skipelem+0x44>
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
801023cc:	8a 00                	mov    (%eax),%al
801023ce:	84 c0                	test   %al,%al
801023d0:	75 eb                	jne    801023bd <skipelem+0x2f>
    path++;
  len = path - s;
801023d2:	8b 55 08             	mov    0x8(%ebp),%edx
801023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d8:	29 c2                	sub    %eax,%edx
801023da:	89 d0                	mov    %edx,%eax
801023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023df:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e3:	7e 1c                	jle    80102401 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
801023e5:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801023ec:	00 
801023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801023f7:	89 04 24             	mov    %eax,(%esp)
801023fa:	e8 54 2d 00 00       	call   80105153 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023ff:	eb 29                	jmp    8010242a <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102404:	89 44 24 08          	mov    %eax,0x8(%esp)
80102408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010240f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102412:	89 04 24             	mov    %eax,(%esp)
80102415:	e8 39 2d 00 00       	call   80105153 <memmove>
    name[len] = 0;
8010241a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010241d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102420:	01 d0                	add    %edx,%eax
80102422:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102425:	eb 03                	jmp    8010242a <skipelem+0x9c>
    path++;
80102427:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
8010242d:	8a 00                	mov    (%eax),%al
8010242f:	3c 2f                	cmp    $0x2f,%al
80102431:	74 f4                	je     80102427 <skipelem+0x99>
    path++;
  return path;
80102433:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102436:	c9                   	leave  
80102437:	c3                   	ret    

80102438 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102438:	55                   	push   %ebp
80102439:	89 e5                	mov    %esp,%ebp
8010243b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010243e:	8b 45 08             	mov    0x8(%ebp),%eax
80102441:	8a 00                	mov    (%eax),%al
80102443:	3c 2f                	cmp    $0x2f,%al
80102445:	75 1c                	jne    80102463 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244e:	00 
8010244f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102456:	e8 c4 f4 ff ff       	call   8010191f <iget>
8010245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010245e:	e9 ac 00 00 00       	jmp    8010250f <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102463:	e8 af 1d 00 00       	call   80104217 <myproc>
80102468:	8b 40 68             	mov    0x68(%eax),%eax
8010246b:	89 04 24             	mov    %eax,(%esp)
8010246e:	e8 81 f5 ff ff       	call   801019f4 <idup>
80102473:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102476:	e9 94 00 00 00       	jmp    8010250f <namex+0xd7>
    ilock(ip);
8010247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247e:	89 04 24             	mov    %eax,(%esp)
80102481:	e8 a0 f5 ff ff       	call   80101a26 <ilock>
    if(ip->type != T_DIR){
80102486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102489:	8b 40 50             	mov    0x50(%eax),%eax
8010248c:	66 83 f8 01          	cmp    $0x1,%ax
80102490:	74 15                	je     801024a7 <namex+0x6f>
      iunlockput(ip);
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102495:	89 04 24             	mov    %eax,(%esp)
80102498:	e8 88 f7 ff ff       	call   80101c25 <iunlockput>
      return 0;
8010249d:	b8 00 00 00 00       	mov    $0x0,%eax
801024a2:	e9 a2 00 00 00       	jmp    80102549 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
801024a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ab:	74 1c                	je     801024c9 <namex+0x91>
801024ad:	8b 45 08             	mov    0x8(%ebp),%eax
801024b0:	8a 00                	mov    (%eax),%al
801024b2:	84 c0                	test   %al,%al
801024b4:	75 13                	jne    801024c9 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
801024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024b9:	89 04 24             	mov    %eax,(%esp)
801024bc:	e8 6f f6 ff ff       	call   80101b30 <iunlock>
      return ip;
801024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c4:	e9 80 00 00 00       	jmp    80102549 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801024d0:	00 
801024d1:	8b 45 10             	mov    0x10(%ebp),%eax
801024d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024db:	89 04 24             	mov    %eax,(%esp)
801024de:	e8 ef fc ff ff       	call   801021d2 <dirlookup>
801024e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024ea:	75 12                	jne    801024fe <namex+0xc6>
      iunlockput(ip);
801024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ef:	89 04 24             	mov    %eax,(%esp)
801024f2:	e8 2e f7 ff ff       	call   80101c25 <iunlockput>
      return 0;
801024f7:	b8 00 00 00 00       	mov    $0x0,%eax
801024fc:	eb 4b                	jmp    80102549 <namex+0x111>
    }
    iunlockput(ip);
801024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102501:	89 04 24             	mov    %eax,(%esp)
80102504:	e8 1c f7 ff ff       	call   80101c25 <iunlockput>
    ip = next;
80102509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010250f:	8b 45 10             	mov    0x10(%ebp),%eax
80102512:	89 44 24 04          	mov    %eax,0x4(%esp)
80102516:	8b 45 08             	mov    0x8(%ebp),%eax
80102519:	89 04 24             	mov    %eax,(%esp)
8010251c:	e8 6d fe ff ff       	call   8010238e <skipelem>
80102521:	89 45 08             	mov    %eax,0x8(%ebp)
80102524:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102528:	0f 85 4d ff ff ff    	jne    8010247b <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010252e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102532:	74 12                	je     80102546 <namex+0x10e>
    iput(ip);
80102534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102537:	89 04 24             	mov    %eax,(%esp)
8010253a:	e8 35 f6 ff ff       	call   80101b74 <iput>
    return 0;
8010253f:	b8 00 00 00 00       	mov    $0x0,%eax
80102544:	eb 03                	jmp    80102549 <namex+0x111>
  }
  return ip;
80102546:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102549:	c9                   	leave  
8010254a:	c3                   	ret    

8010254b <namei>:

struct inode*
namei(char *path)
{
8010254b:	55                   	push   %ebp
8010254c:	89 e5                	mov    %esp,%ebp
8010254e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102551:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102554:	89 44 24 08          	mov    %eax,0x8(%esp)
80102558:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010255f:	00 
80102560:	8b 45 08             	mov    0x8(%ebp),%eax
80102563:	89 04 24             	mov    %eax,(%esp)
80102566:	e8 cd fe ff ff       	call   80102438 <namex>
}
8010256b:	c9                   	leave  
8010256c:	c3                   	ret    

8010256d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256d:	55                   	push   %ebp
8010256e:	89 e5                	mov    %esp,%ebp
80102570:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102573:	8b 45 0c             	mov    0xc(%ebp),%eax
80102576:	89 44 24 08          	mov    %eax,0x8(%esp)
8010257a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102581:	00 
80102582:	8b 45 08             	mov    0x8(%ebp),%eax
80102585:	89 04 24             	mov    %eax,(%esp)
80102588:	e8 ab fe ff ff       	call   80102438 <namex>
}
8010258d:	c9                   	leave  
8010258e:	c3                   	ret    
	...

80102590 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	83 ec 14             	sub    $0x14,%esp
80102596:	8b 45 08             	mov    0x8(%ebp),%eax
80102599:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801025a0:	89 c2                	mov    %eax,%edx
801025a2:	ec                   	in     (%dx),%al
801025a3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025a6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801025a9:	c9                   	leave  
801025aa:	c3                   	ret    

801025ab <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025ab:	55                   	push   %ebp
801025ac:	89 e5                	mov    %esp,%ebp
801025ae:	57                   	push   %edi
801025af:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025b0:	8b 55 08             	mov    0x8(%ebp),%edx
801025b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025b6:	8b 45 10             	mov    0x10(%ebp),%eax
801025b9:	89 cb                	mov    %ecx,%ebx
801025bb:	89 df                	mov    %ebx,%edi
801025bd:	89 c1                	mov    %eax,%ecx
801025bf:	fc                   	cld    
801025c0:	f3 6d                	rep insl (%dx),%es:(%edi)
801025c2:	89 c8                	mov    %ecx,%eax
801025c4:	89 fb                	mov    %edi,%ebx
801025c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025cc:	5b                   	pop    %ebx
801025cd:	5f                   	pop    %edi
801025ce:	5d                   	pop    %ebp
801025cf:	c3                   	ret    

801025d0 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 08             	sub    $0x8,%esp
801025d6:	8b 45 08             	mov    0x8(%ebp),%eax
801025d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801025dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801025e0:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e3:	8a 45 f8             	mov    -0x8(%ebp),%al
801025e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801025e9:	ee                   	out    %al,(%dx)
}
801025ea:	c9                   	leave  
801025eb:	c3                   	ret    

801025ec <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025ec:	55                   	push   %ebp
801025ed:	89 e5                	mov    %esp,%ebp
801025ef:	56                   	push   %esi
801025f0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025f1:	8b 55 08             	mov    0x8(%ebp),%edx
801025f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f7:	8b 45 10             	mov    0x10(%ebp),%eax
801025fa:	89 cb                	mov    %ecx,%ebx
801025fc:	89 de                	mov    %ebx,%esi
801025fe:	89 c1                	mov    %eax,%ecx
80102600:	fc                   	cld    
80102601:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102603:	89 c8                	mov    %ecx,%eax
80102605:	89 f3                	mov    %esi,%ebx
80102607:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010260a:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010260d:	5b                   	pop    %ebx
8010260e:	5e                   	pop    %esi
8010260f:	5d                   	pop    %ebp
80102610:	c3                   	ret    

80102611 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102611:	55                   	push   %ebp
80102612:	89 e5                	mov    %esp,%ebp
80102614:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102617:	90                   	nop
80102618:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010261f:	e8 6c ff ff ff       	call   80102590 <inb>
80102624:	0f b6 c0             	movzbl %al,%eax
80102627:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010262a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262d:	25 c0 00 00 00       	and    $0xc0,%eax
80102632:	83 f8 40             	cmp    $0x40,%eax
80102635:	75 e1                	jne    80102618 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010263b:	74 11                	je     8010264e <idewait+0x3d>
8010263d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102640:	83 e0 21             	and    $0x21,%eax
80102643:	85 c0                	test   %eax,%eax
80102645:	74 07                	je     8010264e <idewait+0x3d>
    return -1;
80102647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264c:	eb 05                	jmp    80102653 <idewait+0x42>
  return 0;
8010264e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102653:	c9                   	leave  
80102654:	c3                   	ret    

80102655 <ideinit>:

void
ideinit(void)
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
80102658:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010265b:	c7 44 24 04 27 89 10 	movl   $0x80108927,0x4(%esp)
80102662:	80 
80102663:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010266a:	e8 97 27 00 00       	call   80104e06 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010266f:	a1 80 40 11 80       	mov    0x80114080,%eax
80102674:	48                   	dec    %eax
80102675:	89 44 24 04          	mov    %eax,0x4(%esp)
80102679:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102680:	e8 66 04 00 00       	call   80102aeb <ioapicenable>
  idewait(0);
80102685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010268c:	e8 80 ff ff ff       	call   80102611 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102691:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102698:	00 
80102699:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026a0:	e8 2b ff ff ff       	call   801025d0 <outb>
  for(i=0; i<1000; i++){
801026a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ac:	eb 1f                	jmp    801026cd <ideinit+0x78>
    if(inb(0x1f7) != 0){
801026ae:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b5:	e8 d6 fe ff ff       	call   80102590 <inb>
801026ba:	84 c0                	test   %al,%al
801026bc:	74 0c                	je     801026ca <ideinit+0x75>
      havedisk1 = 1;
801026be:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
801026c5:	00 00 00 
      break;
801026c8:	eb 0c                	jmp    801026d6 <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801026ca:	ff 45 f4             	incl   -0xc(%ebp)
801026cd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026d4:	7e d8                	jle    801026ae <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026d6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801026dd:	00 
801026de:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026e5:	e8 e6 fe ff ff       	call   801025d0 <outb>
}
801026ea:	c9                   	leave  
801026eb:	c3                   	ret    

801026ec <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026ec:	55                   	push   %ebp
801026ed:	89 e5                	mov    %esp,%ebp
801026ef:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801026f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026f6:	75 0c                	jne    80102704 <idestart+0x18>
    panic("idestart");
801026f8:	c7 04 24 2b 89 10 80 	movl   $0x8010892b,(%esp)
801026ff:	e8 50 de ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
80102704:	8b 45 08             	mov    0x8(%ebp),%eax
80102707:	8b 40 08             	mov    0x8(%eax),%eax
8010270a:	3d 1f 4e 00 00       	cmp    $0x4e1f,%eax
8010270f:	76 0c                	jbe    8010271d <idestart+0x31>
    panic("incorrect blockno");
80102711:	c7 04 24 34 89 10 80 	movl   $0x80108934,(%esp)
80102718:	e8 37 de ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010271d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102724:	8b 45 08             	mov    0x8(%ebp),%eax
80102727:	8b 50 08             	mov    0x8(%eax),%edx
8010272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272d:	0f af c2             	imul   %edx,%eax
80102730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102733:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102737:	75 07                	jne    80102740 <idestart+0x54>
80102739:	b8 20 00 00 00       	mov    $0x20,%eax
8010273e:	eb 05                	jmp    80102745 <idestart+0x59>
80102740:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102745:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102748:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010274c:	75 07                	jne    80102755 <idestart+0x69>
8010274e:	b8 30 00 00 00       	mov    $0x30,%eax
80102753:	eb 05                	jmp    8010275a <idestart+0x6e>
80102755:	b8 c5 00 00 00       	mov    $0xc5,%eax
8010275a:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010275d:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102761:	7e 0c                	jle    8010276f <idestart+0x83>
80102763:	c7 04 24 2b 89 10 80 	movl   $0x8010892b,(%esp)
8010276a:	e8 e5 dd ff ff       	call   80100554 <panic>

  idewait(0);
8010276f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102776:	e8 96 fe ff ff       	call   80102611 <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010277b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102782:	00 
80102783:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010278a:	e8 41 fe ff ff       	call   801025d0 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
8010278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	89 44 24 04          	mov    %eax,0x4(%esp)
80102799:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801027a0:	e8 2b fe ff ff       	call   801025d0 <outb>
  outb(0x1f3, sector & 0xff);
801027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a8:	0f b6 c0             	movzbl %al,%eax
801027ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801027af:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801027b6:	e8 15 fe ff ff       	call   801025d0 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027be:	c1 f8 08             	sar    $0x8,%eax
801027c1:	0f b6 c0             	movzbl %al,%eax
801027c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c8:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801027cf:	e8 fc fd ff ff       	call   801025d0 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027d7:	c1 f8 10             	sar    $0x10,%eax
801027da:	0f b6 c0             	movzbl %al,%eax
801027dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e1:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801027e8:	e8 e3 fd ff ff       	call   801025d0 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027ed:	8b 45 08             	mov    0x8(%ebp),%eax
801027f0:	8b 40 04             	mov    0x4(%eax),%eax
801027f3:	83 e0 01             	and    $0x1,%eax
801027f6:	c1 e0 04             	shl    $0x4,%eax
801027f9:	88 c2                	mov    %al,%dl
801027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027fe:	c1 f8 18             	sar    $0x18,%eax
80102801:	83 e0 0f             	and    $0xf,%eax
80102804:	09 d0                	or     %edx,%eax
80102806:	83 c8 e0             	or     $0xffffffe0,%eax
80102809:	0f b6 c0             	movzbl %al,%eax
8010280c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102810:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102817:	e8 b4 fd ff ff       	call   801025d0 <outb>
  if(b->flags & B_DIRTY){
8010281c:	8b 45 08             	mov    0x8(%ebp),%eax
8010281f:	8b 00                	mov    (%eax),%eax
80102821:	83 e0 04             	and    $0x4,%eax
80102824:	85 c0                	test   %eax,%eax
80102826:	74 36                	je     8010285e <idestart+0x172>
    outb(0x1f7, write_cmd);
80102828:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010282b:	0f b6 c0             	movzbl %al,%eax
8010282e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102832:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102839:	e8 92 fd ff ff       	call   801025d0 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
8010283e:	8b 45 08             	mov    0x8(%ebp),%eax
80102841:	83 c0 5c             	add    $0x5c,%eax
80102844:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010284b:	00 
8010284c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102850:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102857:	e8 90 fd ff ff       	call   801025ec <outsl>
8010285c:	eb 16                	jmp    80102874 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
8010285e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102861:	0f b6 c0             	movzbl %al,%eax
80102864:	89 44 24 04          	mov    %eax,0x4(%esp)
80102868:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010286f:	e8 5c fd ff ff       	call   801025d0 <outb>
  }
}
80102874:	c9                   	leave  
80102875:	c3                   	ret    

80102876 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102876:	55                   	push   %ebp
80102877:	89 e5                	mov    %esp,%ebp
80102879:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010287c:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102883:	e8 9f 25 00 00       	call   80104e27 <acquire>

  if((b = idequeue) == 0){
80102888:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102894:	75 11                	jne    801028a7 <ideintr+0x31>
    release(&idelock);
80102896:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010289d:	e8 ef 25 00 00       	call   80104e91 <release>
    return;
801028a2:	e9 90 00 00 00       	jmp    80102937 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028aa:	8b 40 58             	mov    0x58(%eax),%eax
801028ad:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b5:	8b 00                	mov    (%eax),%eax
801028b7:	83 e0 04             	and    $0x4,%eax
801028ba:	85 c0                	test   %eax,%eax
801028bc:	75 2e                	jne    801028ec <ideintr+0x76>
801028be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028c5:	e8 47 fd ff ff       	call   80102611 <idewait>
801028ca:	85 c0                	test   %eax,%eax
801028cc:	78 1e                	js     801028ec <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d1:	83 c0 5c             	add    $0x5c,%eax
801028d4:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801028db:	00 
801028dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801028e0:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801028e7:	e8 bf fc ff ff       	call   801025ab <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ef:	8b 00                	mov    (%eax),%eax
801028f1:	83 c8 02             	or     $0x2,%eax
801028f4:	89 c2                	mov    %eax,%edx
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f9:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fe:	8b 00                	mov    (%eax),%eax
80102900:	83 e0 fb             	and    $0xfffffffb,%eax
80102903:	89 c2                	mov    %eax,%edx
80102905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102908:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290d:	89 04 24             	mov    %eax,(%esp)
80102910:	e8 17 22 00 00       	call   80104b2c <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102915:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010291a:	85 c0                	test   %eax,%eax
8010291c:	74 0d                	je     8010292b <ideintr+0xb5>
    idestart(idequeue);
8010291e:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102923:	89 04 24             	mov    %eax,(%esp)
80102926:	e8 c1 fd ff ff       	call   801026ec <idestart>

  release(&idelock);
8010292b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102932:	e8 5a 25 00 00       	call   80104e91 <release>
}
80102937:	c9                   	leave  
80102938:	c3                   	ret    

80102939 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102939:	55                   	push   %ebp
8010293a:	89 e5                	mov    %esp,%ebp
8010293c:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010293f:	8b 45 08             	mov    0x8(%ebp),%eax
80102942:	83 c0 0c             	add    $0xc,%eax
80102945:	89 04 24             	mov    %eax,(%esp)
80102948:	e8 52 24 00 00       	call   80104d9f <holdingsleep>
8010294d:	85 c0                	test   %eax,%eax
8010294f:	75 0c                	jne    8010295d <iderw+0x24>
    panic("iderw: buf not locked");
80102951:	c7 04 24 46 89 10 80 	movl   $0x80108946,(%esp)
80102958:	e8 f7 db ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010295d:	8b 45 08             	mov    0x8(%ebp),%eax
80102960:	8b 00                	mov    (%eax),%eax
80102962:	83 e0 06             	and    $0x6,%eax
80102965:	83 f8 02             	cmp    $0x2,%eax
80102968:	75 0c                	jne    80102976 <iderw+0x3d>
    panic("iderw: nothing to do");
8010296a:	c7 04 24 5c 89 10 80 	movl   $0x8010895c,(%esp)
80102971:	e8 de db ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
80102976:	8b 45 08             	mov    0x8(%ebp),%eax
80102979:	8b 40 04             	mov    0x4(%eax),%eax
8010297c:	85 c0                	test   %eax,%eax
8010297e:	74 15                	je     80102995 <iderw+0x5c>
80102980:	a1 58 b6 10 80       	mov    0x8010b658,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	75 0c                	jne    80102995 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102989:	c7 04 24 71 89 10 80 	movl   $0x80108971,(%esp)
80102990:	e8 bf db ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102995:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010299c:	e8 86 24 00 00       	call   80104e27 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801029a1:	8b 45 08             	mov    0x8(%ebp),%eax
801029a4:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029ab:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
801029b2:	eb 0b                	jmp    801029bf <iderw+0x86>
801029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b7:	8b 00                	mov    (%eax),%eax
801029b9:	83 c0 58             	add    $0x58,%eax
801029bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c2:	8b 00                	mov    (%eax),%eax
801029c4:	85 c0                	test   %eax,%eax
801029c6:	75 ec                	jne    801029b4 <iderw+0x7b>
    ;
  *pp = b;
801029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029cb:	8b 55 08             	mov    0x8(%ebp),%edx
801029ce:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029d0:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801029d5:	3b 45 08             	cmp    0x8(%ebp),%eax
801029d8:	75 0d                	jne    801029e7 <iderw+0xae>
    idestart(b);
801029da:	8b 45 08             	mov    0x8(%ebp),%eax
801029dd:	89 04 24             	mov    %eax,(%esp)
801029e0:	e8 07 fd ff ff       	call   801026ec <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029e5:	eb 15                	jmp    801029fc <iderw+0xc3>
801029e7:	eb 13                	jmp    801029fc <iderw+0xc3>
    sleep(b, &idelock);
801029e9:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
801029f0:	80 
801029f1:	8b 45 08             	mov    0x8(%ebp),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 5c 20 00 00       	call   80104a58 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029fc:	8b 45 08             	mov    0x8(%ebp),%eax
801029ff:	8b 00                	mov    (%eax),%eax
80102a01:	83 e0 06             	and    $0x6,%eax
80102a04:	83 f8 02             	cmp    $0x2,%eax
80102a07:	75 e0                	jne    801029e9 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102a09:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102a10:	e8 7c 24 00 00       	call   80104e91 <release>
}
80102a15:	c9                   	leave  
80102a16:	c3                   	ret    
	...

80102a18 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a18:	55                   	push   %ebp
80102a19:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a1b:	a1 b4 39 11 80       	mov    0x801139b4,%eax
80102a20:	8b 55 08             	mov    0x8(%ebp),%edx
80102a23:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a25:	a1 b4 39 11 80       	mov    0x801139b4,%eax
80102a2a:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a2d:	5d                   	pop    %ebp
80102a2e:	c3                   	ret    

80102a2f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a2f:	55                   	push   %ebp
80102a30:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a32:	a1 b4 39 11 80       	mov    0x801139b4,%eax
80102a37:	8b 55 08             	mov    0x8(%ebp),%edx
80102a3a:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a3c:	a1 b4 39 11 80       	mov    0x801139b4,%eax
80102a41:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a44:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a47:	5d                   	pop    %ebp
80102a48:	c3                   	ret    

80102a49 <ioapicinit>:

void
ioapicinit(void)
{
80102a49:	55                   	push   %ebp
80102a4a:	89 e5                	mov    %esp,%ebp
80102a4c:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a4f:	c7 05 b4 39 11 80 00 	movl   $0xfec00000,0x801139b4
80102a56:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a60:	e8 b3 ff ff ff       	call   80102a18 <ioapicread>
80102a65:	c1 e8 10             	shr    $0x10,%eax
80102a68:	25 ff 00 00 00       	and    $0xff,%eax
80102a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a77:	e8 9c ff ff ff       	call   80102a18 <ioapicread>
80102a7c:	c1 e8 18             	shr    $0x18,%eax
80102a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a82:	a0 e0 3a 11 80       	mov    0x80113ae0,%al
80102a87:	0f b6 c0             	movzbl %al,%eax
80102a8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a8d:	74 0c                	je     80102a9b <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a8f:	c7 04 24 90 89 10 80 	movl   $0x80108990,(%esp)
80102a96:	e8 26 d9 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102aa2:	eb 3d                	jmp    80102ae1 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa7:	83 c0 20             	add    $0x20,%eax
80102aaa:	0d 00 00 01 00       	or     $0x10000,%eax
80102aaf:	89 c2                	mov    %eax,%edx
80102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab4:	83 c0 08             	add    $0x8,%eax
80102ab7:	01 c0                	add    %eax,%eax
80102ab9:	89 54 24 04          	mov    %edx,0x4(%esp)
80102abd:	89 04 24             	mov    %eax,(%esp)
80102ac0:	e8 6a ff ff ff       	call   80102a2f <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac8:	83 c0 08             	add    $0x8,%eax
80102acb:	01 c0                	add    %eax,%eax
80102acd:	40                   	inc    %eax
80102ace:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ad5:	00 
80102ad6:	89 04 24             	mov    %eax,(%esp)
80102ad9:	e8 51 ff ff ff       	call   80102a2f <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ade:	ff 45 f4             	incl   -0xc(%ebp)
80102ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ae7:	7e bb                	jle    80102aa4 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ae9:	c9                   	leave  
80102aea:	c3                   	ret    

80102aeb <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aeb:	55                   	push   %ebp
80102aec:	89 e5                	mov    %esp,%ebp
80102aee:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102af1:	8b 45 08             	mov    0x8(%ebp),%eax
80102af4:	83 c0 20             	add    $0x20,%eax
80102af7:	89 c2                	mov    %eax,%edx
80102af9:	8b 45 08             	mov    0x8(%ebp),%eax
80102afc:	83 c0 08             	add    $0x8,%eax
80102aff:	01 c0                	add    %eax,%eax
80102b01:	89 54 24 04          	mov    %edx,0x4(%esp)
80102b05:	89 04 24             	mov    %eax,(%esp)
80102b08:	e8 22 ff ff ff       	call   80102a2f <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b10:	c1 e0 18             	shl    $0x18,%eax
80102b13:	8b 55 08             	mov    0x8(%ebp),%edx
80102b16:	83 c2 08             	add    $0x8,%edx
80102b19:	01 d2                	add    %edx,%edx
80102b1b:	42                   	inc    %edx
80102b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b20:	89 14 24             	mov    %edx,(%esp)
80102b23:	e8 07 ff ff ff       	call   80102a2f <ioapicwrite>
}
80102b28:	c9                   	leave  
80102b29:	c3                   	ret    
	...

80102b2c <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b2c:	55                   	push   %ebp
80102b2d:	89 e5                	mov    %esp,%ebp
80102b2f:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102b32:	c7 44 24 04 c2 89 10 	movl   $0x801089c2,0x4(%esp)
80102b39:	80 
80102b3a:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80102b41:	e8 c0 22 00 00       	call   80104e06 <initlock>
  kmem.use_lock = 0;
80102b46:	c7 05 f4 39 11 80 00 	movl   $0x0,0x801139f4
80102b4d:	00 00 00 
  freerange(vstart, vend);
80102b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b53:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b57:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5a:	89 04 24             	mov    %eax,(%esp)
80102b5d:	e8 26 00 00 00       	call   80102b88 <freerange>
}
80102b62:	c9                   	leave  
80102b63:	c3                   	ret    

80102b64 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b64:	55                   	push   %ebp
80102b65:	89 e5                	mov    %esp,%ebp
80102b67:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b71:	8b 45 08             	mov    0x8(%ebp),%eax
80102b74:	89 04 24             	mov    %eax,(%esp)
80102b77:	e8 0c 00 00 00       	call   80102b88 <freerange>
  kmem.use_lock = 1;
80102b7c:	c7 05 f4 39 11 80 01 	movl   $0x1,0x801139f4
80102b83:	00 00 00 
}
80102b86:	c9                   	leave  
80102b87:	c3                   	ret    

80102b88 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b88:	55                   	push   %ebp
80102b89:	89 e5                	mov    %esp,%ebp
80102b8b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b91:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b9e:	eb 12                	jmp    80102bb2 <freerange+0x2a>
    kfree(p);
80102ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba3:	89 04 24             	mov    %eax,(%esp)
80102ba6:	e8 16 00 00 00       	call   80102bc1 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bab:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb5:	05 00 10 00 00       	add    $0x1000,%eax
80102bba:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102bbd:	76 e1                	jbe    80102ba0 <freerange+0x18>
    kfree(p);
}
80102bbf:	c9                   	leave  
80102bc0:	c3                   	ret    

80102bc1 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bc1:	55                   	push   %ebp
80102bc2:	89 e5                	mov    %esp,%ebp
80102bc4:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80102bca:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bcf:	85 c0                	test   %eax,%eax
80102bd1:	75 18                	jne    80102beb <kfree+0x2a>
80102bd3:	81 7d 08 30 69 11 80 	cmpl   $0x80116930,0x8(%ebp)
80102bda:	72 0f                	jb     80102beb <kfree+0x2a>
80102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdf:	05 00 00 00 80       	add    $0x80000000,%eax
80102be4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102be9:	76 0c                	jbe    80102bf7 <kfree+0x36>
    panic("kfree");
80102beb:	c7 04 24 c7 89 10 80 	movl   $0x801089c7,(%esp)
80102bf2:	e8 5d d9 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bf7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102bfe:	00 
80102bff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102c06:	00 
80102c07:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0a:	89 04 24             	mov    %eax,(%esp)
80102c0d:	e8 78 24 00 00       	call   8010508a <memset>

  if(kmem.use_lock)
80102c12:	a1 f4 39 11 80       	mov    0x801139f4,%eax
80102c17:	85 c0                	test   %eax,%eax
80102c19:	74 0c                	je     80102c27 <kfree+0x66>
    acquire(&kmem.lock);
80102c1b:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80102c22:	e8 00 22 00 00       	call   80104e27 <acquire>
  r = (struct run*)v;
80102c27:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c2d:	8b 15 f8 39 11 80    	mov    0x801139f8,%edx
80102c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c36:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3b:	a3 f8 39 11 80       	mov    %eax,0x801139f8
  if(kmem.use_lock)
80102c40:	a1 f4 39 11 80       	mov    0x801139f4,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	74 0c                	je     80102c55 <kfree+0x94>
    release(&kmem.lock);
80102c49:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80102c50:	e8 3c 22 00 00       	call   80104e91 <release>
}
80102c55:	c9                   	leave  
80102c56:	c3                   	ret    

80102c57 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c57:	55                   	push   %ebp
80102c58:	89 e5                	mov    %esp,%ebp
80102c5a:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102c5d:	a1 f4 39 11 80       	mov    0x801139f4,%eax
80102c62:	85 c0                	test   %eax,%eax
80102c64:	74 0c                	je     80102c72 <kalloc+0x1b>
    acquire(&kmem.lock);
80102c66:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80102c6d:	e8 b5 21 00 00       	call   80104e27 <acquire>
  r = kmem.freelist;
80102c72:	a1 f8 39 11 80       	mov    0x801139f8,%eax
80102c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c7e:	74 0a                	je     80102c8a <kalloc+0x33>
    kmem.freelist = r->next;
80102c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c83:	8b 00                	mov    (%eax),%eax
80102c85:	a3 f8 39 11 80       	mov    %eax,0x801139f8
  if(kmem.use_lock)
80102c8a:	a1 f4 39 11 80       	mov    0x801139f4,%eax
80102c8f:	85 c0                	test   %eax,%eax
80102c91:	74 0c                	je     80102c9f <kalloc+0x48>
    release(&kmem.lock);
80102c93:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80102c9a:	e8 f2 21 00 00       	call   80104e91 <release>
  return (char*)r;
80102c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ca2:	c9                   	leave  
80102ca3:	c3                   	ret    

80102ca4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	83 ec 14             	sub    $0x14,%esp
80102caa:	8b 45 08             	mov    0x8(%ebp),%eax
80102cad:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102cb4:	89 c2                	mov    %eax,%edx
80102cb6:	ec                   	in     (%dx),%al
80102cb7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cba:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102cbd:	c9                   	leave  
80102cbe:	c3                   	ret    

80102cbf <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cbf:	55                   	push   %ebp
80102cc0:	89 e5                	mov    %esp,%ebp
80102cc2:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cc5:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102ccc:	e8 d3 ff ff ff       	call   80102ca4 <inb>
80102cd1:	0f b6 c0             	movzbl %al,%eax
80102cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cda:	83 e0 01             	and    $0x1,%eax
80102cdd:	85 c0                	test   %eax,%eax
80102cdf:	75 0a                	jne    80102ceb <kbdgetc+0x2c>
    return -1;
80102ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ce6:	e9 21 01 00 00       	jmp    80102e0c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102ceb:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102cf2:	e8 ad ff ff ff       	call   80102ca4 <inb>
80102cf7:	0f b6 c0             	movzbl %al,%eax
80102cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cfd:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d04:	75 17                	jne    80102d1d <kbdgetc+0x5e>
    shift |= E0ESC;
80102d06:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d0b:	83 c8 40             	or     $0x40,%eax
80102d0e:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102d13:	b8 00 00 00 00       	mov    $0x0,%eax
80102d18:	e9 ef 00 00 00       	jmp    80102e0c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d20:	25 80 00 00 00       	and    $0x80,%eax
80102d25:	85 c0                	test   %eax,%eax
80102d27:	74 44                	je     80102d6d <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d29:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d2e:	83 e0 40             	and    $0x40,%eax
80102d31:	85 c0                	test   %eax,%eax
80102d33:	75 08                	jne    80102d3d <kbdgetc+0x7e>
80102d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d38:	83 e0 7f             	and    $0x7f,%eax
80102d3b:	eb 03                	jmp    80102d40 <kbdgetc+0x81>
80102d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d46:	05 20 90 10 80       	add    $0x80109020,%eax
80102d4b:	8a 00                	mov    (%eax),%al
80102d4d:	83 c8 40             	or     $0x40,%eax
80102d50:	0f b6 c0             	movzbl %al,%eax
80102d53:	f7 d0                	not    %eax
80102d55:	89 c2                	mov    %eax,%edx
80102d57:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d5c:	21 d0                	and    %edx,%eax
80102d5e:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102d63:	b8 00 00 00 00       	mov    $0x0,%eax
80102d68:	e9 9f 00 00 00       	jmp    80102e0c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d6d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d72:	83 e0 40             	and    $0x40,%eax
80102d75:	85 c0                	test   %eax,%eax
80102d77:	74 14                	je     80102d8d <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d79:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d80:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d85:	83 e0 bf             	and    $0xffffffbf,%eax
80102d88:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d90:	05 20 90 10 80       	add    $0x80109020,%eax
80102d95:	8a 00                	mov    (%eax),%al
80102d97:	0f b6 d0             	movzbl %al,%edx
80102d9a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d9f:	09 d0                	or     %edx,%eax
80102da1:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da9:	05 20 91 10 80       	add    $0x80109120,%eax
80102dae:	8a 00                	mov    (%eax),%al
80102db0:	0f b6 d0             	movzbl %al,%edx
80102db3:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102db8:	31 d0                	xor    %edx,%eax
80102dba:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102dbf:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102dc4:	83 e0 03             	and    $0x3,%eax
80102dc7:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd1:	01 d0                	add    %edx,%eax
80102dd3:	8a 00                	mov    (%eax),%al
80102dd5:	0f b6 c0             	movzbl %al,%eax
80102dd8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ddb:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102de0:	83 e0 08             	and    $0x8,%eax
80102de3:	85 c0                	test   %eax,%eax
80102de5:	74 22                	je     80102e09 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102de7:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102deb:	76 0c                	jbe    80102df9 <kbdgetc+0x13a>
80102ded:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102df1:	77 06                	ja     80102df9 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102df3:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102df7:	eb 10                	jmp    80102e09 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102df9:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102dfd:	76 0a                	jbe    80102e09 <kbdgetc+0x14a>
80102dff:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e03:	77 04                	ja     80102e09 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e05:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e0c:	c9                   	leave  
80102e0d:	c3                   	ret    

80102e0e <kbdintr>:

void
kbdintr(void)
{
80102e0e:	55                   	push   %ebp
80102e0f:	89 e5                	mov    %esp,%ebp
80102e11:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102e14:	c7 04 24 bf 2c 10 80 	movl   $0x80102cbf,(%esp)
80102e1b:	e8 d5 d9 ff ff       	call   801007f5 <consoleintr>
}
80102e20:	c9                   	leave  
80102e21:	c3                   	ret    
	...

80102e24 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	83 ec 14             	sub    $0x14,%esp
80102e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e2d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e34:	89 c2                	mov    %eax,%edx
80102e36:	ec                   	in     (%dx),%al
80102e37:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e3a:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102e3d:	c9                   	leave  
80102e3e:	c3                   	ret    

80102e3f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e3f:	55                   	push   %ebp
80102e40:	89 e5                	mov    %esp,%ebp
80102e42:	83 ec 08             	sub    $0x8,%esp
80102e45:	8b 45 08             	mov    0x8(%ebp),%eax
80102e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e4b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e4f:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e52:	8a 45 f8             	mov    -0x8(%ebp),%al
80102e55:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102e58:	ee                   	out    %al,(%dx)
}
80102e59:	c9                   	leave  
80102e5a:	c3                   	ret    

80102e5b <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102e5b:	55                   	push   %ebp
80102e5c:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e5e:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102e63:	8b 55 08             	mov    0x8(%ebp),%edx
80102e66:	c1 e2 02             	shl    $0x2,%edx
80102e69:	01 c2                	add    %eax,%edx
80102e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e6e:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e70:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102e75:	83 c0 20             	add    $0x20,%eax
80102e78:	8b 00                	mov    (%eax),%eax
}
80102e7a:	5d                   	pop    %ebp
80102e7b:	c3                   	ret    

80102e7c <lapicinit>:

void
lapicinit(void)
{
80102e7c:	55                   	push   %ebp
80102e7d:	89 e5                	mov    %esp,%ebp
80102e7f:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102e82:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102e87:	85 c0                	test   %eax,%eax
80102e89:	75 05                	jne    80102e90 <lapicinit+0x14>
    return;
80102e8b:	e9 43 01 00 00       	jmp    80102fd3 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e90:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e97:	00 
80102e98:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e9f:	e8 b7 ff ff ff       	call   80102e5b <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ea4:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102eab:	00 
80102eac:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102eb3:	e8 a3 ff ff ff       	call   80102e5b <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eb8:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102ebf:	00 
80102ec0:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ec7:	e8 8f ff ff ff       	call   80102e5b <lapicw>
  lapicw(TICR, 10000000);
80102ecc:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102ed3:	00 
80102ed4:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102edb:	e8 7b ff ff ff       	call   80102e5b <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ee0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102ee7:	00 
80102ee8:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102eef:	e8 67 ff ff ff       	call   80102e5b <lapicw>
  lapicw(LINT1, MASKED);
80102ef4:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102efb:	00 
80102efc:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102f03:	e8 53 ff ff ff       	call   80102e5b <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f08:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102f0d:	83 c0 30             	add    $0x30,%eax
80102f10:	8b 00                	mov    (%eax),%eax
80102f12:	c1 e8 10             	shr    $0x10,%eax
80102f15:	0f b6 c0             	movzbl %al,%eax
80102f18:	83 f8 03             	cmp    $0x3,%eax
80102f1b:	76 14                	jbe    80102f31 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102f1d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f24:	00 
80102f25:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102f2c:	e8 2a ff ff ff       	call   80102e5b <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f31:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102f38:	00 
80102f39:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102f40:	e8 16 ff ff ff       	call   80102e5b <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f4c:	00 
80102f4d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f54:	e8 02 ff ff ff       	call   80102e5b <lapicw>
  lapicw(ESR, 0);
80102f59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f60:	00 
80102f61:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f68:	e8 ee fe ff ff       	call   80102e5b <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f74:	00 
80102f75:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f7c:	e8 da fe ff ff       	call   80102e5b <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f88:	00 
80102f89:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f90:	e8 c6 fe ff ff       	call   80102e5b <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f95:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f9c:	00 
80102f9d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa4:	e8 b2 fe ff ff       	call   80102e5b <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102fa9:	90                   	nop
80102faa:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102faf:	05 00 03 00 00       	add    $0x300,%eax
80102fb4:	8b 00                	mov    (%eax),%eax
80102fb6:	25 00 10 00 00       	and    $0x1000,%eax
80102fbb:	85 c0                	test   %eax,%eax
80102fbd:	75 eb                	jne    80102faa <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fc6:	00 
80102fc7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102fce:	e8 88 fe ff ff       	call   80102e5b <lapicw>
}
80102fd3:	c9                   	leave  
80102fd4:	c3                   	ret    

80102fd5 <lapicid>:

int
lapicid(void)
{
80102fd5:	55                   	push   %ebp
80102fd6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fd8:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102fdd:	85 c0                	test   %eax,%eax
80102fdf:	75 07                	jne    80102fe8 <lapicid+0x13>
    return 0;
80102fe1:	b8 00 00 00 00       	mov    $0x0,%eax
80102fe6:	eb 0d                	jmp    80102ff5 <lapicid+0x20>
  return lapic[ID] >> 24;
80102fe8:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80102fed:	83 c0 20             	add    $0x20,%eax
80102ff0:	8b 00                	mov    (%eax),%eax
80102ff2:	c1 e8 18             	shr    $0x18,%eax
}
80102ff5:	5d                   	pop    %ebp
80102ff6:	c3                   	ret    

80102ff7 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ff7:	55                   	push   %ebp
80102ff8:	89 e5                	mov    %esp,%ebp
80102ffa:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ffd:	a1 fc 39 11 80       	mov    0x801139fc,%eax
80103002:	85 c0                	test   %eax,%eax
80103004:	74 14                	je     8010301a <lapiceoi+0x23>
    lapicw(EOI, 0);
80103006:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010300d:	00 
8010300e:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103015:	e8 41 fe ff ff       	call   80102e5b <lapicw>
}
8010301a:	c9                   	leave  
8010301b:	c3                   	ret    

8010301c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010301c:	55                   	push   %ebp
8010301d:	89 e5                	mov    %esp,%ebp
}
8010301f:	5d                   	pop    %ebp
80103020:	c3                   	ret    

80103021 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103021:	55                   	push   %ebp
80103022:	89 e5                	mov    %esp,%ebp
80103024:	83 ec 1c             	sub    $0x1c,%esp
80103027:	8b 45 08             	mov    0x8(%ebp),%eax
8010302a:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010302d:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103034:	00 
80103035:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010303c:	e8 fe fd ff ff       	call   80102e3f <outb>
  outb(CMOS_PORT+1, 0x0A);
80103041:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103048:	00 
80103049:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103050:	e8 ea fd ff ff       	call   80102e3f <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103055:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010305c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010305f:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103064:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103067:	8d 50 02             	lea    0x2(%eax),%edx
8010306a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010306d:	c1 e8 04             	shr    $0x4,%eax
80103070:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103073:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103077:	c1 e0 18             	shl    $0x18,%eax
8010307a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010307e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103085:	e8 d1 fd ff ff       	call   80102e5b <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010308a:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103091:	00 
80103092:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103099:	e8 bd fd ff ff       	call   80102e5b <lapicw>
  microdelay(200);
8010309e:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030a5:	e8 72 ff ff ff       	call   8010301c <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801030aa:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801030b1:	00 
801030b2:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030b9:	e8 9d fd ff ff       	call   80102e5b <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030be:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801030c5:	e8 52 ff ff ff       	call   8010301c <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030d1:	eb 3f                	jmp    80103112 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
801030d3:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030d7:	c1 e0 18             	shl    $0x18,%eax
801030da:	89 44 24 04          	mov    %eax,0x4(%esp)
801030de:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030e5:	e8 71 fd ff ff       	call   80102e5b <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801030ed:	c1 e8 0c             	shr    $0xc,%eax
801030f0:	80 cc 06             	or     $0x6,%ah
801030f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f7:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030fe:	e8 58 fd ff ff       	call   80102e5b <lapicw>
    microdelay(200);
80103103:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010310a:	e8 0d ff ff ff       	call   8010301c <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010310f:	ff 45 fc             	incl   -0x4(%ebp)
80103112:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103116:	7e bb                	jle    801030d3 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103118:	c9                   	leave  
80103119:	c3                   	ret    

8010311a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010311a:	55                   	push   %ebp
8010311b:	89 e5                	mov    %esp,%ebp
8010311d:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103120:	8b 45 08             	mov    0x8(%ebp),%eax
80103123:	0f b6 c0             	movzbl %al,%eax
80103126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010312a:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103131:	e8 09 fd ff ff       	call   80102e3f <outb>
  microdelay(200);
80103136:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010313d:	e8 da fe ff ff       	call   8010301c <microdelay>

  return inb(CMOS_RETURN);
80103142:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103149:	e8 d6 fc ff ff       	call   80102e24 <inb>
8010314e:	0f b6 c0             	movzbl %al,%eax
}
80103151:	c9                   	leave  
80103152:	c3                   	ret    

80103153 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103153:	55                   	push   %ebp
80103154:	89 e5                	mov    %esp,%ebp
80103156:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103159:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103160:	e8 b5 ff ff ff       	call   8010311a <cmos_read>
80103165:	8b 55 08             	mov    0x8(%ebp),%edx
80103168:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010316a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103171:	e8 a4 ff ff ff       	call   8010311a <cmos_read>
80103176:	8b 55 08             	mov    0x8(%ebp),%edx
80103179:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010317c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103183:	e8 92 ff ff ff       	call   8010311a <cmos_read>
80103188:	8b 55 08             	mov    0x8(%ebp),%edx
8010318b:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010318e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103195:	e8 80 ff ff ff       	call   8010311a <cmos_read>
8010319a:	8b 55 08             	mov    0x8(%ebp),%edx
8010319d:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801031a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801031a7:	e8 6e ff ff ff       	call   8010311a <cmos_read>
801031ac:	8b 55 08             	mov    0x8(%ebp),%edx
801031af:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801031b2:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801031b9:	e8 5c ff ff ff       	call   8010311a <cmos_read>
801031be:	8b 55 08             	mov    0x8(%ebp),%edx
801031c1:	89 42 14             	mov    %eax,0x14(%edx)
}
801031c4:	c9                   	leave  
801031c5:	c3                   	ret    

801031c6 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031c6:	55                   	push   %ebp
801031c7:	89 e5                	mov    %esp,%ebp
801031c9:	57                   	push   %edi
801031ca:	56                   	push   %esi
801031cb:	53                   	push   %ebx
801031cc:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031cf:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801031d6:	e8 3f ff ff ff       	call   8010311a <cmos_read>
801031db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031e1:	83 e0 04             	and    $0x4,%eax
801031e4:	85 c0                	test   %eax,%eax
801031e6:	0f 94 c0             	sete   %al
801031e9:	0f b6 c0             	movzbl %al,%eax
801031ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031ef:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031f2:	89 04 24             	mov    %eax,(%esp)
801031f5:	e8 59 ff ff ff       	call   80103153 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103201:	e8 14 ff ff ff       	call   8010311a <cmos_read>
80103206:	25 80 00 00 00       	and    $0x80,%eax
8010320b:	85 c0                	test   %eax,%eax
8010320d:	74 02                	je     80103211 <cmostime+0x4b>
        continue;
8010320f:	eb 36                	jmp    80103247 <cmostime+0x81>
    fill_rtcdate(&t2);
80103211:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103214:	89 04 24             	mov    %eax,(%esp)
80103217:	e8 37 ff ff ff       	call   80103153 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010321c:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103223:	00 
80103224:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010322b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010322e:	89 04 24             	mov    %eax,(%esp)
80103231:	e8 cb 1e 00 00       	call   80105101 <memcmp>
80103236:	85 c0                	test   %eax,%eax
80103238:	75 0d                	jne    80103247 <cmostime+0x81>
      break;
8010323a:	90                   	nop
  }

  // convert
  if(bcd) {
8010323b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010323f:	0f 84 ac 00 00 00    	je     801032f1 <cmostime+0x12b>
80103245:	eb 02                	jmp    80103249 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103247:	eb a6                	jmp    801031ef <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103249:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010324c:	c1 e8 04             	shr    $0x4,%eax
8010324f:	89 c2                	mov    %eax,%edx
80103251:	89 d0                	mov    %edx,%eax
80103253:	c1 e0 02             	shl    $0x2,%eax
80103256:	01 d0                	add    %edx,%eax
80103258:	01 c0                	add    %eax,%eax
8010325a:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010325d:	83 e2 0f             	and    $0xf,%edx
80103260:	01 d0                	add    %edx,%eax
80103262:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103265:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103268:	c1 e8 04             	shr    $0x4,%eax
8010326b:	89 c2                	mov    %eax,%edx
8010326d:	89 d0                	mov    %edx,%eax
8010326f:	c1 e0 02             	shl    $0x2,%eax
80103272:	01 d0                	add    %edx,%eax
80103274:	01 c0                	add    %eax,%eax
80103276:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103279:	83 e2 0f             	and    $0xf,%edx
8010327c:	01 d0                	add    %edx,%eax
8010327e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103281:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103284:	c1 e8 04             	shr    $0x4,%eax
80103287:	89 c2                	mov    %eax,%edx
80103289:	89 d0                	mov    %edx,%eax
8010328b:	c1 e0 02             	shl    $0x2,%eax
8010328e:	01 d0                	add    %edx,%eax
80103290:	01 c0                	add    %eax,%eax
80103292:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103295:	83 e2 0f             	and    $0xf,%edx
80103298:	01 d0                	add    %edx,%eax
8010329a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
8010329d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801032a0:	c1 e8 04             	shr    $0x4,%eax
801032a3:	89 c2                	mov    %eax,%edx
801032a5:	89 d0                	mov    %edx,%eax
801032a7:	c1 e0 02             	shl    $0x2,%eax
801032aa:	01 d0                	add    %edx,%eax
801032ac:	01 c0                	add    %eax,%eax
801032ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801032b1:	83 e2 0f             	and    $0xf,%edx
801032b4:	01 d0                	add    %edx,%eax
801032b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
801032b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032bc:	c1 e8 04             	shr    $0x4,%eax
801032bf:	89 c2                	mov    %eax,%edx
801032c1:	89 d0                	mov    %edx,%eax
801032c3:	c1 e0 02             	shl    $0x2,%eax
801032c6:	01 d0                	add    %edx,%eax
801032c8:	01 c0                	add    %eax,%eax
801032ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032cd:	83 e2 0f             	and    $0xf,%edx
801032d0:	01 d0                	add    %edx,%eax
801032d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
801032d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032d8:	c1 e8 04             	shr    $0x4,%eax
801032db:	89 c2                	mov    %eax,%edx
801032dd:	89 d0                	mov    %edx,%eax
801032df:	c1 e0 02             	shl    $0x2,%eax
801032e2:	01 d0                	add    %edx,%eax
801032e4:	01 c0                	add    %eax,%eax
801032e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032e9:	83 e2 0f             	and    $0xf,%edx
801032ec:	01 d0                	add    %edx,%eax
801032ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
801032f1:	8b 45 08             	mov    0x8(%ebp),%eax
801032f4:	89 c2                	mov    %eax,%edx
801032f6:	8d 5d c8             	lea    -0x38(%ebp),%ebx
801032f9:	b8 06 00 00 00       	mov    $0x6,%eax
801032fe:	89 d7                	mov    %edx,%edi
80103300:	89 de                	mov    %ebx,%esi
80103302:	89 c1                	mov    %eax,%ecx
80103304:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80103306:	8b 45 08             	mov    0x8(%ebp),%eax
80103309:	8b 40 14             	mov    0x14(%eax),%eax
8010330c:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103312:	8b 45 08             	mov    0x8(%ebp),%eax
80103315:	89 50 14             	mov    %edx,0x14(%eax)
}
80103318:	83 c4 5c             	add    $0x5c,%esp
8010331b:	5b                   	pop    %ebx
8010331c:	5e                   	pop    %esi
8010331d:	5f                   	pop    %edi
8010331e:	5d                   	pop    %ebp
8010331f:	c3                   	ret    

80103320 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103326:	c7 44 24 04 cd 89 10 	movl   $0x801089cd,0x4(%esp)
8010332d:	80 
8010332e:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103335:	e8 cc 1a 00 00       	call   80104e06 <initlock>
  readsb(dev, &sb);
8010333a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010333d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103341:	8b 45 08             	mov    0x8(%ebp),%eax
80103344:	89 04 24             	mov    %eax,(%esp)
80103347:	e8 d8 e0 ff ff       	call   80101424 <readsb>
  log.start = sb.logstart;
8010334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334f:	a3 34 3a 11 80       	mov    %eax,0x80113a34
  log.size = sb.nlog;
80103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103357:	a3 38 3a 11 80       	mov    %eax,0x80113a38
  log.dev = dev;
8010335c:	8b 45 08             	mov    0x8(%ebp),%eax
8010335f:	a3 44 3a 11 80       	mov    %eax,0x80113a44
  recover_from_log();
80103364:	e8 95 01 00 00       	call   801034fe <recover_from_log>
}
80103369:	c9                   	leave  
8010336a:	c3                   	ret    

8010336b <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010336b:	55                   	push   %ebp
8010336c:	89 e5                	mov    %esp,%ebp
8010336e:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103371:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103378:	e9 89 00 00 00       	jmp    80103406 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010337d:	8b 15 34 3a 11 80    	mov    0x80113a34,%edx
80103383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103386:	01 d0                	add    %edx,%eax
80103388:	40                   	inc    %eax
80103389:	89 c2                	mov    %eax,%edx
8010338b:	a1 44 3a 11 80       	mov    0x80113a44,%eax
80103390:	89 54 24 04          	mov    %edx,0x4(%esp)
80103394:	89 04 24             	mov    %eax,(%esp)
80103397:	e8 19 ce ff ff       	call   801001b5 <bread>
8010339c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033a2:	83 c0 10             	add    $0x10,%eax
801033a5:	8b 04 85 0c 3a 11 80 	mov    -0x7feec5f4(,%eax,4),%eax
801033ac:	89 c2                	mov    %eax,%edx
801033ae:	a1 44 3a 11 80       	mov    0x80113a44,%eax
801033b3:	89 54 24 04          	mov    %edx,0x4(%esp)
801033b7:	89 04 24             	mov    %eax,(%esp)
801033ba:	e8 f6 cd ff ff       	call   801001b5 <bread>
801033bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c5:	8d 50 5c             	lea    0x5c(%eax),%edx
801033c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033cb:	83 c0 5c             	add    $0x5c,%eax
801033ce:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033d5:	00 
801033d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801033da:	89 04 24             	mov    %eax,(%esp)
801033dd:	e8 71 1d 00 00       	call   80105153 <memmove>
    bwrite(dbuf);  // write dst to disk
801033e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e5:	89 04 24             	mov    %eax,(%esp)
801033e8:	e8 ff cd ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f0:	89 04 24             	mov    %eax,(%esp)
801033f3:	e8 34 ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
801033f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fb:	89 04 24             	mov    %eax,(%esp)
801033fe:	e8 29 ce ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103403:	ff 45 f4             	incl   -0xc(%ebp)
80103406:	a1 48 3a 11 80       	mov    0x80113a48,%eax
8010340b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010340e:	0f 8f 69 ff ff ff    	jg     8010337d <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103414:	c9                   	leave  
80103415:	c3                   	ret    

80103416 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103416:	55                   	push   %ebp
80103417:	89 e5                	mov    %esp,%ebp
80103419:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010341c:	a1 34 3a 11 80       	mov    0x80113a34,%eax
80103421:	89 c2                	mov    %eax,%edx
80103423:	a1 44 3a 11 80       	mov    0x80113a44,%eax
80103428:	89 54 24 04          	mov    %edx,0x4(%esp)
8010342c:	89 04 24             	mov    %eax,(%esp)
8010342f:	e8 81 cd ff ff       	call   801001b5 <bread>
80103434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010343a:	83 c0 5c             	add    $0x5c,%eax
8010343d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103443:	8b 00                	mov    (%eax),%eax
80103445:	a3 48 3a 11 80       	mov    %eax,0x80113a48
  for (i = 0; i < log.lh.n; i++) {
8010344a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103451:	eb 1a                	jmp    8010346d <read_head+0x57>
    log.lh.block[i] = lh->block[i];
80103453:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103456:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103459:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010345d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103460:	83 c2 10             	add    $0x10,%edx
80103463:	89 04 95 0c 3a 11 80 	mov    %eax,-0x7feec5f4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010346a:	ff 45 f4             	incl   -0xc(%ebp)
8010346d:	a1 48 3a 11 80       	mov    0x80113a48,%eax
80103472:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103475:	7f dc                	jg     80103453 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010347a:	89 04 24             	mov    %eax,(%esp)
8010347d:	e8 aa cd ff ff       	call   8010022c <brelse>
}
80103482:	c9                   	leave  
80103483:	c3                   	ret    

80103484 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010348a:	a1 34 3a 11 80       	mov    0x80113a34,%eax
8010348f:	89 c2                	mov    %eax,%edx
80103491:	a1 44 3a 11 80       	mov    0x80113a44,%eax
80103496:	89 54 24 04          	mov    %edx,0x4(%esp)
8010349a:	89 04 24             	mov    %eax,(%esp)
8010349d:	e8 13 cd ff ff       	call   801001b5 <bread>
801034a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a8:	83 c0 5c             	add    $0x5c,%eax
801034ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034ae:	8b 15 48 3a 11 80    	mov    0x80113a48,%edx
801034b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b7:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034c0:	eb 1a                	jmp    801034dc <write_head+0x58>
    hb->block[i] = log.lh.block[i];
801034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c5:	83 c0 10             	add    $0x10,%eax
801034c8:	8b 0c 85 0c 3a 11 80 	mov    -0x7feec5f4(,%eax,4),%ecx
801034cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d5:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034d9:	ff 45 f4             	incl   -0xc(%ebp)
801034dc:	a1 48 3a 11 80       	mov    0x80113a48,%eax
801034e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e4:	7f dc                	jg     801034c2 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034e9:	89 04 24             	mov    %eax,(%esp)
801034ec:	e8 fb cc ff ff       	call   801001ec <bwrite>
  brelse(buf);
801034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f4:	89 04 24             	mov    %eax,(%esp)
801034f7:	e8 30 cd ff ff       	call   8010022c <brelse>
}
801034fc:	c9                   	leave  
801034fd:	c3                   	ret    

801034fe <recover_from_log>:

static void
recover_from_log(void)
{
801034fe:	55                   	push   %ebp
801034ff:	89 e5                	mov    %esp,%ebp
80103501:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103504:	e8 0d ff ff ff       	call   80103416 <read_head>
  install_trans(); // if committed, copy from log to disk
80103509:	e8 5d fe ff ff       	call   8010336b <install_trans>
  log.lh.n = 0;
8010350e:	c7 05 48 3a 11 80 00 	movl   $0x0,0x80113a48
80103515:	00 00 00 
  write_head(); // clear the log
80103518:	e8 67 ff ff ff       	call   80103484 <write_head>
}
8010351d:	c9                   	leave  
8010351e:	c3                   	ret    

8010351f <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010351f:	55                   	push   %ebp
80103520:	89 e5                	mov    %esp,%ebp
80103522:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103525:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
8010352c:	e8 f6 18 00 00       	call   80104e27 <acquire>
  while(1){
    if(log.committing){
80103531:	a1 40 3a 11 80       	mov    0x80113a40,%eax
80103536:	85 c0                	test   %eax,%eax
80103538:	74 16                	je     80103550 <begin_op+0x31>
      sleep(&log, &log.lock);
8010353a:	c7 44 24 04 00 3a 11 	movl   $0x80113a00,0x4(%esp)
80103541:	80 
80103542:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103549:	e8 0a 15 00 00       	call   80104a58 <sleep>
8010354e:	eb 4d                	jmp    8010359d <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103550:	8b 15 48 3a 11 80    	mov    0x80113a48,%edx
80103556:	a1 3c 3a 11 80       	mov    0x80113a3c,%eax
8010355b:	8d 48 01             	lea    0x1(%eax),%ecx
8010355e:	89 c8                	mov    %ecx,%eax
80103560:	c1 e0 02             	shl    $0x2,%eax
80103563:	01 c8                	add    %ecx,%eax
80103565:	01 c0                	add    %eax,%eax
80103567:	01 d0                	add    %edx,%eax
80103569:	83 f8 1e             	cmp    $0x1e,%eax
8010356c:	7e 16                	jle    80103584 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010356e:	c7 44 24 04 00 3a 11 	movl   $0x80113a00,0x4(%esp)
80103575:	80 
80103576:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
8010357d:	e8 d6 14 00 00       	call   80104a58 <sleep>
80103582:	eb 19                	jmp    8010359d <begin_op+0x7e>
    } else {
      log.outstanding += 1;
80103584:	a1 3c 3a 11 80       	mov    0x80113a3c,%eax
80103589:	40                   	inc    %eax
8010358a:	a3 3c 3a 11 80       	mov    %eax,0x80113a3c
      release(&log.lock);
8010358f:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103596:	e8 f6 18 00 00       	call   80104e91 <release>
      break;
8010359b:	eb 02                	jmp    8010359f <begin_op+0x80>
    }
  }
8010359d:	eb 92                	jmp    80103531 <begin_op+0x12>
}
8010359f:	c9                   	leave  
801035a0:	c3                   	ret    

801035a1 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035a1:	55                   	push   %ebp
801035a2:	89 e5                	mov    %esp,%ebp
801035a4:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801035a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035ae:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
801035b5:	e8 6d 18 00 00       	call   80104e27 <acquire>
  log.outstanding -= 1;
801035ba:	a1 3c 3a 11 80       	mov    0x80113a3c,%eax
801035bf:	48                   	dec    %eax
801035c0:	a3 3c 3a 11 80       	mov    %eax,0x80113a3c
  if(log.committing)
801035c5:	a1 40 3a 11 80       	mov    0x80113a40,%eax
801035ca:	85 c0                	test   %eax,%eax
801035cc:	74 0c                	je     801035da <end_op+0x39>
    panic("log.committing");
801035ce:	c7 04 24 d1 89 10 80 	movl   $0x801089d1,(%esp)
801035d5:	e8 7a cf ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
801035da:	a1 3c 3a 11 80       	mov    0x80113a3c,%eax
801035df:	85 c0                	test   %eax,%eax
801035e1:	75 13                	jne    801035f6 <end_op+0x55>
    do_commit = 1;
801035e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035ea:	c7 05 40 3a 11 80 01 	movl   $0x1,0x80113a40
801035f1:	00 00 00 
801035f4:	eb 0c                	jmp    80103602 <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801035f6:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
801035fd:	e8 2a 15 00 00       	call   80104b2c <wakeup>
  }
  release(&log.lock);
80103602:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103609:	e8 83 18 00 00       	call   80104e91 <release>

  if(do_commit){
8010360e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103612:	74 33                	je     80103647 <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103614:	e8 db 00 00 00       	call   801036f4 <commit>
    acquire(&log.lock);
80103619:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103620:	e8 02 18 00 00       	call   80104e27 <acquire>
    log.committing = 0;
80103625:	c7 05 40 3a 11 80 00 	movl   $0x0,0x80113a40
8010362c:	00 00 00 
    wakeup(&log);
8010362f:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103636:	e8 f1 14 00 00       	call   80104b2c <wakeup>
    release(&log.lock);
8010363b:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
80103642:	e8 4a 18 00 00       	call   80104e91 <release>
  }
}
80103647:	c9                   	leave  
80103648:	c3                   	ret    

80103649 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103649:	55                   	push   %ebp
8010364a:	89 e5                	mov    %esp,%ebp
8010364c:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010364f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103656:	e9 89 00 00 00       	jmp    801036e4 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010365b:	8b 15 34 3a 11 80    	mov    0x80113a34,%edx
80103661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103664:	01 d0                	add    %edx,%eax
80103666:	40                   	inc    %eax
80103667:	89 c2                	mov    %eax,%edx
80103669:	a1 44 3a 11 80       	mov    0x80113a44,%eax
8010366e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103672:	89 04 24             	mov    %eax,(%esp)
80103675:	e8 3b cb ff ff       	call   801001b5 <bread>
8010367a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103680:	83 c0 10             	add    $0x10,%eax
80103683:	8b 04 85 0c 3a 11 80 	mov    -0x7feec5f4(,%eax,4),%eax
8010368a:	89 c2                	mov    %eax,%edx
8010368c:	a1 44 3a 11 80       	mov    0x80113a44,%eax
80103691:	89 54 24 04          	mov    %edx,0x4(%esp)
80103695:	89 04 24             	mov    %eax,(%esp)
80103698:	e8 18 cb ff ff       	call   801001b5 <bread>
8010369d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036a3:	8d 50 5c             	lea    0x5c(%eax),%edx
801036a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036a9:	83 c0 5c             	add    $0x5c,%eax
801036ac:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801036b3:	00 
801036b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801036b8:	89 04 24             	mov    %eax,(%esp)
801036bb:	e8 93 1a 00 00       	call   80105153 <memmove>
    bwrite(to);  // write the log
801036c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036c3:	89 04 24             	mov    %eax,(%esp)
801036c6:	e8 21 cb ff ff       	call   801001ec <bwrite>
    brelse(from);
801036cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036ce:	89 04 24             	mov    %eax,(%esp)
801036d1:	e8 56 cb ff ff       	call   8010022c <brelse>
    brelse(to);
801036d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d9:	89 04 24             	mov    %eax,(%esp)
801036dc:	e8 4b cb ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036e1:	ff 45 f4             	incl   -0xc(%ebp)
801036e4:	a1 48 3a 11 80       	mov    0x80113a48,%eax
801036e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ec:	0f 8f 69 ff ff ff    	jg     8010365b <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
801036f2:	c9                   	leave  
801036f3:	c3                   	ret    

801036f4 <commit>:

static void
commit()
{
801036f4:	55                   	push   %ebp
801036f5:	89 e5                	mov    %esp,%ebp
801036f7:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036fa:	a1 48 3a 11 80       	mov    0x80113a48,%eax
801036ff:	85 c0                	test   %eax,%eax
80103701:	7e 1e                	jle    80103721 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103703:	e8 41 ff ff ff       	call   80103649 <write_log>
    write_head();    // Write header to disk -- the real commit
80103708:	e8 77 fd ff ff       	call   80103484 <write_head>
    install_trans(); // Now install writes to home locations
8010370d:	e8 59 fc ff ff       	call   8010336b <install_trans>
    log.lh.n = 0;
80103712:	c7 05 48 3a 11 80 00 	movl   $0x0,0x80113a48
80103719:	00 00 00 
    write_head();    // Erase the transaction from the log
8010371c:	e8 63 fd ff ff       	call   80103484 <write_head>
  }
}
80103721:	c9                   	leave  
80103722:	c3                   	ret    

80103723 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103723:	55                   	push   %ebp
80103724:	89 e5                	mov    %esp,%ebp
80103726:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103729:	a1 48 3a 11 80       	mov    0x80113a48,%eax
8010372e:	83 f8 1d             	cmp    $0x1d,%eax
80103731:	7f 10                	jg     80103743 <log_write+0x20>
80103733:	a1 48 3a 11 80       	mov    0x80113a48,%eax
80103738:	8b 15 38 3a 11 80    	mov    0x80113a38,%edx
8010373e:	4a                   	dec    %edx
8010373f:	39 d0                	cmp    %edx,%eax
80103741:	7c 0c                	jl     8010374f <log_write+0x2c>
    panic("too big a transaction");
80103743:	c7 04 24 e0 89 10 80 	movl   $0x801089e0,(%esp)
8010374a:	e8 05 ce ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
8010374f:	a1 3c 3a 11 80       	mov    0x80113a3c,%eax
80103754:	85 c0                	test   %eax,%eax
80103756:	7f 0c                	jg     80103764 <log_write+0x41>
    panic("log_write outside of trans");
80103758:	c7 04 24 f6 89 10 80 	movl   $0x801089f6,(%esp)
8010375f:	e8 f0 cd ff ff       	call   80100554 <panic>

  acquire(&log.lock);
80103764:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
8010376b:	e8 b7 16 00 00       	call   80104e27 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103777:	eb 1e                	jmp    80103797 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377c:	83 c0 10             	add    $0x10,%eax
8010377f:	8b 04 85 0c 3a 11 80 	mov    -0x7feec5f4(,%eax,4),%eax
80103786:	89 c2                	mov    %eax,%edx
80103788:	8b 45 08             	mov    0x8(%ebp),%eax
8010378b:	8b 40 08             	mov    0x8(%eax),%eax
8010378e:	39 c2                	cmp    %eax,%edx
80103790:	75 02                	jne    80103794 <log_write+0x71>
      break;
80103792:	eb 0d                	jmp    801037a1 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103794:	ff 45 f4             	incl   -0xc(%ebp)
80103797:	a1 48 3a 11 80       	mov    0x80113a48,%eax
8010379c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379f:	7f d8                	jg     80103779 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801037a1:	8b 45 08             	mov    0x8(%ebp),%eax
801037a4:	8b 40 08             	mov    0x8(%eax),%eax
801037a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037aa:	83 c2 10             	add    $0x10,%edx
801037ad:	89 04 95 0c 3a 11 80 	mov    %eax,-0x7feec5f4(,%edx,4)
  if (i == log.lh.n)
801037b4:	a1 48 3a 11 80       	mov    0x80113a48,%eax
801037b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037bc:	75 0b                	jne    801037c9 <log_write+0xa6>
    log.lh.n++;
801037be:	a1 48 3a 11 80       	mov    0x80113a48,%eax
801037c3:	40                   	inc    %eax
801037c4:	a3 48 3a 11 80       	mov    %eax,0x80113a48
  b->flags |= B_DIRTY; // prevent eviction
801037c9:	8b 45 08             	mov    0x8(%ebp),%eax
801037cc:	8b 00                	mov    (%eax),%eax
801037ce:	83 c8 04             	or     $0x4,%eax
801037d1:	89 c2                	mov    %eax,%edx
801037d3:	8b 45 08             	mov    0x8(%ebp),%eax
801037d6:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037d8:	c7 04 24 00 3a 11 80 	movl   $0x80113a00,(%esp)
801037df:	e8 ad 16 00 00       	call   80104e91 <release>
}
801037e4:	c9                   	leave  
801037e5:	c3                   	ret    
	...

801037e8 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037e8:	55                   	push   %ebp
801037e9:	89 e5                	mov    %esp,%ebp
801037eb:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037ee:	8b 55 08             	mov    0x8(%ebp),%edx
801037f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801037f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037f7:	f0 87 02             	lock xchg %eax,(%edx)
801037fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103800:	c9                   	leave  
80103801:	c3                   	ret    

80103802 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103802:	55                   	push   %ebp
80103803:	89 e5                	mov    %esp,%ebp
80103805:	83 e4 f0             	and    $0xfffffff0,%esp
80103808:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010380b:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103812:	80 
80103813:	c7 04 24 30 69 11 80 	movl   $0x80116930,(%esp)
8010381a:	e8 0d f3 ff ff       	call   80102b2c <kinit1>
  kvmalloc();      // kernel page table
8010381f:	e8 e7 44 00 00       	call   80107d0b <kvmalloc>
  mpinit();        // detect other processors
80103824:	e8 c4 03 00 00       	call   80103bed <mpinit>
  lapicinit();     // interrupt controller
80103829:	e8 4e f6 ff ff       	call   80102e7c <lapicinit>
  seginit();       // segment descriptors
8010382e:	e8 c0 3f 00 00       	call   801077f3 <seginit>
  picinit();       // disable pic
80103833:	e8 04 05 00 00       	call   80103d3c <picinit>
  ioapicinit();    // another interrupt controller
80103838:	e8 0c f2 ff ff       	call   80102a49 <ioapicinit>
  consoleinit();   // console hardware
8010383d:	e8 76 d3 ff ff       	call   80100bb8 <consoleinit>
  uartinit();      // serial port
80103842:	e8 38 33 00 00       	call   80106b7f <uartinit>
  pinit();         // process table
80103847:	e8 e6 08 00 00       	call   80104132 <pinit>
  tvinit();        // trap vectors
8010384c:	e8 17 2f 00 00       	call   80106768 <tvinit>
  binit();         // buffer cache
80103851:	e8 de c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103856:	e8 ed d7 ff ff       	call   80101048 <fileinit>
  ideinit();       // disk 
8010385b:	e8 f5 ed ff ff       	call   80102655 <ideinit>
  startothers();   // start other processors
80103860:	e8 83 00 00 00       	call   801038e8 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103865:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010386c:	8e 
8010386d:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103874:	e8 eb f2 ff ff       	call   80102b64 <kinit2>
  userinit();      // first user process
80103879:	e8 c1 0a 00 00       	call   8010433f <userinit>
  mpmain();        // finish this processor's setup
8010387e:	e8 1a 00 00 00       	call   8010389d <mpmain>

80103883 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103883:	55                   	push   %ebp
80103884:	89 e5                	mov    %esp,%ebp
80103886:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103889:	e8 94 44 00 00       	call   80107d22 <switchkvm>
  seginit();
8010388e:	e8 60 3f 00 00       	call   801077f3 <seginit>
  lapicinit();
80103893:	e8 e4 f5 ff ff       	call   80102e7c <lapicinit>
  mpmain();
80103898:	e8 00 00 00 00       	call   8010389d <mpmain>

8010389d <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010389d:	55                   	push   %ebp
8010389e:	89 e5                	mov    %esp,%ebp
801038a0:	53                   	push   %ebx
801038a1:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038a4:	e8 a5 08 00 00       	call   8010414e <cpuid>
801038a9:	89 c3                	mov    %eax,%ebx
801038ab:	e8 9e 08 00 00       	call   8010414e <cpuid>
801038b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801038b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b8:	c7 04 24 11 8a 10 80 	movl   $0x80108a11,(%esp)
801038bf:	e8 fd ca ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
801038c4:	e8 fc 2f 00 00       	call   801068c5 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038c9:	e8 c5 08 00 00       	call   80104193 <mycpu>
801038ce:	05 a0 00 00 00       	add    $0xa0,%eax
801038d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038da:	00 
801038db:	89 04 24             	mov    %eax,(%esp)
801038de:	e8 05 ff ff ff       	call   801037e8 <xchg>
  scheduler();     // start running processes
801038e3:	e8 a6 0f 00 00       	call   8010488e <scheduler>

801038e8 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038e8:	55                   	push   %ebp
801038e9:	89 e5                	mov    %esp,%ebp
801038eb:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
801038ee:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038f5:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801038fe:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
80103905:	80 
80103906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103909:	89 04 24             	mov    %eax,(%esp)
8010390c:	e8 42 18 00 00       	call   80105153 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103911:	c7 45 f4 00 3b 11 80 	movl   $0x80113b00,-0xc(%ebp)
80103918:	eb 75                	jmp    8010398f <startothers+0xa7>
    if(c == mycpu())  // We've started already.
8010391a:	e8 74 08 00 00       	call   80104193 <mycpu>
8010391f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103922:	75 02                	jne    80103926 <startothers+0x3e>
      continue;
80103924:	eb 62                	jmp    80103988 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103926:	e8 2c f3 ff ff       	call   80102c57 <kalloc>
8010392b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103931:	83 e8 04             	sub    $0x4,%eax
80103934:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103937:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010393d:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010393f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103942:	83 e8 08             	sub    $0x8,%eax
80103945:	c7 00 83 38 10 80    	movl   $0x80103883,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394e:	8d 50 f4             	lea    -0xc(%eax),%edx
80103951:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80103956:	05 00 00 00 80       	add    $0x80000000,%eax
8010395b:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
8010395d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103960:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103969:	8a 00                	mov    (%eax),%al
8010396b:	0f b6 c0             	movzbl %al,%eax
8010396e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103972:	89 04 24             	mov    %eax,(%esp)
80103975:	e8 a7 f6 ff ff       	call   80103021 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010397a:	90                   	nop
8010397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010397e:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103984:	85 c0                	test   %eax,%eax
80103986:	74 f3                	je     8010397b <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103988:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
8010398f:	a1 80 40 11 80       	mov    0x80114080,%eax
80103994:	89 c2                	mov    %eax,%edx
80103996:	89 d0                	mov    %edx,%eax
80103998:	c1 e0 02             	shl    $0x2,%eax
8010399b:	01 d0                	add    %edx,%eax
8010399d:	01 c0                	add    %eax,%eax
8010399f:	01 d0                	add    %edx,%eax
801039a1:	c1 e0 04             	shl    $0x4,%eax
801039a4:	05 00 3b 11 80       	add    $0x80113b00,%eax
801039a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039ac:	0f 87 68 ff ff ff    	ja     8010391a <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039b2:	c9                   	leave  
801039b3:	c3                   	ret    

801039b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	83 ec 14             	sub    $0x14,%esp
801039ba:	8b 45 08             	mov    0x8(%ebp),%eax
801039bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039c4:	89 c2                	mov    %eax,%edx
801039c6:	ec                   	in     (%dx),%al
801039c7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039ca:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801039cd:	c9                   	leave  
801039ce:	c3                   	ret    

801039cf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	83 ec 08             	sub    $0x8,%esp
801039d5:	8b 45 08             	mov    0x8(%ebp),%eax
801039d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801039db:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801039df:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039e2:	8a 45 f8             	mov    -0x8(%ebp),%al
801039e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039e8:	ee                   	out    %al,(%dx)
}
801039e9:	c9                   	leave  
801039ea:	c3                   	ret    

801039eb <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
801039eb:	55                   	push   %ebp
801039ec:	89 e5                	mov    %esp,%ebp
801039ee:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
801039f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801039f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801039ff:	eb 13                	jmp    80103a14 <sum+0x29>
    sum += addr[i];
80103a01:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a04:	8b 45 08             	mov    0x8(%ebp),%eax
80103a07:	01 d0                	add    %edx,%eax
80103a09:	8a 00                	mov    (%eax),%al
80103a0b:	0f b6 c0             	movzbl %al,%eax
80103a0e:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103a11:	ff 45 fc             	incl   -0x4(%ebp)
80103a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a17:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a1a:	7c e5                	jl     80103a01 <sum+0x16>
    sum += addr[i];
  return sum;
80103a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a1f:	c9                   	leave  
80103a20:	c3                   	ret    

80103a21 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a21:	55                   	push   %ebp
80103a22:	89 e5                	mov    %esp,%ebp
80103a24:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a27:	8b 45 08             	mov    0x8(%ebp),%eax
80103a2a:	05 00 00 00 80       	add    $0x80000000,%eax
80103a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a32:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a38:	01 d0                	add    %edx,%eax
80103a3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a43:	eb 3f                	jmp    80103a84 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a45:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a4c:	00 
80103a4d:	c7 44 24 04 28 8a 10 	movl   $0x80108a28,0x4(%esp)
80103a54:	80 
80103a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a58:	89 04 24             	mov    %eax,(%esp)
80103a5b:	e8 a1 16 00 00       	call   80105101 <memcmp>
80103a60:	85 c0                	test   %eax,%eax
80103a62:	75 1c                	jne    80103a80 <mpsearch1+0x5f>
80103a64:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a6b:	00 
80103a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6f:	89 04 24             	mov    %eax,(%esp)
80103a72:	e8 74 ff ff ff       	call   801039eb <sum>
80103a77:	84 c0                	test   %al,%al
80103a79:	75 05                	jne    80103a80 <mpsearch1+0x5f>
      return (struct mp*)p;
80103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7e:	eb 11                	jmp    80103a91 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a80:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a87:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a8a:	72 b9                	jb     80103a45 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a91:	c9                   	leave  
80103a92:	c3                   	ret    

80103a93 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a93:	55                   	push   %ebp
80103a94:	89 e5                	mov    %esp,%ebp
80103a96:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a99:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa3:	83 c0 0f             	add    $0xf,%eax
80103aa6:	8a 00                	mov    (%eax),%al
80103aa8:	0f b6 c0             	movzbl %al,%eax
80103aab:	c1 e0 08             	shl    $0x8,%eax
80103aae:	89 c2                	mov    %eax,%edx
80103ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab3:	83 c0 0e             	add    $0xe,%eax
80103ab6:	8a 00                	mov    (%eax),%al
80103ab8:	0f b6 c0             	movzbl %al,%eax
80103abb:	09 d0                	or     %edx,%eax
80103abd:	c1 e0 04             	shl    $0x4,%eax
80103ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ac3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ac7:	74 21                	je     80103aea <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103ac9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ad0:	00 
80103ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad4:	89 04 24             	mov    %eax,(%esp)
80103ad7:	e8 45 ff ff ff       	call   80103a21 <mpsearch1>
80103adc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103adf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ae3:	74 4e                	je     80103b33 <mpsearch+0xa0>
      return mp;
80103ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ae8:	eb 5d                	jmp    80103b47 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aed:	83 c0 14             	add    $0x14,%eax
80103af0:	8a 00                	mov    (%eax),%al
80103af2:	0f b6 c0             	movzbl %al,%eax
80103af5:	c1 e0 08             	shl    $0x8,%eax
80103af8:	89 c2                	mov    %eax,%edx
80103afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afd:	83 c0 13             	add    $0x13,%eax
80103b00:	8a 00                	mov    (%eax),%al
80103b02:	0f b6 c0             	movzbl %al,%eax
80103b05:	09 d0                	or     %edx,%eax
80103b07:	c1 e0 0a             	shl    $0xa,%eax
80103b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b10:	2d 00 04 00 00       	sub    $0x400,%eax
80103b15:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b1c:	00 
80103b1d:	89 04 24             	mov    %eax,(%esp)
80103b20:	e8 fc fe ff ff       	call   80103a21 <mpsearch1>
80103b25:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b2c:	74 05                	je     80103b33 <mpsearch+0xa0>
      return mp;
80103b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b31:	eb 14                	jmp    80103b47 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b33:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b3a:	00 
80103b3b:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b42:	e8 da fe ff ff       	call   80103a21 <mpsearch1>
}
80103b47:	c9                   	leave  
80103b48:	c3                   	ret    

80103b49 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b49:	55                   	push   %ebp
80103b4a:	89 e5                	mov    %esp,%ebp
80103b4c:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b4f:	e8 3f ff ff ff       	call   80103a93 <mpsearch>
80103b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b5b:	74 0a                	je     80103b67 <mpconfig+0x1e>
80103b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b60:	8b 40 04             	mov    0x4(%eax),%eax
80103b63:	85 c0                	test   %eax,%eax
80103b65:	75 07                	jne    80103b6e <mpconfig+0x25>
    return 0;
80103b67:	b8 00 00 00 00       	mov    $0x0,%eax
80103b6c:	eb 7d                	jmp    80103beb <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b71:	8b 40 04             	mov    0x4(%eax),%eax
80103b74:	05 00 00 00 80       	add    $0x80000000,%eax
80103b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b7c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b83:	00 
80103b84:	c7 44 24 04 2d 8a 10 	movl   $0x80108a2d,0x4(%esp)
80103b8b:	80 
80103b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8f:	89 04 24             	mov    %eax,(%esp)
80103b92:	e8 6a 15 00 00       	call   80105101 <memcmp>
80103b97:	85 c0                	test   %eax,%eax
80103b99:	74 07                	je     80103ba2 <mpconfig+0x59>
    return 0;
80103b9b:	b8 00 00 00 00       	mov    $0x0,%eax
80103ba0:	eb 49                	jmp    80103beb <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba5:	8a 40 06             	mov    0x6(%eax),%al
80103ba8:	3c 01                	cmp    $0x1,%al
80103baa:	74 11                	je     80103bbd <mpconfig+0x74>
80103bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103baf:	8a 40 06             	mov    0x6(%eax),%al
80103bb2:	3c 04                	cmp    $0x4,%al
80103bb4:	74 07                	je     80103bbd <mpconfig+0x74>
    return 0;
80103bb6:	b8 00 00 00 00       	mov    $0x0,%eax
80103bbb:	eb 2e                	jmp    80103beb <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc0:	8b 40 04             	mov    0x4(%eax),%eax
80103bc3:	0f b7 c0             	movzwl %ax,%eax
80103bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcd:	89 04 24             	mov    %eax,(%esp)
80103bd0:	e8 16 fe ff ff       	call   801039eb <sum>
80103bd5:	84 c0                	test   %al,%al
80103bd7:	74 07                	je     80103be0 <mpconfig+0x97>
    return 0;
80103bd9:	b8 00 00 00 00       	mov    $0x0,%eax
80103bde:	eb 0b                	jmp    80103beb <mpconfig+0xa2>
  *pmp = mp;
80103be0:	8b 45 08             	mov    0x8(%ebp),%eax
80103be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103be6:	89 10                	mov    %edx,(%eax)
  return conf;
80103be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103beb:	c9                   	leave  
80103bec:	c3                   	ret    

80103bed <mpinit>:

void
mpinit(void)
{
80103bed:	55                   	push   %ebp
80103bee:	89 e5                	mov    %esp,%ebp
80103bf0:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103bf3:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103bf6:	89 04 24             	mov    %eax,(%esp)
80103bf9:	e8 4b ff ff ff       	call   80103b49 <mpconfig>
80103bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c05:	75 0c                	jne    80103c13 <mpinit+0x26>
    panic("Expect to run on an SMP");
80103c07:	c7 04 24 32 8a 10 80 	movl   $0x80108a32,(%esp)
80103c0e:	e8 41 c9 ff ff       	call   80100554 <panic>
  ismp = 1;
80103c13:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c1d:	8b 40 24             	mov    0x24(%eax),%eax
80103c20:	a3 fc 39 11 80       	mov    %eax,0x801139fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c28:	83 c0 2c             	add    $0x2c,%eax
80103c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c31:	8b 40 04             	mov    0x4(%eax),%eax
80103c34:	0f b7 d0             	movzwl %ax,%edx
80103c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c3a:	01 d0                	add    %edx,%eax
80103c3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103c3f:	eb 7d                	jmp    80103cbe <mpinit+0xd1>
    switch(*p){
80103c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c44:	8a 00                	mov    (%eax),%al
80103c46:	0f b6 c0             	movzbl %al,%eax
80103c49:	83 f8 04             	cmp    $0x4,%eax
80103c4c:	77 68                	ja     80103cb6 <mpinit+0xc9>
80103c4e:	8b 04 85 6c 8a 10 80 	mov    -0x7fef7594(,%eax,4),%eax
80103c55:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103c5d:	a1 80 40 11 80       	mov    0x80114080,%eax
80103c62:	83 f8 07             	cmp    $0x7,%eax
80103c65:	7f 2c                	jg     80103c93 <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c67:	8b 15 80 40 11 80    	mov    0x80114080,%edx
80103c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c70:	8a 48 01             	mov    0x1(%eax),%cl
80103c73:	89 d0                	mov    %edx,%eax
80103c75:	c1 e0 02             	shl    $0x2,%eax
80103c78:	01 d0                	add    %edx,%eax
80103c7a:	01 c0                	add    %eax,%eax
80103c7c:	01 d0                	add    %edx,%eax
80103c7e:	c1 e0 04             	shl    $0x4,%eax
80103c81:	05 00 3b 11 80       	add    $0x80113b00,%eax
80103c86:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103c88:	a1 80 40 11 80       	mov    0x80114080,%eax
80103c8d:	40                   	inc    %eax
80103c8e:	a3 80 40 11 80       	mov    %eax,0x80114080
      }
      p += sizeof(struct mpproc);
80103c93:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c97:	eb 25                	jmp    80103cbe <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ca2:	8a 40 01             	mov    0x1(%eax),%al
80103ca5:	a2 e0 3a 11 80       	mov    %al,0x80113ae0
      p += sizeof(struct mpioapic);
80103caa:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cae:	eb 0e                	jmp    80103cbe <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cb0:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cb4:	eb 08                	jmp    80103cbe <mpinit+0xd1>
    default:
      ismp = 0;
80103cb6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103cbd:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103cc4:	0f 82 77 ff ff ff    	jb     80103c41 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103cca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cce:	75 0c                	jne    80103cdc <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103cd0:	c7 04 24 4c 8a 10 80 	movl   $0x80108a4c,(%esp)
80103cd7:	e8 78 c8 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80103cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103cdf:	8a 40 0c             	mov    0xc(%eax),%al
80103ce2:	84 c0                	test   %al,%al
80103ce4:	74 36                	je     80103d1c <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ce6:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103ced:	00 
80103cee:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103cf5:	e8 d5 fc ff ff       	call   801039cf <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103cfa:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d01:	e8 ae fc ff ff       	call   801039b4 <inb>
80103d06:	83 c8 01             	or     $0x1,%eax
80103d09:	0f b6 c0             	movzbl %al,%eax
80103d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d10:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d17:	e8 b3 fc ff ff       	call   801039cf <outb>
  }
}
80103d1c:	c9                   	leave  
80103d1d:	c3                   	ret    
	...

80103d20 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 08             	sub    $0x8,%esp
80103d26:	8b 45 08             	mov    0x8(%ebp),%eax
80103d29:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d2c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d30:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d33:	8a 45 f8             	mov    -0x8(%ebp),%al
80103d36:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103d39:	ee                   	out    %al,(%dx)
}
80103d3a:	c9                   	leave  
80103d3b:	c3                   	ret    

80103d3c <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d3c:	55                   	push   %ebp
80103d3d:	89 e5                	mov    %esp,%ebp
80103d3f:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103d42:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103d49:	00 
80103d4a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103d51:	e8 ca ff ff ff       	call   80103d20 <outb>
  outb(IO_PIC2+1, 0xFF);
80103d56:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103d5d:	00 
80103d5e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103d65:	e8 b6 ff ff ff       	call   80103d20 <outb>
}
80103d6a:	c9                   	leave  
80103d6b:	c3                   	ret    

80103d6c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d6c:	55                   	push   %ebp
80103d6d:	89 e5                	mov    %esp,%ebp
80103d6f:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103d79:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d82:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d85:	8b 10                	mov    (%eax),%edx
80103d87:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d8c:	e8 d3 d2 ff ff       	call   80101064 <filealloc>
80103d91:	8b 55 08             	mov    0x8(%ebp),%edx
80103d94:	89 02                	mov    %eax,(%edx)
80103d96:	8b 45 08             	mov    0x8(%ebp),%eax
80103d99:	8b 00                	mov    (%eax),%eax
80103d9b:	85 c0                	test   %eax,%eax
80103d9d:	0f 84 c8 00 00 00    	je     80103e6b <pipealloc+0xff>
80103da3:	e8 bc d2 ff ff       	call   80101064 <filealloc>
80103da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dab:	89 02                	mov    %eax,(%edx)
80103dad:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db0:	8b 00                	mov    (%eax),%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	0f 84 b1 00 00 00    	je     80103e6b <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103dba:	e8 98 ee ff ff       	call   80102c57 <kalloc>
80103dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dc6:	75 05                	jne    80103dcd <pipealloc+0x61>
    goto bad;
80103dc8:	e9 9e 00 00 00       	jmp    80103e6b <pipealloc+0xff>
  p->readopen = 1;
80103dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103dd7:	00 00 00 
  p->writeopen = 1;
80103dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ddd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103de4:	00 00 00 
  p->nwrite = 0;
80103de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103df1:	00 00 00 
  p->nread = 0;
80103df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103dfe:	00 00 00 
  initlock(&p->lock, "pipe");
80103e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e04:	c7 44 24 04 80 8a 10 	movl   $0x80108a80,0x4(%esp)
80103e0b:	80 
80103e0c:	89 04 24             	mov    %eax,(%esp)
80103e0f:	e8 f2 0f 00 00       	call   80104e06 <initlock>
  (*f0)->type = FD_PIPE;
80103e14:	8b 45 08             	mov    0x8(%ebp),%eax
80103e17:	8b 00                	mov    (%eax),%eax
80103e19:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e22:	8b 00                	mov    (%eax),%eax
80103e24:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e28:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2b:	8b 00                	mov    (%eax),%eax
80103e2d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e31:	8b 45 08             	mov    0x8(%ebp),%eax
80103e34:	8b 00                	mov    (%eax),%eax
80103e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e39:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e3f:	8b 00                	mov    (%eax),%eax
80103e41:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e47:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4a:	8b 00                	mov    (%eax),%eax
80103e4c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e53:	8b 00                	mov    (%eax),%eax
80103e55:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e5c:	8b 00                	mov    (%eax),%eax
80103e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e61:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103e64:	b8 00 00 00 00       	mov    $0x0,%eax
80103e69:	eb 42                	jmp    80103ead <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e6f:	74 0b                	je     80103e7c <pipealloc+0x110>
    kfree((char*)p);
80103e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e74:	89 04 24             	mov    %eax,(%esp)
80103e77:	e8 45 ed ff ff       	call   80102bc1 <kfree>
  if(*f0)
80103e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7f:	8b 00                	mov    (%eax),%eax
80103e81:	85 c0                	test   %eax,%eax
80103e83:	74 0d                	je     80103e92 <pipealloc+0x126>
    fileclose(*f0);
80103e85:	8b 45 08             	mov    0x8(%ebp),%eax
80103e88:	8b 00                	mov    (%eax),%eax
80103e8a:	89 04 24             	mov    %eax,(%esp)
80103e8d:	e8 7a d2 ff ff       	call   8010110c <fileclose>
  if(*f1)
80103e92:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e95:	8b 00                	mov    (%eax),%eax
80103e97:	85 c0                	test   %eax,%eax
80103e99:	74 0d                	je     80103ea8 <pipealloc+0x13c>
    fileclose(*f1);
80103e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e9e:	8b 00                	mov    (%eax),%eax
80103ea0:	89 04 24             	mov    %eax,(%esp)
80103ea3:	e8 64 d2 ff ff       	call   8010110c <fileclose>
  return -1;
80103ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ead:	c9                   	leave  
80103eae:	c3                   	ret    

80103eaf <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103eaf:	55                   	push   %ebp
80103eb0:	89 e5                	mov    %esp,%ebp
80103eb2:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb8:	89 04 24             	mov    %eax,(%esp)
80103ebb:	e8 67 0f 00 00       	call   80104e27 <acquire>
  if(writable){
80103ec0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103ec4:	74 1f                	je     80103ee5 <pipeclose+0x36>
    p->writeopen = 0;
80103ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec9:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103ed0:	00 00 00 
    wakeup(&p->nread);
80103ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed6:	05 34 02 00 00       	add    $0x234,%eax
80103edb:	89 04 24             	mov    %eax,(%esp)
80103ede:	e8 49 0c 00 00       	call   80104b2c <wakeup>
80103ee3:	eb 1d                	jmp    80103f02 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee8:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103eef:	00 00 00 
    wakeup(&p->nwrite);
80103ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef5:	05 38 02 00 00       	add    $0x238,%eax
80103efa:	89 04 24             	mov    %eax,(%esp)
80103efd:	e8 2a 0c 00 00       	call   80104b2c <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f02:	8b 45 08             	mov    0x8(%ebp),%eax
80103f05:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f0b:	85 c0                	test   %eax,%eax
80103f0d:	75 25                	jne    80103f34 <pipeclose+0x85>
80103f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f12:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f18:	85 c0                	test   %eax,%eax
80103f1a:	75 18                	jne    80103f34 <pipeclose+0x85>
    release(&p->lock);
80103f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1f:	89 04 24             	mov    %eax,(%esp)
80103f22:	e8 6a 0f 00 00       	call   80104e91 <release>
    kfree((char*)p);
80103f27:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2a:	89 04 24             	mov    %eax,(%esp)
80103f2d:	e8 8f ec ff ff       	call   80102bc1 <kfree>
80103f32:	eb 0b                	jmp    80103f3f <pipeclose+0x90>
  } else
    release(&p->lock);
80103f34:	8b 45 08             	mov    0x8(%ebp),%eax
80103f37:	89 04 24             	mov    %eax,(%esp)
80103f3a:	e8 52 0f 00 00       	call   80104e91 <release>
}
80103f3f:	c9                   	leave  
80103f40:	c3                   	ret    

80103f41 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103f41:	55                   	push   %ebp
80103f42:	89 e5                	mov    %esp,%ebp
80103f44:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103f47:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4a:	89 04 24             	mov    %eax,(%esp)
80103f4d:	e8 d5 0e 00 00       	call   80104e27 <acquire>
  for(i = 0; i < n; i++){
80103f52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f59:	e9 a3 00 00 00       	jmp    80104001 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f5e:	eb 56                	jmp    80103fb6 <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103f60:	8b 45 08             	mov    0x8(%ebp),%eax
80103f63:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f69:	85 c0                	test   %eax,%eax
80103f6b:	74 0c                	je     80103f79 <pipewrite+0x38>
80103f6d:	e8 a5 02 00 00       	call   80104217 <myproc>
80103f72:	8b 40 24             	mov    0x24(%eax),%eax
80103f75:	85 c0                	test   %eax,%eax
80103f77:	74 15                	je     80103f8e <pipewrite+0x4d>
        release(&p->lock);
80103f79:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7c:	89 04 24             	mov    %eax,(%esp)
80103f7f:	e8 0d 0f 00 00       	call   80104e91 <release>
        return -1;
80103f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f89:	e9 9d 00 00 00       	jmp    8010402b <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f91:	05 34 02 00 00       	add    $0x234,%eax
80103f96:	89 04 24             	mov    %eax,(%esp)
80103f99:	e8 8e 0b 00 00       	call   80104b2c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa1:	8b 55 08             	mov    0x8(%ebp),%edx
80103fa4:	81 c2 38 02 00 00    	add    $0x238,%edx
80103faa:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fae:	89 14 24             	mov    %edx,(%esp)
80103fb1:	e8 a2 0a 00 00       	call   80104a58 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb9:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fc8:	05 00 02 00 00       	add    $0x200,%eax
80103fcd:	39 c2                	cmp    %eax,%edx
80103fcf:	74 8f                	je     80103f60 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fda:	8d 48 01             	lea    0x1(%eax),%ecx
80103fdd:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe0:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103fe6:	25 ff 01 00 00       	and    $0x1ff,%eax
80103feb:	89 c1                	mov    %eax,%ecx
80103fed:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff3:	01 d0                	add    %edx,%eax
80103ff5:	8a 10                	mov    (%eax),%dl
80103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffa:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ffe:	ff 45 f4             	incl   -0xc(%ebp)
80104001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104004:	3b 45 10             	cmp    0x10(%ebp),%eax
80104007:	0f 8c 51 ff ff ff    	jl     80103f5e <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010400d:	8b 45 08             	mov    0x8(%ebp),%eax
80104010:	05 34 02 00 00       	add    $0x234,%eax
80104015:	89 04 24             	mov    %eax,(%esp)
80104018:	e8 0f 0b 00 00       	call   80104b2c <wakeup>
  release(&p->lock);
8010401d:	8b 45 08             	mov    0x8(%ebp),%eax
80104020:	89 04 24             	mov    %eax,(%esp)
80104023:	e8 69 0e 00 00       	call   80104e91 <release>
  return n;
80104028:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010402b:	c9                   	leave  
8010402c:	c3                   	ret    

8010402d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010402d:	55                   	push   %ebp
8010402e:	89 e5                	mov    %esp,%ebp
80104030:	53                   	push   %ebx
80104031:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104034:	8b 45 08             	mov    0x8(%ebp),%eax
80104037:	89 04 24             	mov    %eax,(%esp)
8010403a:	e8 e8 0d 00 00       	call   80104e27 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010403f:	eb 39                	jmp    8010407a <piperead+0x4d>
    if(myproc()->killed){
80104041:	e8 d1 01 00 00       	call   80104217 <myproc>
80104046:	8b 40 24             	mov    0x24(%eax),%eax
80104049:	85 c0                	test   %eax,%eax
8010404b:	74 15                	je     80104062 <piperead+0x35>
      release(&p->lock);
8010404d:	8b 45 08             	mov    0x8(%ebp),%eax
80104050:	89 04 24             	mov    %eax,(%esp)
80104053:	e8 39 0e 00 00       	call   80104e91 <release>
      return -1;
80104058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010405d:	e9 b3 00 00 00       	jmp    80104115 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104062:	8b 45 08             	mov    0x8(%ebp),%eax
80104065:	8b 55 08             	mov    0x8(%ebp),%edx
80104068:	81 c2 34 02 00 00    	add    $0x234,%edx
8010406e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104072:	89 14 24             	mov    %edx,(%esp)
80104075:	e8 de 09 00 00       	call   80104a58 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010407a:	8b 45 08             	mov    0x8(%ebp),%eax
8010407d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
80104086:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010408c:	39 c2                	cmp    %eax,%edx
8010408e:	75 0d                	jne    8010409d <piperead+0x70>
80104090:	8b 45 08             	mov    0x8(%ebp),%eax
80104093:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104099:	85 c0                	test   %eax,%eax
8010409b:	75 a4                	jne    80104041 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010409d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801040a4:	eb 49                	jmp    801040ef <piperead+0xc2>
    if(p->nread == p->nwrite)
801040a6:	8b 45 08             	mov    0x8(%ebp),%eax
801040a9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801040af:	8b 45 08             	mov    0x8(%ebp),%eax
801040b2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040b8:	39 c2                	cmp    %eax,%edx
801040ba:	75 02                	jne    801040be <piperead+0x91>
      break;
801040bc:	eb 39                	jmp    801040f7 <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801040be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801040c7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ca:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801040d0:	8d 48 01             	lea    0x1(%eax),%ecx
801040d3:	8b 55 08             	mov    0x8(%ebp),%edx
801040d6:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801040dc:	25 ff 01 00 00       	and    $0x1ff,%eax
801040e1:	89 c2                	mov    %eax,%edx
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
801040e6:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
801040ea:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040ec:	ff 45 f4             	incl   -0xc(%ebp)
801040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801040f5:	7c af                	jl     801040a6 <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801040f7:	8b 45 08             	mov    0x8(%ebp),%eax
801040fa:	05 38 02 00 00       	add    $0x238,%eax
801040ff:	89 04 24             	mov    %eax,(%esp)
80104102:	e8 25 0a 00 00       	call   80104b2c <wakeup>
  release(&p->lock);
80104107:	8b 45 08             	mov    0x8(%ebp),%eax
8010410a:	89 04 24             	mov    %eax,(%esp)
8010410d:	e8 7f 0d 00 00       	call   80104e91 <release>
  return i;
80104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104115:	83 c4 24             	add    $0x24,%esp
80104118:	5b                   	pop    %ebx
80104119:	5d                   	pop    %ebp
8010411a:	c3                   	ret    
	...

8010411c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010411c:	55                   	push   %ebp
8010411d:	89 e5                	mov    %esp,%ebp
8010411f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104122:	9c                   	pushf  
80104123:	58                   	pop    %eax
80104124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010412a:	c9                   	leave  
8010412b:	c3                   	ret    

8010412c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010412c:	55                   	push   %ebp
8010412d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010412f:	fb                   	sti    
}
80104130:	5d                   	pop    %ebp
80104131:	c3                   	ret    

80104132 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104132:	55                   	push   %ebp
80104133:	89 e5                	mov    %esp,%ebp
80104135:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104138:	c7 44 24 04 88 8a 10 	movl   $0x80108a88,0x4(%esp)
8010413f:	80 
80104140:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104147:	e8 ba 0c 00 00       	call   80104e06 <initlock>
}
8010414c:	c9                   	leave  
8010414d:	c3                   	ret    

8010414e <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010414e:	55                   	push   %ebp
8010414f:	89 e5                	mov    %esp,%ebp
80104151:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104154:	e8 3a 00 00 00       	call   80104193 <mycpu>
80104159:	89 c2                	mov    %eax,%edx
8010415b:	b8 00 3b 11 80       	mov    $0x80113b00,%eax
80104160:	29 c2                	sub    %eax,%edx
80104162:	89 d0                	mov    %edx,%eax
80104164:	c1 f8 04             	sar    $0x4,%eax
80104167:	89 c1                	mov    %eax,%ecx
80104169:	89 ca                	mov    %ecx,%edx
8010416b:	c1 e2 03             	shl    $0x3,%edx
8010416e:	01 ca                	add    %ecx,%edx
80104170:	89 d0                	mov    %edx,%eax
80104172:	c1 e0 05             	shl    $0x5,%eax
80104175:	29 d0                	sub    %edx,%eax
80104177:	c1 e0 02             	shl    $0x2,%eax
8010417a:	01 c8                	add    %ecx,%eax
8010417c:	c1 e0 03             	shl    $0x3,%eax
8010417f:	01 c8                	add    %ecx,%eax
80104181:	89 c2                	mov    %eax,%edx
80104183:	c1 e2 0f             	shl    $0xf,%edx
80104186:	29 c2                	sub    %eax,%edx
80104188:	c1 e2 02             	shl    $0x2,%edx
8010418b:	01 ca                	add    %ecx,%edx
8010418d:	89 d0                	mov    %edx,%eax
8010418f:	f7 d8                	neg    %eax
}
80104191:	c9                   	leave  
80104192:	c3                   	ret    

80104193 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104193:	55                   	push   %ebp
80104194:	89 e5                	mov    %esp,%ebp
80104196:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
80104199:	e8 7e ff ff ff       	call   8010411c <readeflags>
8010419e:	25 00 02 00 00       	and    $0x200,%eax
801041a3:	85 c0                	test   %eax,%eax
801041a5:	74 0c                	je     801041b3 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
801041a7:	c7 04 24 90 8a 10 80 	movl   $0x80108a90,(%esp)
801041ae:	e8 a1 c3 ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
801041b3:	e8 1d ee ff ff       	call   80102fd5 <lapicid>
801041b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801041bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041c2:	eb 3b                	jmp    801041ff <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
801041c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041c7:	89 d0                	mov    %edx,%eax
801041c9:	c1 e0 02             	shl    $0x2,%eax
801041cc:	01 d0                	add    %edx,%eax
801041ce:	01 c0                	add    %eax,%eax
801041d0:	01 d0                	add    %edx,%eax
801041d2:	c1 e0 04             	shl    $0x4,%eax
801041d5:	05 00 3b 11 80       	add    $0x80113b00,%eax
801041da:	8a 00                	mov    (%eax),%al
801041dc:	0f b6 c0             	movzbl %al,%eax
801041df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801041e2:	75 18                	jne    801041fc <mycpu+0x69>
      return &cpus[i];
801041e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e7:	89 d0                	mov    %edx,%eax
801041e9:	c1 e0 02             	shl    $0x2,%eax
801041ec:	01 d0                	add    %edx,%eax
801041ee:	01 c0                	add    %eax,%eax
801041f0:	01 d0                	add    %edx,%eax
801041f2:	c1 e0 04             	shl    $0x4,%eax
801041f5:	05 00 3b 11 80       	add    $0x80113b00,%eax
801041fa:	eb 19                	jmp    80104215 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801041fc:	ff 45 f4             	incl   -0xc(%ebp)
801041ff:	a1 80 40 11 80       	mov    0x80114080,%eax
80104204:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104207:	7c bb                	jl     801041c4 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80104209:	c7 04 24 b6 8a 10 80 	movl   $0x80108ab6,(%esp)
80104210:	e8 3f c3 ff ff       	call   80100554 <panic>
}
80104215:	c9                   	leave  
80104216:	c3                   	ret    

80104217 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104217:	55                   	push   %ebp
80104218:	89 e5                	mov    %esp,%ebp
8010421a:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
8010421d:	e8 64 0d 00 00       	call   80104f86 <pushcli>
  c = mycpu();
80104222:	e8 6c ff ff ff       	call   80104193 <mycpu>
80104227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104233:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104236:	e8 95 0d 00 00       	call   80104fd0 <popcli>
  return p;
8010423b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010423e:	c9                   	leave  
8010423f:	c3                   	ret    

80104240 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104246:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010424d:	e8 d5 0b 00 00       	call   80104e27 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104252:	c7 45 f4 d4 40 11 80 	movl   $0x801140d4,-0xc(%ebp)
80104259:	eb 50                	jmp    801042ab <allocproc+0x6b>
    if(p->state == UNUSED)
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	8b 40 0c             	mov    0xc(%eax),%eax
80104261:	85 c0                	test   %eax,%eax
80104263:	75 42                	jne    801042a7 <allocproc+0x67>
      goto found;
80104265:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104269:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104270:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104275:	8d 50 01             	lea    0x1(%eax),%edx
80104278:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
8010427e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104281:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104284:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010428b:	e8 01 0c 00 00       	call   80104e91 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104290:	e8 c2 e9 ff ff       	call   80102c57 <kalloc>
80104295:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104298:	89 42 08             	mov    %eax,0x8(%edx)
8010429b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429e:	8b 40 08             	mov    0x8(%eax),%eax
801042a1:	85 c0                	test   %eax,%eax
801042a3:	75 33                	jne    801042d8 <allocproc+0x98>
801042a5:	eb 20                	jmp    801042c7 <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a7:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801042ab:	81 7d f4 d4 5f 11 80 	cmpl   $0x80115fd4,-0xc(%ebp)
801042b2:	72 a7                	jb     8010425b <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801042b4:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
801042bb:	e8 d1 0b 00 00       	call   80104e91 <release>
  return 0;
801042c0:	b8 00 00 00 00       	mov    $0x0,%eax
801042c5:	eb 76                	jmp    8010433d <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801042d1:	b8 00 00 00 00       	mov    $0x0,%eax
801042d6:	eb 65                	jmp    8010433d <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801042d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042db:	8b 40 08             	mov    0x8(%eax),%eax
801042de:	05 00 10 00 00       	add    $0x1000,%eax
801042e3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801042e6:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801042ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042f0:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801042f3:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801042f7:	ba 24 67 10 80       	mov    $0x80106724,%edx
801042fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042ff:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104301:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104308:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010430b:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010430e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104311:	8b 40 1c             	mov    0x1c(%eax),%eax
80104314:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010431b:	00 
8010431c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104323:	00 
80104324:	89 04 24             	mov    %eax,(%esp)
80104327:	e8 5e 0d 00 00       	call   8010508a <memset>
  p->context->eip = (uint)forkret;
8010432c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104332:	ba 19 4a 10 80       	mov    $0x80104a19,%edx
80104337:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010433a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010433d:	c9                   	leave  
8010433e:	c3                   	ret    

8010433f <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010433f:	55                   	push   %ebp
80104340:	89 e5                	mov    %esp,%ebp
80104342:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104345:	e8 f6 fe ff ff       	call   80104240 <allocproc>
8010434a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
8010434d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104350:	a3 60 b6 10 80       	mov    %eax,0x8010b660
  if((p->pgdir = setupkvm()) == 0)
80104355:	e8 08 39 00 00       	call   80107c62 <setupkvm>
8010435a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010435d:	89 42 04             	mov    %eax,0x4(%edx)
80104360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104363:	8b 40 04             	mov    0x4(%eax),%eax
80104366:	85 c0                	test   %eax,%eax
80104368:	75 0c                	jne    80104376 <userinit+0x37>
    panic("userinit: out of memory?");
8010436a:	c7 04 24 c6 8a 10 80 	movl   $0x80108ac6,(%esp)
80104371:	e8 de c1 ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104376:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010437b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437e:	8b 40 04             	mov    0x4(%eax),%eax
80104381:	89 54 24 08          	mov    %edx,0x8(%esp)
80104385:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
8010438c:	80 
8010438d:	89 04 24             	mov    %eax,(%esp)
80104390:	e8 2e 3b 00 00       	call   80107ec3 <inituvm>
  p->sz = PGSIZE;
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a1:	8b 40 18             	mov    0x18(%eax),%eax
801043a4:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801043ab:	00 
801043ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043b3:	00 
801043b4:	89 04 24             	mov    %eax,(%esp)
801043b7:	e8 ce 0c 00 00       	call   8010508a <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801043bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bf:	8b 40 18             	mov    0x18(%eax),%eax
801043c2:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cb:	8b 40 18             	mov    0x18(%eax),%eax
801043ce:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801043d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d7:	8b 50 18             	mov    0x18(%eax),%edx
801043da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043dd:	8b 40 18             	mov    0x18(%eax),%eax
801043e0:	8b 40 2c             	mov    0x2c(%eax),%eax
801043e3:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801043e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ea:	8b 50 18             	mov    0x18(%eax),%edx
801043ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f0:	8b 40 18             	mov    0x18(%eax),%eax
801043f3:	8b 40 2c             	mov    0x2c(%eax),%eax
801043f6:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fd:	8b 40 18             	mov    0x18(%eax),%eax
80104400:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440a:	8b 40 18             	mov    0x18(%eax),%eax
8010440d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104414:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104417:	8b 40 18             	mov    0x18(%eax),%eax
8010441a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104424:	83 c0 6c             	add    $0x6c,%eax
80104427:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010442e:	00 
8010442f:	c7 44 24 04 df 8a 10 	movl   $0x80108adf,0x4(%esp)
80104436:	80 
80104437:	89 04 24             	mov    %eax,(%esp)
8010443a:	e8 57 0e 00 00       	call   80105296 <safestrcpy>
  p->cwd = namei("/");
8010443f:	c7 04 24 e8 8a 10 80 	movl   $0x80108ae8,(%esp)
80104446:	e8 00 e1 ff ff       	call   8010254b <namei>
8010444b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010444e:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104451:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104458:	e8 ca 09 00 00       	call   80104e27 <acquire>

  p->state = RUNNABLE;
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104467:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010446e:	e8 1e 0a 00 00       	call   80104e91 <release>
}
80104473:	c9                   	leave  
80104474:	c3                   	ret    

80104475 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104475:	55                   	push   %ebp
80104476:	89 e5                	mov    %esp,%ebp
80104478:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
8010447b:	e8 97 fd ff ff       	call   80104217 <myproc>
80104480:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104486:	8b 00                	mov    (%eax),%eax
80104488:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010448b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010448f:	7e 31                	jle    801044c2 <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104491:	8b 55 08             	mov    0x8(%ebp),%edx
80104494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104497:	01 c2                	add    %eax,%edx
80104499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010449c:	8b 40 04             	mov    0x4(%eax),%eax
8010449f:	89 54 24 08          	mov    %edx,0x8(%esp)
801044a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801044aa:	89 04 24             	mov    %eax,(%esp)
801044ad:	e8 7c 3b 00 00       	call   8010802e <allocuvm>
801044b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801044b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044b9:	75 3e                	jne    801044f9 <growproc+0x84>
      return -1;
801044bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044c0:	eb 4f                	jmp    80104511 <growproc+0x9c>
  } else if(n < 0){
801044c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801044c6:	79 31                	jns    801044f9 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801044c8:	8b 55 08             	mov    0x8(%ebp),%edx
801044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ce:	01 c2                	add    %eax,%edx
801044d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d3:	8b 40 04             	mov    0x4(%eax),%eax
801044d6:	89 54 24 08          	mov    %edx,0x8(%esp)
801044da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801044e1:	89 04 24             	mov    %eax,(%esp)
801044e4:	e8 5b 3c 00 00       	call   80108144 <deallocuvm>
801044e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801044ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044f0:	75 07                	jne    801044f9 <growproc+0x84>
      return -1;
801044f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f7:	eb 18                	jmp    80104511 <growproc+0x9c>
  }
  curproc->sz = sz;
801044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ff:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104501:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104504:	89 04 24             	mov    %eax,(%esp)
80104507:	e8 30 38 00 00       	call   80107d3c <switchuvm>
  return 0;
8010450c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104511:	c9                   	leave  
80104512:	c3                   	ret    

80104513 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104513:	55                   	push   %ebp
80104514:	89 e5                	mov    %esp,%ebp
80104516:	57                   	push   %edi
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
80104519:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
8010451c:	e8 f6 fc ff ff       	call   80104217 <myproc>
80104521:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104524:	e8 17 fd ff ff       	call   80104240 <allocproc>
80104529:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010452c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104530:	75 0a                	jne    8010453c <fork+0x29>
    return -1;
80104532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104537:	e9 35 01 00 00       	jmp    80104671 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010453c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010453f:	8b 10                	mov    (%eax),%edx
80104541:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104544:	8b 40 04             	mov    0x4(%eax),%eax
80104547:	89 54 24 04          	mov    %edx,0x4(%esp)
8010454b:	89 04 24             	mov    %eax,(%esp)
8010454e:	e8 91 3d 00 00       	call   801082e4 <copyuvm>
80104553:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104556:	89 42 04             	mov    %eax,0x4(%edx)
80104559:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010455c:	8b 40 04             	mov    0x4(%eax),%eax
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 2c                	jne    8010458f <fork+0x7c>
    kfree(np->kstack);
80104563:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104566:	8b 40 08             	mov    0x8(%eax),%eax
80104569:	89 04 24             	mov    %eax,(%esp)
8010456c:	e8 50 e6 ff ff       	call   80102bc1 <kfree>
    np->kstack = 0;
80104571:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104574:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010457b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010457e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458a:	e9 e2 00 00 00       	jmp    80104671 <fork+0x15e>
  }
  np->sz = curproc->sz;
8010458f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104592:	8b 10                	mov    (%eax),%edx
80104594:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104597:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104599:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010459c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010459f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801045a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045a5:	8b 50 18             	mov    0x18(%eax),%edx
801045a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045ab:	8b 40 18             	mov    0x18(%eax),%eax
801045ae:	89 c3                	mov    %eax,%ebx
801045b0:	b8 13 00 00 00       	mov    $0x13,%eax
801045b5:	89 d7                	mov    %edx,%edi
801045b7:	89 de                	mov    %ebx,%esi
801045b9:	89 c1                	mov    %eax,%ecx
801045bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801045bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045c0:	8b 40 18             	mov    0x18(%eax),%eax
801045c3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801045ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045d1:	eb 36                	jmp    80104609 <fork+0xf6>
    if(curproc->ofile[i])
801045d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045d9:	83 c2 08             	add    $0x8,%edx
801045dc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045e0:	85 c0                	test   %eax,%eax
801045e2:	74 22                	je     80104606 <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801045e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045ea:	83 c2 08             	add    $0x8,%edx
801045ed:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045f1:	89 04 24             	mov    %eax,(%esp)
801045f4:	e8 cb ca ff ff       	call   801010c4 <filedup>
801045f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801045fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801045ff:	83 c1 08             	add    $0x8,%ecx
80104602:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104606:	ff 45 e4             	incl   -0x1c(%ebp)
80104609:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010460d:	7e c4                	jle    801045d3 <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010460f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104612:	8b 40 68             	mov    0x68(%eax),%eax
80104615:	89 04 24             	mov    %eax,(%esp)
80104618:	e8 d7 d3 ff ff       	call   801019f4 <idup>
8010461d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104620:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104623:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104626:	8d 50 6c             	lea    0x6c(%eax),%edx
80104629:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010462c:	83 c0 6c             	add    $0x6c,%eax
8010462f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104636:	00 
80104637:	89 54 24 04          	mov    %edx,0x4(%esp)
8010463b:	89 04 24             	mov    %eax,(%esp)
8010463e:	e8 53 0c 00 00       	call   80105296 <safestrcpy>

  pid = np->pid;
80104643:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104646:	8b 40 10             	mov    0x10(%eax),%eax
80104649:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
8010464c:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104653:	e8 cf 07 00 00       	call   80104e27 <acquire>

  np->state = RUNNABLE;
80104658:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010465b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104662:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104669:	e8 23 08 00 00       	call   80104e91 <release>

  return pid;
8010466e:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104671:	83 c4 2c             	add    $0x2c,%esp
80104674:	5b                   	pop    %ebx
80104675:	5e                   	pop    %esi
80104676:	5f                   	pop    %edi
80104677:	5d                   	pop    %ebp
80104678:	c3                   	ret    

80104679 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104679:	55                   	push   %ebp
8010467a:	89 e5                	mov    %esp,%ebp
8010467c:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
8010467f:	e8 93 fb ff ff       	call   80104217 <myproc>
80104684:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104687:	a1 60 b6 10 80       	mov    0x8010b660,%eax
8010468c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010468f:	75 0c                	jne    8010469d <exit+0x24>
    panic("init exiting");
80104691:	c7 04 24 ea 8a 10 80 	movl   $0x80108aea,(%esp)
80104698:	e8 b7 be ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010469d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801046a4:	eb 3a                	jmp    801046e0 <exit+0x67>
    if(curproc->ofile[fd]){
801046a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046ac:	83 c2 08             	add    $0x8,%edx
801046af:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046b3:	85 c0                	test   %eax,%eax
801046b5:	74 26                	je     801046dd <exit+0x64>
      fileclose(curproc->ofile[fd]);
801046b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046bd:	83 c2 08             	add    $0x8,%edx
801046c0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c4:	89 04 24             	mov    %eax,(%esp)
801046c7:	e8 40 ca ff ff       	call   8010110c <fileclose>
      curproc->ofile[fd] = 0;
801046cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046d2:	83 c2 08             	add    $0x8,%edx
801046d5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801046dc:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801046dd:	ff 45 f0             	incl   -0x10(%ebp)
801046e0:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801046e4:	7e c0                	jle    801046a6 <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801046e6:	e8 34 ee ff ff       	call   8010351f <begin_op>
  iput(curproc->cwd);
801046eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ee:	8b 40 68             	mov    0x68(%eax),%eax
801046f1:	89 04 24             	mov    %eax,(%esp)
801046f4:	e8 7b d4 ff ff       	call   80101b74 <iput>
  end_op();
801046f9:	e8 a3 ee ff ff       	call   801035a1 <end_op>
  curproc->cwd = 0;
801046fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104701:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104708:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010470f:	e8 13 07 00 00       	call   80104e27 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104714:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104717:	8b 40 14             	mov    0x14(%eax),%eax
8010471a:	89 04 24             	mov    %eax,(%esp)
8010471d:	e8 cc 03 00 00       	call   80104aee <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104722:	c7 45 f4 d4 40 11 80 	movl   $0x801140d4,-0xc(%ebp)
80104729:	eb 33                	jmp    8010475e <exit+0xe5>
    if(p->parent == curproc){
8010472b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472e:	8b 40 14             	mov    0x14(%eax),%eax
80104731:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104734:	75 24                	jne    8010475a <exit+0xe1>
      p->parent = initproc;
80104736:	8b 15 60 b6 10 80    	mov    0x8010b660,%edx
8010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473f:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104745:	8b 40 0c             	mov    0xc(%eax),%eax
80104748:	83 f8 05             	cmp    $0x5,%eax
8010474b:	75 0d                	jne    8010475a <exit+0xe1>
        wakeup1(initproc);
8010474d:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80104752:	89 04 24             	mov    %eax,(%esp)
80104755:	e8 94 03 00 00       	call   80104aee <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010475e:	81 7d f4 d4 5f 11 80 	cmpl   $0x80115fd4,-0xc(%ebp)
80104765:	72 c4                	jb     8010472b <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104767:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010476a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104771:	e8 c3 01 00 00       	call   80104939 <sched>
  panic("zombie exit");
80104776:	c7 04 24 f7 8a 10 80 	movl   $0x80108af7,(%esp)
8010477d:	e8 d2 bd ff ff       	call   80100554 <panic>

80104782 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104782:	55                   	push   %ebp
80104783:	89 e5                	mov    %esp,%ebp
80104785:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104788:	e8 8a fa ff ff       	call   80104217 <myproc>
8010478d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104790:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104797:	e8 8b 06 00 00       	call   80104e27 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010479c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a3:	c7 45 f4 d4 40 11 80 	movl   $0x801140d4,-0xc(%ebp)
801047aa:	e9 95 00 00 00       	jmp    80104844 <wait+0xc2>
      if(p->parent != curproc)
801047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b2:	8b 40 14             	mov    0x14(%eax),%eax
801047b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801047b8:	74 05                	je     801047bf <wait+0x3d>
        continue;
801047ba:	e9 81 00 00 00       	jmp    80104840 <wait+0xbe>
      havekids = 1;
801047bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801047c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c9:	8b 40 0c             	mov    0xc(%eax),%eax
801047cc:	83 f8 05             	cmp    $0x5,%eax
801047cf:	75 6f                	jne    80104840 <wait+0xbe>
        // Found one.
        pid = p->pid;
801047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d4:	8b 40 10             	mov    0x10(%eax),%eax
801047d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801047da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dd:	8b 40 08             	mov    0x8(%eax),%eax
801047e0:	89 04 24             	mov    %eax,(%esp)
801047e3:	e8 d9 e3 ff ff       	call   80102bc1 <kfree>
        p->kstack = 0;
801047e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801047f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f5:	8b 40 04             	mov    0x4(%eax),%eax
801047f8:	89 04 24             	mov    %eax,(%esp)
801047fb:	e8 08 3a 00 00       	call   80108208 <freevm>
        p->pid = 0;
80104800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104803:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104817:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010481b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481e:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104828:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010482f:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104836:	e8 56 06 00 00       	call   80104e91 <release>
        return pid;
8010483b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010483e:	eb 4c                	jmp    8010488c <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104840:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104844:	81 7d f4 d4 5f 11 80 	cmpl   $0x80115fd4,-0xc(%ebp)
8010484b:	0f 82 5e ff ff ff    	jb     801047af <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104851:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104855:	74 0a                	je     80104861 <wait+0xdf>
80104857:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010485a:	8b 40 24             	mov    0x24(%eax),%eax
8010485d:	85 c0                	test   %eax,%eax
8010485f:	74 13                	je     80104874 <wait+0xf2>
      release(&ptable.lock);
80104861:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104868:	e8 24 06 00 00       	call   80104e91 <release>
      return -1;
8010486d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104872:	eb 18                	jmp    8010488c <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104874:	c7 44 24 04 a0 40 11 	movl   $0x801140a0,0x4(%esp)
8010487b:	80 
8010487c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010487f:	89 04 24             	mov    %eax,(%esp)
80104882:	e8 d1 01 00 00       	call   80104a58 <sleep>
  }
80104887:	e9 10 ff ff ff       	jmp    8010479c <wait+0x1a>
}
8010488c:	c9                   	leave  
8010488d:	c3                   	ret    

8010488e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010488e:	55                   	push   %ebp
8010488f:	89 e5                	mov    %esp,%ebp
80104891:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104894:	e8 fa f8 ff ff       	call   80104193 <mycpu>
80104899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010489c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010489f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801048a6:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801048a9:	e8 7e f8 ff ff       	call   8010412c <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048ae:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
801048b5:	e8 6d 05 00 00       	call   80104e27 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ba:	c7 45 f4 d4 40 11 80 	movl   $0x801140d4,-0xc(%ebp)
801048c1:	eb 5c                	jmp    8010491f <scheduler+0x91>
      if(p->state != RUNNABLE)
801048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c6:	8b 40 0c             	mov    0xc(%eax),%eax
801048c9:	83 f8 03             	cmp    $0x3,%eax
801048cc:	74 02                	je     801048d0 <scheduler+0x42>
        continue;
801048ce:	eb 4b                	jmp    8010491b <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801048d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048d6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801048dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048df:	89 04 24             	mov    %eax,(%esp)
801048e2:	e8 55 34 00 00       	call   80107d3c <switchuvm>
      p->state = RUNNING;
801048e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ea:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801048f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f4:	8b 40 1c             	mov    0x1c(%eax),%eax
801048f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048fa:	83 c2 04             	add    $0x4,%edx
801048fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104901:	89 14 24             	mov    %edx,(%esp)
80104904:	e8 fb 09 00 00       	call   80105304 <swtch>
      switchkvm();
80104909:	e8 14 34 00 00       	call   80107d22 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010490e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104911:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104918:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010491b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010491f:	81 7d f4 d4 5f 11 80 	cmpl   $0x80115fd4,-0xc(%ebp)
80104926:	72 9b                	jb     801048c3 <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104928:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010492f:	e8 5d 05 00 00       	call   80104e91 <release>

  }
80104934:	e9 70 ff ff ff       	jmp    801048a9 <scheduler+0x1b>

80104939 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104939:	55                   	push   %ebp
8010493a:	89 e5                	mov    %esp,%ebp
8010493c:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
8010493f:	e8 d3 f8 ff ff       	call   80104217 <myproc>
80104944:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104947:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
8010494e:	e8 02 06 00 00       	call   80104f55 <holding>
80104953:	85 c0                	test   %eax,%eax
80104955:	75 0c                	jne    80104963 <sched+0x2a>
    panic("sched ptable.lock");
80104957:	c7 04 24 03 8b 10 80 	movl   $0x80108b03,(%esp)
8010495e:	e8 f1 bb ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
80104963:	e8 2b f8 ff ff       	call   80104193 <mycpu>
80104968:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010496e:	83 f8 01             	cmp    $0x1,%eax
80104971:	74 0c                	je     8010497f <sched+0x46>
    panic("sched locks");
80104973:	c7 04 24 15 8b 10 80 	movl   $0x80108b15,(%esp)
8010497a:	e8 d5 bb ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
8010497f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104982:	8b 40 0c             	mov    0xc(%eax),%eax
80104985:	83 f8 04             	cmp    $0x4,%eax
80104988:	75 0c                	jne    80104996 <sched+0x5d>
    panic("sched running");
8010498a:	c7 04 24 21 8b 10 80 	movl   $0x80108b21,(%esp)
80104991:	e8 be bb ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
80104996:	e8 81 f7 ff ff       	call   8010411c <readeflags>
8010499b:	25 00 02 00 00       	and    $0x200,%eax
801049a0:	85 c0                	test   %eax,%eax
801049a2:	74 0c                	je     801049b0 <sched+0x77>
    panic("sched interruptible");
801049a4:	c7 04 24 2f 8b 10 80 	movl   $0x80108b2f,(%esp)
801049ab:	e8 a4 bb ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
801049b0:	e8 de f7 ff ff       	call   80104193 <mycpu>
801049b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801049be:	e8 d0 f7 ff ff       	call   80104193 <mycpu>
801049c3:	8b 40 04             	mov    0x4(%eax),%eax
801049c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049c9:	83 c2 1c             	add    $0x1c,%edx
801049cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d0:	89 14 24             	mov    %edx,(%esp)
801049d3:	e8 2c 09 00 00       	call   80105304 <swtch>
  mycpu()->intena = intena;
801049d8:	e8 b6 f7 ff ff       	call   80104193 <mycpu>
801049dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049e0:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801049e6:	c9                   	leave  
801049e7:	c3                   	ret    

801049e8 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801049e8:	55                   	push   %ebp
801049e9:	89 e5                	mov    %esp,%ebp
801049eb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801049ee:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
801049f5:	e8 2d 04 00 00       	call   80104e27 <acquire>
  myproc()->state = RUNNABLE;
801049fa:	e8 18 f8 ff ff       	call   80104217 <myproc>
801049ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104a06:	e8 2e ff ff ff       	call   80104939 <sched>
  release(&ptable.lock);
80104a0b:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104a12:	e8 7a 04 00 00       	call   80104e91 <release>
}
80104a17:	c9                   	leave  
80104a18:	c3                   	ret    

80104a19 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a19:	55                   	push   %ebp
80104a1a:	89 e5                	mov    %esp,%ebp
80104a1c:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104a1f:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104a26:	e8 66 04 00 00       	call   80104e91 <release>

  if (first) {
80104a2b:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104a30:	85 c0                	test   %eax,%eax
80104a32:	74 22                	je     80104a56 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a34:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104a3b:	00 00 00 
    iinit(ROOTDEV);
80104a3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a45:	e8 75 cc ff ff       	call   801016bf <iinit>
    initlog(ROOTDEV);
80104a4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a51:	e8 ca e8 ff ff       	call   80103320 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104a56:	c9                   	leave  
80104a57:	c3                   	ret    

80104a58 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a58:	55                   	push   %ebp
80104a59:	89 e5                	mov    %esp,%ebp
80104a5b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104a5e:	e8 b4 f7 ff ff       	call   80104217 <myproc>
80104a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a6a:	75 0c                	jne    80104a78 <sleep+0x20>
    panic("sleep");
80104a6c:	c7 04 24 43 8b 10 80 	movl   $0x80108b43,(%esp)
80104a73:	e8 dc ba ff ff       	call   80100554 <panic>

  if(lk == 0)
80104a78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a7c:	75 0c                	jne    80104a8a <sleep+0x32>
    panic("sleep without lk");
80104a7e:	c7 04 24 49 8b 10 80 	movl   $0x80108b49,(%esp)
80104a85:	e8 ca ba ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a8a:	81 7d 0c a0 40 11 80 	cmpl   $0x801140a0,0xc(%ebp)
80104a91:	74 17                	je     80104aaa <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a93:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104a9a:	e8 88 03 00 00       	call   80104e27 <acquire>
    release(lk);
80104a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa2:	89 04 24             	mov    %eax,(%esp)
80104aa5:	e8 e7 03 00 00       	call   80104e91 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aad:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab0:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab6:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104abd:	e8 77 fe ff ff       	call   80104939 <sched>

  // Tidy up.
  p->chan = 0;
80104ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104acc:	81 7d 0c a0 40 11 80 	cmpl   $0x801140a0,0xc(%ebp)
80104ad3:	74 17                	je     80104aec <sleep+0x94>
    release(&ptable.lock);
80104ad5:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104adc:	e8 b0 03 00 00       	call   80104e91 <release>
    acquire(lk);
80104ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae4:	89 04 24             	mov    %eax,(%esp)
80104ae7:	e8 3b 03 00 00       	call   80104e27 <acquire>
  }
}
80104aec:	c9                   	leave  
80104aed:	c3                   	ret    

80104aee <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104aee:	55                   	push   %ebp
80104aef:	89 e5                	mov    %esp,%ebp
80104af1:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af4:	c7 45 fc d4 40 11 80 	movl   $0x801140d4,-0x4(%ebp)
80104afb:	eb 24                	jmp    80104b21 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b00:	8b 40 0c             	mov    0xc(%eax),%eax
80104b03:	83 f8 02             	cmp    $0x2,%eax
80104b06:	75 15                	jne    80104b1d <wakeup1+0x2f>
80104b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b0b:	8b 40 20             	mov    0x20(%eax),%eax
80104b0e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b11:	75 0a                	jne    80104b1d <wakeup1+0x2f>
      p->state = RUNNABLE;
80104b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b16:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b1d:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104b21:	81 7d fc d4 5f 11 80 	cmpl   $0x80115fd4,-0x4(%ebp)
80104b28:	72 d3                	jb     80104afd <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    

80104b2c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b2c:	55                   	push   %ebp
80104b2d:	89 e5                	mov    %esp,%ebp
80104b2f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104b32:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104b39:	e8 e9 02 00 00       	call   80104e27 <acquire>
  wakeup1(chan);
80104b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b41:	89 04 24             	mov    %eax,(%esp)
80104b44:	e8 a5 ff ff ff       	call   80104aee <wakeup1>
  release(&ptable.lock);
80104b49:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104b50:	e8 3c 03 00 00       	call   80104e91 <release>
}
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    

80104b57 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b57:	55                   	push   %ebp
80104b58:	89 e5                	mov    %esp,%ebp
80104b5a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b5d:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104b64:	e8 be 02 00 00       	call   80104e27 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b69:	c7 45 f4 d4 40 11 80 	movl   $0x801140d4,-0xc(%ebp)
80104b70:	eb 41                	jmp    80104bb3 <kill+0x5c>
    if(p->pid == pid){
80104b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b75:	8b 40 10             	mov    0x10(%eax),%eax
80104b78:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b7b:	75 32                	jne    80104baf <kill+0x58>
      p->killed = 1;
80104b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b80:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8a:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8d:	83 f8 02             	cmp    $0x2,%eax
80104b90:	75 0a                	jne    80104b9c <kill+0x45>
        p->state = RUNNABLE;
80104b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b9c:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104ba3:	e8 e9 02 00 00       	call   80104e91 <release>
      return 0;
80104ba8:	b8 00 00 00 00       	mov    $0x0,%eax
80104bad:	eb 1e                	jmp    80104bcd <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104baf:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104bb3:	81 7d f4 d4 5f 11 80 	cmpl   $0x80115fd4,-0xc(%ebp)
80104bba:	72 b6                	jb     80104b72 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104bbc:	c7 04 24 a0 40 11 80 	movl   $0x801140a0,(%esp)
80104bc3:	e8 c9 02 00 00       	call   80104e91 <release>
  return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    

80104bcf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bcf:	55                   	push   %ebp
80104bd0:	89 e5                	mov    %esp,%ebp
80104bd2:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd5:	c7 45 f0 d4 40 11 80 	movl   $0x801140d4,-0x10(%ebp)
80104bdc:	e9 d5 00 00 00       	jmp    80104cb6 <procdump+0xe7>
    if(p->state == UNUSED)
80104be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be4:	8b 40 0c             	mov    0xc(%eax),%eax
80104be7:	85 c0                	test   %eax,%eax
80104be9:	75 05                	jne    80104bf0 <procdump+0x21>
      continue;
80104beb:	e9 c2 00 00 00       	jmp    80104cb2 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf3:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf6:	83 f8 05             	cmp    $0x5,%eax
80104bf9:	77 23                	ja     80104c1e <procdump+0x4f>
80104bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfe:	8b 40 0c             	mov    0xc(%eax),%eax
80104c01:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c08:	85 c0                	test   %eax,%eax
80104c0a:	74 12                	je     80104c1e <procdump+0x4f>
      state = states[p->state];
80104c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c0f:	8b 40 0c             	mov    0xc(%eax),%eax
80104c12:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c1c:	eb 07                	jmp    80104c25 <procdump+0x56>
    else
      state = "???";
80104c1e:	c7 45 ec 5a 8b 10 80 	movl   $0x80108b5a,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c28:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2e:	8b 40 10             	mov    0x10(%eax),%eax
80104c31:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104c35:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104c38:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c40:	c7 04 24 5e 8b 10 80 	movl   $0x80108b5e,(%esp)
80104c47:	e8 75 b7 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80104c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c4f:	8b 40 0c             	mov    0xc(%eax),%eax
80104c52:	83 f8 02             	cmp    $0x2,%eax
80104c55:	75 4f                	jne    80104ca6 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c5a:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104c60:	83 c0 08             	add    $0x8,%eax
80104c63:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c66:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c6a:	89 04 24             	mov    %eax,(%esp)
80104c6d:	e8 6c 02 00 00       	call   80104ede <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c79:	eb 1a                	jmp    80104c95 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c82:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c86:	c7 04 24 67 8b 10 80 	movl   $0x80108b67,(%esp)
80104c8d:	e8 2f b7 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104c92:	ff 45 f4             	incl   -0xc(%ebp)
80104c95:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104c99:	7f 0b                	jg     80104ca6 <procdump+0xd7>
80104c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	75 d5                	jne    80104c7b <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ca6:	c7 04 24 6b 8b 10 80 	movl   $0x80108b6b,(%esp)
80104cad:	e8 0f b7 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb2:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104cb6:	81 7d f0 d4 5f 11 80 	cmpl   $0x80115fd4,-0x10(%ebp)
80104cbd:	0f 82 1e ff ff ff    	jb     80104be1 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104cc3:	c9                   	leave  
80104cc4:	c3                   	ret    
80104cc5:	00 00                	add    %al,(%eax)
	...

80104cc8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104cc8:	55                   	push   %ebp
80104cc9:	89 e5                	mov    %esp,%ebp
80104ccb:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104cce:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd1:	83 c0 04             	add    $0x4,%eax
80104cd4:	c7 44 24 04 97 8b 10 	movl   $0x80108b97,0x4(%esp)
80104cdb:	80 
80104cdc:	89 04 24             	mov    %eax,(%esp)
80104cdf:	e8 22 01 00 00       	call   80104e06 <initlock>
  lk->name = name;
80104ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cea:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104ced:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf9:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104d00:	c9                   	leave  
80104d01:	c3                   	ret    

80104d02 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d02:	55                   	push   %ebp
80104d03:	89 e5                	mov    %esp,%ebp
80104d05:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104d08:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0b:	83 c0 04             	add    $0x4,%eax
80104d0e:	89 04 24             	mov    %eax,(%esp)
80104d11:	e8 11 01 00 00       	call   80104e27 <acquire>
  while (lk->locked) {
80104d16:	eb 15                	jmp    80104d2d <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104d18:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1b:	83 c0 04             	add    $0x4,%eax
80104d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d22:	8b 45 08             	mov    0x8(%ebp),%eax
80104d25:	89 04 24             	mov    %eax,(%esp)
80104d28:	e8 2b fd ff ff       	call   80104a58 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d30:	8b 00                	mov    (%eax),%eax
80104d32:	85 c0                	test   %eax,%eax
80104d34:	75 e2                	jne    80104d18 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104d36:	8b 45 08             	mov    0x8(%ebp),%eax
80104d39:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104d3f:	e8 d3 f4 ff ff       	call   80104217 <myproc>
80104d44:	8b 50 10             	mov    0x10(%eax),%edx
80104d47:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4a:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d50:	83 c0 04             	add    $0x4,%eax
80104d53:	89 04 24             	mov    %eax,(%esp)
80104d56:	e8 36 01 00 00       	call   80104e91 <release>
}
80104d5b:	c9                   	leave  
80104d5c:	c3                   	ret    

80104d5d <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d5d:	55                   	push   %ebp
80104d5e:	89 e5                	mov    %esp,%ebp
80104d60:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104d63:	8b 45 08             	mov    0x8(%ebp),%eax
80104d66:	83 c0 04             	add    $0x4,%eax
80104d69:	89 04 24             	mov    %eax,(%esp)
80104d6c:	e8 b6 00 00 00       	call   80104e27 <acquire>
  lk->locked = 0;
80104d71:	8b 45 08             	mov    0x8(%ebp),%eax
80104d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104d84:	8b 45 08             	mov    0x8(%ebp),%eax
80104d87:	89 04 24             	mov    %eax,(%esp)
80104d8a:	e8 9d fd ff ff       	call   80104b2c <wakeup>
  release(&lk->lk);
80104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d92:	83 c0 04             	add    $0x4,%eax
80104d95:	89 04 24             	mov    %eax,(%esp)
80104d98:	e8 f4 00 00 00       	call   80104e91 <release>
}
80104d9d:	c9                   	leave  
80104d9e:	c3                   	ret    

80104d9f <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d9f:	55                   	push   %ebp
80104da0:	89 e5                	mov    %esp,%ebp
80104da2:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104da5:	8b 45 08             	mov    0x8(%ebp),%eax
80104da8:	83 c0 04             	add    $0x4,%eax
80104dab:	89 04 24             	mov    %eax,(%esp)
80104dae:	e8 74 00 00 00       	call   80104e27 <acquire>
  r = lk->locked;
80104db3:	8b 45 08             	mov    0x8(%ebp),%eax
80104db6:	8b 00                	mov    (%eax),%eax
80104db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80104dbe:	83 c0 04             	add    $0x4,%eax
80104dc1:	89 04 24             	mov    %eax,(%esp)
80104dc4:	e8 c8 00 00 00       	call   80104e91 <release>
  return r;
80104dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104dcc:	c9                   	leave  
80104dcd:	c3                   	ret    
	...

80104dd0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104dd6:	9c                   	pushf  
80104dd7:	58                   	pop    %eax
80104dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dde:	c9                   	leave  
80104ddf:	c3                   	ret    

80104de0 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104de3:	fa                   	cli    
}
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    

80104de6 <sti>:

static inline void
sti(void)
{
80104de6:	55                   	push   %ebp
80104de7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104de9:	fb                   	sti    
}
80104dea:	5d                   	pop    %ebp
80104deb:	c3                   	ret    

80104dec <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104dec:	55                   	push   %ebp
80104ded:	89 e5                	mov    %esp,%ebp
80104def:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104df2:	8b 55 08             	mov    0x8(%ebp),%edx
80104df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104df8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dfb:	f0 87 02             	lock xchg %eax,(%edx)
80104dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e04:	c9                   	leave  
80104e05:	c3                   	ret    

80104e06 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e06:	55                   	push   %ebp
80104e07:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104e09:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e0f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104e12:	8b 45 08             	mov    0x8(%ebp),%eax
80104e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e25:	5d                   	pop    %ebp
80104e26:	c3                   	ret    

80104e27 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e27:	55                   	push   %ebp
80104e28:	89 e5                	mov    %esp,%ebp
80104e2a:	53                   	push   %ebx
80104e2b:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e2e:	e8 53 01 00 00       	call   80104f86 <pushcli>
  if(holding(lk))
80104e33:	8b 45 08             	mov    0x8(%ebp),%eax
80104e36:	89 04 24             	mov    %eax,(%esp)
80104e39:	e8 17 01 00 00       	call   80104f55 <holding>
80104e3e:	85 c0                	test   %eax,%eax
80104e40:	74 0c                	je     80104e4e <acquire+0x27>
    panic("acquire");
80104e42:	c7 04 24 a2 8b 10 80 	movl   $0x80108ba2,(%esp)
80104e49:	e8 06 b7 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104e4e:	90                   	nop
80104e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e52:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104e59:	00 
80104e5a:	89 04 24             	mov    %eax,(%esp)
80104e5d:	e8 8a ff ff ff       	call   80104dec <xchg>
80104e62:	85 c0                	test   %eax,%eax
80104e64:	75 e9                	jne    80104e4f <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104e66:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e6e:	e8 20 f3 ff ff       	call   80104193 <mycpu>
80104e73:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104e76:	8b 45 08             	mov    0x8(%ebp),%eax
80104e79:	83 c0 0c             	add    $0xc,%eax
80104e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e80:	8d 45 08             	lea    0x8(%ebp),%eax
80104e83:	89 04 24             	mov    %eax,(%esp)
80104e86:	e8 53 00 00 00       	call   80104ede <getcallerpcs>
}
80104e8b:	83 c4 14             	add    $0x14,%esp
80104e8e:	5b                   	pop    %ebx
80104e8f:	5d                   	pop    %ebp
80104e90:	c3                   	ret    

80104e91 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104e91:	55                   	push   %ebp
80104e92:	89 e5                	mov    %esp,%ebp
80104e94:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104e97:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9a:	89 04 24             	mov    %eax,(%esp)
80104e9d:	e8 b3 00 00 00       	call   80104f55 <holding>
80104ea2:	85 c0                	test   %eax,%eax
80104ea4:	75 0c                	jne    80104eb2 <release+0x21>
    panic("release");
80104ea6:	c7 04 24 aa 8b 10 80 	movl   $0x80108baa,(%esp)
80104ead:	e8 a2 b6 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
80104eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104ec6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ece:	8b 55 08             	mov    0x8(%ebp),%edx
80104ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104ed7:	e8 f4 00 00 00       	call   80104fd0 <popcli>
}
80104edc:	c9                   	leave  
80104edd:	c3                   	ret    

80104ede <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ede:	55                   	push   %ebp
80104edf:	89 e5                	mov    %esp,%ebp
80104ee1:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee7:	83 e8 08             	sub    $0x8,%eax
80104eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104eed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104ef4:	eb 37                	jmp    80104f2d <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104efa:	74 37                	je     80104f33 <getcallerpcs+0x55>
80104efc:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104f03:	76 2e                	jbe    80104f33 <getcallerpcs+0x55>
80104f05:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104f09:	74 28                	je     80104f33 <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f18:	01 c2                	add    %eax,%edx
80104f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f1d:	8b 40 04             	mov    0x4(%eax),%eax
80104f20:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f25:	8b 00                	mov    (%eax),%eax
80104f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f2a:	ff 45 f8             	incl   -0x8(%ebp)
80104f2d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f31:	7e c3                	jle    80104ef6 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f33:	eb 18                	jmp    80104f4d <getcallerpcs+0x6f>
    pcs[i] = 0;
80104f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f42:	01 d0                	add    %edx,%eax
80104f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f4a:	ff 45 f8             	incl   -0x8(%ebp)
80104f4d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f51:	7e e2                	jle    80104f35 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80104f53:	c9                   	leave  
80104f54:	c3                   	ret    

80104f55 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104f55:	55                   	push   %ebp
80104f56:	89 e5                	mov    %esp,%ebp
80104f58:	53                   	push   %ebx
80104f59:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5f:	8b 00                	mov    (%eax),%eax
80104f61:	85 c0                	test   %eax,%eax
80104f63:	74 16                	je     80104f7b <holding+0x26>
80104f65:	8b 45 08             	mov    0x8(%ebp),%eax
80104f68:	8b 58 08             	mov    0x8(%eax),%ebx
80104f6b:	e8 23 f2 ff ff       	call   80104193 <mycpu>
80104f70:	39 c3                	cmp    %eax,%ebx
80104f72:	75 07                	jne    80104f7b <holding+0x26>
80104f74:	b8 01 00 00 00       	mov    $0x1,%eax
80104f79:	eb 05                	jmp    80104f80 <holding+0x2b>
80104f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f80:	83 c4 04             	add    $0x4,%esp
80104f83:	5b                   	pop    %ebx
80104f84:	5d                   	pop    %ebp
80104f85:	c3                   	ret    

80104f86 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f86:	55                   	push   %ebp
80104f87:	89 e5                	mov    %esp,%ebp
80104f89:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104f8c:	e8 3f fe ff ff       	call   80104dd0 <readeflags>
80104f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104f94:	e8 47 fe ff ff       	call   80104de0 <cli>
  if(mycpu()->ncli == 0)
80104f99:	e8 f5 f1 ff ff       	call   80104193 <mycpu>
80104f9e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fa4:	85 c0                	test   %eax,%eax
80104fa6:	75 14                	jne    80104fbc <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104fa8:	e8 e6 f1 ff ff       	call   80104193 <mycpu>
80104fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb0:	81 e2 00 02 00 00    	and    $0x200,%edx
80104fb6:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104fbc:	e8 d2 f1 ff ff       	call   80104193 <mycpu>
80104fc1:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fc7:	42                   	inc    %edx
80104fc8:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104fce:	c9                   	leave  
80104fcf:	c3                   	ret    

80104fd0 <popcli>:

void
popcli(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104fd6:	e8 f5 fd ff ff       	call   80104dd0 <readeflags>
80104fdb:	25 00 02 00 00       	and    $0x200,%eax
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	74 0c                	je     80104ff0 <popcli+0x20>
    panic("popcli - interruptible");
80104fe4:	c7 04 24 b2 8b 10 80 	movl   $0x80108bb2,(%esp)
80104feb:	e8 64 b5 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
80104ff0:	e8 9e f1 ff ff       	call   80104193 <mycpu>
80104ff5:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ffb:	4a                   	dec    %edx
80104ffc:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105002:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105008:	85 c0                	test   %eax,%eax
8010500a:	79 0c                	jns    80105018 <popcli+0x48>
    panic("popcli");
8010500c:	c7 04 24 c9 8b 10 80 	movl   $0x80108bc9,(%esp)
80105013:	e8 3c b5 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105018:	e8 76 f1 ff ff       	call   80104193 <mycpu>
8010501d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105023:	85 c0                	test   %eax,%eax
80105025:	75 14                	jne    8010503b <popcli+0x6b>
80105027:	e8 67 f1 ff ff       	call   80104193 <mycpu>
8010502c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105032:	85 c0                	test   %eax,%eax
80105034:	74 05                	je     8010503b <popcli+0x6b>
    sti();
80105036:	e8 ab fd ff ff       	call   80104de6 <sti>
}
8010503b:	c9                   	leave  
8010503c:	c3                   	ret    
8010503d:	00 00                	add    %al,(%eax)
	...

80105040 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105045:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105048:	8b 55 10             	mov    0x10(%ebp),%edx
8010504b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504e:	89 cb                	mov    %ecx,%ebx
80105050:	89 df                	mov    %ebx,%edi
80105052:	89 d1                	mov    %edx,%ecx
80105054:	fc                   	cld    
80105055:	f3 aa                	rep stos %al,%es:(%edi)
80105057:	89 ca                	mov    %ecx,%edx
80105059:	89 fb                	mov    %edi,%ebx
8010505b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010505e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105061:	5b                   	pop    %ebx
80105062:	5f                   	pop    %edi
80105063:	5d                   	pop    %ebp
80105064:	c3                   	ret    

80105065 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105065:	55                   	push   %ebp
80105066:	89 e5                	mov    %esp,%ebp
80105068:	57                   	push   %edi
80105069:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010506a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010506d:	8b 55 10             	mov    0x10(%ebp),%edx
80105070:	8b 45 0c             	mov    0xc(%ebp),%eax
80105073:	89 cb                	mov    %ecx,%ebx
80105075:	89 df                	mov    %ebx,%edi
80105077:	89 d1                	mov    %edx,%ecx
80105079:	fc                   	cld    
8010507a:	f3 ab                	rep stos %eax,%es:(%edi)
8010507c:	89 ca                	mov    %ecx,%edx
8010507e:	89 fb                	mov    %edi,%ebx
80105080:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105083:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105086:	5b                   	pop    %ebx
80105087:	5f                   	pop    %edi
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret    

8010508a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010508a:	55                   	push   %ebp
8010508b:	89 e5                	mov    %esp,%ebp
8010508d:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105090:	8b 45 08             	mov    0x8(%ebp),%eax
80105093:	83 e0 03             	and    $0x3,%eax
80105096:	85 c0                	test   %eax,%eax
80105098:	75 49                	jne    801050e3 <memset+0x59>
8010509a:	8b 45 10             	mov    0x10(%ebp),%eax
8010509d:	83 e0 03             	and    $0x3,%eax
801050a0:	85 c0                	test   %eax,%eax
801050a2:	75 3f                	jne    801050e3 <memset+0x59>
    c &= 0xFF;
801050a4:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801050ab:	8b 45 10             	mov    0x10(%ebp),%eax
801050ae:	c1 e8 02             	shr    $0x2,%eax
801050b1:	89 c2                	mov    %eax,%edx
801050b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b6:	c1 e0 18             	shl    $0x18,%eax
801050b9:	89 c1                	mov    %eax,%ecx
801050bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050be:	c1 e0 10             	shl    $0x10,%eax
801050c1:	09 c1                	or     %eax,%ecx
801050c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c6:	c1 e0 08             	shl    $0x8,%eax
801050c9:	09 c8                	or     %ecx,%eax
801050cb:	0b 45 0c             	or     0xc(%ebp),%eax
801050ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801050d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d6:	8b 45 08             	mov    0x8(%ebp),%eax
801050d9:	89 04 24             	mov    %eax,(%esp)
801050dc:	e8 84 ff ff ff       	call   80105065 <stosl>
801050e1:	eb 19                	jmp    801050fc <memset+0x72>
  } else
    stosb(dst, c, n);
801050e3:	8b 45 10             	mov    0x10(%ebp),%eax
801050e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801050ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f1:	8b 45 08             	mov    0x8(%ebp),%eax
801050f4:	89 04 24             	mov    %eax,(%esp)
801050f7:	e8 44 ff ff ff       	call   80105040 <stosb>
  return dst;
801050fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801050ff:	c9                   	leave  
80105100:	c3                   	ret    

80105101 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105101:	55                   	push   %ebp
80105102:	89 e5                	mov    %esp,%ebp
80105104:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105107:	8b 45 08             	mov    0x8(%ebp),%eax
8010510a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010510d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105110:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105113:	eb 2a                	jmp    8010513f <memcmp+0x3e>
    if(*s1 != *s2)
80105115:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105118:	8a 10                	mov    (%eax),%dl
8010511a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010511d:	8a 00                	mov    (%eax),%al
8010511f:	38 c2                	cmp    %al,%dl
80105121:	74 16                	je     80105139 <memcmp+0x38>
      return *s1 - *s2;
80105123:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105126:	8a 00                	mov    (%eax),%al
80105128:	0f b6 d0             	movzbl %al,%edx
8010512b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010512e:	8a 00                	mov    (%eax),%al
80105130:	0f b6 c0             	movzbl %al,%eax
80105133:	29 c2                	sub    %eax,%edx
80105135:	89 d0                	mov    %edx,%eax
80105137:	eb 18                	jmp    80105151 <memcmp+0x50>
    s1++, s2++;
80105139:	ff 45 fc             	incl   -0x4(%ebp)
8010513c:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010513f:	8b 45 10             	mov    0x10(%ebp),%eax
80105142:	8d 50 ff             	lea    -0x1(%eax),%edx
80105145:	89 55 10             	mov    %edx,0x10(%ebp)
80105148:	85 c0                	test   %eax,%eax
8010514a:	75 c9                	jne    80105115 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010514c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105151:	c9                   	leave  
80105152:	c3                   	ret    

80105153 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105153:	55                   	push   %ebp
80105154:	89 e5                	mov    %esp,%ebp
80105156:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105159:	8b 45 0c             	mov    0xc(%ebp),%eax
8010515c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010515f:	8b 45 08             	mov    0x8(%ebp),%eax
80105162:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105165:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105168:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010516b:	73 3a                	jae    801051a7 <memmove+0x54>
8010516d:	8b 45 10             	mov    0x10(%ebp),%eax
80105170:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105173:	01 d0                	add    %edx,%eax
80105175:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105178:	76 2d                	jbe    801051a7 <memmove+0x54>
    s += n;
8010517a:	8b 45 10             	mov    0x10(%ebp),%eax
8010517d:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105180:	8b 45 10             	mov    0x10(%ebp),%eax
80105183:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105186:	eb 10                	jmp    80105198 <memmove+0x45>
      *--d = *--s;
80105188:	ff 4d f8             	decl   -0x8(%ebp)
8010518b:	ff 4d fc             	decl   -0x4(%ebp)
8010518e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105191:	8a 10                	mov    (%eax),%dl
80105193:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105196:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105198:	8b 45 10             	mov    0x10(%ebp),%eax
8010519b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010519e:	89 55 10             	mov    %edx,0x10(%ebp)
801051a1:	85 c0                	test   %eax,%eax
801051a3:	75 e3                	jne    80105188 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051a5:	eb 25                	jmp    801051cc <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801051a7:	eb 16                	jmp    801051bf <memmove+0x6c>
      *d++ = *s++;
801051a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051ac:	8d 50 01             	lea    0x1(%eax),%edx
801051af:	89 55 f8             	mov    %edx,-0x8(%ebp)
801051b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051b5:	8d 4a 01             	lea    0x1(%edx),%ecx
801051b8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801051bb:	8a 12                	mov    (%edx),%dl
801051bd:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801051bf:	8b 45 10             	mov    0x10(%ebp),%eax
801051c2:	8d 50 ff             	lea    -0x1(%eax),%edx
801051c5:	89 55 10             	mov    %edx,0x10(%ebp)
801051c8:	85 c0                	test   %eax,%eax
801051ca:	75 dd                	jne    801051a9 <memmove+0x56>
      *d++ = *s++;

  return dst;
801051cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051cf:	c9                   	leave  
801051d0:	c3                   	ret    

801051d1 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801051d1:	55                   	push   %ebp
801051d2:	89 e5                	mov    %esp,%ebp
801051d4:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801051d7:	8b 45 10             	mov    0x10(%ebp),%eax
801051da:	89 44 24 08          	mov    %eax,0x8(%esp)
801051de:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e5:	8b 45 08             	mov    0x8(%ebp),%eax
801051e8:	89 04 24             	mov    %eax,(%esp)
801051eb:	e8 63 ff ff ff       	call   80105153 <memmove>
}
801051f0:	c9                   	leave  
801051f1:	c3                   	ret    

801051f2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801051f2:	55                   	push   %ebp
801051f3:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801051f5:	eb 09                	jmp    80105200 <strncmp+0xe>
    n--, p++, q++;
801051f7:	ff 4d 10             	decl   0x10(%ebp)
801051fa:	ff 45 08             	incl   0x8(%ebp)
801051fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105204:	74 17                	je     8010521d <strncmp+0x2b>
80105206:	8b 45 08             	mov    0x8(%ebp),%eax
80105209:	8a 00                	mov    (%eax),%al
8010520b:	84 c0                	test   %al,%al
8010520d:	74 0e                	je     8010521d <strncmp+0x2b>
8010520f:	8b 45 08             	mov    0x8(%ebp),%eax
80105212:	8a 10                	mov    (%eax),%dl
80105214:	8b 45 0c             	mov    0xc(%ebp),%eax
80105217:	8a 00                	mov    (%eax),%al
80105219:	38 c2                	cmp    %al,%dl
8010521b:	74 da                	je     801051f7 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010521d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105221:	75 07                	jne    8010522a <strncmp+0x38>
    return 0;
80105223:	b8 00 00 00 00       	mov    $0x0,%eax
80105228:	eb 14                	jmp    8010523e <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
8010522a:	8b 45 08             	mov    0x8(%ebp),%eax
8010522d:	8a 00                	mov    (%eax),%al
8010522f:	0f b6 d0             	movzbl %al,%edx
80105232:	8b 45 0c             	mov    0xc(%ebp),%eax
80105235:	8a 00                	mov    (%eax),%al
80105237:	0f b6 c0             	movzbl %al,%eax
8010523a:	29 c2                	sub    %eax,%edx
8010523c:	89 d0                	mov    %edx,%eax
}
8010523e:	5d                   	pop    %ebp
8010523f:	c3                   	ret    

80105240 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105246:	8b 45 08             	mov    0x8(%ebp),%eax
80105249:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010524c:	90                   	nop
8010524d:	8b 45 10             	mov    0x10(%ebp),%eax
80105250:	8d 50 ff             	lea    -0x1(%eax),%edx
80105253:	89 55 10             	mov    %edx,0x10(%ebp)
80105256:	85 c0                	test   %eax,%eax
80105258:	7e 1c                	jle    80105276 <strncpy+0x36>
8010525a:	8b 45 08             	mov    0x8(%ebp),%eax
8010525d:	8d 50 01             	lea    0x1(%eax),%edx
80105260:	89 55 08             	mov    %edx,0x8(%ebp)
80105263:	8b 55 0c             	mov    0xc(%ebp),%edx
80105266:	8d 4a 01             	lea    0x1(%edx),%ecx
80105269:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010526c:	8a 12                	mov    (%edx),%dl
8010526e:	88 10                	mov    %dl,(%eax)
80105270:	8a 00                	mov    (%eax),%al
80105272:	84 c0                	test   %al,%al
80105274:	75 d7                	jne    8010524d <strncpy+0xd>
    ;
  while(n-- > 0)
80105276:	eb 0c                	jmp    80105284 <strncpy+0x44>
    *s++ = 0;
80105278:	8b 45 08             	mov    0x8(%ebp),%eax
8010527b:	8d 50 01             	lea    0x1(%eax),%edx
8010527e:	89 55 08             	mov    %edx,0x8(%ebp)
80105281:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105284:	8b 45 10             	mov    0x10(%ebp),%eax
80105287:	8d 50 ff             	lea    -0x1(%eax),%edx
8010528a:	89 55 10             	mov    %edx,0x10(%ebp)
8010528d:	85 c0                	test   %eax,%eax
8010528f:	7f e7                	jg     80105278 <strncpy+0x38>
    *s++ = 0;
  return os;
80105291:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105294:	c9                   	leave  
80105295:	c3                   	ret    

80105296 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105296:	55                   	push   %ebp
80105297:	89 e5                	mov    %esp,%ebp
80105299:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010529c:	8b 45 08             	mov    0x8(%ebp),%eax
8010529f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801052a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052a6:	7f 05                	jg     801052ad <safestrcpy+0x17>
    return os;
801052a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ab:	eb 2e                	jmp    801052db <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
801052ad:	ff 4d 10             	decl   0x10(%ebp)
801052b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052b4:	7e 1c                	jle    801052d2 <safestrcpy+0x3c>
801052b6:	8b 45 08             	mov    0x8(%ebp),%eax
801052b9:	8d 50 01             	lea    0x1(%eax),%edx
801052bc:	89 55 08             	mov    %edx,0x8(%ebp)
801052bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801052c2:	8d 4a 01             	lea    0x1(%edx),%ecx
801052c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801052c8:	8a 12                	mov    (%edx),%dl
801052ca:	88 10                	mov    %dl,(%eax)
801052cc:	8a 00                	mov    (%eax),%al
801052ce:	84 c0                	test   %al,%al
801052d0:	75 db                	jne    801052ad <safestrcpy+0x17>
    ;
  *s = 0;
801052d2:	8b 45 08             	mov    0x8(%ebp),%eax
801052d5:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801052d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052db:	c9                   	leave  
801052dc:	c3                   	ret    

801052dd <strlen>:

int
strlen(const char *s)
{
801052dd:	55                   	push   %ebp
801052de:	89 e5                	mov    %esp,%ebp
801052e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801052e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801052ea:	eb 03                	jmp    801052ef <strlen+0x12>
801052ec:	ff 45 fc             	incl   -0x4(%ebp)
801052ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052f2:	8b 45 08             	mov    0x8(%ebp),%eax
801052f5:	01 d0                	add    %edx,%eax
801052f7:	8a 00                	mov    (%eax),%al
801052f9:	84 c0                	test   %al,%al
801052fb:	75 ef                	jne    801052ec <strlen+0xf>
    ;
  return n;
801052fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105300:	c9                   	leave  
80105301:	c3                   	ret    
	...

80105304 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105304:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105308:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010530c:	55                   	push   %ebp
  pushl %ebx
8010530d:	53                   	push   %ebx
  pushl %esi
8010530e:	56                   	push   %esi
  pushl %edi
8010530f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105310:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105312:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105314:	5f                   	pop    %edi
  popl %esi
80105315:	5e                   	pop    %esi
  popl %ebx
80105316:	5b                   	pop    %ebx
  popl %ebp
80105317:	5d                   	pop    %ebp
  ret
80105318:	c3                   	ret    
80105319:	00 00                	add    %al,(%eax)
	...

8010531c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010531c:	55                   	push   %ebp
8010531d:	89 e5                	mov    %esp,%ebp
8010531f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105322:	e8 f0 ee ff ff       	call   80104217 <myproc>
80105327:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010532a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532d:	8b 00                	mov    (%eax),%eax
8010532f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105332:	76 0f                	jbe    80105343 <fetchint+0x27>
80105334:	8b 45 08             	mov    0x8(%ebp),%eax
80105337:	8d 50 04             	lea    0x4(%eax),%edx
8010533a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010533d:	8b 00                	mov    (%eax),%eax
8010533f:	39 c2                	cmp    %eax,%edx
80105341:	76 07                	jbe    8010534a <fetchint+0x2e>
    return -1;
80105343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105348:	eb 0f                	jmp    80105359 <fetchint+0x3d>
  *ip = *(int*)(addr);
8010534a:	8b 45 08             	mov    0x8(%ebp),%eax
8010534d:	8b 10                	mov    (%eax),%edx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	89 10                	mov    %edx,(%eax)
  return 0;
80105354:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105359:	c9                   	leave  
8010535a:	c3                   	ret    

8010535b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010535b:	55                   	push   %ebp
8010535c:	89 e5                	mov    %esp,%ebp
8010535e:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105361:	e8 b1 ee ff ff       	call   80104217 <myproc>
80105366:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536c:	8b 00                	mov    (%eax),%eax
8010536e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105371:	77 07                	ja     8010537a <fetchstr+0x1f>
    return -1;
80105373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105378:	eb 41                	jmp    801053bb <fetchstr+0x60>
  *pp = (char*)addr;
8010537a:	8b 55 08             	mov    0x8(%ebp),%edx
8010537d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105380:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105382:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105385:	8b 00                	mov    (%eax),%eax
80105387:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010538a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010538d:	8b 00                	mov    (%eax),%eax
8010538f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105392:	eb 1a                	jmp    801053ae <fetchstr+0x53>
    if(*s == 0)
80105394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105397:	8a 00                	mov    (%eax),%al
80105399:	84 c0                	test   %al,%al
8010539b:	75 0e                	jne    801053ab <fetchstr+0x50>
      return s - *pp;
8010539d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a3:	8b 00                	mov    (%eax),%eax
801053a5:	29 c2                	sub    %eax,%edx
801053a7:	89 d0                	mov    %edx,%eax
801053a9:	eb 10                	jmp    801053bb <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801053ab:	ff 45 f4             	incl   -0xc(%ebp)
801053ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801053b4:	72 de                	jb     80105394 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
801053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053bb:	c9                   	leave  
801053bc:	c3                   	ret    

801053bd <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053bd:	55                   	push   %ebp
801053be:	89 e5                	mov    %esp,%ebp
801053c0:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053c3:	e8 4f ee ff ff       	call   80104217 <myproc>
801053c8:	8b 40 18             	mov    0x18(%eax),%eax
801053cb:	8b 50 44             	mov    0x44(%eax),%edx
801053ce:	8b 45 08             	mov    0x8(%ebp),%eax
801053d1:	c1 e0 02             	shl    $0x2,%eax
801053d4:	01 d0                	add    %edx,%eax
801053d6:	8d 50 04             	lea    0x4(%eax),%edx
801053d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801053e0:	89 14 24             	mov    %edx,(%esp)
801053e3:	e8 34 ff ff ff       	call   8010531c <fetchint>
}
801053e8:	c9                   	leave  
801053e9:	c3                   	ret    

801053ea <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053ea:	55                   	push   %ebp
801053eb:	89 e5                	mov    %esp,%ebp
801053ed:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
801053f0:	e8 22 ee ff ff       	call   80104217 <myproc>
801053f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801053f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105402:	89 04 24             	mov    %eax,(%esp)
80105405:	e8 b3 ff ff ff       	call   801053bd <argint>
8010540a:	85 c0                	test   %eax,%eax
8010540c:	79 07                	jns    80105415 <argptr+0x2b>
    return -1;
8010540e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105413:	eb 3d                	jmp    80105452 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105415:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105419:	78 21                	js     8010543c <argptr+0x52>
8010541b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010541e:	89 c2                	mov    %eax,%edx
80105420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105423:	8b 00                	mov    (%eax),%eax
80105425:	39 c2                	cmp    %eax,%edx
80105427:	73 13                	jae    8010543c <argptr+0x52>
80105429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542c:	89 c2                	mov    %eax,%edx
8010542e:	8b 45 10             	mov    0x10(%ebp),%eax
80105431:	01 c2                	add    %eax,%edx
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	8b 00                	mov    (%eax),%eax
80105438:	39 c2                	cmp    %eax,%edx
8010543a:	76 07                	jbe    80105443 <argptr+0x59>
    return -1;
8010543c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105441:	eb 0f                	jmp    80105452 <argptr+0x68>
  *pp = (char*)i;
80105443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105446:	89 c2                	mov    %eax,%edx
80105448:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544b:	89 10                	mov    %edx,(%eax)
  return 0;
8010544d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105452:	c9                   	leave  
80105453:	c3                   	ret    

80105454 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010545a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105461:	8b 45 08             	mov    0x8(%ebp),%eax
80105464:	89 04 24             	mov    %eax,(%esp)
80105467:	e8 51 ff ff ff       	call   801053bd <argint>
8010546c:	85 c0                	test   %eax,%eax
8010546e:	79 07                	jns    80105477 <argstr+0x23>
    return -1;
80105470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105475:	eb 12                	jmp    80105489 <argstr+0x35>
  return fetchstr(addr, pp);
80105477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010547d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105481:	89 04 24             	mov    %eax,(%esp)
80105484:	e8 d2 fe ff ff       	call   8010535b <fetchstr>
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    

8010548b <syscall>:
[SYS_setuseddisk] sys_setuseddisk,
};

void
syscall(void)
{
8010548b:	55                   	push   %ebp
8010548c:	89 e5                	mov    %esp,%ebp
8010548e:	53                   	push   %ebx
8010548f:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105492:	e8 80 ed ff ff       	call   80104217 <myproc>
80105497:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010549a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549d:	8b 40 18             	mov    0x18(%eax),%eax
801054a0:	8b 40 1c             	mov    0x1c(%eax),%eax
801054a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054aa:	7e 2d                	jle    801054d9 <syscall+0x4e>
801054ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054af:	83 f8 21             	cmp    $0x21,%eax
801054b2:	77 25                	ja     801054d9 <syscall+0x4e>
801054b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b7:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801054be:	85 c0                	test   %eax,%eax
801054c0:	74 17                	je     801054d9 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
801054c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c5:	8b 58 18             	mov    0x18(%eax),%ebx
801054c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054cb:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801054d2:	ff d0                	call   *%eax
801054d4:	89 43 1c             	mov    %eax,0x1c(%ebx)
801054d7:	eb 34                	jmp    8010550d <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801054d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054dc:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e2:	8b 40 10             	mov    0x10(%eax),%eax
801054e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
801054ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f4:	c7 04 24 d0 8b 10 80 	movl   $0x80108bd0,(%esp)
801054fb:	e8 c1 ae ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105503:	8b 40 18             	mov    0x18(%eax),%eax
80105506:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010550d:	83 c4 24             	add    $0x24,%esp
80105510:	5b                   	pop    %ebx
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
	...

80105514 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010551a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010551d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105521:	8b 45 08             	mov    0x8(%ebp),%eax
80105524:	89 04 24             	mov    %eax,(%esp)
80105527:	e8 91 fe ff ff       	call   801053bd <argint>
8010552c:	85 c0                	test   %eax,%eax
8010552e:	79 07                	jns    80105537 <argfd+0x23>
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105535:	eb 4f                	jmp    80105586 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105537:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010553a:	85 c0                	test   %eax,%eax
8010553c:	78 20                	js     8010555e <argfd+0x4a>
8010553e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105541:	83 f8 0f             	cmp    $0xf,%eax
80105544:	7f 18                	jg     8010555e <argfd+0x4a>
80105546:	e8 cc ec ff ff       	call   80104217 <myproc>
8010554b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010554e:	83 c2 08             	add    $0x8,%edx
80105551:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105555:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010555c:	75 07                	jne    80105565 <argfd+0x51>
    return -1;
8010555e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105563:	eb 21                	jmp    80105586 <argfd+0x72>
  if(pfd)
80105565:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105569:	74 08                	je     80105573 <argfd+0x5f>
    *pfd = fd;
8010556b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105571:	89 10                	mov    %edx,(%eax)
  if(pf)
80105573:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105577:	74 08                	je     80105581 <argfd+0x6d>
    *pf = f;
80105579:	8b 45 10             	mov    0x10(%ebp),%eax
8010557c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010557f:	89 10                	mov    %edx,(%eax)
  return 0;
80105581:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105586:	c9                   	leave  
80105587:	c3                   	ret    

80105588 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105588:	55                   	push   %ebp
80105589:	89 e5                	mov    %esp,%ebp
8010558b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010558e:	e8 84 ec ff ff       	call   80104217 <myproc>
80105593:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010559d:	eb 29                	jmp    801055c8 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
8010559f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055a5:	83 c2 08             	add    $0x8,%edx
801055a8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801055ac:	85 c0                	test   %eax,%eax
801055ae:	75 15                	jne    801055c5 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801055b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055b6:	8d 4a 08             	lea    0x8(%edx),%ecx
801055b9:	8b 55 08             	mov    0x8(%ebp),%edx
801055bc:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801055c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c3:	eb 0e                	jmp    801055d3 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055c5:	ff 45 f4             	incl   -0xc(%ebp)
801055c8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055cc:	7e d1                	jle    8010559f <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801055ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d3:	c9                   	leave  
801055d4:	c3                   	ret    

801055d5 <sys_dup>:

int
sys_dup(void)
{
801055d5:	55                   	push   %ebp
801055d6:	89 e5                	mov    %esp,%ebp
801055d8:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801055db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055de:	89 44 24 08          	mov    %eax,0x8(%esp)
801055e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055e9:	00 
801055ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f1:	e8 1e ff ff ff       	call   80105514 <argfd>
801055f6:	85 c0                	test   %eax,%eax
801055f8:	79 07                	jns    80105601 <sys_dup+0x2c>
    return -1;
801055fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ff:	eb 29                	jmp    8010562a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105601:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105604:	89 04 24             	mov    %eax,(%esp)
80105607:	e8 7c ff ff ff       	call   80105588 <fdalloc>
8010560c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010560f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105613:	79 07                	jns    8010561c <sys_dup+0x47>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561a:	eb 0e                	jmp    8010562a <sys_dup+0x55>
  filedup(f);
8010561c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010561f:	89 04 24             	mov    %eax,(%esp)
80105622:	e8 9d ba ff ff       	call   801010c4 <filedup>
  return fd;
80105627:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010562a:	c9                   	leave  
8010562b:	c3                   	ret    

8010562c <sys_read>:

int
sys_read(void)
{
8010562c:	55                   	push   %ebp
8010562d:	89 e5                	mov    %esp,%ebp
8010562f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105632:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105635:	89 44 24 08          	mov    %eax,0x8(%esp)
80105639:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105640:	00 
80105641:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105648:	e8 c7 fe ff ff       	call   80105514 <argfd>
8010564d:	85 c0                	test   %eax,%eax
8010564f:	78 35                	js     80105686 <sys_read+0x5a>
80105651:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105654:	89 44 24 04          	mov    %eax,0x4(%esp)
80105658:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010565f:	e8 59 fd ff ff       	call   801053bd <argint>
80105664:	85 c0                	test   %eax,%eax
80105666:	78 1e                	js     80105686 <sys_read+0x5a>
80105668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010566f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105672:	89 44 24 04          	mov    %eax,0x4(%esp)
80105676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010567d:	e8 68 fd ff ff       	call   801053ea <argptr>
80105682:	85 c0                	test   %eax,%eax
80105684:	79 07                	jns    8010568d <sys_read+0x61>
    return -1;
80105686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568b:	eb 19                	jmp    801056a6 <sys_read+0x7a>
  return fileread(f, p, n);
8010568d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105690:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105696:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010569a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010569e:	89 04 24             	mov    %eax,(%esp)
801056a1:	e8 7f bb ff ff       	call   80101225 <fileread>
}
801056a6:	c9                   	leave  
801056a7:	c3                   	ret    

801056a8 <sys_write>:

int
sys_write(void)
{
801056a8:	55                   	push   %ebp
801056a9:	89 e5                	mov    %esp,%ebp
801056ab:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801056b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056bc:	00 
801056bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056c4:	e8 4b fe ff ff       	call   80105514 <argfd>
801056c9:	85 c0                	test   %eax,%eax
801056cb:	78 35                	js     80105702 <sys_write+0x5a>
801056cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801056d4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056db:	e8 dd fc ff ff       	call   801053bd <argint>
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 1e                	js     80105702 <sys_write+0x5a>
801056e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e7:	89 44 24 08          	mov    %eax,0x8(%esp)
801056eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056f9:	e8 ec fc ff ff       	call   801053ea <argptr>
801056fe:	85 c0                	test   %eax,%eax
80105700:	79 07                	jns    80105709 <sys_write+0x61>
    return -1;
80105702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105707:	eb 19                	jmp    80105722 <sys_write+0x7a>
  return filewrite(f, p, n);
80105709:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010570c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105712:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105716:	89 54 24 04          	mov    %edx,0x4(%esp)
8010571a:	89 04 24             	mov    %eax,(%esp)
8010571d:	e8 be bb ff ff       	call   801012e0 <filewrite>
}
80105722:	c9                   	leave  
80105723:	c3                   	ret    

80105724 <sys_close>:

int
sys_close(void)
{
80105724:	55                   	push   %ebp
80105725:	89 e5                	mov    %esp,%ebp
80105727:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010572a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010572d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105731:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105734:	89 44 24 04          	mov    %eax,0x4(%esp)
80105738:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010573f:	e8 d0 fd ff ff       	call   80105514 <argfd>
80105744:	85 c0                	test   %eax,%eax
80105746:	79 07                	jns    8010574f <sys_close+0x2b>
    return -1;
80105748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574d:	eb 23                	jmp    80105772 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
8010574f:	e8 c3 ea ff ff       	call   80104217 <myproc>
80105754:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105757:	83 c2 08             	add    $0x8,%edx
8010575a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105761:	00 
  fileclose(f);
80105762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105765:	89 04 24             	mov    %eax,(%esp)
80105768:	e8 9f b9 ff ff       	call   8010110c <fileclose>
  return 0;
8010576d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105772:	c9                   	leave  
80105773:	c3                   	ret    

80105774 <sys_fstat>:

int
sys_fstat(void)
{
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010577a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105781:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105788:	00 
80105789:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105790:	e8 7f fd ff ff       	call   80105514 <argfd>
80105795:	85 c0                	test   %eax,%eax
80105797:	78 1f                	js     801057b8 <sys_fstat+0x44>
80105799:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801057a0:	00 
801057a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057af:	e8 36 fc ff ff       	call   801053ea <argptr>
801057b4:	85 c0                	test   %eax,%eax
801057b6:	79 07                	jns    801057bf <sys_fstat+0x4b>
    return -1;
801057b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bd:	eb 12                	jmp    801057d1 <sys_fstat+0x5d>
  return filestat(f, st);
801057bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801057c9:	89 04 24             	mov    %eax,(%esp)
801057cc:	e8 05 ba ff ff       	call   801011d6 <filestat>
}
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    

801057d3 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801057d3:	55                   	push   %ebp
801057d4:	89 e5                	mov    %esp,%ebp
801057d6:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057d9:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057e7:	e8 68 fc ff ff       	call   80105454 <argstr>
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 17                	js     80105807 <sys_link+0x34>
801057f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
801057f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801057f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057fe:	e8 51 fc ff ff       	call   80105454 <argstr>
80105803:	85 c0                	test   %eax,%eax
80105805:	79 0a                	jns    80105811 <sys_link+0x3e>
    return -1;
80105807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580c:	e9 3d 01 00 00       	jmp    8010594e <sys_link+0x17b>

  begin_op();
80105811:	e8 09 dd ff ff       	call   8010351f <begin_op>
  if((ip = namei(old)) == 0){
80105816:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105819:	89 04 24             	mov    %eax,(%esp)
8010581c:	e8 2a cd ff ff       	call   8010254b <namei>
80105821:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105828:	75 0f                	jne    80105839 <sys_link+0x66>
    end_op();
8010582a:	e8 72 dd ff ff       	call   801035a1 <end_op>
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105834:	e9 15 01 00 00       	jmp    8010594e <sys_link+0x17b>
  }

  ilock(ip);
80105839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583c:	89 04 24             	mov    %eax,(%esp)
8010583f:	e8 e2 c1 ff ff       	call   80101a26 <ilock>
  if(ip->type == T_DIR){
80105844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105847:	8b 40 50             	mov    0x50(%eax),%eax
8010584a:	66 83 f8 01          	cmp    $0x1,%ax
8010584e:	75 1a                	jne    8010586a <sys_link+0x97>
    iunlockput(ip);
80105850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105853:	89 04 24             	mov    %eax,(%esp)
80105856:	e8 ca c3 ff ff       	call   80101c25 <iunlockput>
    end_op();
8010585b:	e8 41 dd ff ff       	call   801035a1 <end_op>
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	e9 e4 00 00 00       	jmp    8010594e <sys_link+0x17b>
  }

  ip->nlink++;
8010586a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586d:	66 8b 40 56          	mov    0x56(%eax),%ax
80105871:	40                   	inc    %eax
80105872:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105875:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010587c:	89 04 24             	mov    %eax,(%esp)
8010587f:	e8 df bf ff ff       	call   80101863 <iupdate>
  iunlock(ip);
80105884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105887:	89 04 24             	mov    %eax,(%esp)
8010588a:	e8 a1 c2 ff ff       	call   80101b30 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010588f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105892:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105895:	89 54 24 04          	mov    %edx,0x4(%esp)
80105899:	89 04 24             	mov    %eax,(%esp)
8010589c:	e8 cc cc ff ff       	call   8010256d <nameiparent>
801058a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058a8:	75 02                	jne    801058ac <sys_link+0xd9>
    goto bad;
801058aa:	eb 68                	jmp    80105914 <sys_link+0x141>
  ilock(dp);
801058ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058af:	89 04 24             	mov    %eax,(%esp)
801058b2:	e8 6f c1 ff ff       	call   80101a26 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ba:	8b 10                	mov    (%eax),%edx
801058bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058bf:	8b 00                	mov    (%eax),%eax
801058c1:	39 c2                	cmp    %eax,%edx
801058c3:	75 20                	jne    801058e5 <sys_link+0x112>
801058c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c8:	8b 40 04             	mov    0x4(%eax),%eax
801058cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801058cf:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801058d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d9:	89 04 24             	mov    %eax,(%esp)
801058dc:	e8 b7 c9 ff ff       	call   80102298 <dirlink>
801058e1:	85 c0                	test   %eax,%eax
801058e3:	79 0d                	jns    801058f2 <sys_link+0x11f>
    iunlockput(dp);
801058e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e8:	89 04 24             	mov    %eax,(%esp)
801058eb:	e8 35 c3 ff ff       	call   80101c25 <iunlockput>
    goto bad;
801058f0:	eb 22                	jmp    80105914 <sys_link+0x141>
  }
  iunlockput(dp);
801058f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f5:	89 04 24             	mov    %eax,(%esp)
801058f8:	e8 28 c3 ff ff       	call   80101c25 <iunlockput>
  iput(ip);
801058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105900:	89 04 24             	mov    %eax,(%esp)
80105903:	e8 6c c2 ff ff       	call   80101b74 <iput>

  end_op();
80105908:	e8 94 dc ff ff       	call   801035a1 <end_op>

  return 0;
8010590d:	b8 00 00 00 00       	mov    $0x0,%eax
80105912:	eb 3a                	jmp    8010594e <sys_link+0x17b>

bad:
  ilock(ip);
80105914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105917:	89 04 24             	mov    %eax,(%esp)
8010591a:	e8 07 c1 ff ff       	call   80101a26 <ilock>
  ip->nlink--;
8010591f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105922:	66 8b 40 56          	mov    0x56(%eax),%ax
80105926:	48                   	dec    %eax
80105927:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010592a:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
8010592e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105931:	89 04 24             	mov    %eax,(%esp)
80105934:	e8 2a bf ff ff       	call   80101863 <iupdate>
  iunlockput(ip);
80105939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593c:	89 04 24             	mov    %eax,(%esp)
8010593f:	e8 e1 c2 ff ff       	call   80101c25 <iunlockput>
  end_op();
80105944:	e8 58 dc ff ff       	call   801035a1 <end_op>
  return -1;
80105949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010594e:	c9                   	leave  
8010594f:	c3                   	ret    

80105950 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105956:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010595d:	eb 4a                	jmp    801059a9 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010595f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105962:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105969:	00 
8010596a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010596e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105971:	89 44 24 04          	mov    %eax,0x4(%esp)
80105975:	8b 45 08             	mov    0x8(%ebp),%eax
80105978:	89 04 24             	mov    %eax,(%esp)
8010597b:	e8 3d c5 ff ff       	call   80101ebd <readi>
80105980:	83 f8 10             	cmp    $0x10,%eax
80105983:	74 0c                	je     80105991 <isdirempty+0x41>
      panic("isdirempty: readi");
80105985:	c7 04 24 ec 8b 10 80 	movl   $0x80108bec,(%esp)
8010598c:	e8 c3 ab ff ff       	call   80100554 <panic>
    if(de.inum != 0)
80105991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105994:	66 85 c0             	test   %ax,%ax
80105997:	74 07                	je     801059a0 <isdirempty+0x50>
      return 0;
80105999:	b8 00 00 00 00       	mov    $0x0,%eax
8010599e:	eb 1b                	jmp    801059bb <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a3:	83 c0 10             	add    $0x10,%eax
801059a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ac:	8b 45 08             	mov    0x8(%ebp),%eax
801059af:	8b 40 58             	mov    0x58(%eax),%eax
801059b2:	39 c2                	cmp    %eax,%edx
801059b4:	72 a9                	jb     8010595f <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801059b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801059bb:	c9                   	leave  
801059bc:	c3                   	ret    

801059bd <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801059bd:	55                   	push   %ebp
801059be:	89 e5                	mov    %esp,%ebp
801059c0:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801059c3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801059c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059d1:	e8 7e fa ff ff       	call   80105454 <argstr>
801059d6:	85 c0                	test   %eax,%eax
801059d8:	79 0a                	jns    801059e4 <sys_unlink+0x27>
    return -1;
801059da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059df:	e9 a9 01 00 00       	jmp    80105b8d <sys_unlink+0x1d0>

  begin_op();
801059e4:	e8 36 db ff ff       	call   8010351f <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801059ec:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801059ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801059f3:	89 04 24             	mov    %eax,(%esp)
801059f6:	e8 72 cb ff ff       	call   8010256d <nameiparent>
801059fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a02:	75 0f                	jne    80105a13 <sys_unlink+0x56>
    end_op();
80105a04:	e8 98 db ff ff       	call   801035a1 <end_op>
    return -1;
80105a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0e:	e9 7a 01 00 00       	jmp    80105b8d <sys_unlink+0x1d0>
  }

  ilock(dp);
80105a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a16:	89 04 24             	mov    %eax,(%esp)
80105a19:	e8 08 c0 ff ff       	call   80101a26 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a1e:	c7 44 24 04 fe 8b 10 	movl   $0x80108bfe,0x4(%esp)
80105a25:	80 
80105a26:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a29:	89 04 24             	mov    %eax,(%esp)
80105a2c:	e8 7f c7 ff ff       	call   801021b0 <namecmp>
80105a31:	85 c0                	test   %eax,%eax
80105a33:	0f 84 3f 01 00 00    	je     80105b78 <sys_unlink+0x1bb>
80105a39:	c7 44 24 04 00 8c 10 	movl   $0x80108c00,0x4(%esp)
80105a40:	80 
80105a41:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a44:	89 04 24             	mov    %eax,(%esp)
80105a47:	e8 64 c7 ff ff       	call   801021b0 <namecmp>
80105a4c:	85 c0                	test   %eax,%eax
80105a4e:	0f 84 24 01 00 00    	je     80105b78 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105a54:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105a57:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a5b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a65:	89 04 24             	mov    %eax,(%esp)
80105a68:	e8 65 c7 ff ff       	call   801021d2 <dirlookup>
80105a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a74:	75 05                	jne    80105a7b <sys_unlink+0xbe>
    goto bad;
80105a76:	e9 fd 00 00 00       	jmp    80105b78 <sys_unlink+0x1bb>
  ilock(ip);
80105a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a7e:	89 04 24             	mov    %eax,(%esp)
80105a81:	e8 a0 bf ff ff       	call   80101a26 <ilock>

  if(ip->nlink < 1)
80105a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a89:	66 8b 40 56          	mov    0x56(%eax),%ax
80105a8d:	66 85 c0             	test   %ax,%ax
80105a90:	7f 0c                	jg     80105a9e <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105a92:	c7 04 24 03 8c 10 80 	movl   $0x80108c03,(%esp)
80105a99:	e8 b6 aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa1:	8b 40 50             	mov    0x50(%eax),%eax
80105aa4:	66 83 f8 01          	cmp    $0x1,%ax
80105aa8:	75 1f                	jne    80105ac9 <sys_unlink+0x10c>
80105aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aad:	89 04 24             	mov    %eax,(%esp)
80105ab0:	e8 9b fe ff ff       	call   80105950 <isdirempty>
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	75 10                	jne    80105ac9 <sys_unlink+0x10c>
    iunlockput(ip);
80105ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abc:	89 04 24             	mov    %eax,(%esp)
80105abf:	e8 61 c1 ff ff       	call   80101c25 <iunlockput>
    goto bad;
80105ac4:	e9 af 00 00 00       	jmp    80105b78 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105ac9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105ad0:	00 
80105ad1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ad8:	00 
80105ad9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105adc:	89 04 24             	mov    %eax,(%esp)
80105adf:	e8 a6 f5 ff ff       	call   8010508a <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ae4:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105ae7:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105aee:	00 
80105aef:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105af6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afd:	89 04 24             	mov    %eax,(%esp)
80105b00:	e8 1c c5 ff ff       	call   80102021 <writei>
80105b05:	83 f8 10             	cmp    $0x10,%eax
80105b08:	74 0c                	je     80105b16 <sys_unlink+0x159>
    panic("unlink: writei");
80105b0a:	c7 04 24 15 8c 10 80 	movl   $0x80108c15,(%esp)
80105b11:	e8 3e aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b19:	8b 40 50             	mov    0x50(%eax),%eax
80105b1c:	66 83 f8 01          	cmp    $0x1,%ax
80105b20:	75 1a                	jne    80105b3c <sys_unlink+0x17f>
    dp->nlink--;
80105b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b25:	66 8b 40 56          	mov    0x56(%eax),%ax
80105b29:	48                   	dec    %eax
80105b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b2d:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b34:	89 04 24             	mov    %eax,(%esp)
80105b37:	e8 27 bd ff ff       	call   80101863 <iupdate>
  }
  iunlockput(dp);
80105b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3f:	89 04 24             	mov    %eax,(%esp)
80105b42:	e8 de c0 ff ff       	call   80101c25 <iunlockput>

  ip->nlink--;
80105b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4a:	66 8b 40 56          	mov    0x56(%eax),%ax
80105b4e:	48                   	dec    %eax
80105b4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b52:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b59:	89 04 24             	mov    %eax,(%esp)
80105b5c:	e8 02 bd ff ff       	call   80101863 <iupdate>
  iunlockput(ip);
80105b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b64:	89 04 24             	mov    %eax,(%esp)
80105b67:	e8 b9 c0 ff ff       	call   80101c25 <iunlockput>

  end_op();
80105b6c:	e8 30 da ff ff       	call   801035a1 <end_op>

  return 0;
80105b71:	b8 00 00 00 00       	mov    $0x0,%eax
80105b76:	eb 15                	jmp    80105b8d <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7b:	89 04 24             	mov    %eax,(%esp)
80105b7e:	e8 a2 c0 ff ff       	call   80101c25 <iunlockput>
  end_op();
80105b83:	e8 19 da ff ff       	call   801035a1 <end_op>
  return -1;
80105b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b8d:	c9                   	leave  
80105b8e:	c3                   	ret    

80105b8f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b8f:	55                   	push   %ebp
80105b90:	89 e5                	mov    %esp,%ebp
80105b92:	83 ec 48             	sub    $0x48,%esp
80105b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105b98:	8b 55 10             	mov    0x10(%ebp),%edx
80105b9b:	8b 45 14             	mov    0x14(%ebp),%eax
80105b9e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ba2:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ba6:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105baa:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bad:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb4:	89 04 24             	mov    %eax,(%esp)
80105bb7:	e8 b1 c9 ff ff       	call   8010256d <nameiparent>
80105bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bc3:	75 0a                	jne    80105bcf <create+0x40>
    return 0;
80105bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80105bca:	e9 79 01 00 00       	jmp    80105d48 <create+0x1b9>
  ilock(dp);
80105bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd2:	89 04 24             	mov    %eax,(%esp)
80105bd5:	e8 4c be ff ff       	call   80101a26 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105bda:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105be1:	8d 45 de             	lea    -0x22(%ebp),%eax
80105be4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105beb:	89 04 24             	mov    %eax,(%esp)
80105bee:	e8 df c5 ff ff       	call   801021d2 <dirlookup>
80105bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bfa:	74 46                	je     80105c42 <create+0xb3>
    iunlockput(dp);
80105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bff:	89 04 24             	mov    %eax,(%esp)
80105c02:	e8 1e c0 ff ff       	call   80101c25 <iunlockput>
    ilock(ip);
80105c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0a:	89 04 24             	mov    %eax,(%esp)
80105c0d:	e8 14 be ff ff       	call   80101a26 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c12:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c17:	75 14                	jne    80105c2d <create+0x9e>
80105c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1c:	8b 40 50             	mov    0x50(%eax),%eax
80105c1f:	66 83 f8 02          	cmp    $0x2,%ax
80105c23:	75 08                	jne    80105c2d <create+0x9e>
      return ip;
80105c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c28:	e9 1b 01 00 00       	jmp    80105d48 <create+0x1b9>
    iunlockput(ip);
80105c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c30:	89 04 24             	mov    %eax,(%esp)
80105c33:	e8 ed bf ff ff       	call   80101c25 <iunlockput>
    return 0;
80105c38:	b8 00 00 00 00       	mov    $0x0,%eax
80105c3d:	e9 06 01 00 00       	jmp    80105d48 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105c42:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c49:	8b 00                	mov    (%eax),%eax
80105c4b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c4f:	89 04 24             	mov    %eax,(%esp)
80105c52:	e8 3a bb ff ff       	call   80101791 <ialloc>
80105c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c5e:	75 0c                	jne    80105c6c <create+0xdd>
    panic("create: ialloc");
80105c60:	c7 04 24 24 8c 10 80 	movl   $0x80108c24,(%esp)
80105c67:	e8 e8 a8 ff ff       	call   80100554 <panic>

  ilock(ip);
80105c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6f:	89 04 24             	mov    %eax,(%esp)
80105c72:	e8 af bd ff ff       	call   80101a26 <ilock>
  ip->major = major;
80105c77:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c7d:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c84:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c87:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8e:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c97:	89 04 24             	mov    %eax,(%esp)
80105c9a:	e8 c4 bb ff ff       	call   80101863 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105c9f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105ca4:	75 68                	jne    80105d0e <create+0x17f>
    dp->nlink++;  // for ".."
80105ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca9:	66 8b 40 56          	mov    0x56(%eax),%ax
80105cad:	40                   	inc    %eax
80105cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cb1:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb8:	89 04 24             	mov    %eax,(%esp)
80105cbb:	e8 a3 bb ff ff       	call   80101863 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc3:	8b 40 04             	mov    0x4(%eax),%eax
80105cc6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cca:	c7 44 24 04 fe 8b 10 	movl   $0x80108bfe,0x4(%esp)
80105cd1:	80 
80105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd5:	89 04 24             	mov    %eax,(%esp)
80105cd8:	e8 bb c5 ff ff       	call   80102298 <dirlink>
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	78 21                	js     80105d02 <create+0x173>
80105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce4:	8b 40 04             	mov    0x4(%eax),%eax
80105ce7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ceb:	c7 44 24 04 00 8c 10 	movl   $0x80108c00,0x4(%esp)
80105cf2:	80 
80105cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf6:	89 04 24             	mov    %eax,(%esp)
80105cf9:	e8 9a c5 ff ff       	call   80102298 <dirlink>
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	79 0c                	jns    80105d0e <create+0x17f>
      panic("create dots");
80105d02:	c7 04 24 33 8c 10 80 	movl   $0x80108c33,(%esp)
80105d09:	e8 46 a8 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d11:	8b 40 04             	mov    0x4(%eax),%eax
80105d14:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d18:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d22:	89 04 24             	mov    %eax,(%esp)
80105d25:	e8 6e c5 ff ff       	call   80102298 <dirlink>
80105d2a:	85 c0                	test   %eax,%eax
80105d2c:	79 0c                	jns    80105d3a <create+0x1ab>
    panic("create: dirlink");
80105d2e:	c7 04 24 3f 8c 10 80 	movl   $0x80108c3f,(%esp)
80105d35:	e8 1a a8 ff ff       	call   80100554 <panic>

  iunlockput(dp);
80105d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3d:	89 04 24             	mov    %eax,(%esp)
80105d40:	e8 e0 be ff ff       	call   80101c25 <iunlockput>

  return ip;
80105d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105d48:	c9                   	leave  
80105d49:	c3                   	ret    

80105d4a <sys_open>:

int
sys_open(void)
{
80105d4a:	55                   	push   %ebp
80105d4b:	89 e5                	mov    %esp,%ebp
80105d4d:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d50:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d5e:	e8 f1 f6 ff ff       	call   80105454 <argstr>
80105d63:	85 c0                	test   %eax,%eax
80105d65:	78 17                	js     80105d7e <sys_open+0x34>
80105d67:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d75:	e8 43 f6 ff ff       	call   801053bd <argint>
80105d7a:	85 c0                	test   %eax,%eax
80105d7c:	79 0a                	jns    80105d88 <sys_open+0x3e>
    return -1;
80105d7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d83:	e9 5b 01 00 00       	jmp    80105ee3 <sys_open+0x199>

  begin_op();
80105d88:	e8 92 d7 ff ff       	call   8010351f <begin_op>

  if(omode & O_CREATE){
80105d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d90:	25 00 02 00 00       	and    $0x200,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 3b                	je     80105dd4 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d9c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105da3:	00 
80105da4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105dab:	00 
80105dac:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105db3:	00 
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 d3 fd ff ff       	call   80105b8f <create>
80105dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc3:	75 6a                	jne    80105e2f <sys_open+0xe5>
      end_op();
80105dc5:	e8 d7 d7 ff ff       	call   801035a1 <end_op>
      return -1;
80105dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dcf:	e9 0f 01 00 00       	jmp    80105ee3 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105dd7:	89 04 24             	mov    %eax,(%esp)
80105dda:	e8 6c c7 ff ff       	call   8010254b <namei>
80105ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105de6:	75 0f                	jne    80105df7 <sys_open+0xad>
      end_op();
80105de8:	e8 b4 d7 ff ff       	call   801035a1 <end_op>
      return -1;
80105ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df2:	e9 ec 00 00 00       	jmp    80105ee3 <sys_open+0x199>
    }
    ilock(ip);
80105df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfa:	89 04 24             	mov    %eax,(%esp)
80105dfd:	e8 24 bc ff ff       	call   80101a26 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e05:	8b 40 50             	mov    0x50(%eax),%eax
80105e08:	66 83 f8 01          	cmp    $0x1,%ax
80105e0c:	75 21                	jne    80105e2f <sys_open+0xe5>
80105e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e11:	85 c0                	test   %eax,%eax
80105e13:	74 1a                	je     80105e2f <sys_open+0xe5>
      iunlockput(ip);
80105e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e18:	89 04 24             	mov    %eax,(%esp)
80105e1b:	e8 05 be ff ff       	call   80101c25 <iunlockput>
      end_op();
80105e20:	e8 7c d7 ff ff       	call   801035a1 <end_op>
      return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2a:	e9 b4 00 00 00       	jmp    80105ee3 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e2f:	e8 30 b2 ff ff       	call   80101064 <filealloc>
80105e34:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e3b:	74 14                	je     80105e51 <sys_open+0x107>
80105e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e40:	89 04 24             	mov    %eax,(%esp)
80105e43:	e8 40 f7 ff ff       	call   80105588 <fdalloc>
80105e48:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105e4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105e4f:	79 28                	jns    80105e79 <sys_open+0x12f>
    if(f)
80105e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e55:	74 0b                	je     80105e62 <sys_open+0x118>
      fileclose(f);
80105e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5a:	89 04 24             	mov    %eax,(%esp)
80105e5d:	e8 aa b2 ff ff       	call   8010110c <fileclose>
    iunlockput(ip);
80105e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e65:	89 04 24             	mov    %eax,(%esp)
80105e68:	e8 b8 bd ff ff       	call   80101c25 <iunlockput>
    end_op();
80105e6d:	e8 2f d7 ff ff       	call   801035a1 <end_op>
    return -1;
80105e72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e77:	eb 6a                	jmp    80105ee3 <sys_open+0x199>
  }
  iunlock(ip);
80105e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7c:	89 04 24             	mov    %eax,(%esp)
80105e7f:	e8 ac bc ff ff       	call   80101b30 <iunlock>
  end_op();
80105e84:	e8 18 d7 ff ff       	call   801035a1 <end_op>

  f->type = FD_INODE;
80105e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e98:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ea8:	83 e0 01             	and    $0x1,%eax
80105eab:	85 c0                	test   %eax,%eax
80105ead:	0f 94 c0             	sete   %al
80105eb0:	88 c2                	mov    %al,%dl
80105eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb5:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ebb:	83 e0 01             	and    $0x1,%eax
80105ebe:	85 c0                	test   %eax,%eax
80105ec0:	75 0a                	jne    80105ecc <sys_open+0x182>
80105ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ec5:	83 e0 02             	and    $0x2,%eax
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	74 07                	je     80105ed3 <sys_open+0x189>
80105ecc:	b8 01 00 00 00       	mov    $0x1,%eax
80105ed1:	eb 05                	jmp    80105ed8 <sys_open+0x18e>
80105ed3:	b8 00 00 00 00       	mov    $0x0,%eax
80105ed8:	88 c2                	mov    %al,%dl
80105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edd:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105ee3:	c9                   	leave  
80105ee4:	c3                   	ret    

80105ee5 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ee5:	55                   	push   %ebp
80105ee6:	89 e5                	mov    %esp,%ebp
80105ee8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105eeb:	e8 2f d6 ff ff       	call   8010351f <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ef0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105efe:	e8 51 f5 ff ff       	call   80105454 <argstr>
80105f03:	85 c0                	test   %eax,%eax
80105f05:	78 2c                	js     80105f33 <sys_mkdir+0x4e>
80105f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f11:	00 
80105f12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f19:	00 
80105f1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105f21:	00 
80105f22:	89 04 24             	mov    %eax,(%esp)
80105f25:	e8 65 fc ff ff       	call   80105b8f <create>
80105f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f31:	75 0c                	jne    80105f3f <sys_mkdir+0x5a>
    end_op();
80105f33:	e8 69 d6 ff ff       	call   801035a1 <end_op>
    return -1;
80105f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3d:	eb 15                	jmp    80105f54 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f42:	89 04 24             	mov    %eax,(%esp)
80105f45:	e8 db bc ff ff       	call   80101c25 <iunlockput>
  end_op();
80105f4a:	e8 52 d6 ff ff       	call   801035a1 <end_op>
  return 0;
80105f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f54:	c9                   	leave  
80105f55:	c3                   	ret    

80105f56 <sys_mknod>:

int
sys_mknod(void)
{
80105f56:	55                   	push   %ebp
80105f57:	89 e5                	mov    %esp,%ebp
80105f59:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f5c:	e8 be d5 ff ff       	call   8010351f <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f61:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f64:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f6f:	e8 e0 f4 ff ff       	call   80105454 <argstr>
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 5e                	js     80105fd6 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f78:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f86:	e8 32 f4 ff ff       	call   801053bd <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105f8b:	85 c0                	test   %eax,%eax
80105f8d:	78 47                	js     80105fd6 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f8f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f92:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f96:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f9d:	e8 1b f4 ff ff       	call   801053bd <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105fa2:	85 c0                	test   %eax,%eax
80105fa4:	78 30                	js     80105fd6 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fa9:	0f bf c8             	movswl %ax,%ecx
80105fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105faf:	0f bf d0             	movswl %ax,%edx
80105fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105fb5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105fb9:	89 54 24 08          	mov    %edx,0x8(%esp)
80105fbd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105fc4:	00 
80105fc5:	89 04 24             	mov    %eax,(%esp)
80105fc8:	e8 c2 fb ff ff       	call   80105b8f <create>
80105fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fd4:	75 0c                	jne    80105fe2 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105fd6:	e8 c6 d5 ff ff       	call   801035a1 <end_op>
    return -1;
80105fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe0:	eb 15                	jmp    80105ff7 <sys_mknod+0xa1>
  }
  iunlockput(ip);
80105fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe5:	89 04 24             	mov    %eax,(%esp)
80105fe8:	e8 38 bc ff ff       	call   80101c25 <iunlockput>
  end_op();
80105fed:	e8 af d5 ff ff       	call   801035a1 <end_op>
  return 0;
80105ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ff7:	c9                   	leave  
80105ff8:	c3                   	ret    

80105ff9 <sys_chdir>:

int
sys_chdir(void)
{
80105ff9:	55                   	push   %ebp
80105ffa:	89 e5                	mov    %esp,%ebp
80105ffc:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fff:	e8 13 e2 ff ff       	call   80104217 <myproc>
80106004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106007:	e8 13 d5 ff ff       	call   8010351f <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010600c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010600f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106013:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010601a:	e8 35 f4 ff ff       	call   80105454 <argstr>
8010601f:	85 c0                	test   %eax,%eax
80106021:	78 14                	js     80106037 <sys_chdir+0x3e>
80106023:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106026:	89 04 24             	mov    %eax,(%esp)
80106029:	e8 1d c5 ff ff       	call   8010254b <namei>
8010602e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106035:	75 0c                	jne    80106043 <sys_chdir+0x4a>
    end_op();
80106037:	e8 65 d5 ff ff       	call   801035a1 <end_op>
    return -1;
8010603c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106041:	eb 5a                	jmp    8010609d <sys_chdir+0xa4>
  }
  ilock(ip);
80106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106046:	89 04 24             	mov    %eax,(%esp)
80106049:	e8 d8 b9 ff ff       	call   80101a26 <ilock>
  if(ip->type != T_DIR){
8010604e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106051:	8b 40 50             	mov    0x50(%eax),%eax
80106054:	66 83 f8 01          	cmp    $0x1,%ax
80106058:	74 17                	je     80106071 <sys_chdir+0x78>
    iunlockput(ip);
8010605a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605d:	89 04 24             	mov    %eax,(%esp)
80106060:	e8 c0 bb ff ff       	call   80101c25 <iunlockput>
    end_op();
80106065:	e8 37 d5 ff ff       	call   801035a1 <end_op>
    return -1;
8010606a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606f:	eb 2c                	jmp    8010609d <sys_chdir+0xa4>
  }
  iunlock(ip);
80106071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106074:	89 04 24             	mov    %eax,(%esp)
80106077:	e8 b4 ba ff ff       	call   80101b30 <iunlock>
  iput(curproc->cwd);
8010607c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607f:	8b 40 68             	mov    0x68(%eax),%eax
80106082:	89 04 24             	mov    %eax,(%esp)
80106085:	e8 ea ba ff ff       	call   80101b74 <iput>
  end_op();
8010608a:	e8 12 d5 ff ff       	call   801035a1 <end_op>
  curproc->cwd = ip;
8010608f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106092:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106095:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106098:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010609d:	c9                   	leave  
8010609e:	c3                   	ret    

8010609f <sys_exec>:

int
sys_exec(void)
{
8010609f:	55                   	push   %ebp
801060a0:	89 e5                	mov    %esp,%ebp
801060a2:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801060af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b6:	e8 99 f3 ff ff       	call   80105454 <argstr>
801060bb:	85 c0                	test   %eax,%eax
801060bd:	78 1a                	js     801060d9 <sys_exec+0x3a>
801060bf:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801060c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060d0:	e8 e8 f2 ff ff       	call   801053bd <argint>
801060d5:	85 c0                	test   %eax,%eax
801060d7:	79 0a                	jns    801060e3 <sys_exec+0x44>
    return -1;
801060d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060de:	e9 c7 00 00 00       	jmp    801061aa <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
801060e3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801060ea:	00 
801060eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060f2:	00 
801060f3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801060f9:	89 04 24             	mov    %eax,(%esp)
801060fc:	e8 89 ef ff ff       	call   8010508a <memset>
  for(i=0;; i++){
80106101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010610b:	83 f8 1f             	cmp    $0x1f,%eax
8010610e:	76 0a                	jbe    8010611a <sys_exec+0x7b>
      return -1;
80106110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106115:	e9 90 00 00 00       	jmp    801061aa <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010611a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611d:	c1 e0 02             	shl    $0x2,%eax
80106120:	89 c2                	mov    %eax,%edx
80106122:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106128:	01 c2                	add    %eax,%edx
8010612a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106130:	89 44 24 04          	mov    %eax,0x4(%esp)
80106134:	89 14 24             	mov    %edx,(%esp)
80106137:	e8 e0 f1 ff ff       	call   8010531c <fetchint>
8010613c:	85 c0                	test   %eax,%eax
8010613e:	79 07                	jns    80106147 <sys_exec+0xa8>
      return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106145:	eb 63                	jmp    801061aa <sys_exec+0x10b>
    if(uarg == 0){
80106147:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010614d:	85 c0                	test   %eax,%eax
8010614f:	75 26                	jne    80106177 <sys_exec+0xd8>
      argv[i] = 0;
80106151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106154:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010615b:	00 00 00 00 
      break;
8010615f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106160:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106163:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106169:	89 54 24 04          	mov    %edx,0x4(%esp)
8010616d:	89 04 24             	mov    %eax,(%esp)
80106170:	e8 93 aa ff ff       	call   80100c08 <exec>
80106175:	eb 33                	jmp    801061aa <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106177:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010617d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106180:	c1 e2 02             	shl    $0x2,%edx
80106183:	01 c2                	add    %eax,%edx
80106185:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010618b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010618f:	89 04 24             	mov    %eax,(%esp)
80106192:	e8 c4 f1 ff ff       	call   8010535b <fetchstr>
80106197:	85 c0                	test   %eax,%eax
80106199:	79 07                	jns    801061a2 <sys_exec+0x103>
      return -1;
8010619b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a0:	eb 08                	jmp    801061aa <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801061a2:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801061a5:	e9 5e ff ff ff       	jmp    80106108 <sys_exec+0x69>
  return exec(path, argv);
}
801061aa:	c9                   	leave  
801061ab:	c3                   	ret    

801061ac <sys_pipe>:

int
sys_pipe(void)
{
801061ac:	55                   	push   %ebp
801061ad:	89 e5                	mov    %esp,%ebp
801061af:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061b2:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801061b9:	00 
801061ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061c8:	e8 1d f2 ff ff       	call   801053ea <argptr>
801061cd:	85 c0                	test   %eax,%eax
801061cf:	79 0a                	jns    801061db <sys_pipe+0x2f>
    return -1;
801061d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d6:	e9 9a 00 00 00       	jmp    80106275 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
801061db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061de:	89 44 24 04          	mov    %eax,0x4(%esp)
801061e2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061e5:	89 04 24             	mov    %eax,(%esp)
801061e8:	e8 7f db ff ff       	call   80103d6c <pipealloc>
801061ed:	85 c0                	test   %eax,%eax
801061ef:	79 07                	jns    801061f8 <sys_pipe+0x4c>
    return -1;
801061f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061f6:	eb 7d                	jmp    80106275 <sys_pipe+0xc9>
  fd0 = -1;
801061f8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106202:	89 04 24             	mov    %eax,(%esp)
80106205:	e8 7e f3 ff ff       	call   80105588 <fdalloc>
8010620a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010620d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106211:	78 14                	js     80106227 <sys_pipe+0x7b>
80106213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106216:	89 04 24             	mov    %eax,(%esp)
80106219:	e8 6a f3 ff ff       	call   80105588 <fdalloc>
8010621e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106225:	79 36                	jns    8010625d <sys_pipe+0xb1>
    if(fd0 >= 0)
80106227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010622b:	78 13                	js     80106240 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
8010622d:	e8 e5 df ff ff       	call   80104217 <myproc>
80106232:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106235:	83 c2 08             	add    $0x8,%edx
80106238:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010623f:	00 
    fileclose(rf);
80106240:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106243:	89 04 24             	mov    %eax,(%esp)
80106246:	e8 c1 ae ff ff       	call   8010110c <fileclose>
    fileclose(wf);
8010624b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010624e:	89 04 24             	mov    %eax,(%esp)
80106251:	e8 b6 ae ff ff       	call   8010110c <fileclose>
    return -1;
80106256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625b:	eb 18                	jmp    80106275 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
8010625d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106260:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106263:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106265:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106268:	8d 50 04             	lea    0x4(%eax),%edx
8010626b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626e:	89 02                	mov    %eax,(%edx)
  return 0;
80106270:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    

80106277 <sys_getname>:

int
sys_getname(void)
{
80106277:	55                   	push   %ebp
80106278:	89 e5                	mov    %esp,%ebp
8010627a:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
8010627d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106280:	89 44 24 04          	mov    %eax,0x4(%esp)
80106284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010628b:	e8 2d f1 ff ff       	call   801053bd <argint>
80106290:	85 c0                	test   %eax,%eax
80106292:	78 17                	js     801062ab <sys_getname+0x34>
80106294:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106297:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062a2:	e8 ad f1 ff ff       	call   80105454 <argstr>
801062a7:	85 c0                	test   %eax,%eax
801062a9:	79 07                	jns    801062b2 <sys_getname+0x3b>
    return -1;
801062ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b0:	eb 12                	jmp    801062c4 <sys_getname+0x4d>
  }

  return getname(index, name);
801062b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801062bc:	89 04 24             	mov    %eax,(%esp)
801062bf:	e8 3c 22 00 00       	call   80108500 <getname>
}
801062c4:	c9                   	leave  
801062c5:	c3                   	ret    

801062c6 <sys_setname>:

int
sys_setname(void)
{
801062c6:	55                   	push   %ebp
801062c7:	89 e5                	mov    %esp,%ebp
801062c9:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801062cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801062d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062da:	e8 de f0 ff ff       	call   801053bd <argint>
801062df:	85 c0                	test   %eax,%eax
801062e1:	78 17                	js     801062fa <sys_setname+0x34>
801062e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062f1:	e8 5e f1 ff ff       	call   80105454 <argstr>
801062f6:	85 c0                	test   %eax,%eax
801062f8:	79 07                	jns    80106301 <sys_setname+0x3b>
    return -1;
801062fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ff:	eb 12                	jmp    80106313 <sys_setname+0x4d>
  }

  return setname(index, name);
80106301:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106307:	89 54 24 04          	mov    %edx,0x4(%esp)
8010630b:	89 04 24             	mov    %eax,(%esp)
8010630e:	e8 3f 22 00 00       	call   80108552 <setname>
}
80106313:	c9                   	leave  
80106314:	c3                   	ret    

80106315 <sys_getmaxproc>:

int
sys_getmaxproc(void)
{
80106315:	55                   	push   %ebp
80106316:	89 e5                	mov    %esp,%ebp
80106318:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010631b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010631e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106329:	e8 8f f0 ff ff       	call   801053bd <argint>
8010632e:	85 c0                	test   %eax,%eax
80106330:	79 07                	jns    80106339 <sys_getmaxproc+0x24>
    return -1;
80106332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106337:	eb 0b                	jmp    80106344 <sys_getmaxproc+0x2f>
  }

  return getmaxproc(index);
80106339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010633c:	89 04 24             	mov    %eax,(%esp)
8010633f:	e8 7c 22 00 00       	call   801085c0 <getmaxproc>
}
80106344:	c9                   	leave  
80106345:	c3                   	ret    

80106346 <sys_setmaxproc>:

int
sys_setmaxproc(void)
{
80106346:	55                   	push   %ebp
80106347:	89 e5                	mov    %esp,%ebp
80106349:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
8010634c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010634f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106353:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010635a:	e8 5e f0 ff ff       	call   801053bd <argint>
8010635f:	85 c0                	test   %eax,%eax
80106361:	78 17                	js     8010637a <sys_setmaxproc+0x34>
80106363:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106366:	89 44 24 04          	mov    %eax,0x4(%esp)
8010636a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106371:	e8 47 f0 ff ff       	call   801053bd <argint>
80106376:	85 c0                	test   %eax,%eax
80106378:	74 07                	je     80106381 <sys_setmaxproc+0x3b>
    return -1;
8010637a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637f:	eb 12                	jmp    80106393 <sys_setmaxproc+0x4d>
  }

  return setmaxproc(index, max);
80106381:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106387:	89 54 24 04          	mov    %edx,0x4(%esp)
8010638b:	89 04 24             	mov    %eax,(%esp)
8010638e:	e8 4f 22 00 00       	call   801085e2 <setmaxproc>
}
80106393:	c9                   	leave  
80106394:	c3                   	ret    

80106395 <sys_getmaxmem>:

int
sys_getmaxmem(void)
{
80106395:	55                   	push   %ebp
80106396:	89 e5                	mov    %esp,%ebp
80106398:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010639b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010639e:	89 44 24 04          	mov    %eax,0x4(%esp)
801063a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063a9:	e8 0f f0 ff ff       	call   801053bd <argint>
801063ae:	85 c0                	test   %eax,%eax
801063b0:	79 07                	jns    801063b9 <sys_getmaxmem+0x24>
    return -1;
801063b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b7:	eb 0b                	jmp    801063c4 <sys_getmaxmem+0x2f>
  }

  return getmaxmem(index);
801063b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063bc:	89 04 24             	mov    %eax,(%esp)
801063bf:	e8 49 22 00 00       	call   8010860d <getmaxmem>
}
801063c4:	c9                   	leave  
801063c5:	c3                   	ret    

801063c6 <sys_setmaxmem>:

int
sys_setmaxmem(void)
{
801063c6:	55                   	push   %ebp
801063c7:	89 e5                	mov    %esp,%ebp
801063c9:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
801063cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801063d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063da:	e8 de ef ff ff       	call   801053bd <argint>
801063df:	85 c0                	test   %eax,%eax
801063e1:	78 17                	js     801063fa <sys_setmaxmem+0x34>
801063e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801063f1:	e8 c7 ef ff ff       	call   801053bd <argint>
801063f6:	85 c0                	test   %eax,%eax
801063f8:	74 07                	je     80106401 <sys_setmaxmem+0x3b>
    return -1;
801063fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ff:	eb 12                	jmp    80106413 <sys_setmaxmem+0x4d>
  }

  return setmaxmem(index, max);
80106401:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106407:	89 54 24 04          	mov    %edx,0x4(%esp)
8010640b:	89 04 24             	mov    %eax,(%esp)
8010640e:	e8 1c 22 00 00       	call   8010862f <setmaxmem>
}
80106413:	c9                   	leave  
80106414:	c3                   	ret    

80106415 <sys_getmaxdisk>:

int
sys_getmaxdisk(void)
{
80106415:	55                   	push   %ebp
80106416:	89 e5                	mov    %esp,%ebp
80106418:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010641b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010641e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106429:	e8 8f ef ff ff       	call   801053bd <argint>
8010642e:	85 c0                	test   %eax,%eax
80106430:	79 07                	jns    80106439 <sys_getmaxdisk+0x24>
    return -1;
80106432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106437:	eb 0b                	jmp    80106444 <sys_getmaxdisk+0x2f>
  }

  return getmaxdisk(index);
80106439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643c:	89 04 24             	mov    %eax,(%esp)
8010643f:	e8 16 22 00 00       	call   8010865a <getmaxdisk>
}
80106444:	c9                   	leave  
80106445:	c3                   	ret    

80106446 <sys_setmaxdisk>:

int
sys_setmaxdisk(void)
{
80106446:	55                   	push   %ebp
80106447:	89 e5                	mov    %esp,%ebp
80106449:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
8010644c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010644f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010645a:	e8 5e ef ff ff       	call   801053bd <argint>
8010645f:	85 c0                	test   %eax,%eax
80106461:	78 17                	js     8010647a <sys_setmaxdisk+0x34>
80106463:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106466:	89 44 24 04          	mov    %eax,0x4(%esp)
8010646a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106471:	e8 47 ef ff ff       	call   801053bd <argint>
80106476:	85 c0                	test   %eax,%eax
80106478:	74 07                	je     80106481 <sys_setmaxdisk+0x3b>
    return -1;
8010647a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647f:	eb 12                	jmp    80106493 <sys_setmaxdisk+0x4d>
  }

  return setmaxdisk(index, max);
80106481:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106487:	89 54 24 04          	mov    %edx,0x4(%esp)
8010648b:	89 04 24             	mov    %eax,(%esp)
8010648e:	e8 e8 21 00 00       	call   8010867b <setmaxdisk>
}
80106493:	c9                   	leave  
80106494:	c3                   	ret    

80106495 <sys_getusedmem>:

int
sys_getusedmem(void)
{
80106495:	55                   	push   %ebp
80106496:	89 e5                	mov    %esp,%ebp
80106498:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010649b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010649e:	89 44 24 04          	mov    %eax,0x4(%esp)
801064a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064a9:	e8 0f ef ff ff       	call   801053bd <argint>
801064ae:	85 c0                	test   %eax,%eax
801064b0:	79 07                	jns    801064b9 <sys_getusedmem+0x24>
    return -1;
801064b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b7:	eb 0b                	jmp    801064c4 <sys_getusedmem+0x2f>
  }

  return getusedmem(index);
801064b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064bc:	89 04 24             	mov    %eax,(%esp)
801064bf:	e8 e1 21 00 00       	call   801086a5 <getusedmem>
}
801064c4:	c9                   	leave  
801064c5:	c3                   	ret    

801064c6 <sys_setusedmem>:

int
sys_setusedmem(void)
{
801064c6:	55                   	push   %ebp
801064c7:	89 e5                	mov    %esp,%ebp
801064c9:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
801064cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801064d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064da:	e8 de ee ff ff       	call   801053bd <argint>
801064df:	85 c0                	test   %eax,%eax
801064e1:	78 17                	js     801064fa <sys_setusedmem+0x34>
801064e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801064f1:	e8 c7 ee ff ff       	call   801053bd <argint>
801064f6:	85 c0                	test   %eax,%eax
801064f8:	74 07                	je     80106501 <sys_setusedmem+0x3b>
    return -1;
801064fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ff:	eb 12                	jmp    80106513 <sys_setusedmem+0x4d>
  }

  return setusedmem(index, max);
80106501:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106507:	89 54 24 04          	mov    %edx,0x4(%esp)
8010650b:	89 04 24             	mov    %eax,(%esp)
8010650e:	e8 b4 21 00 00       	call   801086c7 <setusedmem>
}
80106513:	c9                   	leave  
80106514:	c3                   	ret    

80106515 <sys_getuseddisk>:

int
sys_getuseddisk(void)
{
80106515:	55                   	push   %ebp
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010651b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010651e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106529:	e8 8f ee ff ff       	call   801053bd <argint>
8010652e:	85 c0                	test   %eax,%eax
80106530:	79 07                	jns    80106539 <sys_getuseddisk+0x24>
    return -1;
80106532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106537:	eb 0b                	jmp    80106544 <sys_getuseddisk+0x2f>
  }

  return getuseddisk(index);
80106539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653c:	89 04 24             	mov    %eax,(%esp)
8010653f:	e8 ae 21 00 00       	call   801086f2 <getuseddisk>
}
80106544:	c9                   	leave  
80106545:	c3                   	ret    

80106546 <sys_setuseddisk>:

int
sys_setuseddisk(void)
{
80106546:	55                   	push   %ebp
80106547:	89 e5                	mov    %esp,%ebp
80106549:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
8010654c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010654f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106553:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010655a:	e8 5e ee ff ff       	call   801053bd <argint>
8010655f:	85 c0                	test   %eax,%eax
80106561:	78 17                	js     8010657a <sys_setuseddisk+0x34>
80106563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106566:	89 44 24 04          	mov    %eax,0x4(%esp)
8010656a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106571:	e8 47 ee ff ff       	call   801053bd <argint>
80106576:	85 c0                	test   %eax,%eax
80106578:	74 07                	je     80106581 <sys_setuseddisk+0x3b>
    return -1;
8010657a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010657f:	eb 12                	jmp    80106593 <sys_setuseddisk+0x4d>
  }

  return setuseddisk(index, max);
80106581:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106587:	89 54 24 04          	mov    %edx,0x4(%esp)
8010658b:	89 04 24             	mov    %eax,(%esp)
8010658e:	e8 81 21 00 00       	call   80108714 <setuseddisk>
}
80106593:	c9                   	leave  
80106594:	c3                   	ret    
80106595:	00 00                	add    %al,(%eax)
	...

80106598 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106598:	55                   	push   %ebp
80106599:	89 e5                	mov    %esp,%ebp
8010659b:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010659e:	e8 70 df ff ff       	call   80104513 <fork>
}
801065a3:	c9                   	leave  
801065a4:	c3                   	ret    

801065a5 <sys_exit>:

int
sys_exit(void)
{
801065a5:	55                   	push   %ebp
801065a6:	89 e5                	mov    %esp,%ebp
801065a8:	83 ec 08             	sub    $0x8,%esp
  exit();
801065ab:	e8 c9 e0 ff ff       	call   80104679 <exit>
  return 0;  // not reached
801065b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    

801065b7 <sys_wait>:

int
sys_wait(void)
{
801065b7:	55                   	push   %ebp
801065b8:	89 e5                	mov    %esp,%ebp
801065ba:	83 ec 08             	sub    $0x8,%esp
  return wait();
801065bd:	e8 c0 e1 ff ff       	call   80104782 <wait>
}
801065c2:	c9                   	leave  
801065c3:	c3                   	ret    

801065c4 <sys_kill>:

int
sys_kill(void)
{
801065c4:	55                   	push   %ebp
801065c5:	89 e5                	mov    %esp,%ebp
801065c7:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801065d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065d8:	e8 e0 ed ff ff       	call   801053bd <argint>
801065dd:	85 c0                	test   %eax,%eax
801065df:	79 07                	jns    801065e8 <sys_kill+0x24>
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e6:	eb 0b                	jmp    801065f3 <sys_kill+0x2f>
  return kill(pid);
801065e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065eb:	89 04 24             	mov    %eax,(%esp)
801065ee:	e8 64 e5 ff ff       	call   80104b57 <kill>
}
801065f3:	c9                   	leave  
801065f4:	c3                   	ret    

801065f5 <sys_getpid>:

int
sys_getpid(void)
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
801065f8:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801065fb:	e8 17 dc ff ff       	call   80104217 <myproc>
80106600:	8b 40 10             	mov    0x10(%eax),%eax
}
80106603:	c9                   	leave  
80106604:	c3                   	ret    

80106605 <sys_sbrk>:

int
sys_sbrk(void)
{
80106605:	55                   	push   %ebp
80106606:	89 e5                	mov    %esp,%ebp
80106608:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010660b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010660e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106612:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106619:	e8 9f ed ff ff       	call   801053bd <argint>
8010661e:	85 c0                	test   %eax,%eax
80106620:	79 07                	jns    80106629 <sys_sbrk+0x24>
    return -1;
80106622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106627:	eb 23                	jmp    8010664c <sys_sbrk+0x47>
  addr = myproc()->sz;
80106629:	e8 e9 db ff ff       	call   80104217 <myproc>
8010662e:	8b 00                	mov    (%eax),%eax
80106630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106636:	89 04 24             	mov    %eax,(%esp)
80106639:	e8 37 de ff ff       	call   80104475 <growproc>
8010663e:	85 c0                	test   %eax,%eax
80106640:	79 07                	jns    80106649 <sys_sbrk+0x44>
    return -1;
80106642:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106647:	eb 03                	jmp    8010664c <sys_sbrk+0x47>
  return addr;
80106649:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010664c:	c9                   	leave  
8010664d:	c3                   	ret    

8010664e <sys_sleep>:

int
sys_sleep(void)
{
8010664e:	55                   	push   %ebp
8010664f:	89 e5                	mov    %esp,%ebp
80106651:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106654:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106657:	89 44 24 04          	mov    %eax,0x4(%esp)
8010665b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106662:	e8 56 ed ff ff       	call   801053bd <argint>
80106667:	85 c0                	test   %eax,%eax
80106669:	79 07                	jns    80106672 <sys_sleep+0x24>
    return -1;
8010666b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106670:	eb 6b                	jmp    801066dd <sys_sleep+0x8f>
  acquire(&tickslock);
80106672:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
80106679:	e8 a9 e7 ff ff       	call   80104e27 <acquire>
  ticks0 = ticks;
8010667e:	a1 20 68 11 80       	mov    0x80116820,%eax
80106683:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106686:	eb 33                	jmp    801066bb <sys_sleep+0x6d>
    if(myproc()->killed){
80106688:	e8 8a db ff ff       	call   80104217 <myproc>
8010668d:	8b 40 24             	mov    0x24(%eax),%eax
80106690:	85 c0                	test   %eax,%eax
80106692:	74 13                	je     801066a7 <sys_sleep+0x59>
      release(&tickslock);
80106694:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
8010669b:	e8 f1 e7 ff ff       	call   80104e91 <release>
      return -1;
801066a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a5:	eb 36                	jmp    801066dd <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
801066a7:	c7 44 24 04 e0 5f 11 	movl   $0x80115fe0,0x4(%esp)
801066ae:	80 
801066af:	c7 04 24 20 68 11 80 	movl   $0x80116820,(%esp)
801066b6:	e8 9d e3 ff ff       	call   80104a58 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801066bb:	a1 20 68 11 80       	mov    0x80116820,%eax
801066c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801066c3:	89 c2                	mov    %eax,%edx
801066c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c8:	39 c2                	cmp    %eax,%edx
801066ca:	72 bc                	jb     80106688 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801066cc:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
801066d3:	e8 b9 e7 ff ff       	call   80104e91 <release>
  return 0;
801066d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066dd:	c9                   	leave  
801066de:	c3                   	ret    

801066df <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801066df:	55                   	push   %ebp
801066e0:	89 e5                	mov    %esp,%ebp
801066e2:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
801066e5:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
801066ec:	e8 36 e7 ff ff       	call   80104e27 <acquire>
  xticks = ticks;
801066f1:	a1 20 68 11 80       	mov    0x80116820,%eax
801066f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801066f9:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
80106700:	e8 8c e7 ff ff       	call   80104e91 <release>
  return xticks;
80106705:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106708:	c9                   	leave  
80106709:	c3                   	ret    
	...

8010670c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010670c:	1e                   	push   %ds
  pushl %es
8010670d:	06                   	push   %es
  pushl %fs
8010670e:	0f a0                	push   %fs
  pushl %gs
80106710:	0f a8                	push   %gs
  pushal
80106712:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106713:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106717:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106719:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010671b:	54                   	push   %esp
  call trap
8010671c:	e8 c0 01 00 00       	call   801068e1 <trap>
  addl $4, %esp
80106721:	83 c4 04             	add    $0x4,%esp

80106724 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106724:	61                   	popa   
  popl %gs
80106725:	0f a9                	pop    %gs
  popl %fs
80106727:	0f a1                	pop    %fs
  popl %es
80106729:	07                   	pop    %es
  popl %ds
8010672a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010672b:	83 c4 08             	add    $0x8,%esp
  iret
8010672e:	cf                   	iret   
	...

80106730 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106736:	8b 45 0c             	mov    0xc(%ebp),%eax
80106739:	48                   	dec    %eax
8010673a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010673e:	8b 45 08             	mov    0x8(%ebp),%eax
80106741:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106745:	8b 45 08             	mov    0x8(%ebp),%eax
80106748:	c1 e8 10             	shr    $0x10,%eax
8010674b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010674f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106752:	0f 01 18             	lidtl  (%eax)
}
80106755:	c9                   	leave  
80106756:	c3                   	ret    

80106757 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106757:	55                   	push   %ebp
80106758:	89 e5                	mov    %esp,%ebp
8010675a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010675d:	0f 20 d0             	mov    %cr2,%eax
80106760:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106763:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106766:	c9                   	leave  
80106767:	c3                   	ret    

80106768 <tvinit>:

uint ticks;

void
tvinit(void)
{
80106768:	55                   	push   %ebp
80106769:	89 e5                	mov    %esp,%ebp
8010676b:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010676e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106775:	e9 b8 00 00 00       	jmp    80106832 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010677a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677d:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106784:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106787:	66 89 04 d5 20 60 11 	mov    %ax,-0x7fee9fe0(,%edx,8)
8010678e:	80 
8010678f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106792:	66 c7 04 c5 22 60 11 	movw   $0x8,-0x7fee9fde(,%eax,8)
80106799:	80 08 00 
8010679c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679f:	8a 14 c5 24 60 11 80 	mov    -0x7fee9fdc(,%eax,8),%dl
801067a6:	83 e2 e0             	and    $0xffffffe0,%edx
801067a9:	88 14 c5 24 60 11 80 	mov    %dl,-0x7fee9fdc(,%eax,8)
801067b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b3:	8a 14 c5 24 60 11 80 	mov    -0x7fee9fdc(,%eax,8),%dl
801067ba:	83 e2 1f             	and    $0x1f,%edx
801067bd:	88 14 c5 24 60 11 80 	mov    %dl,-0x7fee9fdc(,%eax,8)
801067c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c7:	8a 14 c5 25 60 11 80 	mov    -0x7fee9fdb(,%eax,8),%dl
801067ce:	83 e2 f0             	and    $0xfffffff0,%edx
801067d1:	83 ca 0e             	or     $0xe,%edx
801067d4:	88 14 c5 25 60 11 80 	mov    %dl,-0x7fee9fdb(,%eax,8)
801067db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067de:	8a 14 c5 25 60 11 80 	mov    -0x7fee9fdb(,%eax,8),%dl
801067e5:	83 e2 ef             	and    $0xffffffef,%edx
801067e8:	88 14 c5 25 60 11 80 	mov    %dl,-0x7fee9fdb(,%eax,8)
801067ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f2:	8a 14 c5 25 60 11 80 	mov    -0x7fee9fdb(,%eax,8),%dl
801067f9:	83 e2 9f             	and    $0xffffff9f,%edx
801067fc:	88 14 c5 25 60 11 80 	mov    %dl,-0x7fee9fdb(,%eax,8)
80106803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106806:	8a 14 c5 25 60 11 80 	mov    -0x7fee9fdb(,%eax,8),%dl
8010680d:	83 ca 80             	or     $0xffffff80,%edx
80106810:	88 14 c5 25 60 11 80 	mov    %dl,-0x7fee9fdb(,%eax,8)
80106817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681a:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106821:	c1 e8 10             	shr    $0x10,%eax
80106824:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106827:	66 89 04 d5 26 60 11 	mov    %ax,-0x7fee9fda(,%edx,8)
8010682e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010682f:	ff 45 f4             	incl   -0xc(%ebp)
80106832:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106839:	0f 8e 3b ff ff ff    	jle    8010677a <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010683f:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
80106844:	66 a3 20 62 11 80    	mov    %ax,0x80116220
8010684a:	66 c7 05 22 62 11 80 	movw   $0x8,0x80116222
80106851:	08 00 
80106853:	a0 24 62 11 80       	mov    0x80116224,%al
80106858:	83 e0 e0             	and    $0xffffffe0,%eax
8010685b:	a2 24 62 11 80       	mov    %al,0x80116224
80106860:	a0 24 62 11 80       	mov    0x80116224,%al
80106865:	83 e0 1f             	and    $0x1f,%eax
80106868:	a2 24 62 11 80       	mov    %al,0x80116224
8010686d:	a0 25 62 11 80       	mov    0x80116225,%al
80106872:	83 c8 0f             	or     $0xf,%eax
80106875:	a2 25 62 11 80       	mov    %al,0x80116225
8010687a:	a0 25 62 11 80       	mov    0x80116225,%al
8010687f:	83 e0 ef             	and    $0xffffffef,%eax
80106882:	a2 25 62 11 80       	mov    %al,0x80116225
80106887:	a0 25 62 11 80       	mov    0x80116225,%al
8010688c:	83 c8 60             	or     $0x60,%eax
8010688f:	a2 25 62 11 80       	mov    %al,0x80116225
80106894:	a0 25 62 11 80       	mov    0x80116225,%al
80106899:	83 c8 80             	or     $0xffffff80,%eax
8010689c:	a2 25 62 11 80       	mov    %al,0x80116225
801068a1:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
801068a6:	c1 e8 10             	shr    $0x10,%eax
801068a9:	66 a3 26 62 11 80    	mov    %ax,0x80116226

  initlock(&tickslock, "time");
801068af:	c7 44 24 04 50 8c 10 	movl   $0x80108c50,0x4(%esp)
801068b6:	80 
801068b7:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
801068be:	e8 43 e5 ff ff       	call   80104e06 <initlock>
}
801068c3:	c9                   	leave  
801068c4:	c3                   	ret    

801068c5 <idtinit>:

void
idtinit(void)
{
801068c5:	55                   	push   %ebp
801068c6:	89 e5                	mov    %esp,%ebp
801068c8:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801068cb:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801068d2:	00 
801068d3:	c7 04 24 20 60 11 80 	movl   $0x80116020,(%esp)
801068da:	e8 51 fe ff ff       	call   80106730 <lidt>
}
801068df:	c9                   	leave  
801068e0:	c3                   	ret    

801068e1 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068e1:	55                   	push   %ebp
801068e2:	89 e5                	mov    %esp,%ebp
801068e4:	57                   	push   %edi
801068e5:	56                   	push   %esi
801068e6:	53                   	push   %ebx
801068e7:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801068ea:	8b 45 08             	mov    0x8(%ebp),%eax
801068ed:	8b 40 30             	mov    0x30(%eax),%eax
801068f0:	83 f8 40             	cmp    $0x40,%eax
801068f3:	75 3c                	jne    80106931 <trap+0x50>
    if(myproc()->killed)
801068f5:	e8 1d d9 ff ff       	call   80104217 <myproc>
801068fa:	8b 40 24             	mov    0x24(%eax),%eax
801068fd:	85 c0                	test   %eax,%eax
801068ff:	74 05                	je     80106906 <trap+0x25>
      exit();
80106901:	e8 73 dd ff ff       	call   80104679 <exit>
    myproc()->tf = tf;
80106906:	e8 0c d9 ff ff       	call   80104217 <myproc>
8010690b:	8b 55 08             	mov    0x8(%ebp),%edx
8010690e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106911:	e8 75 eb ff ff       	call   8010548b <syscall>
    if(myproc()->killed)
80106916:	e8 fc d8 ff ff       	call   80104217 <myproc>
8010691b:	8b 40 24             	mov    0x24(%eax),%eax
8010691e:	85 c0                	test   %eax,%eax
80106920:	74 0a                	je     8010692c <trap+0x4b>
      exit();
80106922:	e8 52 dd ff ff       	call   80104679 <exit>
    return;
80106927:	e9 13 02 00 00       	jmp    80106b3f <trap+0x25e>
8010692c:	e9 0e 02 00 00       	jmp    80106b3f <trap+0x25e>
  }

  switch(tf->trapno){
80106931:	8b 45 08             	mov    0x8(%ebp),%eax
80106934:	8b 40 30             	mov    0x30(%eax),%eax
80106937:	83 e8 20             	sub    $0x20,%eax
8010693a:	83 f8 1f             	cmp    $0x1f,%eax
8010693d:	0f 87 ae 00 00 00    	ja     801069f1 <trap+0x110>
80106943:	8b 04 85 f8 8c 10 80 	mov    -0x7fef7308(,%eax,4),%eax
8010694a:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010694c:	e8 fd d7 ff ff       	call   8010414e <cpuid>
80106951:	85 c0                	test   %eax,%eax
80106953:	75 2f                	jne    80106984 <trap+0xa3>
      acquire(&tickslock);
80106955:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
8010695c:	e8 c6 e4 ff ff       	call   80104e27 <acquire>
      ticks++;
80106961:	a1 20 68 11 80       	mov    0x80116820,%eax
80106966:	40                   	inc    %eax
80106967:	a3 20 68 11 80       	mov    %eax,0x80116820
      // myproc()->ticks++;
      wakeup(&ticks);
8010696c:	c7 04 24 20 68 11 80 	movl   $0x80116820,(%esp)
80106973:	e8 b4 e1 ff ff       	call   80104b2c <wakeup>
      release(&tickslock);
80106978:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
8010697f:	e8 0d e5 ff ff       	call   80104e91 <release>
    }
    lapiceoi();
80106984:	e8 6e c6 ff ff       	call   80102ff7 <lapiceoi>
    break;
80106989:	e9 35 01 00 00       	jmp    80106ac3 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010698e:	e8 e3 be ff ff       	call   80102876 <ideintr>
    lapiceoi();
80106993:	e8 5f c6 ff ff       	call   80102ff7 <lapiceoi>
    break;
80106998:	e9 26 01 00 00       	jmp    80106ac3 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010699d:	e8 6c c4 ff ff       	call   80102e0e <kbdintr>
    lapiceoi();
801069a2:	e8 50 c6 ff ff       	call   80102ff7 <lapiceoi>
    break;
801069a7:	e9 17 01 00 00       	jmp    80106ac3 <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801069ac:	e8 70 03 00 00       	call   80106d21 <uartintr>
    lapiceoi();
801069b1:	e8 41 c6 ff ff       	call   80102ff7 <lapiceoi>
    break;
801069b6:	e9 08 01 00 00       	jmp    80106ac3 <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069bb:	8b 45 08             	mov    0x8(%ebp),%eax
801069be:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801069c1:	8b 45 08             	mov    0x8(%ebp),%eax
801069c4:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069c7:	0f b7 d8             	movzwl %ax,%ebx
801069ca:	e8 7f d7 ff ff       	call   8010414e <cpuid>
801069cf:	89 74 24 0c          	mov    %esi,0xc(%esp)
801069d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801069d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801069db:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801069e2:	e8 da 99 ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801069e7:	e8 0b c6 ff ff       	call   80102ff7 <lapiceoi>
    break;
801069ec:	e9 d2 00 00 00       	jmp    80106ac3 <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801069f1:	e8 21 d8 ff ff       	call   80104217 <myproc>
801069f6:	85 c0                	test   %eax,%eax
801069f8:	74 10                	je     80106a0a <trap+0x129>
801069fa:	8b 45 08             	mov    0x8(%ebp),%eax
801069fd:	8b 40 3c             	mov    0x3c(%eax),%eax
80106a00:	0f b7 c0             	movzwl %ax,%eax
80106a03:	83 e0 03             	and    $0x3,%eax
80106a06:	85 c0                	test   %eax,%eax
80106a08:	75 40                	jne    80106a4a <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a0a:	e8 48 fd ff ff       	call   80106757 <rcr2>
80106a0f:	89 c3                	mov    %eax,%ebx
80106a11:	8b 45 08             	mov    0x8(%ebp),%eax
80106a14:	8b 70 38             	mov    0x38(%eax),%esi
80106a17:	e8 32 d7 ff ff       	call   8010414e <cpuid>
80106a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a1f:	8b 52 30             	mov    0x30(%edx),%edx
80106a22:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106a26:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a2e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a32:	c7 04 24 7c 8c 10 80 	movl   $0x80108c7c,(%esp)
80106a39:	e8 83 99 ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106a3e:	c7 04 24 ae 8c 10 80 	movl   $0x80108cae,(%esp)
80106a45:	e8 0a 9b ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a4a:	e8 08 fd ff ff       	call   80106757 <rcr2>
80106a4f:	89 c6                	mov    %eax,%esi
80106a51:	8b 45 08             	mov    0x8(%ebp),%eax
80106a54:	8b 40 38             	mov    0x38(%eax),%eax
80106a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a5a:	e8 ef d6 ff ff       	call   8010414e <cpuid>
80106a5f:	89 c3                	mov    %eax,%ebx
80106a61:	8b 45 08             	mov    0x8(%ebp),%eax
80106a64:	8b 78 34             	mov    0x34(%eax),%edi
80106a67:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6d:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a70:	e8 a2 d7 ff ff       	call   80104217 <myproc>
80106a75:	8d 50 6c             	lea    0x6c(%eax),%edx
80106a78:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106a7b:	e8 97 d7 ff ff       	call   80104217 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a80:	8b 40 10             	mov    0x10(%eax),%eax
80106a83:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106a87:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a8a:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106a8e:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106a92:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80106a99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106a9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106aa0:	89 54 24 08          	mov    %edx,0x8(%esp)
80106aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aa8:	c7 04 24 b4 8c 10 80 	movl   $0x80108cb4,(%esp)
80106aaf:	e8 0d 99 ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106ab4:	e8 5e d7 ff ff       	call   80104217 <myproc>
80106ab9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ac0:	eb 01                	jmp    80106ac3 <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106ac2:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ac3:	e8 4f d7 ff ff       	call   80104217 <myproc>
80106ac8:	85 c0                	test   %eax,%eax
80106aca:	74 22                	je     80106aee <trap+0x20d>
80106acc:	e8 46 d7 ff ff       	call   80104217 <myproc>
80106ad1:	8b 40 24             	mov    0x24(%eax),%eax
80106ad4:	85 c0                	test   %eax,%eax
80106ad6:	74 16                	je     80106aee <trap+0x20d>
80106ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80106adb:	8b 40 3c             	mov    0x3c(%eax),%eax
80106ade:	0f b7 c0             	movzwl %ax,%eax
80106ae1:	83 e0 03             	and    $0x3,%eax
80106ae4:	83 f8 03             	cmp    $0x3,%eax
80106ae7:	75 05                	jne    80106aee <trap+0x20d>
    exit();
80106ae9:	e8 8b db ff ff       	call   80104679 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106aee:	e8 24 d7 ff ff       	call   80104217 <myproc>
80106af3:	85 c0                	test   %eax,%eax
80106af5:	74 1d                	je     80106b14 <trap+0x233>
80106af7:	e8 1b d7 ff ff       	call   80104217 <myproc>
80106afc:	8b 40 0c             	mov    0xc(%eax),%eax
80106aff:	83 f8 04             	cmp    $0x4,%eax
80106b02:	75 10                	jne    80106b14 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106b04:	8b 45 08             	mov    0x8(%ebp),%eax
80106b07:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106b0a:	83 f8 20             	cmp    $0x20,%eax
80106b0d:	75 05                	jne    80106b14 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80106b0f:	e8 d4 de ff ff       	call   801049e8 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b14:	e8 fe d6 ff ff       	call   80104217 <myproc>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	74 22                	je     80106b3f <trap+0x25e>
80106b1d:	e8 f5 d6 ff ff       	call   80104217 <myproc>
80106b22:	8b 40 24             	mov    0x24(%eax),%eax
80106b25:	85 c0                	test   %eax,%eax
80106b27:	74 16                	je     80106b3f <trap+0x25e>
80106b29:	8b 45 08             	mov    0x8(%ebp),%eax
80106b2c:	8b 40 3c             	mov    0x3c(%eax),%eax
80106b2f:	0f b7 c0             	movzwl %ax,%eax
80106b32:	83 e0 03             	and    $0x3,%eax
80106b35:	83 f8 03             	cmp    $0x3,%eax
80106b38:	75 05                	jne    80106b3f <trap+0x25e>
    exit();
80106b3a:	e8 3a db ff ff       	call   80104679 <exit>
}
80106b3f:	83 c4 3c             	add    $0x3c,%esp
80106b42:	5b                   	pop    %ebx
80106b43:	5e                   	pop    %esi
80106b44:	5f                   	pop    %edi
80106b45:	5d                   	pop    %ebp
80106b46:	c3                   	ret    
	...

80106b48 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106b48:	55                   	push   %ebp
80106b49:	89 e5                	mov    %esp,%ebp
80106b4b:	83 ec 14             	sub    $0x14,%esp
80106b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b51:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b58:	89 c2                	mov    %eax,%edx
80106b5a:	ec                   	in     (%dx),%al
80106b5b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106b5e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80106b61:	c9                   	leave  
80106b62:	c3                   	ret    

80106b63 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106b63:	55                   	push   %ebp
80106b64:	89 e5                	mov    %esp,%ebp
80106b66:	83 ec 08             	sub    $0x8,%esp
80106b69:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b6f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106b73:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b76:	8a 45 f8             	mov    -0x8(%ebp),%al
80106b79:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b7c:	ee                   	out    %al,(%dx)
}
80106b7d:	c9                   	leave  
80106b7e:	c3                   	ret    

80106b7f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b7f:	55                   	push   %ebp
80106b80:	89 e5                	mov    %esp,%ebp
80106b82:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b8c:	00 
80106b8d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b94:	e8 ca ff ff ff       	call   80106b63 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b99:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106ba0:	00 
80106ba1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106ba8:	e8 b6 ff ff ff       	call   80106b63 <outb>
  outb(COM1+0, 115200/9600);
80106bad:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106bb4:	00 
80106bb5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106bbc:	e8 a2 ff ff ff       	call   80106b63 <outb>
  outb(COM1+1, 0);
80106bc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bc8:	00 
80106bc9:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106bd0:	e8 8e ff ff ff       	call   80106b63 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106bd5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106bdc:	00 
80106bdd:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106be4:	e8 7a ff ff ff       	call   80106b63 <outb>
  outb(COM1+4, 0);
80106be9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bf0:	00 
80106bf1:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106bf8:	e8 66 ff ff ff       	call   80106b63 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bfd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106c04:	00 
80106c05:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106c0c:	e8 52 ff ff ff       	call   80106b63 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106c11:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c18:	e8 2b ff ff ff       	call   80106b48 <inb>
80106c1d:	3c ff                	cmp    $0xff,%al
80106c1f:	75 02                	jne    80106c23 <uartinit+0xa4>
    return;
80106c21:	eb 5b                	jmp    80106c7e <uartinit+0xff>
  uart = 1;
80106c23:	c7 05 64 b6 10 80 01 	movl   $0x1,0x8010b664
80106c2a:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106c2d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106c34:	e8 0f ff ff ff       	call   80106b48 <inb>
  inb(COM1+0);
80106c39:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c40:	e8 03 ff ff ff       	call   80106b48 <inb>
  ioapicenable(IRQ_COM1, 0);
80106c45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c4c:	00 
80106c4d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106c54:	e8 92 be ff ff       	call   80102aeb <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c59:	c7 45 f4 78 8d 10 80 	movl   $0x80108d78,-0xc(%ebp)
80106c60:	eb 13                	jmp    80106c75 <uartinit+0xf6>
    uartputc(*p);
80106c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c65:	8a 00                	mov    (%eax),%al
80106c67:	0f be c0             	movsbl %al,%eax
80106c6a:	89 04 24             	mov    %eax,(%esp)
80106c6d:	e8 0e 00 00 00       	call   80106c80 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c72:	ff 45 f4             	incl   -0xc(%ebp)
80106c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c78:	8a 00                	mov    (%eax),%al
80106c7a:	84 c0                	test   %al,%al
80106c7c:	75 e4                	jne    80106c62 <uartinit+0xe3>
    uartputc(*p);
}
80106c7e:	c9                   	leave  
80106c7f:	c3                   	ret    

80106c80 <uartputc>:

void
uartputc(int c)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106c86:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106c8b:	85 c0                	test   %eax,%eax
80106c8d:	75 02                	jne    80106c91 <uartputc+0x11>
    return;
80106c8f:	eb 4a                	jmp    80106cdb <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c98:	eb 0f                	jmp    80106ca9 <uartputc+0x29>
    microdelay(10);
80106c9a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106ca1:	e8 76 c3 ff ff       	call   8010301c <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ca6:	ff 45 f4             	incl   -0xc(%ebp)
80106ca9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106cad:	7f 16                	jg     80106cc5 <uartputc+0x45>
80106caf:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cb6:	e8 8d fe ff ff       	call   80106b48 <inb>
80106cbb:	0f b6 c0             	movzbl %al,%eax
80106cbe:	83 e0 20             	and    $0x20,%eax
80106cc1:	85 c0                	test   %eax,%eax
80106cc3:	74 d5                	je     80106c9a <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc8:	0f b6 c0             	movzbl %al,%eax
80106ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ccf:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cd6:	e8 88 fe ff ff       	call   80106b63 <outb>
}
80106cdb:	c9                   	leave  
80106cdc:	c3                   	ret    

80106cdd <uartgetc>:

static int
uartgetc(void)
{
80106cdd:	55                   	push   %ebp
80106cde:	89 e5                	mov    %esp,%ebp
80106ce0:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ce3:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106ce8:	85 c0                	test   %eax,%eax
80106cea:	75 07                	jne    80106cf3 <uartgetc+0x16>
    return -1;
80106cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf1:	eb 2c                	jmp    80106d1f <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106cf3:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cfa:	e8 49 fe ff ff       	call   80106b48 <inb>
80106cff:	0f b6 c0             	movzbl %al,%eax
80106d02:	83 e0 01             	and    $0x1,%eax
80106d05:	85 c0                	test   %eax,%eax
80106d07:	75 07                	jne    80106d10 <uartgetc+0x33>
    return -1;
80106d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d0e:	eb 0f                	jmp    80106d1f <uartgetc+0x42>
  return inb(COM1+0);
80106d10:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106d17:	e8 2c fe ff ff       	call   80106b48 <inb>
80106d1c:	0f b6 c0             	movzbl %al,%eax
}
80106d1f:	c9                   	leave  
80106d20:	c3                   	ret    

80106d21 <uartintr>:

void
uartintr(void)
{
80106d21:	55                   	push   %ebp
80106d22:	89 e5                	mov    %esp,%ebp
80106d24:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106d27:	c7 04 24 dd 6c 10 80 	movl   $0x80106cdd,(%esp)
80106d2e:	e8 c2 9a ff ff       	call   801007f5 <consoleintr>
}
80106d33:	c9                   	leave  
80106d34:	c3                   	ret    
80106d35:	00 00                	add    %al,(%eax)
	...

80106d38 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $0
80106d3a:	6a 00                	push   $0x0
  jmp alltraps
80106d3c:	e9 cb f9 ff ff       	jmp    8010670c <alltraps>

80106d41 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $1
80106d43:	6a 01                	push   $0x1
  jmp alltraps
80106d45:	e9 c2 f9 ff ff       	jmp    8010670c <alltraps>

80106d4a <vector2>:
.globl vector2
vector2:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $2
80106d4c:	6a 02                	push   $0x2
  jmp alltraps
80106d4e:	e9 b9 f9 ff ff       	jmp    8010670c <alltraps>

80106d53 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $3
80106d55:	6a 03                	push   $0x3
  jmp alltraps
80106d57:	e9 b0 f9 ff ff       	jmp    8010670c <alltraps>

80106d5c <vector4>:
.globl vector4
vector4:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $4
80106d5e:	6a 04                	push   $0x4
  jmp alltraps
80106d60:	e9 a7 f9 ff ff       	jmp    8010670c <alltraps>

80106d65 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $5
80106d67:	6a 05                	push   $0x5
  jmp alltraps
80106d69:	e9 9e f9 ff ff       	jmp    8010670c <alltraps>

80106d6e <vector6>:
.globl vector6
vector6:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $6
80106d70:	6a 06                	push   $0x6
  jmp alltraps
80106d72:	e9 95 f9 ff ff       	jmp    8010670c <alltraps>

80106d77 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $7
80106d79:	6a 07                	push   $0x7
  jmp alltraps
80106d7b:	e9 8c f9 ff ff       	jmp    8010670c <alltraps>

80106d80 <vector8>:
.globl vector8
vector8:
  pushl $8
80106d80:	6a 08                	push   $0x8
  jmp alltraps
80106d82:	e9 85 f9 ff ff       	jmp    8010670c <alltraps>

80106d87 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $9
80106d89:	6a 09                	push   $0x9
  jmp alltraps
80106d8b:	e9 7c f9 ff ff       	jmp    8010670c <alltraps>

80106d90 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d90:	6a 0a                	push   $0xa
  jmp alltraps
80106d92:	e9 75 f9 ff ff       	jmp    8010670c <alltraps>

80106d97 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d97:	6a 0b                	push   $0xb
  jmp alltraps
80106d99:	e9 6e f9 ff ff       	jmp    8010670c <alltraps>

80106d9e <vector12>:
.globl vector12
vector12:
  pushl $12
80106d9e:	6a 0c                	push   $0xc
  jmp alltraps
80106da0:	e9 67 f9 ff ff       	jmp    8010670c <alltraps>

80106da5 <vector13>:
.globl vector13
vector13:
  pushl $13
80106da5:	6a 0d                	push   $0xd
  jmp alltraps
80106da7:	e9 60 f9 ff ff       	jmp    8010670c <alltraps>

80106dac <vector14>:
.globl vector14
vector14:
  pushl $14
80106dac:	6a 0e                	push   $0xe
  jmp alltraps
80106dae:	e9 59 f9 ff ff       	jmp    8010670c <alltraps>

80106db3 <vector15>:
.globl vector15
vector15:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $15
80106db5:	6a 0f                	push   $0xf
  jmp alltraps
80106db7:	e9 50 f9 ff ff       	jmp    8010670c <alltraps>

80106dbc <vector16>:
.globl vector16
vector16:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $16
80106dbe:	6a 10                	push   $0x10
  jmp alltraps
80106dc0:	e9 47 f9 ff ff       	jmp    8010670c <alltraps>

80106dc5 <vector17>:
.globl vector17
vector17:
  pushl $17
80106dc5:	6a 11                	push   $0x11
  jmp alltraps
80106dc7:	e9 40 f9 ff ff       	jmp    8010670c <alltraps>

80106dcc <vector18>:
.globl vector18
vector18:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $18
80106dce:	6a 12                	push   $0x12
  jmp alltraps
80106dd0:	e9 37 f9 ff ff       	jmp    8010670c <alltraps>

80106dd5 <vector19>:
.globl vector19
vector19:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $19
80106dd7:	6a 13                	push   $0x13
  jmp alltraps
80106dd9:	e9 2e f9 ff ff       	jmp    8010670c <alltraps>

80106dde <vector20>:
.globl vector20
vector20:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $20
80106de0:	6a 14                	push   $0x14
  jmp alltraps
80106de2:	e9 25 f9 ff ff       	jmp    8010670c <alltraps>

80106de7 <vector21>:
.globl vector21
vector21:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $21
80106de9:	6a 15                	push   $0x15
  jmp alltraps
80106deb:	e9 1c f9 ff ff       	jmp    8010670c <alltraps>

80106df0 <vector22>:
.globl vector22
vector22:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $22
80106df2:	6a 16                	push   $0x16
  jmp alltraps
80106df4:	e9 13 f9 ff ff       	jmp    8010670c <alltraps>

80106df9 <vector23>:
.globl vector23
vector23:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $23
80106dfb:	6a 17                	push   $0x17
  jmp alltraps
80106dfd:	e9 0a f9 ff ff       	jmp    8010670c <alltraps>

80106e02 <vector24>:
.globl vector24
vector24:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $24
80106e04:	6a 18                	push   $0x18
  jmp alltraps
80106e06:	e9 01 f9 ff ff       	jmp    8010670c <alltraps>

80106e0b <vector25>:
.globl vector25
vector25:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $25
80106e0d:	6a 19                	push   $0x19
  jmp alltraps
80106e0f:	e9 f8 f8 ff ff       	jmp    8010670c <alltraps>

80106e14 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $26
80106e16:	6a 1a                	push   $0x1a
  jmp alltraps
80106e18:	e9 ef f8 ff ff       	jmp    8010670c <alltraps>

80106e1d <vector27>:
.globl vector27
vector27:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $27
80106e1f:	6a 1b                	push   $0x1b
  jmp alltraps
80106e21:	e9 e6 f8 ff ff       	jmp    8010670c <alltraps>

80106e26 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $28
80106e28:	6a 1c                	push   $0x1c
  jmp alltraps
80106e2a:	e9 dd f8 ff ff       	jmp    8010670c <alltraps>

80106e2f <vector29>:
.globl vector29
vector29:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $29
80106e31:	6a 1d                	push   $0x1d
  jmp alltraps
80106e33:	e9 d4 f8 ff ff       	jmp    8010670c <alltraps>

80106e38 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $30
80106e3a:	6a 1e                	push   $0x1e
  jmp alltraps
80106e3c:	e9 cb f8 ff ff       	jmp    8010670c <alltraps>

80106e41 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $31
80106e43:	6a 1f                	push   $0x1f
  jmp alltraps
80106e45:	e9 c2 f8 ff ff       	jmp    8010670c <alltraps>

80106e4a <vector32>:
.globl vector32
vector32:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $32
80106e4c:	6a 20                	push   $0x20
  jmp alltraps
80106e4e:	e9 b9 f8 ff ff       	jmp    8010670c <alltraps>

80106e53 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $33
80106e55:	6a 21                	push   $0x21
  jmp alltraps
80106e57:	e9 b0 f8 ff ff       	jmp    8010670c <alltraps>

80106e5c <vector34>:
.globl vector34
vector34:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $34
80106e5e:	6a 22                	push   $0x22
  jmp alltraps
80106e60:	e9 a7 f8 ff ff       	jmp    8010670c <alltraps>

80106e65 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $35
80106e67:	6a 23                	push   $0x23
  jmp alltraps
80106e69:	e9 9e f8 ff ff       	jmp    8010670c <alltraps>

80106e6e <vector36>:
.globl vector36
vector36:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $36
80106e70:	6a 24                	push   $0x24
  jmp alltraps
80106e72:	e9 95 f8 ff ff       	jmp    8010670c <alltraps>

80106e77 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $37
80106e79:	6a 25                	push   $0x25
  jmp alltraps
80106e7b:	e9 8c f8 ff ff       	jmp    8010670c <alltraps>

80106e80 <vector38>:
.globl vector38
vector38:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $38
80106e82:	6a 26                	push   $0x26
  jmp alltraps
80106e84:	e9 83 f8 ff ff       	jmp    8010670c <alltraps>

80106e89 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $39
80106e8b:	6a 27                	push   $0x27
  jmp alltraps
80106e8d:	e9 7a f8 ff ff       	jmp    8010670c <alltraps>

80106e92 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $40
80106e94:	6a 28                	push   $0x28
  jmp alltraps
80106e96:	e9 71 f8 ff ff       	jmp    8010670c <alltraps>

80106e9b <vector41>:
.globl vector41
vector41:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $41
80106e9d:	6a 29                	push   $0x29
  jmp alltraps
80106e9f:	e9 68 f8 ff ff       	jmp    8010670c <alltraps>

80106ea4 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $42
80106ea6:	6a 2a                	push   $0x2a
  jmp alltraps
80106ea8:	e9 5f f8 ff ff       	jmp    8010670c <alltraps>

80106ead <vector43>:
.globl vector43
vector43:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $43
80106eaf:	6a 2b                	push   $0x2b
  jmp alltraps
80106eb1:	e9 56 f8 ff ff       	jmp    8010670c <alltraps>

80106eb6 <vector44>:
.globl vector44
vector44:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $44
80106eb8:	6a 2c                	push   $0x2c
  jmp alltraps
80106eba:	e9 4d f8 ff ff       	jmp    8010670c <alltraps>

80106ebf <vector45>:
.globl vector45
vector45:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $45
80106ec1:	6a 2d                	push   $0x2d
  jmp alltraps
80106ec3:	e9 44 f8 ff ff       	jmp    8010670c <alltraps>

80106ec8 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $46
80106eca:	6a 2e                	push   $0x2e
  jmp alltraps
80106ecc:	e9 3b f8 ff ff       	jmp    8010670c <alltraps>

80106ed1 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $47
80106ed3:	6a 2f                	push   $0x2f
  jmp alltraps
80106ed5:	e9 32 f8 ff ff       	jmp    8010670c <alltraps>

80106eda <vector48>:
.globl vector48
vector48:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $48
80106edc:	6a 30                	push   $0x30
  jmp alltraps
80106ede:	e9 29 f8 ff ff       	jmp    8010670c <alltraps>

80106ee3 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $49
80106ee5:	6a 31                	push   $0x31
  jmp alltraps
80106ee7:	e9 20 f8 ff ff       	jmp    8010670c <alltraps>

80106eec <vector50>:
.globl vector50
vector50:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $50
80106eee:	6a 32                	push   $0x32
  jmp alltraps
80106ef0:	e9 17 f8 ff ff       	jmp    8010670c <alltraps>

80106ef5 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $51
80106ef7:	6a 33                	push   $0x33
  jmp alltraps
80106ef9:	e9 0e f8 ff ff       	jmp    8010670c <alltraps>

80106efe <vector52>:
.globl vector52
vector52:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $52
80106f00:	6a 34                	push   $0x34
  jmp alltraps
80106f02:	e9 05 f8 ff ff       	jmp    8010670c <alltraps>

80106f07 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $53
80106f09:	6a 35                	push   $0x35
  jmp alltraps
80106f0b:	e9 fc f7 ff ff       	jmp    8010670c <alltraps>

80106f10 <vector54>:
.globl vector54
vector54:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $54
80106f12:	6a 36                	push   $0x36
  jmp alltraps
80106f14:	e9 f3 f7 ff ff       	jmp    8010670c <alltraps>

80106f19 <vector55>:
.globl vector55
vector55:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $55
80106f1b:	6a 37                	push   $0x37
  jmp alltraps
80106f1d:	e9 ea f7 ff ff       	jmp    8010670c <alltraps>

80106f22 <vector56>:
.globl vector56
vector56:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $56
80106f24:	6a 38                	push   $0x38
  jmp alltraps
80106f26:	e9 e1 f7 ff ff       	jmp    8010670c <alltraps>

80106f2b <vector57>:
.globl vector57
vector57:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $57
80106f2d:	6a 39                	push   $0x39
  jmp alltraps
80106f2f:	e9 d8 f7 ff ff       	jmp    8010670c <alltraps>

80106f34 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $58
80106f36:	6a 3a                	push   $0x3a
  jmp alltraps
80106f38:	e9 cf f7 ff ff       	jmp    8010670c <alltraps>

80106f3d <vector59>:
.globl vector59
vector59:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $59
80106f3f:	6a 3b                	push   $0x3b
  jmp alltraps
80106f41:	e9 c6 f7 ff ff       	jmp    8010670c <alltraps>

80106f46 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $60
80106f48:	6a 3c                	push   $0x3c
  jmp alltraps
80106f4a:	e9 bd f7 ff ff       	jmp    8010670c <alltraps>

80106f4f <vector61>:
.globl vector61
vector61:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $61
80106f51:	6a 3d                	push   $0x3d
  jmp alltraps
80106f53:	e9 b4 f7 ff ff       	jmp    8010670c <alltraps>

80106f58 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $62
80106f5a:	6a 3e                	push   $0x3e
  jmp alltraps
80106f5c:	e9 ab f7 ff ff       	jmp    8010670c <alltraps>

80106f61 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $63
80106f63:	6a 3f                	push   $0x3f
  jmp alltraps
80106f65:	e9 a2 f7 ff ff       	jmp    8010670c <alltraps>

80106f6a <vector64>:
.globl vector64
vector64:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $64
80106f6c:	6a 40                	push   $0x40
  jmp alltraps
80106f6e:	e9 99 f7 ff ff       	jmp    8010670c <alltraps>

80106f73 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $65
80106f75:	6a 41                	push   $0x41
  jmp alltraps
80106f77:	e9 90 f7 ff ff       	jmp    8010670c <alltraps>

80106f7c <vector66>:
.globl vector66
vector66:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $66
80106f7e:	6a 42                	push   $0x42
  jmp alltraps
80106f80:	e9 87 f7 ff ff       	jmp    8010670c <alltraps>

80106f85 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $67
80106f87:	6a 43                	push   $0x43
  jmp alltraps
80106f89:	e9 7e f7 ff ff       	jmp    8010670c <alltraps>

80106f8e <vector68>:
.globl vector68
vector68:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $68
80106f90:	6a 44                	push   $0x44
  jmp alltraps
80106f92:	e9 75 f7 ff ff       	jmp    8010670c <alltraps>

80106f97 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $69
80106f99:	6a 45                	push   $0x45
  jmp alltraps
80106f9b:	e9 6c f7 ff ff       	jmp    8010670c <alltraps>

80106fa0 <vector70>:
.globl vector70
vector70:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $70
80106fa2:	6a 46                	push   $0x46
  jmp alltraps
80106fa4:	e9 63 f7 ff ff       	jmp    8010670c <alltraps>

80106fa9 <vector71>:
.globl vector71
vector71:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $71
80106fab:	6a 47                	push   $0x47
  jmp alltraps
80106fad:	e9 5a f7 ff ff       	jmp    8010670c <alltraps>

80106fb2 <vector72>:
.globl vector72
vector72:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $72
80106fb4:	6a 48                	push   $0x48
  jmp alltraps
80106fb6:	e9 51 f7 ff ff       	jmp    8010670c <alltraps>

80106fbb <vector73>:
.globl vector73
vector73:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $73
80106fbd:	6a 49                	push   $0x49
  jmp alltraps
80106fbf:	e9 48 f7 ff ff       	jmp    8010670c <alltraps>

80106fc4 <vector74>:
.globl vector74
vector74:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $74
80106fc6:	6a 4a                	push   $0x4a
  jmp alltraps
80106fc8:	e9 3f f7 ff ff       	jmp    8010670c <alltraps>

80106fcd <vector75>:
.globl vector75
vector75:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $75
80106fcf:	6a 4b                	push   $0x4b
  jmp alltraps
80106fd1:	e9 36 f7 ff ff       	jmp    8010670c <alltraps>

80106fd6 <vector76>:
.globl vector76
vector76:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $76
80106fd8:	6a 4c                	push   $0x4c
  jmp alltraps
80106fda:	e9 2d f7 ff ff       	jmp    8010670c <alltraps>

80106fdf <vector77>:
.globl vector77
vector77:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $77
80106fe1:	6a 4d                	push   $0x4d
  jmp alltraps
80106fe3:	e9 24 f7 ff ff       	jmp    8010670c <alltraps>

80106fe8 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $78
80106fea:	6a 4e                	push   $0x4e
  jmp alltraps
80106fec:	e9 1b f7 ff ff       	jmp    8010670c <alltraps>

80106ff1 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $79
80106ff3:	6a 4f                	push   $0x4f
  jmp alltraps
80106ff5:	e9 12 f7 ff ff       	jmp    8010670c <alltraps>

80106ffa <vector80>:
.globl vector80
vector80:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $80
80106ffc:	6a 50                	push   $0x50
  jmp alltraps
80106ffe:	e9 09 f7 ff ff       	jmp    8010670c <alltraps>

80107003 <vector81>:
.globl vector81
vector81:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $81
80107005:	6a 51                	push   $0x51
  jmp alltraps
80107007:	e9 00 f7 ff ff       	jmp    8010670c <alltraps>

8010700c <vector82>:
.globl vector82
vector82:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $82
8010700e:	6a 52                	push   $0x52
  jmp alltraps
80107010:	e9 f7 f6 ff ff       	jmp    8010670c <alltraps>

80107015 <vector83>:
.globl vector83
vector83:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $83
80107017:	6a 53                	push   $0x53
  jmp alltraps
80107019:	e9 ee f6 ff ff       	jmp    8010670c <alltraps>

8010701e <vector84>:
.globl vector84
vector84:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $84
80107020:	6a 54                	push   $0x54
  jmp alltraps
80107022:	e9 e5 f6 ff ff       	jmp    8010670c <alltraps>

80107027 <vector85>:
.globl vector85
vector85:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $85
80107029:	6a 55                	push   $0x55
  jmp alltraps
8010702b:	e9 dc f6 ff ff       	jmp    8010670c <alltraps>

80107030 <vector86>:
.globl vector86
vector86:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $86
80107032:	6a 56                	push   $0x56
  jmp alltraps
80107034:	e9 d3 f6 ff ff       	jmp    8010670c <alltraps>

80107039 <vector87>:
.globl vector87
vector87:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $87
8010703b:	6a 57                	push   $0x57
  jmp alltraps
8010703d:	e9 ca f6 ff ff       	jmp    8010670c <alltraps>

80107042 <vector88>:
.globl vector88
vector88:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $88
80107044:	6a 58                	push   $0x58
  jmp alltraps
80107046:	e9 c1 f6 ff ff       	jmp    8010670c <alltraps>

8010704b <vector89>:
.globl vector89
vector89:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $89
8010704d:	6a 59                	push   $0x59
  jmp alltraps
8010704f:	e9 b8 f6 ff ff       	jmp    8010670c <alltraps>

80107054 <vector90>:
.globl vector90
vector90:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $90
80107056:	6a 5a                	push   $0x5a
  jmp alltraps
80107058:	e9 af f6 ff ff       	jmp    8010670c <alltraps>

8010705d <vector91>:
.globl vector91
vector91:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $91
8010705f:	6a 5b                	push   $0x5b
  jmp alltraps
80107061:	e9 a6 f6 ff ff       	jmp    8010670c <alltraps>

80107066 <vector92>:
.globl vector92
vector92:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $92
80107068:	6a 5c                	push   $0x5c
  jmp alltraps
8010706a:	e9 9d f6 ff ff       	jmp    8010670c <alltraps>

8010706f <vector93>:
.globl vector93
vector93:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $93
80107071:	6a 5d                	push   $0x5d
  jmp alltraps
80107073:	e9 94 f6 ff ff       	jmp    8010670c <alltraps>

80107078 <vector94>:
.globl vector94
vector94:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $94
8010707a:	6a 5e                	push   $0x5e
  jmp alltraps
8010707c:	e9 8b f6 ff ff       	jmp    8010670c <alltraps>

80107081 <vector95>:
.globl vector95
vector95:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $95
80107083:	6a 5f                	push   $0x5f
  jmp alltraps
80107085:	e9 82 f6 ff ff       	jmp    8010670c <alltraps>

8010708a <vector96>:
.globl vector96
vector96:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $96
8010708c:	6a 60                	push   $0x60
  jmp alltraps
8010708e:	e9 79 f6 ff ff       	jmp    8010670c <alltraps>

80107093 <vector97>:
.globl vector97
vector97:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $97
80107095:	6a 61                	push   $0x61
  jmp alltraps
80107097:	e9 70 f6 ff ff       	jmp    8010670c <alltraps>

8010709c <vector98>:
.globl vector98
vector98:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $98
8010709e:	6a 62                	push   $0x62
  jmp alltraps
801070a0:	e9 67 f6 ff ff       	jmp    8010670c <alltraps>

801070a5 <vector99>:
.globl vector99
vector99:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $99
801070a7:	6a 63                	push   $0x63
  jmp alltraps
801070a9:	e9 5e f6 ff ff       	jmp    8010670c <alltraps>

801070ae <vector100>:
.globl vector100
vector100:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $100
801070b0:	6a 64                	push   $0x64
  jmp alltraps
801070b2:	e9 55 f6 ff ff       	jmp    8010670c <alltraps>

801070b7 <vector101>:
.globl vector101
vector101:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $101
801070b9:	6a 65                	push   $0x65
  jmp alltraps
801070bb:	e9 4c f6 ff ff       	jmp    8010670c <alltraps>

801070c0 <vector102>:
.globl vector102
vector102:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $102
801070c2:	6a 66                	push   $0x66
  jmp alltraps
801070c4:	e9 43 f6 ff ff       	jmp    8010670c <alltraps>

801070c9 <vector103>:
.globl vector103
vector103:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $103
801070cb:	6a 67                	push   $0x67
  jmp alltraps
801070cd:	e9 3a f6 ff ff       	jmp    8010670c <alltraps>

801070d2 <vector104>:
.globl vector104
vector104:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $104
801070d4:	6a 68                	push   $0x68
  jmp alltraps
801070d6:	e9 31 f6 ff ff       	jmp    8010670c <alltraps>

801070db <vector105>:
.globl vector105
vector105:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $105
801070dd:	6a 69                	push   $0x69
  jmp alltraps
801070df:	e9 28 f6 ff ff       	jmp    8010670c <alltraps>

801070e4 <vector106>:
.globl vector106
vector106:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $106
801070e6:	6a 6a                	push   $0x6a
  jmp alltraps
801070e8:	e9 1f f6 ff ff       	jmp    8010670c <alltraps>

801070ed <vector107>:
.globl vector107
vector107:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $107
801070ef:	6a 6b                	push   $0x6b
  jmp alltraps
801070f1:	e9 16 f6 ff ff       	jmp    8010670c <alltraps>

801070f6 <vector108>:
.globl vector108
vector108:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $108
801070f8:	6a 6c                	push   $0x6c
  jmp alltraps
801070fa:	e9 0d f6 ff ff       	jmp    8010670c <alltraps>

801070ff <vector109>:
.globl vector109
vector109:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $109
80107101:	6a 6d                	push   $0x6d
  jmp alltraps
80107103:	e9 04 f6 ff ff       	jmp    8010670c <alltraps>

80107108 <vector110>:
.globl vector110
vector110:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $110
8010710a:	6a 6e                	push   $0x6e
  jmp alltraps
8010710c:	e9 fb f5 ff ff       	jmp    8010670c <alltraps>

80107111 <vector111>:
.globl vector111
vector111:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $111
80107113:	6a 6f                	push   $0x6f
  jmp alltraps
80107115:	e9 f2 f5 ff ff       	jmp    8010670c <alltraps>

8010711a <vector112>:
.globl vector112
vector112:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $112
8010711c:	6a 70                	push   $0x70
  jmp alltraps
8010711e:	e9 e9 f5 ff ff       	jmp    8010670c <alltraps>

80107123 <vector113>:
.globl vector113
vector113:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $113
80107125:	6a 71                	push   $0x71
  jmp alltraps
80107127:	e9 e0 f5 ff ff       	jmp    8010670c <alltraps>

8010712c <vector114>:
.globl vector114
vector114:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $114
8010712e:	6a 72                	push   $0x72
  jmp alltraps
80107130:	e9 d7 f5 ff ff       	jmp    8010670c <alltraps>

80107135 <vector115>:
.globl vector115
vector115:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $115
80107137:	6a 73                	push   $0x73
  jmp alltraps
80107139:	e9 ce f5 ff ff       	jmp    8010670c <alltraps>

8010713e <vector116>:
.globl vector116
vector116:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $116
80107140:	6a 74                	push   $0x74
  jmp alltraps
80107142:	e9 c5 f5 ff ff       	jmp    8010670c <alltraps>

80107147 <vector117>:
.globl vector117
vector117:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $117
80107149:	6a 75                	push   $0x75
  jmp alltraps
8010714b:	e9 bc f5 ff ff       	jmp    8010670c <alltraps>

80107150 <vector118>:
.globl vector118
vector118:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $118
80107152:	6a 76                	push   $0x76
  jmp alltraps
80107154:	e9 b3 f5 ff ff       	jmp    8010670c <alltraps>

80107159 <vector119>:
.globl vector119
vector119:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $119
8010715b:	6a 77                	push   $0x77
  jmp alltraps
8010715d:	e9 aa f5 ff ff       	jmp    8010670c <alltraps>

80107162 <vector120>:
.globl vector120
vector120:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $120
80107164:	6a 78                	push   $0x78
  jmp alltraps
80107166:	e9 a1 f5 ff ff       	jmp    8010670c <alltraps>

8010716b <vector121>:
.globl vector121
vector121:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $121
8010716d:	6a 79                	push   $0x79
  jmp alltraps
8010716f:	e9 98 f5 ff ff       	jmp    8010670c <alltraps>

80107174 <vector122>:
.globl vector122
vector122:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $122
80107176:	6a 7a                	push   $0x7a
  jmp alltraps
80107178:	e9 8f f5 ff ff       	jmp    8010670c <alltraps>

8010717d <vector123>:
.globl vector123
vector123:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $123
8010717f:	6a 7b                	push   $0x7b
  jmp alltraps
80107181:	e9 86 f5 ff ff       	jmp    8010670c <alltraps>

80107186 <vector124>:
.globl vector124
vector124:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $124
80107188:	6a 7c                	push   $0x7c
  jmp alltraps
8010718a:	e9 7d f5 ff ff       	jmp    8010670c <alltraps>

8010718f <vector125>:
.globl vector125
vector125:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $125
80107191:	6a 7d                	push   $0x7d
  jmp alltraps
80107193:	e9 74 f5 ff ff       	jmp    8010670c <alltraps>

80107198 <vector126>:
.globl vector126
vector126:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $126
8010719a:	6a 7e                	push   $0x7e
  jmp alltraps
8010719c:	e9 6b f5 ff ff       	jmp    8010670c <alltraps>

801071a1 <vector127>:
.globl vector127
vector127:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $127
801071a3:	6a 7f                	push   $0x7f
  jmp alltraps
801071a5:	e9 62 f5 ff ff       	jmp    8010670c <alltraps>

801071aa <vector128>:
.globl vector128
vector128:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $128
801071ac:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071b1:	e9 56 f5 ff ff       	jmp    8010670c <alltraps>

801071b6 <vector129>:
.globl vector129
vector129:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $129
801071b8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801071bd:	e9 4a f5 ff ff       	jmp    8010670c <alltraps>

801071c2 <vector130>:
.globl vector130
vector130:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $130
801071c4:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071c9:	e9 3e f5 ff ff       	jmp    8010670c <alltraps>

801071ce <vector131>:
.globl vector131
vector131:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $131
801071d0:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071d5:	e9 32 f5 ff ff       	jmp    8010670c <alltraps>

801071da <vector132>:
.globl vector132
vector132:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $132
801071dc:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071e1:	e9 26 f5 ff ff       	jmp    8010670c <alltraps>

801071e6 <vector133>:
.globl vector133
vector133:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $133
801071e8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071ed:	e9 1a f5 ff ff       	jmp    8010670c <alltraps>

801071f2 <vector134>:
.globl vector134
vector134:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $134
801071f4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071f9:	e9 0e f5 ff ff       	jmp    8010670c <alltraps>

801071fe <vector135>:
.globl vector135
vector135:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $135
80107200:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107205:	e9 02 f5 ff ff       	jmp    8010670c <alltraps>

8010720a <vector136>:
.globl vector136
vector136:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $136
8010720c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107211:	e9 f6 f4 ff ff       	jmp    8010670c <alltraps>

80107216 <vector137>:
.globl vector137
vector137:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $137
80107218:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010721d:	e9 ea f4 ff ff       	jmp    8010670c <alltraps>

80107222 <vector138>:
.globl vector138
vector138:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $138
80107224:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107229:	e9 de f4 ff ff       	jmp    8010670c <alltraps>

8010722e <vector139>:
.globl vector139
vector139:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $139
80107230:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107235:	e9 d2 f4 ff ff       	jmp    8010670c <alltraps>

8010723a <vector140>:
.globl vector140
vector140:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $140
8010723c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107241:	e9 c6 f4 ff ff       	jmp    8010670c <alltraps>

80107246 <vector141>:
.globl vector141
vector141:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $141
80107248:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010724d:	e9 ba f4 ff ff       	jmp    8010670c <alltraps>

80107252 <vector142>:
.globl vector142
vector142:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $142
80107254:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107259:	e9 ae f4 ff ff       	jmp    8010670c <alltraps>

8010725e <vector143>:
.globl vector143
vector143:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $143
80107260:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107265:	e9 a2 f4 ff ff       	jmp    8010670c <alltraps>

8010726a <vector144>:
.globl vector144
vector144:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $144
8010726c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107271:	e9 96 f4 ff ff       	jmp    8010670c <alltraps>

80107276 <vector145>:
.globl vector145
vector145:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $145
80107278:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010727d:	e9 8a f4 ff ff       	jmp    8010670c <alltraps>

80107282 <vector146>:
.globl vector146
vector146:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $146
80107284:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107289:	e9 7e f4 ff ff       	jmp    8010670c <alltraps>

8010728e <vector147>:
.globl vector147
vector147:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $147
80107290:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107295:	e9 72 f4 ff ff       	jmp    8010670c <alltraps>

8010729a <vector148>:
.globl vector148
vector148:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $148
8010729c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072a1:	e9 66 f4 ff ff       	jmp    8010670c <alltraps>

801072a6 <vector149>:
.globl vector149
vector149:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $149
801072a8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072ad:	e9 5a f4 ff ff       	jmp    8010670c <alltraps>

801072b2 <vector150>:
.globl vector150
vector150:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $150
801072b4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801072b9:	e9 4e f4 ff ff       	jmp    8010670c <alltraps>

801072be <vector151>:
.globl vector151
vector151:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $151
801072c0:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801072c5:	e9 42 f4 ff ff       	jmp    8010670c <alltraps>

801072ca <vector152>:
.globl vector152
vector152:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $152
801072cc:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072d1:	e9 36 f4 ff ff       	jmp    8010670c <alltraps>

801072d6 <vector153>:
.globl vector153
vector153:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $153
801072d8:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072dd:	e9 2a f4 ff ff       	jmp    8010670c <alltraps>

801072e2 <vector154>:
.globl vector154
vector154:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $154
801072e4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072e9:	e9 1e f4 ff ff       	jmp    8010670c <alltraps>

801072ee <vector155>:
.globl vector155
vector155:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $155
801072f0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072f5:	e9 12 f4 ff ff       	jmp    8010670c <alltraps>

801072fa <vector156>:
.globl vector156
vector156:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $156
801072fc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107301:	e9 06 f4 ff ff       	jmp    8010670c <alltraps>

80107306 <vector157>:
.globl vector157
vector157:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $157
80107308:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010730d:	e9 fa f3 ff ff       	jmp    8010670c <alltraps>

80107312 <vector158>:
.globl vector158
vector158:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $158
80107314:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107319:	e9 ee f3 ff ff       	jmp    8010670c <alltraps>

8010731e <vector159>:
.globl vector159
vector159:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $159
80107320:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107325:	e9 e2 f3 ff ff       	jmp    8010670c <alltraps>

8010732a <vector160>:
.globl vector160
vector160:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $160
8010732c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107331:	e9 d6 f3 ff ff       	jmp    8010670c <alltraps>

80107336 <vector161>:
.globl vector161
vector161:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $161
80107338:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010733d:	e9 ca f3 ff ff       	jmp    8010670c <alltraps>

80107342 <vector162>:
.globl vector162
vector162:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $162
80107344:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107349:	e9 be f3 ff ff       	jmp    8010670c <alltraps>

8010734e <vector163>:
.globl vector163
vector163:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $163
80107350:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107355:	e9 b2 f3 ff ff       	jmp    8010670c <alltraps>

8010735a <vector164>:
.globl vector164
vector164:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $164
8010735c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107361:	e9 a6 f3 ff ff       	jmp    8010670c <alltraps>

80107366 <vector165>:
.globl vector165
vector165:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $165
80107368:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010736d:	e9 9a f3 ff ff       	jmp    8010670c <alltraps>

80107372 <vector166>:
.globl vector166
vector166:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $166
80107374:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107379:	e9 8e f3 ff ff       	jmp    8010670c <alltraps>

8010737e <vector167>:
.globl vector167
vector167:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $167
80107380:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107385:	e9 82 f3 ff ff       	jmp    8010670c <alltraps>

8010738a <vector168>:
.globl vector168
vector168:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $168
8010738c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107391:	e9 76 f3 ff ff       	jmp    8010670c <alltraps>

80107396 <vector169>:
.globl vector169
vector169:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $169
80107398:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010739d:	e9 6a f3 ff ff       	jmp    8010670c <alltraps>

801073a2 <vector170>:
.globl vector170
vector170:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $170
801073a4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073a9:	e9 5e f3 ff ff       	jmp    8010670c <alltraps>

801073ae <vector171>:
.globl vector171
vector171:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $171
801073b0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801073b5:	e9 52 f3 ff ff       	jmp    8010670c <alltraps>

801073ba <vector172>:
.globl vector172
vector172:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $172
801073bc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801073c1:	e9 46 f3 ff ff       	jmp    8010670c <alltraps>

801073c6 <vector173>:
.globl vector173
vector173:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $173
801073c8:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073cd:	e9 3a f3 ff ff       	jmp    8010670c <alltraps>

801073d2 <vector174>:
.globl vector174
vector174:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $174
801073d4:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073d9:	e9 2e f3 ff ff       	jmp    8010670c <alltraps>

801073de <vector175>:
.globl vector175
vector175:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $175
801073e0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073e5:	e9 22 f3 ff ff       	jmp    8010670c <alltraps>

801073ea <vector176>:
.globl vector176
vector176:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $176
801073ec:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073f1:	e9 16 f3 ff ff       	jmp    8010670c <alltraps>

801073f6 <vector177>:
.globl vector177
vector177:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $177
801073f8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073fd:	e9 0a f3 ff ff       	jmp    8010670c <alltraps>

80107402 <vector178>:
.globl vector178
vector178:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $178
80107404:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107409:	e9 fe f2 ff ff       	jmp    8010670c <alltraps>

8010740e <vector179>:
.globl vector179
vector179:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $179
80107410:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107415:	e9 f2 f2 ff ff       	jmp    8010670c <alltraps>

8010741a <vector180>:
.globl vector180
vector180:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $180
8010741c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107421:	e9 e6 f2 ff ff       	jmp    8010670c <alltraps>

80107426 <vector181>:
.globl vector181
vector181:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $181
80107428:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010742d:	e9 da f2 ff ff       	jmp    8010670c <alltraps>

80107432 <vector182>:
.globl vector182
vector182:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $182
80107434:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107439:	e9 ce f2 ff ff       	jmp    8010670c <alltraps>

8010743e <vector183>:
.globl vector183
vector183:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $183
80107440:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107445:	e9 c2 f2 ff ff       	jmp    8010670c <alltraps>

8010744a <vector184>:
.globl vector184
vector184:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $184
8010744c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107451:	e9 b6 f2 ff ff       	jmp    8010670c <alltraps>

80107456 <vector185>:
.globl vector185
vector185:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $185
80107458:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010745d:	e9 aa f2 ff ff       	jmp    8010670c <alltraps>

80107462 <vector186>:
.globl vector186
vector186:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $186
80107464:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107469:	e9 9e f2 ff ff       	jmp    8010670c <alltraps>

8010746e <vector187>:
.globl vector187
vector187:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $187
80107470:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107475:	e9 92 f2 ff ff       	jmp    8010670c <alltraps>

8010747a <vector188>:
.globl vector188
vector188:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $188
8010747c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107481:	e9 86 f2 ff ff       	jmp    8010670c <alltraps>

80107486 <vector189>:
.globl vector189
vector189:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $189
80107488:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010748d:	e9 7a f2 ff ff       	jmp    8010670c <alltraps>

80107492 <vector190>:
.globl vector190
vector190:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $190
80107494:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107499:	e9 6e f2 ff ff       	jmp    8010670c <alltraps>

8010749e <vector191>:
.globl vector191
vector191:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $191
801074a0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074a5:	e9 62 f2 ff ff       	jmp    8010670c <alltraps>

801074aa <vector192>:
.globl vector192
vector192:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $192
801074ac:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074b1:	e9 56 f2 ff ff       	jmp    8010670c <alltraps>

801074b6 <vector193>:
.globl vector193
vector193:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $193
801074b8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801074bd:	e9 4a f2 ff ff       	jmp    8010670c <alltraps>

801074c2 <vector194>:
.globl vector194
vector194:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $194
801074c4:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074c9:	e9 3e f2 ff ff       	jmp    8010670c <alltraps>

801074ce <vector195>:
.globl vector195
vector195:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $195
801074d0:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074d5:	e9 32 f2 ff ff       	jmp    8010670c <alltraps>

801074da <vector196>:
.globl vector196
vector196:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $196
801074dc:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074e1:	e9 26 f2 ff ff       	jmp    8010670c <alltraps>

801074e6 <vector197>:
.globl vector197
vector197:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $197
801074e8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074ed:	e9 1a f2 ff ff       	jmp    8010670c <alltraps>

801074f2 <vector198>:
.globl vector198
vector198:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $198
801074f4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074f9:	e9 0e f2 ff ff       	jmp    8010670c <alltraps>

801074fe <vector199>:
.globl vector199
vector199:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $199
80107500:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107505:	e9 02 f2 ff ff       	jmp    8010670c <alltraps>

8010750a <vector200>:
.globl vector200
vector200:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $200
8010750c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107511:	e9 f6 f1 ff ff       	jmp    8010670c <alltraps>

80107516 <vector201>:
.globl vector201
vector201:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $201
80107518:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010751d:	e9 ea f1 ff ff       	jmp    8010670c <alltraps>

80107522 <vector202>:
.globl vector202
vector202:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $202
80107524:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107529:	e9 de f1 ff ff       	jmp    8010670c <alltraps>

8010752e <vector203>:
.globl vector203
vector203:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $203
80107530:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107535:	e9 d2 f1 ff ff       	jmp    8010670c <alltraps>

8010753a <vector204>:
.globl vector204
vector204:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $204
8010753c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107541:	e9 c6 f1 ff ff       	jmp    8010670c <alltraps>

80107546 <vector205>:
.globl vector205
vector205:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $205
80107548:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010754d:	e9 ba f1 ff ff       	jmp    8010670c <alltraps>

80107552 <vector206>:
.globl vector206
vector206:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $206
80107554:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107559:	e9 ae f1 ff ff       	jmp    8010670c <alltraps>

8010755e <vector207>:
.globl vector207
vector207:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $207
80107560:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107565:	e9 a2 f1 ff ff       	jmp    8010670c <alltraps>

8010756a <vector208>:
.globl vector208
vector208:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $208
8010756c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107571:	e9 96 f1 ff ff       	jmp    8010670c <alltraps>

80107576 <vector209>:
.globl vector209
vector209:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $209
80107578:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010757d:	e9 8a f1 ff ff       	jmp    8010670c <alltraps>

80107582 <vector210>:
.globl vector210
vector210:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $210
80107584:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107589:	e9 7e f1 ff ff       	jmp    8010670c <alltraps>

8010758e <vector211>:
.globl vector211
vector211:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $211
80107590:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107595:	e9 72 f1 ff ff       	jmp    8010670c <alltraps>

8010759a <vector212>:
.globl vector212
vector212:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $212
8010759c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075a1:	e9 66 f1 ff ff       	jmp    8010670c <alltraps>

801075a6 <vector213>:
.globl vector213
vector213:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $213
801075a8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075ad:	e9 5a f1 ff ff       	jmp    8010670c <alltraps>

801075b2 <vector214>:
.globl vector214
vector214:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $214
801075b4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801075b9:	e9 4e f1 ff ff       	jmp    8010670c <alltraps>

801075be <vector215>:
.globl vector215
vector215:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $215
801075c0:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801075c5:	e9 42 f1 ff ff       	jmp    8010670c <alltraps>

801075ca <vector216>:
.globl vector216
vector216:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $216
801075cc:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075d1:	e9 36 f1 ff ff       	jmp    8010670c <alltraps>

801075d6 <vector217>:
.globl vector217
vector217:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $217
801075d8:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075dd:	e9 2a f1 ff ff       	jmp    8010670c <alltraps>

801075e2 <vector218>:
.globl vector218
vector218:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $218
801075e4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075e9:	e9 1e f1 ff ff       	jmp    8010670c <alltraps>

801075ee <vector219>:
.globl vector219
vector219:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $219
801075f0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075f5:	e9 12 f1 ff ff       	jmp    8010670c <alltraps>

801075fa <vector220>:
.globl vector220
vector220:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $220
801075fc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107601:	e9 06 f1 ff ff       	jmp    8010670c <alltraps>

80107606 <vector221>:
.globl vector221
vector221:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $221
80107608:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010760d:	e9 fa f0 ff ff       	jmp    8010670c <alltraps>

80107612 <vector222>:
.globl vector222
vector222:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $222
80107614:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107619:	e9 ee f0 ff ff       	jmp    8010670c <alltraps>

8010761e <vector223>:
.globl vector223
vector223:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $223
80107620:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107625:	e9 e2 f0 ff ff       	jmp    8010670c <alltraps>

8010762a <vector224>:
.globl vector224
vector224:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $224
8010762c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107631:	e9 d6 f0 ff ff       	jmp    8010670c <alltraps>

80107636 <vector225>:
.globl vector225
vector225:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $225
80107638:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010763d:	e9 ca f0 ff ff       	jmp    8010670c <alltraps>

80107642 <vector226>:
.globl vector226
vector226:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $226
80107644:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107649:	e9 be f0 ff ff       	jmp    8010670c <alltraps>

8010764e <vector227>:
.globl vector227
vector227:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $227
80107650:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107655:	e9 b2 f0 ff ff       	jmp    8010670c <alltraps>

8010765a <vector228>:
.globl vector228
vector228:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $228
8010765c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107661:	e9 a6 f0 ff ff       	jmp    8010670c <alltraps>

80107666 <vector229>:
.globl vector229
vector229:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $229
80107668:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010766d:	e9 9a f0 ff ff       	jmp    8010670c <alltraps>

80107672 <vector230>:
.globl vector230
vector230:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $230
80107674:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107679:	e9 8e f0 ff ff       	jmp    8010670c <alltraps>

8010767e <vector231>:
.globl vector231
vector231:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $231
80107680:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107685:	e9 82 f0 ff ff       	jmp    8010670c <alltraps>

8010768a <vector232>:
.globl vector232
vector232:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $232
8010768c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107691:	e9 76 f0 ff ff       	jmp    8010670c <alltraps>

80107696 <vector233>:
.globl vector233
vector233:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $233
80107698:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010769d:	e9 6a f0 ff ff       	jmp    8010670c <alltraps>

801076a2 <vector234>:
.globl vector234
vector234:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $234
801076a4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076a9:	e9 5e f0 ff ff       	jmp    8010670c <alltraps>

801076ae <vector235>:
.globl vector235
vector235:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $235
801076b0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801076b5:	e9 52 f0 ff ff       	jmp    8010670c <alltraps>

801076ba <vector236>:
.globl vector236
vector236:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $236
801076bc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801076c1:	e9 46 f0 ff ff       	jmp    8010670c <alltraps>

801076c6 <vector237>:
.globl vector237
vector237:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $237
801076c8:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076cd:	e9 3a f0 ff ff       	jmp    8010670c <alltraps>

801076d2 <vector238>:
.globl vector238
vector238:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $238
801076d4:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076d9:	e9 2e f0 ff ff       	jmp    8010670c <alltraps>

801076de <vector239>:
.globl vector239
vector239:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $239
801076e0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076e5:	e9 22 f0 ff ff       	jmp    8010670c <alltraps>

801076ea <vector240>:
.globl vector240
vector240:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $240
801076ec:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076f1:	e9 16 f0 ff ff       	jmp    8010670c <alltraps>

801076f6 <vector241>:
.globl vector241
vector241:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $241
801076f8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076fd:	e9 0a f0 ff ff       	jmp    8010670c <alltraps>

80107702 <vector242>:
.globl vector242
vector242:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $242
80107704:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107709:	e9 fe ef ff ff       	jmp    8010670c <alltraps>

8010770e <vector243>:
.globl vector243
vector243:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $243
80107710:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107715:	e9 f2 ef ff ff       	jmp    8010670c <alltraps>

8010771a <vector244>:
.globl vector244
vector244:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $244
8010771c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107721:	e9 e6 ef ff ff       	jmp    8010670c <alltraps>

80107726 <vector245>:
.globl vector245
vector245:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $245
80107728:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010772d:	e9 da ef ff ff       	jmp    8010670c <alltraps>

80107732 <vector246>:
.globl vector246
vector246:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $246
80107734:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107739:	e9 ce ef ff ff       	jmp    8010670c <alltraps>

8010773e <vector247>:
.globl vector247
vector247:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $247
80107740:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107745:	e9 c2 ef ff ff       	jmp    8010670c <alltraps>

8010774a <vector248>:
.globl vector248
vector248:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $248
8010774c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107751:	e9 b6 ef ff ff       	jmp    8010670c <alltraps>

80107756 <vector249>:
.globl vector249
vector249:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $249
80107758:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010775d:	e9 aa ef ff ff       	jmp    8010670c <alltraps>

80107762 <vector250>:
.globl vector250
vector250:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $250
80107764:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107769:	e9 9e ef ff ff       	jmp    8010670c <alltraps>

8010776e <vector251>:
.globl vector251
vector251:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $251
80107770:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107775:	e9 92 ef ff ff       	jmp    8010670c <alltraps>

8010777a <vector252>:
.globl vector252
vector252:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $252
8010777c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107781:	e9 86 ef ff ff       	jmp    8010670c <alltraps>

80107786 <vector253>:
.globl vector253
vector253:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $253
80107788:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010778d:	e9 7a ef ff ff       	jmp    8010670c <alltraps>

80107792 <vector254>:
.globl vector254
vector254:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $254
80107794:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107799:	e9 6e ef ff ff       	jmp    8010670c <alltraps>

8010779e <vector255>:
.globl vector255
vector255:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $255
801077a0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077a5:	e9 62 ef ff ff       	jmp    8010670c <alltraps>
	...

801077ac <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801077ac:	55                   	push   %ebp
801077ad:	89 e5                	mov    %esp,%ebp
801077af:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801077b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801077b5:	48                   	dec    %eax
801077b6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801077ba:	8b 45 08             	mov    0x8(%ebp),%eax
801077bd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801077c1:	8b 45 08             	mov    0x8(%ebp),%eax
801077c4:	c1 e8 10             	shr    $0x10,%eax
801077c7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801077cb:	8d 45 fa             	lea    -0x6(%ebp),%eax
801077ce:	0f 01 10             	lgdtl  (%eax)
}
801077d1:	c9                   	leave  
801077d2:	c3                   	ret    

801077d3 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801077d3:	55                   	push   %ebp
801077d4:	89 e5                	mov    %esp,%ebp
801077d6:	83 ec 04             	sub    $0x4,%esp
801077d9:	8b 45 08             	mov    0x8(%ebp),%eax
801077dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801077e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801077e3:	0f 00 d8             	ltr    %ax
}
801077e6:	c9                   	leave  
801077e7:	c3                   	ret    

801077e8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
801077e8:	55                   	push   %ebp
801077e9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077eb:	8b 45 08             	mov    0x8(%ebp),%eax
801077ee:	0f 22 d8             	mov    %eax,%cr3
}
801077f1:	5d                   	pop    %ebp
801077f2:	c3                   	ret    

801077f3 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077f3:	55                   	push   %ebp
801077f4:	89 e5                	mov    %esp,%ebp
801077f6:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801077f9:	e8 50 c9 ff ff       	call   8010414e <cpuid>
801077fe:	89 c2                	mov    %eax,%edx
80107800:	89 d0                	mov    %edx,%eax
80107802:	c1 e0 02             	shl    $0x2,%eax
80107805:	01 d0                	add    %edx,%eax
80107807:	01 c0                	add    %eax,%eax
80107809:	01 d0                	add    %edx,%eax
8010780b:	c1 e0 04             	shl    $0x4,%eax
8010780e:	05 00 3b 11 80       	add    $0x80113b00,%eax
80107813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107819:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010782f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107832:	8a 50 7d             	mov    0x7d(%eax),%dl
80107835:	83 e2 f0             	and    $0xfffffff0,%edx
80107838:	83 ca 0a             	or     $0xa,%edx
8010783b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010783e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107841:	8a 50 7d             	mov    0x7d(%eax),%dl
80107844:	83 ca 10             	or     $0x10,%edx
80107847:	88 50 7d             	mov    %dl,0x7d(%eax)
8010784a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784d:	8a 50 7d             	mov    0x7d(%eax),%dl
80107850:	83 e2 9f             	and    $0xffffff9f,%edx
80107853:	88 50 7d             	mov    %dl,0x7d(%eax)
80107856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107859:	8a 50 7d             	mov    0x7d(%eax),%dl
8010785c:	83 ca 80             	or     $0xffffff80,%edx
8010785f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107865:	8a 50 7e             	mov    0x7e(%eax),%dl
80107868:	83 ca 0f             	or     $0xf,%edx
8010786b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010786e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107871:	8a 50 7e             	mov    0x7e(%eax),%dl
80107874:	83 e2 ef             	and    $0xffffffef,%edx
80107877:	88 50 7e             	mov    %dl,0x7e(%eax)
8010787a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787d:	8a 50 7e             	mov    0x7e(%eax),%dl
80107880:	83 e2 df             	and    $0xffffffdf,%edx
80107883:	88 50 7e             	mov    %dl,0x7e(%eax)
80107886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107889:	8a 50 7e             	mov    0x7e(%eax),%dl
8010788c:	83 ca 40             	or     $0x40,%edx
8010788f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107895:	8a 50 7e             	mov    0x7e(%eax),%dl
80107898:	83 ca 80             	or     $0xffffff80,%edx
8010789b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a8:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801078af:	ff ff 
801078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b4:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801078bb:	00 00 
801078bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ca:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801078d0:	83 e2 f0             	and    $0xfffffff0,%edx
801078d3:	83 ca 02             	or     $0x2,%edx
801078d6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078df:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801078e5:	83 ca 10             	or     $0x10,%edx
801078e8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f1:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801078f7:	83 e2 9f             	and    $0xffffff9f,%edx
801078fa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107903:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107909:	83 ca 80             	or     $0xffffff80,%edx
8010790c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107915:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010791b:	83 ca 0f             	or     $0xf,%edx
8010791e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107927:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010792d:	83 e2 ef             	and    $0xffffffef,%edx
80107930:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107939:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010793f:	83 e2 df             	and    $0xffffffdf,%edx
80107942:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794b:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107951:	83 ca 40             	or     $0x40,%edx
80107954:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010795a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795d:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107963:	83 ca 80             	or     $0xffffff80,%edx
80107966:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010796c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796f:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107979:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107980:	ff ff 
80107982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107985:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010798c:	00 00 
8010798e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107991:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799b:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801079a1:	83 e2 f0             	and    $0xfffffff0,%edx
801079a4:	83 ca 0a             	or     $0xa,%edx
801079a7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b0:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801079b6:	83 ca 10             	or     $0x10,%edx
801079b9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c2:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801079c8:	83 ca 60             	or     $0x60,%edx
801079cb:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d4:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801079da:	83 ca 80             	or     $0xffffff80,%edx
801079dd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e6:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801079ec:	83 ca 0f             	or     $0xf,%edx
801079ef:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f8:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801079fe:	83 e2 ef             	and    $0xffffffef,%edx
80107a01:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0a:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107a10:	83 e2 df             	and    $0xffffffdf,%edx
80107a13:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1c:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107a22:	83 ca 40             	or     $0x40,%edx
80107a25:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2e:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107a34:	83 ca 80             	or     $0xffffff80,%edx
80107a37:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a40:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4a:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a51:	ff ff 
80107a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a56:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a5d:	00 00 
80107a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a62:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107a72:	83 e2 f0             	and    $0xfffffff0,%edx
80107a75:	83 ca 02             	or     $0x2,%edx
80107a78:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a81:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107a87:	83 ca 10             	or     $0x10,%edx
80107a8a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a93:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107a99:	83 ca 60             	or     $0x60,%edx
80107a9c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa5:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107aab:	83 ca 80             	or     $0xffffff80,%edx
80107aae:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107abd:	83 ca 0f             	or     $0xf,%edx
80107ac0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac9:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107acf:	83 e2 ef             	and    $0xffffffef,%edx
80107ad2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adb:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107ae1:	83 e2 df             	and    $0xffffffdf,%edx
80107ae4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aed:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107af3:	83 ca 40             	or     $0x40,%edx
80107af6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aff:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107b05:	83 ca 80             	or     $0xffffff80,%edx
80107b08:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b11:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1b:	83 c0 70             	add    $0x70,%eax
80107b1e:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107b25:	00 
80107b26:	89 04 24             	mov    %eax,(%esp)
80107b29:	e8 7e fc ff ff       	call   801077ac <lgdt>
}
80107b2e:	c9                   	leave  
80107b2f:	c3                   	ret    

80107b30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b36:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b39:	c1 e8 16             	shr    $0x16,%eax
80107b3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b43:	8b 45 08             	mov    0x8(%ebp),%eax
80107b46:	01 d0                	add    %edx,%eax
80107b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b4e:	8b 00                	mov    (%eax),%eax
80107b50:	83 e0 01             	and    $0x1,%eax
80107b53:	85 c0                	test   %eax,%eax
80107b55:	74 14                	je     80107b6b <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b5a:	8b 00                	mov    (%eax),%eax
80107b5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b61:	05 00 00 00 80       	add    $0x80000000,%eax
80107b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b69:	eb 48                	jmp    80107bb3 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b6f:	74 0e                	je     80107b7f <walkpgdir+0x4f>
80107b71:	e8 e1 b0 ff ff       	call   80102c57 <kalloc>
80107b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b7d:	75 07                	jne    80107b86 <walkpgdir+0x56>
      return 0;
80107b7f:	b8 00 00 00 00       	mov    $0x0,%eax
80107b84:	eb 44                	jmp    80107bca <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b86:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b8d:	00 
80107b8e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b95:	00 
80107b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b99:	89 04 24             	mov    %eax,(%esp)
80107b9c:	e8 e9 d4 ff ff       	call   8010508a <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ba9:	83 c8 07             	or     $0x7,%eax
80107bac:	89 c2                	mov    %eax,%edx
80107bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bb1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bb6:	c1 e8 0c             	shr    $0xc,%eax
80107bb9:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc8:	01 d0                	add    %edx,%eax
}
80107bca:	c9                   	leave  
80107bcb:	c3                   	ret    

80107bcc <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bcc:	55                   	push   %ebp
80107bcd:	89 e5                	mov    %esp,%ebp
80107bcf:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
80107be0:	8b 45 10             	mov    0x10(%ebp),%eax
80107be3:	01 d0                	add    %edx,%eax
80107be5:	48                   	dec    %eax
80107be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107bf5:	00 
80107bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80107c00:	89 04 24             	mov    %eax,(%esp)
80107c03:	e8 28 ff ff ff       	call   80107b30 <walkpgdir>
80107c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c0f:	75 07                	jne    80107c18 <mappages+0x4c>
      return -1;
80107c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c16:	eb 48                	jmp    80107c60 <mappages+0x94>
    if(*pte & PTE_P)
80107c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c1b:	8b 00                	mov    (%eax),%eax
80107c1d:	83 e0 01             	and    $0x1,%eax
80107c20:	85 c0                	test   %eax,%eax
80107c22:	74 0c                	je     80107c30 <mappages+0x64>
      panic("remap");
80107c24:	c7 04 24 80 8d 10 80 	movl   $0x80108d80,(%esp)
80107c2b:	e8 24 89 ff ff       	call   80100554 <panic>
    *pte = pa | perm | PTE_P;
80107c30:	8b 45 18             	mov    0x18(%ebp),%eax
80107c33:	0b 45 14             	or     0x14(%ebp),%eax
80107c36:	83 c8 01             	or     $0x1,%eax
80107c39:	89 c2                	mov    %eax,%edx
80107c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c3e:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c46:	75 08                	jne    80107c50 <mappages+0x84>
      break;
80107c48:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c49:	b8 00 00 00 00       	mov    $0x0,%eax
80107c4e:	eb 10                	jmp    80107c60 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c57:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c5e:	eb 8e                	jmp    80107bee <mappages+0x22>
  return 0;
}
80107c60:	c9                   	leave  
80107c61:	c3                   	ret    

80107c62 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c62:	55                   	push   %ebp
80107c63:	89 e5                	mov    %esp,%ebp
80107c65:	53                   	push   %ebx
80107c66:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c69:	e8 e9 af ff ff       	call   80102c57 <kalloc>
80107c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c75:	75 0a                	jne    80107c81 <setupkvm+0x1f>
    return 0;
80107c77:	b8 00 00 00 00       	mov    $0x0,%eax
80107c7c:	e9 84 00 00 00       	jmp    80107d05 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107c81:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c88:	00 
80107c89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c90:	00 
80107c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c94:	89 04 24             	mov    %eax,(%esp)
80107c97:	e8 ee d3 ff ff       	call   8010508a <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c9c:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107ca3:	eb 54                	jmp    80107cf9 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca8:	8b 48 0c             	mov    0xc(%eax),%ecx
80107cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cae:	8b 50 04             	mov    0x4(%eax),%edx
80107cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb4:	8b 58 08             	mov    0x8(%eax),%ebx
80107cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cba:	8b 40 04             	mov    0x4(%eax),%eax
80107cbd:	29 c3                	sub    %eax,%ebx
80107cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc2:	8b 00                	mov    (%eax),%eax
80107cc4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107cc8:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ccc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cd7:	89 04 24             	mov    %eax,(%esp)
80107cda:	e8 ed fe ff ff       	call   80107bcc <mappages>
80107cdf:	85 c0                	test   %eax,%eax
80107ce1:	79 12                	jns    80107cf5 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ce6:	89 04 24             	mov    %eax,(%esp)
80107ce9:	e8 1a 05 00 00       	call   80108208 <freevm>
      return 0;
80107cee:	b8 00 00 00 00       	mov    $0x0,%eax
80107cf3:	eb 10                	jmp    80107d05 <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cf5:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107cf9:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107d00:	72 a3                	jb     80107ca5 <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
80107d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d05:	83 c4 34             	add    $0x34,%esp
80107d08:	5b                   	pop    %ebx
80107d09:	5d                   	pop    %ebp
80107d0a:	c3                   	ret    

80107d0b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d0b:	55                   	push   %ebp
80107d0c:	89 e5                	mov    %esp,%ebp
80107d0e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d11:	e8 4c ff ff ff       	call   80107c62 <setupkvm>
80107d16:	a3 24 68 11 80       	mov    %eax,0x80116824
  switchkvm();
80107d1b:	e8 02 00 00 00       	call   80107d22 <switchkvm>
}
80107d20:	c9                   	leave  
80107d21:	c3                   	ret    

80107d22 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d22:	55                   	push   %ebp
80107d23:	89 e5                	mov    %esp,%ebp
80107d25:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d28:	a1 24 68 11 80       	mov    0x80116824,%eax
80107d2d:	05 00 00 00 80       	add    $0x80000000,%eax
80107d32:	89 04 24             	mov    %eax,(%esp)
80107d35:	e8 ae fa ff ff       	call   801077e8 <lcr3>
}
80107d3a:	c9                   	leave  
80107d3b:	c3                   	ret    

80107d3c <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d3c:	55                   	push   %ebp
80107d3d:	89 e5                	mov    %esp,%ebp
80107d3f:	57                   	push   %edi
80107d40:	56                   	push   %esi
80107d41:	53                   	push   %ebx
80107d42:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d49:	75 0c                	jne    80107d57 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107d4b:	c7 04 24 86 8d 10 80 	movl   $0x80108d86,(%esp)
80107d52:	e8 fd 87 ff ff       	call   80100554 <panic>
  if(p->kstack == 0)
80107d57:	8b 45 08             	mov    0x8(%ebp),%eax
80107d5a:	8b 40 08             	mov    0x8(%eax),%eax
80107d5d:	85 c0                	test   %eax,%eax
80107d5f:	75 0c                	jne    80107d6d <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107d61:	c7 04 24 9c 8d 10 80 	movl   $0x80108d9c,(%esp)
80107d68:	e8 e7 87 ff ff       	call   80100554 <panic>
  if(p->pgdir == 0)
80107d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d70:	8b 40 04             	mov    0x4(%eax),%eax
80107d73:	85 c0                	test   %eax,%eax
80107d75:	75 0c                	jne    80107d83 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107d77:	c7 04 24 b1 8d 10 80 	movl   $0x80108db1,(%esp)
80107d7e:	e8 d1 87 ff ff       	call   80100554 <panic>

  pushcli();
80107d83:	e8 fe d1 ff ff       	call   80104f86 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d88:	e8 06 c4 ff ff       	call   80104193 <mycpu>
80107d8d:	89 c3                	mov    %eax,%ebx
80107d8f:	e8 ff c3 ff ff       	call   80104193 <mycpu>
80107d94:	83 c0 08             	add    $0x8,%eax
80107d97:	89 c6                	mov    %eax,%esi
80107d99:	e8 f5 c3 ff ff       	call   80104193 <mycpu>
80107d9e:	83 c0 08             	add    $0x8,%eax
80107da1:	c1 e8 10             	shr    $0x10,%eax
80107da4:	89 c7                	mov    %eax,%edi
80107da6:	e8 e8 c3 ff ff       	call   80104193 <mycpu>
80107dab:	83 c0 08             	add    $0x8,%eax
80107dae:	c1 e8 18             	shr    $0x18,%eax
80107db1:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107db8:	67 00 
80107dba:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107dc1:	89 f9                	mov    %edi,%ecx
80107dc3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107dc9:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107dcf:	83 e2 f0             	and    $0xfffffff0,%edx
80107dd2:	83 ca 09             	or     $0x9,%edx
80107dd5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107ddb:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107de1:	83 ca 10             	or     $0x10,%edx
80107de4:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107dea:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107df0:	83 e2 9f             	and    $0xffffff9f,%edx
80107df3:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107df9:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107dff:	83 ca 80             	or     $0xffffff80,%edx
80107e02:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e08:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107e0e:	83 e2 f0             	and    $0xfffffff0,%edx
80107e11:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e17:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107e1d:	83 e2 ef             	and    $0xffffffef,%edx
80107e20:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e26:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107e2c:	83 e2 df             	and    $0xffffffdf,%edx
80107e2f:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e35:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107e3b:	83 ca 40             	or     $0x40,%edx
80107e3e:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e44:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107e4a:	83 e2 7f             	and    $0x7f,%edx
80107e4d:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e53:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107e59:	e8 35 c3 ff ff       	call   80104193 <mycpu>
80107e5e:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107e64:	83 e2 ef             	and    $0xffffffef,%edx
80107e67:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e6d:	e8 21 c3 ff ff       	call   80104193 <mycpu>
80107e72:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e78:	e8 16 c3 ff ff       	call   80104193 <mycpu>
80107e7d:	8b 55 08             	mov    0x8(%ebp),%edx
80107e80:	8b 52 08             	mov    0x8(%edx),%edx
80107e83:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e89:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e8c:	e8 02 c3 ff ff       	call   80104193 <mycpu>
80107e91:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107e97:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107e9e:	e8 30 f9 ff ff       	call   801077d3 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107ea3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea6:	8b 40 04             	mov    0x4(%eax),%eax
80107ea9:	05 00 00 00 80       	add    $0x80000000,%eax
80107eae:	89 04 24             	mov    %eax,(%esp)
80107eb1:	e8 32 f9 ff ff       	call   801077e8 <lcr3>
  popcli();
80107eb6:	e8 15 d1 ff ff       	call   80104fd0 <popcli>
}
80107ebb:	83 c4 1c             	add    $0x1c,%esp
80107ebe:	5b                   	pop    %ebx
80107ebf:	5e                   	pop    %esi
80107ec0:	5f                   	pop    %edi
80107ec1:	5d                   	pop    %ebp
80107ec2:	c3                   	ret    

80107ec3 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ec3:	55                   	push   %ebp
80107ec4:	89 e5                	mov    %esp,%ebp
80107ec6:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107ec9:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ed0:	76 0c                	jbe    80107ede <inituvm+0x1b>
    panic("inituvm: more than a page");
80107ed2:	c7 04 24 c5 8d 10 80 	movl   $0x80108dc5,(%esp)
80107ed9:	e8 76 86 ff ff       	call   80100554 <panic>
  mem = kalloc();
80107ede:	e8 74 ad ff ff       	call   80102c57 <kalloc>
80107ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ee6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107eed:	00 
80107eee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ef5:	00 
80107ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef9:	89 04 24             	mov    %eax,(%esp)
80107efc:	e8 89 d1 ff ff       	call   8010508a <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f04:	05 00 00 00 80       	add    $0x80000000,%eax
80107f09:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107f10:	00 
80107f11:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107f15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f1c:	00 
80107f1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f24:	00 
80107f25:	8b 45 08             	mov    0x8(%ebp),%eax
80107f28:	89 04 24             	mov    %eax,(%esp)
80107f2b:	e8 9c fc ff ff       	call   80107bcc <mappages>
  memmove(mem, init, sz);
80107f30:	8b 45 10             	mov    0x10(%ebp),%eax
80107f33:	89 44 24 08          	mov    %eax,0x8(%esp)
80107f37:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f41:	89 04 24             	mov    %eax,(%esp)
80107f44:	e8 0a d2 ff ff       	call   80105153 <memmove>
}
80107f49:	c9                   	leave  
80107f4a:	c3                   	ret    

80107f4b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f4b:	55                   	push   %ebp
80107f4c:	89 e5                	mov    %esp,%ebp
80107f4e:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f51:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f54:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f59:	85 c0                	test   %eax,%eax
80107f5b:	74 0c                	je     80107f69 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107f5d:	c7 04 24 e0 8d 10 80 	movl   $0x80108de0,(%esp)
80107f64:	e8 eb 85 ff ff       	call   80100554 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f70:	e9 a6 00 00 00       	jmp    8010801b <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f7b:	01 d0                	add    %edx,%eax
80107f7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f84:	00 
80107f85:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f89:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8c:	89 04 24             	mov    %eax,(%esp)
80107f8f:	e8 9c fb ff ff       	call   80107b30 <walkpgdir>
80107f94:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f9b:	75 0c                	jne    80107fa9 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107f9d:	c7 04 24 03 8e 10 80 	movl   $0x80108e03,(%esp)
80107fa4:	e8 ab 85 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80107fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fac:	8b 00                	mov    (%eax),%eax
80107fae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb9:	8b 55 18             	mov    0x18(%ebp),%edx
80107fbc:	29 c2                	sub    %eax,%edx
80107fbe:	89 d0                	mov    %edx,%eax
80107fc0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fc5:	77 0f                	ja     80107fd6 <loaduvm+0x8b>
      n = sz - i;
80107fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fca:	8b 55 18             	mov    0x18(%ebp),%edx
80107fcd:	29 c2                	sub    %eax,%edx
80107fcf:	89 d0                	mov    %edx,%eax
80107fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fd4:	eb 07                	jmp    80107fdd <loaduvm+0x92>
    else
      n = PGSIZE;
80107fd6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe0:	8b 55 14             	mov    0x14(%ebp),%edx
80107fe3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fe9:	05 00 00 00 80       	add    $0x80000000,%eax
80107fee:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ff1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ff5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ffd:	8b 45 10             	mov    0x10(%ebp),%eax
80108000:	89 04 24             	mov    %eax,(%esp)
80108003:	e8 b5 9e ff ff       	call   80101ebd <readi>
80108008:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010800b:	74 07                	je     80108014 <loaduvm+0xc9>
      return -1;
8010800d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108012:	eb 18                	jmp    8010802c <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108014:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010801b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801e:	3b 45 18             	cmp    0x18(%ebp),%eax
80108021:	0f 82 4e ff ff ff    	jb     80107f75 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108027:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010802c:	c9                   	leave  
8010802d:	c3                   	ret    

8010802e <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010802e:	55                   	push   %ebp
8010802f:	89 e5                	mov    %esp,%ebp
80108031:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108034:	8b 45 10             	mov    0x10(%ebp),%eax
80108037:	85 c0                	test   %eax,%eax
80108039:	79 0a                	jns    80108045 <allocuvm+0x17>
    return 0;
8010803b:	b8 00 00 00 00       	mov    $0x0,%eax
80108040:	e9 fd 00 00 00       	jmp    80108142 <allocuvm+0x114>
  if(newsz < oldsz)
80108045:	8b 45 10             	mov    0x10(%ebp),%eax
80108048:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010804b:	73 08                	jae    80108055 <allocuvm+0x27>
    return oldsz;
8010804d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108050:	e9 ed 00 00 00       	jmp    80108142 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80108055:	8b 45 0c             	mov    0xc(%ebp),%eax
80108058:	05 ff 0f 00 00       	add    $0xfff,%eax
8010805d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108065:	e9 c9 00 00 00       	jmp    80108133 <allocuvm+0x105>
    mem = kalloc();
8010806a:	e8 e8 ab ff ff       	call   80102c57 <kalloc>
8010806f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108076:	75 2f                	jne    801080a7 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80108078:	c7 04 24 21 8e 10 80 	movl   $0x80108e21,(%esp)
8010807f:	e8 3d 83 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108084:	8b 45 0c             	mov    0xc(%ebp),%eax
80108087:	89 44 24 08          	mov    %eax,0x8(%esp)
8010808b:	8b 45 10             	mov    0x10(%ebp),%eax
8010808e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108092:	8b 45 08             	mov    0x8(%ebp),%eax
80108095:	89 04 24             	mov    %eax,(%esp)
80108098:	e8 a7 00 00 00       	call   80108144 <deallocuvm>
      return 0;
8010809d:	b8 00 00 00 00       	mov    $0x0,%eax
801080a2:	e9 9b 00 00 00       	jmp    80108142 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801080a7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080ae:	00 
801080af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080b6:	00 
801080b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ba:	89 04 24             	mov    %eax,(%esp)
801080bd:	e8 c8 cf ff ff       	call   8010508a <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801080c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080c5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080d5:	00 
801080d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
801080da:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080e1:	00 
801080e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801080e6:	8b 45 08             	mov    0x8(%ebp),%eax
801080e9:	89 04 24             	mov    %eax,(%esp)
801080ec:	e8 db fa ff ff       	call   80107bcc <mappages>
801080f1:	85 c0                	test   %eax,%eax
801080f3:	79 37                	jns    8010812c <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
801080f5:	c7 04 24 39 8e 10 80 	movl   $0x80108e39,(%esp)
801080fc:	e8 c0 82 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108101:	8b 45 0c             	mov    0xc(%ebp),%eax
80108104:	89 44 24 08          	mov    %eax,0x8(%esp)
80108108:	8b 45 10             	mov    0x10(%ebp),%eax
8010810b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010810f:	8b 45 08             	mov    0x8(%ebp),%eax
80108112:	89 04 24             	mov    %eax,(%esp)
80108115:	e8 2a 00 00 00       	call   80108144 <deallocuvm>
      kfree(mem);
8010811a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010811d:	89 04 24             	mov    %eax,(%esp)
80108120:	e8 9c aa ff ff       	call   80102bc1 <kfree>
      return 0;
80108125:	b8 00 00 00 00       	mov    $0x0,%eax
8010812a:	eb 16                	jmp    80108142 <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010812c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108136:	3b 45 10             	cmp    0x10(%ebp),%eax
80108139:	0f 82 2b ff ff ff    	jb     8010806a <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
8010813f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108142:	c9                   	leave  
80108143:	c3                   	ret    

80108144 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108144:	55                   	push   %ebp
80108145:	89 e5                	mov    %esp,%ebp
80108147:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010814a:	8b 45 10             	mov    0x10(%ebp),%eax
8010814d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108150:	72 08                	jb     8010815a <deallocuvm+0x16>
    return oldsz;
80108152:	8b 45 0c             	mov    0xc(%ebp),%eax
80108155:	e9 ac 00 00 00       	jmp    80108206 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
8010815a:	8b 45 10             	mov    0x10(%ebp),%eax
8010815d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010816a:	e9 88 00 00 00       	jmp    801081f7 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010816f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108172:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108179:	00 
8010817a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010817e:	8b 45 08             	mov    0x8(%ebp),%eax
80108181:	89 04 24             	mov    %eax,(%esp)
80108184:	e8 a7 f9 ff ff       	call   80107b30 <walkpgdir>
80108189:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010818c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108190:	75 14                	jne    801081a6 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108195:	c1 e8 16             	shr    $0x16,%eax
80108198:	40                   	inc    %eax
80108199:	c1 e0 16             	shl    $0x16,%eax
8010819c:	2d 00 10 00 00       	sub    $0x1000,%eax
801081a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081a4:	eb 4a                	jmp    801081f0 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
801081a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a9:	8b 00                	mov    (%eax),%eax
801081ab:	83 e0 01             	and    $0x1,%eax
801081ae:	85 c0                	test   %eax,%eax
801081b0:	74 3e                	je     801081f0 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801081b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b5:	8b 00                	mov    (%eax),%eax
801081b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801081bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081c3:	75 0c                	jne    801081d1 <deallocuvm+0x8d>
        panic("kfree");
801081c5:	c7 04 24 55 8e 10 80 	movl   $0x80108e55,(%esp)
801081cc:	e8 83 83 ff ff       	call   80100554 <panic>
      char *v = P2V(pa);
801081d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081d4:	05 00 00 00 80       	add    $0x80000000,%eax
801081d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801081dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081df:	89 04 24             	mov    %eax,(%esp)
801081e2:	e8 da a9 ff ff       	call   80102bc1 <kfree>
      *pte = 0;
801081e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801081f0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081fd:	0f 82 6c ff ff ff    	jb     8010816f <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108203:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108206:	c9                   	leave  
80108207:	c3                   	ret    

80108208 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108208:	55                   	push   %ebp
80108209:	89 e5                	mov    %esp,%ebp
8010820b:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010820e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108212:	75 0c                	jne    80108220 <freevm+0x18>
    panic("freevm: no pgdir");
80108214:	c7 04 24 5b 8e 10 80 	movl   $0x80108e5b,(%esp)
8010821b:	e8 34 83 ff ff       	call   80100554 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108220:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108227:	00 
80108228:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010822f:	80 
80108230:	8b 45 08             	mov    0x8(%ebp),%eax
80108233:	89 04 24             	mov    %eax,(%esp)
80108236:	e8 09 ff ff ff       	call   80108144 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010823b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108242:	eb 44                	jmp    80108288 <freevm+0x80>
    if(pgdir[i] & PTE_P){
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010824e:	8b 45 08             	mov    0x8(%ebp),%eax
80108251:	01 d0                	add    %edx,%eax
80108253:	8b 00                	mov    (%eax),%eax
80108255:	83 e0 01             	and    $0x1,%eax
80108258:	85 c0                	test   %eax,%eax
8010825a:	74 29                	je     80108285 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010825c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108266:	8b 45 08             	mov    0x8(%ebp),%eax
80108269:	01 d0                	add    %edx,%eax
8010826b:	8b 00                	mov    (%eax),%eax
8010826d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108272:	05 00 00 00 80       	add    $0x80000000,%eax
80108277:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010827a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010827d:	89 04 24             	mov    %eax,(%esp)
80108280:	e8 3c a9 ff ff       	call   80102bc1 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108285:	ff 45 f4             	incl   -0xc(%ebp)
80108288:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010828f:	76 b3                	jbe    80108244 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108291:	8b 45 08             	mov    0x8(%ebp),%eax
80108294:	89 04 24             	mov    %eax,(%esp)
80108297:	e8 25 a9 ff ff       	call   80102bc1 <kfree>
}
8010829c:	c9                   	leave  
8010829d:	c3                   	ret    

8010829e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010829e:	55                   	push   %ebp
8010829f:	89 e5                	mov    %esp,%ebp
801082a1:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082ab:	00 
801082ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801082af:	89 44 24 04          	mov    %eax,0x4(%esp)
801082b3:	8b 45 08             	mov    0x8(%ebp),%eax
801082b6:	89 04 24             	mov    %eax,(%esp)
801082b9:	e8 72 f8 ff ff       	call   80107b30 <walkpgdir>
801082be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801082c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801082c5:	75 0c                	jne    801082d3 <clearpteu+0x35>
    panic("clearpteu");
801082c7:	c7 04 24 6c 8e 10 80 	movl   $0x80108e6c,(%esp)
801082ce:	e8 81 82 ff ff       	call   80100554 <panic>
  *pte &= ~PTE_U;
801082d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d6:	8b 00                	mov    (%eax),%eax
801082d8:	83 e0 fb             	and    $0xfffffffb,%eax
801082db:	89 c2                	mov    %eax,%edx
801082dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e0:	89 10                	mov    %edx,(%eax)
}
801082e2:	c9                   	leave  
801082e3:	c3                   	ret    

801082e4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801082e4:	55                   	push   %ebp
801082e5:	89 e5                	mov    %esp,%ebp
801082e7:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801082ea:	e8 73 f9 ff ff       	call   80107c62 <setupkvm>
801082ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082f6:	75 0a                	jne    80108302 <copyuvm+0x1e>
    return 0;
801082f8:	b8 00 00 00 00       	mov    $0x0,%eax
801082fd:	e9 f8 00 00 00       	jmp    801083fa <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80108302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108309:	e9 cb 00 00 00       	jmp    801083d9 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010830e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108311:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108318:	00 
80108319:	89 44 24 04          	mov    %eax,0x4(%esp)
8010831d:	8b 45 08             	mov    0x8(%ebp),%eax
80108320:	89 04 24             	mov    %eax,(%esp)
80108323:	e8 08 f8 ff ff       	call   80107b30 <walkpgdir>
80108328:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010832b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010832f:	75 0c                	jne    8010833d <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108331:	c7 04 24 76 8e 10 80 	movl   $0x80108e76,(%esp)
80108338:	e8 17 82 ff ff       	call   80100554 <panic>
    if(!(*pte & PTE_P))
8010833d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108340:	8b 00                	mov    (%eax),%eax
80108342:	83 e0 01             	and    $0x1,%eax
80108345:	85 c0                	test   %eax,%eax
80108347:	75 0c                	jne    80108355 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108349:	c7 04 24 90 8e 10 80 	movl   $0x80108e90,(%esp)
80108350:	e8 ff 81 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80108355:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108358:	8b 00                	mov    (%eax),%eax
8010835a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010835f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108362:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108365:	8b 00                	mov    (%eax),%eax
80108367:	25 ff 0f 00 00       	and    $0xfff,%eax
8010836c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010836f:	e8 e3 a8 ff ff       	call   80102c57 <kalloc>
80108374:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010837b:	75 02                	jne    8010837f <copyuvm+0x9b>
      goto bad;
8010837d:	eb 6b                	jmp    801083ea <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010837f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108382:	05 00 00 00 80       	add    $0x80000000,%eax
80108387:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010838e:	00 
8010838f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108393:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108396:	89 04 24             	mov    %eax,(%esp)
80108399:	e8 b5 cd ff ff       	call   80105153 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010839e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801083a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083a4:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801083aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ad:	89 54 24 10          	mov    %edx,0x10(%esp)
801083b1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801083b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083bc:	00 
801083bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801083c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c4:	89 04 24             	mov    %eax,(%esp)
801083c7:	e8 00 f8 ff ff       	call   80107bcc <mappages>
801083cc:	85 c0                	test   %eax,%eax
801083ce:	79 02                	jns    801083d2 <copyuvm+0xee>
      goto bad;
801083d0:	eb 18                	jmp    801083ea <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801083d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083df:	0f 82 29 ff ff ff    	jb     8010830e <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
801083e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e8:	eb 10                	jmp    801083fa <copyuvm+0x116>

bad:
  freevm(d);
801083ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ed:	89 04 24             	mov    %eax,(%esp)
801083f0:	e8 13 fe ff ff       	call   80108208 <freevm>
  return 0;
801083f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083fa:	c9                   	leave  
801083fb:	c3                   	ret    

801083fc <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801083fc:	55                   	push   %ebp
801083fd:	89 e5                	mov    %esp,%ebp
801083ff:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108402:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108409:	00 
8010840a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010840d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108411:	8b 45 08             	mov    0x8(%ebp),%eax
80108414:	89 04 24             	mov    %eax,(%esp)
80108417:	e8 14 f7 ff ff       	call   80107b30 <walkpgdir>
8010841c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010841f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108422:	8b 00                	mov    (%eax),%eax
80108424:	83 e0 01             	and    $0x1,%eax
80108427:	85 c0                	test   %eax,%eax
80108429:	75 07                	jne    80108432 <uva2ka+0x36>
    return 0;
8010842b:	b8 00 00 00 00       	mov    $0x0,%eax
80108430:	eb 22                	jmp    80108454 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108435:	8b 00                	mov    (%eax),%eax
80108437:	83 e0 04             	and    $0x4,%eax
8010843a:	85 c0                	test   %eax,%eax
8010843c:	75 07                	jne    80108445 <uva2ka+0x49>
    return 0;
8010843e:	b8 00 00 00 00       	mov    $0x0,%eax
80108443:	eb 0f                	jmp    80108454 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108448:	8b 00                	mov    (%eax),%eax
8010844a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010844f:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108454:	c9                   	leave  
80108455:	c3                   	ret    

80108456 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108456:	55                   	push   %ebp
80108457:	89 e5                	mov    %esp,%ebp
80108459:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010845c:	8b 45 10             	mov    0x10(%ebp),%eax
8010845f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108462:	e9 87 00 00 00       	jmp    801084ee <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010846f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108472:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108475:	89 44 24 04          	mov    %eax,0x4(%esp)
80108479:	8b 45 08             	mov    0x8(%ebp),%eax
8010847c:	89 04 24             	mov    %eax,(%esp)
8010847f:	e8 78 ff ff ff       	call   801083fc <uva2ka>
80108484:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108487:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010848b:	75 07                	jne    80108494 <copyout+0x3e>
      return -1;
8010848d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108492:	eb 69                	jmp    801084fd <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108494:	8b 45 0c             	mov    0xc(%ebp),%eax
80108497:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010849a:	29 c2                	sub    %eax,%edx
8010849c:	89 d0                	mov    %edx,%eax
8010849e:	05 00 10 00 00       	add    $0x1000,%eax
801084a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801084a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084a9:	3b 45 14             	cmp    0x14(%ebp),%eax
801084ac:	76 06                	jbe    801084b4 <copyout+0x5e>
      n = len;
801084ae:	8b 45 14             	mov    0x14(%ebp),%eax
801084b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801084b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ba:	29 c2                	sub    %eax,%edx
801084bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084bf:	01 c2                	add    %eax,%edx
801084c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801084c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801084cf:	89 14 24             	mov    %edx,(%esp)
801084d2:	e8 7c cc ff ff       	call   80105153 <memmove>
    len -= n;
801084d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084da:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801084dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e0:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801084e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e6:	05 00 10 00 00       	add    $0x1000,%eax
801084eb:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801084ee:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801084f2:	0f 85 6f ff ff ff    	jne    80108467 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801084f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084fd:	c9                   	leave  
801084fe:	c3                   	ret    
	...

80108500 <getname>:
#include "container.h"
#define NUM_VCS 4
struct container tuperwares[NUM_VCS];

int getname(int index, char* name){
80108500:	55                   	push   %ebp
80108501:	89 e5                	mov    %esp,%ebp
80108503:	53                   	push   %ebx
80108504:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((*name++ = tuperwares[index].name[i++]) != 0)
8010850e:	90                   	nop
8010850f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108512:	8d 42 01             	lea    0x1(%edx),%eax
80108515:	89 45 0c             	mov    %eax,0xc(%ebp)
80108518:	8b 4d f8             	mov    -0x8(%ebp),%ecx
8010851b:	8d 41 01             	lea    0x1(%ecx),%eax
8010851e:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108521:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108524:	89 d8                	mov    %ebx,%eax
80108526:	01 c0                	add    %eax,%eax
80108528:	01 d8                	add    %ebx,%eax
8010852a:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
80108531:	01 d8                	add    %ebx,%eax
80108533:	c1 e0 02             	shl    $0x2,%eax
80108536:	01 c8                	add    %ecx,%eax
80108538:	05 40 68 11 80       	add    $0x80116840,%eax
8010853d:	8a 00                	mov    (%eax),%al
8010853f:	88 02                	mov    %al,(%edx)
80108541:	8a 02                	mov    (%edx),%al
80108543:	84 c0                	test   %al,%al
80108545:	75 c8                	jne    8010850f <getname+0xf>
    ;
    return 0;
80108547:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010854c:	83 c4 10             	add    $0x10,%esp
8010854f:	5b                   	pop    %ebx
80108550:	5d                   	pop    %ebp
80108551:	c3                   	ret    

80108552 <setname>:

int setname(int index, char* name){
80108552:	55                   	push   %ebp
80108553:	89 e5                	mov    %esp,%ebp
80108555:	53                   	push   %ebx
80108556:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108559:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((tuperwares[index].name[i++] = *name++) != 0)
80108560:	90                   	nop
80108561:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108564:	8d 42 01             	lea    0x1(%edx),%eax
80108567:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010856a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010856d:	8d 48 01             	lea    0x1(%eax),%ecx
80108570:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108573:	8a 08                	mov    (%eax),%cl
80108575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108578:	89 d8                	mov    %ebx,%eax
8010857a:	01 c0                	add    %eax,%eax
8010857c:	01 d8                	add    %ebx,%eax
8010857e:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
80108585:	01 d8                	add    %ebx,%eax
80108587:	c1 e0 02             	shl    $0x2,%eax
8010858a:	01 d0                	add    %edx,%eax
8010858c:	05 40 68 11 80       	add    $0x80116840,%eax
80108591:	88 08                	mov    %cl,(%eax)
80108593:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108596:	89 c8                	mov    %ecx,%eax
80108598:	01 c0                	add    %eax,%eax
8010859a:	01 c8                	add    %ecx,%eax
8010859c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
801085a3:	01 c8                	add    %ecx,%eax
801085a5:	c1 e0 02             	shl    $0x2,%eax
801085a8:	01 d0                	add    %edx,%eax
801085aa:	05 40 68 11 80       	add    $0x80116840,%eax
801085af:	8a 00                	mov    (%eax),%al
801085b1:	84 c0                	test   %al,%al
801085b3:	75 ac                	jne    80108561 <setname+0xf>
    ;
    return 0;
801085b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085ba:	83 c4 10             	add    $0x10,%esp
801085bd:	5b                   	pop    %ebx
801085be:	5d                   	pop    %ebp
801085bf:	c3                   	ret    

801085c0 <getmaxproc>:

int getmaxproc(int index){
801085c0:	55                   	push   %ebp
801085c1:	89 e5                	mov    %esp,%ebp
    return tuperwares[index].max_proc;
801085c3:	8b 55 08             	mov    0x8(%ebp),%edx
801085c6:	89 d0                	mov    %edx,%eax
801085c8:	01 c0                	add    %eax,%eax
801085ca:	01 d0                	add    %edx,%eax
801085cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085d3:	01 d0                	add    %edx,%eax
801085d5:	c1 e0 02             	shl    $0x2,%eax
801085d8:	05 60 68 11 80       	add    $0x80116860,%eax
801085dd:	8b 40 08             	mov    0x8(%eax),%eax
}
801085e0:	5d                   	pop    %ebp
801085e1:	c3                   	ret    

801085e2 <setmaxproc>:

int setmaxproc(int index, int max_proc){
801085e2:	55                   	push   %ebp
801085e3:	89 e5                	mov    %esp,%ebp
    tuperwares[index].max_proc = max_proc;
801085e5:	8b 55 08             	mov    0x8(%ebp),%edx
801085e8:	89 d0                	mov    %edx,%eax
801085ea:	01 c0                	add    %eax,%eax
801085ec:	01 d0                	add    %edx,%eax
801085ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085f5:	01 d0                	add    %edx,%eax
801085f7:	c1 e0 02             	shl    $0x2,%eax
801085fa:	8d 90 60 68 11 80    	lea    -0x7fee97a0(%eax),%edx
80108600:	8b 45 0c             	mov    0xc(%ebp),%eax
80108603:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108606:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010860b:	5d                   	pop    %ebp
8010860c:	c3                   	ret    

8010860d <getmaxmem>:

int getmaxmem(int index){
8010860d:	55                   	push   %ebp
8010860e:	89 e5                	mov    %esp,%ebp
    return tuperwares[index].max_mem;
80108610:	8b 55 08             	mov    0x8(%ebp),%edx
80108613:	89 d0                	mov    %edx,%eax
80108615:	01 c0                	add    %eax,%eax
80108617:	01 d0                	add    %edx,%eax
80108619:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108620:	01 d0                	add    %edx,%eax
80108622:	c1 e0 02             	shl    $0x2,%eax
80108625:	05 60 68 11 80       	add    $0x80116860,%eax
8010862a:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010862d:	5d                   	pop    %ebp
8010862e:	c3                   	ret    

8010862f <setmaxmem>:

int setmaxmem(int index, int max_mem){
8010862f:	55                   	push   %ebp
80108630:	89 e5                	mov    %esp,%ebp
    tuperwares[index].max_mem = max_mem;
80108632:	8b 55 08             	mov    0x8(%ebp),%edx
80108635:	89 d0                	mov    %edx,%eax
80108637:	01 c0                	add    %eax,%eax
80108639:	01 d0                	add    %edx,%eax
8010863b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108642:	01 d0                	add    %edx,%eax
80108644:	c1 e0 02             	shl    $0x2,%eax
80108647:	8d 90 60 68 11 80    	lea    -0x7fee97a0(%eax),%edx
8010864d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108650:	89 42 0c             	mov    %eax,0xc(%edx)
    return 0;
80108653:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108658:	5d                   	pop    %ebp
80108659:	c3                   	ret    

8010865a <getmaxdisk>:

int getmaxdisk(int index){
8010865a:	55                   	push   %ebp
8010865b:	89 e5                	mov    %esp,%ebp
    return tuperwares[index].max_disk;
8010865d:	8b 55 08             	mov    0x8(%ebp),%edx
80108660:	89 d0                	mov    %edx,%eax
80108662:	01 c0                	add    %eax,%eax
80108664:	01 d0                	add    %edx,%eax
80108666:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010866d:	01 d0                	add    %edx,%eax
8010866f:	c1 e0 02             	shl    $0x2,%eax
80108672:	05 70 68 11 80       	add    $0x80116870,%eax
80108677:	8b 00                	mov    (%eax),%eax
}
80108679:	5d                   	pop    %ebp
8010867a:	c3                   	ret    

8010867b <setmaxdisk>:

int setmaxdisk(int index, int max_disk){
8010867b:	55                   	push   %ebp
8010867c:	89 e5                	mov    %esp,%ebp
    tuperwares[index].max_disk = max_disk;
8010867e:	8b 55 08             	mov    0x8(%ebp),%edx
80108681:	89 d0                	mov    %edx,%eax
80108683:	01 c0                	add    %eax,%eax
80108685:	01 d0                	add    %edx,%eax
80108687:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010868e:	01 d0                	add    %edx,%eax
80108690:	c1 e0 02             	shl    $0x2,%eax
80108693:	8d 90 70 68 11 80    	lea    -0x7fee9790(%eax),%edx
80108699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010869c:	89 02                	mov    %eax,(%edx)
    return 0;
8010869e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086a3:	5d                   	pop    %ebp
801086a4:	c3                   	ret    

801086a5 <getusedmem>:

int getusedmem(int index){
801086a5:	55                   	push   %ebp
801086a6:	89 e5                	mov    %esp,%ebp
    return tuperwares[index].used_mem;
801086a8:	8b 55 08             	mov    0x8(%ebp),%edx
801086ab:	89 d0                	mov    %edx,%eax
801086ad:	01 c0                	add    %eax,%eax
801086af:	01 d0                	add    %edx,%eax
801086b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086b8:	01 d0                	add    %edx,%eax
801086ba:	c1 e0 02             	shl    $0x2,%eax
801086bd:	05 70 68 11 80       	add    $0x80116870,%eax
801086c2:	8b 40 04             	mov    0x4(%eax),%eax
}
801086c5:	5d                   	pop    %ebp
801086c6:	c3                   	ret    

801086c7 <setusedmem>:

int setusedmem(int index, int used_mem){
801086c7:	55                   	push   %ebp
801086c8:	89 e5                	mov    %esp,%ebp
    tuperwares[index].used_mem = used_mem;
801086ca:	8b 55 08             	mov    0x8(%ebp),%edx
801086cd:	89 d0                	mov    %edx,%eax
801086cf:	01 c0                	add    %eax,%eax
801086d1:	01 d0                	add    %edx,%eax
801086d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086da:	01 d0                	add    %edx,%eax
801086dc:	c1 e0 02             	shl    $0x2,%eax
801086df:	8d 90 70 68 11 80    	lea    -0x7fee9790(%eax),%edx
801086e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801086e8:	89 42 04             	mov    %eax,0x4(%edx)
    return 0;
801086eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086f0:	5d                   	pop    %ebp
801086f1:	c3                   	ret    

801086f2 <getuseddisk>:

int getuseddisk(int index){
801086f2:	55                   	push   %ebp
801086f3:	89 e5                	mov    %esp,%ebp
    return tuperwares[index].used_disk;
801086f5:	8b 55 08             	mov    0x8(%ebp),%edx
801086f8:	89 d0                	mov    %edx,%eax
801086fa:	01 c0                	add    %eax,%eax
801086fc:	01 d0                	add    %edx,%eax
801086fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108705:	01 d0                	add    %edx,%eax
80108707:	c1 e0 02             	shl    $0x2,%eax
8010870a:	05 70 68 11 80       	add    $0x80116870,%eax
8010870f:	8b 40 08             	mov    0x8(%eax),%eax
}
80108712:	5d                   	pop    %ebp
80108713:	c3                   	ret    

80108714 <setuseddisk>:

int setuseddisk(int index, int used_disk){
80108714:	55                   	push   %ebp
80108715:	89 e5                	mov    %esp,%ebp
    tuperwares[index].used_disk = used_disk;
80108717:	8b 55 08             	mov    0x8(%ebp),%edx
8010871a:	89 d0                	mov    %edx,%eax
8010871c:	01 c0                	add    %eax,%eax
8010871e:	01 d0                	add    %edx,%eax
80108720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108727:	01 d0                	add    %edx,%eax
80108729:	c1 e0 02             	shl    $0x2,%eax
8010872c:	8d 90 70 68 11 80    	lea    -0x7fee9790(%eax),%edx
80108732:	8b 45 0c             	mov    0xc(%ebp),%eax
80108735:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108738:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010873d:	5d                   	pop    %ebp
8010873e:	c3                   	ret    
