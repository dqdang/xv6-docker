
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
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 62 37 10 80       	mov    $0x80103762,%eax
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
8010003a:	c7 44 24 04 40 81 10 	movl   $0x80108140,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100049:	e8 18 4d 00 00       	call   80104d66 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 47 81 10 	movl   $0x80108147,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 91 4b 00 00       	call   80104c28 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 90 0d 11 80       	mov    0x80110d90,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 90 0d 11 80       	mov    %eax,0x80110d90

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
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
801000c2:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801000c9:	e8 b9 4c 00 00       	call   80104d87 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 90 0d 11 80       	mov    0x80110d90,%eax
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
801000fd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100104:	e8 e8 4c 00 00       	call   80104df1 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 4b 4b 00 00       	call   80104c62 <acquiresleep>
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
80100128:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 8c 0d 11 80       	mov    0x80110d8c,%eax
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
80100176:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010017d:	e8 6f 4c 00 00       	call   80104df1 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 d2 4a 00 00       	call   80104c62 <acquiresleep>
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
8010019e:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 4e 81 10 80 	movl   $0x8010814e,(%esp)
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
801001e2:	e8 b2 26 00 00       	call   80102899 <iderw>
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
801001fb:	e8 ff 4a 00 00       	call   80104cff <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 5f 81 10 80 	movl   $0x8010815f,(%esp)
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
80100225:	e8 6f 26 00 00       	call   80102899 <iderw>
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
8010023b:	e8 bf 4a 00 00       	call   80104cff <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 66 81 10 80 	movl   $0x80108166,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 5f 4a 00 00       	call   80104cbd <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100265:	e8 1d 4b 00 00       	call   80104d87 <acquire>
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
801002a1:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801002d1:	e8 1b 4b 00 00       	call   80104df1 <release>
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
80100364:	8a 80 08 90 10 80    	mov    -0x7fef6ff8(%eax),%al
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
801003c7:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
801003cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d3:	74 0c                	je     801003e1 <cprintf+0x20>
    acquire(&cons.lock);
801003d5:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801003dc:	e8 a6 49 00 00       	call   80104d87 <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 6d 81 10 80 	movl   $0x8010816d,(%esp)
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
801004cf:	c7 45 ec 76 81 10 80 	movl   $0x80108176,-0x14(%ebp)
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
80100546:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010054d:	e8 9f 48 00 00       	call   80104df1 <release>
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
8010055f:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
80100566:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100569:	e8 c7 29 00 00       	call   80102f35 <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 7d 81 10 80 	movl   $0x8010817d,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 91 81 10 80 	movl   $0x80108191,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 97 48 00 00       	call   80104e3e <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 93 81 10 80 	movl   $0x80108193,(%esp)
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
801005d0:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
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
80100666:	8b 0d 04 90 10 80    	mov    0x80109004,%ecx
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
80100695:	c7 04 24 97 81 10 80 	movl   $0x80108197,(%esp)
8010069c:	e8 b3 fe ff ff       	call   80100554 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006a1:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a8:	7e 53                	jle    801006fd <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006aa:	a1 04 90 10 80       	mov    0x80109004,%eax
801006af:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b5:	a1 04 90 10 80       	mov    0x80109004,%eax
801006ba:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c1:	00 
801006c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801006c6:	89 04 24             	mov    %eax,(%esp)
801006c9:	e8 e5 49 00 00       	call   801050b3 <memmove>
    pos -= 80;
801006ce:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d2:	b8 80 07 00 00       	mov    $0x780,%eax
801006d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006da:	01 c0                	add    %eax,%eax
801006dc:	8b 0d 04 90 10 80    	mov    0x80109004,%ecx
801006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801006e5:	01 d2                	add    %edx,%edx
801006e7:	01 ca                	add    %ecx,%edx
801006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801006ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f4:	00 
801006f5:	89 14 24             	mov    %edx,(%esp)
801006f8:	e8 ed 48 00 00       	call   80104fea <memset>
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
80100754:	8b 15 04 90 10 80    	mov    0x80109004,%edx
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
8010076e:	a1 80 b5 10 80       	mov    0x8010b580,%eax
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
8010078e:	e8 2d 61 00 00       	call   801068c0 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 21 61 00 00       	call   801068c0 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 15 61 00 00       	call   801068c0 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 08 61 00 00       	call   801068c0 <uartputc>
  cgaputc(c);
801007b8:	8b 45 08             	mov    0x8(%ebp),%eax
801007bb:	89 04 24             	mov    %eax,(%esp)
801007be:	e8 19 fe ff ff       	call   801005dc <cgaputc>
}
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
801007cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801007d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&cons.lock);
801007d9:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801007e0:	e8 a2 45 00 00       	call   80104d87 <acquire>
  while((c = getc()) >= 0){
801007e5:	e9 67 01 00 00       	jmp    80100951 <consoleintr+0x18c>
    switch(c){
801007ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801007ed:	83 f8 14             	cmp    $0x14,%eax
801007f0:	74 33                	je     80100825 <consoleintr+0x60>
801007f2:	83 f8 14             	cmp    $0x14,%eax
801007f5:	7f 13                	jg     8010080a <consoleintr+0x45>
801007f7:	83 f8 08             	cmp    $0x8,%eax
801007fa:	0f 84 92 00 00 00    	je     80100892 <consoleintr+0xcd>
80100800:	83 f8 10             	cmp    $0x10,%eax
80100803:	74 14                	je     80100819 <consoleintr+0x54>
80100805:	e9 b8 00 00 00       	jmp    801008c2 <consoleintr+0xfd>
8010080a:	83 f8 15             	cmp    $0x15,%eax
8010080d:	74 5b                	je     8010086a <consoleintr+0xa5>
8010080f:	83 f8 7f             	cmp    $0x7f,%eax
80100812:	74 7e                	je     80100892 <consoleintr+0xcd>
80100814:	e9 a9 00 00 00       	jmp    801008c2 <consoleintr+0xfd>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100819:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100820:	e9 2c 01 00 00       	jmp    80100951 <consoleintr+0x18c>
    case C('T'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      if (active == 1){
80100825:	a1 00 90 10 80       	mov    0x80109000,%eax
8010082a:	83 f8 01             	cmp    $0x1,%eax
8010082d:	75 0c                	jne    8010083b <consoleintr+0x76>
        active = 2;
8010082f:	c7 05 00 90 10 80 02 	movl   $0x2,0x80109000
80100836:	00 00 00 
80100839:	eb 0a                	jmp    80100845 <consoleintr+0x80>
      }else{
        active = 1;
8010083b:	c7 05 00 90 10 80 01 	movl   $0x1,0x80109000
80100842:	00 00 00 
      } 
      doconsoleswitch = 1;
80100845:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
8010084c:	e9 00 01 00 00       	jmp    80100951 <consoleintr+0x18c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100851:	a1 28 10 11 80       	mov    0x80111028,%eax
80100856:	48                   	dec    %eax
80100857:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
8010085c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100863:	e8 00 ff ff ff       	call   80100768 <consputc>
80100868:	eb 01                	jmp    8010086b <consoleintr+0xa6>
        active = 1;
      } 
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	90                   	nop
8010086b:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100871:	a1 24 10 11 80       	mov    0x80111024,%eax
80100876:	39 c2                	cmp    %eax,%edx
80100878:	74 13                	je     8010088d <consoleintr+0xc8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087a:	a1 28 10 11 80       	mov    0x80111028,%eax
8010087f:	48                   	dec    %eax
80100880:	83 e0 7f             	and    $0x7f,%eax
80100883:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
        active = 1;
      } 
      doconsoleswitch = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100889:	3c 0a                	cmp    $0xa,%al
8010088b:	75 c4                	jne    80100851 <consoleintr+0x8c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010088d:	e9 bf 00 00 00       	jmp    80100951 <consoleintr+0x18c>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100892:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100898:	a1 24 10 11 80       	mov    0x80111024,%eax
8010089d:	39 c2                	cmp    %eax,%edx
8010089f:	74 1c                	je     801008bd <consoleintr+0xf8>
        input.e--;
801008a1:	a1 28 10 11 80       	mov    0x80111028,%eax
801008a6:	48                   	dec    %eax
801008a7:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801008ac:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008b3:	e8 b0 fe ff ff       	call   80100768 <consputc>
      }
      break;
801008b8:	e9 94 00 00 00       	jmp    80100951 <consoleintr+0x18c>
801008bd:	e9 8f 00 00 00       	jmp    80100951 <consoleintr+0x18c>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801008c6:	0f 84 84 00 00 00    	je     80100950 <consoleintr+0x18b>
801008cc:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008d2:	a1 20 10 11 80       	mov    0x80111020,%eax
801008d7:	29 c2                	sub    %eax,%edx
801008d9:	89 d0                	mov    %edx,%eax
801008db:	83 f8 7f             	cmp    $0x7f,%eax
801008de:	77 70                	ja     80100950 <consoleintr+0x18b>
        c = (c == '\r') ? '\n' : c;
801008e0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
801008e4:	74 05                	je     801008eb <consoleintr+0x126>
801008e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801008e9:	eb 05                	jmp    801008f0 <consoleintr+0x12b>
801008eb:	b8 0a 00 00 00       	mov    $0xa,%eax
801008f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008f3:	a1 28 10 11 80       	mov    0x80111028,%eax
801008f8:	8d 50 01             	lea    0x1(%eax),%edx
801008fb:	89 15 28 10 11 80    	mov    %edx,0x80111028
80100901:	83 e0 7f             	and    $0x7f,%eax
80100904:	89 c2                	mov    %eax,%edx
80100906:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100909:	88 82 a0 0f 11 80    	mov    %al,-0x7feef060(%edx)
        consputc(c);
8010090f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100912:	89 04 24             	mov    %eax,(%esp)
80100915:	e8 4e fe ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
8010091e:	74 18                	je     80100938 <consoleintr+0x173>
80100920:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100924:	74 12                	je     80100938 <consoleintr+0x173>
80100926:	a1 28 10 11 80       	mov    0x80111028,%eax
8010092b:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100931:	83 ea 80             	sub    $0xffffff80,%edx
80100934:	39 d0                	cmp    %edx,%eax
80100936:	75 18                	jne    80100950 <consoleintr+0x18b>
          input.w = input.e;
80100938:	a1 28 10 11 80       	mov    0x80111028,%eax
8010093d:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
80100942:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
80100949:	e8 3e 41 00 00       	call   80104a8c <wakeup>
        }
      }
      break;
8010094e:	eb 00                	jmp    80100950 <consoleintr+0x18b>
80100950:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100951:	8b 45 08             	mov    0x8(%ebp),%eax
80100954:	ff d0                	call   *%eax
80100956:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010095d:	0f 89 87 fe ff ff    	jns    801007ea <consoleintr+0x25>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100963:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010096a:	e8 82 44 00 00       	call   80104df1 <release>
  if(doprocdump){
8010096f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100973:	74 05                	je     8010097a <consoleintr+0x1b5>
    procdump();  // now call procdump() wo. cons.lock held
80100975:	e8 b5 41 00 00       	call   80104b2f <procdump>
  }
  if(doconsoleswitch){
8010097a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010097e:	74 15                	je     80100995 <consoleintr+0x1d0>
    cprintf("\nActive console now: %d\n", active);
80100980:	a1 00 90 10 80       	mov    0x80109000,%eax
80100985:	89 44 24 04          	mov    %eax,0x4(%esp)
80100989:	c7 04 24 aa 81 10 80 	movl   $0x801081aa,(%esp)
80100990:	e8 2c fa ff ff       	call   801003c1 <cprintf>
  }
}
80100995:	c9                   	leave  
80100996:	c3                   	ret    

80100997 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100997:	55                   	push   %ebp
80100998:	89 e5                	mov    %esp,%ebp
8010099a:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
8010099d:	8b 45 08             	mov    0x8(%ebp),%eax
801009a0:	89 04 24             	mov    %eax,(%esp)
801009a3:	e8 e8 10 00 00       	call   80101a90 <iunlock>
  target = n;
801009a8:	8b 45 10             	mov    0x10(%ebp),%eax
801009ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009ae:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801009b5:	e8 cd 43 00 00       	call   80104d87 <acquire>
  while(n > 0){
801009ba:	e9 b7 00 00 00       	jmp    80100a76 <consoleread+0xdf>
    while(input.r == input.w || active != ip->minor){
801009bf:	eb 41                	jmp    80100a02 <consoleread+0x6b>
      if(myproc()->killed){
801009c1:	e8 b1 37 00 00       	call   80104177 <myproc>
801009c6:	8b 40 24             	mov    0x24(%eax),%eax
801009c9:	85 c0                	test   %eax,%eax
801009cb:	74 21                	je     801009ee <consoleread+0x57>
        release(&cons.lock);
801009cd:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801009d4:	e8 18 44 00 00       	call   80104df1 <release>
        ilock(ip);
801009d9:	8b 45 08             	mov    0x8(%ebp),%eax
801009dc:	89 04 24             	mov    %eax,(%esp)
801009df:	e8 a2 0f 00 00       	call   80101986 <ilock>
        return -1;
801009e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009e9:	e9 b3 00 00 00       	jmp    80100aa1 <consoleread+0x10a>
      }
      sleep(&input.r, &cons.lock);
801009ee:	c7 44 24 04 a0 b5 10 	movl   $0x8010b5a0,0x4(%esp)
801009f5:	80 
801009f6:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
801009fd:	e8 b6 3f 00 00       	call   801049b8 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w || active != ip->minor){
80100a02:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100a08:	a1 24 10 11 80       	mov    0x80111024,%eax
80100a0d:	39 c2                	cmp    %eax,%edx
80100a0f:	74 b0                	je     801009c1 <consoleread+0x2a>
80100a11:	8b 45 08             	mov    0x8(%ebp),%eax
80100a14:	8b 40 54             	mov    0x54(%eax),%eax
80100a17:	0f bf d0             	movswl %ax,%edx
80100a1a:	a1 00 90 10 80       	mov    0x80109000,%eax
80100a1f:	39 c2                	cmp    %eax,%edx
80100a21:	75 9e                	jne    801009c1 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a23:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a28:	8d 50 01             	lea    0x1(%eax),%edx
80100a2b:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100a31:	83 e0 7f             	and    $0x7f,%eax
80100a34:	8a 80 a0 0f 11 80    	mov    -0x7feef060(%eax),%al
80100a3a:	0f be c0             	movsbl %al,%eax
80100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a40:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a44:	75 17                	jne    80100a5d <consoleread+0xc6>
      if(n < target){
80100a46:	8b 45 10             	mov    0x10(%ebp),%eax
80100a49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a4c:	73 0d                	jae    80100a5b <consoleread+0xc4>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a4e:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a53:	48                   	dec    %eax
80100a54:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100a59:	eb 25                	jmp    80100a80 <consoleread+0xe9>
80100a5b:	eb 23                	jmp    80100a80 <consoleread+0xe9>
    }
    *dst++ = c;
80100a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a60:	8d 50 01             	lea    0x1(%eax),%edx
80100a63:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a69:	88 10                	mov    %dl,(%eax)
    --n;
80100a6b:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100a6e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a72:	75 02                	jne    80100a76 <consoleread+0xdf>
      break;
80100a74:	eb 0a                	jmp    80100a80 <consoleread+0xe9>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a7a:	0f 8f 3f ff ff ff    	jg     801009bf <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100a80:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a87:	e8 65 43 00 00       	call   80104df1 <release>
  ilock(ip);
80100a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8f:	89 04 24             	mov    %eax,(%esp)
80100a92:	e8 ef 0e 00 00       	call   80101986 <ilock>

  return target - n;
80100a97:	8b 45 10             	mov    0x10(%ebp),%eax
80100a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9d:	29 c2                	sub    %eax,%edx
80100a9f:	89 d0                	mov    %edx,%eax
}
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    

80100aa3 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa3:	55                   	push   %ebp
80100aa4:	89 e5                	mov    %esp,%ebp
80100aa6:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor){
80100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80100aac:	8b 40 54             	mov    0x54(%eax),%eax
80100aaf:	0f bf d0             	movswl %ax,%edx
80100ab2:	a1 00 90 10 80       	mov    0x80109000,%eax
80100ab7:	39 c2                	cmp    %eax,%edx
80100ab9:	75 5a                	jne    80100b15 <consolewrite+0x72>
    iunlock(ip);
80100abb:	8b 45 08             	mov    0x8(%ebp),%eax
80100abe:	89 04 24             	mov    %eax,(%esp)
80100ac1:	e8 ca 0f 00 00       	call   80101a90 <iunlock>
    acquire(&cons.lock);
80100ac6:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100acd:	e8 b5 42 00 00       	call   80104d87 <acquire>
    for(i = 0; i < n; i++)
80100ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ad9:	eb 1b                	jmp    80100af6 <consolewrite+0x53>
      consputc(buf[i] & 0xff);
80100adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ade:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ae1:	01 d0                	add    %edx,%eax
80100ae3:	8a 00                	mov    (%eax),%al
80100ae5:	0f be c0             	movsbl %al,%eax
80100ae8:	0f b6 c0             	movzbl %al,%eax
80100aeb:	89 04 24             	mov    %eax,(%esp)
80100aee:	e8 75 fc ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100af3:	ff 45 f4             	incl   -0xc(%ebp)
80100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af9:	3b 45 10             	cmp    0x10(%ebp),%eax
80100afc:	7c dd                	jl     80100adb <consolewrite+0x38>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100afe:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b05:	e8 e7 42 00 00       	call   80104df1 <release>
    ilock(ip);
80100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80100b0d:	89 04 24             	mov    %eax,(%esp)
80100b10:	e8 71 0e 00 00       	call   80101986 <ilock>
  }
  return n;
80100b15:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b18:	c9                   	leave  
80100b19:	c3                   	ret    

80100b1a <consoleinit>:

void
consoleinit(void)
{
80100b1a:	55                   	push   %ebp
80100b1b:	89 e5                	mov    %esp,%ebp
80100b1d:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100b20:	c7 44 24 04 c3 81 10 	movl   $0x801081c3,0x4(%esp)
80100b27:	80 
80100b28:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100b2f:	e8 32 42 00 00       	call   80104d66 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 ec 19 11 80 a3 	movl   $0x80100aa3,0x801119ec
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 e8 19 11 80 97 	movl   $0x80100997,0x801119e8
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100b4f:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b52:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b59:	00 
80100b5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b61:	e8 e5 1e 00 00       	call   80102a4b <ioapicenable>
}
80100b66:	c9                   	leave  
80100b67:	c3                   	ret    

80100b68 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b68:	55                   	push   %ebp
80100b69:	89 e5                	mov    %esp,%ebp
80100b6b:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b71:	e8 01 36 00 00       	call   80104177 <myproc>
80100b76:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b79:	e8 01 29 00 00       	call   8010347f <begin_op>

  if((ip = namei(path)) == 0){
80100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 22 19 00 00       	call   801024ab <namei>
80100b89:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b8c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b90:	75 1b                	jne    80100bad <exec+0x45>
    end_op();
80100b92:	e8 6a 29 00 00       	call   80103501 <end_op>
    cprintf("exec: fail\n");
80100b97:	c7 04 24 cb 81 10 80 	movl   $0x801081cb,(%esp)
80100b9e:	e8 1e f8 ff ff       	call   801003c1 <cprintf>
    return -1;
80100ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba8:	e9 f6 03 00 00       	jmp    80100fa3 <exec+0x43b>
  }
  ilock(ip);
80100bad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bb0:	89 04 24             	mov    %eax,(%esp)
80100bb3:	e8 ce 0d 00 00       	call   80101986 <ilock>
  pgdir = 0;
80100bb8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bbf:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100bc6:	00 
80100bc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100bce:	00 
80100bcf:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bdc:	89 04 24             	mov    %eax,(%esp)
80100bdf:	e8 39 12 00 00       	call   80101e1d <readi>
80100be4:	83 f8 34             	cmp    $0x34,%eax
80100be7:	74 05                	je     80100bee <exec+0x86>
    goto bad;
80100be9:	e9 89 03 00 00       	jmp    80100f77 <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100bee:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100bf4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bf9:	74 05                	je     80100c00 <exec+0x98>
    goto bad;
80100bfb:	e9 77 03 00 00       	jmp    80100f77 <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100c00:	e8 9d 6c 00 00       	call   801078a2 <setupkvm>
80100c05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c0c:	75 05                	jne    80100c13 <exec+0xab>
    goto bad;
80100c0e:	e9 64 03 00 00       	jmp    80100f77 <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100c13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c21:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c27:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c2a:	e9 fb 00 00 00       	jmp    80100d2a <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c32:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100c39:	00 
80100c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c3e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c44:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c4b:	89 04 24             	mov    %eax,(%esp)
80100c4e:	e8 ca 11 00 00       	call   80101e1d <readi>
80100c53:	83 f8 20             	cmp    $0x20,%eax
80100c56:	74 05                	je     80100c5d <exec+0xf5>
      goto bad;
80100c58:	e9 1a 03 00 00       	jmp    80100f77 <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100c5d:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c63:	83 f8 01             	cmp    $0x1,%eax
80100c66:	74 05                	je     80100c6d <exec+0x105>
      continue;
80100c68:	e9 b1 00 00 00       	jmp    80100d1e <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100c6d:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c73:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c79:	39 c2                	cmp    %eax,%edx
80100c7b:	73 05                	jae    80100c82 <exec+0x11a>
      goto bad;
80100c7d:	e9 f5 02 00 00       	jmp    80100f77 <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c82:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c88:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8e:	01 c2                	add    %eax,%edx
80100c90:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c96:	39 c2                	cmp    %eax,%edx
80100c98:	73 05                	jae    80100c9f <exec+0x137>
      goto bad;
80100c9a:	e9 d8 02 00 00       	jmp    80100f77 <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c9f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca5:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cab:	01 d0                	add    %edx,%eax
80100cad:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbb:	89 04 24             	mov    %eax,(%esp)
80100cbe:	e8 ab 6f 00 00       	call   80107c6e <allocuvm>
80100cc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cca:	75 05                	jne    80100cd1 <exec+0x169>
      goto bad;
80100ccc:	e9 a6 02 00 00       	jmp    80100f77 <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100cd1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cd7:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cdc:	85 c0                	test   %eax,%eax
80100cde:	74 05                	je     80100ce5 <exec+0x17d>
      goto bad;
80100ce0:	e9 92 02 00 00       	jmp    80100f77 <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce5:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100ceb:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100cf1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cf7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cfb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cff:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100d02:	89 54 24 08          	mov    %edx,0x8(%esp)
80100d06:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d0d:	89 04 24             	mov    %eax,(%esp)
80100d10:	e8 76 6e 00 00       	call   80107b8b <loaduvm>
80100d15:	85 c0                	test   %eax,%eax
80100d17:	79 05                	jns    80100d1e <exec+0x1b6>
      goto bad;
80100d19:	e9 59 02 00 00       	jmp    80100f77 <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1e:	ff 45 ec             	incl   -0x14(%ebp)
80100d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d24:	83 c0 20             	add    $0x20,%eax
80100d27:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d2a:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100d30:	0f b7 c0             	movzwl %ax,%eax
80100d33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d36:	0f 8f f3 fe ff ff    	jg     80100c2f <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d3f:	89 04 24             	mov    %eax,(%esp)
80100d42:	e8 3e 0e 00 00       	call   80101b85 <iunlockput>
  end_op();
80100d47:	e8 b5 27 00 00       	call   80103501 <end_op>
  ip = 0;
80100d4c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d56:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d66:	05 00 20 00 00       	add    $0x2000,%eax
80100d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d79:	89 04 24             	mov    %eax,(%esp)
80100d7c:	e8 ed 6e 00 00       	call   80107c6e <allocuvm>
80100d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d88:	75 05                	jne    80100d8f <exec+0x227>
    goto bad;
80100d8a:	e9 e8 01 00 00       	jmp    80100f77 <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d92:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d97:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d9e:	89 04 24             	mov    %eax,(%esp)
80100da1:	e8 38 71 00 00       	call   80107ede <clearpteu>
  sp = sz;
80100da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da9:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100db3:	e9 95 00 00 00       	jmp    80100e4d <exec+0x2e5>
    if(argc >= MAXARG)
80100db8:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dbc:	76 05                	jbe    80100dc3 <exec+0x25b>
      goto bad;
80100dbe:	e9 b4 01 00 00       	jmp    80100f77 <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd0:	01 d0                	add    %edx,%eax
80100dd2:	8b 00                	mov    (%eax),%eax
80100dd4:	89 04 24             	mov    %eax,(%esp)
80100dd7:	e8 61 44 00 00       	call   8010523d <strlen>
80100ddc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ddf:	29 c2                	sub    %eax,%edx
80100de1:	89 d0                	mov    %edx,%eax
80100de3:	48                   	dec    %eax
80100de4:	83 e0 fc             	and    $0xfffffffc,%eax
80100de7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ded:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df7:	01 d0                	add    %edx,%eax
80100df9:	8b 00                	mov    (%eax),%eax
80100dfb:	89 04 24             	mov    %eax,(%esp)
80100dfe:	e8 3a 44 00 00       	call   8010523d <strlen>
80100e03:	40                   	inc    %eax
80100e04:	89 c2                	mov    %eax,%edx
80100e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e09:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e13:	01 c8                	add    %ecx,%eax
80100e15:	8b 00                	mov    (%eax),%eax
80100e17:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100e1b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e22:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e29:	89 04 24             	mov    %eax,(%esp)
80100e2c:	e8 65 72 00 00       	call   80108096 <copyout>
80100e31:	85 c0                	test   %eax,%eax
80100e33:	79 05                	jns    80100e3a <exec+0x2d2>
      goto bad;
80100e35:	e9 3d 01 00 00       	jmp    80100f77 <exec+0x40f>
    ustack[3+argc] = sp;
80100e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3d:	8d 50 03             	lea    0x3(%eax),%edx
80100e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e43:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e4a:	ff 45 e4             	incl   -0x1c(%ebp)
80100e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e57:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e5a:	01 d0                	add    %edx,%eax
80100e5c:	8b 00                	mov    (%eax),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	0f 85 52 ff ff ff    	jne    80100db8 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e69:	83 c0 03             	add    $0x3,%eax
80100e6c:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e73:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e77:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e7e:	ff ff ff 
  ustack[1] = argc;
80100e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e84:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8d:	40                   	inc    %eax
80100e8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e98:	29 d0                	sub    %edx,%eax
80100e9a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea3:	83 c0 04             	add    $0x4,%eax
80100ea6:	c1 e0 02             	shl    $0x2,%eax
80100ea9:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eaf:	83 c0 04             	add    $0x4,%eax
80100eb2:	c1 e0 02             	shl    $0x2,%eax
80100eb5:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100eb9:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ebf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100eca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 c1 71 00 00       	call   80108096 <copyout>
80100ed5:	85 c0                	test   %eax,%eax
80100ed7:	79 05                	jns    80100ede <exec+0x376>
    goto bad;
80100ed9:	e9 99 00 00 00       	jmp    80100f77 <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ede:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eea:	eb 13                	jmp    80100eff <exec+0x397>
    if(*s == '/')
80100eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eef:	8a 00                	mov    (%eax),%al
80100ef1:	3c 2f                	cmp    $0x2f,%al
80100ef3:	75 07                	jne    80100efc <exec+0x394>
      last = s+1;
80100ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef8:	40                   	inc    %eax
80100ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100efc:	ff 45 f4             	incl   -0xc(%ebp)
80100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f02:	8a 00                	mov    (%eax),%al
80100f04:	84 c0                	test   %al,%al
80100f06:	75 e4                	jne    80100eec <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f0b:	8d 50 6c             	lea    0x6c(%eax),%edx
80100f0e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100f15:	00 
80100f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f19:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f1d:	89 14 24             	mov    %edx,(%esp)
80100f20:	e8 d1 42 00 00       	call   801051f6 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f25:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f28:	8b 40 04             	mov    0x4(%eax),%eax
80100f2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f34:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f3d:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f42:	8b 40 18             	mov    0x18(%eax),%eax
80100f45:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f4b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f51:	8b 40 18             	mov    0x18(%eax),%eax
80100f54:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f57:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f5d:	89 04 24             	mov    %eax,(%esp)
80100f60:	e8 17 6a 00 00       	call   8010797c <switchuvm>
  freevm(oldpgdir);
80100f65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f68:	89 04 24             	mov    %eax,(%esp)
80100f6b:	e8 d8 6e 00 00       	call   80107e48 <freevm>
  return 0;
80100f70:	b8 00 00 00 00       	mov    $0x0,%eax
80100f75:	eb 2c                	jmp    80100fa3 <exec+0x43b>

 bad:
  if(pgdir)
80100f77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f7b:	74 0b                	je     80100f88 <exec+0x420>
    freevm(pgdir);
80100f7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f80:	89 04 24             	mov    %eax,(%esp)
80100f83:	e8 c0 6e 00 00       	call   80107e48 <freevm>
  if(ip){
80100f88:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f8c:	74 10                	je     80100f9e <exec+0x436>
    iunlockput(ip);
80100f8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f91:	89 04 24             	mov    %eax,(%esp)
80100f94:	e8 ec 0b 00 00       	call   80101b85 <iunlockput>
    end_op();
80100f99:	e8 63 25 00 00       	call   80103501 <end_op>
  }
  return -1;
80100f9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fa3:	c9                   	leave  
80100fa4:	c3                   	ret    
80100fa5:	00 00                	add    %al,(%eax)
	...

80100fa8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fa8:	55                   	push   %ebp
80100fa9:	89 e5                	mov    %esp,%ebp
80100fab:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100fae:	c7 44 24 04 d7 81 10 	movl   $0x801081d7,0x4(%esp)
80100fb5:	80 
80100fb6:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100fbd:	e8 a4 3d 00 00       	call   80104d66 <initlock>
}
80100fc2:	c9                   	leave  
80100fc3:	c3                   	ret    

80100fc4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fca:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100fd1:	e8 b1 3d 00 00       	call   80104d87 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd6:	c7 45 f4 74 10 11 80 	movl   $0x80111074,-0xc(%ebp)
80100fdd:	eb 29                	jmp    80101008 <filealloc+0x44>
    if(f->ref == 0){
80100fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe2:	8b 40 04             	mov    0x4(%eax),%eax
80100fe5:	85 c0                	test   %eax,%eax
80100fe7:	75 1b                	jne    80101004 <filealloc+0x40>
      f->ref = 1;
80100fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fec:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100ff3:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100ffa:	e8 f2 3d 00 00       	call   80104df1 <release>
      return f;
80100fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101002:	eb 1e                	jmp    80101022 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101004:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101008:	81 7d f4 d4 19 11 80 	cmpl   $0x801119d4,-0xc(%ebp)
8010100f:	72 ce                	jb     80100fdf <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101011:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101018:	e8 d4 3d 00 00       	call   80104df1 <release>
  return 0;
8010101d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101022:	c9                   	leave  
80101023:	c3                   	ret    

80101024 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
8010102a:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101031:	e8 51 3d 00 00       	call   80104d87 <acquire>
  if(f->ref < 1)
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	8b 40 04             	mov    0x4(%eax),%eax
8010103c:	85 c0                	test   %eax,%eax
8010103e:	7f 0c                	jg     8010104c <filedup+0x28>
    panic("filedup");
80101040:	c7 04 24 de 81 10 80 	movl   $0x801081de,(%esp)
80101047:	e8 08 f5 ff ff       	call   80100554 <panic>
  f->ref++;
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	8d 50 01             	lea    0x1(%eax),%edx
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010105b:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101062:	e8 8a 3d 00 00       	call   80104df1 <release>
  return f;
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010106a:	c9                   	leave  
8010106b:	c3                   	ret    

8010106c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010106c:	55                   	push   %ebp
8010106d:	89 e5                	mov    %esp,%ebp
8010106f:	57                   	push   %edi
80101070:	56                   	push   %esi
80101071:	53                   	push   %ebx
80101072:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101075:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
8010107c:	e8 06 3d 00 00       	call   80104d87 <acquire>
  if(f->ref < 1)
80101081:	8b 45 08             	mov    0x8(%ebp),%eax
80101084:	8b 40 04             	mov    0x4(%eax),%eax
80101087:	85 c0                	test   %eax,%eax
80101089:	7f 0c                	jg     80101097 <fileclose+0x2b>
    panic("fileclose");
8010108b:	c7 04 24 e6 81 10 80 	movl   $0x801081e6,(%esp)
80101092:	e8 bd f4 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
80101097:	8b 45 08             	mov    0x8(%ebp),%eax
8010109a:	8b 40 04             	mov    0x4(%eax),%eax
8010109d:	8d 50 ff             	lea    -0x1(%eax),%edx
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	89 50 04             	mov    %edx,0x4(%eax)
801010a6:	8b 45 08             	mov    0x8(%ebp),%eax
801010a9:	8b 40 04             	mov    0x4(%eax),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	7e 0e                	jle    801010be <fileclose+0x52>
    release(&ftable.lock);
801010b0:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801010b7:	e8 35 3d 00 00       	call   80104df1 <release>
801010bc:	eb 70                	jmp    8010112e <fileclose+0xc2>
    return;
  }
  ff = *f;
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
801010c1:	8d 55 d0             	lea    -0x30(%ebp),%edx
801010c4:	89 c3                	mov    %eax,%ebx
801010c6:	b8 06 00 00 00       	mov    $0x6,%eax
801010cb:	89 d7                	mov    %edx,%edi
801010cd:	89 de                	mov    %ebx,%esi
801010cf:	89 c1                	mov    %eax,%ecx
801010d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
801010e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010e6:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801010ed:	e8 ff 3c 00 00       	call   80104df1 <release>

  if(ff.type == FD_PIPE)
801010f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010f5:	83 f8 01             	cmp    $0x1,%eax
801010f8:	75 17                	jne    80101111 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
801010fa:	8a 45 d9             	mov    -0x27(%ebp),%al
801010fd:	0f be d0             	movsbl %al,%edx
80101100:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101103:	89 54 24 04          	mov    %edx,0x4(%esp)
80101107:	89 04 24             	mov    %eax,(%esp)
8010110a:	e8 00 2d 00 00       	call   80103e0f <pipeclose>
8010110f:	eb 1d                	jmp    8010112e <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101111:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101114:	83 f8 02             	cmp    $0x2,%eax
80101117:	75 15                	jne    8010112e <fileclose+0xc2>
    begin_op();
80101119:	e8 61 23 00 00       	call   8010347f <begin_op>
    iput(ff.ip);
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	89 04 24             	mov    %eax,(%esp)
80101124:	e8 ab 09 00 00       	call   80101ad4 <iput>
    end_op();
80101129:	e8 d3 23 00 00       	call   80103501 <end_op>
  }
}
8010112e:	83 c4 3c             	add    $0x3c,%esp
80101131:	5b                   	pop    %ebx
80101132:	5e                   	pop    %esi
80101133:	5f                   	pop    %edi
80101134:	5d                   	pop    %ebp
80101135:	c3                   	ret    

80101136 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101136:	55                   	push   %ebp
80101137:	89 e5                	mov    %esp,%ebp
80101139:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010113c:	8b 45 08             	mov    0x8(%ebp),%eax
8010113f:	8b 00                	mov    (%eax),%eax
80101141:	83 f8 02             	cmp    $0x2,%eax
80101144:	75 38                	jne    8010117e <filestat+0x48>
    ilock(f->ip);
80101146:	8b 45 08             	mov    0x8(%ebp),%eax
80101149:	8b 40 10             	mov    0x10(%eax),%eax
8010114c:	89 04 24             	mov    %eax,(%esp)
8010114f:	e8 32 08 00 00       	call   80101986 <ilock>
    stati(f->ip, st);
80101154:	8b 45 08             	mov    0x8(%ebp),%eax
80101157:	8b 40 10             	mov    0x10(%eax),%eax
8010115a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101161:	89 04 24             	mov    %eax,(%esp)
80101164:	e8 70 0c 00 00       	call   80101dd9 <stati>
    iunlock(f->ip);
80101169:	8b 45 08             	mov    0x8(%ebp),%eax
8010116c:	8b 40 10             	mov    0x10(%eax),%eax
8010116f:	89 04 24             	mov    %eax,(%esp)
80101172:	e8 19 09 00 00       	call   80101a90 <iunlock>
    return 0;
80101177:	b8 00 00 00 00       	mov    $0x0,%eax
8010117c:	eb 05                	jmp    80101183 <filestat+0x4d>
  }
  return -1;
8010117e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101183:	c9                   	leave  
80101184:	c3                   	ret    

80101185 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101185:	55                   	push   %ebp
80101186:	89 e5                	mov    %esp,%ebp
80101188:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	8a 40 08             	mov    0x8(%eax),%al
80101191:	84 c0                	test   %al,%al
80101193:	75 0a                	jne    8010119f <fileread+0x1a>
    return -1;
80101195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010119a:	e9 9f 00 00 00       	jmp    8010123e <fileread+0xb9>
  if(f->type == FD_PIPE)
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 00                	mov    (%eax),%eax
801011a4:	83 f8 01             	cmp    $0x1,%eax
801011a7:	75 1e                	jne    801011c7 <fileread+0x42>
    return piperead(f->pipe, addr, n);
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	8b 40 0c             	mov    0xc(%eax),%eax
801011af:	8b 55 10             	mov    0x10(%ebp),%edx
801011b2:	89 54 24 08          	mov    %edx,0x8(%esp)
801011b6:	8b 55 0c             	mov    0xc(%ebp),%edx
801011b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801011bd:	89 04 24             	mov    %eax,(%esp)
801011c0:	e8 c8 2d 00 00       	call   80103f8d <piperead>
801011c5:	eb 77                	jmp    8010123e <fileread+0xb9>
  if(f->type == FD_INODE){
801011c7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ca:	8b 00                	mov    (%eax),%eax
801011cc:	83 f8 02             	cmp    $0x2,%eax
801011cf:	75 61                	jne    80101232 <fileread+0xad>
    ilock(f->ip);
801011d1:	8b 45 08             	mov    0x8(%ebp),%eax
801011d4:	8b 40 10             	mov    0x10(%eax),%eax
801011d7:	89 04 24             	mov    %eax,(%esp)
801011da:	e8 a7 07 00 00       	call   80101986 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011df:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011e2:	8b 45 08             	mov    0x8(%ebp),%eax
801011e5:	8b 50 14             	mov    0x14(%eax),%edx
801011e8:	8b 45 08             	mov    0x8(%ebp),%eax
801011eb:	8b 40 10             	mov    0x10(%eax),%eax
801011ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011f2:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801011fd:	89 04 24             	mov    %eax,(%esp)
80101200:	e8 18 0c 00 00       	call   80101e1d <readi>
80101205:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010120c:	7e 11                	jle    8010121f <fileread+0x9a>
      f->off += r;
8010120e:	8b 45 08             	mov    0x8(%ebp),%eax
80101211:	8b 50 14             	mov    0x14(%eax),%edx
80101214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101217:	01 c2                	add    %eax,%edx
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	8b 40 10             	mov    0x10(%eax),%eax
80101225:	89 04 24             	mov    %eax,(%esp)
80101228:	e8 63 08 00 00       	call   80101a90 <iunlock>
    return r;
8010122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101230:	eb 0c                	jmp    8010123e <fileread+0xb9>
  }
  panic("fileread");
80101232:	c7 04 24 f0 81 10 80 	movl   $0x801081f0,(%esp)
80101239:	e8 16 f3 ff ff       	call   80100554 <panic>
}
8010123e:	c9                   	leave  
8010123f:	c3                   	ret    

80101240 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	53                   	push   %ebx
80101244:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101247:	8b 45 08             	mov    0x8(%ebp),%eax
8010124a:	8a 40 09             	mov    0x9(%eax),%al
8010124d:	84 c0                	test   %al,%al
8010124f:	75 0a                	jne    8010125b <filewrite+0x1b>
    return -1;
80101251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101256:	e9 20 01 00 00       	jmp    8010137b <filewrite+0x13b>
  if(f->type == FD_PIPE)
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 00                	mov    (%eax),%eax
80101260:	83 f8 01             	cmp    $0x1,%eax
80101263:	75 21                	jne    80101286 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 40 0c             	mov    0xc(%eax),%eax
8010126b:	8b 55 10             	mov    0x10(%ebp),%edx
8010126e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101272:	8b 55 0c             	mov    0xc(%ebp),%edx
80101275:	89 54 24 04          	mov    %edx,0x4(%esp)
80101279:	89 04 24             	mov    %eax,(%esp)
8010127c:	e8 20 2c 00 00       	call   80103ea1 <pipewrite>
80101281:	e9 f5 00 00 00       	jmp    8010137b <filewrite+0x13b>
  if(f->type == FD_INODE){
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	8b 00                	mov    (%eax),%eax
8010128b:	83 f8 02             	cmp    $0x2,%eax
8010128e:	0f 85 db 00 00 00    	jne    8010136f <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101294:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010129b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012a2:	e9 a8 00 00 00       	jmp    8010134f <filewrite+0x10f>
      int n1 = n - i;
801012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012aa:	8b 55 10             	mov    0x10(%ebp),%edx
801012ad:	29 c2                	sub    %eax,%edx
801012af:	89 d0                	mov    %edx,%eax
801012b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012ba:	7e 06                	jle    801012c2 <filewrite+0x82>
        n1 = max;
801012bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012c2:	e8 b8 21 00 00       	call   8010347f <begin_op>
      ilock(f->ip);
801012c7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ca:	8b 40 10             	mov    0x10(%eax),%eax
801012cd:	89 04 24             	mov    %eax,(%esp)
801012d0:	e8 b1 06 00 00       	call   80101986 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	8b 50 14             	mov    0x14(%eax),%edx
801012de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801012e4:	01 c3                	add    %eax,%ebx
801012e6:	8b 45 08             	mov    0x8(%ebp),%eax
801012e9:	8b 40 10             	mov    0x10(%eax),%eax
801012ec:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012f0:	89 54 24 08          	mov    %edx,0x8(%esp)
801012f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012f8:	89 04 24             	mov    %eax,(%esp)
801012fb:	e8 81 0c 00 00       	call   80101f81 <writei>
80101300:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101303:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101307:	7e 11                	jle    8010131a <filewrite+0xda>
        f->off += r;
80101309:	8b 45 08             	mov    0x8(%ebp),%eax
8010130c:	8b 50 14             	mov    0x14(%eax),%edx
8010130f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101312:	01 c2                	add    %eax,%edx
80101314:	8b 45 08             	mov    0x8(%ebp),%eax
80101317:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010131a:	8b 45 08             	mov    0x8(%ebp),%eax
8010131d:	8b 40 10             	mov    0x10(%eax),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 68 07 00 00       	call   80101a90 <iunlock>
      end_op();
80101328:	e8 d4 21 00 00       	call   80103501 <end_op>

      if(r < 0)
8010132d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101331:	79 02                	jns    80101335 <filewrite+0xf5>
        break;
80101333:	eb 26                	jmp    8010135b <filewrite+0x11b>
      if(r != n1)
80101335:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101338:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010133b:	74 0c                	je     80101349 <filewrite+0x109>
        panic("short filewrite");
8010133d:	c7 04 24 f9 81 10 80 	movl   $0x801081f9,(%esp)
80101344:	e8 0b f2 ff ff       	call   80100554 <panic>
      i += r;
80101349:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010134c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101352:	3b 45 10             	cmp    0x10(%ebp),%eax
80101355:	0f 8c 4c ff ff ff    	jl     801012a7 <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101361:	75 05                	jne    80101368 <filewrite+0x128>
80101363:	8b 45 10             	mov    0x10(%ebp),%eax
80101366:	eb 05                	jmp    8010136d <filewrite+0x12d>
80101368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010136d:	eb 0c                	jmp    8010137b <filewrite+0x13b>
  }
  panic("filewrite");
8010136f:	c7 04 24 09 82 10 80 	movl   $0x80108209,(%esp)
80101376:	e8 d9 f1 ff ff       	call   80100554 <panic>
}
8010137b:	83 c4 24             	add    $0x24,%esp
8010137e:	5b                   	pop    %ebx
8010137f:	5d                   	pop    %ebp
80101380:	c3                   	ret    
80101381:	00 00                	add    %al,(%eax)
	...

80101384 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101394:	00 
80101395:	89 04 24             	mov    %eax,(%esp)
80101398:	e8 18 ee ff ff       	call   801001b5 <bread>
8010139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a3:	83 c0 5c             	add    $0x5c,%eax
801013a6:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013ad:	00 
801013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801013b5:	89 04 24             	mov    %eax,(%esp)
801013b8:	e8 f6 3c 00 00       	call   801050b3 <memmove>
  brelse(bp);
801013bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c0:	89 04 24             	mov    %eax,(%esp)
801013c3:	e8 64 ee ff ff       	call   8010022c <brelse>
}
801013c8:	c9                   	leave  
801013c9:	c3                   	ret    

801013ca <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ca:	55                   	push   %ebp
801013cb:	89 e5                	mov    %esp,%ebp
801013cd:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
801013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801013d3:	8b 45 08             	mov    0x8(%ebp),%eax
801013d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801013da:	89 04 24             	mov    %eax,(%esp)
801013dd:	e8 d3 ed ff ff       	call   801001b5 <bread>
801013e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e8:	83 c0 5c             	add    $0x5c,%eax
801013eb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013f2:	00 
801013f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013fa:	00 
801013fb:	89 04 24             	mov    %eax,(%esp)
801013fe:	e8 e7 3b 00 00       	call   80104fea <memset>
  log_write(bp);
80101403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101406:	89 04 24             	mov    %eax,(%esp)
80101409:	e8 75 22 00 00       	call   80103683 <log_write>
  brelse(bp);
8010140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101411:	89 04 24             	mov    %eax,(%esp)
80101414:	e8 13 ee ff ff       	call   8010022c <brelse>
}
80101419:	c9                   	leave  
8010141a:	c3                   	ret    

8010141b <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141b:	55                   	push   %ebp
8010141c:	89 e5                	mov    %esp,%ebp
8010141e:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101421:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010142f:	e9 03 01 00 00       	jmp    80101537 <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
80101434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101437:	85 c0                	test   %eax,%eax
80101439:	79 05                	jns    80101440 <balloc+0x25>
8010143b:	05 ff 0f 00 00       	add    $0xfff,%eax
80101440:	c1 f8 0c             	sar    $0xc,%eax
80101443:	89 c2                	mov    %eax,%edx
80101445:	a1 58 1a 11 80       	mov    0x80111a58,%eax
8010144a:	01 d0                	add    %edx,%eax
8010144c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101450:	8b 45 08             	mov    0x8(%ebp),%eax
80101453:	89 04 24             	mov    %eax,(%esp)
80101456:	e8 5a ed ff ff       	call   801001b5 <bread>
8010145b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101465:	e9 9b 00 00 00       	jmp    80101505 <balloc+0xea>
      m = 1 << (bi % 8);
8010146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146d:	25 07 00 00 80       	and    $0x80000007,%eax
80101472:	85 c0                	test   %eax,%eax
80101474:	79 05                	jns    8010147b <balloc+0x60>
80101476:	48                   	dec    %eax
80101477:	83 c8 f8             	or     $0xfffffff8,%eax
8010147a:	40                   	inc    %eax
8010147b:	ba 01 00 00 00       	mov    $0x1,%edx
80101480:	88 c1                	mov    %al,%cl
80101482:	d3 e2                	shl    %cl,%edx
80101484:	89 d0                	mov    %edx,%eax
80101486:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148c:	85 c0                	test   %eax,%eax
8010148e:	79 03                	jns    80101493 <balloc+0x78>
80101490:	83 c0 07             	add    $0x7,%eax
80101493:	c1 f8 03             	sar    $0x3,%eax
80101496:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101499:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
8010149d:	0f b6 c0             	movzbl %al,%eax
801014a0:	23 45 e8             	and    -0x18(%ebp),%eax
801014a3:	85 c0                	test   %eax,%eax
801014a5:	75 5b                	jne    80101502 <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014aa:	85 c0                	test   %eax,%eax
801014ac:	79 03                	jns    801014b1 <balloc+0x96>
801014ae:	83 c0 07             	add    $0x7,%eax
801014b1:	c1 f8 03             	sar    $0x3,%eax
801014b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014b7:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
801014bb:	88 d1                	mov    %dl,%cl
801014bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c0:	09 ca                	or     %ecx,%edx
801014c2:	88 d1                	mov    %dl,%cl
801014c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c7:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
801014cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ce:	89 04 24             	mov    %eax,(%esp)
801014d1:	e8 ad 21 00 00       	call   80103683 <log_write>
        brelse(bp);
801014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014d9:	89 04 24             	mov    %eax,(%esp)
801014dc:	e8 4b ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
801014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e7:	01 c2                	add    %eax,%edx
801014e9:	8b 45 08             	mov    0x8(%ebp),%eax
801014ec:	89 54 24 04          	mov    %edx,0x4(%esp)
801014f0:	89 04 24             	mov    %eax,(%esp)
801014f3:	e8 d2 fe ff ff       	call   801013ca <bzero>
        return b + bi;
801014f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014fe:	01 d0                	add    %edx,%eax
80101500:	eb 51                	jmp    80101553 <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101502:	ff 45 f0             	incl   -0x10(%ebp)
80101505:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010150c:	7f 17                	jg     80101525 <balloc+0x10a>
8010150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101511:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101514:	01 d0                	add    %edx,%eax
80101516:	89 c2                	mov    %eax,%edx
80101518:	a1 40 1a 11 80       	mov    0x80111a40,%eax
8010151d:	39 c2                	cmp    %eax,%edx
8010151f:	0f 82 45 ff ff ff    	jb     8010146a <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101525:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101528:	89 04 24             	mov    %eax,(%esp)
8010152b:	e8 fc ec ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101530:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101537:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153a:	a1 40 1a 11 80       	mov    0x80111a40,%eax
8010153f:	39 c2                	cmp    %eax,%edx
80101541:	0f 82 ed fe ff ff    	jb     80101434 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101547:	c7 04 24 14 82 10 80 	movl   $0x80108214,(%esp)
8010154e:	e8 01 f0 ff ff       	call   80100554 <panic>
}
80101553:	c9                   	leave  
80101554:	c3                   	ret    

80101555 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101555:	55                   	push   %ebp
80101556:	89 e5                	mov    %esp,%ebp
80101558:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010155b:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
80101562:	80 
80101563:	8b 45 08             	mov    0x8(%ebp),%eax
80101566:	89 04 24             	mov    %eax,(%esp)
80101569:	e8 16 fe ff ff       	call   80101384 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010156e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101571:	c1 e8 0c             	shr    $0xc,%eax
80101574:	89 c2                	mov    %eax,%edx
80101576:	a1 58 1a 11 80       	mov    0x80111a58,%eax
8010157b:	01 c2                	add    %eax,%edx
8010157d:	8b 45 08             	mov    0x8(%ebp),%eax
80101580:	89 54 24 04          	mov    %edx,0x4(%esp)
80101584:	89 04 24             	mov    %eax,(%esp)
80101587:	e8 29 ec ff ff       	call   801001b5 <bread>
8010158c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010158f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101592:	25 ff 0f 00 00       	and    $0xfff,%eax
80101597:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159d:	25 07 00 00 80       	and    $0x80000007,%eax
801015a2:	85 c0                	test   %eax,%eax
801015a4:	79 05                	jns    801015ab <bfree+0x56>
801015a6:	48                   	dec    %eax
801015a7:	83 c8 f8             	or     $0xfffffff8,%eax
801015aa:	40                   	inc    %eax
801015ab:	ba 01 00 00 00       	mov    $0x1,%edx
801015b0:	88 c1                	mov    %al,%cl
801015b2:	d3 e2                	shl    %cl,%edx
801015b4:	89 d0                	mov    %edx,%eax
801015b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015bc:	85 c0                	test   %eax,%eax
801015be:	79 03                	jns    801015c3 <bfree+0x6e>
801015c0:	83 c0 07             	add    $0x7,%eax
801015c3:	c1 f8 03             	sar    $0x3,%eax
801015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c9:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
801015cd:	0f b6 c0             	movzbl %al,%eax
801015d0:	23 45 ec             	and    -0x14(%ebp),%eax
801015d3:	85 c0                	test   %eax,%eax
801015d5:	75 0c                	jne    801015e3 <bfree+0x8e>
    panic("freeing free block");
801015d7:	c7 04 24 2a 82 10 80 	movl   $0x8010822a,(%esp)
801015de:	e8 71 ef ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
801015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e6:	85 c0                	test   %eax,%eax
801015e8:	79 03                	jns    801015ed <bfree+0x98>
801015ea:	83 c0 07             	add    $0x7,%eax
801015ed:	c1 f8 03             	sar    $0x3,%eax
801015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015f3:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
801015f7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015fa:	f7 d1                	not    %ecx
801015fc:	21 ca                	and    %ecx,%edx
801015fe:	88 d1                	mov    %dl,%cl
80101600:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101603:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010160a:	89 04 24             	mov    %eax,(%esp)
8010160d:	e8 71 20 00 00       	call   80103683 <log_write>
  brelse(bp);
80101612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101615:	89 04 24             	mov    %eax,(%esp)
80101618:	e8 0f ec ff ff       	call   8010022c <brelse>
}
8010161d:	c9                   	leave  
8010161e:	c3                   	ret    

8010161f <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010161f:	55                   	push   %ebp
80101620:	89 e5                	mov    %esp,%ebp
80101622:	57                   	push   %edi
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
80101628:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010162f:	c7 44 24 04 3d 82 10 	movl   $0x8010823d,0x4(%esp)
80101636:	80 
80101637:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010163e:	e8 23 37 00 00       	call   80104d66 <initlock>
  for(i = 0; i < NINODE; i++) {
80101643:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010164a:	eb 2b                	jmp    80101677 <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
8010164c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010164f:	89 d0                	mov    %edx,%eax
80101651:	c1 e0 03             	shl    $0x3,%eax
80101654:	01 d0                	add    %edx,%eax
80101656:	c1 e0 04             	shl    $0x4,%eax
80101659:	83 c0 30             	add    $0x30,%eax
8010165c:	05 60 1a 11 80       	add    $0x80111a60,%eax
80101661:	83 c0 10             	add    $0x10,%eax
80101664:	c7 44 24 04 44 82 10 	movl   $0x80108244,0x4(%esp)
8010166b:	80 
8010166c:	89 04 24             	mov    %eax,(%esp)
8010166f:	e8 b4 35 00 00       	call   80104c28 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101674:	ff 45 e4             	incl   -0x1c(%ebp)
80101677:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010167b:	7e cf                	jle    8010164c <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010167d:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
80101684:	80 
80101685:	8b 45 08             	mov    0x8(%ebp),%eax
80101688:	89 04 24             	mov    %eax,(%esp)
8010168b:	e8 f4 fc ff ff       	call   80101384 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101690:	a1 58 1a 11 80       	mov    0x80111a58,%eax
80101695:	8b 3d 54 1a 11 80    	mov    0x80111a54,%edi
8010169b:	8b 35 50 1a 11 80    	mov    0x80111a50,%esi
801016a1:	8b 1d 4c 1a 11 80    	mov    0x80111a4c,%ebx
801016a7:	8b 0d 48 1a 11 80    	mov    0x80111a48,%ecx
801016ad:	8b 15 44 1a 11 80    	mov    0x80111a44,%edx
801016b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801016b6:	8b 15 40 1a 11 80    	mov    0x80111a40,%edx
801016bc:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801016c0:	89 7c 24 18          	mov    %edi,0x18(%esp)
801016c4:	89 74 24 14          	mov    %esi,0x14(%esp)
801016c8:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801016cc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801016d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801016d7:	89 d0                	mov    %edx,%eax
801016d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801016dd:	c7 04 24 4c 82 10 80 	movl   $0x8010824c,(%esp)
801016e4:	e8 d8 ec ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801016e9:	83 c4 4c             	add    $0x4c,%esp
801016ec:	5b                   	pop    %ebx
801016ed:	5e                   	pop    %esi
801016ee:	5f                   	pop    %edi
801016ef:	5d                   	pop    %ebp
801016f0:	c3                   	ret    

801016f1 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801016f1:	55                   	push   %ebp
801016f2:	89 e5                	mov    %esp,%ebp
801016f4:	83 ec 28             	sub    $0x28,%esp
801016f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801016fa:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016fe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101705:	e9 9b 00 00 00       	jmp    801017a5 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
8010170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170d:	c1 e8 03             	shr    $0x3,%eax
80101710:	89 c2                	mov    %eax,%edx
80101712:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101717:	01 d0                	add    %edx,%eax
80101719:	89 44 24 04          	mov    %eax,0x4(%esp)
8010171d:	8b 45 08             	mov    0x8(%ebp),%eax
80101720:	89 04 24             	mov    %eax,(%esp)
80101723:	e8 8d ea ff ff       	call   801001b5 <bread>
80101728:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101734:	83 e0 07             	and    $0x7,%eax
80101737:	c1 e0 06             	shl    $0x6,%eax
8010173a:	01 d0                	add    %edx,%eax
8010173c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010173f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101742:	8b 00                	mov    (%eax),%eax
80101744:	66 85 c0             	test   %ax,%ax
80101747:	75 4e                	jne    80101797 <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
80101749:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101750:	00 
80101751:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101758:	00 
80101759:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010175c:	89 04 24             	mov    %eax,(%esp)
8010175f:	e8 86 38 00 00       	call   80104fea <memset>
      dip->type = type;
80101764:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010176a:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
8010176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101770:	89 04 24             	mov    %eax,(%esp)
80101773:	e8 0b 1f 00 00       	call   80103683 <log_write>
      brelse(bp);
80101778:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177b:	89 04 24             	mov    %eax,(%esp)
8010177e:	e8 a9 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101786:	89 44 24 04          	mov    %eax,0x4(%esp)
8010178a:	8b 45 08             	mov    0x8(%ebp),%eax
8010178d:	89 04 24             	mov    %eax,(%esp)
80101790:	e8 ea 00 00 00       	call   8010187f <iget>
80101795:	eb 2a                	jmp    801017c1 <ialloc+0xd0>
    }
    brelse(bp);
80101797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179a:	89 04 24             	mov    %eax,(%esp)
8010179d:	e8 8a ea ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017a2:	ff 45 f4             	incl   -0xc(%ebp)
801017a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017a8:	a1 48 1a 11 80       	mov    0x80111a48,%eax
801017ad:	39 c2                	cmp    %eax,%edx
801017af:	0f 82 55 ff ff ff    	jb     8010170a <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801017b5:	c7 04 24 9f 82 10 80 	movl   $0x8010829f,(%esp)
801017bc:	e8 93 ed ff ff       	call   80100554 <panic>
}
801017c1:	c9                   	leave  
801017c2:	c3                   	ret    

801017c3 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801017c3:	55                   	push   %ebp
801017c4:	89 e5                	mov    %esp,%ebp
801017c6:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c9:	8b 45 08             	mov    0x8(%ebp),%eax
801017cc:	8b 40 04             	mov    0x4(%eax),%eax
801017cf:	c1 e8 03             	shr    $0x3,%eax
801017d2:	89 c2                	mov    %eax,%edx
801017d4:	a1 54 1a 11 80       	mov    0x80111a54,%eax
801017d9:	01 c2                	add    %eax,%edx
801017db:	8b 45 08             	mov    0x8(%ebp),%eax
801017de:	8b 00                	mov    (%eax),%eax
801017e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801017e4:	89 04 24             	mov    %eax,(%esp)
801017e7:	e8 c9 e9 ff ff       	call   801001b5 <bread>
801017ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f2:	8d 50 5c             	lea    0x5c(%eax),%edx
801017f5:	8b 45 08             	mov    0x8(%ebp),%eax
801017f8:	8b 40 04             	mov    0x4(%eax),%eax
801017fb:	83 e0 07             	and    $0x7,%eax
801017fe:	c1 e0 06             	shl    $0x6,%eax
80101801:	01 d0                	add    %edx,%eax
80101803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101806:	8b 45 08             	mov    0x8(%ebp),%eax
80101809:	8b 40 50             	mov    0x50(%eax),%eax
8010180c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010180f:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101812:	8b 45 08             	mov    0x8(%ebp),%eax
80101815:	66 8b 40 52          	mov    0x52(%eax),%ax
80101819:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010181c:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101820:	8b 45 08             	mov    0x8(%ebp),%eax
80101823:	8b 40 54             	mov    0x54(%eax),%eax
80101826:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101829:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
8010182d:	8b 45 08             	mov    0x8(%ebp),%eax
80101830:	66 8b 40 56          	mov    0x56(%eax),%ax
80101834:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101837:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
8010183b:	8b 45 08             	mov    0x8(%ebp),%eax
8010183e:	8b 50 58             	mov    0x58(%eax),%edx
80101841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101844:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101847:	8b 45 08             	mov    0x8(%ebp),%eax
8010184a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010184d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101850:	83 c0 0c             	add    $0xc,%eax
80101853:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010185a:	00 
8010185b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010185f:	89 04 24             	mov    %eax,(%esp)
80101862:	e8 4c 38 00 00       	call   801050b3 <memmove>
  log_write(bp);
80101867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186a:	89 04 24             	mov    %eax,(%esp)
8010186d:	e8 11 1e 00 00       	call   80103683 <log_write>
  brelse(bp);
80101872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101875:	89 04 24             	mov    %eax,(%esp)
80101878:	e8 af e9 ff ff       	call   8010022c <brelse>
}
8010187d:	c9                   	leave  
8010187e:	c3                   	ret    

8010187f <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010187f:	55                   	push   %ebp
80101880:	89 e5                	mov    %esp,%ebp
80101882:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101885:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010188c:	e8 f6 34 00 00       	call   80104d87 <acquire>

  // Is the inode already cached?
  empty = 0;
80101891:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101898:	c7 45 f4 94 1a 11 80 	movl   $0x80111a94,-0xc(%ebp)
8010189f:	eb 5c                	jmp    801018fd <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	8b 40 08             	mov    0x8(%eax),%eax
801018a7:	85 c0                	test   %eax,%eax
801018a9:	7e 35                	jle    801018e0 <iget+0x61>
801018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ae:	8b 00                	mov    (%eax),%eax
801018b0:	3b 45 08             	cmp    0x8(%ebp),%eax
801018b3:	75 2b                	jne    801018e0 <iget+0x61>
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	8b 40 04             	mov    0x4(%eax),%eax
801018bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018be:	75 20                	jne    801018e0 <iget+0x61>
      ip->ref++;
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	8b 40 08             	mov    0x8(%eax),%eax
801018c6:	8d 50 01             	lea    0x1(%eax),%edx
801018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cc:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018cf:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801018d6:	e8 16 35 00 00       	call   80104df1 <release>
      return ip;
801018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018de:	eb 72                	jmp    80101952 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e4:	75 10                	jne    801018f6 <iget+0x77>
801018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e9:	8b 40 08             	mov    0x8(%eax),%eax
801018ec:	85 c0                	test   %eax,%eax
801018ee:	75 06                	jne    801018f6 <iget+0x77>
      empty = ip;
801018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f6:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018fd:	81 7d f4 b4 36 11 80 	cmpl   $0x801136b4,-0xc(%ebp)
80101904:	72 9b                	jb     801018a1 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010190a:	75 0c                	jne    80101918 <iget+0x99>
    panic("iget: no inodes");
8010190c:	c7 04 24 b1 82 10 80 	movl   $0x801082b1,(%esp)
80101913:	e8 3c ec ff ff       	call   80100554 <panic>

  ip = empty;
80101918:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101921:	8b 55 08             	mov    0x8(%ebp),%edx
80101924:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101929:	8b 55 0c             	mov    0xc(%ebp),%edx
8010192c:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101932:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193c:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101943:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010194a:	e8 a2 34 00 00       	call   80104df1 <release>

  return ip;
8010194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101952:	c9                   	leave  
80101953:	c3                   	ret    

80101954 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101954:	55                   	push   %ebp
80101955:	89 e5                	mov    %esp,%ebp
80101957:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010195a:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101961:	e8 21 34 00 00       	call   80104d87 <acquire>
  ip->ref++;
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	8b 40 08             	mov    0x8(%eax),%eax
8010196c:	8d 50 01             	lea    0x1(%eax),%edx
8010196f:	8b 45 08             	mov    0x8(%ebp),%eax
80101972:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101975:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010197c:	e8 70 34 00 00       	call   80104df1 <release>
  return ip;
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101984:	c9                   	leave  
80101985:	c3                   	ret    

80101986 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101986:	55                   	push   %ebp
80101987:	89 e5                	mov    %esp,%ebp
80101989:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010198c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101990:	74 0a                	je     8010199c <ilock+0x16>
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	8b 40 08             	mov    0x8(%eax),%eax
80101998:	85 c0                	test   %eax,%eax
8010199a:	7f 0c                	jg     801019a8 <ilock+0x22>
    panic("ilock");
8010199c:	c7 04 24 c1 82 10 80 	movl   $0x801082c1,(%esp)
801019a3:	e8 ac eb ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
801019a8:	8b 45 08             	mov    0x8(%ebp),%eax
801019ab:	83 c0 0c             	add    $0xc,%eax
801019ae:	89 04 24             	mov    %eax,(%esp)
801019b1:	e8 ac 32 00 00       	call   80104c62 <acquiresleep>

  if(ip->valid == 0){
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	8b 40 4c             	mov    0x4c(%eax),%eax
801019bc:	85 c0                	test   %eax,%eax
801019be:	0f 85 ca 00 00 00    	jne    80101a8e <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019c4:	8b 45 08             	mov    0x8(%ebp),%eax
801019c7:	8b 40 04             	mov    0x4(%eax),%eax
801019ca:	c1 e8 03             	shr    $0x3,%eax
801019cd:	89 c2                	mov    %eax,%edx
801019cf:	a1 54 1a 11 80       	mov    0x80111a54,%eax
801019d4:	01 c2                	add    %eax,%edx
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	8b 00                	mov    (%eax),%eax
801019db:	89 54 24 04          	mov    %edx,0x4(%esp)
801019df:	89 04 24             	mov    %eax,(%esp)
801019e2:	e8 ce e7 ff ff       	call   801001b5 <bread>
801019e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ed:	8d 50 5c             	lea    0x5c(%eax),%edx
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	8b 40 04             	mov    0x4(%eax),%eax
801019f6:	83 e0 07             	and    $0x7,%eax
801019f9:	c1 e0 06             	shl    $0x6,%eax
801019fc:	01 d0                	add    %edx,%eax
801019fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	8b 00                	mov    (%eax),%eax
80101a06:	8b 55 08             	mov    0x8(%ebp),%edx
80101a09:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a10:	66 8b 40 02          	mov    0x2(%eax),%ax
80101a14:	8b 55 08             	mov    0x8(%ebp),%edx
80101a17:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1e:	8b 40 04             	mov    0x4(%eax),%eax
80101a21:	8b 55 08             	mov    0x8(%ebp),%edx
80101a24:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2b:	66 8b 40 06          	mov    0x6(%eax),%ax
80101a2f:	8b 55 08             	mov    0x8(%ebp),%edx
80101a32:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a39:	8b 50 08             	mov    0x8(%eax),%edx
80101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3f:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a45:	8d 50 0c             	lea    0xc(%eax),%edx
80101a48:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4b:	83 c0 5c             	add    $0x5c,%eax
80101a4e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a55:	00 
80101a56:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a5a:	89 04 24             	mov    %eax,(%esp)
80101a5d:	e8 51 36 00 00       	call   801050b3 <memmove>
    brelse(bp);
80101a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a65:	89 04 24             	mov    %eax,(%esp)
80101a68:	e8 bf e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a70:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101a77:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7a:	8b 40 50             	mov    0x50(%eax),%eax
80101a7d:	66 85 c0             	test   %ax,%ax
80101a80:	75 0c                	jne    80101a8e <ilock+0x108>
      panic("ilock: no type");
80101a82:	c7 04 24 c7 82 10 80 	movl   $0x801082c7,(%esp)
80101a89:	e8 c6 ea ff ff       	call   80100554 <panic>
  }
}
80101a8e:	c9                   	leave  
80101a8f:	c3                   	ret    

80101a90 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a9a:	74 1c                	je     80101ab8 <iunlock+0x28>
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	83 c0 0c             	add    $0xc,%eax
80101aa2:	89 04 24             	mov    %eax,(%esp)
80101aa5:	e8 55 32 00 00       	call   80104cff <holdingsleep>
80101aaa:	85 c0                	test   %eax,%eax
80101aac:	74 0a                	je     80101ab8 <iunlock+0x28>
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	8b 40 08             	mov    0x8(%eax),%eax
80101ab4:	85 c0                	test   %eax,%eax
80101ab6:	7f 0c                	jg     80101ac4 <iunlock+0x34>
    panic("iunlock");
80101ab8:	c7 04 24 d6 82 10 80 	movl   $0x801082d6,(%esp)
80101abf:	e8 90 ea ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	83 c0 0c             	add    $0xc,%eax
80101aca:	89 04 24             	mov    %eax,(%esp)
80101acd:	e8 eb 31 00 00       	call   80104cbd <releasesleep>
}
80101ad2:	c9                   	leave  
80101ad3:	c3                   	ret    

80101ad4 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	83 c0 0c             	add    $0xc,%eax
80101ae0:	89 04 24             	mov    %eax,(%esp)
80101ae3:	e8 7a 31 00 00       	call   80104c62 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	8b 40 4c             	mov    0x4c(%eax),%eax
80101aee:	85 c0                	test   %eax,%eax
80101af0:	74 5c                	je     80101b4e <iput+0x7a>
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	66 8b 40 56          	mov    0x56(%eax),%ax
80101af9:	66 85 c0             	test   %ax,%ax
80101afc:	75 50                	jne    80101b4e <iput+0x7a>
    acquire(&icache.lock);
80101afe:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b05:	e8 7d 32 00 00       	call   80104d87 <acquire>
    int r = ip->ref;
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 40 08             	mov    0x8(%eax),%eax
80101b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b13:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b1a:	e8 d2 32 00 00       	call   80104df1 <release>
    if(r == 1){
80101b1f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101b23:	75 29                	jne    80101b4e <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101b25:	8b 45 08             	mov    0x8(%ebp),%eax
80101b28:	89 04 24             	mov    %eax,(%esp)
80101b2b:	e8 86 01 00 00       	call   80101cb6 <itrunc>
      ip->type = 0;
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	89 04 24             	mov    %eax,(%esp)
80101b3f:	e8 7f fc ff ff       	call   801017c3 <iupdate>
      ip->valid = 0;
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	83 c0 0c             	add    $0xc,%eax
80101b54:	89 04 24             	mov    %eax,(%esp)
80101b57:	e8 61 31 00 00       	call   80104cbd <releasesleep>

  acquire(&icache.lock);
80101b5c:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b63:	e8 1f 32 00 00       	call   80104d87 <acquire>
  ip->ref--;
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	8b 40 08             	mov    0x8(%eax),%eax
80101b6e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b77:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b7e:	e8 6e 32 00 00       	call   80104df1 <release>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    

80101b85 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b85:	55                   	push   %ebp
80101b86:	89 e5                	mov    %esp,%ebp
80101b88:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 fa fe ff ff       	call   80101a90 <iunlock>
  iput(ip);
80101b96:	8b 45 08             	mov    0x8(%ebp),%eax
80101b99:	89 04 24             	mov    %eax,(%esp)
80101b9c:	e8 33 ff ff ff       	call   80101ad4 <iput>
}
80101ba1:	c9                   	leave  
80101ba2:	c3                   	ret    

80101ba3 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ba3:	55                   	push   %ebp
80101ba4:	89 e5                	mov    %esp,%ebp
80101ba6:	53                   	push   %ebx
80101ba7:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101baa:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bae:	77 3e                	ja     80101bee <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb6:	83 c2 14             	add    $0x14,%edx
80101bb9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc4:	75 20                	jne    80101be6 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc9:	8b 00                	mov    (%eax),%eax
80101bcb:	89 04 24             	mov    %eax,(%esp)
80101bce:	e8 48 f8 ff ff       	call   8010141b <balloc>
80101bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bdc:	8d 4a 14             	lea    0x14(%edx),%ecx
80101bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be2:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be9:	e9 c2 00 00 00       	jmp    80101cb0 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101bee:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bf2:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bf6:	0f 87 a8 00 00 00    	ja     80101ca4 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bff:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0c:	75 1c                	jne    80101c2a <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c11:	8b 00                	mov    (%eax),%eax
80101c13:	89 04 24             	mov    %eax,(%esp)
80101c16:	e8 00 f8 ff ff       	call   8010141b <balloc>
80101c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c24:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 00                	mov    (%eax),%eax
80101c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c32:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 77 e5 ff ff       	call   801001b5 <bread>
80101c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c44:	83 c0 5c             	add    $0x5c,%eax
80101c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c57:	01 d0                	add    %edx,%eax
80101c59:	8b 00                	mov    (%eax),%eax
80101c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c62:	75 30                	jne    80101c94 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c64:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c71:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c74:	8b 45 08             	mov    0x8(%ebp),%eax
80101c77:	8b 00                	mov    (%eax),%eax
80101c79:	89 04 24             	mov    %eax,(%esp)
80101c7c:	e8 9a f7 ff ff       	call   8010141b <balloc>
80101c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c87:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8c:	89 04 24             	mov    %eax,(%esp)
80101c8f:	e8 ef 19 00 00       	call   80103683 <log_write>
    }
    brelse(bp);
80101c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c97:	89 04 24             	mov    %eax,(%esp)
80101c9a:	e8 8d e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ca2:	eb 0c                	jmp    80101cb0 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101ca4:	c7 04 24 de 82 10 80 	movl   $0x801082de,(%esp)
80101cab:	e8 a4 e8 ff ff       	call   80100554 <panic>
}
80101cb0:	83 c4 24             	add    $0x24,%esp
80101cb3:	5b                   	pop    %ebx
80101cb4:	5d                   	pop    %ebp
80101cb5:	c3                   	ret    

80101cb6 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cb6:	55                   	push   %ebp
80101cb7:	89 e5                	mov    %esp,%ebp
80101cb9:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101cc3:	eb 43                	jmp    80101d08 <itrunc+0x52>
    if(ip->addrs[i]){
80101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ccb:	83 c2 14             	add    $0x14,%edx
80101cce:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cd2:	85 c0                	test   %eax,%eax
80101cd4:	74 2f                	je     80101d05 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cdc:	83 c2 14             	add    $0x14,%edx
80101cdf:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cec:	89 04 24             	mov    %eax,(%esp)
80101cef:	e8 61 f8 ff ff       	call   80101555 <bfree>
      ip->addrs[i] = 0;
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfa:	83 c2 14             	add    $0x14,%edx
80101cfd:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d04:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d05:	ff 45 f4             	incl   -0xc(%ebp)
80101d08:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d0c:	7e b7                	jle    80101cc5 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d11:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d17:	85 c0                	test   %eax,%eax
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d22:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d28:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2b:	8b 00                	mov    (%eax),%eax
80101d2d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d31:	89 04 24             	mov    %eax,(%esp)
80101d34:	e8 7c e4 ff ff       	call   801001b5 <bread>
80101d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d3f:	83 c0 5c             	add    $0x5c,%eax
80101d42:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d4c:	eb 3a                	jmp    80101d88 <itrunc+0xd2>
      if(a[j])
80101d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d5b:	01 d0                	add    %edx,%eax
80101d5d:	8b 00                	mov    (%eax),%eax
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 22                	je     80101d85 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d70:	01 d0                	add    %edx,%eax
80101d72:	8b 10                	mov    (%eax),%edx
80101d74:	8b 45 08             	mov    0x8(%ebp),%eax
80101d77:	8b 00                	mov    (%eax),%eax
80101d79:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d7d:	89 04 24             	mov    %eax,(%esp)
80101d80:	e8 d0 f7 ff ff       	call   80101555 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d85:	ff 45 f0             	incl   -0x10(%ebp)
80101d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d8b:	83 f8 7f             	cmp    $0x7f,%eax
80101d8e:	76 be                	jbe    80101d4e <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d93:	89 04 24             	mov    %eax,(%esp)
80101d96:	e8 91 e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9e:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	8b 00                	mov    (%eax),%eax
80101da9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dad:	89 04 24             	mov    %eax,(%esp)
80101db0:	e8 a0 f7 ff ff       	call   80101555 <bfree>
    ip->addrs[NDIRECT] = 0;
80101db5:	8b 45 08             	mov    0x8(%ebp),%eax
80101db8:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101dbf:	00 00 00 
  }

  ip->size = 0;
80101dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc5:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcf:	89 04 24             	mov    %eax,(%esp)
80101dd2:	e8 ec f9 ff ff       	call   801017c3 <iupdate>
}
80101dd7:	c9                   	leave  
80101dd8:	c3                   	ret    

80101dd9 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101dd9:	55                   	push   %ebp
80101dda:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 00                	mov    (%eax),%eax
80101de1:	89 c2                	mov    %eax,%edx
80101de3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de6:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101de9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dec:	8b 50 04             	mov    0x4(%eax),%edx
80101def:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df2:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101df5:	8b 45 08             	mov    0x8(%ebp),%eax
80101df8:	8b 40 50             	mov    0x50(%eax),%eax
80101dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dfe:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101e01:	8b 45 08             	mov    0x8(%ebp),%eax
80101e04:	66 8b 40 56          	mov    0x56(%eax),%ax
80101e08:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e0b:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e12:	8b 50 58             	mov    0x58(%eax),%edx
80101e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e18:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e1b:	5d                   	pop    %ebp
80101e1c:	c3                   	ret    

80101e1d <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e1d:	55                   	push   %ebp
80101e1e:	89 e5                	mov    %esp,%ebp
80101e20:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e23:	8b 45 08             	mov    0x8(%ebp),%eax
80101e26:	8b 40 50             	mov    0x50(%eax),%eax
80101e29:	66 83 f8 03          	cmp    $0x3,%ax
80101e2d:	75 60                	jne    80101e8f <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e32:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e36:	66 85 c0             	test   %ax,%ax
80101e39:	78 20                	js     80101e5b <readi+0x3e>
80101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3e:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e42:	66 83 f8 09          	cmp    $0x9,%ax
80101e46:	7f 13                	jg     80101e5b <readi+0x3e>
80101e48:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4b:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e4f:	98                   	cwtl   
80101e50:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101e57:	85 c0                	test   %eax,%eax
80101e59:	75 0a                	jne    80101e65 <readi+0x48>
      return -1;
80101e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e60:	e9 1a 01 00 00       	jmp    80101f7f <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e65:	8b 45 08             	mov    0x8(%ebp),%eax
80101e68:	66 8b 40 52          	mov    0x52(%eax),%ax
80101e6c:	98                   	cwtl   
80101e6d:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101e74:	8b 55 14             	mov    0x14(%ebp),%edx
80101e77:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e82:	8b 55 08             	mov    0x8(%ebp),%edx
80101e85:	89 14 24             	mov    %edx,(%esp)
80101e88:	ff d0                	call   *%eax
80101e8a:	e9 f0 00 00 00       	jmp    80101f7f <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e92:	8b 40 58             	mov    0x58(%eax),%eax
80101e95:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e98:	72 0d                	jb     80101ea7 <readi+0x8a>
80101e9a:	8b 45 14             	mov    0x14(%ebp),%eax
80101e9d:	8b 55 10             	mov    0x10(%ebp),%edx
80101ea0:	01 d0                	add    %edx,%eax
80101ea2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ea5:	73 0a                	jae    80101eb1 <readi+0x94>
    return -1;
80101ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eac:	e9 ce 00 00 00       	jmp    80101f7f <readi+0x162>
  if(off + n > ip->size)
80101eb1:	8b 45 14             	mov    0x14(%ebp),%eax
80101eb4:	8b 55 10             	mov    0x10(%ebp),%edx
80101eb7:	01 c2                	add    %eax,%edx
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	8b 40 58             	mov    0x58(%eax),%eax
80101ebf:	39 c2                	cmp    %eax,%edx
80101ec1:	76 0c                	jbe    80101ecf <readi+0xb2>
    n = ip->size - off;
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	8b 40 58             	mov    0x58(%eax),%eax
80101ec9:	2b 45 10             	sub    0x10(%ebp),%eax
80101ecc:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ecf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ed6:	e9 95 00 00 00       	jmp    80101f70 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101edb:	8b 45 10             	mov    0x10(%ebp),%eax
80101ede:	c1 e8 09             	shr    $0x9,%eax
80101ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee8:	89 04 24             	mov    %eax,(%esp)
80101eeb:	e8 b3 fc ff ff       	call   80101ba3 <bmap>
80101ef0:	8b 55 08             	mov    0x8(%ebp),%edx
80101ef3:	8b 12                	mov    (%edx),%edx
80101ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ef9:	89 14 24             	mov    %edx,(%esp)
80101efc:	e8 b4 e2 ff ff       	call   801001b5 <bread>
80101f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f04:	8b 45 10             	mov    0x10(%ebp),%eax
80101f07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f0c:	89 c2                	mov    %eax,%edx
80101f0e:	b8 00 02 00 00       	mov    $0x200,%eax
80101f13:	29 d0                	sub    %edx,%eax
80101f15:	89 c1                	mov    %eax,%ecx
80101f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f1a:	8b 55 14             	mov    0x14(%ebp),%edx
80101f1d:	29 c2                	sub    %eax,%edx
80101f1f:	89 c8                	mov    %ecx,%eax
80101f21:	39 d0                	cmp    %edx,%eax
80101f23:	76 02                	jbe    80101f27 <readi+0x10a>
80101f25:	89 d0                	mov    %edx,%eax
80101f27:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f2a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f2d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f32:	8d 50 50             	lea    0x50(%eax),%edx
80101f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f38:	01 d0                	add    %edx,%eax
80101f3a:	8d 50 0c             	lea    0xc(%eax),%edx
80101f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f40:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f44:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f48:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f4b:	89 04 24             	mov    %eax,(%esp)
80101f4e:	e8 60 31 00 00       	call   801050b3 <memmove>
    brelse(bp);
80101f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f56:	89 04 24             	mov    %eax,(%esp)
80101f59:	e8 ce e2 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f61:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f67:	01 45 10             	add    %eax,0x10(%ebp)
80101f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f6d:	01 45 0c             	add    %eax,0xc(%ebp)
80101f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f73:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f76:	0f 82 5f ff ff ff    	jb     80101edb <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f7c:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f7f:	c9                   	leave  
80101f80:	c3                   	ret    

80101f81 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f81:	55                   	push   %ebp
80101f82:	89 e5                	mov    %esp,%ebp
80101f84:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f87:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8a:	8b 40 50             	mov    0x50(%eax),%eax
80101f8d:	66 83 f8 03          	cmp    $0x3,%ax
80101f91:	75 60                	jne    80101ff3 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f93:	8b 45 08             	mov    0x8(%ebp),%eax
80101f96:	66 8b 40 52          	mov    0x52(%eax),%ax
80101f9a:	66 85 c0             	test   %ax,%ax
80101f9d:	78 20                	js     80101fbf <writei+0x3e>
80101f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa2:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fa6:	66 83 f8 09          	cmp    $0x9,%ax
80101faa:	7f 13                	jg     80101fbf <writei+0x3e>
80101fac:	8b 45 08             	mov    0x8(%ebp),%eax
80101faf:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fb3:	98                   	cwtl   
80101fb4:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101fbb:	85 c0                	test   %eax,%eax
80101fbd:	75 0a                	jne    80101fc9 <writei+0x48>
      return -1;
80101fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc4:	e9 45 01 00 00       	jmp    8010210e <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fd0:	98                   	cwtl   
80101fd1:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101fd8:	8b 55 14             	mov    0x14(%ebp),%edx
80101fdb:	89 54 24 08          	mov    %edx,0x8(%esp)
80101fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fe6:	8b 55 08             	mov    0x8(%ebp),%edx
80101fe9:	89 14 24             	mov    %edx,(%esp)
80101fec:	ff d0                	call   *%eax
80101fee:	e9 1b 01 00 00       	jmp    8010210e <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff6:	8b 40 58             	mov    0x58(%eax),%eax
80101ff9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ffc:	72 0d                	jb     8010200b <writei+0x8a>
80101ffe:	8b 45 14             	mov    0x14(%ebp),%eax
80102001:	8b 55 10             	mov    0x10(%ebp),%edx
80102004:	01 d0                	add    %edx,%eax
80102006:	3b 45 10             	cmp    0x10(%ebp),%eax
80102009:	73 0a                	jae    80102015 <writei+0x94>
    return -1;
8010200b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102010:	e9 f9 00 00 00       	jmp    8010210e <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80102015:	8b 45 14             	mov    0x14(%ebp),%eax
80102018:	8b 55 10             	mov    0x10(%ebp),%edx
8010201b:	01 d0                	add    %edx,%eax
8010201d:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102022:	76 0a                	jbe    8010202e <writei+0xad>
    return -1;
80102024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102029:	e9 e0 00 00 00       	jmp    8010210e <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010202e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102035:	e9 a0 00 00 00       	jmp    801020da <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010203a:	8b 45 10             	mov    0x10(%ebp),%eax
8010203d:	c1 e8 09             	shr    $0x9,%eax
80102040:	89 44 24 04          	mov    %eax,0x4(%esp)
80102044:	8b 45 08             	mov    0x8(%ebp),%eax
80102047:	89 04 24             	mov    %eax,(%esp)
8010204a:	e8 54 fb ff ff       	call   80101ba3 <bmap>
8010204f:	8b 55 08             	mov    0x8(%ebp),%edx
80102052:	8b 12                	mov    (%edx),%edx
80102054:	89 44 24 04          	mov    %eax,0x4(%esp)
80102058:	89 14 24             	mov    %edx,(%esp)
8010205b:	e8 55 e1 ff ff       	call   801001b5 <bread>
80102060:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102063:	8b 45 10             	mov    0x10(%ebp),%eax
80102066:	25 ff 01 00 00       	and    $0x1ff,%eax
8010206b:	89 c2                	mov    %eax,%edx
8010206d:	b8 00 02 00 00       	mov    $0x200,%eax
80102072:	29 d0                	sub    %edx,%eax
80102074:	89 c1                	mov    %eax,%ecx
80102076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102079:	8b 55 14             	mov    0x14(%ebp),%edx
8010207c:	29 c2                	sub    %eax,%edx
8010207e:	89 c8                	mov    %ecx,%eax
80102080:	39 d0                	cmp    %edx,%eax
80102082:	76 02                	jbe    80102086 <writei+0x105>
80102084:	89 d0                	mov    %edx,%eax
80102086:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102089:	8b 45 10             	mov    0x10(%ebp),%eax
8010208c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102091:	8d 50 50             	lea    0x50(%eax),%edx
80102094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102097:	01 d0                	add    %edx,%eax
80102099:	8d 50 0c             	lea    0xc(%eax),%edx
8010209c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010209f:	89 44 24 08          	mov    %eax,0x8(%esp)
801020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801020aa:	89 14 24             	mov    %edx,(%esp)
801020ad:	e8 01 30 00 00       	call   801050b3 <memmove>
    log_write(bp);
801020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020b5:	89 04 24             	mov    %eax,(%esp)
801020b8:	e8 c6 15 00 00       	call   80103683 <log_write>
    brelse(bp);
801020bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c0:	89 04 24             	mov    %eax,(%esp)
801020c3:	e8 64 e1 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cb:	01 45 f4             	add    %eax,-0xc(%ebp)
801020ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020d1:	01 45 10             	add    %eax,0x10(%ebp)
801020d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020d7:	01 45 0c             	add    %eax,0xc(%ebp)
801020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020dd:	3b 45 14             	cmp    0x14(%ebp),%eax
801020e0:	0f 82 54 ff ff ff    	jb     8010203a <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020ea:	74 1f                	je     8010210b <writei+0x18a>
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	8b 40 58             	mov    0x58(%eax),%eax
801020f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f5:	73 14                	jae    8010210b <writei+0x18a>
    ip->size = off;
801020f7:	8b 45 08             	mov    0x8(%ebp),%eax
801020fa:	8b 55 10             	mov    0x10(%ebp),%edx
801020fd:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102100:	8b 45 08             	mov    0x8(%ebp),%eax
80102103:	89 04 24             	mov    %eax,(%esp)
80102106:	e8 b8 f6 ff ff       	call   801017c3 <iupdate>
  }
  return n;
8010210b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010210e:	c9                   	leave  
8010210f:	c3                   	ret    

80102110 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102116:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010211d:	00 
8010211e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102121:	89 44 24 04          	mov    %eax,0x4(%esp)
80102125:	8b 45 08             	mov    0x8(%ebp),%eax
80102128:	89 04 24             	mov    %eax,(%esp)
8010212b:	e8 22 30 00 00       	call   80105152 <strncmp>
}
80102130:	c9                   	leave  
80102131:	c3                   	ret    

80102132 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102132:	55                   	push   %ebp
80102133:	89 e5                	mov    %esp,%ebp
80102135:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	8b 40 50             	mov    0x50(%eax),%eax
8010213e:	66 83 f8 01          	cmp    $0x1,%ax
80102142:	74 0c                	je     80102150 <dirlookup+0x1e>
    panic("dirlookup not DIR");
80102144:	c7 04 24 f1 82 10 80 	movl   $0x801082f1,(%esp)
8010214b:	e8 04 e4 ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102150:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102157:	e9 86 00 00 00       	jmp    801021e2 <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102163:	00 
80102164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102167:	89 44 24 08          	mov    %eax,0x8(%esp)
8010216b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010216e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102172:	8b 45 08             	mov    0x8(%ebp),%eax
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 a0 fc ff ff       	call   80101e1d <readi>
8010217d:	83 f8 10             	cmp    $0x10,%eax
80102180:	74 0c                	je     8010218e <dirlookup+0x5c>
      panic("dirlookup read");
80102182:	c7 04 24 03 83 10 80 	movl   $0x80108303,(%esp)
80102189:	e8 c6 e3 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
8010218e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102191:	66 85 c0             	test   %ax,%ax
80102194:	75 02                	jne    80102198 <dirlookup+0x66>
      continue;
80102196:	eb 46                	jmp    801021de <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
80102198:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219b:	83 c0 02             	add    $0x2,%eax
8010219e:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801021a5:	89 04 24             	mov    %eax,(%esp)
801021a8:	e8 63 ff ff ff       	call   80102110 <namecmp>
801021ad:	85 c0                	test   %eax,%eax
801021af:	75 2d                	jne    801021de <dirlookup+0xac>
      // entry matches path element
      if(poff)
801021b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021b5:	74 08                	je     801021bf <dirlookup+0x8d>
        *poff = off;
801021b7:	8b 45 10             	mov    0x10(%ebp),%eax
801021ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021bd:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021c2:	0f b7 c0             	movzwl %ax,%eax
801021c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021c8:	8b 45 08             	mov    0x8(%ebp),%eax
801021cb:	8b 00                	mov    (%eax),%eax
801021cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801021d4:	89 04 24             	mov    %eax,(%esp)
801021d7:	e8 a3 f6 ff ff       	call   8010187f <iget>
801021dc:	eb 18                	jmp    801021f6 <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021de:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021e2:	8b 45 08             	mov    0x8(%ebp),%eax
801021e5:	8b 40 58             	mov    0x58(%eax),%eax
801021e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021eb:	0f 87 6b ff ff ff    	ja     8010215c <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021f6:	c9                   	leave  
801021f7:	c3                   	ret    

801021f8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021f8:	55                   	push   %ebp
801021f9:	89 e5                	mov    %esp,%ebp
801021fb:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102205:	00 
80102206:	8b 45 0c             	mov    0xc(%ebp),%eax
80102209:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220d:	8b 45 08             	mov    0x8(%ebp),%eax
80102210:	89 04 24             	mov    %eax,(%esp)
80102213:	e8 1a ff ff ff       	call   80102132 <dirlookup>
80102218:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010221b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010221f:	74 15                	je     80102236 <dirlink+0x3e>
    iput(ip);
80102221:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102224:	89 04 24             	mov    %eax,(%esp)
80102227:	e8 a8 f8 ff ff       	call   80101ad4 <iput>
    return -1;
8010222c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102231:	e9 b6 00 00 00       	jmp    801022ec <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010223d:	eb 45                	jmp    80102284 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102242:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102249:	00 
8010224a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010224e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102251:	89 44 24 04          	mov    %eax,0x4(%esp)
80102255:	8b 45 08             	mov    0x8(%ebp),%eax
80102258:	89 04 24             	mov    %eax,(%esp)
8010225b:	e8 bd fb ff ff       	call   80101e1d <readi>
80102260:	83 f8 10             	cmp    $0x10,%eax
80102263:	74 0c                	je     80102271 <dirlink+0x79>
      panic("dirlink read");
80102265:	c7 04 24 12 83 10 80 	movl   $0x80108312,(%esp)
8010226c:	e8 e3 e2 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
80102271:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102274:	66 85 c0             	test   %ax,%ax
80102277:	75 02                	jne    8010227b <dirlink+0x83>
      break;
80102279:	eb 16                	jmp    80102291 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010227e:	83 c0 10             	add    $0x10,%eax
80102281:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102284:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102287:	8b 45 08             	mov    0x8(%ebp),%eax
8010228a:	8b 40 58             	mov    0x58(%eax),%eax
8010228d:	39 c2                	cmp    %eax,%edx
8010228f:	72 ae                	jb     8010223f <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102291:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102298:	00 
80102299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010229c:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a3:	83 c0 02             	add    $0x2,%eax
801022a6:	89 04 24             	mov    %eax,(%esp)
801022a9:	e8 f2 2e 00 00       	call   801051a0 <strncpy>
  de.inum = inum;
801022ae:	8b 45 10             	mov    0x10(%ebp),%eax
801022b1:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022bf:	00 
801022c0:	89 44 24 08          	mov    %eax,0x8(%esp)
801022c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
801022ce:	89 04 24             	mov    %eax,(%esp)
801022d1:	e8 ab fc ff ff       	call   80101f81 <writei>
801022d6:	83 f8 10             	cmp    $0x10,%eax
801022d9:	74 0c                	je     801022e7 <dirlink+0xef>
    panic("dirlink");
801022db:	c7 04 24 1f 83 10 80 	movl   $0x8010831f,(%esp)
801022e2:	e8 6d e2 ff ff       	call   80100554 <panic>

  return 0;
801022e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022ec:	c9                   	leave  
801022ed:	c3                   	ret    

801022ee <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022ee:	55                   	push   %ebp
801022ef:	89 e5                	mov    %esp,%ebp
801022f1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022f4:	eb 03                	jmp    801022f9 <skipelem+0xb>
    path++;
801022f6:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	8a 00                	mov    (%eax),%al
801022fe:	3c 2f                	cmp    $0x2f,%al
80102300:	74 f4                	je     801022f6 <skipelem+0x8>
    path++;
  if(*path == 0)
80102302:	8b 45 08             	mov    0x8(%ebp),%eax
80102305:	8a 00                	mov    (%eax),%al
80102307:	84 c0                	test   %al,%al
80102309:	75 0a                	jne    80102315 <skipelem+0x27>
    return 0;
8010230b:	b8 00 00 00 00       	mov    $0x0,%eax
80102310:	e9 81 00 00 00       	jmp    80102396 <skipelem+0xa8>
  s = path;
80102315:	8b 45 08             	mov    0x8(%ebp),%eax
80102318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010231b:	eb 03                	jmp    80102320 <skipelem+0x32>
    path++;
8010231d:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102320:	8b 45 08             	mov    0x8(%ebp),%eax
80102323:	8a 00                	mov    (%eax),%al
80102325:	3c 2f                	cmp    $0x2f,%al
80102327:	74 09                	je     80102332 <skipelem+0x44>
80102329:	8b 45 08             	mov    0x8(%ebp),%eax
8010232c:	8a 00                	mov    (%eax),%al
8010232e:	84 c0                	test   %al,%al
80102330:	75 eb                	jne    8010231d <skipelem+0x2f>
    path++;
  len = path - s;
80102332:	8b 55 08             	mov    0x8(%ebp),%edx
80102335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102338:	29 c2                	sub    %eax,%edx
8010233a:	89 d0                	mov    %edx,%eax
8010233c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010233f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102343:	7e 1c                	jle    80102361 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
80102345:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010234c:	00 
8010234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102350:	89 44 24 04          	mov    %eax,0x4(%esp)
80102354:	8b 45 0c             	mov    0xc(%ebp),%eax
80102357:	89 04 24             	mov    %eax,(%esp)
8010235a:	e8 54 2d 00 00       	call   801050b3 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010235f:	eb 29                	jmp    8010238a <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102361:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102364:	89 44 24 08          	mov    %eax,0x8(%esp)
80102368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102372:	89 04 24             	mov    %eax,(%esp)
80102375:	e8 39 2d 00 00       	call   801050b3 <memmove>
    name[len] = 0;
8010237a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010237d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102380:	01 d0                	add    %edx,%eax
80102382:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102385:	eb 03                	jmp    8010238a <skipelem+0x9c>
    path++;
80102387:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010238a:	8b 45 08             	mov    0x8(%ebp),%eax
8010238d:	8a 00                	mov    (%eax),%al
8010238f:	3c 2f                	cmp    $0x2f,%al
80102391:	74 f4                	je     80102387 <skipelem+0x99>
    path++;
  return path;
80102393:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102396:	c9                   	leave  
80102397:	c3                   	ret    

80102398 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
801023a1:	8a 00                	mov    (%eax),%al
801023a3:	3c 2f                	cmp    $0x2f,%al
801023a5:	75 1c                	jne    801023c3 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801023a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023ae:	00 
801023af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023b6:	e8 c4 f4 ff ff       	call   8010187f <iget>
801023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801023be:	e9 ac 00 00 00       	jmp    8010246f <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801023c3:	e8 af 1d 00 00       	call   80104177 <myproc>
801023c8:	8b 40 68             	mov    0x68(%eax),%eax
801023cb:	89 04 24             	mov    %eax,(%esp)
801023ce:	e8 81 f5 ff ff       	call   80101954 <idup>
801023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023d6:	e9 94 00 00 00       	jmp    8010246f <namex+0xd7>
    ilock(ip);
801023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023de:	89 04 24             	mov    %eax,(%esp)
801023e1:	e8 a0 f5 ff ff       	call   80101986 <ilock>
    if(ip->type != T_DIR){
801023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e9:	8b 40 50             	mov    0x50(%eax),%eax
801023ec:	66 83 f8 01          	cmp    $0x1,%ax
801023f0:	74 15                	je     80102407 <namex+0x6f>
      iunlockput(ip);
801023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f5:	89 04 24             	mov    %eax,(%esp)
801023f8:	e8 88 f7 ff ff       	call   80101b85 <iunlockput>
      return 0;
801023fd:	b8 00 00 00 00       	mov    $0x0,%eax
80102402:	e9 a2 00 00 00       	jmp    801024a9 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
80102407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010240b:	74 1c                	je     80102429 <namex+0x91>
8010240d:	8b 45 08             	mov    0x8(%ebp),%eax
80102410:	8a 00                	mov    (%eax),%al
80102412:	84 c0                	test   %al,%al
80102414:	75 13                	jne    80102429 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
80102416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102419:	89 04 24             	mov    %eax,(%esp)
8010241c:	e8 6f f6 ff ff       	call   80101a90 <iunlock>
      return ip;
80102421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102424:	e9 80 00 00 00       	jmp    801024a9 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102429:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102430:	00 
80102431:	8b 45 10             	mov    0x10(%ebp),%eax
80102434:	89 44 24 04          	mov    %eax,0x4(%esp)
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 ef fc ff ff       	call   80102132 <dirlookup>
80102443:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010244a:	75 12                	jne    8010245e <namex+0xc6>
      iunlockput(ip);
8010244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244f:	89 04 24             	mov    %eax,(%esp)
80102452:	e8 2e f7 ff ff       	call   80101b85 <iunlockput>
      return 0;
80102457:	b8 00 00 00 00       	mov    $0x0,%eax
8010245c:	eb 4b                	jmp    801024a9 <namex+0x111>
    }
    iunlockput(ip);
8010245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102461:	89 04 24             	mov    %eax,(%esp)
80102464:	e8 1c f7 ff ff       	call   80101b85 <iunlockput>
    ip = next;
80102469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010246c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010246f:	8b 45 10             	mov    0x10(%ebp),%eax
80102472:	89 44 24 04          	mov    %eax,0x4(%esp)
80102476:	8b 45 08             	mov    0x8(%ebp),%eax
80102479:	89 04 24             	mov    %eax,(%esp)
8010247c:	e8 6d fe ff ff       	call   801022ee <skipelem>
80102481:	89 45 08             	mov    %eax,0x8(%ebp)
80102484:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102488:	0f 85 4d ff ff ff    	jne    801023db <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010248e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102492:	74 12                	je     801024a6 <namex+0x10e>
    iput(ip);
80102494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102497:	89 04 24             	mov    %eax,(%esp)
8010249a:	e8 35 f6 ff ff       	call   80101ad4 <iput>
    return 0;
8010249f:	b8 00 00 00 00       	mov    $0x0,%eax
801024a4:	eb 03                	jmp    801024a9 <namex+0x111>
  }
  return ip;
801024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024a9:	c9                   	leave  
801024aa:	c3                   	ret    

801024ab <namei>:

struct inode*
namei(char *path)
{
801024ab:	55                   	push   %ebp
801024ac:	89 e5                	mov    %esp,%ebp
801024ae:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024b1:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024b4:	89 44 24 08          	mov    %eax,0x8(%esp)
801024b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024bf:	00 
801024c0:	8b 45 08             	mov    0x8(%ebp),%eax
801024c3:	89 04 24             	mov    %eax,(%esp)
801024c6:	e8 cd fe ff ff       	call   80102398 <namex>
}
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    

801024cd <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024cd:	55                   	push   %ebp
801024ce:	89 e5                	mov    %esp,%ebp
801024d0:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801024d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801024da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024e1:	00 
801024e2:	8b 45 08             	mov    0x8(%ebp),%eax
801024e5:	89 04 24             	mov    %eax,(%esp)
801024e8:	e8 ab fe ff ff       	call   80102398 <namex>
}
801024ed:	c9                   	leave  
801024ee:	c3                   	ret    
	...

801024f0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	83 ec 14             	sub    $0x14,%esp
801024f6:	8b 45 08             	mov    0x8(%ebp),%eax
801024f9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102500:	89 c2                	mov    %eax,%edx
80102502:	ec                   	in     (%dx),%al
80102503:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102506:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102509:	c9                   	leave  
8010250a:	c3                   	ret    

8010250b <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010250b:	55                   	push   %ebp
8010250c:	89 e5                	mov    %esp,%ebp
8010250e:	57                   	push   %edi
8010250f:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102510:	8b 55 08             	mov    0x8(%ebp),%edx
80102513:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102516:	8b 45 10             	mov    0x10(%ebp),%eax
80102519:	89 cb                	mov    %ecx,%ebx
8010251b:	89 df                	mov    %ebx,%edi
8010251d:	89 c1                	mov    %eax,%ecx
8010251f:	fc                   	cld    
80102520:	f3 6d                	rep insl (%dx),%es:(%edi)
80102522:	89 c8                	mov    %ecx,%eax
80102524:	89 fb                	mov    %edi,%ebx
80102526:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102529:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010252c:	5b                   	pop    %ebx
8010252d:	5f                   	pop    %edi
8010252e:	5d                   	pop    %ebp
8010252f:	c3                   	ret    

80102530 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	83 ec 08             	sub    $0x8,%esp
80102536:	8b 45 08             	mov    0x8(%ebp),%eax
80102539:	8b 55 0c             	mov    0xc(%ebp),%edx
8010253c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102540:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102543:	8a 45 f8             	mov    -0x8(%ebp),%al
80102546:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102549:	ee                   	out    %al,(%dx)
}
8010254a:	c9                   	leave  
8010254b:	c3                   	ret    

8010254c <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010254c:	55                   	push   %ebp
8010254d:	89 e5                	mov    %esp,%ebp
8010254f:	56                   	push   %esi
80102550:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102551:	8b 55 08             	mov    0x8(%ebp),%edx
80102554:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102557:	8b 45 10             	mov    0x10(%ebp),%eax
8010255a:	89 cb                	mov    %ecx,%ebx
8010255c:	89 de                	mov    %ebx,%esi
8010255e:	89 c1                	mov    %eax,%ecx
80102560:	fc                   	cld    
80102561:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102563:	89 c8                	mov    %ecx,%eax
80102565:	89 f3                	mov    %esi,%ebx
80102567:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010256a:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010256d:	5b                   	pop    %ebx
8010256e:	5e                   	pop    %esi
8010256f:	5d                   	pop    %ebp
80102570:	c3                   	ret    

80102571 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102571:	55                   	push   %ebp
80102572:	89 e5                	mov    %esp,%ebp
80102574:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102577:	90                   	nop
80102578:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010257f:	e8 6c ff ff ff       	call   801024f0 <inb>
80102584:	0f b6 c0             	movzbl %al,%eax
80102587:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010258a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258d:	25 c0 00 00 00       	and    $0xc0,%eax
80102592:	83 f8 40             	cmp    $0x40,%eax
80102595:	75 e1                	jne    80102578 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102597:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010259b:	74 11                	je     801025ae <idewait+0x3d>
8010259d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025a0:	83 e0 21             	and    $0x21,%eax
801025a3:	85 c0                	test   %eax,%eax
801025a5:	74 07                	je     801025ae <idewait+0x3d>
    return -1;
801025a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ac:	eb 05                	jmp    801025b3 <idewait+0x42>
  return 0;
801025ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025b3:	c9                   	leave  
801025b4:	c3                   	ret    

801025b5 <ideinit>:

void
ideinit(void)
{
801025b5:	55                   	push   %ebp
801025b6:	89 e5                	mov    %esp,%ebp
801025b8:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025bb:	c7 44 24 04 27 83 10 	movl   $0x80108327,0x4(%esp)
801025c2:	80 
801025c3:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801025ca:	e8 97 27 00 00       	call   80104d66 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025cf:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801025d4:	48                   	dec    %eax
801025d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801025d9:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025e0:	e8 66 04 00 00       	call   80102a4b <ioapicenable>
  idewait(0);
801025e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025ec:	e8 80 ff ff ff       	call   80102571 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025f1:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025f8:	00 
801025f9:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102600:	e8 2b ff ff ff       	call   80102530 <outb>
  for(i=0; i<1000; i++){
80102605:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010260c:	eb 1f                	jmp    8010262d <ideinit+0x78>
    if(inb(0x1f7) != 0){
8010260e:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102615:	e8 d6 fe ff ff       	call   801024f0 <inb>
8010261a:	84 c0                	test   %al,%al
8010261c:	74 0c                	je     8010262a <ideinit+0x75>
      havedisk1 = 1;
8010261e:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
80102625:	00 00 00 
      break;
80102628:	eb 0c                	jmp    80102636 <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010262a:	ff 45 f4             	incl   -0xc(%ebp)
8010262d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102634:	7e d8                	jle    8010260e <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102636:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010263d:	00 
8010263e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102645:	e8 e6 fe ff ff       	call   80102530 <outb>
}
8010264a:	c9                   	leave  
8010264b:	c3                   	ret    

8010264c <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010264c:	55                   	push   %ebp
8010264d:	89 e5                	mov    %esp,%ebp
8010264f:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102652:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102656:	75 0c                	jne    80102664 <idestart+0x18>
    panic("idestart");
80102658:	c7 04 24 2b 83 10 80 	movl   $0x8010832b,(%esp)
8010265f:	e8 f0 de ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
80102667:	8b 40 08             	mov    0x8(%eax),%eax
8010266a:	3d e7 03 00 00       	cmp    $0x3e7,%eax
8010266f:	76 0c                	jbe    8010267d <idestart+0x31>
    panic("incorrect blockno");
80102671:	c7 04 24 34 83 10 80 	movl   $0x80108334,(%esp)
80102678:	e8 d7 de ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010267d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102684:	8b 45 08             	mov    0x8(%ebp),%eax
80102687:	8b 50 08             	mov    0x8(%eax),%edx
8010268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010268d:	0f af c2             	imul   %edx,%eax
80102690:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102693:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102697:	75 07                	jne    801026a0 <idestart+0x54>
80102699:	b8 20 00 00 00       	mov    $0x20,%eax
8010269e:	eb 05                	jmp    801026a5 <idestart+0x59>
801026a0:	b8 c4 00 00 00       	mov    $0xc4,%eax
801026a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
801026a8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801026ac:	75 07                	jne    801026b5 <idestart+0x69>
801026ae:	b8 30 00 00 00       	mov    $0x30,%eax
801026b3:	eb 05                	jmp    801026ba <idestart+0x6e>
801026b5:	b8 c5 00 00 00       	mov    $0xc5,%eax
801026ba:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026bd:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026c1:	7e 0c                	jle    801026cf <idestart+0x83>
801026c3:	c7 04 24 2b 83 10 80 	movl   $0x8010832b,(%esp)
801026ca:	e8 85 de ff ff       	call   80100554 <panic>

  idewait(0);
801026cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026d6:	e8 96 fe ff ff       	call   80102571 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026e2:	00 
801026e3:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026ea:	e8 41 fe ff ff       	call   80102530 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f2:	0f b6 c0             	movzbl %al,%eax
801026f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f9:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102700:	e8 2b fe ff ff       	call   80102530 <outb>
  outb(0x1f3, sector & 0xff);
80102705:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102708:	0f b6 c0             	movzbl %al,%eax
8010270b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010270f:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102716:	e8 15 fe ff ff       	call   80102530 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010271e:	c1 f8 08             	sar    $0x8,%eax
80102721:	0f b6 c0             	movzbl %al,%eax
80102724:	89 44 24 04          	mov    %eax,0x4(%esp)
80102728:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010272f:	e8 fc fd ff ff       	call   80102530 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102737:	c1 f8 10             	sar    $0x10,%eax
8010273a:	0f b6 c0             	movzbl %al,%eax
8010273d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102741:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102748:	e8 e3 fd ff ff       	call   80102530 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010274d:	8b 45 08             	mov    0x8(%ebp),%eax
80102750:	8b 40 04             	mov    0x4(%eax),%eax
80102753:	83 e0 01             	and    $0x1,%eax
80102756:	c1 e0 04             	shl    $0x4,%eax
80102759:	88 c2                	mov    %al,%dl
8010275b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010275e:	c1 f8 18             	sar    $0x18,%eax
80102761:	83 e0 0f             	and    $0xf,%eax
80102764:	09 d0                	or     %edx,%eax
80102766:	83 c8 e0             	or     $0xffffffe0,%eax
80102769:	0f b6 c0             	movzbl %al,%eax
8010276c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102770:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102777:	e8 b4 fd ff ff       	call   80102530 <outb>
  if(b->flags & B_DIRTY){
8010277c:	8b 45 08             	mov    0x8(%ebp),%eax
8010277f:	8b 00                	mov    (%eax),%eax
80102781:	83 e0 04             	and    $0x4,%eax
80102784:	85 c0                	test   %eax,%eax
80102786:	74 36                	je     801027be <idestart+0x172>
    outb(0x1f7, write_cmd);
80102788:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010278b:	0f b6 c0             	movzbl %al,%eax
8010278e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102792:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102799:	e8 92 fd ff ff       	call   80102530 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	83 c0 5c             	add    $0x5c,%eax
801027a4:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027ab:	00 
801027ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801027b0:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027b7:	e8 90 fd ff ff       	call   8010254c <outsl>
801027bc:	eb 16                	jmp    801027d4 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
801027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027c1:	0f b6 c0             	movzbl %al,%eax
801027c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027cf:	e8 5c fd ff ff       	call   80102530 <outb>
  }
}
801027d4:	c9                   	leave  
801027d5:	c3                   	ret    

801027d6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027d6:	55                   	push   %ebp
801027d7:	89 e5                	mov    %esp,%ebp
801027d9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801027e3:	e8 9f 25 00 00       	call   80104d87 <acquire>

  if((b = idequeue) == 0){
801027e8:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801027ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027f4:	75 11                	jne    80102807 <ideintr+0x31>
    release(&idelock);
801027f6:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801027fd:	e8 ef 25 00 00       	call   80104df1 <release>
    return;
80102802:	e9 90 00 00 00       	jmp    80102897 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280a:	8b 40 58             	mov    0x58(%eax),%eax
8010280d:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102815:	8b 00                	mov    (%eax),%eax
80102817:	83 e0 04             	and    $0x4,%eax
8010281a:	85 c0                	test   %eax,%eax
8010281c:	75 2e                	jne    8010284c <ideintr+0x76>
8010281e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102825:	e8 47 fd ff ff       	call   80102571 <idewait>
8010282a:	85 c0                	test   %eax,%eax
8010282c:	78 1e                	js     8010284c <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
8010282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102831:	83 c0 5c             	add    $0x5c,%eax
80102834:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010283b:	00 
8010283c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102840:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102847:	e8 bf fc ff ff       	call   8010250b <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284f:	8b 00                	mov    (%eax),%eax
80102851:	83 c8 02             	or     $0x2,%eax
80102854:	89 c2                	mov    %eax,%edx
80102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102859:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285e:	8b 00                	mov    (%eax),%eax
80102860:	83 e0 fb             	and    $0xfffffffb,%eax
80102863:	89 c2                	mov    %eax,%edx
80102865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102868:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286d:	89 04 24             	mov    %eax,(%esp)
80102870:	e8 17 22 00 00       	call   80104a8c <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102875:	a1 14 b6 10 80       	mov    0x8010b614,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	74 0d                	je     8010288b <ideintr+0xb5>
    idestart(idequeue);
8010287e:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102883:	89 04 24             	mov    %eax,(%esp)
80102886:	e8 c1 fd ff ff       	call   8010264c <idestart>

  release(&idelock);
8010288b:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102892:	e8 5a 25 00 00       	call   80104df1 <release>
}
80102897:	c9                   	leave  
80102898:	c3                   	ret    

80102899 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102899:	55                   	push   %ebp
8010289a:	89 e5                	mov    %esp,%ebp
8010289c:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	83 c0 0c             	add    $0xc,%eax
801028a5:	89 04 24             	mov    %eax,(%esp)
801028a8:	e8 52 24 00 00       	call   80104cff <holdingsleep>
801028ad:	85 c0                	test   %eax,%eax
801028af:	75 0c                	jne    801028bd <iderw+0x24>
    panic("iderw: buf not locked");
801028b1:	c7 04 24 46 83 10 80 	movl   $0x80108346,(%esp)
801028b8:	e8 97 dc ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028bd:	8b 45 08             	mov    0x8(%ebp),%eax
801028c0:	8b 00                	mov    (%eax),%eax
801028c2:	83 e0 06             	and    $0x6,%eax
801028c5:	83 f8 02             	cmp    $0x2,%eax
801028c8:	75 0c                	jne    801028d6 <iderw+0x3d>
    panic("iderw: nothing to do");
801028ca:	c7 04 24 5c 83 10 80 	movl   $0x8010835c,(%esp)
801028d1:	e8 7e dc ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
801028d6:	8b 45 08             	mov    0x8(%ebp),%eax
801028d9:	8b 40 04             	mov    0x4(%eax),%eax
801028dc:	85 c0                	test   %eax,%eax
801028de:	74 15                	je     801028f5 <iderw+0x5c>
801028e0:	a1 18 b6 10 80       	mov    0x8010b618,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	75 0c                	jne    801028f5 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
801028e9:	c7 04 24 71 83 10 80 	movl   $0x80108371,(%esp)
801028f0:	e8 5f dc ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028f5:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801028fc:	e8 86 24 00 00       	call   80104d87 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102901:	8b 45 08             	mov    0x8(%ebp),%eax
80102904:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010290b:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
80102912:	eb 0b                	jmp    8010291f <iderw+0x86>
80102914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102917:	8b 00                	mov    (%eax),%eax
80102919:	83 c0 58             	add    $0x58,%eax
8010291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102922:	8b 00                	mov    (%eax),%eax
80102924:	85 c0                	test   %eax,%eax
80102926:	75 ec                	jne    80102914 <iderw+0x7b>
    ;
  *pp = b;
80102928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292b:	8b 55 08             	mov    0x8(%ebp),%edx
8010292e:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102930:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102935:	3b 45 08             	cmp    0x8(%ebp),%eax
80102938:	75 0d                	jne    80102947 <iderw+0xae>
    idestart(b);
8010293a:	8b 45 08             	mov    0x8(%ebp),%eax
8010293d:	89 04 24             	mov    %eax,(%esp)
80102940:	e8 07 fd ff ff       	call   8010264c <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102945:	eb 15                	jmp    8010295c <iderw+0xc3>
80102947:	eb 13                	jmp    8010295c <iderw+0xc3>
    sleep(b, &idelock);
80102949:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80102950:	80 
80102951:	8b 45 08             	mov    0x8(%ebp),%eax
80102954:	89 04 24             	mov    %eax,(%esp)
80102957:	e8 5c 20 00 00       	call   801049b8 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010295c:	8b 45 08             	mov    0x8(%ebp),%eax
8010295f:	8b 00                	mov    (%eax),%eax
80102961:	83 e0 06             	and    $0x6,%eax
80102964:	83 f8 02             	cmp    $0x2,%eax
80102967:	75 e0                	jne    80102949 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102969:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102970:	e8 7c 24 00 00       	call   80104df1 <release>
}
80102975:	c9                   	leave  
80102976:	c3                   	ret    
	...

80102978 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102978:	55                   	push   %ebp
80102979:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010297b:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102980:	8b 55 08             	mov    0x8(%ebp),%edx
80102983:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102985:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010298a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010298d:	5d                   	pop    %ebp
8010298e:	c3                   	ret    

8010298f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010298f:	55                   	push   %ebp
80102990:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102992:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102997:	8b 55 08             	mov    0x8(%ebp),%edx
8010299a:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010299c:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801029a4:	89 50 10             	mov    %edx,0x10(%eax)
}
801029a7:	5d                   	pop    %ebp
801029a8:	c3                   	ret    

801029a9 <ioapicinit>:

void
ioapicinit(void)
{
801029a9:	55                   	push   %ebp
801029aa:	89 e5                	mov    %esp,%ebp
801029ac:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029af:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
801029b6:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029c0:	e8 b3 ff ff ff       	call   80102978 <ioapicread>
801029c5:	c1 e8 10             	shr    $0x10,%eax
801029c8:	25 ff 00 00 00       	and    $0xff,%eax
801029cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029d7:	e8 9c ff ff ff       	call   80102978 <ioapicread>
801029dc:	c1 e8 18             	shr    $0x18,%eax
801029df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029e2:	a0 e0 37 11 80       	mov    0x801137e0,%al
801029e7:	0f b6 c0             	movzbl %al,%eax
801029ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029ed:	74 0c                	je     801029fb <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029ef:	c7 04 24 90 83 10 80 	movl   $0x80108390,(%esp)
801029f6:	e8 c6 d9 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a02:	eb 3d                	jmp    80102a41 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a07:	83 c0 20             	add    $0x20,%eax
80102a0a:	0d 00 00 01 00       	or     $0x10000,%eax
80102a0f:	89 c2                	mov    %eax,%edx
80102a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a14:	83 c0 08             	add    $0x8,%eax
80102a17:	01 c0                	add    %eax,%eax
80102a19:	89 54 24 04          	mov    %edx,0x4(%esp)
80102a1d:	89 04 24             	mov    %eax,(%esp)
80102a20:	e8 6a ff ff ff       	call   8010298f <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a28:	83 c0 08             	add    $0x8,%eax
80102a2b:	01 c0                	add    %eax,%eax
80102a2d:	40                   	inc    %eax
80102a2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a35:	00 
80102a36:	89 04 24             	mov    %eax,(%esp)
80102a39:	e8 51 ff ff ff       	call   8010298f <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a3e:	ff 45 f4             	incl   -0xc(%ebp)
80102a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a47:	7e bb                	jle    80102a04 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a49:	c9                   	leave  
80102a4a:	c3                   	ret    

80102a4b <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a4b:	55                   	push   %ebp
80102a4c:	89 e5                	mov    %esp,%ebp
80102a4e:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a51:	8b 45 08             	mov    0x8(%ebp),%eax
80102a54:	83 c0 20             	add    $0x20,%eax
80102a57:	89 c2                	mov    %eax,%edx
80102a59:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5c:	83 c0 08             	add    $0x8,%eax
80102a5f:	01 c0                	add    %eax,%eax
80102a61:	89 54 24 04          	mov    %edx,0x4(%esp)
80102a65:	89 04 24             	mov    %eax,(%esp)
80102a68:	e8 22 ff ff ff       	call   8010298f <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a70:	c1 e0 18             	shl    $0x18,%eax
80102a73:	8b 55 08             	mov    0x8(%ebp),%edx
80102a76:	83 c2 08             	add    $0x8,%edx
80102a79:	01 d2                	add    %edx,%edx
80102a7b:	42                   	inc    %edx
80102a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a80:	89 14 24             	mov    %edx,(%esp)
80102a83:	e8 07 ff ff ff       	call   8010298f <ioapicwrite>
}
80102a88:	c9                   	leave  
80102a89:	c3                   	ret    
	...

80102a8c <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a8c:	55                   	push   %ebp
80102a8d:	89 e5                	mov    %esp,%ebp
80102a8f:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a92:	c7 44 24 04 c2 83 10 	movl   $0x801083c2,0x4(%esp)
80102a99:	80 
80102a9a:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102aa1:	e8 c0 22 00 00       	call   80104d66 <initlock>
  kmem.use_lock = 0;
80102aa6:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102aad:	00 00 00 
  freerange(vstart, vend);
80102ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aba:	89 04 24             	mov    %eax,(%esp)
80102abd:	e8 26 00 00 00       	call   80102ae8 <freerange>
}
80102ac2:	c9                   	leave  
80102ac3:	c3                   	ret    

80102ac4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102aca:	8b 45 0c             	mov    0xc(%ebp),%eax
80102acd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad4:	89 04 24             	mov    %eax,(%esp)
80102ad7:	e8 0c 00 00 00       	call   80102ae8 <freerange>
  kmem.use_lock = 1;
80102adc:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102ae3:	00 00 00 
}
80102ae6:	c9                   	leave  
80102ae7:	c3                   	ret    

80102ae8 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ae8:	55                   	push   %ebp
80102ae9:	89 e5                	mov    %esp,%ebp
80102aeb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aee:	8b 45 08             	mov    0x8(%ebp),%eax
80102af1:	05 ff 0f 00 00       	add    $0xfff,%eax
80102af6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afe:	eb 12                	jmp    80102b12 <freerange+0x2a>
    kfree(p);
80102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b03:	89 04 24             	mov    %eax,(%esp)
80102b06:	e8 16 00 00 00       	call   80102b21 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b15:	05 00 10 00 00       	add    $0x1000,%eax
80102b1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b1d:	76 e1                	jbe    80102b00 <freerange+0x18>
    kfree(p);
}
80102b1f:	c9                   	leave  
80102b20:	c3                   	ret    

80102b21 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b21:	55                   	push   %ebp
80102b22:	89 e5                	mov    %esp,%ebp
80102b24:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2a:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b2f:	85 c0                	test   %eax,%eax
80102b31:	75 18                	jne    80102b4b <kfree+0x2a>
80102b33:	81 7d 08 28 65 11 80 	cmpl   $0x80116528,0x8(%ebp)
80102b3a:	72 0f                	jb     80102b4b <kfree+0x2a>
80102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3f:	05 00 00 00 80       	add    $0x80000000,%eax
80102b44:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b49:	76 0c                	jbe    80102b57 <kfree+0x36>
    panic("kfree");
80102b4b:	c7 04 24 c7 83 10 80 	movl   $0x801083c7,(%esp)
80102b52:	e8 fd d9 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b5e:	00 
80102b5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b66:	00 
80102b67:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6a:	89 04 24             	mov    %eax,(%esp)
80102b6d:	e8 78 24 00 00       	call   80104fea <memset>

  if(kmem.use_lock)
80102b72:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102b77:	85 c0                	test   %eax,%eax
80102b79:	74 0c                	je     80102b87 <kfree+0x66>
    acquire(&kmem.lock);
80102b7b:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102b82:	e8 00 22 00 00       	call   80104d87 <acquire>
  r = (struct run*)v;
80102b87:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b8d:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b96:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9b:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102ba0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	74 0c                	je     80102bb5 <kfree+0x94>
    release(&kmem.lock);
80102ba9:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bb0:	e8 3c 22 00 00       	call   80104df1 <release>
}
80102bb5:	c9                   	leave  
80102bb6:	c3                   	ret    

80102bb7 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bb7:	55                   	push   %ebp
80102bb8:	89 e5                	mov    %esp,%ebp
80102bba:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102bbd:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102bc2:	85 c0                	test   %eax,%eax
80102bc4:	74 0c                	je     80102bd2 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bc6:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bcd:	e8 b5 21 00 00       	call   80104d87 <acquire>
  r = kmem.freelist;
80102bd2:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bde:	74 0a                	je     80102bea <kalloc+0x33>
    kmem.freelist = r->next;
80102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be3:	8b 00                	mov    (%eax),%eax
80102be5:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102bea:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102bef:	85 c0                	test   %eax,%eax
80102bf1:	74 0c                	je     80102bff <kalloc+0x48>
    release(&kmem.lock);
80102bf3:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bfa:	e8 f2 21 00 00       	call   80104df1 <release>
  return (char*)r;
80102bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c02:	c9                   	leave  
80102c03:	c3                   	ret    

80102c04 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c04:	55                   	push   %ebp
80102c05:	89 e5                	mov    %esp,%ebp
80102c07:	83 ec 14             	sub    $0x14,%esp
80102c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102c14:	89 c2                	mov    %eax,%edx
80102c16:	ec                   	in     (%dx),%al
80102c17:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c1a:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102c1d:	c9                   	leave  
80102c1e:	c3                   	ret    

80102c1f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c1f:	55                   	push   %ebp
80102c20:	89 e5                	mov    %esp,%ebp
80102c22:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c25:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c2c:	e8 d3 ff ff ff       	call   80102c04 <inb>
80102c31:	0f b6 c0             	movzbl %al,%eax
80102c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3a:	83 e0 01             	and    $0x1,%eax
80102c3d:	85 c0                	test   %eax,%eax
80102c3f:	75 0a                	jne    80102c4b <kbdgetc+0x2c>
    return -1;
80102c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c46:	e9 21 01 00 00       	jmp    80102d6c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c4b:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c52:	e8 ad ff ff ff       	call   80102c04 <inb>
80102c57:	0f b6 c0             	movzbl %al,%eax
80102c5a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c5d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c64:	75 17                	jne    80102c7d <kbdgetc+0x5e>
    shift |= E0ESC;
80102c66:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c6b:	83 c8 40             	or     $0x40,%eax
80102c6e:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102c73:	b8 00 00 00 00       	mov    $0x0,%eax
80102c78:	e9 ef 00 00 00       	jmp    80102d6c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c80:	25 80 00 00 00       	and    $0x80,%eax
80102c85:	85 c0                	test   %eax,%eax
80102c87:	74 44                	je     80102ccd <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c89:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c8e:	83 e0 40             	and    $0x40,%eax
80102c91:	85 c0                	test   %eax,%eax
80102c93:	75 08                	jne    80102c9d <kbdgetc+0x7e>
80102c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c98:	83 e0 7f             	and    $0x7f,%eax
80102c9b:	eb 03                	jmp    80102ca0 <kbdgetc+0x81>
80102c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca6:	05 20 90 10 80       	add    $0x80109020,%eax
80102cab:	8a 00                	mov    (%eax),%al
80102cad:	83 c8 40             	or     $0x40,%eax
80102cb0:	0f b6 c0             	movzbl %al,%eax
80102cb3:	f7 d0                	not    %eax
80102cb5:	89 c2                	mov    %eax,%edx
80102cb7:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cbc:	21 d0                	and    %edx,%eax
80102cbe:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102cc3:	b8 00 00 00 00       	mov    $0x0,%eax
80102cc8:	e9 9f 00 00 00       	jmp    80102d6c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ccd:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cd2:	83 e0 40             	and    $0x40,%eax
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	74 14                	je     80102ced <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cd9:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102ce0:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102ce5:	83 e0 bf             	and    $0xffffffbf,%eax
80102ce8:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf0:	05 20 90 10 80       	add    $0x80109020,%eax
80102cf5:	8a 00                	mov    (%eax),%al
80102cf7:	0f b6 d0             	movzbl %al,%edx
80102cfa:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cff:	09 d0                	or     %edx,%eax
80102d01:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d09:	05 20 91 10 80       	add    $0x80109120,%eax
80102d0e:	8a 00                	mov    (%eax),%al
80102d10:	0f b6 d0             	movzbl %al,%edx
80102d13:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d18:	31 d0                	xor    %edx,%eax
80102d1a:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d1f:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d24:	83 e0 03             	and    $0x3,%eax
80102d27:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d31:	01 d0                	add    %edx,%eax
80102d33:	8a 00                	mov    (%eax),%al
80102d35:	0f b6 c0             	movzbl %al,%eax
80102d38:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d3b:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d40:	83 e0 08             	and    $0x8,%eax
80102d43:	85 c0                	test   %eax,%eax
80102d45:	74 22                	je     80102d69 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d47:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d4b:	76 0c                	jbe    80102d59 <kbdgetc+0x13a>
80102d4d:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d51:	77 06                	ja     80102d59 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d53:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d57:	eb 10                	jmp    80102d69 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d59:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d5d:	76 0a                	jbe    80102d69 <kbdgetc+0x14a>
80102d5f:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d63:	77 04                	ja     80102d69 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d65:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d6c:	c9                   	leave  
80102d6d:	c3                   	ret    

80102d6e <kbdintr>:

void
kbdintr(void)
{
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d74:	c7 04 24 1f 2c 10 80 	movl   $0x80102c1f,(%esp)
80102d7b:	e8 45 da ff ff       	call   801007c5 <consoleintr>
}
80102d80:	c9                   	leave  
80102d81:	c3                   	ret    
	...

80102d84 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	83 ec 14             	sub    $0x14,%esp
80102d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d8d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102d94:	89 c2                	mov    %eax,%edx
80102d96:	ec                   	in     (%dx),%al
80102d97:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d9a:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102d9d:	c9                   	leave  
80102d9e:	c3                   	ret    

80102d9f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d9f:	55                   	push   %ebp
80102da0:	89 e5                	mov    %esp,%ebp
80102da2:	83 ec 08             	sub    $0x8,%esp
80102da5:	8b 45 08             	mov    0x8(%ebp),%eax
80102da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80102dab:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102daf:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db2:	8a 45 f8             	mov    -0x8(%ebp),%al
80102db5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102db8:	ee                   	out    %al,(%dx)
}
80102db9:	c9                   	leave  
80102dba:	c3                   	ret    

80102dbb <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102dbb:	55                   	push   %ebp
80102dbc:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dbe:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102dc3:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc6:	c1 e2 02             	shl    $0x2,%edx
80102dc9:	01 c2                	add    %eax,%edx
80102dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dce:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dd0:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102dd5:	83 c0 20             	add    $0x20,%eax
80102dd8:	8b 00                	mov    (%eax),%eax
}
80102dda:	5d                   	pop    %ebp
80102ddb:	c3                   	ret    

80102ddc <lapicinit>:

void
lapicinit(void)
{
80102ddc:	55                   	push   %ebp
80102ddd:	89 e5                	mov    %esp,%ebp
80102ddf:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102de2:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102de7:	85 c0                	test   %eax,%eax
80102de9:	75 05                	jne    80102df0 <lapicinit+0x14>
    return;
80102deb:	e9 43 01 00 00       	jmp    80102f33 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102df0:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102df7:	00 
80102df8:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102dff:	e8 b7 ff ff ff       	call   80102dbb <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e04:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e0b:	00 
80102e0c:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e13:	e8 a3 ff ff ff       	call   80102dbb <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e18:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e1f:	00 
80102e20:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e27:	e8 8f ff ff ff       	call   80102dbb <lapicw>
  lapicw(TICR, 10000000);
80102e2c:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e33:	00 
80102e34:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e3b:	e8 7b ff ff ff       	call   80102dbb <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e40:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e47:	00 
80102e48:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e4f:	e8 67 ff ff ff       	call   80102dbb <lapicw>
  lapicw(LINT1, MASKED);
80102e54:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e5b:	00 
80102e5c:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e63:	e8 53 ff ff ff       	call   80102dbb <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e68:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e6d:	83 c0 30             	add    $0x30,%eax
80102e70:	8b 00                	mov    (%eax),%eax
80102e72:	c1 e8 10             	shr    $0x10,%eax
80102e75:	0f b6 c0             	movzbl %al,%eax
80102e78:	83 f8 03             	cmp    $0x3,%eax
80102e7b:	76 14                	jbe    80102e91 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e7d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e84:	00 
80102e85:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e8c:	e8 2a ff ff ff       	call   80102dbb <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e91:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e98:	00 
80102e99:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ea0:	e8 16 ff ff ff       	call   80102dbb <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ea5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eac:	00 
80102ead:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eb4:	e8 02 ff ff ff       	call   80102dbb <lapicw>
  lapicw(ESR, 0);
80102eb9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec0:	00 
80102ec1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ec8:	e8 ee fe ff ff       	call   80102dbb <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ecd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ed4:	00 
80102ed5:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102edc:	e8 da fe ff ff       	call   80102dbb <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ee8:	00 
80102ee9:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ef0:	e8 c6 fe ff ff       	call   80102dbb <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ef5:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102efc:	00 
80102efd:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f04:	e8 b2 fe ff ff       	call   80102dbb <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f09:	90                   	nop
80102f0a:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f0f:	05 00 03 00 00       	add    $0x300,%eax
80102f14:	8b 00                	mov    (%eax),%eax
80102f16:	25 00 10 00 00       	and    $0x1000,%eax
80102f1b:	85 c0                	test   %eax,%eax
80102f1d:	75 eb                	jne    80102f0a <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f26:	00 
80102f27:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f2e:	e8 88 fe ff ff       	call   80102dbb <lapicw>
}
80102f33:	c9                   	leave  
80102f34:	c3                   	ret    

80102f35 <lapicid>:

int
lapicid(void)
{
80102f35:	55                   	push   %ebp
80102f36:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f38:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f3d:	85 c0                	test   %eax,%eax
80102f3f:	75 07                	jne    80102f48 <lapicid+0x13>
    return 0;
80102f41:	b8 00 00 00 00       	mov    $0x0,%eax
80102f46:	eb 0d                	jmp    80102f55 <lapicid+0x20>
  return lapic[ID] >> 24;
80102f48:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f4d:	83 c0 20             	add    $0x20,%eax
80102f50:	8b 00                	mov    (%eax),%eax
80102f52:	c1 e8 18             	shr    $0x18,%eax
}
80102f55:	5d                   	pop    %ebp
80102f56:	c3                   	ret    

80102f57 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f57:	55                   	push   %ebp
80102f58:	89 e5                	mov    %esp,%ebp
80102f5a:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f5d:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f62:	85 c0                	test   %eax,%eax
80102f64:	74 14                	je     80102f7a <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f6d:	00 
80102f6e:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f75:	e8 41 fe ff ff       	call   80102dbb <lapicw>
}
80102f7a:	c9                   	leave  
80102f7b:	c3                   	ret    

80102f7c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f7c:	55                   	push   %ebp
80102f7d:	89 e5                	mov    %esp,%ebp
}
80102f7f:	5d                   	pop    %ebp
80102f80:	c3                   	ret    

80102f81 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f81:	55                   	push   %ebp
80102f82:	89 e5                	mov    %esp,%ebp
80102f84:	83 ec 1c             	sub    $0x1c,%esp
80102f87:	8b 45 08             	mov    0x8(%ebp),%eax
80102f8a:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f8d:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f94:	00 
80102f95:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f9c:	e8 fe fd ff ff       	call   80102d9f <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fa1:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fa8:	00 
80102fa9:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fb0:	e8 ea fd ff ff       	call   80102d9f <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fb5:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fbf:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc7:	8d 50 02             	lea    0x2(%eax),%edx
80102fca:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fcd:	c1 e8 04             	shr    $0x4,%eax
80102fd0:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fd3:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd7:	c1 e0 18             	shl    $0x18,%eax
80102fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fde:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fe5:	e8 d1 fd ff ff       	call   80102dbb <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fea:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102ff1:	00 
80102ff2:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff9:	e8 bd fd ff ff       	call   80102dbb <lapicw>
  microdelay(200);
80102ffe:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103005:	e8 72 ff ff ff       	call   80102f7c <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010300a:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103011:	00 
80103012:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103019:	e8 9d fd ff ff       	call   80102dbb <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010301e:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103025:	e8 52 ff ff ff       	call   80102f7c <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010302a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103031:	eb 3f                	jmp    80103072 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
80103033:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103037:	c1 e0 18             	shl    $0x18,%eax
8010303a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010303e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103045:	e8 71 fd ff ff       	call   80102dbb <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010304a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010304d:	c1 e8 0c             	shr    $0xc,%eax
80103050:	80 cc 06             	or     $0x6,%ah
80103053:	89 44 24 04          	mov    %eax,0x4(%esp)
80103057:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010305e:	e8 58 fd ff ff       	call   80102dbb <lapicw>
    microdelay(200);
80103063:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010306a:	e8 0d ff ff ff       	call   80102f7c <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010306f:	ff 45 fc             	incl   -0x4(%ebp)
80103072:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103076:	7e bb                	jle    80103033 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103078:	c9                   	leave  
80103079:	c3                   	ret    

8010307a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103080:	8b 45 08             	mov    0x8(%ebp),%eax
80103083:	0f b6 c0             	movzbl %al,%eax
80103086:	89 44 24 04          	mov    %eax,0x4(%esp)
8010308a:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103091:	e8 09 fd ff ff       	call   80102d9f <outb>
  microdelay(200);
80103096:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010309d:	e8 da fe ff ff       	call   80102f7c <microdelay>

  return inb(CMOS_RETURN);
801030a2:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030a9:	e8 d6 fc ff ff       	call   80102d84 <inb>
801030ae:	0f b6 c0             	movzbl %al,%eax
}
801030b1:	c9                   	leave  
801030b2:	c3                   	ret    

801030b3 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030b3:	55                   	push   %ebp
801030b4:	89 e5                	mov    %esp,%ebp
801030b6:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030c0:	e8 b5 ff ff ff       	call   8010307a <cmos_read>
801030c5:	8b 55 08             	mov    0x8(%ebp),%edx
801030c8:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030ca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030d1:	e8 a4 ff ff ff       	call   8010307a <cmos_read>
801030d6:	8b 55 08             	mov    0x8(%ebp),%edx
801030d9:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030dc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030e3:	e8 92 ff ff ff       	call   8010307a <cmos_read>
801030e8:	8b 55 08             	mov    0x8(%ebp),%edx
801030eb:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030ee:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030f5:	e8 80 ff ff ff       	call   8010307a <cmos_read>
801030fa:	8b 55 08             	mov    0x8(%ebp),%edx
801030fd:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103100:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103107:	e8 6e ff ff ff       	call   8010307a <cmos_read>
8010310c:	8b 55 08             	mov    0x8(%ebp),%edx
8010310f:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103112:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103119:	e8 5c ff ff ff       	call   8010307a <cmos_read>
8010311e:	8b 55 08             	mov    0x8(%ebp),%edx
80103121:	89 42 14             	mov    %eax,0x14(%edx)
}
80103124:	c9                   	leave  
80103125:	c3                   	ret    

80103126 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103126:	55                   	push   %ebp
80103127:	89 e5                	mov    %esp,%ebp
80103129:	57                   	push   %edi
8010312a:	56                   	push   %esi
8010312b:	53                   	push   %ebx
8010312c:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010312f:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103136:	e8 3f ff ff ff       	call   8010307a <cmos_read>
8010313b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010313e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103141:	83 e0 04             	and    $0x4,%eax
80103144:	85 c0                	test   %eax,%eax
80103146:	0f 94 c0             	sete   %al
80103149:	0f b6 c0             	movzbl %al,%eax
8010314c:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010314f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103152:	89 04 24             	mov    %eax,(%esp)
80103155:	e8 59 ff ff ff       	call   801030b3 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010315a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103161:	e8 14 ff ff ff       	call   8010307a <cmos_read>
80103166:	25 80 00 00 00       	and    $0x80,%eax
8010316b:	85 c0                	test   %eax,%eax
8010316d:	74 02                	je     80103171 <cmostime+0x4b>
        continue;
8010316f:	eb 36                	jmp    801031a7 <cmostime+0x81>
    fill_rtcdate(&t2);
80103171:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103174:	89 04 24             	mov    %eax,(%esp)
80103177:	e8 37 ff ff ff       	call   801030b3 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010317c:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103183:	00 
80103184:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010318b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010318e:	89 04 24             	mov    %eax,(%esp)
80103191:	e8 cb 1e 00 00       	call   80105061 <memcmp>
80103196:	85 c0                	test   %eax,%eax
80103198:	75 0d                	jne    801031a7 <cmostime+0x81>
      break;
8010319a:	90                   	nop
  }

  // convert
  if(bcd) {
8010319b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010319f:	0f 84 ac 00 00 00    	je     80103251 <cmostime+0x12b>
801031a5:	eb 02                	jmp    801031a9 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031a7:	eb a6                	jmp    8010314f <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031ac:	c1 e8 04             	shr    $0x4,%eax
801031af:	89 c2                	mov    %eax,%edx
801031b1:	89 d0                	mov    %edx,%eax
801031b3:	c1 e0 02             	shl    $0x2,%eax
801031b6:	01 d0                	add    %edx,%eax
801031b8:	01 c0                	add    %eax,%eax
801031ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
801031bd:	83 e2 0f             	and    $0xf,%edx
801031c0:	01 d0                	add    %edx,%eax
801031c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
801031c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031c8:	c1 e8 04             	shr    $0x4,%eax
801031cb:	89 c2                	mov    %eax,%edx
801031cd:	89 d0                	mov    %edx,%eax
801031cf:	c1 e0 02             	shl    $0x2,%eax
801031d2:	01 d0                	add    %edx,%eax
801031d4:	01 c0                	add    %eax,%eax
801031d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
801031d9:	83 e2 0f             	and    $0xf,%edx
801031dc:	01 d0                	add    %edx,%eax
801031de:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
801031e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801031e4:	c1 e8 04             	shr    $0x4,%eax
801031e7:	89 c2                	mov    %eax,%edx
801031e9:	89 d0                	mov    %edx,%eax
801031eb:	c1 e0 02             	shl    $0x2,%eax
801031ee:	01 d0                	add    %edx,%eax
801031f0:	01 c0                	add    %eax,%eax
801031f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
801031f5:	83 e2 0f             	and    $0xf,%edx
801031f8:	01 d0                	add    %edx,%eax
801031fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
801031fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103200:	c1 e8 04             	shr    $0x4,%eax
80103203:	89 c2                	mov    %eax,%edx
80103205:	89 d0                	mov    %edx,%eax
80103207:	c1 e0 02             	shl    $0x2,%eax
8010320a:	01 d0                	add    %edx,%eax
8010320c:	01 c0                	add    %eax,%eax
8010320e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103211:	83 e2 0f             	and    $0xf,%edx
80103214:	01 d0                	add    %edx,%eax
80103216:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103219:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010321c:	c1 e8 04             	shr    $0x4,%eax
8010321f:	89 c2                	mov    %eax,%edx
80103221:	89 d0                	mov    %edx,%eax
80103223:	c1 e0 02             	shl    $0x2,%eax
80103226:	01 d0                	add    %edx,%eax
80103228:	01 c0                	add    %eax,%eax
8010322a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010322d:	83 e2 0f             	and    $0xf,%edx
80103230:	01 d0                	add    %edx,%eax
80103232:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
80103235:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103238:	c1 e8 04             	shr    $0x4,%eax
8010323b:	89 c2                	mov    %eax,%edx
8010323d:	89 d0                	mov    %edx,%eax
8010323f:	c1 e0 02             	shl    $0x2,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	01 c0                	add    %eax,%eax
80103246:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103249:	83 e2 0f             	and    $0xf,%edx
8010324c:	01 d0                	add    %edx,%eax
8010324e:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
80103251:	8b 45 08             	mov    0x8(%ebp),%eax
80103254:	89 c2                	mov    %eax,%edx
80103256:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80103259:	b8 06 00 00 00       	mov    $0x6,%eax
8010325e:	89 d7                	mov    %edx,%edi
80103260:	89 de                	mov    %ebx,%esi
80103262:	89 c1                	mov    %eax,%ecx
80103264:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80103266:	8b 45 08             	mov    0x8(%ebp),%eax
80103269:	8b 40 14             	mov    0x14(%eax),%eax
8010326c:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103272:	8b 45 08             	mov    0x8(%ebp),%eax
80103275:	89 50 14             	mov    %edx,0x14(%eax)
}
80103278:	83 c4 5c             	add    $0x5c,%esp
8010327b:	5b                   	pop    %ebx
8010327c:	5e                   	pop    %esi
8010327d:	5f                   	pop    %edi
8010327e:	5d                   	pop    %ebp
8010327f:	c3                   	ret    

80103280 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103286:	c7 44 24 04 cd 83 10 	movl   $0x801083cd,0x4(%esp)
8010328d:	80 
8010328e:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103295:	e8 cc 1a 00 00       	call   80104d66 <initlock>
  readsb(dev, &sb);
8010329a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010329d:	89 44 24 04          	mov    %eax,0x4(%esp)
801032a1:	8b 45 08             	mov    0x8(%ebp),%eax
801032a4:	89 04 24             	mov    %eax,(%esp)
801032a7:	e8 d8 e0 ff ff       	call   80101384 <readsb>
  log.start = sb.logstart;
801032ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032af:	a3 34 37 11 80       	mov    %eax,0x80113734
  log.size = sb.nlog;
801032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032b7:	a3 38 37 11 80       	mov    %eax,0x80113738
  log.dev = dev;
801032bc:	8b 45 08             	mov    0x8(%ebp),%eax
801032bf:	a3 44 37 11 80       	mov    %eax,0x80113744
  recover_from_log();
801032c4:	e8 95 01 00 00       	call   8010345e <recover_from_log>
}
801032c9:	c9                   	leave  
801032ca:	c3                   	ret    

801032cb <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801032cb:	55                   	push   %ebp
801032cc:	89 e5                	mov    %esp,%ebp
801032ce:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d8:	e9 89 00 00 00       	jmp    80103366 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032dd:	8b 15 34 37 11 80    	mov    0x80113734,%edx
801032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e6:	01 d0                	add    %edx,%eax
801032e8:	40                   	inc    %eax
801032e9:	89 c2                	mov    %eax,%edx
801032eb:	a1 44 37 11 80       	mov    0x80113744,%eax
801032f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801032f4:	89 04 24             	mov    %eax,(%esp)
801032f7:	e8 b9 ce ff ff       	call   801001b5 <bread>
801032fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103302:	83 c0 10             	add    $0x10,%eax
80103305:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
8010330c:	89 c2                	mov    %eax,%edx
8010330e:	a1 44 37 11 80       	mov    0x80113744,%eax
80103313:	89 54 24 04          	mov    %edx,0x4(%esp)
80103317:	89 04 24             	mov    %eax,(%esp)
8010331a:	e8 96 ce ff ff       	call   801001b5 <bread>
8010331f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103322:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103325:	8d 50 5c             	lea    0x5c(%eax),%edx
80103328:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010332b:	83 c0 5c             	add    $0x5c,%eax
8010332e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103335:	00 
80103336:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333a:	89 04 24             	mov    %eax,(%esp)
8010333d:	e8 71 1d 00 00       	call   801050b3 <memmove>
    bwrite(dbuf);  // write dst to disk
80103342:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103345:	89 04 24             	mov    %eax,(%esp)
80103348:	e8 9f ce ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
8010334d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103350:	89 04 24             	mov    %eax,(%esp)
80103353:	e8 d4 ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
80103358:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010335b:	89 04 24             	mov    %eax,(%esp)
8010335e:	e8 c9 ce ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103363:	ff 45 f4             	incl   -0xc(%ebp)
80103366:	a1 48 37 11 80       	mov    0x80113748,%eax
8010336b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010336e:	0f 8f 69 ff ff ff    	jg     801032dd <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103374:	c9                   	leave  
80103375:	c3                   	ret    

80103376 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103376:	55                   	push   %ebp
80103377:	89 e5                	mov    %esp,%ebp
80103379:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010337c:	a1 34 37 11 80       	mov    0x80113734,%eax
80103381:	89 c2                	mov    %eax,%edx
80103383:	a1 44 37 11 80       	mov    0x80113744,%eax
80103388:	89 54 24 04          	mov    %edx,0x4(%esp)
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	e8 21 ce ff ff       	call   801001b5 <bread>
80103394:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103397:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010339a:	83 c0 5c             	add    $0x5c,%eax
8010339d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033a3:	8b 00                	mov    (%eax),%eax
801033a5:	a3 48 37 11 80       	mov    %eax,0x80113748
  for (i = 0; i < log.lh.n; i++) {
801033aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033b1:	eb 1a                	jmp    801033cd <read_head+0x57>
    log.lh.block[i] = lh->block[i];
801033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033b9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033c0:	83 c2 10             	add    $0x10,%edx
801033c3:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033ca:	ff 45 f4             	incl   -0xc(%ebp)
801033cd:	a1 48 37 11 80       	mov    0x80113748,%eax
801033d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033d5:	7f dc                	jg     801033b3 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033da:	89 04 24             	mov    %eax,(%esp)
801033dd:	e8 4a ce ff ff       	call   8010022c <brelse>
}
801033e2:	c9                   	leave  
801033e3:	c3                   	ret    

801033e4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033ea:	a1 34 37 11 80       	mov    0x80113734,%eax
801033ef:	89 c2                	mov    %eax,%edx
801033f1:	a1 44 37 11 80       	mov    0x80113744,%eax
801033f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801033fa:	89 04 24             	mov    %eax,(%esp)
801033fd:	e8 b3 cd ff ff       	call   801001b5 <bread>
80103402:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103408:	83 c0 5c             	add    $0x5c,%eax
8010340b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010340e:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80103414:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103417:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103420:	eb 1a                	jmp    8010343c <write_head+0x58>
    hb->block[i] = log.lh.block[i];
80103422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103425:	83 c0 10             	add    $0x10,%eax
80103428:	8b 0c 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%ecx
8010342f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103432:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103435:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103439:	ff 45 f4             	incl   -0xc(%ebp)
8010343c:	a1 48 37 11 80       	mov    0x80113748,%eax
80103441:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103444:	7f dc                	jg     80103422 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103449:	89 04 24             	mov    %eax,(%esp)
8010344c:	e8 9b cd ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103454:	89 04 24             	mov    %eax,(%esp)
80103457:	e8 d0 cd ff ff       	call   8010022c <brelse>
}
8010345c:	c9                   	leave  
8010345d:	c3                   	ret    

8010345e <recover_from_log>:

static void
recover_from_log(void)
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
80103461:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103464:	e8 0d ff ff ff       	call   80103376 <read_head>
  install_trans(); // if committed, copy from log to disk
80103469:	e8 5d fe ff ff       	call   801032cb <install_trans>
  log.lh.n = 0;
8010346e:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80103475:	00 00 00 
  write_head(); // clear the log
80103478:	e8 67 ff ff ff       	call   801033e4 <write_head>
}
8010347d:	c9                   	leave  
8010347e:	c3                   	ret    

8010347f <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010347f:	55                   	push   %ebp
80103480:	89 e5                	mov    %esp,%ebp
80103482:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103485:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010348c:	e8 f6 18 00 00       	call   80104d87 <acquire>
  while(1){
    if(log.committing){
80103491:	a1 40 37 11 80       	mov    0x80113740,%eax
80103496:	85 c0                	test   %eax,%eax
80103498:	74 16                	je     801034b0 <begin_op+0x31>
      sleep(&log, &log.lock);
8010349a:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
801034a1:	80 
801034a2:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034a9:	e8 0a 15 00 00       	call   801049b8 <sleep>
801034ae:	eb 4d                	jmp    801034fd <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034b0:	8b 15 48 37 11 80    	mov    0x80113748,%edx
801034b6:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801034bb:	8d 48 01             	lea    0x1(%eax),%ecx
801034be:	89 c8                	mov    %ecx,%eax
801034c0:	c1 e0 02             	shl    $0x2,%eax
801034c3:	01 c8                	add    %ecx,%eax
801034c5:	01 c0                	add    %eax,%eax
801034c7:	01 d0                	add    %edx,%eax
801034c9:	83 f8 1e             	cmp    $0x1e,%eax
801034cc:	7e 16                	jle    801034e4 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034ce:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
801034d5:	80 
801034d6:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034dd:	e8 d6 14 00 00       	call   801049b8 <sleep>
801034e2:	eb 19                	jmp    801034fd <begin_op+0x7e>
    } else {
      log.outstanding += 1;
801034e4:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801034e9:	40                   	inc    %eax
801034ea:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
801034ef:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034f6:	e8 f6 18 00 00       	call   80104df1 <release>
      break;
801034fb:	eb 02                	jmp    801034ff <begin_op+0x80>
    }
  }
801034fd:	eb 92                	jmp    80103491 <begin_op+0x12>
}
801034ff:	c9                   	leave  
80103500:	c3                   	ret    

80103501 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103501:	55                   	push   %ebp
80103502:	89 e5                	mov    %esp,%ebp
80103504:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010350e:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103515:	e8 6d 18 00 00       	call   80104d87 <acquire>
  log.outstanding -= 1;
8010351a:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010351f:	48                   	dec    %eax
80103520:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
80103525:	a1 40 37 11 80       	mov    0x80113740,%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	74 0c                	je     8010353a <end_op+0x39>
    panic("log.committing");
8010352e:	c7 04 24 d1 83 10 80 	movl   $0x801083d1,(%esp)
80103535:	e8 1a d0 ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
8010353a:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010353f:	85 c0                	test   %eax,%eax
80103541:	75 13                	jne    80103556 <end_op+0x55>
    do_commit = 1;
80103543:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010354a:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80103551:	00 00 00 
80103554:	eb 0c                	jmp    80103562 <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103556:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010355d:	e8 2a 15 00 00       	call   80104a8c <wakeup>
  }
  release(&log.lock);
80103562:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103569:	e8 83 18 00 00       	call   80104df1 <release>

  if(do_commit){
8010356e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103572:	74 33                	je     801035a7 <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103574:	e8 db 00 00 00       	call   80103654 <commit>
    acquire(&log.lock);
80103579:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103580:	e8 02 18 00 00       	call   80104d87 <acquire>
    log.committing = 0;
80103585:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
8010358c:	00 00 00 
    wakeup(&log);
8010358f:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103596:	e8 f1 14 00 00       	call   80104a8c <wakeup>
    release(&log.lock);
8010359b:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801035a2:	e8 4a 18 00 00       	call   80104df1 <release>
  }
}
801035a7:	c9                   	leave  
801035a8:	c3                   	ret    

801035a9 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801035a9:	55                   	push   %ebp
801035aa:	89 e5                	mov    %esp,%ebp
801035ac:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035b6:	e9 89 00 00 00       	jmp    80103644 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035bb:	8b 15 34 37 11 80    	mov    0x80113734,%edx
801035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035c4:	01 d0                	add    %edx,%eax
801035c6:	40                   	inc    %eax
801035c7:	89 c2                	mov    %eax,%edx
801035c9:	a1 44 37 11 80       	mov    0x80113744,%eax
801035ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801035d2:	89 04 24             	mov    %eax,(%esp)
801035d5:	e8 db cb ff ff       	call   801001b5 <bread>
801035da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e0:	83 c0 10             	add    $0x10,%eax
801035e3:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801035ea:	89 c2                	mov    %eax,%edx
801035ec:	a1 44 37 11 80       	mov    0x80113744,%eax
801035f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801035f5:	89 04 24             	mov    %eax,(%esp)
801035f8:	e8 b8 cb ff ff       	call   801001b5 <bread>
801035fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103600:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103603:	8d 50 5c             	lea    0x5c(%eax),%edx
80103606:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103609:	83 c0 5c             	add    $0x5c,%eax
8010360c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103613:	00 
80103614:	89 54 24 04          	mov    %edx,0x4(%esp)
80103618:	89 04 24             	mov    %eax,(%esp)
8010361b:	e8 93 1a 00 00       	call   801050b3 <memmove>
    bwrite(to);  // write the log
80103620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103623:	89 04 24             	mov    %eax,(%esp)
80103626:	e8 c1 cb ff ff       	call   801001ec <bwrite>
    brelse(from);
8010362b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010362e:	89 04 24             	mov    %eax,(%esp)
80103631:	e8 f6 cb ff ff       	call   8010022c <brelse>
    brelse(to);
80103636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103639:	89 04 24             	mov    %eax,(%esp)
8010363c:	e8 eb cb ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103641:	ff 45 f4             	incl   -0xc(%ebp)
80103644:	a1 48 37 11 80       	mov    0x80113748,%eax
80103649:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010364c:	0f 8f 69 ff ff ff    	jg     801035bb <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103652:	c9                   	leave  
80103653:	c3                   	ret    

80103654 <commit>:

static void
commit()
{
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010365a:	a1 48 37 11 80       	mov    0x80113748,%eax
8010365f:	85 c0                	test   %eax,%eax
80103661:	7e 1e                	jle    80103681 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103663:	e8 41 ff ff ff       	call   801035a9 <write_log>
    write_head();    // Write header to disk -- the real commit
80103668:	e8 77 fd ff ff       	call   801033e4 <write_head>
    install_trans(); // Now install writes to home locations
8010366d:	e8 59 fc ff ff       	call   801032cb <install_trans>
    log.lh.n = 0;
80103672:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80103679:	00 00 00 
    write_head();    // Erase the transaction from the log
8010367c:	e8 63 fd ff ff       	call   801033e4 <write_head>
  }
}
80103681:	c9                   	leave  
80103682:	c3                   	ret    

80103683 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103683:	55                   	push   %ebp
80103684:	89 e5                	mov    %esp,%ebp
80103686:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103689:	a1 48 37 11 80       	mov    0x80113748,%eax
8010368e:	83 f8 1d             	cmp    $0x1d,%eax
80103691:	7f 10                	jg     801036a3 <log_write+0x20>
80103693:	a1 48 37 11 80       	mov    0x80113748,%eax
80103698:	8b 15 38 37 11 80    	mov    0x80113738,%edx
8010369e:	4a                   	dec    %edx
8010369f:	39 d0                	cmp    %edx,%eax
801036a1:	7c 0c                	jl     801036af <log_write+0x2c>
    panic("too big a transaction");
801036a3:	c7 04 24 e0 83 10 80 	movl   $0x801083e0,(%esp)
801036aa:	e8 a5 ce ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
801036af:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	7f 0c                	jg     801036c4 <log_write+0x41>
    panic("log_write outside of trans");
801036b8:	c7 04 24 f6 83 10 80 	movl   $0x801083f6,(%esp)
801036bf:	e8 90 ce ff ff       	call   80100554 <panic>

  acquire(&log.lock);
801036c4:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801036cb:	e8 b7 16 00 00       	call   80104d87 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036d7:	eb 1e                	jmp    801036f7 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036dc:	83 c0 10             	add    $0x10,%eax
801036df:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801036e6:	89 c2                	mov    %eax,%edx
801036e8:	8b 45 08             	mov    0x8(%ebp),%eax
801036eb:	8b 40 08             	mov    0x8(%eax),%eax
801036ee:	39 c2                	cmp    %eax,%edx
801036f0:	75 02                	jne    801036f4 <log_write+0x71>
      break;
801036f2:	eb 0d                	jmp    80103701 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036f4:	ff 45 f4             	incl   -0xc(%ebp)
801036f7:	a1 48 37 11 80       	mov    0x80113748,%eax
801036fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ff:	7f d8                	jg     801036d9 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103701:	8b 45 08             	mov    0x8(%ebp),%eax
80103704:	8b 40 08             	mov    0x8(%eax),%eax
80103707:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010370a:	83 c2 10             	add    $0x10,%edx
8010370d:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  if (i == log.lh.n)
80103714:	a1 48 37 11 80       	mov    0x80113748,%eax
80103719:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010371c:	75 0b                	jne    80103729 <log_write+0xa6>
    log.lh.n++;
8010371e:	a1 48 37 11 80       	mov    0x80113748,%eax
80103723:	40                   	inc    %eax
80103724:	a3 48 37 11 80       	mov    %eax,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
80103729:	8b 45 08             	mov    0x8(%ebp),%eax
8010372c:	8b 00                	mov    (%eax),%eax
8010372e:	83 c8 04             	or     $0x4,%eax
80103731:	89 c2                	mov    %eax,%edx
80103733:	8b 45 08             	mov    0x8(%ebp),%eax
80103736:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103738:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010373f:	e8 ad 16 00 00       	call   80104df1 <release>
}
80103744:	c9                   	leave  
80103745:	c3                   	ret    
	...

80103748 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103748:	55                   	push   %ebp
80103749:	89 e5                	mov    %esp,%ebp
8010374b:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010374e:	8b 55 08             	mov    0x8(%ebp),%edx
80103751:	8b 45 0c             	mov    0xc(%ebp),%eax
80103754:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103757:	f0 87 02             	lock xchg %eax,(%edx)
8010375a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010375d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103760:	c9                   	leave  
80103761:	c3                   	ret    

80103762 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103762:	55                   	push   %ebp
80103763:	89 e5                	mov    %esp,%ebp
80103765:	83 e4 f0             	and    $0xfffffff0,%esp
80103768:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010376b:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103772:	80 
80103773:	c7 04 24 28 65 11 80 	movl   $0x80116528,(%esp)
8010377a:	e8 0d f3 ff ff       	call   80102a8c <kinit1>
  kvmalloc();      // kernel page table
8010377f:	e8 c7 41 00 00       	call   8010794b <kvmalloc>
  mpinit();        // detect other processors
80103784:	e8 c4 03 00 00       	call   80103b4d <mpinit>
  lapicinit();     // interrupt controller
80103789:	e8 4e f6 ff ff       	call   80102ddc <lapicinit>
  seginit();       // segment descriptors
8010378e:	e8 a0 3c 00 00       	call   80107433 <seginit>
  picinit();       // disable pic
80103793:	e8 04 05 00 00       	call   80103c9c <picinit>
  ioapicinit();    // another interrupt controller
80103798:	e8 0c f2 ff ff       	call   801029a9 <ioapicinit>
  consoleinit();   // console hardware
8010379d:	e8 78 d3 ff ff       	call   80100b1a <consoleinit>
  uartinit();      // serial port
801037a2:	e8 18 30 00 00       	call   801067bf <uartinit>
  pinit();         // process table
801037a7:	e8 e6 08 00 00       	call   80104092 <pinit>
  tvinit();        // trap vectors
801037ac:	e8 f7 2b 00 00       	call   801063a8 <tvinit>
  binit();         // buffer cache
801037b1:	e8 7e c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037b6:	e8 ed d7 ff ff       	call   80100fa8 <fileinit>
  ideinit();       // disk 
801037bb:	e8 f5 ed ff ff       	call   801025b5 <ideinit>
  startothers();   // start other processors
801037c0:	e8 83 00 00 00       	call   80103848 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037c5:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037cc:	8e 
801037cd:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037d4:	e8 eb f2 ff ff       	call   80102ac4 <kinit2>
  userinit();      // first user process
801037d9:	e8 c1 0a 00 00       	call   8010429f <userinit>
  mpmain();        // finish this processor's setup
801037de:	e8 1a 00 00 00       	call   801037fd <mpmain>

801037e3 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037e3:	55                   	push   %ebp
801037e4:	89 e5                	mov    %esp,%ebp
801037e6:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037e9:	e8 74 41 00 00       	call   80107962 <switchkvm>
  seginit();
801037ee:	e8 40 3c 00 00       	call   80107433 <seginit>
  lapicinit();
801037f3:	e8 e4 f5 ff ff       	call   80102ddc <lapicinit>
  mpmain();
801037f8:	e8 00 00 00 00       	call   801037fd <mpmain>

801037fd <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037fd:	55                   	push   %ebp
801037fe:	89 e5                	mov    %esp,%ebp
80103800:	53                   	push   %ebx
80103801:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103804:	e8 a5 08 00 00       	call   801040ae <cpuid>
80103809:	89 c3                	mov    %eax,%ebx
8010380b:	e8 9e 08 00 00       	call   801040ae <cpuid>
80103810:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103814:	89 44 24 04          	mov    %eax,0x4(%esp)
80103818:	c7 04 24 11 84 10 80 	movl   $0x80108411,(%esp)
8010381f:	e8 9d cb ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
80103824:	e8 dc 2c 00 00       	call   80106505 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103829:	e8 c5 08 00 00       	call   801040f3 <mycpu>
8010382e:	05 a0 00 00 00       	add    $0xa0,%eax
80103833:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010383a:	00 
8010383b:	89 04 24             	mov    %eax,(%esp)
8010383e:	e8 05 ff ff ff       	call   80103748 <xchg>
  scheduler();     // start running processes
80103843:	e8 a6 0f 00 00       	call   801047ee <scheduler>

80103848 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103848:	55                   	push   %ebp
80103849:	89 e5                	mov    %esp,%ebp
8010384b:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010384e:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103855:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010385a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010385e:	c7 44 24 04 ec b4 10 	movl   $0x8010b4ec,0x4(%esp)
80103865:	80 
80103866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103869:	89 04 24             	mov    %eax,(%esp)
8010386c:	e8 42 18 00 00       	call   801050b3 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103871:	c7 45 f4 00 38 11 80 	movl   $0x80113800,-0xc(%ebp)
80103878:	eb 75                	jmp    801038ef <startothers+0xa7>
    if(c == mycpu())  // We've started already.
8010387a:	e8 74 08 00 00       	call   801040f3 <mycpu>
8010387f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103882:	75 02                	jne    80103886 <startothers+0x3e>
      continue;
80103884:	eb 62                	jmp    801038e8 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103886:	e8 2c f3 ff ff       	call   80102bb7 <kalloc>
8010388b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010388e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103891:	83 e8 04             	sub    $0x4,%eax
80103894:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103897:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010389d:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010389f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a2:	83 e8 08             	sub    $0x8,%eax
801038a5:	c7 00 e3 37 10 80    	movl   $0x801037e3,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ae:	8d 50 f4             	lea    -0xc(%eax),%edx
801038b1:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801038b6:	05 00 00 00 80       	add    $0x80000000,%eax
801038bb:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
801038bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801038c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c9:	8a 00                	mov    (%eax),%al
801038cb:	0f b6 c0             	movzbl %al,%eax
801038ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801038d2:	89 04 24             	mov    %eax,(%esp)
801038d5:	e8 a7 f6 ff ff       	call   80102f81 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038da:	90                   	nop
801038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038de:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801038e4:	85 c0                	test   %eax,%eax
801038e6:	74 f3                	je     801038db <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801038e8:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801038ef:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801038f4:	89 c2                	mov    %eax,%edx
801038f6:	89 d0                	mov    %edx,%eax
801038f8:	c1 e0 02             	shl    $0x2,%eax
801038fb:	01 d0                	add    %edx,%eax
801038fd:	01 c0                	add    %eax,%eax
801038ff:	01 d0                	add    %edx,%eax
80103901:	c1 e0 04             	shl    $0x4,%eax
80103904:	05 00 38 11 80       	add    $0x80113800,%eax
80103909:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010390c:	0f 87 68 ff ff ff    	ja     8010387a <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103912:	c9                   	leave  
80103913:	c3                   	ret    

80103914 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	83 ec 14             	sub    $0x14,%esp
8010391a:	8b 45 08             	mov    0x8(%ebp),%eax
8010391d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103921:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103924:	89 c2                	mov    %eax,%edx
80103926:	ec                   	in     (%dx),%al
80103927:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010392a:	8a 45 ff             	mov    -0x1(%ebp),%al
}
8010392d:	c9                   	leave  
8010392e:	c3                   	ret    

8010392f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010392f:	55                   	push   %ebp
80103930:	89 e5                	mov    %esp,%ebp
80103932:	83 ec 08             	sub    $0x8,%esp
80103935:	8b 45 08             	mov    0x8(%ebp),%eax
80103938:	8b 55 0c             	mov    0xc(%ebp),%edx
8010393b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010393f:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103942:	8a 45 f8             	mov    -0x8(%ebp),%al
80103945:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103948:	ee                   	out    %al,(%dx)
}
80103949:	c9                   	leave  
8010394a:	c3                   	ret    

8010394b <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
8010394b:	55                   	push   %ebp
8010394c:	89 e5                	mov    %esp,%ebp
8010394e:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103951:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010395f:	eb 13                	jmp    80103974 <sum+0x29>
    sum += addr[i];
80103961:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103964:	8b 45 08             	mov    0x8(%ebp),%eax
80103967:	01 d0                	add    %edx,%eax
80103969:	8a 00                	mov    (%eax),%al
8010396b:	0f b6 c0             	movzbl %al,%eax
8010396e:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103971:	ff 45 fc             	incl   -0x4(%ebp)
80103974:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103977:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010397a:	7c e5                	jl     80103961 <sum+0x16>
    sum += addr[i];
  return sum;
8010397c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010397f:	c9                   	leave  
80103980:	c3                   	ret    

80103981 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103981:	55                   	push   %ebp
80103982:	89 e5                	mov    %esp,%ebp
80103984:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103987:	8b 45 08             	mov    0x8(%ebp),%eax
8010398a:	05 00 00 00 80       	add    $0x80000000,%eax
8010398f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103992:	8b 55 0c             	mov    0xc(%ebp),%edx
80103995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103998:	01 d0                	add    %edx,%eax
8010399a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010399d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039a3:	eb 3f                	jmp    801039e4 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039a5:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039ac:	00 
801039ad:	c7 44 24 04 28 84 10 	movl   $0x80108428,0x4(%esp)
801039b4:	80 
801039b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b8:	89 04 24             	mov    %eax,(%esp)
801039bb:	e8 a1 16 00 00       	call   80105061 <memcmp>
801039c0:	85 c0                	test   %eax,%eax
801039c2:	75 1c                	jne    801039e0 <mpsearch1+0x5f>
801039c4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801039cb:	00 
801039cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cf:	89 04 24             	mov    %eax,(%esp)
801039d2:	e8 74 ff ff ff       	call   8010394b <sum>
801039d7:	84 c0                	test   %al,%al
801039d9:	75 05                	jne    801039e0 <mpsearch1+0x5f>
      return (struct mp*)p;
801039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039de:	eb 11                	jmp    801039f1 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801039e0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801039e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039ea:	72 b9                	jb     801039a5 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801039ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801039f1:	c9                   	leave  
801039f2:	c3                   	ret    

801039f3 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801039f3:	55                   	push   %ebp
801039f4:	89 e5                	mov    %esp,%ebp
801039f6:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801039f9:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a03:	83 c0 0f             	add    $0xf,%eax
80103a06:	8a 00                	mov    (%eax),%al
80103a08:	0f b6 c0             	movzbl %al,%eax
80103a0b:	c1 e0 08             	shl    $0x8,%eax
80103a0e:	89 c2                	mov    %eax,%edx
80103a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a13:	83 c0 0e             	add    $0xe,%eax
80103a16:	8a 00                	mov    (%eax),%al
80103a18:	0f b6 c0             	movzbl %al,%eax
80103a1b:	09 d0                	or     %edx,%eax
80103a1d:	c1 e0 04             	shl    $0x4,%eax
80103a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a27:	74 21                	je     80103a4a <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103a29:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a30:	00 
80103a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a34:	89 04 24             	mov    %eax,(%esp)
80103a37:	e8 45 ff ff ff       	call   80103981 <mpsearch1>
80103a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a43:	74 4e                	je     80103a93 <mpsearch+0xa0>
      return mp;
80103a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a48:	eb 5d                	jmp    80103aa7 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4d:	83 c0 14             	add    $0x14,%eax
80103a50:	8a 00                	mov    (%eax),%al
80103a52:	0f b6 c0             	movzbl %al,%eax
80103a55:	c1 e0 08             	shl    $0x8,%eax
80103a58:	89 c2                	mov    %eax,%edx
80103a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5d:	83 c0 13             	add    $0x13,%eax
80103a60:	8a 00                	mov    (%eax),%al
80103a62:	0f b6 c0             	movzbl %al,%eax
80103a65:	09 d0                	or     %edx,%eax
80103a67:	c1 e0 0a             	shl    $0xa,%eax
80103a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a70:	2d 00 04 00 00       	sub    $0x400,%eax
80103a75:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a7c:	00 
80103a7d:	89 04 24             	mov    %eax,(%esp)
80103a80:	e8 fc fe ff ff       	call   80103981 <mpsearch1>
80103a85:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a8c:	74 05                	je     80103a93 <mpsearch+0xa0>
      return mp;
80103a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a91:	eb 14                	jmp    80103aa7 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103a93:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103a9a:	00 
80103a9b:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103aa2:	e8 da fe ff ff       	call   80103981 <mpsearch1>
}
80103aa7:	c9                   	leave  
80103aa8:	c3                   	ret    

80103aa9 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103aa9:	55                   	push   %ebp
80103aaa:	89 e5                	mov    %esp,%ebp
80103aac:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aaf:	e8 3f ff ff ff       	call   801039f3 <mpsearch>
80103ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103abb:	74 0a                	je     80103ac7 <mpconfig+0x1e>
80103abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac0:	8b 40 04             	mov    0x4(%eax),%eax
80103ac3:	85 c0                	test   %eax,%eax
80103ac5:	75 07                	jne    80103ace <mpconfig+0x25>
    return 0;
80103ac7:	b8 00 00 00 00       	mov    $0x0,%eax
80103acc:	eb 7d                	jmp    80103b4b <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad1:	8b 40 04             	mov    0x4(%eax),%eax
80103ad4:	05 00 00 00 80       	add    $0x80000000,%eax
80103ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103adc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103ae3:	00 
80103ae4:	c7 44 24 04 2d 84 10 	movl   $0x8010842d,0x4(%esp)
80103aeb:	80 
80103aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aef:	89 04 24             	mov    %eax,(%esp)
80103af2:	e8 6a 15 00 00       	call   80105061 <memcmp>
80103af7:	85 c0                	test   %eax,%eax
80103af9:	74 07                	je     80103b02 <mpconfig+0x59>
    return 0;
80103afb:	b8 00 00 00 00       	mov    $0x0,%eax
80103b00:	eb 49                	jmp    80103b4b <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b05:	8a 40 06             	mov    0x6(%eax),%al
80103b08:	3c 01                	cmp    $0x1,%al
80103b0a:	74 11                	je     80103b1d <mpconfig+0x74>
80103b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b0f:	8a 40 06             	mov    0x6(%eax),%al
80103b12:	3c 04                	cmp    $0x4,%al
80103b14:	74 07                	je     80103b1d <mpconfig+0x74>
    return 0;
80103b16:	b8 00 00 00 00       	mov    $0x0,%eax
80103b1b:	eb 2e                	jmp    80103b4b <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b20:	8b 40 04             	mov    0x4(%eax),%eax
80103b23:	0f b7 c0             	movzwl %ax,%eax
80103b26:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b2d:	89 04 24             	mov    %eax,(%esp)
80103b30:	e8 16 fe ff ff       	call   8010394b <sum>
80103b35:	84 c0                	test   %al,%al
80103b37:	74 07                	je     80103b40 <mpconfig+0x97>
    return 0;
80103b39:	b8 00 00 00 00       	mov    $0x0,%eax
80103b3e:	eb 0b                	jmp    80103b4b <mpconfig+0xa2>
  *pmp = mp;
80103b40:	8b 45 08             	mov    0x8(%ebp),%eax
80103b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b46:	89 10                	mov    %edx,(%eax)
  return conf;
80103b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b4b:	c9                   	leave  
80103b4c:	c3                   	ret    

80103b4d <mpinit>:

void
mpinit(void)
{
80103b4d:	55                   	push   %ebp
80103b4e:	89 e5                	mov    %esp,%ebp
80103b50:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b53:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103b56:	89 04 24             	mov    %eax,(%esp)
80103b59:	e8 4b ff ff ff       	call   80103aa9 <mpconfig>
80103b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b65:	75 0c                	jne    80103b73 <mpinit+0x26>
    panic("Expect to run on an SMP");
80103b67:	c7 04 24 32 84 10 80 	movl   $0x80108432,(%esp)
80103b6e:	e8 e1 c9 ff ff       	call   80100554 <panic>
  ismp = 1;
80103b73:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b7d:	8b 40 24             	mov    0x24(%eax),%eax
80103b80:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b88:	83 c0 2c             	add    $0x2c,%eax
80103b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b91:	8b 40 04             	mov    0x4(%eax),%eax
80103b94:	0f b7 d0             	movzwl %ax,%edx
80103b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b9a:	01 d0                	add    %edx,%eax
80103b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103b9f:	eb 7d                	jmp    80103c1e <mpinit+0xd1>
    switch(*p){
80103ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba4:	8a 00                	mov    (%eax),%al
80103ba6:	0f b6 c0             	movzbl %al,%eax
80103ba9:	83 f8 04             	cmp    $0x4,%eax
80103bac:	77 68                	ja     80103c16 <mpinit+0xc9>
80103bae:	8b 04 85 6c 84 10 80 	mov    -0x7fef7b94(,%eax,4),%eax
80103bb5:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103bbd:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103bc2:	83 f8 07             	cmp    $0x7,%eax
80103bc5:	7f 2c                	jg     80103bf3 <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bc7:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
80103bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bd0:	8a 48 01             	mov    0x1(%eax),%cl
80103bd3:	89 d0                	mov    %edx,%eax
80103bd5:	c1 e0 02             	shl    $0x2,%eax
80103bd8:	01 d0                	add    %edx,%eax
80103bda:	01 c0                	add    %eax,%eax
80103bdc:	01 d0                	add    %edx,%eax
80103bde:	c1 e0 04             	shl    $0x4,%eax
80103be1:	05 00 38 11 80       	add    $0x80113800,%eax
80103be6:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103be8:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103bed:	40                   	inc    %eax
80103bee:	a3 80 3d 11 80       	mov    %eax,0x80113d80
      }
      p += sizeof(struct mpproc);
80103bf3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103bf7:	eb 25                	jmp    80103c1e <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c02:	8a 40 01             	mov    0x1(%eax),%al
80103c05:	a2 e0 37 11 80       	mov    %al,0x801137e0
      p += sizeof(struct mpioapic);
80103c0a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c0e:	eb 0e                	jmp    80103c1e <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c10:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c14:	eb 08                	jmp    80103c1e <mpinit+0xd1>
    default:
      ismp = 0;
80103c16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103c1d:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c21:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103c24:	0f 82 77 ff ff ff    	jb     80103ba1 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c2e:	75 0c                	jne    80103c3c <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103c30:	c7 04 24 4c 84 10 80 	movl   $0x8010844c,(%esp)
80103c37:	e8 18 c9 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80103c3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103c3f:	8a 40 0c             	mov    0xc(%eax),%al
80103c42:	84 c0                	test   %al,%al
80103c44:	74 36                	je     80103c7c <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103c46:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103c4d:	00 
80103c4e:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103c55:	e8 d5 fc ff ff       	call   8010392f <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c5a:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c61:	e8 ae fc ff ff       	call   80103914 <inb>
80103c66:	83 c8 01             	or     $0x1,%eax
80103c69:	0f b6 c0             	movzbl %al,%eax
80103c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c70:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c77:	e8 b3 fc ff ff       	call   8010392f <outb>
  }
}
80103c7c:	c9                   	leave  
80103c7d:	c3                   	ret    
	...

80103c80 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 08             	sub    $0x8,%esp
80103c86:	8b 45 08             	mov    0x8(%ebp),%eax
80103c89:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c8c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c90:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c93:	8a 45 f8             	mov    -0x8(%ebp),%al
80103c96:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c99:	ee                   	out    %al,(%dx)
}
80103c9a:	c9                   	leave  
80103c9b:	c3                   	ret    

80103c9c <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c9c:	55                   	push   %ebp
80103c9d:	89 e5                	mov    %esp,%ebp
80103c9f:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ca2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ca9:	00 
80103caa:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103cb1:	e8 ca ff ff ff       	call   80103c80 <outb>
  outb(IO_PIC2+1, 0xFF);
80103cb6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cbd:	00 
80103cbe:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cc5:	e8 b6 ff ff ff       	call   80103c80 <outb>
}
80103cca:	c9                   	leave  
80103ccb:	c3                   	ret    

80103ccc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ccc:	55                   	push   %ebp
80103ccd:	89 e5                	mov    %esp,%ebp
80103ccf:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce5:	8b 10                	mov    (%eax),%edx
80103ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cea:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103cec:	e8 d3 d2 ff ff       	call   80100fc4 <filealloc>
80103cf1:	8b 55 08             	mov    0x8(%ebp),%edx
80103cf4:	89 02                	mov    %eax,(%edx)
80103cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf9:	8b 00                	mov    (%eax),%eax
80103cfb:	85 c0                	test   %eax,%eax
80103cfd:	0f 84 c8 00 00 00    	je     80103dcb <pipealloc+0xff>
80103d03:	e8 bc d2 ff ff       	call   80100fc4 <filealloc>
80103d08:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d0b:	89 02                	mov    %eax,(%edx)
80103d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d10:	8b 00                	mov    (%eax),%eax
80103d12:	85 c0                	test   %eax,%eax
80103d14:	0f 84 b1 00 00 00    	je     80103dcb <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d1a:	e8 98 ee ff ff       	call   80102bb7 <kalloc>
80103d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d26:	75 05                	jne    80103d2d <pipealloc+0x61>
    goto bad;
80103d28:	e9 9e 00 00 00       	jmp    80103dcb <pipealloc+0xff>
  p->readopen = 1;
80103d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d30:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d37:	00 00 00 
  p->writeopen = 1;
80103d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d44:	00 00 00 
  p->nwrite = 0;
80103d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4a:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d51:	00 00 00 
  p->nread = 0;
80103d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d57:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d5e:	00 00 00 
  initlock(&p->lock, "pipe");
80103d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d64:	c7 44 24 04 80 84 10 	movl   $0x80108480,0x4(%esp)
80103d6b:	80 
80103d6c:	89 04 24             	mov    %eax,(%esp)
80103d6f:	e8 f2 0f 00 00       	call   80104d66 <initlock>
  (*f0)->type = FD_PIPE;
80103d74:	8b 45 08             	mov    0x8(%ebp),%eax
80103d77:	8b 00                	mov    (%eax),%eax
80103d79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d82:	8b 00                	mov    (%eax),%eax
80103d84:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d88:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8b:	8b 00                	mov    (%eax),%eax
80103d8d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d91:	8b 45 08             	mov    0x8(%ebp),%eax
80103d94:	8b 00                	mov    (%eax),%eax
80103d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d99:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9f:	8b 00                	mov    (%eax),%eax
80103da1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103da7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103daa:	8b 00                	mov    (%eax),%eax
80103dac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db3:	8b 00                	mov    (%eax),%eax
80103db5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103db9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dbc:	8b 00                	mov    (%eax),%eax
80103dbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dc1:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103dc4:	b8 00 00 00 00       	mov    $0x0,%eax
80103dc9:	eb 42                	jmp    80103e0d <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103dcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dcf:	74 0b                	je     80103ddc <pipealloc+0x110>
    kfree((char*)p);
80103dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd4:	89 04 24             	mov    %eax,(%esp)
80103dd7:	e8 45 ed ff ff       	call   80102b21 <kfree>
  if(*f0)
80103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddf:	8b 00                	mov    (%eax),%eax
80103de1:	85 c0                	test   %eax,%eax
80103de3:	74 0d                	je     80103df2 <pipealloc+0x126>
    fileclose(*f0);
80103de5:	8b 45 08             	mov    0x8(%ebp),%eax
80103de8:	8b 00                	mov    (%eax),%eax
80103dea:	89 04 24             	mov    %eax,(%esp)
80103ded:	e8 7a d2 ff ff       	call   8010106c <fileclose>
  if(*f1)
80103df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df5:	8b 00                	mov    (%eax),%eax
80103df7:	85 c0                	test   %eax,%eax
80103df9:	74 0d                	je     80103e08 <pipealloc+0x13c>
    fileclose(*f1);
80103dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dfe:	8b 00                	mov    (%eax),%eax
80103e00:	89 04 24             	mov    %eax,(%esp)
80103e03:	e8 64 d2 ff ff       	call   8010106c <fileclose>
  return -1;
80103e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e0d:	c9                   	leave  
80103e0e:	c3                   	ret    

80103e0f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e0f:	55                   	push   %ebp
80103e10:	89 e5                	mov    %esp,%ebp
80103e12:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e15:	8b 45 08             	mov    0x8(%ebp),%eax
80103e18:	89 04 24             	mov    %eax,(%esp)
80103e1b:	e8 67 0f 00 00       	call   80104d87 <acquire>
  if(writable){
80103e20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e24:	74 1f                	je     80103e45 <pipeclose+0x36>
    p->writeopen = 0;
80103e26:	8b 45 08             	mov    0x8(%ebp),%eax
80103e29:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e30:	00 00 00 
    wakeup(&p->nread);
80103e33:	8b 45 08             	mov    0x8(%ebp),%eax
80103e36:	05 34 02 00 00       	add    $0x234,%eax
80103e3b:	89 04 24             	mov    %eax,(%esp)
80103e3e:	e8 49 0c 00 00       	call   80104a8c <wakeup>
80103e43:	eb 1d                	jmp    80103e62 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e45:	8b 45 08             	mov    0x8(%ebp),%eax
80103e48:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e4f:	00 00 00 
    wakeup(&p->nwrite);
80103e52:	8b 45 08             	mov    0x8(%ebp),%eax
80103e55:	05 38 02 00 00       	add    $0x238,%eax
80103e5a:	89 04 24             	mov    %eax,(%esp)
80103e5d:	e8 2a 0c 00 00       	call   80104a8c <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e62:	8b 45 08             	mov    0x8(%ebp),%eax
80103e65:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e6b:	85 c0                	test   %eax,%eax
80103e6d:	75 25                	jne    80103e94 <pipeclose+0x85>
80103e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e72:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	75 18                	jne    80103e94 <pipeclose+0x85>
    release(&p->lock);
80103e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7f:	89 04 24             	mov    %eax,(%esp)
80103e82:	e8 6a 0f 00 00       	call   80104df1 <release>
    kfree((char*)p);
80103e87:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8a:	89 04 24             	mov    %eax,(%esp)
80103e8d:	e8 8f ec ff ff       	call   80102b21 <kfree>
80103e92:	eb 0b                	jmp    80103e9f <pipeclose+0x90>
  } else
    release(&p->lock);
80103e94:	8b 45 08             	mov    0x8(%ebp),%eax
80103e97:	89 04 24             	mov    %eax,(%esp)
80103e9a:	e8 52 0f 00 00       	call   80104df1 <release>
}
80103e9f:	c9                   	leave  
80103ea0:	c3                   	ret    

80103ea1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ea1:	55                   	push   %ebp
80103ea2:	89 e5                	mov    %esp,%ebp
80103ea4:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eaa:	89 04 24             	mov    %eax,(%esp)
80103ead:	e8 d5 0e 00 00       	call   80104d87 <acquire>
  for(i = 0; i < n; i++){
80103eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103eb9:	e9 a3 00 00 00       	jmp    80103f61 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ebe:	eb 56                	jmp    80103f16 <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ec9:	85 c0                	test   %eax,%eax
80103ecb:	74 0c                	je     80103ed9 <pipewrite+0x38>
80103ecd:	e8 a5 02 00 00       	call   80104177 <myproc>
80103ed2:	8b 40 24             	mov    0x24(%eax),%eax
80103ed5:	85 c0                	test   %eax,%eax
80103ed7:	74 15                	je     80103eee <pipewrite+0x4d>
        release(&p->lock);
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	89 04 24             	mov    %eax,(%esp)
80103edf:	e8 0d 0f 00 00       	call   80104df1 <release>
        return -1;
80103ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ee9:	e9 9d 00 00 00       	jmp    80103f8b <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103eee:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef1:	05 34 02 00 00       	add    $0x234,%eax
80103ef6:	89 04 24             	mov    %eax,(%esp)
80103ef9:	e8 8e 0b 00 00       	call   80104a8c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103efe:	8b 45 08             	mov    0x8(%ebp),%eax
80103f01:	8b 55 08             	mov    0x8(%ebp),%edx
80103f04:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f0e:	89 14 24             	mov    %edx,(%esp)
80103f11:	e8 a2 0a 00 00       	call   801049b8 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f16:	8b 45 08             	mov    0x8(%ebp),%eax
80103f19:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f22:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f28:	05 00 02 00 00       	add    $0x200,%eax
80103f2d:	39 c2                	cmp    %eax,%edx
80103f2f:	74 8f                	je     80103ec0 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f31:	8b 45 08             	mov    0x8(%ebp),%eax
80103f34:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f3a:	8d 48 01             	lea    0x1(%eax),%ecx
80103f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f40:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f46:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f4b:	89 c1                	mov    %eax,%ecx
80103f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f50:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f53:	01 d0                	add    %edx,%eax
80103f55:	8a 10                	mov    (%eax),%dl
80103f57:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5a:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f5e:	ff 45 f4             	incl   -0xc(%ebp)
80103f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f64:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f67:	0f 8c 51 ff ff ff    	jl     80103ebe <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f70:	05 34 02 00 00       	add    $0x234,%eax
80103f75:	89 04 24             	mov    %eax,(%esp)
80103f78:	e8 0f 0b 00 00       	call   80104a8c <wakeup>
  release(&p->lock);
80103f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f80:	89 04 24             	mov    %eax,(%esp)
80103f83:	e8 69 0e 00 00       	call   80104df1 <release>
  return n;
80103f88:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f8b:	c9                   	leave  
80103f8c:	c3                   	ret    

80103f8d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f8d:	55                   	push   %ebp
80103f8e:	89 e5                	mov    %esp,%ebp
80103f90:	53                   	push   %ebx
80103f91:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f94:	8b 45 08             	mov    0x8(%ebp),%eax
80103f97:	89 04 24             	mov    %eax,(%esp)
80103f9a:	e8 e8 0d 00 00       	call   80104d87 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f9f:	eb 39                	jmp    80103fda <piperead+0x4d>
    if(myproc()->killed){
80103fa1:	e8 d1 01 00 00       	call   80104177 <myproc>
80103fa6:	8b 40 24             	mov    0x24(%eax),%eax
80103fa9:	85 c0                	test   %eax,%eax
80103fab:	74 15                	je     80103fc2 <piperead+0x35>
      release(&p->lock);
80103fad:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb0:	89 04 24             	mov    %eax,(%esp)
80103fb3:	e8 39 0e 00 00       	call   80104df1 <release>
      return -1;
80103fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fbd:	e9 b3 00 00 00       	jmp    80104075 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc5:	8b 55 08             	mov    0x8(%ebp),%edx
80103fc8:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fce:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fd2:	89 14 24             	mov    %edx,(%esp)
80103fd5:	e8 de 09 00 00       	call   801049b8 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fda:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdd:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe6:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fec:	39 c2                	cmp    %eax,%edx
80103fee:	75 0d                	jne    80103ffd <piperead+0x70>
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ff9:	85 c0                	test   %eax,%eax
80103ffb:	75 a4                	jne    80103fa1 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104004:	eb 49                	jmp    8010404f <piperead+0xc2>
    if(p->nread == p->nwrite)
80104006:	8b 45 08             	mov    0x8(%ebp),%eax
80104009:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
80104012:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104018:	39 c2                	cmp    %eax,%edx
8010401a:	75 02                	jne    8010401e <piperead+0x91>
      break;
8010401c:	eb 39                	jmp    80104057 <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010401e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104021:	8b 45 0c             	mov    0xc(%ebp),%eax
80104024:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104030:	8d 48 01             	lea    0x1(%eax),%ecx
80104033:	8b 55 08             	mov    0x8(%ebp),%edx
80104036:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010403c:	25 ff 01 00 00       	and    $0x1ff,%eax
80104041:	89 c2                	mov    %eax,%edx
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
8010404a:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010404c:	ff 45 f4             	incl   -0xc(%ebp)
8010404f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104052:	3b 45 10             	cmp    0x10(%ebp),%eax
80104055:	7c af                	jl     80104006 <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104057:	8b 45 08             	mov    0x8(%ebp),%eax
8010405a:	05 38 02 00 00       	add    $0x238,%eax
8010405f:	89 04 24             	mov    %eax,(%esp)
80104062:	e8 25 0a 00 00       	call   80104a8c <wakeup>
  release(&p->lock);
80104067:	8b 45 08             	mov    0x8(%ebp),%eax
8010406a:	89 04 24             	mov    %eax,(%esp)
8010406d:	e8 7f 0d 00 00       	call   80104df1 <release>
  return i;
80104072:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104075:	83 c4 24             	add    $0x24,%esp
80104078:	5b                   	pop    %ebx
80104079:	5d                   	pop    %ebp
8010407a:	c3                   	ret    
	...

8010407c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010407c:	55                   	push   %ebp
8010407d:	89 e5                	mov    %esp,%ebp
8010407f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104082:	9c                   	pushf  
80104083:	58                   	pop    %eax
80104084:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104087:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010408a:	c9                   	leave  
8010408b:	c3                   	ret    

8010408c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010408c:	55                   	push   %ebp
8010408d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010408f:	fb                   	sti    
}
80104090:	5d                   	pop    %ebp
80104091:	c3                   	ret    

80104092 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104092:	55                   	push   %ebp
80104093:	89 e5                	mov    %esp,%ebp
80104095:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104098:	c7 44 24 04 88 84 10 	movl   $0x80108488,0x4(%esp)
8010409f:	80 
801040a0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801040a7:	e8 ba 0c 00 00       	call   80104d66 <initlock>
}
801040ac:	c9                   	leave  
801040ad:	c3                   	ret    

801040ae <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801040ae:	55                   	push   %ebp
801040af:	89 e5                	mov    %esp,%ebp
801040b1:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040b4:	e8 3a 00 00 00       	call   801040f3 <mycpu>
801040b9:	89 c2                	mov    %eax,%edx
801040bb:	b8 00 38 11 80       	mov    $0x80113800,%eax
801040c0:	29 c2                	sub    %eax,%edx
801040c2:	89 d0                	mov    %edx,%eax
801040c4:	c1 f8 04             	sar    $0x4,%eax
801040c7:	89 c1                	mov    %eax,%ecx
801040c9:	89 ca                	mov    %ecx,%edx
801040cb:	c1 e2 03             	shl    $0x3,%edx
801040ce:	01 ca                	add    %ecx,%edx
801040d0:	89 d0                	mov    %edx,%eax
801040d2:	c1 e0 05             	shl    $0x5,%eax
801040d5:	29 d0                	sub    %edx,%eax
801040d7:	c1 e0 02             	shl    $0x2,%eax
801040da:	01 c8                	add    %ecx,%eax
801040dc:	c1 e0 03             	shl    $0x3,%eax
801040df:	01 c8                	add    %ecx,%eax
801040e1:	89 c2                	mov    %eax,%edx
801040e3:	c1 e2 0f             	shl    $0xf,%edx
801040e6:	29 c2                	sub    %eax,%edx
801040e8:	c1 e2 02             	shl    $0x2,%edx
801040eb:	01 ca                	add    %ecx,%edx
801040ed:	89 d0                	mov    %edx,%eax
801040ef:	f7 d8                	neg    %eax
}
801040f1:	c9                   	leave  
801040f2:	c3                   	ret    

801040f3 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801040f3:	55                   	push   %ebp
801040f4:	89 e5                	mov    %esp,%ebp
801040f6:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801040f9:	e8 7e ff ff ff       	call   8010407c <readeflags>
801040fe:	25 00 02 00 00       	and    $0x200,%eax
80104103:	85 c0                	test   %eax,%eax
80104105:	74 0c                	je     80104113 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
80104107:	c7 04 24 90 84 10 80 	movl   $0x80108490,(%esp)
8010410e:	e8 41 c4 ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
80104113:	e8 1d ee ff ff       	call   80102f35 <lapicid>
80104118:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010411b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104122:	eb 3b                	jmp    8010415f <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
80104124:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104127:	89 d0                	mov    %edx,%eax
80104129:	c1 e0 02             	shl    $0x2,%eax
8010412c:	01 d0                	add    %edx,%eax
8010412e:	01 c0                	add    %eax,%eax
80104130:	01 d0                	add    %edx,%eax
80104132:	c1 e0 04             	shl    $0x4,%eax
80104135:	05 00 38 11 80       	add    $0x80113800,%eax
8010413a:	8a 00                	mov    (%eax),%al
8010413c:	0f b6 c0             	movzbl %al,%eax
8010413f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104142:	75 18                	jne    8010415c <mycpu+0x69>
      return &cpus[i];
80104144:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104147:	89 d0                	mov    %edx,%eax
80104149:	c1 e0 02             	shl    $0x2,%eax
8010414c:	01 d0                	add    %edx,%eax
8010414e:	01 c0                	add    %eax,%eax
80104150:	01 d0                	add    %edx,%eax
80104152:	c1 e0 04             	shl    $0x4,%eax
80104155:	05 00 38 11 80       	add    $0x80113800,%eax
8010415a:	eb 19                	jmp    80104175 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010415c:	ff 45 f4             	incl   -0xc(%ebp)
8010415f:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80104164:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104167:	7c bb                	jl     80104124 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80104169:	c7 04 24 b6 84 10 80 	movl   $0x801084b6,(%esp)
80104170:	e8 df c3 ff ff       	call   80100554 <panic>
}
80104175:	c9                   	leave  
80104176:	c3                   	ret    

80104177 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104177:	55                   	push   %ebp
80104178:	89 e5                	mov    %esp,%ebp
8010417a:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
8010417d:	e8 64 0d 00 00       	call   80104ee6 <pushcli>
  c = mycpu();
80104182:	e8 6c ff ff ff       	call   801040f3 <mycpu>
80104187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104193:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104196:	e8 95 0d 00 00       	call   80104f30 <popcli>
  return p;
8010419b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010419e:	c9                   	leave  
8010419f:	c3                   	ret    

801041a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041a6:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801041ad:	e8 d5 0b 00 00       	call   80104d87 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b2:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801041b9:	eb 50                	jmp    8010420b <allocproc+0x6b>
    if(p->state == UNUSED)
801041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041be:	8b 40 0c             	mov    0xc(%eax),%eax
801041c1:	85 c0                	test   %eax,%eax
801041c3:	75 42                	jne    80104207 <allocproc+0x67>
      goto found;
801041c5:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801041c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c9:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801041d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801041d5:	8d 50 01             	lea    0x1(%eax),%edx
801041d8:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
801041de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e1:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
801041e4:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801041eb:	e8 01 0c 00 00       	call   80104df1 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041f0:	e8 c2 e9 ff ff       	call   80102bb7 <kalloc>
801041f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041f8:	89 42 08             	mov    %eax,0x8(%edx)
801041fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fe:	8b 40 08             	mov    0x8(%eax),%eax
80104201:	85 c0                	test   %eax,%eax
80104203:	75 33                	jne    80104238 <allocproc+0x98>
80104205:	eb 20                	jmp    80104227 <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104207:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010420b:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104212:	72 a7                	jb     801041bb <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80104214:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010421b:	e8 d1 0b 00 00       	call   80104df1 <release>
  return 0;
80104220:	b8 00 00 00 00       	mov    $0x0,%eax
80104225:	eb 76                	jmp    8010429d <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104231:	b8 00 00 00 00       	mov    $0x0,%eax
80104236:	eb 65                	jmp    8010429d <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
80104238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423b:	8b 40 08             	mov    0x8(%eax),%eax
8010423e:	05 00 10 00 00       	add    $0x1000,%eax
80104243:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104246:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010424a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104250:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104253:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104257:	ba 64 63 10 80       	mov    $0x80106364,%edx
8010425c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010425f:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104261:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104268:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010426b:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010426e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104271:	8b 40 1c             	mov    0x1c(%eax),%eax
80104274:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010427b:	00 
8010427c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104283:	00 
80104284:	89 04 24             	mov    %eax,(%esp)
80104287:	e8 5e 0d 00 00       	call   80104fea <memset>
  p->context->eip = (uint)forkret;
8010428c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104292:	ba 79 49 10 80       	mov    $0x80104979,%edx
80104297:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010429a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010429d:	c9                   	leave  
8010429e:	c3                   	ret    

8010429f <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010429f:	55                   	push   %ebp
801042a0:	89 e5                	mov    %esp,%ebp
801042a2:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801042a5:	e8 f6 fe ff ff       	call   801041a0 <allocproc>
801042aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801042ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b0:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
801042b5:	e8 e8 35 00 00       	call   801078a2 <setupkvm>
801042ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042bd:	89 42 04             	mov    %eax,0x4(%edx)
801042c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c3:	8b 40 04             	mov    0x4(%eax),%eax
801042c6:	85 c0                	test   %eax,%eax
801042c8:	75 0c                	jne    801042d6 <userinit+0x37>
    panic("userinit: out of memory?");
801042ca:	c7 04 24 c6 84 10 80 	movl   $0x801084c6,(%esp)
801042d1:	e8 7e c2 ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042d6:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042de:	8b 40 04             	mov    0x4(%eax),%eax
801042e1:	89 54 24 08          	mov    %edx,0x8(%esp)
801042e5:	c7 44 24 04 c0 b4 10 	movl   $0x8010b4c0,0x4(%esp)
801042ec:	80 
801042ed:	89 04 24             	mov    %eax,(%esp)
801042f0:	e8 0e 38 00 00       	call   80107b03 <inituvm>
  p->sz = PGSIZE;
801042f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f8:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104301:	8b 40 18             	mov    0x18(%eax),%eax
80104304:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010430b:	00 
8010430c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104313:	00 
80104314:	89 04 24             	mov    %eax,(%esp)
80104317:	e8 ce 0c 00 00       	call   80104fea <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010431f:	8b 40 18             	mov    0x18(%eax),%eax
80104322:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432b:	8b 40 18             	mov    0x18(%eax),%eax
8010432e:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104337:	8b 50 18             	mov    0x18(%eax),%edx
8010433a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433d:	8b 40 18             	mov    0x18(%eax),%eax
80104340:	8b 40 2c             	mov    0x2c(%eax),%eax
80104343:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
80104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434a:	8b 50 18             	mov    0x18(%eax),%edx
8010434d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104350:	8b 40 18             	mov    0x18(%eax),%eax
80104353:	8b 40 2c             	mov    0x2c(%eax),%eax
80104356:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
8010435a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435d:	8b 40 18             	mov    0x18(%eax),%eax
80104360:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436a:	8b 40 18             	mov    0x18(%eax),%eax
8010436d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104377:	8b 40 18             	mov    0x18(%eax),%eax
8010437a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104384:	83 c0 6c             	add    $0x6c,%eax
80104387:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010438e:	00 
8010438f:	c7 44 24 04 df 84 10 	movl   $0x801084df,0x4(%esp)
80104396:	80 
80104397:	89 04 24             	mov    %eax,(%esp)
8010439a:	e8 57 0e 00 00       	call   801051f6 <safestrcpy>
  p->cwd = namei("/");
8010439f:	c7 04 24 e8 84 10 80 	movl   $0x801084e8,(%esp)
801043a6:	e8 00 e1 ff ff       	call   801024ab <namei>
801043ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ae:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801043b1:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801043b8:	e8 ca 09 00 00       	call   80104d87 <acquire>

  p->state = RUNNABLE;
801043bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801043c7:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801043ce:	e8 1e 0a 00 00       	call   80104df1 <release>
}
801043d3:	c9                   	leave  
801043d4:	c3                   	ret    

801043d5 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801043d5:	55                   	push   %ebp
801043d6:	89 e5                	mov    %esp,%ebp
801043d8:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
801043db:	e8 97 fd ff ff       	call   80104177 <myproc>
801043e0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801043e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043e6:	8b 00                	mov    (%eax),%eax
801043e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801043eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043ef:	7e 31                	jle    80104422 <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043f1:	8b 55 08             	mov    0x8(%ebp),%edx
801043f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f7:	01 c2                	add    %eax,%edx
801043f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043fc:	8b 40 04             	mov    0x4(%eax),%eax
801043ff:	89 54 24 08          	mov    %edx,0x8(%esp)
80104403:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104406:	89 54 24 04          	mov    %edx,0x4(%esp)
8010440a:	89 04 24             	mov    %eax,(%esp)
8010440d:	e8 5c 38 00 00       	call   80107c6e <allocuvm>
80104412:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104419:	75 3e                	jne    80104459 <growproc+0x84>
      return -1;
8010441b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104420:	eb 4f                	jmp    80104471 <growproc+0x9c>
  } else if(n < 0){
80104422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104426:	79 31                	jns    80104459 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104428:	8b 55 08             	mov    0x8(%ebp),%edx
8010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442e:	01 c2                	add    %eax,%edx
80104430:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104433:	8b 40 04             	mov    0x4(%eax),%eax
80104436:	89 54 24 08          	mov    %edx,0x8(%esp)
8010443a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010443d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104441:	89 04 24             	mov    %eax,(%esp)
80104444:	e8 3b 39 00 00       	call   80107d84 <deallocuvm>
80104449:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010444c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104450:	75 07                	jne    80104459 <growproc+0x84>
      return -1;
80104452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104457:	eb 18                	jmp    80104471 <growproc+0x9c>
  }
  curproc->sz = sz;
80104459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010445c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010445f:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104464:	89 04 24             	mov    %eax,(%esp)
80104467:	e8 10 35 00 00       	call   8010797c <switchuvm>
  return 0;
8010446c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104471:	c9                   	leave  
80104472:	c3                   	ret    

80104473 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104473:	55                   	push   %ebp
80104474:	89 e5                	mov    %esp,%ebp
80104476:	57                   	push   %edi
80104477:	56                   	push   %esi
80104478:	53                   	push   %ebx
80104479:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
8010447c:	e8 f6 fc ff ff       	call   80104177 <myproc>
80104481:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104484:	e8 17 fd ff ff       	call   801041a0 <allocproc>
80104489:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010448c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104490:	75 0a                	jne    8010449c <fork+0x29>
    return -1;
80104492:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104497:	e9 35 01 00 00       	jmp    801045d1 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010449c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010449f:	8b 10                	mov    (%eax),%edx
801044a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044a4:	8b 40 04             	mov    0x4(%eax),%eax
801044a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ab:	89 04 24             	mov    %eax,(%esp)
801044ae:	e8 71 3a 00 00       	call   80107f24 <copyuvm>
801044b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801044b6:	89 42 04             	mov    %eax,0x4(%edx)
801044b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044bc:	8b 40 04             	mov    0x4(%eax),%eax
801044bf:	85 c0                	test   %eax,%eax
801044c1:	75 2c                	jne    801044ef <fork+0x7c>
    kfree(np->kstack);
801044c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044c6:	8b 40 08             	mov    0x8(%eax),%eax
801044c9:	89 04 24             	mov    %eax,(%esp)
801044cc:	e8 50 e6 ff ff       	call   80102b21 <kfree>
    np->kstack = 0;
801044d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801044db:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ea:	e9 e2 00 00 00       	jmp    801045d1 <fork+0x15e>
  }
  np->sz = curproc->sz;
801044ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f2:	8b 10                	mov    (%eax),%edx
801044f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044f7:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801044f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044ff:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104502:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104505:	8b 50 18             	mov    0x18(%eax),%edx
80104508:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010450b:	8b 40 18             	mov    0x18(%eax),%eax
8010450e:	89 c3                	mov    %eax,%ebx
80104510:	b8 13 00 00 00       	mov    $0x13,%eax
80104515:	89 d7                	mov    %edx,%edi
80104517:	89 de                	mov    %ebx,%esi
80104519:	89 c1                	mov    %eax,%ecx
8010451b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010451d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104520:	8b 40 18             	mov    0x18(%eax),%eax
80104523:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010452a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104531:	eb 36                	jmp    80104569 <fork+0xf6>
    if(curproc->ofile[i])
80104533:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104536:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104539:	83 c2 08             	add    $0x8,%edx
8010453c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104540:	85 c0                	test   %eax,%eax
80104542:	74 22                	je     80104566 <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104544:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104547:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010454a:	83 c2 08             	add    $0x8,%edx
8010454d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104551:	89 04 24             	mov    %eax,(%esp)
80104554:	e8 cb ca ff ff       	call   80101024 <filedup>
80104559:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010455c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010455f:	83 c1 08             	add    $0x8,%ecx
80104562:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104566:	ff 45 e4             	incl   -0x1c(%ebp)
80104569:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010456d:	7e c4                	jle    80104533 <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010456f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104572:	8b 40 68             	mov    0x68(%eax),%eax
80104575:	89 04 24             	mov    %eax,(%esp)
80104578:	e8 d7 d3 ff ff       	call   80101954 <idup>
8010457d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104580:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104583:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104586:	8d 50 6c             	lea    0x6c(%eax),%edx
80104589:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010458c:	83 c0 6c             	add    $0x6c,%eax
8010458f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104596:	00 
80104597:	89 54 24 04          	mov    %edx,0x4(%esp)
8010459b:	89 04 24             	mov    %eax,(%esp)
8010459e:	e8 53 0c 00 00       	call   801051f6 <safestrcpy>

  pid = np->pid;
801045a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045a6:	8b 40 10             	mov    0x10(%eax),%eax
801045a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
801045ac:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801045b3:	e8 cf 07 00 00       	call   80104d87 <acquire>

  np->state = RUNNABLE;
801045b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045bb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801045c2:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801045c9:	e8 23 08 00 00       	call   80104df1 <release>

  return pid;
801045ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
801045d1:	83 c4 2c             	add    $0x2c,%esp
801045d4:	5b                   	pop    %ebx
801045d5:	5e                   	pop    %esi
801045d6:	5f                   	pop    %edi
801045d7:	5d                   	pop    %ebp
801045d8:	c3                   	ret    

801045d9 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801045d9:	55                   	push   %ebp
801045da:	89 e5                	mov    %esp,%ebp
801045dc:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
801045df:	e8 93 fb ff ff       	call   80104177 <myproc>
801045e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
801045e7:	a1 20 b6 10 80       	mov    0x8010b620,%eax
801045ec:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801045ef:	75 0c                	jne    801045fd <exit+0x24>
    panic("init exiting");
801045f1:	c7 04 24 ea 84 10 80 	movl   $0x801084ea,(%esp)
801045f8:	e8 57 bf ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104604:	eb 3a                	jmp    80104640 <exit+0x67>
    if(curproc->ofile[fd]){
80104606:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104609:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010460c:	83 c2 08             	add    $0x8,%edx
8010460f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104613:	85 c0                	test   %eax,%eax
80104615:	74 26                	je     8010463d <exit+0x64>
      fileclose(curproc->ofile[fd]);
80104617:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010461a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010461d:	83 c2 08             	add    $0x8,%edx
80104620:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104624:	89 04 24             	mov    %eax,(%esp)
80104627:	e8 40 ca ff ff       	call   8010106c <fileclose>
      curproc->ofile[fd] = 0;
8010462c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010462f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104632:	83 c2 08             	add    $0x8,%edx
80104635:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010463c:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010463d:	ff 45 f0             	incl   -0x10(%ebp)
80104640:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104644:	7e c0                	jle    80104606 <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80104646:	e8 34 ee ff ff       	call   8010347f <begin_op>
  iput(curproc->cwd);
8010464b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010464e:	8b 40 68             	mov    0x68(%eax),%eax
80104651:	89 04 24             	mov    %eax,(%esp)
80104654:	e8 7b d4 ff ff       	call   80101ad4 <iput>
  end_op();
80104659:	e8 a3 ee ff ff       	call   80103501 <end_op>
  curproc->cwd = 0;
8010465e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104661:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104668:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010466f:	e8 13 07 00 00       	call   80104d87 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104674:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104677:	8b 40 14             	mov    0x14(%eax),%eax
8010467a:	89 04 24             	mov    %eax,(%esp)
8010467d:	e8 cc 03 00 00       	call   80104a4e <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104682:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104689:	eb 33                	jmp    801046be <exit+0xe5>
    if(p->parent == curproc){
8010468b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468e:	8b 40 14             	mov    0x14(%eax),%eax
80104691:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104694:	75 24                	jne    801046ba <exit+0xe1>
      p->parent = initproc;
80104696:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
8010469c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469f:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a5:	8b 40 0c             	mov    0xc(%eax),%eax
801046a8:	83 f8 05             	cmp    $0x5,%eax
801046ab:	75 0d                	jne    801046ba <exit+0xe1>
        wakeup1(initproc);
801046ad:	a1 20 b6 10 80       	mov    0x8010b620,%eax
801046b2:	89 04 24             	mov    %eax,(%esp)
801046b5:	e8 94 03 00 00       	call   80104a4e <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ba:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801046be:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801046c5:	72 c4                	jb     8010468b <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801046c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ca:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046d1:	e8 c3 01 00 00       	call   80104899 <sched>
  panic("zombie exit");
801046d6:	c7 04 24 f7 84 10 80 	movl   $0x801084f7,(%esp)
801046dd:	e8 72 be ff ff       	call   80100554 <panic>

801046e2 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046e2:	55                   	push   %ebp
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801046e8:	e8 8a fa ff ff       	call   80104177 <myproc>
801046ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801046f0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801046f7:	e8 8b 06 00 00       	call   80104d87 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104703:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
8010470a:	e9 95 00 00 00       	jmp    801047a4 <wait+0xc2>
      if(p->parent != curproc)
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	8b 40 14             	mov    0x14(%eax),%eax
80104715:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104718:	74 05                	je     8010471f <wait+0x3d>
        continue;
8010471a:	e9 81 00 00 00       	jmp    801047a0 <wait+0xbe>
      havekids = 1;
8010471f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104729:	8b 40 0c             	mov    0xc(%eax),%eax
8010472c:	83 f8 05             	cmp    $0x5,%eax
8010472f:	75 6f                	jne    801047a0 <wait+0xbe>
        // Found one.
        pid = p->pid;
80104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104734:	8b 40 10             	mov    0x10(%eax),%eax
80104737:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010473a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473d:	8b 40 08             	mov    0x8(%eax),%eax
80104740:	89 04 24             	mov    %eax,(%esp)
80104743:	e8 d9 e3 ff ff       	call   80102b21 <kfree>
        p->kstack = 0;
80104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104755:	8b 40 04             	mov    0x4(%eax),%eax
80104758:	89 04 24             	mov    %eax,(%esp)
8010475b:	e8 e8 36 00 00       	call   80107e48 <freevm>
        p->pid = 0;
80104760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104763:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104777:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010477b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477e:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104788:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010478f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104796:	e8 56 06 00 00       	call   80104df1 <release>
        return pid;
8010479b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010479e:	eb 4c                	jmp    801047ec <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a0:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801047a4:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801047ab:	0f 82 5e ff ff ff    	jb     8010470f <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801047b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047b5:	74 0a                	je     801047c1 <wait+0xdf>
801047b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ba:	8b 40 24             	mov    0x24(%eax),%eax
801047bd:	85 c0                	test   %eax,%eax
801047bf:	74 13                	je     801047d4 <wait+0xf2>
      release(&ptable.lock);
801047c1:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801047c8:	e8 24 06 00 00       	call   80104df1 <release>
      return -1;
801047cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d2:	eb 18                	jmp    801047ec <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801047d4:	c7 44 24 04 a0 3d 11 	movl   $0x80113da0,0x4(%esp)
801047db:	80 
801047dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047df:	89 04 24             	mov    %eax,(%esp)
801047e2:	e8 d1 01 00 00       	call   801049b8 <sleep>
  }
801047e7:	e9 10 ff ff ff       	jmp    801046fc <wait+0x1a>
}
801047ec:	c9                   	leave  
801047ed:	c3                   	ret    

801047ee <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047ee:	55                   	push   %ebp
801047ef:	89 e5                	mov    %esp,%ebp
801047f1:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801047f4:	e8 fa f8 ff ff       	call   801040f3 <mycpu>
801047f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801047fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047ff:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104806:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104809:	e8 7e f8 ff ff       	call   8010408c <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010480e:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104815:	e8 6d 05 00 00       	call   80104d87 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010481a:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104821:	eb 5c                	jmp    8010487f <scheduler+0x91>
      if(p->state != RUNNABLE)
80104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104826:	8b 40 0c             	mov    0xc(%eax),%eax
80104829:	83 f8 03             	cmp    $0x3,%eax
8010482c:	74 02                	je     80104830 <scheduler+0x42>
        continue;
8010482e:	eb 4b                	jmp    8010487b <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104830:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104833:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104836:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
8010483c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483f:	89 04 24             	mov    %eax,(%esp)
80104842:	e8 35 31 00 00       	call   8010797c <switchuvm>
      p->state = RUNNING;
80104847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484a:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104854:	8b 40 1c             	mov    0x1c(%eax),%eax
80104857:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010485a:	83 c2 04             	add    $0x4,%edx
8010485d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104861:	89 14 24             	mov    %edx,(%esp)
80104864:	e8 fb 09 00 00       	call   80105264 <swtch>
      switchkvm();
80104869:	e8 f4 30 00 00       	call   80107962 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010486e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104871:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104878:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010487f:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104886:	72 9b                	jb     80104823 <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104888:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010488f:	e8 5d 05 00 00       	call   80104df1 <release>

  }
80104894:	e9 70 ff ff ff       	jmp    80104809 <scheduler+0x1b>

80104899 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104899:	55                   	push   %ebp
8010489a:	89 e5                	mov    %esp,%ebp
8010489c:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
8010489f:	e8 d3 f8 ff ff       	call   80104177 <myproc>
801048a4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
801048a7:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801048ae:	e8 02 06 00 00       	call   80104eb5 <holding>
801048b3:	85 c0                	test   %eax,%eax
801048b5:	75 0c                	jne    801048c3 <sched+0x2a>
    panic("sched ptable.lock");
801048b7:	c7 04 24 03 85 10 80 	movl   $0x80108503,(%esp)
801048be:	e8 91 bc ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
801048c3:	e8 2b f8 ff ff       	call   801040f3 <mycpu>
801048c8:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048ce:	83 f8 01             	cmp    $0x1,%eax
801048d1:	74 0c                	je     801048df <sched+0x46>
    panic("sched locks");
801048d3:	c7 04 24 15 85 10 80 	movl   $0x80108515,(%esp)
801048da:	e8 75 bc ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
801048df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e2:	8b 40 0c             	mov    0xc(%eax),%eax
801048e5:	83 f8 04             	cmp    $0x4,%eax
801048e8:	75 0c                	jne    801048f6 <sched+0x5d>
    panic("sched running");
801048ea:	c7 04 24 21 85 10 80 	movl   $0x80108521,(%esp)
801048f1:	e8 5e bc ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
801048f6:	e8 81 f7 ff ff       	call   8010407c <readeflags>
801048fb:	25 00 02 00 00       	and    $0x200,%eax
80104900:	85 c0                	test   %eax,%eax
80104902:	74 0c                	je     80104910 <sched+0x77>
    panic("sched interruptible");
80104904:	c7 04 24 2f 85 10 80 	movl   $0x8010852f,(%esp)
8010490b:	e8 44 bc ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
80104910:	e8 de f7 ff ff       	call   801040f3 <mycpu>
80104915:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010491b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
8010491e:	e8 d0 f7 ff ff       	call   801040f3 <mycpu>
80104923:	8b 40 04             	mov    0x4(%eax),%eax
80104926:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104929:	83 c2 1c             	add    $0x1c,%edx
8010492c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104930:	89 14 24             	mov    %edx,(%esp)
80104933:	e8 2c 09 00 00       	call   80105264 <swtch>
  mycpu()->intena = intena;
80104938:	e8 b6 f7 ff ff       	call   801040f3 <mycpu>
8010493d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104940:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104946:	c9                   	leave  
80104947:	c3                   	ret    

80104948 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104948:	55                   	push   %ebp
80104949:	89 e5                	mov    %esp,%ebp
8010494b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010494e:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104955:	e8 2d 04 00 00       	call   80104d87 <acquire>
  myproc()->state = RUNNABLE;
8010495a:	e8 18 f8 ff ff       	call   80104177 <myproc>
8010495f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104966:	e8 2e ff ff ff       	call   80104899 <sched>
  release(&ptable.lock);
8010496b:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104972:	e8 7a 04 00 00       	call   80104df1 <release>
}
80104977:	c9                   	leave  
80104978:	c3                   	ret    

80104979 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104979:	55                   	push   %ebp
8010497a:	89 e5                	mov    %esp,%ebp
8010497c:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010497f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104986:	e8 66 04 00 00       	call   80104df1 <release>

  if (first) {
8010498b:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104990:	85 c0                	test   %eax,%eax
80104992:	74 22                	je     801049b6 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104994:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
8010499b:	00 00 00 
    iinit(ROOTDEV);
8010499e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049a5:	e8 75 cc ff ff       	call   8010161f <iinit>
    initlog(ROOTDEV);
801049aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049b1:	e8 ca e8 ff ff       	call   80103280 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801049b6:	c9                   	leave  
801049b7:	c3                   	ret    

801049b8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801049b8:	55                   	push   %ebp
801049b9:	89 e5                	mov    %esp,%ebp
801049bb:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
801049be:	e8 b4 f7 ff ff       	call   80104177 <myproc>
801049c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801049c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049ca:	75 0c                	jne    801049d8 <sleep+0x20>
    panic("sleep");
801049cc:	c7 04 24 43 85 10 80 	movl   $0x80108543,(%esp)
801049d3:	e8 7c bb ff ff       	call   80100554 <panic>

  if(lk == 0)
801049d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801049dc:	75 0c                	jne    801049ea <sleep+0x32>
    panic("sleep without lk");
801049de:	c7 04 24 49 85 10 80 	movl   $0x80108549,(%esp)
801049e5:	e8 6a bb ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049ea:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
801049f1:	74 17                	je     80104a0a <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049f3:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801049fa:	e8 88 03 00 00       	call   80104d87 <acquire>
    release(lk);
801049ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a02:	89 04 24             	mov    %eax,(%esp)
80104a05:	e8 e7 03 00 00       	call   80104df1 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a10:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a16:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104a1d:	e8 77 fe ff ff       	call   80104899 <sched>

  // Tidy up.
  p->chan = 0;
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a2c:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104a33:	74 17                	je     80104a4c <sleep+0x94>
    release(&ptable.lock);
80104a35:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a3c:	e8 b0 03 00 00       	call   80104df1 <release>
    acquire(lk);
80104a41:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a44:	89 04 24             	mov    %eax,(%esp)
80104a47:	e8 3b 03 00 00       	call   80104d87 <acquire>
  }
}
80104a4c:	c9                   	leave  
80104a4d:	c3                   	ret    

80104a4e <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a4e:	55                   	push   %ebp
80104a4f:	89 e5                	mov    %esp,%ebp
80104a51:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a54:	c7 45 fc d4 3d 11 80 	movl   $0x80113dd4,-0x4(%ebp)
80104a5b:	eb 24                	jmp    80104a81 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a60:	8b 40 0c             	mov    0xc(%eax),%eax
80104a63:	83 f8 02             	cmp    $0x2,%eax
80104a66:	75 15                	jne    80104a7d <wakeup1+0x2f>
80104a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a6b:	8b 40 20             	mov    0x20(%eax),%eax
80104a6e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a71:	75 0a                	jne    80104a7d <wakeup1+0x2f>
      p->state = RUNNABLE;
80104a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a76:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a7d:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104a81:	81 7d fc d4 5c 11 80 	cmpl   $0x80115cd4,-0x4(%ebp)
80104a88:	72 d3                	jb     80104a5d <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104a8a:	c9                   	leave  
80104a8b:	c3                   	ret    

80104a8c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a8c:	55                   	push   %ebp
80104a8d:	89 e5                	mov    %esp,%ebp
80104a8f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104a92:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a99:	e8 e9 02 00 00       	call   80104d87 <acquire>
  wakeup1(chan);
80104a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa1:	89 04 24             	mov    %eax,(%esp)
80104aa4:	e8 a5 ff ff ff       	call   80104a4e <wakeup1>
  release(&ptable.lock);
80104aa9:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104ab0:	e8 3c 03 00 00       	call   80104df1 <release>
}
80104ab5:	c9                   	leave  
80104ab6:	c3                   	ret    

80104ab7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ab7:	55                   	push   %ebp
80104ab8:	89 e5                	mov    %esp,%ebp
80104aba:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104abd:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104ac4:	e8 be 02 00 00       	call   80104d87 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac9:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104ad0:	eb 41                	jmp    80104b13 <kill+0x5c>
    if(p->pid == pid){
80104ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad5:	8b 40 10             	mov    0x10(%eax),%eax
80104ad8:	3b 45 08             	cmp    0x8(%ebp),%eax
80104adb:	75 32                	jne    80104b0f <kill+0x58>
      p->killed = 1;
80104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aea:	8b 40 0c             	mov    0xc(%eax),%eax
80104aed:	83 f8 02             	cmp    $0x2,%eax
80104af0:	75 0a                	jne    80104afc <kill+0x45>
        p->state = RUNNABLE;
80104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104afc:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104b03:	e8 e9 02 00 00       	call   80104df1 <release>
      return 0;
80104b08:	b8 00 00 00 00       	mov    $0x0,%eax
80104b0d:	eb 1e                	jmp    80104b2d <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b13:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104b1a:	72 b6                	jb     80104ad2 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104b1c:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104b23:	e8 c9 02 00 00       	call   80104df1 <release>
  return -1;
80104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    

80104b2f <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b2f:	55                   	push   %ebp
80104b30:	89 e5                	mov    %esp,%ebp
80104b32:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b35:	c7 45 f0 d4 3d 11 80 	movl   $0x80113dd4,-0x10(%ebp)
80104b3c:	e9 d5 00 00 00       	jmp    80104c16 <procdump+0xe7>
    if(p->state == UNUSED)
80104b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b44:	8b 40 0c             	mov    0xc(%eax),%eax
80104b47:	85 c0                	test   %eax,%eax
80104b49:	75 05                	jne    80104b50 <procdump+0x21>
      continue;
80104b4b:	e9 c2 00 00 00       	jmp    80104c12 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b53:	8b 40 0c             	mov    0xc(%eax),%eax
80104b56:	83 f8 05             	cmp    $0x5,%eax
80104b59:	77 23                	ja     80104b7e <procdump+0x4f>
80104b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b61:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	74 12                	je     80104b7e <procdump+0x4f>
      state = states[p->state];
80104b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6f:	8b 40 0c             	mov    0xc(%eax),%eax
80104b72:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104b7c:	eb 07                	jmp    80104b85 <procdump+0x56>
    else
      state = "???";
80104b7e:	c7 45 ec 5a 85 10 80 	movl   $0x8010855a,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b88:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b8e:	8b 40 10             	mov    0x10(%eax),%eax
80104b91:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104b95:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b98:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba0:	c7 04 24 5e 85 10 80 	movl   $0x8010855e,(%esp)
80104ba7:	e8 15 b8 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80104bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104baf:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb2:	83 f8 02             	cmp    $0x2,%eax
80104bb5:	75 4f                	jne    80104c06 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bba:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bbd:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc0:	83 c0 08             	add    $0x8,%eax
80104bc3:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104bc6:	89 54 24 04          	mov    %edx,0x4(%esp)
80104bca:	89 04 24             	mov    %eax,(%esp)
80104bcd:	e8 6c 02 00 00       	call   80104e3e <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104bd9:	eb 1a                	jmp    80104bf5 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bde:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104be2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be6:	c7 04 24 67 85 10 80 	movl   $0x80108567,(%esp)
80104bed:	e8 cf b7 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104bf2:	ff 45 f4             	incl   -0xc(%ebp)
80104bf5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104bf9:	7f 0b                	jg     80104c06 <procdump+0xd7>
80104bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfe:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c02:	85 c0                	test   %eax,%eax
80104c04:	75 d5                	jne    80104bdb <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c06:	c7 04 24 6b 85 10 80 	movl   $0x8010856b,(%esp)
80104c0d:	e8 af b7 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c12:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104c16:	81 7d f0 d4 5c 11 80 	cmpl   $0x80115cd4,-0x10(%ebp)
80104c1d:	0f 82 1e ff ff ff    	jb     80104b41 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104c23:	c9                   	leave  
80104c24:	c3                   	ret    
80104c25:	00 00                	add    %al,(%eax)
	...

80104c28 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c28:	55                   	push   %ebp
80104c29:	89 e5                	mov    %esp,%ebp
80104c2b:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104c31:	83 c0 04             	add    $0x4,%eax
80104c34:	c7 44 24 04 97 85 10 	movl   $0x80108597,0x4(%esp)
80104c3b:	80 
80104c3c:	89 04 24             	mov    %eax,(%esp)
80104c3f:	e8 22 01 00 00       	call   80104d66 <initlock>
  lk->name = name;
80104c44:	8b 45 08             	mov    0x8(%ebp),%eax
80104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c4a:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104c56:	8b 45 08             	mov    0x8(%ebp),%eax
80104c59:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104c60:	c9                   	leave  
80104c61:	c3                   	ret    

80104c62 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c62:	55                   	push   %ebp
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104c68:	8b 45 08             	mov    0x8(%ebp),%eax
80104c6b:	83 c0 04             	add    $0x4,%eax
80104c6e:	89 04 24             	mov    %eax,(%esp)
80104c71:	e8 11 01 00 00       	call   80104d87 <acquire>
  while (lk->locked) {
80104c76:	eb 15                	jmp    80104c8d <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104c78:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7b:	83 c0 04             	add    $0x4,%eax
80104c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c82:	8b 45 08             	mov    0x8(%ebp),%eax
80104c85:	89 04 24             	mov    %eax,(%esp)
80104c88:	e8 2b fd ff ff       	call   801049b8 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c90:	8b 00                	mov    (%eax),%eax
80104c92:	85 c0                	test   %eax,%eax
80104c94:	75 e2                	jne    80104c78 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104c96:	8b 45 08             	mov    0x8(%ebp),%eax
80104c99:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104c9f:	e8 d3 f4 ff ff       	call   80104177 <myproc>
80104ca4:	8b 50 10             	mov    0x10(%eax),%edx
80104ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80104caa:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104cad:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb0:	83 c0 04             	add    $0x4,%eax
80104cb3:	89 04 24             	mov    %eax,(%esp)
80104cb6:	e8 36 01 00 00       	call   80104df1 <release>
}
80104cbb:	c9                   	leave  
80104cbc:	c3                   	ret    

80104cbd <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cbd:	55                   	push   %ebp
80104cbe:	89 e5                	mov    %esp,%ebp
80104cc0:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc6:	83 c0 04             	add    $0x4,%eax
80104cc9:	89 04 24             	mov    %eax,(%esp)
80104ccc:	e8 b6 00 00 00       	call   80104d87 <acquire>
  lk->locked = 0;
80104cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104cda:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdd:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce7:	89 04 24             	mov    %eax,(%esp)
80104cea:	e8 9d fd ff ff       	call   80104a8c <wakeup>
  release(&lk->lk);
80104cef:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf2:	83 c0 04             	add    $0x4,%eax
80104cf5:	89 04 24             	mov    %eax,(%esp)
80104cf8:	e8 f4 00 00 00       	call   80104df1 <release>
}
80104cfd:	c9                   	leave  
80104cfe:	c3                   	ret    

80104cff <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104cff:	55                   	push   %ebp
80104d00:	89 e5                	mov    %esp,%ebp
80104d02:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104d05:	8b 45 08             	mov    0x8(%ebp),%eax
80104d08:	83 c0 04             	add    $0x4,%eax
80104d0b:	89 04 24             	mov    %eax,(%esp)
80104d0e:	e8 74 00 00 00       	call   80104d87 <acquire>
  r = lk->locked;
80104d13:	8b 45 08             	mov    0x8(%ebp),%eax
80104d16:	8b 00                	mov    (%eax),%eax
80104d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1e:	83 c0 04             	add    $0x4,%eax
80104d21:	89 04 24             	mov    %eax,(%esp)
80104d24:	e8 c8 00 00 00       	call   80104df1 <release>
  return r;
80104d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    
	...

80104d30 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d36:	9c                   	pushf  
80104d37:	58                   	pop    %eax
80104d38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d3e:	c9                   	leave  
80104d3f:	c3                   	ret    

80104d40 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104d43:	fa                   	cli    
}
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    

80104d46 <sti>:

static inline void
sti(void)
{
80104d46:	55                   	push   %ebp
80104d47:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104d49:	fb                   	sti    
}
80104d4a:	5d                   	pop    %ebp
80104d4b:	c3                   	ret    

80104d4c <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104d4c:	55                   	push   %ebp
80104d4d:	89 e5                	mov    %esp,%ebp
80104d4f:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104d52:	8b 55 08             	mov    0x8(%ebp),%edx
80104d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d5b:	f0 87 02             	lock xchg %eax,(%edx)
80104d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d64:	c9                   	leave  
80104d65:	c3                   	ret    

80104d66 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d66:	55                   	push   %ebp
80104d67:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104d69:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104d72:	8b 45 08             	mov    0x8(%ebp),%eax
80104d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    

80104d87 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104d87:	55                   	push   %ebp
80104d88:	89 e5                	mov    %esp,%ebp
80104d8a:	53                   	push   %ebx
80104d8b:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d8e:	e8 53 01 00 00       	call   80104ee6 <pushcli>
  if(holding(lk))
80104d93:	8b 45 08             	mov    0x8(%ebp),%eax
80104d96:	89 04 24             	mov    %eax,(%esp)
80104d99:	e8 17 01 00 00       	call   80104eb5 <holding>
80104d9e:	85 c0                	test   %eax,%eax
80104da0:	74 0c                	je     80104dae <acquire+0x27>
    panic("acquire");
80104da2:	c7 04 24 a2 85 10 80 	movl   $0x801085a2,(%esp)
80104da9:	e8 a6 b7 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104dae:	90                   	nop
80104daf:	8b 45 08             	mov    0x8(%ebp),%eax
80104db2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104db9:	00 
80104dba:	89 04 24             	mov    %eax,(%esp)
80104dbd:	e8 8a ff ff ff       	call   80104d4c <xchg>
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	75 e9                	jne    80104daf <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104dc6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104dcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dce:	e8 20 f3 ff ff       	call   801040f3 <mycpu>
80104dd3:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd9:	83 c0 0c             	add    $0xc,%eax
80104ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104de0:	8d 45 08             	lea    0x8(%ebp),%eax
80104de3:	89 04 24             	mov    %eax,(%esp)
80104de6:	e8 53 00 00 00       	call   80104e3e <getcallerpcs>
}
80104deb:	83 c4 14             	add    $0x14,%esp
80104dee:	5b                   	pop    %ebx
80104def:	5d                   	pop    %ebp
80104df0:	c3                   	ret    

80104df1 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104df1:	55                   	push   %ebp
80104df2:	89 e5                	mov    %esp,%ebp
80104df4:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104df7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfa:	89 04 24             	mov    %eax,(%esp)
80104dfd:	e8 b3 00 00 00       	call   80104eb5 <holding>
80104e02:	85 c0                	test   %eax,%eax
80104e04:	75 0c                	jne    80104e12 <release+0x21>
    panic("release");
80104e06:	c7 04 24 aa 85 10 80 	movl   $0x801085aa,(%esp)
80104e0d:	e8 42 b7 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
80104e12:	8b 45 08             	mov    0x8(%ebp),%eax
80104e15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104e26:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104e31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104e37:	e8 f4 00 00 00       	call   80104f30 <popcli>
}
80104e3c:	c9                   	leave  
80104e3d:	c3                   	ret    

80104e3e <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e3e:	55                   	push   %ebp
80104e3f:	89 e5                	mov    %esp,%ebp
80104e41:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104e44:	8b 45 08             	mov    0x8(%ebp),%eax
80104e47:	83 e8 08             	sub    $0x8,%eax
80104e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104e54:	eb 37                	jmp    80104e8d <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e56:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104e5a:	74 37                	je     80104e93 <getcallerpcs+0x55>
80104e5c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104e63:	76 2e                	jbe    80104e93 <getcallerpcs+0x55>
80104e65:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104e69:	74 28                	je     80104e93 <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e75:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e78:	01 c2                	add    %eax,%edx
80104e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e7d:	8b 40 04             	mov    0x4(%eax),%eax
80104e80:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e85:	8b 00                	mov    (%eax),%eax
80104e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e8a:	ff 45 f8             	incl   -0x8(%ebp)
80104e8d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104e91:	7e c3                	jle    80104e56 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104e93:	eb 18                	jmp    80104ead <getcallerpcs+0x6f>
    pcs[i] = 0;
80104e95:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ea2:	01 d0                	add    %edx,%eax
80104ea4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104eaa:	ff 45 f8             	incl   -0x8(%ebp)
80104ead:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104eb1:	7e e2                	jle    80104e95 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80104eb3:	c9                   	leave  
80104eb4:	c3                   	ret    

80104eb5 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104eb5:	55                   	push   %ebp
80104eb6:	89 e5                	mov    %esp,%ebp
80104eb8:	53                   	push   %ebx
80104eb9:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebf:	8b 00                	mov    (%eax),%eax
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	74 16                	je     80104edb <holding+0x26>
80104ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec8:	8b 58 08             	mov    0x8(%eax),%ebx
80104ecb:	e8 23 f2 ff ff       	call   801040f3 <mycpu>
80104ed0:	39 c3                	cmp    %eax,%ebx
80104ed2:	75 07                	jne    80104edb <holding+0x26>
80104ed4:	b8 01 00 00 00       	mov    $0x1,%eax
80104ed9:	eb 05                	jmp    80104ee0 <holding+0x2b>
80104edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ee0:	83 c4 04             	add    $0x4,%esp
80104ee3:	5b                   	pop    %ebx
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    

80104ee6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ee6:	55                   	push   %ebp
80104ee7:	89 e5                	mov    %esp,%ebp
80104ee9:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104eec:	e8 3f fe ff ff       	call   80104d30 <readeflags>
80104ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104ef4:	e8 47 fe ff ff       	call   80104d40 <cli>
  if(mycpu()->ncli == 0)
80104ef9:	e8 f5 f1 ff ff       	call   801040f3 <mycpu>
80104efe:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f04:	85 c0                	test   %eax,%eax
80104f06:	75 14                	jne    80104f1c <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104f08:	e8 e6 f1 ff ff       	call   801040f3 <mycpu>
80104f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f10:	81 e2 00 02 00 00    	and    $0x200,%edx
80104f16:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104f1c:	e8 d2 f1 ff ff       	call   801040f3 <mycpu>
80104f21:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f27:	42                   	inc    %edx
80104f28:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104f2e:	c9                   	leave  
80104f2f:	c3                   	ret    

80104f30 <popcli>:

void
popcli(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104f36:	e8 f5 fd ff ff       	call   80104d30 <readeflags>
80104f3b:	25 00 02 00 00       	and    $0x200,%eax
80104f40:	85 c0                	test   %eax,%eax
80104f42:	74 0c                	je     80104f50 <popcli+0x20>
    panic("popcli - interruptible");
80104f44:	c7 04 24 b2 85 10 80 	movl   $0x801085b2,(%esp)
80104f4b:	e8 04 b6 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
80104f50:	e8 9e f1 ff ff       	call   801040f3 <mycpu>
80104f55:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f5b:	4a                   	dec    %edx
80104f5c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104f62:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	79 0c                	jns    80104f78 <popcli+0x48>
    panic("popcli");
80104f6c:	c7 04 24 c9 85 10 80 	movl   $0x801085c9,(%esp)
80104f73:	e8 dc b5 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f78:	e8 76 f1 ff ff       	call   801040f3 <mycpu>
80104f7d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f83:	85 c0                	test   %eax,%eax
80104f85:	75 14                	jne    80104f9b <popcli+0x6b>
80104f87:	e8 67 f1 ff ff       	call   801040f3 <mycpu>
80104f8c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f92:	85 c0                	test   %eax,%eax
80104f94:	74 05                	je     80104f9b <popcli+0x6b>
    sti();
80104f96:	e8 ab fd ff ff       	call   80104d46 <sti>
}
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    
80104f9d:	00 00                	add    %al,(%eax)
	...

80104fa0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fa8:	8b 55 10             	mov    0x10(%ebp),%edx
80104fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fae:	89 cb                	mov    %ecx,%ebx
80104fb0:	89 df                	mov    %ebx,%edi
80104fb2:	89 d1                	mov    %edx,%ecx
80104fb4:	fc                   	cld    
80104fb5:	f3 aa                	rep stos %al,%es:(%edi)
80104fb7:	89 ca                	mov    %ecx,%edx
80104fb9:	89 fb                	mov    %edi,%ebx
80104fbb:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104fbe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104fc1:	5b                   	pop    %ebx
80104fc2:	5f                   	pop    %edi
80104fc3:	5d                   	pop    %ebp
80104fc4:	c3                   	ret    

80104fc5 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104fc5:	55                   	push   %ebp
80104fc6:	89 e5                	mov    %esp,%ebp
80104fc8:	57                   	push   %edi
80104fc9:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104fca:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fcd:	8b 55 10             	mov    0x10(%ebp),%edx
80104fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd3:	89 cb                	mov    %ecx,%ebx
80104fd5:	89 df                	mov    %ebx,%edi
80104fd7:	89 d1                	mov    %edx,%ecx
80104fd9:	fc                   	cld    
80104fda:	f3 ab                	rep stos %eax,%es:(%edi)
80104fdc:	89 ca                	mov    %ecx,%edx
80104fde:	89 fb                	mov    %edi,%ebx
80104fe0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104fe3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104fe6:	5b                   	pop    %ebx
80104fe7:	5f                   	pop    %edi
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    

80104fea <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fea:	55                   	push   %ebp
80104feb:	89 e5                	mov    %esp,%ebp
80104fed:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff3:	83 e0 03             	and    $0x3,%eax
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	75 49                	jne    80105043 <memset+0x59>
80104ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80104ffd:	83 e0 03             	and    $0x3,%eax
80105000:	85 c0                	test   %eax,%eax
80105002:	75 3f                	jne    80105043 <memset+0x59>
    c &= 0xFF;
80105004:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010500b:	8b 45 10             	mov    0x10(%ebp),%eax
8010500e:	c1 e8 02             	shr    $0x2,%eax
80105011:	89 c2                	mov    %eax,%edx
80105013:	8b 45 0c             	mov    0xc(%ebp),%eax
80105016:	c1 e0 18             	shl    $0x18,%eax
80105019:	89 c1                	mov    %eax,%ecx
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	c1 e0 10             	shl    $0x10,%eax
80105021:	09 c1                	or     %eax,%ecx
80105023:	8b 45 0c             	mov    0xc(%ebp),%eax
80105026:	c1 e0 08             	shl    $0x8,%eax
80105029:	09 c8                	or     %ecx,%eax
8010502b:	0b 45 0c             	or     0xc(%ebp),%eax
8010502e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105032:	89 44 24 04          	mov    %eax,0x4(%esp)
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
80105039:	89 04 24             	mov    %eax,(%esp)
8010503c:	e8 84 ff ff ff       	call   80104fc5 <stosl>
80105041:	eb 19                	jmp    8010505c <memset+0x72>
  } else
    stosb(dst, c, n);
80105043:	8b 45 10             	mov    0x10(%ebp),%eax
80105046:	89 44 24 08          	mov    %eax,0x8(%esp)
8010504a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105051:	8b 45 08             	mov    0x8(%ebp),%eax
80105054:	89 04 24             	mov    %eax,(%esp)
80105057:	e8 44 ff ff ff       	call   80104fa0 <stosb>
  return dst;
8010505c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010505f:	c9                   	leave  
80105060:	c3                   	ret    

80105061 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105061:	55                   	push   %ebp
80105062:	89 e5                	mov    %esp,%ebp
80105064:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105067:	8b 45 08             	mov    0x8(%ebp),%eax
8010506a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010506d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105070:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105073:	eb 2a                	jmp    8010509f <memcmp+0x3e>
    if(*s1 != *s2)
80105075:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105078:	8a 10                	mov    (%eax),%dl
8010507a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010507d:	8a 00                	mov    (%eax),%al
8010507f:	38 c2                	cmp    %al,%dl
80105081:	74 16                	je     80105099 <memcmp+0x38>
      return *s1 - *s2;
80105083:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105086:	8a 00                	mov    (%eax),%al
80105088:	0f b6 d0             	movzbl %al,%edx
8010508b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010508e:	8a 00                	mov    (%eax),%al
80105090:	0f b6 c0             	movzbl %al,%eax
80105093:	29 c2                	sub    %eax,%edx
80105095:	89 d0                	mov    %edx,%eax
80105097:	eb 18                	jmp    801050b1 <memcmp+0x50>
    s1++, s2++;
80105099:	ff 45 fc             	incl   -0x4(%ebp)
8010509c:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010509f:	8b 45 10             	mov    0x10(%ebp),%eax
801050a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801050a5:	89 55 10             	mov    %edx,0x10(%ebp)
801050a8:	85 c0                	test   %eax,%eax
801050aa:	75 c9                	jne    80105075 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801050ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050b1:	c9                   	leave  
801050b2:	c3                   	ret    

801050b3 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050b3:	55                   	push   %ebp
801050b4:	89 e5                	mov    %esp,%ebp
801050b6:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801050b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801050bf:	8b 45 08             	mov    0x8(%ebp),%eax
801050c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801050c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050cb:	73 3a                	jae    80105107 <memmove+0x54>
801050cd:	8b 45 10             	mov    0x10(%ebp),%eax
801050d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050d3:	01 d0                	add    %edx,%eax
801050d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050d8:	76 2d                	jbe    80105107 <memmove+0x54>
    s += n;
801050da:	8b 45 10             	mov    0x10(%ebp),%eax
801050dd:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801050e0:	8b 45 10             	mov    0x10(%ebp),%eax
801050e3:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801050e6:	eb 10                	jmp    801050f8 <memmove+0x45>
      *--d = *--s;
801050e8:	ff 4d f8             	decl   -0x8(%ebp)
801050eb:	ff 4d fc             	decl   -0x4(%ebp)
801050ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f1:	8a 10                	mov    (%eax),%dl
801050f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050f6:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801050f8:	8b 45 10             	mov    0x10(%ebp),%eax
801050fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801050fe:	89 55 10             	mov    %edx,0x10(%ebp)
80105101:	85 c0                	test   %eax,%eax
80105103:	75 e3                	jne    801050e8 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105105:	eb 25                	jmp    8010512c <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105107:	eb 16                	jmp    8010511f <memmove+0x6c>
      *d++ = *s++;
80105109:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010510c:	8d 50 01             	lea    0x1(%eax),%edx
8010510f:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105112:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105115:	8d 4a 01             	lea    0x1(%edx),%ecx
80105118:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010511b:	8a 12                	mov    (%edx),%dl
8010511d:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010511f:	8b 45 10             	mov    0x10(%ebp),%eax
80105122:	8d 50 ff             	lea    -0x1(%eax),%edx
80105125:	89 55 10             	mov    %edx,0x10(%ebp)
80105128:	85 c0                	test   %eax,%eax
8010512a:	75 dd                	jne    80105109 <memmove+0x56>
      *d++ = *s++;

  return dst;
8010512c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010512f:	c9                   	leave  
80105130:	c3                   	ret    

80105131 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105131:	55                   	push   %ebp
80105132:	89 e5                	mov    %esp,%ebp
80105134:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105137:	8b 45 10             	mov    0x10(%ebp),%eax
8010513a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010513e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105141:	89 44 24 04          	mov    %eax,0x4(%esp)
80105145:	8b 45 08             	mov    0x8(%ebp),%eax
80105148:	89 04 24             	mov    %eax,(%esp)
8010514b:	e8 63 ff ff ff       	call   801050b3 <memmove>
}
80105150:	c9                   	leave  
80105151:	c3                   	ret    

80105152 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105152:	55                   	push   %ebp
80105153:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105155:	eb 09                	jmp    80105160 <strncmp+0xe>
    n--, p++, q++;
80105157:	ff 4d 10             	decl   0x10(%ebp)
8010515a:	ff 45 08             	incl   0x8(%ebp)
8010515d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105160:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105164:	74 17                	je     8010517d <strncmp+0x2b>
80105166:	8b 45 08             	mov    0x8(%ebp),%eax
80105169:	8a 00                	mov    (%eax),%al
8010516b:	84 c0                	test   %al,%al
8010516d:	74 0e                	je     8010517d <strncmp+0x2b>
8010516f:	8b 45 08             	mov    0x8(%ebp),%eax
80105172:	8a 10                	mov    (%eax),%dl
80105174:	8b 45 0c             	mov    0xc(%ebp),%eax
80105177:	8a 00                	mov    (%eax),%al
80105179:	38 c2                	cmp    %al,%dl
8010517b:	74 da                	je     80105157 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010517d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105181:	75 07                	jne    8010518a <strncmp+0x38>
    return 0;
80105183:	b8 00 00 00 00       	mov    $0x0,%eax
80105188:	eb 14                	jmp    8010519e <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
8010518a:	8b 45 08             	mov    0x8(%ebp),%eax
8010518d:	8a 00                	mov    (%eax),%al
8010518f:	0f b6 d0             	movzbl %al,%edx
80105192:	8b 45 0c             	mov    0xc(%ebp),%eax
80105195:	8a 00                	mov    (%eax),%al
80105197:	0f b6 c0             	movzbl %al,%eax
8010519a:	29 c2                	sub    %eax,%edx
8010519c:	89 d0                	mov    %edx,%eax
}
8010519e:	5d                   	pop    %ebp
8010519f:	c3                   	ret    

801051a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801051a6:	8b 45 08             	mov    0x8(%ebp),%eax
801051a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801051ac:	90                   	nop
801051ad:	8b 45 10             	mov    0x10(%ebp),%eax
801051b0:	8d 50 ff             	lea    -0x1(%eax),%edx
801051b3:	89 55 10             	mov    %edx,0x10(%ebp)
801051b6:	85 c0                	test   %eax,%eax
801051b8:	7e 1c                	jle    801051d6 <strncpy+0x36>
801051ba:	8b 45 08             	mov    0x8(%ebp),%eax
801051bd:	8d 50 01             	lea    0x1(%eax),%edx
801051c0:	89 55 08             	mov    %edx,0x8(%ebp)
801051c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801051c6:	8d 4a 01             	lea    0x1(%edx),%ecx
801051c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801051cc:	8a 12                	mov    (%edx),%dl
801051ce:	88 10                	mov    %dl,(%eax)
801051d0:	8a 00                	mov    (%eax),%al
801051d2:	84 c0                	test   %al,%al
801051d4:	75 d7                	jne    801051ad <strncpy+0xd>
    ;
  while(n-- > 0)
801051d6:	eb 0c                	jmp    801051e4 <strncpy+0x44>
    *s++ = 0;
801051d8:	8b 45 08             	mov    0x8(%ebp),%eax
801051db:	8d 50 01             	lea    0x1(%eax),%edx
801051de:	89 55 08             	mov    %edx,0x8(%ebp)
801051e1:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801051e4:	8b 45 10             	mov    0x10(%ebp),%eax
801051e7:	8d 50 ff             	lea    -0x1(%eax),%edx
801051ea:	89 55 10             	mov    %edx,0x10(%ebp)
801051ed:	85 c0                	test   %eax,%eax
801051ef:	7f e7                	jg     801051d8 <strncpy+0x38>
    *s++ = 0;
  return os;
801051f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051f4:	c9                   	leave  
801051f5:	c3                   	ret    

801051f6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051f6:	55                   	push   %ebp
801051f7:	89 e5                	mov    %esp,%ebp
801051f9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801051fc:	8b 45 08             	mov    0x8(%ebp),%eax
801051ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105202:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105206:	7f 05                	jg     8010520d <safestrcpy+0x17>
    return os;
80105208:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010520b:	eb 2e                	jmp    8010523b <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
8010520d:	ff 4d 10             	decl   0x10(%ebp)
80105210:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105214:	7e 1c                	jle    80105232 <safestrcpy+0x3c>
80105216:	8b 45 08             	mov    0x8(%ebp),%eax
80105219:	8d 50 01             	lea    0x1(%eax),%edx
8010521c:	89 55 08             	mov    %edx,0x8(%ebp)
8010521f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105222:	8d 4a 01             	lea    0x1(%edx),%ecx
80105225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105228:	8a 12                	mov    (%edx),%dl
8010522a:	88 10                	mov    %dl,(%eax)
8010522c:	8a 00                	mov    (%eax),%al
8010522e:	84 c0                	test   %al,%al
80105230:	75 db                	jne    8010520d <safestrcpy+0x17>
    ;
  *s = 0;
80105232:	8b 45 08             	mov    0x8(%ebp),%eax
80105235:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010523b:	c9                   	leave  
8010523c:	c3                   	ret    

8010523d <strlen>:

int
strlen(const char *s)
{
8010523d:	55                   	push   %ebp
8010523e:	89 e5                	mov    %esp,%ebp
80105240:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010524a:	eb 03                	jmp    8010524f <strlen+0x12>
8010524c:	ff 45 fc             	incl   -0x4(%ebp)
8010524f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105252:	8b 45 08             	mov    0x8(%ebp),%eax
80105255:	01 d0                	add    %edx,%eax
80105257:	8a 00                	mov    (%eax),%al
80105259:	84 c0                	test   %al,%al
8010525b:	75 ef                	jne    8010524c <strlen+0xf>
    ;
  return n;
8010525d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105260:	c9                   	leave  
80105261:	c3                   	ret    
	...

80105264 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105264:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105268:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010526c:	55                   	push   %ebp
  pushl %ebx
8010526d:	53                   	push   %ebx
  pushl %esi
8010526e:	56                   	push   %esi
  pushl %edi
8010526f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105270:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105272:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105274:	5f                   	pop    %edi
  popl %esi
80105275:	5e                   	pop    %esi
  popl %ebx
80105276:	5b                   	pop    %ebx
  popl %ebp
80105277:	5d                   	pop    %ebp
  ret
80105278:	c3                   	ret    
80105279:	00 00                	add    %al,(%eax)
	...

8010527c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010527c:	55                   	push   %ebp
8010527d:	89 e5                	mov    %esp,%ebp
8010527f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105282:	e8 f0 ee ff ff       	call   80104177 <myproc>
80105287:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010528d:	8b 00                	mov    (%eax),%eax
8010528f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105292:	76 0f                	jbe    801052a3 <fetchint+0x27>
80105294:	8b 45 08             	mov    0x8(%ebp),%eax
80105297:	8d 50 04             	lea    0x4(%eax),%edx
8010529a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010529d:	8b 00                	mov    (%eax),%eax
8010529f:	39 c2                	cmp    %eax,%edx
801052a1:	76 07                	jbe    801052aa <fetchint+0x2e>
    return -1;
801052a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a8:	eb 0f                	jmp    801052b9 <fetchint+0x3d>
  *ip = *(int*)(addr);
801052aa:	8b 45 08             	mov    0x8(%ebp),%eax
801052ad:	8b 10                	mov    (%eax),%edx
801052af:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b2:	89 10                	mov    %edx,(%eax)
  return 0;
801052b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052b9:	c9                   	leave  
801052ba:	c3                   	ret    

801052bb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801052bb:	55                   	push   %ebp
801052bc:	89 e5                	mov    %esp,%ebp
801052be:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801052c1:	e8 b1 ee ff ff       	call   80104177 <myproc>
801052c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801052c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cc:	8b 00                	mov    (%eax),%eax
801052ce:	3b 45 08             	cmp    0x8(%ebp),%eax
801052d1:	77 07                	ja     801052da <fetchstr+0x1f>
    return -1;
801052d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d8:	eb 41                	jmp    8010531b <fetchstr+0x60>
  *pp = (char*)addr;
801052da:	8b 55 08             	mov    0x8(%ebp),%edx
801052dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e0:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801052e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e5:	8b 00                	mov    (%eax),%eax
801052e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801052ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ed:	8b 00                	mov    (%eax),%eax
801052ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801052f2:	eb 1a                	jmp    8010530e <fetchstr+0x53>
    if(*s == 0)
801052f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f7:	8a 00                	mov    (%eax),%al
801052f9:	84 c0                	test   %al,%al
801052fb:	75 0e                	jne    8010530b <fetchstr+0x50>
      return s - *pp;
801052fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105300:	8b 45 0c             	mov    0xc(%ebp),%eax
80105303:	8b 00                	mov    (%eax),%eax
80105305:	29 c2                	sub    %eax,%edx
80105307:	89 d0                	mov    %edx,%eax
80105309:	eb 10                	jmp    8010531b <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010530b:	ff 45 f4             	incl   -0xc(%ebp)
8010530e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105311:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105314:	72 de                	jb     801052f4 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80105316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010531b:	c9                   	leave  
8010531c:	c3                   	ret    

8010531d <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010531d:	55                   	push   %ebp
8010531e:	89 e5                	mov    %esp,%ebp
80105320:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105323:	e8 4f ee ff ff       	call   80104177 <myproc>
80105328:	8b 40 18             	mov    0x18(%eax),%eax
8010532b:	8b 50 44             	mov    0x44(%eax),%edx
8010532e:	8b 45 08             	mov    0x8(%ebp),%eax
80105331:	c1 e0 02             	shl    $0x2,%eax
80105334:	01 d0                	add    %edx,%eax
80105336:	8d 50 04             	lea    0x4(%eax),%edx
80105339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105340:	89 14 24             	mov    %edx,(%esp)
80105343:	e8 34 ff ff ff       	call   8010527c <fetchint>
}
80105348:	c9                   	leave  
80105349:	c3                   	ret    

8010534a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010534a:	55                   	push   %ebp
8010534b:	89 e5                	mov    %esp,%ebp
8010534d:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
80105350:	e8 22 ee ff ff       	call   80104177 <myproc>
80105355:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105358:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010535b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535f:	8b 45 08             	mov    0x8(%ebp),%eax
80105362:	89 04 24             	mov    %eax,(%esp)
80105365:	e8 b3 ff ff ff       	call   8010531d <argint>
8010536a:	85 c0                	test   %eax,%eax
8010536c:	79 07                	jns    80105375 <argptr+0x2b>
    return -1;
8010536e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105373:	eb 3d                	jmp    801053b2 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105375:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105379:	78 21                	js     8010539c <argptr+0x52>
8010537b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537e:	89 c2                	mov    %eax,%edx
80105380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105383:	8b 00                	mov    (%eax),%eax
80105385:	39 c2                	cmp    %eax,%edx
80105387:	73 13                	jae    8010539c <argptr+0x52>
80105389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538c:	89 c2                	mov    %eax,%edx
8010538e:	8b 45 10             	mov    0x10(%ebp),%eax
80105391:	01 c2                	add    %eax,%edx
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	8b 00                	mov    (%eax),%eax
80105398:	39 c2                	cmp    %eax,%edx
8010539a:	76 07                	jbe    801053a3 <argptr+0x59>
    return -1;
8010539c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a1:	eb 0f                	jmp    801053b2 <argptr+0x68>
  *pp = (char*)i;
801053a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053a6:	89 c2                	mov    %eax,%edx
801053a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ab:	89 10                	mov    %edx,(%eax)
  return 0;
801053ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    

801053b4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053b4:	55                   	push   %ebp
801053b5:	89 e5                	mov    %esp,%ebp
801053b7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c1:	8b 45 08             	mov    0x8(%ebp),%eax
801053c4:	89 04 24             	mov    %eax,(%esp)
801053c7:	e8 51 ff ff ff       	call   8010531d <argint>
801053cc:	85 c0                	test   %eax,%eax
801053ce:	79 07                	jns    801053d7 <argstr+0x23>
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d5:	eb 12                	jmp    801053e9 <argstr+0x35>
  return fetchstr(addr, pp);
801053d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053da:	8b 55 0c             	mov    0xc(%ebp),%edx
801053dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801053e1:	89 04 24             	mov    %eax,(%esp)
801053e4:	e8 d2 fe ff ff       	call   801052bb <fetchstr>
}
801053e9:	c9                   	leave  
801053ea:	c3                   	ret    

801053eb <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801053eb:	55                   	push   %ebp
801053ec:	89 e5                	mov    %esp,%ebp
801053ee:	53                   	push   %ebx
801053ef:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
801053f2:	e8 80 ed ff ff       	call   80104177 <myproc>
801053f7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801053fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053fd:	8b 40 18             	mov    0x18(%eax),%eax
80105400:	8b 40 1c             	mov    0x1c(%eax),%eax
80105403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010540a:	7e 2d                	jle    80105439 <syscall+0x4e>
8010540c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010540f:	83 f8 15             	cmp    $0x15,%eax
80105412:	77 25                	ja     80105439 <syscall+0x4e>
80105414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105417:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
8010541e:	85 c0                	test   %eax,%eax
80105420:	74 17                	je     80105439 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105425:	8b 58 18             	mov    0x18(%eax),%ebx
80105428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542b:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105432:	ff d0                	call   *%eax
80105434:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105437:	eb 34                	jmp    8010546d <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543c:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010543f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105442:	8b 40 10             	mov    0x10(%eax),%eax
80105445:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105448:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010544c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105450:	89 44 24 04          	mov    %eax,0x4(%esp)
80105454:	c7 04 24 d0 85 10 80 	movl   $0x801085d0,(%esp)
8010545b:	e8 61 af ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105463:	8b 40 18             	mov    0x18(%eax),%eax
80105466:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010546d:	83 c4 24             	add    $0x24,%esp
80105470:	5b                   	pop    %ebx
80105471:	5d                   	pop    %ebp
80105472:	c3                   	ret    
	...

80105474 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010547a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105481:	8b 45 08             	mov    0x8(%ebp),%eax
80105484:	89 04 24             	mov    %eax,(%esp)
80105487:	e8 91 fe ff ff       	call   8010531d <argint>
8010548c:	85 c0                	test   %eax,%eax
8010548e:	79 07                	jns    80105497 <argfd+0x23>
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105495:	eb 4f                	jmp    801054e6 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105497:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010549a:	85 c0                	test   %eax,%eax
8010549c:	78 20                	js     801054be <argfd+0x4a>
8010549e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a1:	83 f8 0f             	cmp    $0xf,%eax
801054a4:	7f 18                	jg     801054be <argfd+0x4a>
801054a6:	e8 cc ec ff ff       	call   80104177 <myproc>
801054ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054ae:	83 c2 08             	add    $0x8,%edx
801054b1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801054b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054bc:	75 07                	jne    801054c5 <argfd+0x51>
    return -1;
801054be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c3:	eb 21                	jmp    801054e6 <argfd+0x72>
  if(pfd)
801054c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801054c9:	74 08                	je     801054d3 <argfd+0x5f>
    *pfd = fd;
801054cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d1:	89 10                	mov    %edx,(%eax)
  if(pf)
801054d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054d7:	74 08                	je     801054e1 <argfd+0x6d>
    *pf = f;
801054d9:	8b 45 10             	mov    0x10(%ebp),%eax
801054dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054df:	89 10                	mov    %edx,(%eax)
  return 0;
801054e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801054ee:	e8 84 ec ff ff       	call   80104177 <myproc>
801054f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801054f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054fd:	eb 29                	jmp    80105528 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
801054ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105502:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105505:	83 c2 08             	add    $0x8,%edx
80105508:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010550c:	85 c0                	test   %eax,%eax
8010550e:	75 15                	jne    80105525 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105513:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105516:	8d 4a 08             	lea    0x8(%edx),%ecx
80105519:	8b 55 08             	mov    0x8(%ebp),%edx
8010551c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105523:	eb 0e                	jmp    80105533 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105525:	ff 45 f4             	incl   -0xc(%ebp)
80105528:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010552c:	7e d1                	jle    801054ff <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010552e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105533:	c9                   	leave  
80105534:	c3                   	ret    

80105535 <sys_dup>:

int
sys_dup(void)
{
80105535:	55                   	push   %ebp
80105536:	89 e5                	mov    %esp,%ebp
80105538:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010553b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010553e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105542:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105549:	00 
8010554a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105551:	e8 1e ff ff ff       	call   80105474 <argfd>
80105556:	85 c0                	test   %eax,%eax
80105558:	79 07                	jns    80105561 <sys_dup+0x2c>
    return -1;
8010555a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555f:	eb 29                	jmp    8010558a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105561:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105564:	89 04 24             	mov    %eax,(%esp)
80105567:	e8 7c ff ff ff       	call   801054e8 <fdalloc>
8010556c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010556f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105573:	79 07                	jns    8010557c <sys_dup+0x47>
    return -1;
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557a:	eb 0e                	jmp    8010558a <sys_dup+0x55>
  filedup(f);
8010557c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557f:	89 04 24             	mov    %eax,(%esp)
80105582:	e8 9d ba ff ff       	call   80101024 <filedup>
  return fd;
80105587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    

8010558c <sys_read>:

int
sys_read(void)
{
8010558c:	55                   	push   %ebp
8010558d:	89 e5                	mov    %esp,%ebp
8010558f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105592:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105595:	89 44 24 08          	mov    %eax,0x8(%esp)
80105599:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055a0:	00 
801055a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055a8:	e8 c7 fe ff ff       	call   80105474 <argfd>
801055ad:	85 c0                	test   %eax,%eax
801055af:	78 35                	js     801055e6 <sys_read+0x5a>
801055b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801055b8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801055bf:	e8 59 fd ff ff       	call   8010531d <argint>
801055c4:	85 c0                	test   %eax,%eax
801055c6:	78 1e                	js     801055e6 <sys_read+0x5a>
801055c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801055cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801055d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055dd:	e8 68 fd ff ff       	call   8010534a <argptr>
801055e2:	85 c0                	test   %eax,%eax
801055e4:	79 07                	jns    801055ed <sys_read+0x61>
    return -1;
801055e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055eb:	eb 19                	jmp    80105606 <sys_read+0x7a>
  return fileread(f, p, n);
801055ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801055f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801055fe:	89 04 24             	mov    %eax,(%esp)
80105601:	e8 7f bb ff ff       	call   80101185 <fileread>
}
80105606:	c9                   	leave  
80105607:	c3                   	ret    

80105608 <sys_write>:

int
sys_write(void)
{
80105608:	55                   	push   %ebp
80105609:	89 e5                	mov    %esp,%ebp
8010560b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010560e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105611:	89 44 24 08          	mov    %eax,0x8(%esp)
80105615:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010561c:	00 
8010561d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105624:	e8 4b fe ff ff       	call   80105474 <argfd>
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 35                	js     80105662 <sys_write+0x5a>
8010562d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105630:	89 44 24 04          	mov    %eax,0x4(%esp)
80105634:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010563b:	e8 dd fc ff ff       	call   8010531d <argint>
80105640:	85 c0                	test   %eax,%eax
80105642:	78 1e                	js     80105662 <sys_write+0x5a>
80105644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105647:	89 44 24 08          	mov    %eax,0x8(%esp)
8010564b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010564e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105652:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105659:	e8 ec fc ff ff       	call   8010534a <argptr>
8010565e:	85 c0                	test   %eax,%eax
80105660:	79 07                	jns    80105669 <sys_write+0x61>
    return -1;
80105662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105667:	eb 19                	jmp    80105682 <sys_write+0x7a>
  return filewrite(f, p, n);
80105669:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010566c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010566f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105672:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105676:	89 54 24 04          	mov    %edx,0x4(%esp)
8010567a:	89 04 24             	mov    %eax,(%esp)
8010567d:	e8 be bb ff ff       	call   80101240 <filewrite>
}
80105682:	c9                   	leave  
80105683:	c3                   	ret    

80105684 <sys_close>:

int
sys_close(void)
{
80105684:	55                   	push   %ebp
80105685:	89 e5                	mov    %esp,%ebp
80105687:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010568a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010568d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105691:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105694:	89 44 24 04          	mov    %eax,0x4(%esp)
80105698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010569f:	e8 d0 fd ff ff       	call   80105474 <argfd>
801056a4:	85 c0                	test   %eax,%eax
801056a6:	79 07                	jns    801056af <sys_close+0x2b>
    return -1;
801056a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ad:	eb 23                	jmp    801056d2 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
801056af:	e8 c3 ea ff ff       	call   80104177 <myproc>
801056b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b7:	83 c2 08             	add    $0x8,%edx
801056ba:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801056c1:	00 
  fileclose(f);
801056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c5:	89 04 24             	mov    %eax,(%esp)
801056c8:	e8 9f b9 ff ff       	call   8010106c <fileclose>
  return 0;
801056cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056d2:	c9                   	leave  
801056d3:	c3                   	ret    

801056d4 <sys_fstat>:

int
sys_fstat(void)
{
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056dd:	89 44 24 08          	mov    %eax,0x8(%esp)
801056e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056e8:	00 
801056e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056f0:	e8 7f fd ff ff       	call   80105474 <argfd>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 1f                	js     80105718 <sys_fstat+0x44>
801056f9:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105700:	00 
80105701:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105704:	89 44 24 04          	mov    %eax,0x4(%esp)
80105708:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010570f:	e8 36 fc ff ff       	call   8010534a <argptr>
80105714:	85 c0                	test   %eax,%eax
80105716:	79 07                	jns    8010571f <sys_fstat+0x4b>
    return -1;
80105718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571d:	eb 12                	jmp    80105731 <sys_fstat+0x5d>
  return filestat(f, st);
8010571f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105725:	89 54 24 04          	mov    %edx,0x4(%esp)
80105729:	89 04 24             	mov    %eax,(%esp)
8010572c:	e8 05 ba ff ff       	call   80101136 <filestat>
}
80105731:	c9                   	leave  
80105732:	c3                   	ret    

80105733 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105733:	55                   	push   %ebp
80105734:	89 e5                	mov    %esp,%ebp
80105736:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105739:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010573c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105747:	e8 68 fc ff ff       	call   801053b4 <argstr>
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 17                	js     80105767 <sys_link+0x34>
80105750:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105753:	89 44 24 04          	mov    %eax,0x4(%esp)
80105757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010575e:	e8 51 fc ff ff       	call   801053b4 <argstr>
80105763:	85 c0                	test   %eax,%eax
80105765:	79 0a                	jns    80105771 <sys_link+0x3e>
    return -1;
80105767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576c:	e9 3d 01 00 00       	jmp    801058ae <sys_link+0x17b>

  begin_op();
80105771:	e8 09 dd ff ff       	call   8010347f <begin_op>
  if((ip = namei(old)) == 0){
80105776:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105779:	89 04 24             	mov    %eax,(%esp)
8010577c:	e8 2a cd ff ff       	call   801024ab <namei>
80105781:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105788:	75 0f                	jne    80105799 <sys_link+0x66>
    end_op();
8010578a:	e8 72 dd ff ff       	call   80103501 <end_op>
    return -1;
8010578f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105794:	e9 15 01 00 00       	jmp    801058ae <sys_link+0x17b>
  }

  ilock(ip);
80105799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579c:	89 04 24             	mov    %eax,(%esp)
8010579f:	e8 e2 c1 ff ff       	call   80101986 <ilock>
  if(ip->type == T_DIR){
801057a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a7:	8b 40 50             	mov    0x50(%eax),%eax
801057aa:	66 83 f8 01          	cmp    $0x1,%ax
801057ae:	75 1a                	jne    801057ca <sys_link+0x97>
    iunlockput(ip);
801057b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b3:	89 04 24             	mov    %eax,(%esp)
801057b6:	e8 ca c3 ff ff       	call   80101b85 <iunlockput>
    end_op();
801057bb:	e8 41 dd ff ff       	call   80103501 <end_op>
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c5:	e9 e4 00 00 00       	jmp    801058ae <sys_link+0x17b>
  }

  ip->nlink++;
801057ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057cd:	66 8b 40 56          	mov    0x56(%eax),%ax
801057d1:	40                   	inc    %eax
801057d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057d5:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
801057d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057dc:	89 04 24             	mov    %eax,(%esp)
801057df:	e8 df bf ff ff       	call   801017c3 <iupdate>
  iunlock(ip);
801057e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e7:	89 04 24             	mov    %eax,(%esp)
801057ea:	e8 a1 c2 ff ff       	call   80101a90 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801057ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057f2:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801057f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801057f9:	89 04 24             	mov    %eax,(%esp)
801057fc:	e8 cc cc ff ff       	call   801024cd <nameiparent>
80105801:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105808:	75 02                	jne    8010580c <sys_link+0xd9>
    goto bad;
8010580a:	eb 68                	jmp    80105874 <sys_link+0x141>
  ilock(dp);
8010580c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010580f:	89 04 24             	mov    %eax,(%esp)
80105812:	e8 6f c1 ff ff       	call   80101986 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581a:	8b 10                	mov    (%eax),%edx
8010581c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581f:	8b 00                	mov    (%eax),%eax
80105821:	39 c2                	cmp    %eax,%edx
80105823:	75 20                	jne    80105845 <sys_link+0x112>
80105825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105828:	8b 40 04             	mov    0x4(%eax),%eax
8010582b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010582f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105832:	89 44 24 04          	mov    %eax,0x4(%esp)
80105836:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105839:	89 04 24             	mov    %eax,(%esp)
8010583c:	e8 b7 c9 ff ff       	call   801021f8 <dirlink>
80105841:	85 c0                	test   %eax,%eax
80105843:	79 0d                	jns    80105852 <sys_link+0x11f>
    iunlockput(dp);
80105845:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105848:	89 04 24             	mov    %eax,(%esp)
8010584b:	e8 35 c3 ff ff       	call   80101b85 <iunlockput>
    goto bad;
80105850:	eb 22                	jmp    80105874 <sys_link+0x141>
  }
  iunlockput(dp);
80105852:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105855:	89 04 24             	mov    %eax,(%esp)
80105858:	e8 28 c3 ff ff       	call   80101b85 <iunlockput>
  iput(ip);
8010585d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105860:	89 04 24             	mov    %eax,(%esp)
80105863:	e8 6c c2 ff ff       	call   80101ad4 <iput>

  end_op();
80105868:	e8 94 dc ff ff       	call   80103501 <end_op>

  return 0;
8010586d:	b8 00 00 00 00       	mov    $0x0,%eax
80105872:	eb 3a                	jmp    801058ae <sys_link+0x17b>

bad:
  ilock(ip);
80105874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105877:	89 04 24             	mov    %eax,(%esp)
8010587a:	e8 07 c1 ff ff       	call   80101986 <ilock>
  ip->nlink--;
8010587f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105882:	66 8b 40 56          	mov    0x56(%eax),%ax
80105886:	48                   	dec    %eax
80105887:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010588a:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
8010588e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105891:	89 04 24             	mov    %eax,(%esp)
80105894:	e8 2a bf ff ff       	call   801017c3 <iupdate>
  iunlockput(ip);
80105899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589c:	89 04 24             	mov    %eax,(%esp)
8010589f:	e8 e1 c2 ff ff       	call   80101b85 <iunlockput>
  end_op();
801058a4:	e8 58 dc ff ff       	call   80103501 <end_op>
  return -1;
801058a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ae:	c9                   	leave  
801058af:	c3                   	ret    

801058b0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058b6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801058bd:	eb 4a                	jmp    80105909 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801058c9:	00 
801058ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d5:	8b 45 08             	mov    0x8(%ebp),%eax
801058d8:	89 04 24             	mov    %eax,(%esp)
801058db:	e8 3d c5 ff ff       	call   80101e1d <readi>
801058e0:	83 f8 10             	cmp    $0x10,%eax
801058e3:	74 0c                	je     801058f1 <isdirempty+0x41>
      panic("isdirempty: readi");
801058e5:	c7 04 24 ec 85 10 80 	movl   $0x801085ec,(%esp)
801058ec:	e8 63 ac ff ff       	call   80100554 <panic>
    if(de.inum != 0)
801058f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058f4:	66 85 c0             	test   %ax,%ax
801058f7:	74 07                	je     80105900 <isdirempty+0x50>
      return 0;
801058f9:	b8 00 00 00 00       	mov    $0x0,%eax
801058fe:	eb 1b                	jmp    8010591b <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105903:	83 c0 10             	add    $0x10,%eax
80105906:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105909:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010590c:	8b 45 08             	mov    0x8(%ebp),%eax
8010590f:	8b 40 58             	mov    0x58(%eax),%eax
80105912:	39 c2                	cmp    %eax,%edx
80105914:	72 a9                	jb     801058bf <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105916:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010591b:	c9                   	leave  
8010591c:	c3                   	ret    

8010591d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010591d:	55                   	push   %ebp
8010591e:	89 e5                	mov    %esp,%ebp
80105920:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105923:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105926:	89 44 24 04          	mov    %eax,0x4(%esp)
8010592a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105931:	e8 7e fa ff ff       	call   801053b4 <argstr>
80105936:	85 c0                	test   %eax,%eax
80105938:	79 0a                	jns    80105944 <sys_unlink+0x27>
    return -1;
8010593a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593f:	e9 a9 01 00 00       	jmp    80105aed <sys_unlink+0x1d0>

  begin_op();
80105944:	e8 36 db ff ff       	call   8010347f <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105949:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010594c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010594f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105953:	89 04 24             	mov    %eax,(%esp)
80105956:	e8 72 cb ff ff       	call   801024cd <nameiparent>
8010595b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010595e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105962:	75 0f                	jne    80105973 <sys_unlink+0x56>
    end_op();
80105964:	e8 98 db ff ff       	call   80103501 <end_op>
    return -1;
80105969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596e:	e9 7a 01 00 00       	jmp    80105aed <sys_unlink+0x1d0>
  }

  ilock(dp);
80105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105976:	89 04 24             	mov    %eax,(%esp)
80105979:	e8 08 c0 ff ff       	call   80101986 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010597e:	c7 44 24 04 fe 85 10 	movl   $0x801085fe,0x4(%esp)
80105985:	80 
80105986:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105989:	89 04 24             	mov    %eax,(%esp)
8010598c:	e8 7f c7 ff ff       	call   80102110 <namecmp>
80105991:	85 c0                	test   %eax,%eax
80105993:	0f 84 3f 01 00 00    	je     80105ad8 <sys_unlink+0x1bb>
80105999:	c7 44 24 04 00 86 10 	movl   $0x80108600,0x4(%esp)
801059a0:	80 
801059a1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801059a4:	89 04 24             	mov    %eax,(%esp)
801059a7:	e8 64 c7 ff ff       	call   80102110 <namecmp>
801059ac:	85 c0                	test   %eax,%eax
801059ae:	0f 84 24 01 00 00    	je     80105ad8 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801059b4:	8d 45 c8             	lea    -0x38(%ebp),%eax
801059b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801059bb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801059be:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c5:	89 04 24             	mov    %eax,(%esp)
801059c8:	e8 65 c7 ff ff       	call   80102132 <dirlookup>
801059cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059d4:	75 05                	jne    801059db <sys_unlink+0xbe>
    goto bad;
801059d6:	e9 fd 00 00 00       	jmp    80105ad8 <sys_unlink+0x1bb>
  ilock(ip);
801059db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059de:	89 04 24             	mov    %eax,(%esp)
801059e1:	e8 a0 bf ff ff       	call   80101986 <ilock>

  if(ip->nlink < 1)
801059e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e9:	66 8b 40 56          	mov    0x56(%eax),%ax
801059ed:	66 85 c0             	test   %ax,%ax
801059f0:	7f 0c                	jg     801059fe <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
801059f2:	c7 04 24 03 86 10 80 	movl   $0x80108603,(%esp)
801059f9:	e8 56 ab ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801059fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a01:	8b 40 50             	mov    0x50(%eax),%eax
80105a04:	66 83 f8 01          	cmp    $0x1,%ax
80105a08:	75 1f                	jne    80105a29 <sys_unlink+0x10c>
80105a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a0d:	89 04 24             	mov    %eax,(%esp)
80105a10:	e8 9b fe ff ff       	call   801058b0 <isdirempty>
80105a15:	85 c0                	test   %eax,%eax
80105a17:	75 10                	jne    80105a29 <sys_unlink+0x10c>
    iunlockput(ip);
80105a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1c:	89 04 24             	mov    %eax,(%esp)
80105a1f:	e8 61 c1 ff ff       	call   80101b85 <iunlockput>
    goto bad;
80105a24:	e9 af 00 00 00       	jmp    80105ad8 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105a29:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105a30:	00 
80105a31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a38:	00 
80105a39:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a3c:	89 04 24             	mov    %eax,(%esp)
80105a3f:	e8 a6 f5 ff ff       	call   80104fea <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105a47:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105a4e:	00 
80105a4f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a53:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a56:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5d:	89 04 24             	mov    %eax,(%esp)
80105a60:	e8 1c c5 ff ff       	call   80101f81 <writei>
80105a65:	83 f8 10             	cmp    $0x10,%eax
80105a68:	74 0c                	je     80105a76 <sys_unlink+0x159>
    panic("unlink: writei");
80105a6a:	c7 04 24 15 86 10 80 	movl   $0x80108615,(%esp)
80105a71:	e8 de aa ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a79:	8b 40 50             	mov    0x50(%eax),%eax
80105a7c:	66 83 f8 01          	cmp    $0x1,%ax
80105a80:	75 1a                	jne    80105a9c <sys_unlink+0x17f>
    dp->nlink--;
80105a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a85:	66 8b 40 56          	mov    0x56(%eax),%ax
80105a89:	48                   	dec    %eax
80105a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a8d:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a94:	89 04 24             	mov    %eax,(%esp)
80105a97:	e8 27 bd ff ff       	call   801017c3 <iupdate>
  }
  iunlockput(dp);
80105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9f:	89 04 24             	mov    %eax,(%esp)
80105aa2:	e8 de c0 ff ff       	call   80101b85 <iunlockput>

  ip->nlink--;
80105aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aaa:	66 8b 40 56          	mov    0x56(%eax),%ax
80105aae:	48                   	dec    %eax
80105aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ab2:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab9:	89 04 24             	mov    %eax,(%esp)
80105abc:	e8 02 bd ff ff       	call   801017c3 <iupdate>
  iunlockput(ip);
80105ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac4:	89 04 24             	mov    %eax,(%esp)
80105ac7:	e8 b9 c0 ff ff       	call   80101b85 <iunlockput>

  end_op();
80105acc:	e8 30 da ff ff       	call   80103501 <end_op>

  return 0;
80105ad1:	b8 00 00 00 00       	mov    $0x0,%eax
80105ad6:	eb 15                	jmp    80105aed <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105adb:	89 04 24             	mov    %eax,(%esp)
80105ade:	e8 a2 c0 ff ff       	call   80101b85 <iunlockput>
  end_op();
80105ae3:	e8 19 da ff ff       	call   80103501 <end_op>
  return -1;
80105ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aed:	c9                   	leave  
80105aee:	c3                   	ret    

80105aef <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105aef:	55                   	push   %ebp
80105af0:	89 e5                	mov    %esp,%ebp
80105af2:	83 ec 48             	sub    $0x48,%esp
80105af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105af8:	8b 55 10             	mov    0x10(%ebp),%edx
80105afb:	8b 45 14             	mov    0x14(%ebp),%eax
80105afe:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105b02:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105b06:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b0a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b11:	8b 45 08             	mov    0x8(%ebp),%eax
80105b14:	89 04 24             	mov    %eax,(%esp)
80105b17:	e8 b1 c9 ff ff       	call   801024cd <nameiparent>
80105b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b23:	75 0a                	jne    80105b2f <create+0x40>
    return 0;
80105b25:	b8 00 00 00 00       	mov    $0x0,%eax
80105b2a:	e9 79 01 00 00       	jmp    80105ca8 <create+0x1b9>
  ilock(dp);
80105b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b32:	89 04 24             	mov    %eax,(%esp)
80105b35:	e8 4c be ff ff       	call   80101986 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105b3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b41:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4b:	89 04 24             	mov    %eax,(%esp)
80105b4e:	e8 df c5 ff ff       	call   80102132 <dirlookup>
80105b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b5a:	74 46                	je     80105ba2 <create+0xb3>
    iunlockput(dp);
80105b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5f:	89 04 24             	mov    %eax,(%esp)
80105b62:	e8 1e c0 ff ff       	call   80101b85 <iunlockput>
    ilock(ip);
80105b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6a:	89 04 24             	mov    %eax,(%esp)
80105b6d:	e8 14 be ff ff       	call   80101986 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105b72:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b77:	75 14                	jne    80105b8d <create+0x9e>
80105b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7c:	8b 40 50             	mov    0x50(%eax),%eax
80105b7f:	66 83 f8 02          	cmp    $0x2,%ax
80105b83:	75 08                	jne    80105b8d <create+0x9e>
      return ip;
80105b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b88:	e9 1b 01 00 00       	jmp    80105ca8 <create+0x1b9>
    iunlockput(ip);
80105b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b90:	89 04 24             	mov    %eax,(%esp)
80105b93:	e8 ed bf ff ff       	call   80101b85 <iunlockput>
    return 0;
80105b98:	b8 00 00 00 00       	mov    $0x0,%eax
80105b9d:	e9 06 01 00 00       	jmp    80105ca8 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ba2:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba9:	8b 00                	mov    (%eax),%eax
80105bab:	89 54 24 04          	mov    %edx,0x4(%esp)
80105baf:	89 04 24             	mov    %eax,(%esp)
80105bb2:	e8 3a bb ff ff       	call   801016f1 <ialloc>
80105bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bbe:	75 0c                	jne    80105bcc <create+0xdd>
    panic("create: ialloc");
80105bc0:	c7 04 24 24 86 10 80 	movl   $0x80108624,(%esp)
80105bc7:	e8 88 a9 ff ff       	call   80100554 <panic>

  ilock(ip);
80105bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcf:	89 04 24             	mov    %eax,(%esp)
80105bd2:	e8 af bd ff ff       	call   80101986 <ilock>
  ip->major = major;
80105bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bda:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105bdd:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105be1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105be7:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bee:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf7:	89 04 24             	mov    %eax,(%esp)
80105bfa:	e8 c4 bb ff ff       	call   801017c3 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105bff:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105c04:	75 68                	jne    80105c6e <create+0x17f>
    dp->nlink++;  // for ".."
80105c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c09:	66 8b 40 56          	mov    0x56(%eax),%ax
80105c0d:	40                   	inc    %eax
80105c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c11:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c18:	89 04 24             	mov    %eax,(%esp)
80105c1b:	e8 a3 bb ff ff       	call   801017c3 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c23:	8b 40 04             	mov    0x4(%eax),%eax
80105c26:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c2a:	c7 44 24 04 fe 85 10 	movl   $0x801085fe,0x4(%esp)
80105c31:	80 
80105c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c35:	89 04 24             	mov    %eax,(%esp)
80105c38:	e8 bb c5 ff ff       	call   801021f8 <dirlink>
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	78 21                	js     80105c62 <create+0x173>
80105c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c44:	8b 40 04             	mov    0x4(%eax),%eax
80105c47:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c4b:	c7 44 24 04 00 86 10 	movl   $0x80108600,0x4(%esp)
80105c52:	80 
80105c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c56:	89 04 24             	mov    %eax,(%esp)
80105c59:	e8 9a c5 ff ff       	call   801021f8 <dirlink>
80105c5e:	85 c0                	test   %eax,%eax
80105c60:	79 0c                	jns    80105c6e <create+0x17f>
      panic("create dots");
80105c62:	c7 04 24 33 86 10 80 	movl   $0x80108633,(%esp)
80105c69:	e8 e6 a8 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	8b 40 04             	mov    0x4(%eax),%eax
80105c74:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c78:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c82:	89 04 24             	mov    %eax,(%esp)
80105c85:	e8 6e c5 ff ff       	call   801021f8 <dirlink>
80105c8a:	85 c0                	test   %eax,%eax
80105c8c:	79 0c                	jns    80105c9a <create+0x1ab>
    panic("create: dirlink");
80105c8e:	c7 04 24 3f 86 10 80 	movl   $0x8010863f,(%esp)
80105c95:	e8 ba a8 ff ff       	call   80100554 <panic>

  iunlockput(dp);
80105c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9d:	89 04 24             	mov    %eax,(%esp)
80105ca0:	e8 e0 be ff ff       	call   80101b85 <iunlockput>

  return ip;
80105ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105ca8:	c9                   	leave  
80105ca9:	c3                   	ret    

80105caa <sys_open>:

int
sys_open(void)
{
80105caa:	55                   	push   %ebp
80105cab:	89 e5                	mov    %esp,%ebp
80105cad:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cb0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cbe:	e8 f1 f6 ff ff       	call   801053b4 <argstr>
80105cc3:	85 c0                	test   %eax,%eax
80105cc5:	78 17                	js     80105cde <sys_open+0x34>
80105cc7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cca:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105cd5:	e8 43 f6 ff ff       	call   8010531d <argint>
80105cda:	85 c0                	test   %eax,%eax
80105cdc:	79 0a                	jns    80105ce8 <sys_open+0x3e>
    return -1;
80105cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce3:	e9 5b 01 00 00       	jmp    80105e43 <sys_open+0x199>

  begin_op();
80105ce8:	e8 92 d7 ff ff       	call   8010347f <begin_op>

  if(omode & O_CREATE){
80105ced:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cf0:	25 00 02 00 00       	and    $0x200,%eax
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 3b                	je     80105d34 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cfc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d03:	00 
80105d04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d0b:	00 
80105d0c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105d13:	00 
80105d14:	89 04 24             	mov    %eax,(%esp)
80105d17:	e8 d3 fd ff ff       	call   80105aef <create>
80105d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d23:	75 6a                	jne    80105d8f <sys_open+0xe5>
      end_op();
80105d25:	e8 d7 d7 ff ff       	call   80103501 <end_op>
      return -1;
80105d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2f:	e9 0f 01 00 00       	jmp    80105e43 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105d34:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d37:	89 04 24             	mov    %eax,(%esp)
80105d3a:	e8 6c c7 ff ff       	call   801024ab <namei>
80105d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d46:	75 0f                	jne    80105d57 <sys_open+0xad>
      end_op();
80105d48:	e8 b4 d7 ff ff       	call   80103501 <end_op>
      return -1;
80105d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d52:	e9 ec 00 00 00       	jmp    80105e43 <sys_open+0x199>
    }
    ilock(ip);
80105d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5a:	89 04 24             	mov    %eax,(%esp)
80105d5d:	e8 24 bc ff ff       	call   80101986 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d65:	8b 40 50             	mov    0x50(%eax),%eax
80105d68:	66 83 f8 01          	cmp    $0x1,%ax
80105d6c:	75 21                	jne    80105d8f <sys_open+0xe5>
80105d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d71:	85 c0                	test   %eax,%eax
80105d73:	74 1a                	je     80105d8f <sys_open+0xe5>
      iunlockput(ip);
80105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d78:	89 04 24             	mov    %eax,(%esp)
80105d7b:	e8 05 be ff ff       	call   80101b85 <iunlockput>
      end_op();
80105d80:	e8 7c d7 ff ff       	call   80103501 <end_op>
      return -1;
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8a:	e9 b4 00 00 00       	jmp    80105e43 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d8f:	e8 30 b2 ff ff       	call   80100fc4 <filealloc>
80105d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d9b:	74 14                	je     80105db1 <sys_open+0x107>
80105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da0:	89 04 24             	mov    %eax,(%esp)
80105da3:	e8 40 f7 ff ff       	call   801054e8 <fdalloc>
80105da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105dab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105daf:	79 28                	jns    80105dd9 <sys_open+0x12f>
    if(f)
80105db1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105db5:	74 0b                	je     80105dc2 <sys_open+0x118>
      fileclose(f);
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	89 04 24             	mov    %eax,(%esp)
80105dbd:	e8 aa b2 ff ff       	call   8010106c <fileclose>
    iunlockput(ip);
80105dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc5:	89 04 24             	mov    %eax,(%esp)
80105dc8:	e8 b8 bd ff ff       	call   80101b85 <iunlockput>
    end_op();
80105dcd:	e8 2f d7 ff ff       	call   80103501 <end_op>
    return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 6a                	jmp    80105e43 <sys_open+0x199>
  }
  iunlock(ip);
80105dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddc:	89 04 24             	mov    %eax,(%esp)
80105ddf:	e8 ac bc ff ff       	call   80101a90 <iunlock>
  end_op();
80105de4:	e8 18 d7 ff ff       	call   80103501 <end_op>

  f->type = FD_INODE;
80105de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dec:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df8:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfe:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e08:	83 e0 01             	and    $0x1,%eax
80105e0b:	85 c0                	test   %eax,%eax
80105e0d:	0f 94 c0             	sete   %al
80105e10:	88 c2                	mov    %al,%dl
80105e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e15:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e1b:	83 e0 01             	and    $0x1,%eax
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	75 0a                	jne    80105e2c <sys_open+0x182>
80105e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e25:	83 e0 02             	and    $0x2,%eax
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	74 07                	je     80105e33 <sys_open+0x189>
80105e2c:	b8 01 00 00 00       	mov    $0x1,%eax
80105e31:	eb 05                	jmp    80105e38 <sys_open+0x18e>
80105e33:	b8 00 00 00 00       	mov    $0x0,%eax
80105e38:	88 c2                	mov    %al,%dl
80105e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3d:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105e43:	c9                   	leave  
80105e44:	c3                   	ret    

80105e45 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e45:	55                   	push   %ebp
80105e46:	89 e5                	mov    %esp,%ebp
80105e48:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e4b:	e8 2f d6 ff ff       	call   8010347f <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e5e:	e8 51 f5 ff ff       	call   801053b4 <argstr>
80105e63:	85 c0                	test   %eax,%eax
80105e65:	78 2c                	js     80105e93 <sys_mkdir+0x4e>
80105e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105e71:	00 
80105e72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105e79:	00 
80105e7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105e81:	00 
80105e82:	89 04 24             	mov    %eax,(%esp)
80105e85:	e8 65 fc ff ff       	call   80105aef <create>
80105e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e91:	75 0c                	jne    80105e9f <sys_mkdir+0x5a>
    end_op();
80105e93:	e8 69 d6 ff ff       	call   80103501 <end_op>
    return -1;
80105e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9d:	eb 15                	jmp    80105eb4 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea2:	89 04 24             	mov    %eax,(%esp)
80105ea5:	e8 db bc ff ff       	call   80101b85 <iunlockput>
  end_op();
80105eaa:	e8 52 d6 ff ff       	call   80103501 <end_op>
  return 0;
80105eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105eb4:	c9                   	leave  
80105eb5:	c3                   	ret    

80105eb6 <sys_mknod>:

int
sys_mknod(void)
{
80105eb6:	55                   	push   %ebp
80105eb7:	89 e5                	mov    %esp,%ebp
80105eb9:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ebc:	e8 be d5 ff ff       	call   8010347f <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ec1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ecf:	e8 e0 f4 ff ff       	call   801053b4 <argstr>
80105ed4:	85 c0                	test   %eax,%eax
80105ed6:	78 5e                	js     80105f36 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ed8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105edf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ee6:	e8 32 f4 ff ff       	call   8010531d <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105eeb:	85 c0                	test   %eax,%eax
80105eed:	78 47                	js     80105f36 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105eef:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ef2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105efd:	e8 1b f4 ff ff       	call   8010531d <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105f02:	85 c0                	test   %eax,%eax
80105f04:	78 30                	js     80105f36 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f09:	0f bf c8             	movswl %ax,%ecx
80105f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f0f:	0f bf d0             	movswl %ax,%edx
80105f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f15:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105f19:	89 54 24 08          	mov    %edx,0x8(%esp)
80105f1d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105f24:	00 
80105f25:	89 04 24             	mov    %eax,(%esp)
80105f28:	e8 c2 fb ff ff       	call   80105aef <create>
80105f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f34:	75 0c                	jne    80105f42 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105f36:	e8 c6 d5 ff ff       	call   80103501 <end_op>
    return -1;
80105f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f40:	eb 15                	jmp    80105f57 <sys_mknod+0xa1>
  }
  iunlockput(ip);
80105f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f45:	89 04 24             	mov    %eax,(%esp)
80105f48:	e8 38 bc ff ff       	call   80101b85 <iunlockput>
  end_op();
80105f4d:	e8 af d5 ff ff       	call   80103501 <end_op>
  return 0;
80105f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f57:	c9                   	leave  
80105f58:	c3                   	ret    

80105f59 <sys_chdir>:

int
sys_chdir(void)
{
80105f59:	55                   	push   %ebp
80105f5a:	89 e5                	mov    %esp,%ebp
80105f5c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f5f:	e8 13 e2 ff ff       	call   80104177 <myproc>
80105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105f67:	e8 13 d5 ff ff       	call   8010347f <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105f6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f7a:	e8 35 f4 ff ff       	call   801053b4 <argstr>
80105f7f:	85 c0                	test   %eax,%eax
80105f81:	78 14                	js     80105f97 <sys_chdir+0x3e>
80105f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f86:	89 04 24             	mov    %eax,(%esp)
80105f89:	e8 1d c5 ff ff       	call   801024ab <namei>
80105f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f95:	75 0c                	jne    80105fa3 <sys_chdir+0x4a>
    end_op();
80105f97:	e8 65 d5 ff ff       	call   80103501 <end_op>
    return -1;
80105f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa1:	eb 5a                	jmp    80105ffd <sys_chdir+0xa4>
  }
  ilock(ip);
80105fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa6:	89 04 24             	mov    %eax,(%esp)
80105fa9:	e8 d8 b9 ff ff       	call   80101986 <ilock>
  if(ip->type != T_DIR){
80105fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb1:	8b 40 50             	mov    0x50(%eax),%eax
80105fb4:	66 83 f8 01          	cmp    $0x1,%ax
80105fb8:	74 17                	je     80105fd1 <sys_chdir+0x78>
    iunlockput(ip);
80105fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fbd:	89 04 24             	mov    %eax,(%esp)
80105fc0:	e8 c0 bb ff ff       	call   80101b85 <iunlockput>
    end_op();
80105fc5:	e8 37 d5 ff ff       	call   80103501 <end_op>
    return -1;
80105fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcf:	eb 2c                	jmp    80105ffd <sys_chdir+0xa4>
  }
  iunlock(ip);
80105fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd4:	89 04 24             	mov    %eax,(%esp)
80105fd7:	e8 b4 ba ff ff       	call   80101a90 <iunlock>
  iput(curproc->cwd);
80105fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdf:	8b 40 68             	mov    0x68(%eax),%eax
80105fe2:	89 04 24             	mov    %eax,(%esp)
80105fe5:	e8 ea ba ff ff       	call   80101ad4 <iput>
  end_op();
80105fea:	e8 12 d5 ff ff       	call   80103501 <end_op>
  curproc->cwd = ip;
80105fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ff5:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    

80105fff <sys_exec>:

int
sys_exec(void)
{
80105fff:	55                   	push   %ebp
80106000:	89 e5                	mov    %esp,%ebp
80106002:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106008:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010600b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010600f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106016:	e8 99 f3 ff ff       	call   801053b4 <argstr>
8010601b:	85 c0                	test   %eax,%eax
8010601d:	78 1a                	js     80106039 <sys_exec+0x3a>
8010601f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106025:	89 44 24 04          	mov    %eax,0x4(%esp)
80106029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106030:	e8 e8 f2 ff ff       	call   8010531d <argint>
80106035:	85 c0                	test   %eax,%eax
80106037:	79 0a                	jns    80106043 <sys_exec+0x44>
    return -1;
80106039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603e:	e9 c7 00 00 00       	jmp    8010610a <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106043:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010604a:	00 
8010604b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106052:	00 
80106053:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106059:	89 04 24             	mov    %eax,(%esp)
8010605c:	e8 89 ef ff ff       	call   80104fea <memset>
  for(i=0;; i++){
80106061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606b:	83 f8 1f             	cmp    $0x1f,%eax
8010606e:	76 0a                	jbe    8010607a <sys_exec+0x7b>
      return -1;
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106075:	e9 90 00 00 00       	jmp    8010610a <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010607a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607d:	c1 e0 02             	shl    $0x2,%eax
80106080:	89 c2                	mov    %eax,%edx
80106082:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106088:	01 c2                	add    %eax,%edx
8010608a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106090:	89 44 24 04          	mov    %eax,0x4(%esp)
80106094:	89 14 24             	mov    %edx,(%esp)
80106097:	e8 e0 f1 ff ff       	call   8010527c <fetchint>
8010609c:	85 c0                	test   %eax,%eax
8010609e:	79 07                	jns    801060a7 <sys_exec+0xa8>
      return -1;
801060a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a5:	eb 63                	jmp    8010610a <sys_exec+0x10b>
    if(uarg == 0){
801060a7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801060ad:	85 c0                	test   %eax,%eax
801060af:	75 26                	jne    801060d7 <sys_exec+0xd8>
      argv[i] = 0;
801060b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801060bb:	00 00 00 00 
      break;
801060bf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801060c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c3:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801060c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801060cd:	89 04 24             	mov    %eax,(%esp)
801060d0:	e8 93 aa ff ff       	call   80100b68 <exec>
801060d5:	eb 33                	jmp    8010610a <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060d7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801060dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060e0:	c1 e2 02             	shl    $0x2,%edx
801060e3:	01 c2                	add    %eax,%edx
801060e5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801060eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801060ef:	89 04 24             	mov    %eax,(%esp)
801060f2:	e8 c4 f1 ff ff       	call   801052bb <fetchstr>
801060f7:	85 c0                	test   %eax,%eax
801060f9:	79 07                	jns    80106102 <sys_exec+0x103>
      return -1;
801060fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106100:	eb 08                	jmp    8010610a <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106102:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106105:	e9 5e ff ff ff       	jmp    80106068 <sys_exec+0x69>
  return exec(path, argv);
}
8010610a:	c9                   	leave  
8010610b:	c3                   	ret    

8010610c <sys_pipe>:

int
sys_pipe(void)
{
8010610c:	55                   	push   %ebp
8010610d:	89 e5                	mov    %esp,%ebp
8010610f:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106112:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106119:	00 
8010611a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010611d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106128:	e8 1d f2 ff ff       	call   8010534a <argptr>
8010612d:	85 c0                	test   %eax,%eax
8010612f:	79 0a                	jns    8010613b <sys_pipe+0x2f>
    return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106136:	e9 9a 00 00 00       	jmp    801061d5 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
8010613b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010613e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106142:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106145:	89 04 24             	mov    %eax,(%esp)
80106148:	e8 7f db ff ff       	call   80103ccc <pipealloc>
8010614d:	85 c0                	test   %eax,%eax
8010614f:	79 07                	jns    80106158 <sys_pipe+0x4c>
    return -1;
80106151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106156:	eb 7d                	jmp    801061d5 <sys_pipe+0xc9>
  fd0 = -1;
80106158:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010615f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106162:	89 04 24             	mov    %eax,(%esp)
80106165:	e8 7e f3 ff ff       	call   801054e8 <fdalloc>
8010616a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010616d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106171:	78 14                	js     80106187 <sys_pipe+0x7b>
80106173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106176:	89 04 24             	mov    %eax,(%esp)
80106179:	e8 6a f3 ff ff       	call   801054e8 <fdalloc>
8010617e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106185:	79 36                	jns    801061bd <sys_pipe+0xb1>
    if(fd0 >= 0)
80106187:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010618b:	78 13                	js     801061a0 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
8010618d:	e8 e5 df ff ff       	call   80104177 <myproc>
80106192:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106195:	83 c2 08             	add    $0x8,%edx
80106198:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010619f:	00 
    fileclose(rf);
801061a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061a3:	89 04 24             	mov    %eax,(%esp)
801061a6:	e8 c1 ae ff ff       	call   8010106c <fileclose>
    fileclose(wf);
801061ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061ae:	89 04 24             	mov    %eax,(%esp)
801061b1:	e8 b6 ae ff ff       	call   8010106c <fileclose>
    return -1;
801061b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061bb:	eb 18                	jmp    801061d5 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
801061bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801061c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061c8:	8d 50 04             	lea    0x4(%eax),%edx
801061cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ce:	89 02                	mov    %eax,(%edx)
  return 0;
801061d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
	...

801061d8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801061d8:	55                   	push   %ebp
801061d9:	89 e5                	mov    %esp,%ebp
801061db:	83 ec 08             	sub    $0x8,%esp
  return fork();
801061de:	e8 90 e2 ff ff       	call   80104473 <fork>
}
801061e3:	c9                   	leave  
801061e4:	c3                   	ret    

801061e5 <sys_exit>:

int
sys_exit(void)
{
801061e5:	55                   	push   %ebp
801061e6:	89 e5                	mov    %esp,%ebp
801061e8:	83 ec 08             	sub    $0x8,%esp
  exit();
801061eb:	e8 e9 e3 ff ff       	call   801045d9 <exit>
  return 0;  // not reached
801061f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    

801061f7 <sys_wait>:

int
sys_wait(void)
{
801061f7:	55                   	push   %ebp
801061f8:	89 e5                	mov    %esp,%ebp
801061fa:	83 ec 08             	sub    $0x8,%esp
  return wait();
801061fd:	e8 e0 e4 ff ff       	call   801046e2 <wait>
}
80106202:	c9                   	leave  
80106203:	c3                   	ret    

80106204 <sys_kill>:

int
sys_kill(void)
{
80106204:	55                   	push   %ebp
80106205:	89 e5                	mov    %esp,%ebp
80106207:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010620a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010620d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106218:	e8 00 f1 ff ff       	call   8010531d <argint>
8010621d:	85 c0                	test   %eax,%eax
8010621f:	79 07                	jns    80106228 <sys_kill+0x24>
    return -1;
80106221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106226:	eb 0b                	jmp    80106233 <sys_kill+0x2f>
  return kill(pid);
80106228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622b:	89 04 24             	mov    %eax,(%esp)
8010622e:	e8 84 e8 ff ff       	call   80104ab7 <kill>
}
80106233:	c9                   	leave  
80106234:	c3                   	ret    

80106235 <sys_getpid>:

int
sys_getpid(void)
{
80106235:	55                   	push   %ebp
80106236:	89 e5                	mov    %esp,%ebp
80106238:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010623b:	e8 37 df ff ff       	call   80104177 <myproc>
80106240:	8b 40 10             	mov    0x10(%eax),%eax
}
80106243:	c9                   	leave  
80106244:	c3                   	ret    

80106245 <sys_sbrk>:

int
sys_sbrk(void)
{
80106245:	55                   	push   %ebp
80106246:	89 e5                	mov    %esp,%ebp
80106248:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010624b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010624e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106252:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106259:	e8 bf f0 ff ff       	call   8010531d <argint>
8010625e:	85 c0                	test   %eax,%eax
80106260:	79 07                	jns    80106269 <sys_sbrk+0x24>
    return -1;
80106262:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106267:	eb 23                	jmp    8010628c <sys_sbrk+0x47>
  addr = myproc()->sz;
80106269:	e8 09 df ff ff       	call   80104177 <myproc>
8010626e:	8b 00                	mov    (%eax),%eax
80106270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106276:	89 04 24             	mov    %eax,(%esp)
80106279:	e8 57 e1 ff ff       	call   801043d5 <growproc>
8010627e:	85 c0                	test   %eax,%eax
80106280:	79 07                	jns    80106289 <sys_sbrk+0x44>
    return -1;
80106282:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106287:	eb 03                	jmp    8010628c <sys_sbrk+0x47>
  return addr;
80106289:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010628c:	c9                   	leave  
8010628d:	c3                   	ret    

8010628e <sys_sleep>:

int
sys_sleep(void)
{
8010628e:	55                   	push   %ebp
8010628f:	89 e5                	mov    %esp,%ebp
80106291:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106294:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106297:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a2:	e8 76 f0 ff ff       	call   8010531d <argint>
801062a7:	85 c0                	test   %eax,%eax
801062a9:	79 07                	jns    801062b2 <sys_sleep+0x24>
    return -1;
801062ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b0:	eb 6b                	jmp    8010631d <sys_sleep+0x8f>
  acquire(&tickslock);
801062b2:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801062b9:	e8 c9 ea ff ff       	call   80104d87 <acquire>
  ticks0 = ticks;
801062be:	a1 20 65 11 80       	mov    0x80116520,%eax
801062c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801062c6:	eb 33                	jmp    801062fb <sys_sleep+0x6d>
    if(myproc()->killed){
801062c8:	e8 aa de ff ff       	call   80104177 <myproc>
801062cd:	8b 40 24             	mov    0x24(%eax),%eax
801062d0:	85 c0                	test   %eax,%eax
801062d2:	74 13                	je     801062e7 <sys_sleep+0x59>
      release(&tickslock);
801062d4:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801062db:	e8 11 eb ff ff       	call   80104df1 <release>
      return -1;
801062e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e5:	eb 36                	jmp    8010631d <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
801062e7:	c7 44 24 04 e0 5c 11 	movl   $0x80115ce0,0x4(%esp)
801062ee:	80 
801062ef:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
801062f6:	e8 bd e6 ff ff       	call   801049b8 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801062fb:	a1 20 65 11 80       	mov    0x80116520,%eax
80106300:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106303:	89 c2                	mov    %eax,%edx
80106305:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106308:	39 c2                	cmp    %eax,%edx
8010630a:	72 bc                	jb     801062c8 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010630c:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106313:	e8 d9 ea ff ff       	call   80104df1 <release>
  return 0;
80106318:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010631d:	c9                   	leave  
8010631e:	c3                   	ret    

8010631f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010631f:	55                   	push   %ebp
80106320:	89 e5                	mov    %esp,%ebp
80106322:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106325:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
8010632c:	e8 56 ea ff ff       	call   80104d87 <acquire>
  xticks = ticks;
80106331:	a1 20 65 11 80       	mov    0x80116520,%eax
80106336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106339:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
80106340:	e8 ac ea ff ff       	call   80104df1 <release>
  return xticks;
80106345:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106348:	c9                   	leave  
80106349:	c3                   	ret    
	...

8010634c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010634c:	1e                   	push   %ds
  pushl %es
8010634d:	06                   	push   %es
  pushl %fs
8010634e:	0f a0                	push   %fs
  pushl %gs
80106350:	0f a8                	push   %gs
  pushal
80106352:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106353:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106357:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106359:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010635b:	54                   	push   %esp
  call trap
8010635c:	e8 c0 01 00 00       	call   80106521 <trap>
  addl $4, %esp
80106361:	83 c4 04             	add    $0x4,%esp

80106364 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106364:	61                   	popa   
  popl %gs
80106365:	0f a9                	pop    %gs
  popl %fs
80106367:	0f a1                	pop    %fs
  popl %es
80106369:	07                   	pop    %es
  popl %ds
8010636a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010636b:	83 c4 08             	add    $0x8,%esp
  iret
8010636e:	cf                   	iret   
	...

80106370 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106376:	8b 45 0c             	mov    0xc(%ebp),%eax
80106379:	48                   	dec    %eax
8010637a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010637e:	8b 45 08             	mov    0x8(%ebp),%eax
80106381:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106385:	8b 45 08             	mov    0x8(%ebp),%eax
80106388:	c1 e8 10             	shr    $0x10,%eax
8010638b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010638f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106392:	0f 01 18             	lidtl  (%eax)
}
80106395:	c9                   	leave  
80106396:	c3                   	ret    

80106397 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106397:	55                   	push   %ebp
80106398:	89 e5                	mov    %esp,%ebp
8010639a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010639d:	0f 20 d0             	mov    %cr2,%eax
801063a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801063a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063a6:	c9                   	leave  
801063a7:	c3                   	ret    

801063a8 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801063a8:	55                   	push   %ebp
801063a9:	89 e5                	mov    %esp,%ebp
801063ab:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801063ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063b5:	e9 b8 00 00 00       	jmp    80106472 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063bd:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
801063c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063c7:	66 89 04 d5 20 5d 11 	mov    %ax,-0x7feea2e0(,%edx,8)
801063ce:	80 
801063cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d2:	66 c7 04 c5 22 5d 11 	movw   $0x8,-0x7feea2de(,%eax,8)
801063d9:	80 08 00 
801063dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063df:	8a 14 c5 24 5d 11 80 	mov    -0x7feea2dc(,%eax,8),%dl
801063e6:	83 e2 e0             	and    $0xffffffe0,%edx
801063e9:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
801063f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f3:	8a 14 c5 24 5d 11 80 	mov    -0x7feea2dc(,%eax,8),%dl
801063fa:	83 e2 1f             	and    $0x1f,%edx
801063fd:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
80106404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106407:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
8010640e:	83 e2 f0             	and    $0xfffffff0,%edx
80106411:	83 ca 0e             	or     $0xe,%edx
80106414:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010641b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641e:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
80106425:	83 e2 ef             	and    $0xffffffef,%edx
80106428:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010642f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106432:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
80106439:	83 e2 9f             	and    $0xffffff9f,%edx
8010643c:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106446:	8a 14 c5 25 5d 11 80 	mov    -0x7feea2db(,%eax,8),%dl
8010644d:	83 ca 80             	or     $0xffffff80,%edx
80106450:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645a:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
80106461:	c1 e8 10             	shr    $0x10,%eax
80106464:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106467:	66 89 04 d5 26 5d 11 	mov    %ax,-0x7feea2da(,%edx,8)
8010646e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010646f:	ff 45 f4             	incl   -0xc(%ebp)
80106472:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106479:	0f 8e 3b ff ff ff    	jle    801063ba <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010647f:	a1 78 b1 10 80       	mov    0x8010b178,%eax
80106484:	66 a3 20 5f 11 80    	mov    %ax,0x80115f20
8010648a:	66 c7 05 22 5f 11 80 	movw   $0x8,0x80115f22
80106491:	08 00 
80106493:	a0 24 5f 11 80       	mov    0x80115f24,%al
80106498:	83 e0 e0             	and    $0xffffffe0,%eax
8010649b:	a2 24 5f 11 80       	mov    %al,0x80115f24
801064a0:	a0 24 5f 11 80       	mov    0x80115f24,%al
801064a5:	83 e0 1f             	and    $0x1f,%eax
801064a8:	a2 24 5f 11 80       	mov    %al,0x80115f24
801064ad:	a0 25 5f 11 80       	mov    0x80115f25,%al
801064b2:	83 c8 0f             	or     $0xf,%eax
801064b5:	a2 25 5f 11 80       	mov    %al,0x80115f25
801064ba:	a0 25 5f 11 80       	mov    0x80115f25,%al
801064bf:	83 e0 ef             	and    $0xffffffef,%eax
801064c2:	a2 25 5f 11 80       	mov    %al,0x80115f25
801064c7:	a0 25 5f 11 80       	mov    0x80115f25,%al
801064cc:	83 c8 60             	or     $0x60,%eax
801064cf:	a2 25 5f 11 80       	mov    %al,0x80115f25
801064d4:	a0 25 5f 11 80       	mov    0x80115f25,%al
801064d9:	83 c8 80             	or     $0xffffff80,%eax
801064dc:	a2 25 5f 11 80       	mov    %al,0x80115f25
801064e1:	a1 78 b1 10 80       	mov    0x8010b178,%eax
801064e6:	c1 e8 10             	shr    $0x10,%eax
801064e9:	66 a3 26 5f 11 80    	mov    %ax,0x80115f26

  initlock(&tickslock, "time");
801064ef:	c7 44 24 04 50 86 10 	movl   $0x80108650,0x4(%esp)
801064f6:	80 
801064f7:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801064fe:	e8 63 e8 ff ff       	call   80104d66 <initlock>
}
80106503:	c9                   	leave  
80106504:	c3                   	ret    

80106505 <idtinit>:

void
idtinit(void)
{
80106505:	55                   	push   %ebp
80106506:	89 e5                	mov    %esp,%ebp
80106508:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010650b:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106512:	00 
80106513:	c7 04 24 20 5d 11 80 	movl   $0x80115d20,(%esp)
8010651a:	e8 51 fe ff ff       	call   80106370 <lidt>
}
8010651f:	c9                   	leave  
80106520:	c3                   	ret    

80106521 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106521:	55                   	push   %ebp
80106522:	89 e5                	mov    %esp,%ebp
80106524:	57                   	push   %edi
80106525:	56                   	push   %esi
80106526:	53                   	push   %ebx
80106527:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010652a:	8b 45 08             	mov    0x8(%ebp),%eax
8010652d:	8b 40 30             	mov    0x30(%eax),%eax
80106530:	83 f8 40             	cmp    $0x40,%eax
80106533:	75 3c                	jne    80106571 <trap+0x50>
    if(myproc()->killed)
80106535:	e8 3d dc ff ff       	call   80104177 <myproc>
8010653a:	8b 40 24             	mov    0x24(%eax),%eax
8010653d:	85 c0                	test   %eax,%eax
8010653f:	74 05                	je     80106546 <trap+0x25>
      exit();
80106541:	e8 93 e0 ff ff       	call   801045d9 <exit>
    myproc()->tf = tf;
80106546:	e8 2c dc ff ff       	call   80104177 <myproc>
8010654b:	8b 55 08             	mov    0x8(%ebp),%edx
8010654e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106551:	e8 95 ee ff ff       	call   801053eb <syscall>
    if(myproc()->killed)
80106556:	e8 1c dc ff ff       	call   80104177 <myproc>
8010655b:	8b 40 24             	mov    0x24(%eax),%eax
8010655e:	85 c0                	test   %eax,%eax
80106560:	74 0a                	je     8010656c <trap+0x4b>
      exit();
80106562:	e8 72 e0 ff ff       	call   801045d9 <exit>
    return;
80106567:	e9 13 02 00 00       	jmp    8010677f <trap+0x25e>
8010656c:	e9 0e 02 00 00       	jmp    8010677f <trap+0x25e>
  }

  switch(tf->trapno){
80106571:	8b 45 08             	mov    0x8(%ebp),%eax
80106574:	8b 40 30             	mov    0x30(%eax),%eax
80106577:	83 e8 20             	sub    $0x20,%eax
8010657a:	83 f8 1f             	cmp    $0x1f,%eax
8010657d:	0f 87 ae 00 00 00    	ja     80106631 <trap+0x110>
80106583:	8b 04 85 f8 86 10 80 	mov    -0x7fef7908(,%eax,4),%eax
8010658a:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010658c:	e8 1d db ff ff       	call   801040ae <cpuid>
80106591:	85 c0                	test   %eax,%eax
80106593:	75 2f                	jne    801065c4 <trap+0xa3>
      acquire(&tickslock);
80106595:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
8010659c:	e8 e6 e7 ff ff       	call   80104d87 <acquire>
      ticks++;
801065a1:	a1 20 65 11 80       	mov    0x80116520,%eax
801065a6:	40                   	inc    %eax
801065a7:	a3 20 65 11 80       	mov    %eax,0x80116520
      wakeup(&ticks);
801065ac:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
801065b3:	e8 d4 e4 ff ff       	call   80104a8c <wakeup>
      release(&tickslock);
801065b8:	c7 04 24 e0 5c 11 80 	movl   $0x80115ce0,(%esp)
801065bf:	e8 2d e8 ff ff       	call   80104df1 <release>
    }
    lapiceoi();
801065c4:	e8 8e c9 ff ff       	call   80102f57 <lapiceoi>
    break;
801065c9:	e9 35 01 00 00       	jmp    80106703 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065ce:	e8 03 c2 ff ff       	call   801027d6 <ideintr>
    lapiceoi();
801065d3:	e8 7f c9 ff ff       	call   80102f57 <lapiceoi>
    break;
801065d8:	e9 26 01 00 00       	jmp    80106703 <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801065dd:	e8 8c c7 ff ff       	call   80102d6e <kbdintr>
    lapiceoi();
801065e2:	e8 70 c9 ff ff       	call   80102f57 <lapiceoi>
    break;
801065e7:	e9 17 01 00 00       	jmp    80106703 <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801065ec:	e8 70 03 00 00       	call   80106961 <uartintr>
    lapiceoi();
801065f1:	e8 61 c9 ff ff       	call   80102f57 <lapiceoi>
    break;
801065f6:	e9 08 01 00 00       	jmp    80106703 <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065fb:	8b 45 08             	mov    0x8(%ebp),%eax
801065fe:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106601:	8b 45 08             	mov    0x8(%ebp),%eax
80106604:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106607:	0f b7 d8             	movzwl %ax,%ebx
8010660a:	e8 9f da ff ff       	call   801040ae <cpuid>
8010660f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106613:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106617:	89 44 24 04          	mov    %eax,0x4(%esp)
8010661b:	c7 04 24 58 86 10 80 	movl   $0x80108658,(%esp)
80106622:	e8 9a 9d ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106627:	e8 2b c9 ff ff       	call   80102f57 <lapiceoi>
    break;
8010662c:	e9 d2 00 00 00       	jmp    80106703 <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106631:	e8 41 db ff ff       	call   80104177 <myproc>
80106636:	85 c0                	test   %eax,%eax
80106638:	74 10                	je     8010664a <trap+0x129>
8010663a:	8b 45 08             	mov    0x8(%ebp),%eax
8010663d:	8b 40 3c             	mov    0x3c(%eax),%eax
80106640:	0f b7 c0             	movzwl %ax,%eax
80106643:	83 e0 03             	and    $0x3,%eax
80106646:	85 c0                	test   %eax,%eax
80106648:	75 40                	jne    8010668a <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010664a:	e8 48 fd ff ff       	call   80106397 <rcr2>
8010664f:	89 c3                	mov    %eax,%ebx
80106651:	8b 45 08             	mov    0x8(%ebp),%eax
80106654:	8b 70 38             	mov    0x38(%eax),%esi
80106657:	e8 52 da ff ff       	call   801040ae <cpuid>
8010665c:	8b 55 08             	mov    0x8(%ebp),%edx
8010665f:	8b 52 30             	mov    0x30(%edx),%edx
80106662:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106666:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010666a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010666e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106672:	c7 04 24 7c 86 10 80 	movl   $0x8010867c,(%esp)
80106679:	e8 43 9d ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010667e:	c7 04 24 ae 86 10 80 	movl   $0x801086ae,(%esp)
80106685:	e8 ca 9e ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010668a:	e8 08 fd ff ff       	call   80106397 <rcr2>
8010668f:	89 c6                	mov    %eax,%esi
80106691:	8b 45 08             	mov    0x8(%ebp),%eax
80106694:	8b 40 38             	mov    0x38(%eax),%eax
80106697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010669a:	e8 0f da ff ff       	call   801040ae <cpuid>
8010669f:	89 c3                	mov    %eax,%ebx
801066a1:	8b 45 08             	mov    0x8(%ebp),%eax
801066a4:	8b 78 34             	mov    0x34(%eax),%edi
801066a7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801066aa:	8b 45 08             	mov    0x8(%ebp),%eax
801066ad:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066b0:	e8 c2 da ff ff       	call   80104177 <myproc>
801066b5:	8d 50 6c             	lea    0x6c(%eax),%edx
801066b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066bb:	e8 b7 da ff ff       	call   80104177 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066c0:	8b 40 10             	mov    0x10(%eax),%eax
801066c3:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801066c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801066ca:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801066ce:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801066d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801066d5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801066d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801066dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066e0:	89 54 24 08          	mov    %edx,0x8(%esp)
801066e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801066e8:	c7 04 24 b4 86 10 80 	movl   $0x801086b4,(%esp)
801066ef:	e8 cd 9c ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066f4:	e8 7e da ff ff       	call   80104177 <myproc>
801066f9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106700:	eb 01                	jmp    80106703 <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106702:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106703:	e8 6f da ff ff       	call   80104177 <myproc>
80106708:	85 c0                	test   %eax,%eax
8010670a:	74 22                	je     8010672e <trap+0x20d>
8010670c:	e8 66 da ff ff       	call   80104177 <myproc>
80106711:	8b 40 24             	mov    0x24(%eax),%eax
80106714:	85 c0                	test   %eax,%eax
80106716:	74 16                	je     8010672e <trap+0x20d>
80106718:	8b 45 08             	mov    0x8(%ebp),%eax
8010671b:	8b 40 3c             	mov    0x3c(%eax),%eax
8010671e:	0f b7 c0             	movzwl %ax,%eax
80106721:	83 e0 03             	and    $0x3,%eax
80106724:	83 f8 03             	cmp    $0x3,%eax
80106727:	75 05                	jne    8010672e <trap+0x20d>
    exit();
80106729:	e8 ab de ff ff       	call   801045d9 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010672e:	e8 44 da ff ff       	call   80104177 <myproc>
80106733:	85 c0                	test   %eax,%eax
80106735:	74 1d                	je     80106754 <trap+0x233>
80106737:	e8 3b da ff ff       	call   80104177 <myproc>
8010673c:	8b 40 0c             	mov    0xc(%eax),%eax
8010673f:	83 f8 04             	cmp    $0x4,%eax
80106742:	75 10                	jne    80106754 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106744:	8b 45 08             	mov    0x8(%ebp),%eax
80106747:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010674a:	83 f8 20             	cmp    $0x20,%eax
8010674d:	75 05                	jne    80106754 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010674f:	e8 f4 e1 ff ff       	call   80104948 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106754:	e8 1e da ff ff       	call   80104177 <myproc>
80106759:	85 c0                	test   %eax,%eax
8010675b:	74 22                	je     8010677f <trap+0x25e>
8010675d:	e8 15 da ff ff       	call   80104177 <myproc>
80106762:	8b 40 24             	mov    0x24(%eax),%eax
80106765:	85 c0                	test   %eax,%eax
80106767:	74 16                	je     8010677f <trap+0x25e>
80106769:	8b 45 08             	mov    0x8(%ebp),%eax
8010676c:	8b 40 3c             	mov    0x3c(%eax),%eax
8010676f:	0f b7 c0             	movzwl %ax,%eax
80106772:	83 e0 03             	and    $0x3,%eax
80106775:	83 f8 03             	cmp    $0x3,%eax
80106778:	75 05                	jne    8010677f <trap+0x25e>
    exit();
8010677a:	e8 5a de ff ff       	call   801045d9 <exit>
}
8010677f:	83 c4 3c             	add    $0x3c,%esp
80106782:	5b                   	pop    %ebx
80106783:	5e                   	pop    %esi
80106784:	5f                   	pop    %edi
80106785:	5d                   	pop    %ebp
80106786:	c3                   	ret    
	...

80106788 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106788:	55                   	push   %ebp
80106789:	89 e5                	mov    %esp,%ebp
8010678b:	83 ec 14             	sub    $0x14,%esp
8010678e:	8b 45 08             	mov    0x8(%ebp),%eax
80106791:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106795:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106798:	89 c2                	mov    %eax,%edx
8010679a:	ec                   	in     (%dx),%al
8010679b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010679e:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801067a1:	c9                   	leave  
801067a2:	c3                   	ret    

801067a3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067a3:	55                   	push   %ebp
801067a4:	89 e5                	mov    %esp,%ebp
801067a6:	83 ec 08             	sub    $0x8,%esp
801067a9:	8b 45 08             	mov    0x8(%ebp),%eax
801067ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801067af:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801067b3:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067b6:	8a 45 f8             	mov    -0x8(%ebp),%al
801067b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067bc:	ee                   	out    %al,(%dx)
}
801067bd:	c9                   	leave  
801067be:	c3                   	ret    

801067bf <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067bf:	55                   	push   %ebp
801067c0:	89 e5                	mov    %esp,%ebp
801067c2:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801067c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067cc:	00 
801067cd:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067d4:	e8 ca ff ff ff       	call   801067a3 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801067d9:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801067e0:	00 
801067e1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067e8:	e8 b6 ff ff ff       	call   801067a3 <outb>
  outb(COM1+0, 115200/9600);
801067ed:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801067f4:	00 
801067f5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801067fc:	e8 a2 ff ff ff       	call   801067a3 <outb>
  outb(COM1+1, 0);
80106801:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106808:	00 
80106809:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106810:	e8 8e ff ff ff       	call   801067a3 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106815:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010681c:	00 
8010681d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106824:	e8 7a ff ff ff       	call   801067a3 <outb>
  outb(COM1+4, 0);
80106829:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106830:	00 
80106831:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106838:	e8 66 ff ff ff       	call   801067a3 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010683d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106844:	00 
80106845:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010684c:	e8 52 ff ff ff       	call   801067a3 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106851:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106858:	e8 2b ff ff ff       	call   80106788 <inb>
8010685d:	3c ff                	cmp    $0xff,%al
8010685f:	75 02                	jne    80106863 <uartinit+0xa4>
    return;
80106861:	eb 5b                	jmp    801068be <uartinit+0xff>
  uart = 1;
80106863:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
8010686a:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010686d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106874:	e8 0f ff ff ff       	call   80106788 <inb>
  inb(COM1+0);
80106879:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106880:	e8 03 ff ff ff       	call   80106788 <inb>
  ioapicenable(IRQ_COM1, 0);
80106885:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010688c:	00 
8010688d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106894:	e8 b2 c1 ff ff       	call   80102a4b <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106899:	c7 45 f4 78 87 10 80 	movl   $0x80108778,-0xc(%ebp)
801068a0:	eb 13                	jmp    801068b5 <uartinit+0xf6>
    uartputc(*p);
801068a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a5:	8a 00                	mov    (%eax),%al
801068a7:	0f be c0             	movsbl %al,%eax
801068aa:	89 04 24             	mov    %eax,(%esp)
801068ad:	e8 0e 00 00 00       	call   801068c0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068b2:	ff 45 f4             	incl   -0xc(%ebp)
801068b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b8:	8a 00                	mov    (%eax),%al
801068ba:	84 c0                	test   %al,%al
801068bc:	75 e4                	jne    801068a2 <uartinit+0xe3>
    uartputc(*p);
}
801068be:	c9                   	leave  
801068bf:	c3                   	ret    

801068c0 <uartputc>:

void
uartputc(int c)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801068c6:	a1 24 b6 10 80       	mov    0x8010b624,%eax
801068cb:	85 c0                	test   %eax,%eax
801068cd:	75 02                	jne    801068d1 <uartputc+0x11>
    return;
801068cf:	eb 4a                	jmp    8010691b <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068d8:	eb 0f                	jmp    801068e9 <uartputc+0x29>
    microdelay(10);
801068da:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801068e1:	e8 96 c6 ff ff       	call   80102f7c <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068e6:	ff 45 f4             	incl   -0xc(%ebp)
801068e9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801068ed:	7f 16                	jg     80106905 <uartputc+0x45>
801068ef:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068f6:	e8 8d fe ff ff       	call   80106788 <inb>
801068fb:	0f b6 c0             	movzbl %al,%eax
801068fe:	83 e0 20             	and    $0x20,%eax
80106901:	85 c0                	test   %eax,%eax
80106903:	74 d5                	je     801068da <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106905:	8b 45 08             	mov    0x8(%ebp),%eax
80106908:	0f b6 c0             	movzbl %al,%eax
8010690b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106916:	e8 88 fe ff ff       	call   801067a3 <outb>
}
8010691b:	c9                   	leave  
8010691c:	c3                   	ret    

8010691d <uartgetc>:

static int
uartgetc(void)
{
8010691d:	55                   	push   %ebp
8010691e:	89 e5                	mov    %esp,%ebp
80106920:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106923:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106928:	85 c0                	test   %eax,%eax
8010692a:	75 07                	jne    80106933 <uartgetc+0x16>
    return -1;
8010692c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106931:	eb 2c                	jmp    8010695f <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106933:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010693a:	e8 49 fe ff ff       	call   80106788 <inb>
8010693f:	0f b6 c0             	movzbl %al,%eax
80106942:	83 e0 01             	and    $0x1,%eax
80106945:	85 c0                	test   %eax,%eax
80106947:	75 07                	jne    80106950 <uartgetc+0x33>
    return -1;
80106949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694e:	eb 0f                	jmp    8010695f <uartgetc+0x42>
  return inb(COM1+0);
80106950:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106957:	e8 2c fe ff ff       	call   80106788 <inb>
8010695c:	0f b6 c0             	movzbl %al,%eax
}
8010695f:	c9                   	leave  
80106960:	c3                   	ret    

80106961 <uartintr>:

void
uartintr(void)
{
80106961:	55                   	push   %ebp
80106962:	89 e5                	mov    %esp,%ebp
80106964:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106967:	c7 04 24 1d 69 10 80 	movl   $0x8010691d,(%esp)
8010696e:	e8 52 9e ff ff       	call   801007c5 <consoleintr>
}
80106973:	c9                   	leave  
80106974:	c3                   	ret    
80106975:	00 00                	add    %al,(%eax)
	...

80106978 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $0
8010697a:	6a 00                	push   $0x0
  jmp alltraps
8010697c:	e9 cb f9 ff ff       	jmp    8010634c <alltraps>

80106981 <vector1>:
.globl vector1
vector1:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $1
80106983:	6a 01                	push   $0x1
  jmp alltraps
80106985:	e9 c2 f9 ff ff       	jmp    8010634c <alltraps>

8010698a <vector2>:
.globl vector2
vector2:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $2
8010698c:	6a 02                	push   $0x2
  jmp alltraps
8010698e:	e9 b9 f9 ff ff       	jmp    8010634c <alltraps>

80106993 <vector3>:
.globl vector3
vector3:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $3
80106995:	6a 03                	push   $0x3
  jmp alltraps
80106997:	e9 b0 f9 ff ff       	jmp    8010634c <alltraps>

8010699c <vector4>:
.globl vector4
vector4:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $4
8010699e:	6a 04                	push   $0x4
  jmp alltraps
801069a0:	e9 a7 f9 ff ff       	jmp    8010634c <alltraps>

801069a5 <vector5>:
.globl vector5
vector5:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $5
801069a7:	6a 05                	push   $0x5
  jmp alltraps
801069a9:	e9 9e f9 ff ff       	jmp    8010634c <alltraps>

801069ae <vector6>:
.globl vector6
vector6:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $6
801069b0:	6a 06                	push   $0x6
  jmp alltraps
801069b2:	e9 95 f9 ff ff       	jmp    8010634c <alltraps>

801069b7 <vector7>:
.globl vector7
vector7:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $7
801069b9:	6a 07                	push   $0x7
  jmp alltraps
801069bb:	e9 8c f9 ff ff       	jmp    8010634c <alltraps>

801069c0 <vector8>:
.globl vector8
vector8:
  pushl $8
801069c0:	6a 08                	push   $0x8
  jmp alltraps
801069c2:	e9 85 f9 ff ff       	jmp    8010634c <alltraps>

801069c7 <vector9>:
.globl vector9
vector9:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $9
801069c9:	6a 09                	push   $0x9
  jmp alltraps
801069cb:	e9 7c f9 ff ff       	jmp    8010634c <alltraps>

801069d0 <vector10>:
.globl vector10
vector10:
  pushl $10
801069d0:	6a 0a                	push   $0xa
  jmp alltraps
801069d2:	e9 75 f9 ff ff       	jmp    8010634c <alltraps>

801069d7 <vector11>:
.globl vector11
vector11:
  pushl $11
801069d7:	6a 0b                	push   $0xb
  jmp alltraps
801069d9:	e9 6e f9 ff ff       	jmp    8010634c <alltraps>

801069de <vector12>:
.globl vector12
vector12:
  pushl $12
801069de:	6a 0c                	push   $0xc
  jmp alltraps
801069e0:	e9 67 f9 ff ff       	jmp    8010634c <alltraps>

801069e5 <vector13>:
.globl vector13
vector13:
  pushl $13
801069e5:	6a 0d                	push   $0xd
  jmp alltraps
801069e7:	e9 60 f9 ff ff       	jmp    8010634c <alltraps>

801069ec <vector14>:
.globl vector14
vector14:
  pushl $14
801069ec:	6a 0e                	push   $0xe
  jmp alltraps
801069ee:	e9 59 f9 ff ff       	jmp    8010634c <alltraps>

801069f3 <vector15>:
.globl vector15
vector15:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $15
801069f5:	6a 0f                	push   $0xf
  jmp alltraps
801069f7:	e9 50 f9 ff ff       	jmp    8010634c <alltraps>

801069fc <vector16>:
.globl vector16
vector16:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $16
801069fe:	6a 10                	push   $0x10
  jmp alltraps
80106a00:	e9 47 f9 ff ff       	jmp    8010634c <alltraps>

80106a05 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a05:	6a 11                	push   $0x11
  jmp alltraps
80106a07:	e9 40 f9 ff ff       	jmp    8010634c <alltraps>

80106a0c <vector18>:
.globl vector18
vector18:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $18
80106a0e:	6a 12                	push   $0x12
  jmp alltraps
80106a10:	e9 37 f9 ff ff       	jmp    8010634c <alltraps>

80106a15 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $19
80106a17:	6a 13                	push   $0x13
  jmp alltraps
80106a19:	e9 2e f9 ff ff       	jmp    8010634c <alltraps>

80106a1e <vector20>:
.globl vector20
vector20:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $20
80106a20:	6a 14                	push   $0x14
  jmp alltraps
80106a22:	e9 25 f9 ff ff       	jmp    8010634c <alltraps>

80106a27 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $21
80106a29:	6a 15                	push   $0x15
  jmp alltraps
80106a2b:	e9 1c f9 ff ff       	jmp    8010634c <alltraps>

80106a30 <vector22>:
.globl vector22
vector22:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $22
80106a32:	6a 16                	push   $0x16
  jmp alltraps
80106a34:	e9 13 f9 ff ff       	jmp    8010634c <alltraps>

80106a39 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $23
80106a3b:	6a 17                	push   $0x17
  jmp alltraps
80106a3d:	e9 0a f9 ff ff       	jmp    8010634c <alltraps>

80106a42 <vector24>:
.globl vector24
vector24:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $24
80106a44:	6a 18                	push   $0x18
  jmp alltraps
80106a46:	e9 01 f9 ff ff       	jmp    8010634c <alltraps>

80106a4b <vector25>:
.globl vector25
vector25:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $25
80106a4d:	6a 19                	push   $0x19
  jmp alltraps
80106a4f:	e9 f8 f8 ff ff       	jmp    8010634c <alltraps>

80106a54 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $26
80106a56:	6a 1a                	push   $0x1a
  jmp alltraps
80106a58:	e9 ef f8 ff ff       	jmp    8010634c <alltraps>

80106a5d <vector27>:
.globl vector27
vector27:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $27
80106a5f:	6a 1b                	push   $0x1b
  jmp alltraps
80106a61:	e9 e6 f8 ff ff       	jmp    8010634c <alltraps>

80106a66 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $28
80106a68:	6a 1c                	push   $0x1c
  jmp alltraps
80106a6a:	e9 dd f8 ff ff       	jmp    8010634c <alltraps>

80106a6f <vector29>:
.globl vector29
vector29:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $29
80106a71:	6a 1d                	push   $0x1d
  jmp alltraps
80106a73:	e9 d4 f8 ff ff       	jmp    8010634c <alltraps>

80106a78 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $30
80106a7a:	6a 1e                	push   $0x1e
  jmp alltraps
80106a7c:	e9 cb f8 ff ff       	jmp    8010634c <alltraps>

80106a81 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $31
80106a83:	6a 1f                	push   $0x1f
  jmp alltraps
80106a85:	e9 c2 f8 ff ff       	jmp    8010634c <alltraps>

80106a8a <vector32>:
.globl vector32
vector32:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $32
80106a8c:	6a 20                	push   $0x20
  jmp alltraps
80106a8e:	e9 b9 f8 ff ff       	jmp    8010634c <alltraps>

80106a93 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $33
80106a95:	6a 21                	push   $0x21
  jmp alltraps
80106a97:	e9 b0 f8 ff ff       	jmp    8010634c <alltraps>

80106a9c <vector34>:
.globl vector34
vector34:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $34
80106a9e:	6a 22                	push   $0x22
  jmp alltraps
80106aa0:	e9 a7 f8 ff ff       	jmp    8010634c <alltraps>

80106aa5 <vector35>:
.globl vector35
vector35:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $35
80106aa7:	6a 23                	push   $0x23
  jmp alltraps
80106aa9:	e9 9e f8 ff ff       	jmp    8010634c <alltraps>

80106aae <vector36>:
.globl vector36
vector36:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $36
80106ab0:	6a 24                	push   $0x24
  jmp alltraps
80106ab2:	e9 95 f8 ff ff       	jmp    8010634c <alltraps>

80106ab7 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $37
80106ab9:	6a 25                	push   $0x25
  jmp alltraps
80106abb:	e9 8c f8 ff ff       	jmp    8010634c <alltraps>

80106ac0 <vector38>:
.globl vector38
vector38:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $38
80106ac2:	6a 26                	push   $0x26
  jmp alltraps
80106ac4:	e9 83 f8 ff ff       	jmp    8010634c <alltraps>

80106ac9 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $39
80106acb:	6a 27                	push   $0x27
  jmp alltraps
80106acd:	e9 7a f8 ff ff       	jmp    8010634c <alltraps>

80106ad2 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $40
80106ad4:	6a 28                	push   $0x28
  jmp alltraps
80106ad6:	e9 71 f8 ff ff       	jmp    8010634c <alltraps>

80106adb <vector41>:
.globl vector41
vector41:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $41
80106add:	6a 29                	push   $0x29
  jmp alltraps
80106adf:	e9 68 f8 ff ff       	jmp    8010634c <alltraps>

80106ae4 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $42
80106ae6:	6a 2a                	push   $0x2a
  jmp alltraps
80106ae8:	e9 5f f8 ff ff       	jmp    8010634c <alltraps>

80106aed <vector43>:
.globl vector43
vector43:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $43
80106aef:	6a 2b                	push   $0x2b
  jmp alltraps
80106af1:	e9 56 f8 ff ff       	jmp    8010634c <alltraps>

80106af6 <vector44>:
.globl vector44
vector44:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $44
80106af8:	6a 2c                	push   $0x2c
  jmp alltraps
80106afa:	e9 4d f8 ff ff       	jmp    8010634c <alltraps>

80106aff <vector45>:
.globl vector45
vector45:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $45
80106b01:	6a 2d                	push   $0x2d
  jmp alltraps
80106b03:	e9 44 f8 ff ff       	jmp    8010634c <alltraps>

80106b08 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $46
80106b0a:	6a 2e                	push   $0x2e
  jmp alltraps
80106b0c:	e9 3b f8 ff ff       	jmp    8010634c <alltraps>

80106b11 <vector47>:
.globl vector47
vector47:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $47
80106b13:	6a 2f                	push   $0x2f
  jmp alltraps
80106b15:	e9 32 f8 ff ff       	jmp    8010634c <alltraps>

80106b1a <vector48>:
.globl vector48
vector48:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $48
80106b1c:	6a 30                	push   $0x30
  jmp alltraps
80106b1e:	e9 29 f8 ff ff       	jmp    8010634c <alltraps>

80106b23 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $49
80106b25:	6a 31                	push   $0x31
  jmp alltraps
80106b27:	e9 20 f8 ff ff       	jmp    8010634c <alltraps>

80106b2c <vector50>:
.globl vector50
vector50:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $50
80106b2e:	6a 32                	push   $0x32
  jmp alltraps
80106b30:	e9 17 f8 ff ff       	jmp    8010634c <alltraps>

80106b35 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $51
80106b37:	6a 33                	push   $0x33
  jmp alltraps
80106b39:	e9 0e f8 ff ff       	jmp    8010634c <alltraps>

80106b3e <vector52>:
.globl vector52
vector52:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $52
80106b40:	6a 34                	push   $0x34
  jmp alltraps
80106b42:	e9 05 f8 ff ff       	jmp    8010634c <alltraps>

80106b47 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $53
80106b49:	6a 35                	push   $0x35
  jmp alltraps
80106b4b:	e9 fc f7 ff ff       	jmp    8010634c <alltraps>

80106b50 <vector54>:
.globl vector54
vector54:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $54
80106b52:	6a 36                	push   $0x36
  jmp alltraps
80106b54:	e9 f3 f7 ff ff       	jmp    8010634c <alltraps>

80106b59 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $55
80106b5b:	6a 37                	push   $0x37
  jmp alltraps
80106b5d:	e9 ea f7 ff ff       	jmp    8010634c <alltraps>

80106b62 <vector56>:
.globl vector56
vector56:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $56
80106b64:	6a 38                	push   $0x38
  jmp alltraps
80106b66:	e9 e1 f7 ff ff       	jmp    8010634c <alltraps>

80106b6b <vector57>:
.globl vector57
vector57:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $57
80106b6d:	6a 39                	push   $0x39
  jmp alltraps
80106b6f:	e9 d8 f7 ff ff       	jmp    8010634c <alltraps>

80106b74 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $58
80106b76:	6a 3a                	push   $0x3a
  jmp alltraps
80106b78:	e9 cf f7 ff ff       	jmp    8010634c <alltraps>

80106b7d <vector59>:
.globl vector59
vector59:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $59
80106b7f:	6a 3b                	push   $0x3b
  jmp alltraps
80106b81:	e9 c6 f7 ff ff       	jmp    8010634c <alltraps>

80106b86 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $60
80106b88:	6a 3c                	push   $0x3c
  jmp alltraps
80106b8a:	e9 bd f7 ff ff       	jmp    8010634c <alltraps>

80106b8f <vector61>:
.globl vector61
vector61:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $61
80106b91:	6a 3d                	push   $0x3d
  jmp alltraps
80106b93:	e9 b4 f7 ff ff       	jmp    8010634c <alltraps>

80106b98 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $62
80106b9a:	6a 3e                	push   $0x3e
  jmp alltraps
80106b9c:	e9 ab f7 ff ff       	jmp    8010634c <alltraps>

80106ba1 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $63
80106ba3:	6a 3f                	push   $0x3f
  jmp alltraps
80106ba5:	e9 a2 f7 ff ff       	jmp    8010634c <alltraps>

80106baa <vector64>:
.globl vector64
vector64:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $64
80106bac:	6a 40                	push   $0x40
  jmp alltraps
80106bae:	e9 99 f7 ff ff       	jmp    8010634c <alltraps>

80106bb3 <vector65>:
.globl vector65
vector65:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $65
80106bb5:	6a 41                	push   $0x41
  jmp alltraps
80106bb7:	e9 90 f7 ff ff       	jmp    8010634c <alltraps>

80106bbc <vector66>:
.globl vector66
vector66:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $66
80106bbe:	6a 42                	push   $0x42
  jmp alltraps
80106bc0:	e9 87 f7 ff ff       	jmp    8010634c <alltraps>

80106bc5 <vector67>:
.globl vector67
vector67:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $67
80106bc7:	6a 43                	push   $0x43
  jmp alltraps
80106bc9:	e9 7e f7 ff ff       	jmp    8010634c <alltraps>

80106bce <vector68>:
.globl vector68
vector68:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $68
80106bd0:	6a 44                	push   $0x44
  jmp alltraps
80106bd2:	e9 75 f7 ff ff       	jmp    8010634c <alltraps>

80106bd7 <vector69>:
.globl vector69
vector69:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $69
80106bd9:	6a 45                	push   $0x45
  jmp alltraps
80106bdb:	e9 6c f7 ff ff       	jmp    8010634c <alltraps>

80106be0 <vector70>:
.globl vector70
vector70:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $70
80106be2:	6a 46                	push   $0x46
  jmp alltraps
80106be4:	e9 63 f7 ff ff       	jmp    8010634c <alltraps>

80106be9 <vector71>:
.globl vector71
vector71:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $71
80106beb:	6a 47                	push   $0x47
  jmp alltraps
80106bed:	e9 5a f7 ff ff       	jmp    8010634c <alltraps>

80106bf2 <vector72>:
.globl vector72
vector72:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $72
80106bf4:	6a 48                	push   $0x48
  jmp alltraps
80106bf6:	e9 51 f7 ff ff       	jmp    8010634c <alltraps>

80106bfb <vector73>:
.globl vector73
vector73:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $73
80106bfd:	6a 49                	push   $0x49
  jmp alltraps
80106bff:	e9 48 f7 ff ff       	jmp    8010634c <alltraps>

80106c04 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $74
80106c06:	6a 4a                	push   $0x4a
  jmp alltraps
80106c08:	e9 3f f7 ff ff       	jmp    8010634c <alltraps>

80106c0d <vector75>:
.globl vector75
vector75:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $75
80106c0f:	6a 4b                	push   $0x4b
  jmp alltraps
80106c11:	e9 36 f7 ff ff       	jmp    8010634c <alltraps>

80106c16 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $76
80106c18:	6a 4c                	push   $0x4c
  jmp alltraps
80106c1a:	e9 2d f7 ff ff       	jmp    8010634c <alltraps>

80106c1f <vector77>:
.globl vector77
vector77:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $77
80106c21:	6a 4d                	push   $0x4d
  jmp alltraps
80106c23:	e9 24 f7 ff ff       	jmp    8010634c <alltraps>

80106c28 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $78
80106c2a:	6a 4e                	push   $0x4e
  jmp alltraps
80106c2c:	e9 1b f7 ff ff       	jmp    8010634c <alltraps>

80106c31 <vector79>:
.globl vector79
vector79:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $79
80106c33:	6a 4f                	push   $0x4f
  jmp alltraps
80106c35:	e9 12 f7 ff ff       	jmp    8010634c <alltraps>

80106c3a <vector80>:
.globl vector80
vector80:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $80
80106c3c:	6a 50                	push   $0x50
  jmp alltraps
80106c3e:	e9 09 f7 ff ff       	jmp    8010634c <alltraps>

80106c43 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $81
80106c45:	6a 51                	push   $0x51
  jmp alltraps
80106c47:	e9 00 f7 ff ff       	jmp    8010634c <alltraps>

80106c4c <vector82>:
.globl vector82
vector82:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $82
80106c4e:	6a 52                	push   $0x52
  jmp alltraps
80106c50:	e9 f7 f6 ff ff       	jmp    8010634c <alltraps>

80106c55 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $83
80106c57:	6a 53                	push   $0x53
  jmp alltraps
80106c59:	e9 ee f6 ff ff       	jmp    8010634c <alltraps>

80106c5e <vector84>:
.globl vector84
vector84:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $84
80106c60:	6a 54                	push   $0x54
  jmp alltraps
80106c62:	e9 e5 f6 ff ff       	jmp    8010634c <alltraps>

80106c67 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $85
80106c69:	6a 55                	push   $0x55
  jmp alltraps
80106c6b:	e9 dc f6 ff ff       	jmp    8010634c <alltraps>

80106c70 <vector86>:
.globl vector86
vector86:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $86
80106c72:	6a 56                	push   $0x56
  jmp alltraps
80106c74:	e9 d3 f6 ff ff       	jmp    8010634c <alltraps>

80106c79 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $87
80106c7b:	6a 57                	push   $0x57
  jmp alltraps
80106c7d:	e9 ca f6 ff ff       	jmp    8010634c <alltraps>

80106c82 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $88
80106c84:	6a 58                	push   $0x58
  jmp alltraps
80106c86:	e9 c1 f6 ff ff       	jmp    8010634c <alltraps>

80106c8b <vector89>:
.globl vector89
vector89:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $89
80106c8d:	6a 59                	push   $0x59
  jmp alltraps
80106c8f:	e9 b8 f6 ff ff       	jmp    8010634c <alltraps>

80106c94 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $90
80106c96:	6a 5a                	push   $0x5a
  jmp alltraps
80106c98:	e9 af f6 ff ff       	jmp    8010634c <alltraps>

80106c9d <vector91>:
.globl vector91
vector91:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $91
80106c9f:	6a 5b                	push   $0x5b
  jmp alltraps
80106ca1:	e9 a6 f6 ff ff       	jmp    8010634c <alltraps>

80106ca6 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $92
80106ca8:	6a 5c                	push   $0x5c
  jmp alltraps
80106caa:	e9 9d f6 ff ff       	jmp    8010634c <alltraps>

80106caf <vector93>:
.globl vector93
vector93:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $93
80106cb1:	6a 5d                	push   $0x5d
  jmp alltraps
80106cb3:	e9 94 f6 ff ff       	jmp    8010634c <alltraps>

80106cb8 <vector94>:
.globl vector94
vector94:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $94
80106cba:	6a 5e                	push   $0x5e
  jmp alltraps
80106cbc:	e9 8b f6 ff ff       	jmp    8010634c <alltraps>

80106cc1 <vector95>:
.globl vector95
vector95:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $95
80106cc3:	6a 5f                	push   $0x5f
  jmp alltraps
80106cc5:	e9 82 f6 ff ff       	jmp    8010634c <alltraps>

80106cca <vector96>:
.globl vector96
vector96:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $96
80106ccc:	6a 60                	push   $0x60
  jmp alltraps
80106cce:	e9 79 f6 ff ff       	jmp    8010634c <alltraps>

80106cd3 <vector97>:
.globl vector97
vector97:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $97
80106cd5:	6a 61                	push   $0x61
  jmp alltraps
80106cd7:	e9 70 f6 ff ff       	jmp    8010634c <alltraps>

80106cdc <vector98>:
.globl vector98
vector98:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $98
80106cde:	6a 62                	push   $0x62
  jmp alltraps
80106ce0:	e9 67 f6 ff ff       	jmp    8010634c <alltraps>

80106ce5 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $99
80106ce7:	6a 63                	push   $0x63
  jmp alltraps
80106ce9:	e9 5e f6 ff ff       	jmp    8010634c <alltraps>

80106cee <vector100>:
.globl vector100
vector100:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $100
80106cf0:	6a 64                	push   $0x64
  jmp alltraps
80106cf2:	e9 55 f6 ff ff       	jmp    8010634c <alltraps>

80106cf7 <vector101>:
.globl vector101
vector101:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $101
80106cf9:	6a 65                	push   $0x65
  jmp alltraps
80106cfb:	e9 4c f6 ff ff       	jmp    8010634c <alltraps>

80106d00 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $102
80106d02:	6a 66                	push   $0x66
  jmp alltraps
80106d04:	e9 43 f6 ff ff       	jmp    8010634c <alltraps>

80106d09 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $103
80106d0b:	6a 67                	push   $0x67
  jmp alltraps
80106d0d:	e9 3a f6 ff ff       	jmp    8010634c <alltraps>

80106d12 <vector104>:
.globl vector104
vector104:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $104
80106d14:	6a 68                	push   $0x68
  jmp alltraps
80106d16:	e9 31 f6 ff ff       	jmp    8010634c <alltraps>

80106d1b <vector105>:
.globl vector105
vector105:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $105
80106d1d:	6a 69                	push   $0x69
  jmp alltraps
80106d1f:	e9 28 f6 ff ff       	jmp    8010634c <alltraps>

80106d24 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $106
80106d26:	6a 6a                	push   $0x6a
  jmp alltraps
80106d28:	e9 1f f6 ff ff       	jmp    8010634c <alltraps>

80106d2d <vector107>:
.globl vector107
vector107:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $107
80106d2f:	6a 6b                	push   $0x6b
  jmp alltraps
80106d31:	e9 16 f6 ff ff       	jmp    8010634c <alltraps>

80106d36 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $108
80106d38:	6a 6c                	push   $0x6c
  jmp alltraps
80106d3a:	e9 0d f6 ff ff       	jmp    8010634c <alltraps>

80106d3f <vector109>:
.globl vector109
vector109:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $109
80106d41:	6a 6d                	push   $0x6d
  jmp alltraps
80106d43:	e9 04 f6 ff ff       	jmp    8010634c <alltraps>

80106d48 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $110
80106d4a:	6a 6e                	push   $0x6e
  jmp alltraps
80106d4c:	e9 fb f5 ff ff       	jmp    8010634c <alltraps>

80106d51 <vector111>:
.globl vector111
vector111:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $111
80106d53:	6a 6f                	push   $0x6f
  jmp alltraps
80106d55:	e9 f2 f5 ff ff       	jmp    8010634c <alltraps>

80106d5a <vector112>:
.globl vector112
vector112:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $112
80106d5c:	6a 70                	push   $0x70
  jmp alltraps
80106d5e:	e9 e9 f5 ff ff       	jmp    8010634c <alltraps>

80106d63 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $113
80106d65:	6a 71                	push   $0x71
  jmp alltraps
80106d67:	e9 e0 f5 ff ff       	jmp    8010634c <alltraps>

80106d6c <vector114>:
.globl vector114
vector114:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $114
80106d6e:	6a 72                	push   $0x72
  jmp alltraps
80106d70:	e9 d7 f5 ff ff       	jmp    8010634c <alltraps>

80106d75 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $115
80106d77:	6a 73                	push   $0x73
  jmp alltraps
80106d79:	e9 ce f5 ff ff       	jmp    8010634c <alltraps>

80106d7e <vector116>:
.globl vector116
vector116:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $116
80106d80:	6a 74                	push   $0x74
  jmp alltraps
80106d82:	e9 c5 f5 ff ff       	jmp    8010634c <alltraps>

80106d87 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $117
80106d89:	6a 75                	push   $0x75
  jmp alltraps
80106d8b:	e9 bc f5 ff ff       	jmp    8010634c <alltraps>

80106d90 <vector118>:
.globl vector118
vector118:
  pushl $0
80106d90:	6a 00                	push   $0x0
  pushl $118
80106d92:	6a 76                	push   $0x76
  jmp alltraps
80106d94:	e9 b3 f5 ff ff       	jmp    8010634c <alltraps>

80106d99 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $119
80106d9b:	6a 77                	push   $0x77
  jmp alltraps
80106d9d:	e9 aa f5 ff ff       	jmp    8010634c <alltraps>

80106da2 <vector120>:
.globl vector120
vector120:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $120
80106da4:	6a 78                	push   $0x78
  jmp alltraps
80106da6:	e9 a1 f5 ff ff       	jmp    8010634c <alltraps>

80106dab <vector121>:
.globl vector121
vector121:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $121
80106dad:	6a 79                	push   $0x79
  jmp alltraps
80106daf:	e9 98 f5 ff ff       	jmp    8010634c <alltraps>

80106db4 <vector122>:
.globl vector122
vector122:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $122
80106db6:	6a 7a                	push   $0x7a
  jmp alltraps
80106db8:	e9 8f f5 ff ff       	jmp    8010634c <alltraps>

80106dbd <vector123>:
.globl vector123
vector123:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $123
80106dbf:	6a 7b                	push   $0x7b
  jmp alltraps
80106dc1:	e9 86 f5 ff ff       	jmp    8010634c <alltraps>

80106dc6 <vector124>:
.globl vector124
vector124:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $124
80106dc8:	6a 7c                	push   $0x7c
  jmp alltraps
80106dca:	e9 7d f5 ff ff       	jmp    8010634c <alltraps>

80106dcf <vector125>:
.globl vector125
vector125:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $125
80106dd1:	6a 7d                	push   $0x7d
  jmp alltraps
80106dd3:	e9 74 f5 ff ff       	jmp    8010634c <alltraps>

80106dd8 <vector126>:
.globl vector126
vector126:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $126
80106dda:	6a 7e                	push   $0x7e
  jmp alltraps
80106ddc:	e9 6b f5 ff ff       	jmp    8010634c <alltraps>

80106de1 <vector127>:
.globl vector127
vector127:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $127
80106de3:	6a 7f                	push   $0x7f
  jmp alltraps
80106de5:	e9 62 f5 ff ff       	jmp    8010634c <alltraps>

80106dea <vector128>:
.globl vector128
vector128:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $128
80106dec:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106df1:	e9 56 f5 ff ff       	jmp    8010634c <alltraps>

80106df6 <vector129>:
.globl vector129
vector129:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $129
80106df8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106dfd:	e9 4a f5 ff ff       	jmp    8010634c <alltraps>

80106e02 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $130
80106e04:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e09:	e9 3e f5 ff ff       	jmp    8010634c <alltraps>

80106e0e <vector131>:
.globl vector131
vector131:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $131
80106e10:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e15:	e9 32 f5 ff ff       	jmp    8010634c <alltraps>

80106e1a <vector132>:
.globl vector132
vector132:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $132
80106e1c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e21:	e9 26 f5 ff ff       	jmp    8010634c <alltraps>

80106e26 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $133
80106e28:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e2d:	e9 1a f5 ff ff       	jmp    8010634c <alltraps>

80106e32 <vector134>:
.globl vector134
vector134:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $134
80106e34:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e39:	e9 0e f5 ff ff       	jmp    8010634c <alltraps>

80106e3e <vector135>:
.globl vector135
vector135:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $135
80106e40:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e45:	e9 02 f5 ff ff       	jmp    8010634c <alltraps>

80106e4a <vector136>:
.globl vector136
vector136:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $136
80106e4c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e51:	e9 f6 f4 ff ff       	jmp    8010634c <alltraps>

80106e56 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $137
80106e58:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e5d:	e9 ea f4 ff ff       	jmp    8010634c <alltraps>

80106e62 <vector138>:
.globl vector138
vector138:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $138
80106e64:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e69:	e9 de f4 ff ff       	jmp    8010634c <alltraps>

80106e6e <vector139>:
.globl vector139
vector139:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $139
80106e70:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e75:	e9 d2 f4 ff ff       	jmp    8010634c <alltraps>

80106e7a <vector140>:
.globl vector140
vector140:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $140
80106e7c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e81:	e9 c6 f4 ff ff       	jmp    8010634c <alltraps>

80106e86 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $141
80106e88:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e8d:	e9 ba f4 ff ff       	jmp    8010634c <alltraps>

80106e92 <vector142>:
.globl vector142
vector142:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $142
80106e94:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e99:	e9 ae f4 ff ff       	jmp    8010634c <alltraps>

80106e9e <vector143>:
.globl vector143
vector143:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $143
80106ea0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ea5:	e9 a2 f4 ff ff       	jmp    8010634c <alltraps>

80106eaa <vector144>:
.globl vector144
vector144:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $144
80106eac:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106eb1:	e9 96 f4 ff ff       	jmp    8010634c <alltraps>

80106eb6 <vector145>:
.globl vector145
vector145:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $145
80106eb8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ebd:	e9 8a f4 ff ff       	jmp    8010634c <alltraps>

80106ec2 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $146
80106ec4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ec9:	e9 7e f4 ff ff       	jmp    8010634c <alltraps>

80106ece <vector147>:
.globl vector147
vector147:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $147
80106ed0:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ed5:	e9 72 f4 ff ff       	jmp    8010634c <alltraps>

80106eda <vector148>:
.globl vector148
vector148:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $148
80106edc:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ee1:	e9 66 f4 ff ff       	jmp    8010634c <alltraps>

80106ee6 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $149
80106ee8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106eed:	e9 5a f4 ff ff       	jmp    8010634c <alltraps>

80106ef2 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $150
80106ef4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ef9:	e9 4e f4 ff ff       	jmp    8010634c <alltraps>

80106efe <vector151>:
.globl vector151
vector151:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $151
80106f00:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f05:	e9 42 f4 ff ff       	jmp    8010634c <alltraps>

80106f0a <vector152>:
.globl vector152
vector152:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $152
80106f0c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f11:	e9 36 f4 ff ff       	jmp    8010634c <alltraps>

80106f16 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $153
80106f18:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f1d:	e9 2a f4 ff ff       	jmp    8010634c <alltraps>

80106f22 <vector154>:
.globl vector154
vector154:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $154
80106f24:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f29:	e9 1e f4 ff ff       	jmp    8010634c <alltraps>

80106f2e <vector155>:
.globl vector155
vector155:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $155
80106f30:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f35:	e9 12 f4 ff ff       	jmp    8010634c <alltraps>

80106f3a <vector156>:
.globl vector156
vector156:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $156
80106f3c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f41:	e9 06 f4 ff ff       	jmp    8010634c <alltraps>

80106f46 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $157
80106f48:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f4d:	e9 fa f3 ff ff       	jmp    8010634c <alltraps>

80106f52 <vector158>:
.globl vector158
vector158:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $158
80106f54:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f59:	e9 ee f3 ff ff       	jmp    8010634c <alltraps>

80106f5e <vector159>:
.globl vector159
vector159:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $159
80106f60:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f65:	e9 e2 f3 ff ff       	jmp    8010634c <alltraps>

80106f6a <vector160>:
.globl vector160
vector160:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $160
80106f6c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f71:	e9 d6 f3 ff ff       	jmp    8010634c <alltraps>

80106f76 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $161
80106f78:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f7d:	e9 ca f3 ff ff       	jmp    8010634c <alltraps>

80106f82 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $162
80106f84:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f89:	e9 be f3 ff ff       	jmp    8010634c <alltraps>

80106f8e <vector163>:
.globl vector163
vector163:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $163
80106f90:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f95:	e9 b2 f3 ff ff       	jmp    8010634c <alltraps>

80106f9a <vector164>:
.globl vector164
vector164:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $164
80106f9c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fa1:	e9 a6 f3 ff ff       	jmp    8010634c <alltraps>

80106fa6 <vector165>:
.globl vector165
vector165:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $165
80106fa8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106fad:	e9 9a f3 ff ff       	jmp    8010634c <alltraps>

80106fb2 <vector166>:
.globl vector166
vector166:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $166
80106fb4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106fb9:	e9 8e f3 ff ff       	jmp    8010634c <alltraps>

80106fbe <vector167>:
.globl vector167
vector167:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $167
80106fc0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106fc5:	e9 82 f3 ff ff       	jmp    8010634c <alltraps>

80106fca <vector168>:
.globl vector168
vector168:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $168
80106fcc:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106fd1:	e9 76 f3 ff ff       	jmp    8010634c <alltraps>

80106fd6 <vector169>:
.globl vector169
vector169:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $169
80106fd8:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106fdd:	e9 6a f3 ff ff       	jmp    8010634c <alltraps>

80106fe2 <vector170>:
.globl vector170
vector170:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $170
80106fe4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fe9:	e9 5e f3 ff ff       	jmp    8010634c <alltraps>

80106fee <vector171>:
.globl vector171
vector171:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $171
80106ff0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ff5:	e9 52 f3 ff ff       	jmp    8010634c <alltraps>

80106ffa <vector172>:
.globl vector172
vector172:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $172
80106ffc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107001:	e9 46 f3 ff ff       	jmp    8010634c <alltraps>

80107006 <vector173>:
.globl vector173
vector173:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $173
80107008:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010700d:	e9 3a f3 ff ff       	jmp    8010634c <alltraps>

80107012 <vector174>:
.globl vector174
vector174:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $174
80107014:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107019:	e9 2e f3 ff ff       	jmp    8010634c <alltraps>

8010701e <vector175>:
.globl vector175
vector175:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $175
80107020:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107025:	e9 22 f3 ff ff       	jmp    8010634c <alltraps>

8010702a <vector176>:
.globl vector176
vector176:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $176
8010702c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107031:	e9 16 f3 ff ff       	jmp    8010634c <alltraps>

80107036 <vector177>:
.globl vector177
vector177:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $177
80107038:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010703d:	e9 0a f3 ff ff       	jmp    8010634c <alltraps>

80107042 <vector178>:
.globl vector178
vector178:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $178
80107044:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107049:	e9 fe f2 ff ff       	jmp    8010634c <alltraps>

8010704e <vector179>:
.globl vector179
vector179:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $179
80107050:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107055:	e9 f2 f2 ff ff       	jmp    8010634c <alltraps>

8010705a <vector180>:
.globl vector180
vector180:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $180
8010705c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107061:	e9 e6 f2 ff ff       	jmp    8010634c <alltraps>

80107066 <vector181>:
.globl vector181
vector181:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $181
80107068:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010706d:	e9 da f2 ff ff       	jmp    8010634c <alltraps>

80107072 <vector182>:
.globl vector182
vector182:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $182
80107074:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107079:	e9 ce f2 ff ff       	jmp    8010634c <alltraps>

8010707e <vector183>:
.globl vector183
vector183:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $183
80107080:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107085:	e9 c2 f2 ff ff       	jmp    8010634c <alltraps>

8010708a <vector184>:
.globl vector184
vector184:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $184
8010708c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107091:	e9 b6 f2 ff ff       	jmp    8010634c <alltraps>

80107096 <vector185>:
.globl vector185
vector185:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $185
80107098:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010709d:	e9 aa f2 ff ff       	jmp    8010634c <alltraps>

801070a2 <vector186>:
.globl vector186
vector186:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $186
801070a4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070a9:	e9 9e f2 ff ff       	jmp    8010634c <alltraps>

801070ae <vector187>:
.globl vector187
vector187:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $187
801070b0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801070b5:	e9 92 f2 ff ff       	jmp    8010634c <alltraps>

801070ba <vector188>:
.globl vector188
vector188:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $188
801070bc:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801070c1:	e9 86 f2 ff ff       	jmp    8010634c <alltraps>

801070c6 <vector189>:
.globl vector189
vector189:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $189
801070c8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070cd:	e9 7a f2 ff ff       	jmp    8010634c <alltraps>

801070d2 <vector190>:
.globl vector190
vector190:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $190
801070d4:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070d9:	e9 6e f2 ff ff       	jmp    8010634c <alltraps>

801070de <vector191>:
.globl vector191
vector191:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $191
801070e0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070e5:	e9 62 f2 ff ff       	jmp    8010634c <alltraps>

801070ea <vector192>:
.globl vector192
vector192:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $192
801070ec:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801070f1:	e9 56 f2 ff ff       	jmp    8010634c <alltraps>

801070f6 <vector193>:
.globl vector193
vector193:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $193
801070f8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070fd:	e9 4a f2 ff ff       	jmp    8010634c <alltraps>

80107102 <vector194>:
.globl vector194
vector194:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $194
80107104:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107109:	e9 3e f2 ff ff       	jmp    8010634c <alltraps>

8010710e <vector195>:
.globl vector195
vector195:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $195
80107110:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107115:	e9 32 f2 ff ff       	jmp    8010634c <alltraps>

8010711a <vector196>:
.globl vector196
vector196:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $196
8010711c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107121:	e9 26 f2 ff ff       	jmp    8010634c <alltraps>

80107126 <vector197>:
.globl vector197
vector197:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $197
80107128:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010712d:	e9 1a f2 ff ff       	jmp    8010634c <alltraps>

80107132 <vector198>:
.globl vector198
vector198:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $198
80107134:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107139:	e9 0e f2 ff ff       	jmp    8010634c <alltraps>

8010713e <vector199>:
.globl vector199
vector199:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $199
80107140:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107145:	e9 02 f2 ff ff       	jmp    8010634c <alltraps>

8010714a <vector200>:
.globl vector200
vector200:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $200
8010714c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107151:	e9 f6 f1 ff ff       	jmp    8010634c <alltraps>

80107156 <vector201>:
.globl vector201
vector201:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $201
80107158:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010715d:	e9 ea f1 ff ff       	jmp    8010634c <alltraps>

80107162 <vector202>:
.globl vector202
vector202:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $202
80107164:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107169:	e9 de f1 ff ff       	jmp    8010634c <alltraps>

8010716e <vector203>:
.globl vector203
vector203:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $203
80107170:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107175:	e9 d2 f1 ff ff       	jmp    8010634c <alltraps>

8010717a <vector204>:
.globl vector204
vector204:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $204
8010717c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107181:	e9 c6 f1 ff ff       	jmp    8010634c <alltraps>

80107186 <vector205>:
.globl vector205
vector205:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $205
80107188:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010718d:	e9 ba f1 ff ff       	jmp    8010634c <alltraps>

80107192 <vector206>:
.globl vector206
vector206:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $206
80107194:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107199:	e9 ae f1 ff ff       	jmp    8010634c <alltraps>

8010719e <vector207>:
.globl vector207
vector207:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $207
801071a0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071a5:	e9 a2 f1 ff ff       	jmp    8010634c <alltraps>

801071aa <vector208>:
.globl vector208
vector208:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $208
801071ac:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071b1:	e9 96 f1 ff ff       	jmp    8010634c <alltraps>

801071b6 <vector209>:
.globl vector209
vector209:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $209
801071b8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801071bd:	e9 8a f1 ff ff       	jmp    8010634c <alltraps>

801071c2 <vector210>:
.globl vector210
vector210:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $210
801071c4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071c9:	e9 7e f1 ff ff       	jmp    8010634c <alltraps>

801071ce <vector211>:
.globl vector211
vector211:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $211
801071d0:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071d5:	e9 72 f1 ff ff       	jmp    8010634c <alltraps>

801071da <vector212>:
.globl vector212
vector212:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $212
801071dc:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071e1:	e9 66 f1 ff ff       	jmp    8010634c <alltraps>

801071e6 <vector213>:
.globl vector213
vector213:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $213
801071e8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801071ed:	e9 5a f1 ff ff       	jmp    8010634c <alltraps>

801071f2 <vector214>:
.globl vector214
vector214:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $214
801071f4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071f9:	e9 4e f1 ff ff       	jmp    8010634c <alltraps>

801071fe <vector215>:
.globl vector215
vector215:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $215
80107200:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107205:	e9 42 f1 ff ff       	jmp    8010634c <alltraps>

8010720a <vector216>:
.globl vector216
vector216:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $216
8010720c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107211:	e9 36 f1 ff ff       	jmp    8010634c <alltraps>

80107216 <vector217>:
.globl vector217
vector217:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $217
80107218:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010721d:	e9 2a f1 ff ff       	jmp    8010634c <alltraps>

80107222 <vector218>:
.globl vector218
vector218:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $218
80107224:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107229:	e9 1e f1 ff ff       	jmp    8010634c <alltraps>

8010722e <vector219>:
.globl vector219
vector219:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $219
80107230:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107235:	e9 12 f1 ff ff       	jmp    8010634c <alltraps>

8010723a <vector220>:
.globl vector220
vector220:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $220
8010723c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107241:	e9 06 f1 ff ff       	jmp    8010634c <alltraps>

80107246 <vector221>:
.globl vector221
vector221:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $221
80107248:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010724d:	e9 fa f0 ff ff       	jmp    8010634c <alltraps>

80107252 <vector222>:
.globl vector222
vector222:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $222
80107254:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107259:	e9 ee f0 ff ff       	jmp    8010634c <alltraps>

8010725e <vector223>:
.globl vector223
vector223:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $223
80107260:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107265:	e9 e2 f0 ff ff       	jmp    8010634c <alltraps>

8010726a <vector224>:
.globl vector224
vector224:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $224
8010726c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107271:	e9 d6 f0 ff ff       	jmp    8010634c <alltraps>

80107276 <vector225>:
.globl vector225
vector225:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $225
80107278:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010727d:	e9 ca f0 ff ff       	jmp    8010634c <alltraps>

80107282 <vector226>:
.globl vector226
vector226:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $226
80107284:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107289:	e9 be f0 ff ff       	jmp    8010634c <alltraps>

8010728e <vector227>:
.globl vector227
vector227:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $227
80107290:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107295:	e9 b2 f0 ff ff       	jmp    8010634c <alltraps>

8010729a <vector228>:
.globl vector228
vector228:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $228
8010729c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072a1:	e9 a6 f0 ff ff       	jmp    8010634c <alltraps>

801072a6 <vector229>:
.globl vector229
vector229:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $229
801072a8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072ad:	e9 9a f0 ff ff       	jmp    8010634c <alltraps>

801072b2 <vector230>:
.globl vector230
vector230:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $230
801072b4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801072b9:	e9 8e f0 ff ff       	jmp    8010634c <alltraps>

801072be <vector231>:
.globl vector231
vector231:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $231
801072c0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072c5:	e9 82 f0 ff ff       	jmp    8010634c <alltraps>

801072ca <vector232>:
.globl vector232
vector232:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $232
801072cc:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072d1:	e9 76 f0 ff ff       	jmp    8010634c <alltraps>

801072d6 <vector233>:
.globl vector233
vector233:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $233
801072d8:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072dd:	e9 6a f0 ff ff       	jmp    8010634c <alltraps>

801072e2 <vector234>:
.globl vector234
vector234:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $234
801072e4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072e9:	e9 5e f0 ff ff       	jmp    8010634c <alltraps>

801072ee <vector235>:
.globl vector235
vector235:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $235
801072f0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072f5:	e9 52 f0 ff ff       	jmp    8010634c <alltraps>

801072fa <vector236>:
.globl vector236
vector236:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $236
801072fc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107301:	e9 46 f0 ff ff       	jmp    8010634c <alltraps>

80107306 <vector237>:
.globl vector237
vector237:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $237
80107308:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010730d:	e9 3a f0 ff ff       	jmp    8010634c <alltraps>

80107312 <vector238>:
.globl vector238
vector238:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $238
80107314:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107319:	e9 2e f0 ff ff       	jmp    8010634c <alltraps>

8010731e <vector239>:
.globl vector239
vector239:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $239
80107320:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107325:	e9 22 f0 ff ff       	jmp    8010634c <alltraps>

8010732a <vector240>:
.globl vector240
vector240:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $240
8010732c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107331:	e9 16 f0 ff ff       	jmp    8010634c <alltraps>

80107336 <vector241>:
.globl vector241
vector241:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $241
80107338:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010733d:	e9 0a f0 ff ff       	jmp    8010634c <alltraps>

80107342 <vector242>:
.globl vector242
vector242:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $242
80107344:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107349:	e9 fe ef ff ff       	jmp    8010634c <alltraps>

8010734e <vector243>:
.globl vector243
vector243:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $243
80107350:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107355:	e9 f2 ef ff ff       	jmp    8010634c <alltraps>

8010735a <vector244>:
.globl vector244
vector244:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $244
8010735c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107361:	e9 e6 ef ff ff       	jmp    8010634c <alltraps>

80107366 <vector245>:
.globl vector245
vector245:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $245
80107368:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010736d:	e9 da ef ff ff       	jmp    8010634c <alltraps>

80107372 <vector246>:
.globl vector246
vector246:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $246
80107374:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107379:	e9 ce ef ff ff       	jmp    8010634c <alltraps>

8010737e <vector247>:
.globl vector247
vector247:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $247
80107380:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107385:	e9 c2 ef ff ff       	jmp    8010634c <alltraps>

8010738a <vector248>:
.globl vector248
vector248:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $248
8010738c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107391:	e9 b6 ef ff ff       	jmp    8010634c <alltraps>

80107396 <vector249>:
.globl vector249
vector249:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $249
80107398:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010739d:	e9 aa ef ff ff       	jmp    8010634c <alltraps>

801073a2 <vector250>:
.globl vector250
vector250:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $250
801073a4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073a9:	e9 9e ef ff ff       	jmp    8010634c <alltraps>

801073ae <vector251>:
.globl vector251
vector251:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $251
801073b0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801073b5:	e9 92 ef ff ff       	jmp    8010634c <alltraps>

801073ba <vector252>:
.globl vector252
vector252:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $252
801073bc:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801073c1:	e9 86 ef ff ff       	jmp    8010634c <alltraps>

801073c6 <vector253>:
.globl vector253
vector253:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $253
801073c8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073cd:	e9 7a ef ff ff       	jmp    8010634c <alltraps>

801073d2 <vector254>:
.globl vector254
vector254:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $254
801073d4:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073d9:	e9 6e ef ff ff       	jmp    8010634c <alltraps>

801073de <vector255>:
.globl vector255
vector255:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $255
801073e0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073e5:	e9 62 ef ff ff       	jmp    8010634c <alltraps>
	...

801073ec <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801073ec:	55                   	push   %ebp
801073ed:	89 e5                	mov    %esp,%ebp
801073ef:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801073f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f5:	48                   	dec    %eax
801073f6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801073fa:	8b 45 08             	mov    0x8(%ebp),%eax
801073fd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107401:	8b 45 08             	mov    0x8(%ebp),%eax
80107404:	c1 e8 10             	shr    $0x10,%eax
80107407:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010740b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010740e:	0f 01 10             	lgdtl  (%eax)
}
80107411:	c9                   	leave  
80107412:	c3                   	ret    

80107413 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107413:	55                   	push   %ebp
80107414:	89 e5                	mov    %esp,%ebp
80107416:	83 ec 04             	sub    $0x4,%esp
80107419:	8b 45 08             	mov    0x8(%ebp),%eax
8010741c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107420:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107423:	0f 00 d8             	ltr    %ax
}
80107426:	c9                   	leave  
80107427:	c3                   	ret    

80107428 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107428:	55                   	push   %ebp
80107429:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010742b:	8b 45 08             	mov    0x8(%ebp),%eax
8010742e:	0f 22 d8             	mov    %eax,%cr3
}
80107431:	5d                   	pop    %ebp
80107432:	c3                   	ret    

80107433 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107433:	55                   	push   %ebp
80107434:	89 e5                	mov    %esp,%ebp
80107436:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107439:	e8 70 cc ff ff       	call   801040ae <cpuid>
8010743e:	89 c2                	mov    %eax,%edx
80107440:	89 d0                	mov    %edx,%eax
80107442:	c1 e0 02             	shl    $0x2,%eax
80107445:	01 d0                	add    %edx,%eax
80107447:	01 c0                	add    %eax,%eax
80107449:	01 d0                	add    %edx,%eax
8010744b:	c1 e0 04             	shl    $0x4,%eax
8010744e:	05 00 38 11 80       	add    $0x80113800,%eax
80107453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107459:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010745f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107462:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010746f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107472:	8a 50 7d             	mov    0x7d(%eax),%dl
80107475:	83 e2 f0             	and    $0xfffffff0,%edx
80107478:	83 ca 0a             	or     $0xa,%edx
8010747b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010747e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107481:	8a 50 7d             	mov    0x7d(%eax),%dl
80107484:	83 ca 10             	or     $0x10,%edx
80107487:	88 50 7d             	mov    %dl,0x7d(%eax)
8010748a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748d:	8a 50 7d             	mov    0x7d(%eax),%dl
80107490:	83 e2 9f             	and    $0xffffff9f,%edx
80107493:	88 50 7d             	mov    %dl,0x7d(%eax)
80107496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107499:	8a 50 7d             	mov    0x7d(%eax),%dl
8010749c:	83 ca 80             	or     $0xffffff80,%edx
8010749f:	88 50 7d             	mov    %dl,0x7d(%eax)
801074a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a5:	8a 50 7e             	mov    0x7e(%eax),%dl
801074a8:	83 ca 0f             	or     $0xf,%edx
801074ab:	88 50 7e             	mov    %dl,0x7e(%eax)
801074ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b1:	8a 50 7e             	mov    0x7e(%eax),%dl
801074b4:	83 e2 ef             	and    $0xffffffef,%edx
801074b7:	88 50 7e             	mov    %dl,0x7e(%eax)
801074ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bd:	8a 50 7e             	mov    0x7e(%eax),%dl
801074c0:	83 e2 df             	and    $0xffffffdf,%edx
801074c3:	88 50 7e             	mov    %dl,0x7e(%eax)
801074c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c9:	8a 50 7e             	mov    0x7e(%eax),%dl
801074cc:	83 ca 40             	or     $0x40,%edx
801074cf:	88 50 7e             	mov    %dl,0x7e(%eax)
801074d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d5:	8a 50 7e             	mov    0x7e(%eax),%dl
801074d8:	83 ca 80             	or     $0xffffff80,%edx
801074db:	88 50 7e             	mov    %dl,0x7e(%eax)
801074de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e1:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e8:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801074ef:	ff ff 
801074f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f4:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801074fb:	00 00 
801074fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107500:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750a:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107510:	83 e2 f0             	and    $0xfffffff0,%edx
80107513:	83 ca 02             	or     $0x2,%edx
80107516:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010751c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751f:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107525:	83 ca 10             	or     $0x10,%edx
80107528:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010752e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107531:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107537:	83 e2 9f             	and    $0xffffff9f,%edx
8010753a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107543:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107549:	83 ca 80             	or     $0xffffff80,%edx
8010754c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107552:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107555:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010755b:	83 ca 0f             	or     $0xf,%edx
8010755e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107567:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010756d:	83 e2 ef             	and    $0xffffffef,%edx
80107570:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107579:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010757f:	83 e2 df             	and    $0xffffffdf,%edx
80107582:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758b:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107591:	83 ca 40             	or     $0x40,%edx
80107594:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010759a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759d:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075a3:	83 ca 80             	or     $0xffffff80,%edx
801075a6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075af:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b9:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801075c0:	ff ff 
801075c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c5:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801075cc:	00 00 
801075ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d1:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801075d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075db:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801075e1:	83 e2 f0             	and    $0xfffffff0,%edx
801075e4:	83 ca 0a             	or     $0xa,%edx
801075e7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801075ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f0:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801075f6:	83 ca 10             	or     $0x10,%edx
801075f9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801075ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107602:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80107608:	83 ca 60             	or     $0x60,%edx
8010760b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107614:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010761a:	83 ca 80             	or     $0xffffff80,%edx
8010761d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107626:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010762c:	83 ca 0f             	or     $0xf,%edx
8010762f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107638:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010763e:	83 e2 ef             	and    $0xffffffef,%edx
80107641:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764a:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107650:	83 e2 df             	and    $0xffffffdf,%edx
80107653:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765c:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107662:	83 ca 40             	or     $0x40,%edx
80107665:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010766b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766e:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80107674:	83 ca 80             	or     $0xffffff80,%edx
80107677:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010767d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107680:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768a:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107691:	ff ff 
80107693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107696:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010769d:	00 00 
8010769f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a2:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801076a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ac:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801076b2:	83 e2 f0             	and    $0xfffffff0,%edx
801076b5:	83 ca 02             	or     $0x2,%edx
801076b8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c1:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801076c7:	83 ca 10             	or     $0x10,%edx
801076ca:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d3:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801076d9:	83 ca 60             	or     $0x60,%edx
801076dc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e5:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801076eb:	83 ca 80             	or     $0xffffff80,%edx
801076ee:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801076fd:	83 ca 0f             	or     $0xf,%edx
80107700:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107709:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010770f:	83 e2 ef             	and    $0xffffffef,%edx
80107712:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107721:	83 e2 df             	and    $0xffffffdf,%edx
80107724:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010772a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107733:	83 ca 40             	or     $0x40,%edx
80107736:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010773c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107745:	83 ca 80             	or     $0xffffff80,%edx
80107748:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010774e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107751:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775b:	83 c0 70             	add    $0x70,%eax
8010775e:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107765:	00 
80107766:	89 04 24             	mov    %eax,(%esp)
80107769:	e8 7e fc ff ff       	call   801073ec <lgdt>
}
8010776e:	c9                   	leave  
8010776f:	c3                   	ret    

80107770 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107776:	8b 45 0c             	mov    0xc(%ebp),%eax
80107779:	c1 e8 16             	shr    $0x16,%eax
8010777c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107783:	8b 45 08             	mov    0x8(%ebp),%eax
80107786:	01 d0                	add    %edx,%eax
80107788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010778b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010778e:	8b 00                	mov    (%eax),%eax
80107790:	83 e0 01             	and    $0x1,%eax
80107793:	85 c0                	test   %eax,%eax
80107795:	74 14                	je     801077ab <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010779a:	8b 00                	mov    (%eax),%eax
8010779c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077a1:	05 00 00 00 80       	add    $0x80000000,%eax
801077a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077a9:	eb 48                	jmp    801077f3 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801077af:	74 0e                	je     801077bf <walkpgdir+0x4f>
801077b1:	e8 01 b4 ff ff       	call   80102bb7 <kalloc>
801077b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077bd:	75 07                	jne    801077c6 <walkpgdir+0x56>
      return 0;
801077bf:	b8 00 00 00 00       	mov    $0x0,%eax
801077c4:	eb 44                	jmp    8010780a <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801077c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801077cd:	00 
801077ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801077d5:	00 
801077d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d9:	89 04 24             	mov    %eax,(%esp)
801077dc:	e8 09 d8 ff ff       	call   80104fea <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e4:	05 00 00 00 80       	add    $0x80000000,%eax
801077e9:	83 c8 07             	or     $0x7,%eax
801077ec:	89 c2                	mov    %eax,%edx
801077ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077f1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801077f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077f6:	c1 e8 0c             	shr    $0xc,%eax
801077f9:	25 ff 03 00 00       	and    $0x3ff,%eax
801077fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107808:	01 d0                	add    %edx,%eax
}
8010780a:	c9                   	leave  
8010780b:	c3                   	ret    

8010780c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010780c:	55                   	push   %ebp
8010780d:	89 e5                	mov    %esp,%ebp
8010780f:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107812:	8b 45 0c             	mov    0xc(%ebp),%eax
80107815:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010781a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010781d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107820:	8b 45 10             	mov    0x10(%ebp),%eax
80107823:	01 d0                	add    %edx,%eax
80107825:	48                   	dec    %eax
80107826:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010782b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010782e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107835:	00 
80107836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010783d:	8b 45 08             	mov    0x8(%ebp),%eax
80107840:	89 04 24             	mov    %eax,(%esp)
80107843:	e8 28 ff ff ff       	call   80107770 <walkpgdir>
80107848:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010784b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010784f:	75 07                	jne    80107858 <mappages+0x4c>
      return -1;
80107851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107856:	eb 48                	jmp    801078a0 <mappages+0x94>
    if(*pte & PTE_P)
80107858:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010785b:	8b 00                	mov    (%eax),%eax
8010785d:	83 e0 01             	and    $0x1,%eax
80107860:	85 c0                	test   %eax,%eax
80107862:	74 0c                	je     80107870 <mappages+0x64>
      panic("remap");
80107864:	c7 04 24 80 87 10 80 	movl   $0x80108780,(%esp)
8010786b:	e8 e4 8c ff ff       	call   80100554 <panic>
    *pte = pa | perm | PTE_P;
80107870:	8b 45 18             	mov    0x18(%ebp),%eax
80107873:	0b 45 14             	or     0x14(%ebp),%eax
80107876:	83 c8 01             	or     $0x1,%eax
80107879:	89 c2                	mov    %eax,%edx
8010787b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010787e:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107886:	75 08                	jne    80107890 <mappages+0x84>
      break;
80107888:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107889:	b8 00 00 00 00       	mov    $0x0,%eax
8010788e:	eb 10                	jmp    801078a0 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107890:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107897:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010789e:	eb 8e                	jmp    8010782e <mappages+0x22>
  return 0;
}
801078a0:	c9                   	leave  
801078a1:	c3                   	ret    

801078a2 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801078a2:	55                   	push   %ebp
801078a3:	89 e5                	mov    %esp,%ebp
801078a5:	53                   	push   %ebx
801078a6:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801078a9:	e8 09 b3 ff ff       	call   80102bb7 <kalloc>
801078ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078b5:	75 0a                	jne    801078c1 <setupkvm+0x1f>
    return 0;
801078b7:	b8 00 00 00 00       	mov    $0x0,%eax
801078bc:	e9 84 00 00 00       	jmp    80107945 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
801078c1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078c8:	00 
801078c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801078d0:	00 
801078d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d4:	89 04 24             	mov    %eax,(%esp)
801078d7:	e8 0e d7 ff ff       	call   80104fea <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078dc:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
801078e3:	eb 54                	jmp    80107939 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e8:	8b 48 0c             	mov    0xc(%eax),%ecx
801078eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ee:	8b 50 04             	mov    0x4(%eax),%edx
801078f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f4:	8b 58 08             	mov    0x8(%eax),%ebx
801078f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fa:	8b 40 04             	mov    0x4(%eax),%eax
801078fd:	29 c3                	sub    %eax,%ebx
801078ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107902:	8b 00                	mov    (%eax),%eax
80107904:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107908:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010790c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107910:	89 44 24 04          	mov    %eax,0x4(%esp)
80107914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107917:	89 04 24             	mov    %eax,(%esp)
8010791a:	e8 ed fe ff ff       	call   8010780c <mappages>
8010791f:	85 c0                	test   %eax,%eax
80107921:	79 12                	jns    80107935 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107926:	89 04 24             	mov    %eax,(%esp)
80107929:	e8 1a 05 00 00       	call   80107e48 <freevm>
      return 0;
8010792e:	b8 00 00 00 00       	mov    $0x0,%eax
80107933:	eb 10                	jmp    80107945 <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107935:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107939:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107940:	72 a3                	jb     801078e5 <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
80107942:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107945:	83 c4 34             	add    $0x34,%esp
80107948:	5b                   	pop    %ebx
80107949:	5d                   	pop    %ebp
8010794a:	c3                   	ret    

8010794b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010794b:	55                   	push   %ebp
8010794c:	89 e5                	mov    %esp,%ebp
8010794e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107951:	e8 4c ff ff ff       	call   801078a2 <setupkvm>
80107956:	a3 24 65 11 80       	mov    %eax,0x80116524
  switchkvm();
8010795b:	e8 02 00 00 00       	call   80107962 <switchkvm>
}
80107960:	c9                   	leave  
80107961:	c3                   	ret    

80107962 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107962:	55                   	push   %ebp
80107963:	89 e5                	mov    %esp,%ebp
80107965:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107968:	a1 24 65 11 80       	mov    0x80116524,%eax
8010796d:	05 00 00 00 80       	add    $0x80000000,%eax
80107972:	89 04 24             	mov    %eax,(%esp)
80107975:	e8 ae fa ff ff       	call   80107428 <lcr3>
}
8010797a:	c9                   	leave  
8010797b:	c3                   	ret    

8010797c <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010797c:	55                   	push   %ebp
8010797d:	89 e5                	mov    %esp,%ebp
8010797f:	57                   	push   %edi
80107980:	56                   	push   %esi
80107981:	53                   	push   %ebx
80107982:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107989:	75 0c                	jne    80107997 <switchuvm+0x1b>
    panic("switchuvm: no process");
8010798b:	c7 04 24 86 87 10 80 	movl   $0x80108786,(%esp)
80107992:	e8 bd 8b ff ff       	call   80100554 <panic>
  if(p->kstack == 0)
80107997:	8b 45 08             	mov    0x8(%ebp),%eax
8010799a:	8b 40 08             	mov    0x8(%eax),%eax
8010799d:	85 c0                	test   %eax,%eax
8010799f:	75 0c                	jne    801079ad <switchuvm+0x31>
    panic("switchuvm: no kstack");
801079a1:	c7 04 24 9c 87 10 80 	movl   $0x8010879c,(%esp)
801079a8:	e8 a7 8b ff ff       	call   80100554 <panic>
  if(p->pgdir == 0)
801079ad:	8b 45 08             	mov    0x8(%ebp),%eax
801079b0:	8b 40 04             	mov    0x4(%eax),%eax
801079b3:	85 c0                	test   %eax,%eax
801079b5:	75 0c                	jne    801079c3 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
801079b7:	c7 04 24 b1 87 10 80 	movl   $0x801087b1,(%esp)
801079be:	e8 91 8b ff ff       	call   80100554 <panic>

  pushcli();
801079c3:	e8 1e d5 ff ff       	call   80104ee6 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079c8:	e8 26 c7 ff ff       	call   801040f3 <mycpu>
801079cd:	89 c3                	mov    %eax,%ebx
801079cf:	e8 1f c7 ff ff       	call   801040f3 <mycpu>
801079d4:	83 c0 08             	add    $0x8,%eax
801079d7:	89 c6                	mov    %eax,%esi
801079d9:	e8 15 c7 ff ff       	call   801040f3 <mycpu>
801079de:	83 c0 08             	add    $0x8,%eax
801079e1:	c1 e8 10             	shr    $0x10,%eax
801079e4:	89 c7                	mov    %eax,%edi
801079e6:	e8 08 c7 ff ff       	call   801040f3 <mycpu>
801079eb:	83 c0 08             	add    $0x8,%eax
801079ee:	c1 e8 18             	shr    $0x18,%eax
801079f1:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801079f8:	67 00 
801079fa:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107a01:	89 f9                	mov    %edi,%ecx
80107a03:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a09:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a0f:	83 e2 f0             	and    $0xfffffff0,%edx
80107a12:	83 ca 09             	or     $0x9,%edx
80107a15:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a1b:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a21:	83 ca 10             	or     $0x10,%edx
80107a24:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a2a:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a30:	83 e2 9f             	and    $0xffffff9f,%edx
80107a33:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a39:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80107a3f:	83 ca 80             	or     $0xffffff80,%edx
80107a42:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a48:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a4e:	83 e2 f0             	and    $0xfffffff0,%edx
80107a51:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a57:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a5d:	83 e2 ef             	and    $0xffffffef,%edx
80107a60:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a66:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a6c:	83 e2 df             	and    $0xffffffdf,%edx
80107a6f:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a75:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a7b:	83 ca 40             	or     $0x40,%edx
80107a7e:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a84:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80107a8a:	83 e2 7f             	and    $0x7f,%edx
80107a8d:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a93:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107a99:	e8 55 c6 ff ff       	call   801040f3 <mycpu>
80107a9e:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107aa4:	83 e2 ef             	and    $0xffffffef,%edx
80107aa7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107aad:	e8 41 c6 ff ff       	call   801040f3 <mycpu>
80107ab2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107ab8:	e8 36 c6 ff ff       	call   801040f3 <mycpu>
80107abd:	8b 55 08             	mov    0x8(%ebp),%edx
80107ac0:	8b 52 08             	mov    0x8(%edx),%edx
80107ac3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107ac9:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107acc:	e8 22 c6 ff ff       	call   801040f3 <mycpu>
80107ad1:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107ad7:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107ade:	e8 30 f9 ff ff       	call   80107413 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae6:	8b 40 04             	mov    0x4(%eax),%eax
80107ae9:	05 00 00 00 80       	add    $0x80000000,%eax
80107aee:	89 04 24             	mov    %eax,(%esp)
80107af1:	e8 32 f9 ff ff       	call   80107428 <lcr3>
  popcli();
80107af6:	e8 35 d4 ff ff       	call   80104f30 <popcli>
}
80107afb:	83 c4 1c             	add    $0x1c,%esp
80107afe:	5b                   	pop    %ebx
80107aff:	5e                   	pop    %esi
80107b00:	5f                   	pop    %edi
80107b01:	5d                   	pop    %ebp
80107b02:	c3                   	ret    

80107b03 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107b03:	55                   	push   %ebp
80107b04:	89 e5                	mov    %esp,%ebp
80107b06:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107b09:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b10:	76 0c                	jbe    80107b1e <inituvm+0x1b>
    panic("inituvm: more than a page");
80107b12:	c7 04 24 c5 87 10 80 	movl   $0x801087c5,(%esp)
80107b19:	e8 36 8a ff ff       	call   80100554 <panic>
  mem = kalloc();
80107b1e:	e8 94 b0 ff ff       	call   80102bb7 <kalloc>
80107b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107b26:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b2d:	00 
80107b2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b35:	00 
80107b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b39:	89 04 24             	mov    %eax,(%esp)
80107b3c:	e8 a9 d4 ff ff       	call   80104fea <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b44:	05 00 00 00 80       	add    $0x80000000,%eax
80107b49:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107b50:	00 
80107b51:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107b55:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b5c:	00 
80107b5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b64:	00 
80107b65:	8b 45 08             	mov    0x8(%ebp),%eax
80107b68:	89 04 24             	mov    %eax,(%esp)
80107b6b:	e8 9c fc ff ff       	call   8010780c <mappages>
  memmove(mem, init, sz);
80107b70:	8b 45 10             	mov    0x10(%ebp),%eax
80107b73:	89 44 24 08          	mov    %eax,0x8(%esp)
80107b77:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b81:	89 04 24             	mov    %eax,(%esp)
80107b84:	e8 2a d5 ff ff       	call   801050b3 <memmove>
}
80107b89:	c9                   	leave  
80107b8a:	c3                   	ret    

80107b8b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b8b:	55                   	push   %ebp
80107b8c:	89 e5                	mov    %esp,%ebp
80107b8e:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b91:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b94:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b99:	85 c0                	test   %eax,%eax
80107b9b:	74 0c                	je     80107ba9 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107b9d:	c7 04 24 e0 87 10 80 	movl   $0x801087e0,(%esp)
80107ba4:	e8 ab 89 ff ff       	call   80100554 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bb0:	e9 a6 00 00 00       	jmp    80107c5b <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bbb:	01 d0                	add    %edx,%eax
80107bbd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107bc4:	00 
80107bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80107bcc:	89 04 24             	mov    %eax,(%esp)
80107bcf:	e8 9c fb ff ff       	call   80107770 <walkpgdir>
80107bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bdb:	75 0c                	jne    80107be9 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107bdd:	c7 04 24 03 88 10 80 	movl   $0x80108803,(%esp)
80107be4:	e8 6b 89 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80107be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bec:	8b 00                	mov    (%eax),%eax
80107bee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf9:	8b 55 18             	mov    0x18(%ebp),%edx
80107bfc:	29 c2                	sub    %eax,%edx
80107bfe:	89 d0                	mov    %edx,%eax
80107c00:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107c05:	77 0f                	ja     80107c16 <loaduvm+0x8b>
      n = sz - i;
80107c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0a:	8b 55 18             	mov    0x18(%ebp),%edx
80107c0d:	29 c2                	sub    %eax,%edx
80107c0f:	89 d0                	mov    %edx,%eax
80107c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c14:	eb 07                	jmp    80107c1d <loaduvm+0x92>
    else
      n = PGSIZE;
80107c16:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c20:	8b 55 14             	mov    0x14(%ebp),%edx
80107c23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c29:	05 00 00 00 80       	add    $0x80000000,%eax
80107c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107c31:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c35:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107c39:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c3d:	8b 45 10             	mov    0x10(%ebp),%eax
80107c40:	89 04 24             	mov    %eax,(%esp)
80107c43:	e8 d5 a1 ff ff       	call   80101e1d <readi>
80107c48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c4b:	74 07                	je     80107c54 <loaduvm+0xc9>
      return -1;
80107c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c52:	eb 18                	jmp    80107c6c <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107c54:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5e:	3b 45 18             	cmp    0x18(%ebp),%eax
80107c61:	0f 82 4e ff ff ff    	jb     80107bb5 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c6c:	c9                   	leave  
80107c6d:	c3                   	ret    

80107c6e <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c6e:	55                   	push   %ebp
80107c6f:	89 e5                	mov    %esp,%ebp
80107c71:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107c74:	8b 45 10             	mov    0x10(%ebp),%eax
80107c77:	85 c0                	test   %eax,%eax
80107c79:	79 0a                	jns    80107c85 <allocuvm+0x17>
    return 0;
80107c7b:	b8 00 00 00 00       	mov    $0x0,%eax
80107c80:	e9 fd 00 00 00       	jmp    80107d82 <allocuvm+0x114>
  if(newsz < oldsz)
80107c85:	8b 45 10             	mov    0x10(%ebp),%eax
80107c88:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c8b:	73 08                	jae    80107c95 <allocuvm+0x27>
    return oldsz;
80107c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c90:	e9 ed 00 00 00       	jmp    80107d82 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80107c95:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c98:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ca5:	e9 c9 00 00 00       	jmp    80107d73 <allocuvm+0x105>
    mem = kalloc();
80107caa:	e8 08 af ff ff       	call   80102bb7 <kalloc>
80107caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cb6:	75 2f                	jne    80107ce7 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80107cb8:	c7 04 24 21 88 10 80 	movl   $0x80108821,(%esp)
80107cbf:	e8 fd 86 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ccb:	8b 45 10             	mov    0x10(%ebp),%eax
80107cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd5:	89 04 24             	mov    %eax,(%esp)
80107cd8:	e8 a7 00 00 00       	call   80107d84 <deallocuvm>
      return 0;
80107cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce2:	e9 9b 00 00 00       	jmp    80107d82 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
80107ce7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cee:	00 
80107cef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cf6:	00 
80107cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cfa:	89 04 24             	mov    %eax,(%esp)
80107cfd:	e8 e8 d2 ff ff       	call   80104fea <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d05:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107d15:	00 
80107d16:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d1a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d21:	00 
80107d22:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d26:	8b 45 08             	mov    0x8(%ebp),%eax
80107d29:	89 04 24             	mov    %eax,(%esp)
80107d2c:	e8 db fa ff ff       	call   8010780c <mappages>
80107d31:	85 c0                	test   %eax,%eax
80107d33:	79 37                	jns    80107d6c <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80107d35:	c7 04 24 39 88 10 80 	movl   $0x80108839,(%esp)
80107d3c:	e8 80 86 ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107d41:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d44:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d48:	8b 45 10             	mov    0x10(%ebp),%eax
80107d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d52:	89 04 24             	mov    %eax,(%esp)
80107d55:	e8 2a 00 00 00       	call   80107d84 <deallocuvm>
      kfree(mem);
80107d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d5d:	89 04 24             	mov    %eax,(%esp)
80107d60:	e8 bc ad ff ff       	call   80102b21 <kfree>
      return 0;
80107d65:	b8 00 00 00 00       	mov    $0x0,%eax
80107d6a:	eb 16                	jmp    80107d82 <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107d6c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d76:	3b 45 10             	cmp    0x10(%ebp),%eax
80107d79:	0f 82 2b ff ff ff    	jb     80107caa <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80107d7f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d82:	c9                   	leave  
80107d83:	c3                   	ret    

80107d84 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d84:	55                   	push   %ebp
80107d85:	89 e5                	mov    %esp,%ebp
80107d87:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d8a:	8b 45 10             	mov    0x10(%ebp),%eax
80107d8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d90:	72 08                	jb     80107d9a <deallocuvm+0x16>
    return oldsz;
80107d92:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d95:	e9 ac 00 00 00       	jmp    80107e46 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107d9a:	8b 45 10             	mov    0x10(%ebp),%eax
80107d9d:	05 ff 0f 00 00       	add    $0xfff,%eax
80107da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107daa:	e9 88 00 00 00       	jmp    80107e37 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107db9:	00 
80107dba:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80107dc1:	89 04 24             	mov    %eax,(%esp)
80107dc4:	e8 a7 f9 ff ff       	call   80107770 <walkpgdir>
80107dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107dd0:	75 14                	jne    80107de6 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd5:	c1 e8 16             	shr    $0x16,%eax
80107dd8:	40                   	inc    %eax
80107dd9:	c1 e0 16             	shl    $0x16,%eax
80107ddc:	2d 00 10 00 00       	sub    $0x1000,%eax
80107de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107de4:	eb 4a                	jmp    80107e30 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107de9:	8b 00                	mov    (%eax),%eax
80107deb:	83 e0 01             	and    $0x1,%eax
80107dee:	85 c0                	test   %eax,%eax
80107df0:	74 3e                	je     80107e30 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107df5:	8b 00                	mov    (%eax),%eax
80107df7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e03:	75 0c                	jne    80107e11 <deallocuvm+0x8d>
        panic("kfree");
80107e05:	c7 04 24 55 88 10 80 	movl   $0x80108855,(%esp)
80107e0c:	e8 43 87 ff ff       	call   80100554 <panic>
      char *v = P2V(pa);
80107e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e14:	05 00 00 00 80       	add    $0x80000000,%eax
80107e19:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e1f:	89 04 24             	mov    %eax,(%esp)
80107e22:	e8 fa ac ff ff       	call   80102b21 <kfree>
      *pte = 0;
80107e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107e30:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e3d:	0f 82 6c ff ff ff    	jb     80107daf <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107e43:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e46:	c9                   	leave  
80107e47:	c3                   	ret    

80107e48 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e48:	55                   	push   %ebp
80107e49:	89 e5                	mov    %esp,%ebp
80107e4b:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107e4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e52:	75 0c                	jne    80107e60 <freevm+0x18>
    panic("freevm: no pgdir");
80107e54:	c7 04 24 5b 88 10 80 	movl   $0x8010885b,(%esp)
80107e5b:	e8 f4 86 ff ff       	call   80100554 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107e60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e67:	00 
80107e68:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107e6f:	80 
80107e70:	8b 45 08             	mov    0x8(%ebp),%eax
80107e73:	89 04 24             	mov    %eax,(%esp)
80107e76:	e8 09 ff ff ff       	call   80107d84 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e82:	eb 44                	jmp    80107ec8 <freevm+0x80>
    if(pgdir[i] & PTE_P){
80107e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e91:	01 d0                	add    %edx,%eax
80107e93:	8b 00                	mov    (%eax),%eax
80107e95:	83 e0 01             	and    $0x1,%eax
80107e98:	85 c0                	test   %eax,%eax
80107e9a:	74 29                	je     80107ec5 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea9:	01 d0                	add    %edx,%eax
80107eab:	8b 00                	mov    (%eax),%eax
80107ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eb2:	05 00 00 00 80       	add    $0x80000000,%eax
80107eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebd:	89 04 24             	mov    %eax,(%esp)
80107ec0:	e8 5c ac ff ff       	call   80102b21 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ec5:	ff 45 f4             	incl   -0xc(%ebp)
80107ec8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107ecf:	76 b3                	jbe    80107e84 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed4:	89 04 24             	mov    %eax,(%esp)
80107ed7:	e8 45 ac ff ff       	call   80102b21 <kfree>
}
80107edc:	c9                   	leave  
80107edd:	c3                   	ret    

80107ede <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107ede:	55                   	push   %ebp
80107edf:	89 e5                	mov    %esp,%ebp
80107ee1:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ee4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107eeb:	00 
80107eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eef:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef6:	89 04 24             	mov    %eax,(%esp)
80107ef9:	e8 72 f8 ff ff       	call   80107770 <walkpgdir>
80107efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f05:	75 0c                	jne    80107f13 <clearpteu+0x35>
    panic("clearpteu");
80107f07:	c7 04 24 6c 88 10 80 	movl   $0x8010886c,(%esp)
80107f0e:	e8 41 86 ff ff       	call   80100554 <panic>
  *pte &= ~PTE_U;
80107f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f16:	8b 00                	mov    (%eax),%eax
80107f18:	83 e0 fb             	and    $0xfffffffb,%eax
80107f1b:	89 c2                	mov    %eax,%edx
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	89 10                	mov    %edx,(%eax)
}
80107f22:	c9                   	leave  
80107f23:	c3                   	ret    

80107f24 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107f24:	55                   	push   %ebp
80107f25:	89 e5                	mov    %esp,%ebp
80107f27:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f2a:	e8 73 f9 ff ff       	call   801078a2 <setupkvm>
80107f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f36:	75 0a                	jne    80107f42 <copyuvm+0x1e>
    return 0;
80107f38:	b8 00 00 00 00       	mov    $0x0,%eax
80107f3d:	e9 f8 00 00 00       	jmp    8010803a <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80107f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f49:	e9 cb 00 00 00       	jmp    80108019 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f51:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f58:	00 
80107f59:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f60:	89 04 24             	mov    %eax,(%esp)
80107f63:	e8 08 f8 ff ff       	call   80107770 <walkpgdir>
80107f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f6f:	75 0c                	jne    80107f7d <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80107f71:	c7 04 24 76 88 10 80 	movl   $0x80108876,(%esp)
80107f78:	e8 d7 85 ff ff       	call   80100554 <panic>
    if(!(*pte & PTE_P))
80107f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f80:	8b 00                	mov    (%eax),%eax
80107f82:	83 e0 01             	and    $0x1,%eax
80107f85:	85 c0                	test   %eax,%eax
80107f87:	75 0c                	jne    80107f95 <copyuvm+0x71>
      panic("copyuvm: page not present");
80107f89:	c7 04 24 90 88 10 80 	movl   $0x80108890,(%esp)
80107f90:	e8 bf 85 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80107f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f98:	8b 00                	mov    (%eax),%eax
80107f9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa5:	8b 00                	mov    (%eax),%eax
80107fa7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107faf:	e8 03 ac ff ff       	call   80102bb7 <kalloc>
80107fb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107fbb:	75 02                	jne    80107fbf <copyuvm+0x9b>
      goto bad;
80107fbd:	eb 6b                	jmp    8010802a <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fc2:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fce:	00 
80107fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fd6:	89 04 24             	mov    %eax,(%esp)
80107fd9:	e8 d5 d0 ff ff       	call   801050b3 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107fde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fe1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fe4:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fed:	89 54 24 10          	mov    %edx,0x10(%esp)
80107ff1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107ff5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ffc:	00 
80107ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108004:	89 04 24             	mov    %eax,(%esp)
80108007:	e8 00 f8 ff ff       	call   8010780c <mappages>
8010800c:	85 c0                	test   %eax,%eax
8010800e:	79 02                	jns    80108012 <copyuvm+0xee>
      goto bad;
80108010:	eb 18                	jmp    8010802a <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108012:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010801f:	0f 82 29 ff ff ff    	jb     80107f4e <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80108025:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108028:	eb 10                	jmp    8010803a <copyuvm+0x116>

bad:
  freevm(d);
8010802a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010802d:	89 04 24             	mov    %eax,(%esp)
80108030:	e8 13 fe ff ff       	call   80107e48 <freevm>
  return 0;
80108035:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010803a:	c9                   	leave  
8010803b:	c3                   	ret    

8010803c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010803c:	55                   	push   %ebp
8010803d:	89 e5                	mov    %esp,%ebp
8010803f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108042:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108049:	00 
8010804a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010804d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108051:	8b 45 08             	mov    0x8(%ebp),%eax
80108054:	89 04 24             	mov    %eax,(%esp)
80108057:	e8 14 f7 ff ff       	call   80107770 <walkpgdir>
8010805c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	8b 00                	mov    (%eax),%eax
80108064:	83 e0 01             	and    $0x1,%eax
80108067:	85 c0                	test   %eax,%eax
80108069:	75 07                	jne    80108072 <uva2ka+0x36>
    return 0;
8010806b:	b8 00 00 00 00       	mov    $0x0,%eax
80108070:	eb 22                	jmp    80108094 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108075:	8b 00                	mov    (%eax),%eax
80108077:	83 e0 04             	and    $0x4,%eax
8010807a:	85 c0                	test   %eax,%eax
8010807c:	75 07                	jne    80108085 <uva2ka+0x49>
    return 0;
8010807e:	b8 00 00 00 00       	mov    $0x0,%eax
80108083:	eb 0f                	jmp    80108094 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108088:	8b 00                	mov    (%eax),%eax
8010808a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010808f:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108094:	c9                   	leave  
80108095:	c3                   	ret    

80108096 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108096:	55                   	push   %ebp
80108097:	89 e5                	mov    %esp,%ebp
80108099:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010809c:	8b 45 10             	mov    0x10(%ebp),%eax
8010809f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801080a2:	e9 87 00 00 00       	jmp    8010812e <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801080a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801080aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801080b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080b9:	8b 45 08             	mov    0x8(%ebp),%eax
801080bc:	89 04 24             	mov    %eax,(%esp)
801080bf:	e8 78 ff ff ff       	call   8010803c <uva2ka>
801080c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801080c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801080cb:	75 07                	jne    801080d4 <copyout+0x3e>
      return -1;
801080cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080d2:	eb 69                	jmp    8010813d <copyout+0xa7>
    n = PGSIZE - (va - va0);
801080d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801080da:	29 c2                	sub    %eax,%edx
801080dc:	89 d0                	mov    %edx,%eax
801080de:	05 00 10 00 00       	add    $0x1000,%eax
801080e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801080e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080e9:	3b 45 14             	cmp    0x14(%ebp),%eax
801080ec:	76 06                	jbe    801080f4 <copyout+0x5e>
      n = len;
801080ee:	8b 45 14             	mov    0x14(%ebp),%eax
801080f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801080f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801080fa:	29 c2                	sub    %eax,%edx
801080fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080ff:	01 c2                	add    %eax,%edx
80108101:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108104:	89 44 24 08          	mov    %eax,0x8(%esp)
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010810f:	89 14 24             	mov    %edx,(%esp)
80108112:	e8 9c cf ff ff       	call   801050b3 <memmove>
    len -= n;
80108117:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010811a:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010811d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108120:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108123:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108126:	05 00 10 00 00       	add    $0x1000,%eax
8010812b:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010812e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108132:	0f 85 6f ff ff ff    	jne    801080a7 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108138:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010813d:	c9                   	leave  
8010813e:	c3                   	ret    
