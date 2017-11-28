
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
80100028:	bc 90 d6 10 80       	mov    $0x8010d690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 1a 39 10 80       	mov    $0x8010391a,%eax
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
8010003a:	c7 44 24 04 a4 90 10 	movl   $0x801090a4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 d0 4e 00 00       	call   80104f1e <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 ec 1d 11 80 9c 	movl   $0x80111d9c,0x80111dec
80100055:	1d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 f0 1d 11 80 9c 	movl   $0x80111d9c,0x80111df0
8010005f:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 d4 d6 10 80 	movl   $0x8010d6d4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 f0 1d 11 80    	mov    0x80111df0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 9c 1d 11 80 	movl   $0x80111d9c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 ab 90 10 	movl   $0x801090ab,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 49 4d 00 00       	call   80104de0 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 f0 1d 11 80       	mov    %eax,0x80111df0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
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
801000c2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801000c9:	e8 71 4e 00 00       	call   80104f3f <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
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
801000fd:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100104:	e8 a0 4e 00 00       	call   80104fa9 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 03 4d 00 00       	call   80104e1a <acquiresleep>
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
80100128:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 ec 1d 11 80       	mov    0x80111dec,%eax
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
80100176:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010017d:	e8 27 4e 00 00       	call   80104fa9 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 8a 4c 00 00       	call   80104e1a <acquiresleep>
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
8010019e:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 b2 90 10 80 	movl   $0x801090b2,(%esp)
801001ae:	e8 cf 03 00 00       	call   80100582 <panic>
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
801001e2:	e8 6a 28 00 00       	call   80102a51 <iderw>
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
801001fb:	e8 b7 4c 00 00       	call   80104eb7 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 c3 90 10 80 	movl   $0x801090c3,(%esp)
8010020b:	e8 72 03 00 00       	call   80100582 <panic>
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
80100225:	e8 27 28 00 00       	call   80102a51 <iderw>
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
8010023b:	e8 77 4c 00 00       	call   80104eb7 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 ca 90 10 80 	movl   $0x801090ca,(%esp)
8010024b:	e8 32 03 00 00       	call   80100582 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 17 4c 00 00       	call   80104e75 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100265:	e8 d5 4c 00 00       	call   80104f3f <acquire>
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
801002a1:	8b 15 f0 1d 11 80    	mov    0x80111df0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 9c 1d 11 80 	movl   $0x80111d9c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 f0 1d 11 80       	mov    %eax,0x80111df0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002d1:	e8 d3 4c 00 00       	call   80104fa9 <release>
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

80100315 <strcpy>:
  int locking;
} cons;

char*
strcpy(char *s, char *t)
{
80100315:	55                   	push   %ebp
80100316:	89 e5                	mov    %esp,%ebp
80100318:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
80100321:	90                   	nop
80100322:	8b 45 08             	mov    0x8(%ebp),%eax
80100325:	8d 50 01             	lea    0x1(%eax),%edx
80100328:	89 55 08             	mov    %edx,0x8(%ebp)
8010032b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010032e:	8d 4a 01             	lea    0x1(%edx),%ecx
80100331:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80100334:	8a 12                	mov    (%edx),%dl
80100336:	88 10                	mov    %dl,(%eax)
80100338:	8a 00                	mov    (%eax),%al
8010033a:	84 c0                	test   %al,%al
8010033c:	75 e4                	jne    80100322 <strcpy+0xd>
    ;
  return os;
8010033e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80100341:	c9                   	leave  
80100342:	c3                   	ret    

80100343 <printint>:

static void
printint(int xx, int base, int sign)
{
80100343:	55                   	push   %ebp
80100344:	89 e5                	mov    %esp,%ebp
80100346:	56                   	push   %esi
80100347:	53                   	push   %ebx
80100348:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010034b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010034f:	74 1c                	je     8010036d <printint+0x2a>
80100351:	8b 45 08             	mov    0x8(%ebp),%eax
80100354:	c1 e8 1f             	shr    $0x1f,%eax
80100357:	0f b6 c0             	movzbl %al,%eax
8010035a:	89 45 10             	mov    %eax,0x10(%ebp)
8010035d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100361:	74 0a                	je     8010036d <printint+0x2a>
    x = -xx;
80100363:	8b 45 08             	mov    0x8(%ebp),%eax
80100366:	f7 d8                	neg    %eax
80100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036b:	eb 06                	jmp    80100373 <printint+0x30>
  else
    x = xx;
8010036d:	8b 45 08             	mov    0x8(%ebp),%eax
80100370:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010037a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010037d:	8d 41 01             	lea    0x1(%ecx),%eax
80100380:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100383:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100389:	ba 00 00 00 00       	mov    $0x0,%edx
8010038e:	f7 f3                	div    %ebx
80100390:	89 d0                	mov    %edx,%eax
80100392:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
80100398:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010039c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a2:	ba 00 00 00 00       	mov    $0x0,%edx
801003a7:	f7 f6                	div    %esi
801003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b0:	75 c8                	jne    8010037a <printint+0x37>

  if(sign)
801003b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003b6:	74 10                	je     801003c8 <printint+0x85>
    buf[i++] = '-';
801003b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bb:	8d 50 01             	lea    0x1(%eax),%edx
801003be:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c1:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003c6:	eb 17                	jmp    801003df <printint+0x9c>
801003c8:	eb 15                	jmp    801003df <printint+0x9c>
    consputc(buf[i]);
801003ca:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d0:	01 d0                	add    %edx,%eax
801003d2:	8a 00                	mov    (%eax),%al
801003d4:	0f be c0             	movsbl %al,%eax
801003d7:	89 04 24             	mov    %eax,(%esp)
801003da:	e8 b7 03 00 00       	call   80100796 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003df:	ff 4d f4             	decl   -0xc(%ebp)
801003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003e6:	79 e2                	jns    801003ca <printint+0x87>
    consputc(buf[i]);
}
801003e8:	83 c4 30             	add    $0x30,%esp
801003eb:	5b                   	pop    %ebx
801003ec:	5e                   	pop    %esi
801003ed:	5d                   	pop    %ebp
801003ee:	c3                   	ret    

801003ef <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003ef:	55                   	push   %ebp
801003f0:	89 e5                	mov    %esp,%ebp
801003f2:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003f5:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100401:	74 0c                	je     8010040f <cprintf+0x20>
    acquire(&cons.lock);
80100403:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010040a:	e8 30 4b 00 00       	call   80104f3f <acquire>

  if (fmt == 0)
8010040f:	8b 45 08             	mov    0x8(%ebp),%eax
80100412:	85 c0                	test   %eax,%eax
80100414:	75 0c                	jne    80100422 <cprintf+0x33>
    panic("null fmt");
80100416:	c7 04 24 d1 90 10 80 	movl   $0x801090d1,(%esp)
8010041d:	e8 60 01 00 00       	call   80100582 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100422:	8d 45 0c             	lea    0xc(%ebp),%eax
80100425:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010042f:	e9 1b 01 00 00       	jmp    8010054f <cprintf+0x160>
    if(c != '%'){
80100434:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100438:	74 10                	je     8010044a <cprintf+0x5b>
      consputc(c);
8010043a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010043d:	89 04 24             	mov    %eax,(%esp)
80100440:	e8 51 03 00 00       	call   80100796 <consputc>
      continue;
80100445:	e9 02 01 00 00       	jmp    8010054c <cprintf+0x15d>
    }
    c = fmt[++i] & 0xff;
8010044a:	8b 55 08             	mov    0x8(%ebp),%edx
8010044d:	ff 45 f4             	incl   -0xc(%ebp)
80100450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100453:	01 d0                	add    %edx,%eax
80100455:	8a 00                	mov    (%eax),%al
80100457:	0f be c0             	movsbl %al,%eax
8010045a:	25 ff 00 00 00       	and    $0xff,%eax
8010045f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100466:	75 05                	jne    8010046d <cprintf+0x7e>
      break;
80100468:	e9 01 01 00 00       	jmp    8010056e <cprintf+0x17f>
    switch(c){
8010046d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100470:	83 f8 70             	cmp    $0x70,%eax
80100473:	74 4f                	je     801004c4 <cprintf+0xd5>
80100475:	83 f8 70             	cmp    $0x70,%eax
80100478:	7f 13                	jg     8010048d <cprintf+0x9e>
8010047a:	83 f8 25             	cmp    $0x25,%eax
8010047d:	0f 84 a3 00 00 00    	je     80100526 <cprintf+0x137>
80100483:	83 f8 64             	cmp    $0x64,%eax
80100486:	74 14                	je     8010049c <cprintf+0xad>
80100488:	e9 a7 00 00 00       	jmp    80100534 <cprintf+0x145>
8010048d:	83 f8 73             	cmp    $0x73,%eax
80100490:	74 57                	je     801004e9 <cprintf+0xfa>
80100492:	83 f8 78             	cmp    $0x78,%eax
80100495:	74 2d                	je     801004c4 <cprintf+0xd5>
80100497:	e9 98 00 00 00       	jmp    80100534 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801004ae:	00 
801004af:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801004b6:	00 
801004b7:	89 04 24             	mov    %eax,(%esp)
801004ba:	e8 84 fe ff ff       	call   80100343 <printint>
      break;
801004bf:	e9 88 00 00 00       	jmp    8010054c <cprintf+0x15d>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004d6:	00 
801004d7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004de:	00 
801004df:	89 04 24             	mov    %eax,(%esp)
801004e2:	e8 5c fe ff ff       	call   80100343 <printint>
      break;
801004e7:	eb 63                	jmp    8010054c <cprintf+0x15d>
    case 's':
      if((s = (char*)*argp++) == 0)
801004e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ec:	8d 50 04             	lea    0x4(%eax),%edx
801004ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f2:	8b 00                	mov    (%eax),%eax
801004f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004fb:	75 09                	jne    80100506 <cprintf+0x117>
        s = "(null)";
801004fd:	c7 45 ec da 90 10 80 	movl   $0x801090da,-0x14(%ebp)
      for(; *s; s++)
80100504:	eb 15                	jmp    8010051b <cprintf+0x12c>
80100506:	eb 13                	jmp    8010051b <cprintf+0x12c>
        consputc(*s);
80100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010050b:	8a 00                	mov    (%eax),%al
8010050d:	0f be c0             	movsbl %al,%eax
80100510:	89 04 24             	mov    %eax,(%esp)
80100513:	e8 7e 02 00 00       	call   80100796 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100518:	ff 45 ec             	incl   -0x14(%ebp)
8010051b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051e:	8a 00                	mov    (%eax),%al
80100520:	84 c0                	test   %al,%al
80100522:	75 e4                	jne    80100508 <cprintf+0x119>
        consputc(*s);
      break;
80100524:	eb 26                	jmp    8010054c <cprintf+0x15d>
    case '%':
      consputc('%');
80100526:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010052d:	e8 64 02 00 00       	call   80100796 <consputc>
      break;
80100532:	eb 18                	jmp    8010054c <cprintf+0x15d>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100534:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010053b:	e8 56 02 00 00       	call   80100796 <consputc>
      consputc(c);
80100540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100543:	89 04 24             	mov    %eax,(%esp)
80100546:	e8 4b 02 00 00       	call   80100796 <consputc>
      break;
8010054b:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010054c:	ff 45 f4             	incl   -0xc(%ebp)
8010054f:	8b 55 08             	mov    0x8(%ebp),%edx
80100552:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100555:	01 d0                	add    %edx,%eax
80100557:	8a 00                	mov    (%eax),%al
80100559:	0f be c0             	movsbl %al,%eax
8010055c:	25 ff 00 00 00       	and    $0xff,%eax
80100561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100568:	0f 85 c6 fe ff ff    	jne    80100434 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
8010056e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100572:	74 0c                	je     80100580 <cprintf+0x191>
    release(&cons.lock);
80100574:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010057b:	e8 29 4a 00 00       	call   80104fa9 <release>
}
80100580:	c9                   	leave  
80100581:	c3                   	ret    

80100582 <panic>:

void
panic(char *s)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100588:	e8 82 fd ff ff       	call   8010030f <cli>
  cons.locking = 0;
8010058d:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100594:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100597:	e8 51 2b 00 00       	call   801030ed <lapicid>
8010059c:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a0:	c7 04 24 e1 90 10 80 	movl   $0x801090e1,(%esp)
801005a7:	e8 43 fe ff ff       	call   801003ef <cprintf>
  cprintf(s);
801005ac:	8b 45 08             	mov    0x8(%ebp),%eax
801005af:	89 04 24             	mov    %eax,(%esp)
801005b2:	e8 38 fe ff ff       	call   801003ef <cprintf>
  cprintf("\n");
801005b7:	c7 04 24 f5 90 10 80 	movl   $0x801090f5,(%esp)
801005be:	e8 2c fe ff ff       	call   801003ef <cprintf>
  getcallerpcs(&s, pcs);
801005c3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ca:	8d 45 08             	lea    0x8(%ebp),%eax
801005cd:	89 04 24             	mov    %eax,(%esp)
801005d0:	e8 21 4a 00 00       	call   80104ff6 <getcallerpcs>
  for(i=0; i<10; i++)
801005d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005dc:	eb 1a                	jmp    801005f8 <panic+0x76>
    cprintf(" %p", pcs[i]);
801005de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005e1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801005e9:	c7 04 24 f7 90 10 80 	movl   $0x801090f7,(%esp)
801005f0:	e8 fa fd ff ff       	call   801003ef <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005f5:	ff 45 f4             	incl   -0xc(%ebp)
801005f8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005fc:	7e e0                	jle    801005de <panic+0x5c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005fe:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
80100605:	00 00 00 
  for(;;)
    ;
80100608:	eb fe                	jmp    80100608 <panic+0x86>

8010060a <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
8010060a:	55                   	push   %ebp
8010060b:	89 e5                	mov    %esp,%ebp
8010060d:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100610:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100617:	00 
80100618:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010061f:	e8 cf fc ff ff       	call   801002f3 <outb>
  pos = inb(CRTPORT+1) << 8;
80100624:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010062b:	e8 a8 fc ff ff       	call   801002d8 <inb>
80100630:	0f b6 c0             	movzbl %al,%eax
80100633:	c1 e0 08             	shl    $0x8,%eax
80100636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100639:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100640:	00 
80100641:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100648:	e8 a6 fc ff ff       	call   801002f3 <outb>
  pos |= inb(CRTPORT+1);
8010064d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100654:	e8 7f fc ff ff       	call   801002d8 <inb>
80100659:	0f b6 c0             	movzbl %al,%eax
8010065c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010065f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100663:	75 1b                	jne    80100680 <cgaputc+0x76>
    pos += 80 - pos%80;
80100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100668:	b9 50 00 00 00       	mov    $0x50,%ecx
8010066d:	99                   	cltd   
8010066e:	f7 f9                	idiv   %ecx
80100670:	89 d0                	mov    %edx,%eax
80100672:	ba 50 00 00 00       	mov    $0x50,%edx
80100677:	29 c2                	sub    %eax,%edx
80100679:	89 d0                	mov    %edx,%eax
8010067b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010067e:	eb 34                	jmp    801006b4 <cgaputc+0xaa>
  else if(c == BACKSPACE){
80100680:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100687:	75 0b                	jne    80100694 <cgaputc+0x8a>
    if(pos > 0) --pos;
80100689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068d:	7e 25                	jle    801006b4 <cgaputc+0xaa>
8010068f:	ff 4d f4             	decl   -0xc(%ebp)
80100692:	eb 20                	jmp    801006b4 <cgaputc+0xaa>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100694:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010069d:	8d 50 01             	lea    0x1(%eax),%edx
801006a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a3:	01 c0                	add    %eax,%eax
801006a5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006a8:	8b 45 08             	mov    0x8(%ebp),%eax
801006ab:	0f b6 c0             	movzbl %al,%eax
801006ae:	80 cc 07             	or     $0x7,%ah
801006b1:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006b8:	78 09                	js     801006c3 <cgaputc+0xb9>
801006ba:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c1:	7e 0c                	jle    801006cf <cgaputc+0xc5>
    panic("pos under/overflow");
801006c3:	c7 04 24 fb 90 10 80 	movl   $0x801090fb,(%esp)
801006ca:	e8 b3 fe ff ff       	call   80100582 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006cf:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006d6:	7e 53                	jle    8010072b <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006d8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006dd:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e3:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e8:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006ef:	00 
801006f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801006f4:	89 04 24             	mov    %eax,(%esp)
801006f7:	e8 6f 4b 00 00       	call   8010526b <memmove>
    pos -= 80;
801006fc:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100700:	b8 80 07 00 00       	mov    $0x780,%eax
80100705:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100708:	01 c0                	add    %eax,%eax
8010070a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100710:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100713:	01 d2                	add    %edx,%edx
80100715:	01 ca                	add    %ecx,%edx
80100717:	89 44 24 08          	mov    %eax,0x8(%esp)
8010071b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100722:	00 
80100723:	89 14 24             	mov    %edx,(%esp)
80100726:	e8 77 4a 00 00       	call   801051a2 <memset>
  }

  outb(CRTPORT, 14);
8010072b:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100732:	00 
80100733:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010073a:	e8 b4 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos>>8);
8010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100742:	c1 f8 08             	sar    $0x8,%eax
80100745:	0f b6 c0             	movzbl %al,%eax
80100748:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100753:	e8 9b fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT, 15);
80100758:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010075f:	00 
80100760:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100767:	e8 87 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos);
8010076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076f:	0f b6 c0             	movzbl %al,%eax
80100772:	89 44 24 04          	mov    %eax,0x4(%esp)
80100776:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010077d:	e8 71 fb ff ff       	call   801002f3 <outb>
  crt[pos] = ' ' | 0x0700;
80100782:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80100788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078b:	01 c0                	add    %eax,%eax
8010078d:	01 d0                	add    %edx,%eax
8010078f:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100794:	c9                   	leave  
80100795:	c3                   	ret    

80100796 <consputc>:

void
consputc(int c)
{
80100796:	55                   	push   %ebp
80100797:	89 e5                	mov    %esp,%ebp
80100799:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010079c:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
801007a1:	85 c0                	test   %eax,%eax
801007a3:	74 07                	je     801007ac <consputc+0x16>
    cli();
801007a5:	e8 65 fb ff ff       	call   8010030f <cli>
    for(;;)
      ;
801007aa:	eb fe                	jmp    801007aa <consputc+0x14>
  }

  if(c == BACKSPACE){
801007ac:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b3:	75 26                	jne    801007db <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007bc:	e8 2b 6b 00 00       	call   801072ec <uartputc>
801007c1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007c8:	e8 1f 6b 00 00       	call   801072ec <uartputc>
801007cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007d4:	e8 13 6b 00 00       	call   801072ec <uartputc>
801007d9:	eb 0b                	jmp    801007e6 <consputc+0x50>
  } else
    uartputc(c);
801007db:	8b 45 08             	mov    0x8(%ebp),%eax
801007de:	89 04 24             	mov    %eax,(%esp)
801007e1:	e8 06 6b 00 00       	call   801072ec <uartputc>
  cgaputc(c);
801007e6:	8b 45 08             	mov    0x8(%ebp),%eax
801007e9:	89 04 24             	mov    %eax,(%esp)
801007ec:	e8 19 fe ff ff       	call   8010060a <cgaputc>
}
801007f1:	c9                   	leave  
801007f2:	c3                   	ret    

801007f3 <copy_buf>:

#define C(x)  ((x)-'@')  // Control-x


void copy_buf(char *dst, char *src, int len)
{
801007f3:	55                   	push   %ebp
801007f4:	89 e5                	mov    %esp,%ebp
801007f6:	83 ec 10             	sub    $0x10,%esp
  int i;

  for (i = 0; i < len; i++) {
801007f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80100800:	eb 17                	jmp    80100819 <copy_buf+0x26>
    dst[i] = src[i];
80100802:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100805:	8b 45 08             	mov    0x8(%ebp),%eax
80100808:	01 c2                	add    %eax,%edx
8010080a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
8010080d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100810:	01 c8                	add    %ecx,%eax
80100812:	8a 00                	mov    (%eax),%al
80100814:	88 02                	mov    %al,(%edx)

void copy_buf(char *dst, char *src, int len)
{
  int i;

  for (i = 0; i < len; i++) {
80100816:	ff 45 fc             	incl   -0x4(%ebp)
80100819:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010081c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010081f:	7c e1                	jl     80100802 <copy_buf+0xf>
    dst[i] = src[i];
  }
}
80100821:	c9                   	leave  
80100822:	c3                   	ret    

80100823 <consoleintr>:

void
consoleintr(int (*getc)(void))
{
80100823:	55                   	push   %ebp
80100824:	89 e5                	mov    %esp,%ebp
80100826:	57                   	push   %edi
80100827:	56                   	push   %esi
80100828:	53                   	push   %ebx
80100829:	81 ec ac 00 00 00    	sub    $0xac,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
8010082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  acquire(&cons.lock);
8010083d:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100844:	e8 f6 46 00 00       	call   80104f3f <acquire>
  while((c = getc()) >= 0){
80100849:	e9 a3 02 00 00       	jmp    80100af1 <consoleintr+0x2ce>
    switch(c){
8010084e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100851:	83 f8 14             	cmp    $0x14,%eax
80100854:	74 3b                	je     80100891 <consoleintr+0x6e>
80100856:	83 f8 14             	cmp    $0x14,%eax
80100859:	7f 13                	jg     8010086e <consoleintr+0x4b>
8010085b:	83 f8 08             	cmp    $0x8,%eax
8010085e:	0f 84 d0 01 00 00    	je     80100a34 <consoleintr+0x211>
80100864:	83 f8 10             	cmp    $0x10,%eax
80100867:	74 1c                	je     80100885 <consoleintr+0x62>
80100869:	e9 f6 01 00 00       	jmp    80100a64 <consoleintr+0x241>
8010086e:	83 f8 15             	cmp    $0x15,%eax
80100871:	0f 84 95 01 00 00    	je     80100a0c <consoleintr+0x1e9>
80100877:	83 f8 7f             	cmp    $0x7f,%eax
8010087a:	0f 84 b4 01 00 00    	je     80100a34 <consoleintr+0x211>
80100880:	e9 df 01 00 00       	jmp    80100a64 <consoleintr+0x241>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100885:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
8010088c:	e9 60 02 00 00       	jmp    80100af1 <consoleintr+0x2ce>
    case C('T'):  // Process listing.
      inputs[active] = input;
80100891:	8b 15 e4 c5 10 80    	mov    0x8010c5e4,%edx
80100897:	89 d0                	mov    %edx,%eax
80100899:	c1 e0 02             	shl    $0x2,%eax
8010089c:	01 d0                	add    %edx,%eax
8010089e:	c1 e0 02             	shl    $0x2,%eax
801008a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008a8:	29 c2                	sub    %eax,%edx
801008aa:	8d 82 40 22 11 80    	lea    -0x7feeddc0(%edx),%eax
801008b0:	89 c2                	mov    %eax,%edx
801008b2:	bb 00 20 11 80       	mov    $0x80112000,%ebx
801008b7:	b8 23 00 00 00       	mov    $0x23,%eax
801008bc:	89 d7                	mov    %edx,%edi
801008be:	89 de                	mov    %ebx,%esi
801008c0:	89 c1                	mov    %eax,%ecx
801008c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      active = (active + 1) % (NUM_VCS + 1);
801008c4:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
801008c9:	40                   	inc    %eax
801008ca:	b9 05 00 00 00       	mov    $0x5,%ecx
801008cf:	99                   	cltd   
801008d0:	f7 f9                	idiv   %ecx
801008d2:	89 d0                	mov    %edx,%eax
801008d4:	a3 e4 c5 10 80       	mov    %eax,0x8010c5e4
      input = inputs[active];
801008d9:	8b 15 e4 c5 10 80    	mov    0x8010c5e4,%edx
801008df:	89 d0                	mov    %edx,%eax
801008e1:	c1 e0 02             	shl    $0x2,%eax
801008e4:	01 d0                	add    %edx,%eax
801008e6:	c1 e0 02             	shl    $0x2,%eax
801008e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008f0:	29 c2                	sub    %eax,%edx
801008f2:	8d 82 40 22 11 80    	lea    -0x7feeddc0(%edx),%eax
801008f8:	ba 00 20 11 80       	mov    $0x80112000,%edx
801008fd:	89 c3                	mov    %eax,%ebx
801008ff:	b8 23 00 00 00       	mov    $0x23,%eax
80100904:	89 d7                	mov    %edx,%edi
80100906:	89 de                	mov    %ebx,%esi
80100908:	89 c1                	mov    %eax,%ecx
8010090a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      doconsoleswitch = 1;
8010090c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      char fs[32];
      if(active > 0){
80100913:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100918:	85 c0                	test   %eax,%eax
8010091a:	0f 8e b2 00 00 00    	jle    801009d2 <consoleintr+0x1af>
        char active_string[32];
        itoa(active-1, active_string, 10);
80100920:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100925:	8d 50 ff             	lea    -0x1(%eax),%edx
80100928:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
8010092f:	00 
80100930:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100936:	89 44 24 04          	mov    %eax,0x4(%esp)
8010093a:	89 14 24             	mov    %edx,(%esp)
8010093d:	e8 44 4b 00 00       	call   80105486 <itoa>
        strcat(active_string, "\0");
80100942:	c7 44 24 04 0e 91 10 	movl   $0x8010910e,0x4(%esp)
80100949:	80 
8010094a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100950:	89 04 24             	mov    %eax,(%esp)
80100953:	e8 c2 4a 00 00       	call   8010541a <strcat>
        char vc[32];
        strcpy(vc, "vc");
80100958:	c7 44 24 04 10 91 10 	movl   $0x80109110,0x4(%esp)
8010095f:	80 
80100960:	8d 45 9c             	lea    -0x64(%ebp),%eax
80100963:	89 04 24             	mov    %eax,(%esp)
80100966:	e8 aa f9 ff ff       	call   80100315 <strcpy>
        strcat(vc, active_string);
8010096b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100971:	89 44 24 04          	mov    %eax,0x4(%esp)
80100975:	8d 45 9c             	lea    -0x64(%ebp),%eax
80100978:	89 04 24             	mov    %eax,(%esp)
8010097b:	e8 9a 4a 00 00       	call   8010541a <strcat>
        strcat(vc, "\0");
80100980:	c7 44 24 04 0e 91 10 	movl   $0x8010910e,0x4(%esp)
80100987:	80 
80100988:	8d 45 9c             	lea    -0x64(%ebp),%eax
8010098b:	89 04 24             	mov    %eax,(%esp)
8010098e:	e8 87 4a 00 00       	call   8010541a <strcat>
        char vcfs[32];
        getvcfs(vc, vcfs);
80100993:	8d 45 bc             	lea    -0x44(%ebp),%eax
80100996:	89 44 24 04          	mov    %eax,0x4(%esp)
8010099a:	8d 45 9c             	lea    -0x64(%ebp),%eax
8010099d:	89 04 24             	mov    %eax,(%esp)
801009a0:	e8 25 84 00 00       	call   80108dca <getvcfs>
        strcpy(fs, "/");
801009a5:	c7 44 24 04 13 91 10 	movl   $0x80109113,0x4(%esp)
801009ac:	80 
801009ad:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801009b3:	89 04 24             	mov    %eax,(%esp)
801009b6:	e8 5a f9 ff ff       	call   80100315 <strcpy>
        strcat(fs, vcfs);
801009bb:	8d 45 bc             	lea    -0x44(%ebp),%eax
801009be:	89 44 24 04          	mov    %eax,0x4(%esp)
801009c2:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801009c8:	89 04 24             	mov    %eax,(%esp)
801009cb:	e8 4a 4a 00 00       	call   8010541a <strcat>
801009d0:	eb 0e                	jmp    801009e0 <consoleintr+0x1bd>
      }else{
        fs[0] = '/';
801009d2:	c6 85 5c ff ff ff 2f 	movb   $0x2f,-0xa4(%ebp)
        fs[1] = '\0';
801009d9:	c6 85 5d ff ff ff 00 	movb   $0x0,-0xa3(%ebp)
      }
      setactivefs(fs);
801009e0:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801009e6:	89 04 24             	mov    %eax,(%esp)
801009e9:	e8 5f 84 00 00       	call   80108e4d <setactivefs>
      break;
801009ee:	e9 fe 00 00 00       	jmp    80100af1 <consoleintr+0x2ce>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801009f3:	a1 88 20 11 80       	mov    0x80112088,%eax
801009f8:	48                   	dec    %eax
801009f9:	a3 88 20 11 80       	mov    %eax,0x80112088
        consputc(BACKSPACE);
801009fe:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100a05:	e8 8c fd ff ff       	call   80100796 <consputc>
80100a0a:	eb 01                	jmp    80100a0d <consoleintr+0x1ea>
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100a0c:	90                   	nop
80100a0d:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100a13:	a1 84 20 11 80       	mov    0x80112084,%eax
80100a18:	39 c2                	cmp    %eax,%edx
80100a1a:	74 13                	je     80100a2f <consoleintr+0x20c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a1c:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a21:	48                   	dec    %eax
80100a22:	83 e0 7f             	and    $0x7f,%eax
80100a25:	8a 80 00 20 11 80    	mov    -0x7feee000(%eax),%al
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100a2b:	3c 0a                	cmp    $0xa,%al
80100a2d:	75 c4                	jne    801009f3 <consoleintr+0x1d0>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100a2f:	e9 bd 00 00 00       	jmp    80100af1 <consoleintr+0x2ce>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100a34:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100a3a:	a1 84 20 11 80       	mov    0x80112084,%eax
80100a3f:	39 c2                	cmp    %eax,%edx
80100a41:	74 1c                	je     80100a5f <consoleintr+0x23c>
        input.e--;
80100a43:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a48:	48                   	dec    %eax
80100a49:	a3 88 20 11 80       	mov    %eax,0x80112088
        consputc(BACKSPACE);
80100a4e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100a55:	e8 3c fd ff ff       	call   80100796 <consputc>
      }
      break;
80100a5a:	e9 92 00 00 00       	jmp    80100af1 <consoleintr+0x2ce>
80100a5f:	e9 8d 00 00 00       	jmp    80100af1 <consoleintr+0x2ce>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100a68:	0f 84 82 00 00 00    	je     80100af0 <consoleintr+0x2cd>
80100a6e:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100a74:	a1 80 20 11 80       	mov    0x80112080,%eax
80100a79:	29 c2                	sub    %eax,%edx
80100a7b:	89 d0                	mov    %edx,%eax
80100a7d:	83 f8 7f             	cmp    $0x7f,%eax
80100a80:	77 6e                	ja     80100af0 <consoleintr+0x2cd>
        c = (c == '\r') ? '\n' : c;
80100a82:	83 7d dc 0d          	cmpl   $0xd,-0x24(%ebp)
80100a86:	74 05                	je     80100a8d <consoleintr+0x26a>
80100a88:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a8b:	eb 05                	jmp    80100a92 <consoleintr+0x26f>
80100a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a92:	89 45 dc             	mov    %eax,-0x24(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100a95:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a9a:	8d 50 01             	lea    0x1(%eax),%edx
80100a9d:	89 15 88 20 11 80    	mov    %edx,0x80112088
80100aa3:	83 e0 7f             	and    $0x7f,%eax
80100aa6:	89 c2                	mov    %eax,%edx
80100aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100aab:	88 82 00 20 11 80    	mov    %al,-0x7feee000(%edx)
        consputc(c);
80100ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ab4:	89 04 24             	mov    %eax,(%esp)
80100ab7:	e8 da fc ff ff       	call   80100796 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100abc:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
80100ac0:	74 18                	je     80100ada <consoleintr+0x2b7>
80100ac2:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
80100ac6:	74 12                	je     80100ada <consoleintr+0x2b7>
80100ac8:	a1 88 20 11 80       	mov    0x80112088,%eax
80100acd:	8b 15 80 20 11 80    	mov    0x80112080,%edx
80100ad3:	83 ea 80             	sub    $0xffffff80,%edx
80100ad6:	39 d0                	cmp    %edx,%eax
80100ad8:	75 16                	jne    80100af0 <consoleintr+0x2cd>
          input.w = input.e;
80100ada:	a1 88 20 11 80       	mov    0x80112088,%eax
80100adf:	a3 84 20 11 80       	mov    %eax,0x80112084
          wakeup(&input.r);
80100ae4:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100aeb:	e8 54 41 00 00       	call   80104c44 <wakeup>
        }
      }
      break;
80100af0:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100af1:	8b 45 08             	mov    0x8(%ebp),%eax
80100af4:	ff d0                	call   *%eax
80100af6:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100af9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100afd:	0f 89 4b fd ff ff    	jns    8010084e <consoleintr+0x2b>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100b03:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100b0a:	e8 9a 44 00 00       	call   80104fa9 <release>
  if(doprocdump){
80100b0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100b13:	74 05                	je     80100b1a <consoleintr+0x2f7>
    procdump();  // now call procdump() wo. cons.lock held
80100b15:	e8 cd 41 00 00       	call   80104ce7 <procdump>
  }
  if(doconsoleswitch){
80100b1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100b1e:	74 15                	je     80100b35 <consoleintr+0x312>
    cprintf("\nActive console now: %d\n", active);
80100b20:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b29:	c7 04 24 15 91 10 80 	movl   $0x80109115,(%esp)
80100b30:	e8 ba f8 ff ff       	call   801003ef <cprintf>
  }
}
80100b35:	81 c4 ac 00 00 00    	add    $0xac,%esp
80100b3b:	5b                   	pop    %ebx
80100b3c:	5e                   	pop    %esi
80100b3d:	5f                   	pop    %edi
80100b3e:	5d                   	pop    %ebp
80100b3f:	c3                   	ret    

80100b40 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100b40:	55                   	push   %ebp
80100b41:	89 e5                	mov    %esp,%ebp
80100b43:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100b46:	8b 45 08             	mov    0x8(%ebp),%eax
80100b49:	89 04 24             	mov    %eax,(%esp)
80100b4c:	e8 f7 10 00 00       	call   80101c48 <iunlock>
  target = n;
80100b51:	8b 45 10             	mov    0x10(%ebp),%eax
80100b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100b57:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100b5e:	e8 dc 43 00 00       	call   80104f3f <acquire>
  while(n > 0){
80100b63:	e9 b8 00 00 00       	jmp    80100c20 <consoleread+0xe0>
    while((input.r == input.w) || (active != ip->minor-1)){
80100b68:	eb 41                	jmp    80100bab <consoleread+0x6b>
      if(myproc()->killed){
80100b6a:	e8 c0 37 00 00       	call   8010432f <myproc>
80100b6f:	8b 40 24             	mov    0x24(%eax),%eax
80100b72:	85 c0                	test   %eax,%eax
80100b74:	74 21                	je     80100b97 <consoleread+0x57>
        release(&cons.lock);
80100b76:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100b7d:	e8 27 44 00 00       	call   80104fa9 <release>
        ilock(ip);
80100b82:	8b 45 08             	mov    0x8(%ebp),%eax
80100b85:	89 04 24             	mov    %eax,(%esp)
80100b88:	e8 b1 0f 00 00       	call   80101b3e <ilock>
        return -1;
80100b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b92:	e9 b4 00 00 00       	jmp    80100c4b <consoleread+0x10b>
      }
      sleep(&input.r, &cons.lock);
80100b97:	c7 44 24 04 00 c6 10 	movl   $0x8010c600,0x4(%esp)
80100b9e:	80 
80100b9f:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100ba6:	e8 c5 3f 00 00       	call   80104b70 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while((input.r == input.w) || (active != ip->minor-1)){
80100bab:	8b 15 80 20 11 80    	mov    0x80112080,%edx
80100bb1:	a1 84 20 11 80       	mov    0x80112084,%eax
80100bb6:	39 c2                	cmp    %eax,%edx
80100bb8:	74 b0                	je     80100b6a <consoleread+0x2a>
80100bba:	8b 45 08             	mov    0x8(%ebp),%eax
80100bbd:	8b 40 54             	mov    0x54(%eax),%eax
80100bc0:	98                   	cwtl   
80100bc1:	8d 50 ff             	lea    -0x1(%eax),%edx
80100bc4:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100bc9:	39 c2                	cmp    %eax,%edx
80100bcb:	75 9d                	jne    80100b6a <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100bcd:	a1 80 20 11 80       	mov    0x80112080,%eax
80100bd2:	8d 50 01             	lea    0x1(%eax),%edx
80100bd5:	89 15 80 20 11 80    	mov    %edx,0x80112080
80100bdb:	83 e0 7f             	and    $0x7f,%eax
80100bde:	8a 80 00 20 11 80    	mov    -0x7feee000(%eax),%al
80100be4:	0f be c0             	movsbl %al,%eax
80100be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100bea:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100bee:	75 17                	jne    80100c07 <consoleread+0xc7>
      if(n < target){
80100bf0:	8b 45 10             	mov    0x10(%ebp),%eax
80100bf3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100bf6:	73 0d                	jae    80100c05 <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100bf8:	a1 80 20 11 80       	mov    0x80112080,%eax
80100bfd:	48                   	dec    %eax
80100bfe:	a3 80 20 11 80       	mov    %eax,0x80112080
      }
      break;
80100c03:	eb 25                	jmp    80100c2a <consoleread+0xea>
80100c05:	eb 23                	jmp    80100c2a <consoleread+0xea>
    }
    *dst++ = c;
80100c07:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0a:	8d 50 01             	lea    0x1(%eax),%edx
80100c0d:	89 55 0c             	mov    %edx,0xc(%ebp)
80100c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100c13:	88 10                	mov    %dl,(%eax)
    --n;
80100c15:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100c18:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100c1c:	75 02                	jne    80100c20 <consoleread+0xe0>
      break;
80100c1e:	eb 0a                	jmp    80100c2a <consoleread+0xea>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100c24:	0f 8f 3e ff ff ff    	jg     80100b68 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100c2a:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100c31:	e8 73 43 00 00       	call   80104fa9 <release>
  ilock(ip);
80100c36:	8b 45 08             	mov    0x8(%ebp),%eax
80100c39:	89 04 24             	mov    %eax,(%esp)
80100c3c:	e8 fd 0e 00 00       	call   80101b3e <ilock>

  return target - n;
80100c41:	8b 45 10             	mov    0x10(%ebp),%eax
80100c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100c47:	29 c2                	sub    %eax,%edx
80100c49:	89 d0                	mov    %edx,%eax
}
80100c4b:	c9                   	leave  
80100c4c:	c3                   	ret    

80100c4d <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100c4d:	55                   	push   %ebp
80100c4e:	89 e5                	mov    %esp,%ebp
80100c50:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor-1){
80100c53:	8b 45 08             	mov    0x8(%ebp),%eax
80100c56:	8b 40 54             	mov    0x54(%eax),%eax
80100c59:	98                   	cwtl   
80100c5a:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c5d:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100c62:	39 c2                	cmp    %eax,%edx
80100c64:	75 5a                	jne    80100cc0 <consolewrite+0x73>
    iunlock(ip);
80100c66:	8b 45 08             	mov    0x8(%ebp),%eax
80100c69:	89 04 24             	mov    %eax,(%esp)
80100c6c:	e8 d7 0f 00 00       	call   80101c48 <iunlock>
    acquire(&cons.lock);
80100c71:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100c78:	e8 c2 42 00 00       	call   80104f3f <acquire>
    for(i = 0; i < n; i++)
80100c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100c84:	eb 1b                	jmp    80100ca1 <consolewrite+0x54>
      consputc(buf[i] & 0xff);
80100c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100c89:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8c:	01 d0                	add    %edx,%eax
80100c8e:	8a 00                	mov    (%eax),%al
80100c90:	0f be c0             	movsbl %al,%eax
80100c93:	0f b6 c0             	movzbl %al,%eax
80100c96:	89 04 24             	mov    %eax,(%esp)
80100c99:	e8 f8 fa ff ff       	call   80100796 <consputc>
  int i;

  if (active == ip->minor-1){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100c9e:	ff 45 f4             	incl   -0xc(%ebp)
80100ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ca4:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ca7:	7c dd                	jl     80100c86 <consolewrite+0x39>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100ca9:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100cb0:	e8 f4 42 00 00       	call   80104fa9 <release>
    ilock(ip);
80100cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb8:	89 04 24             	mov    %eax,(%esp)
80100cbb:	e8 7e 0e 00 00       	call   80101b3e <ilock>
  }
  return n;
80100cc0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100cc3:	c9                   	leave  
80100cc4:	c3                   	ret    

80100cc5 <consoleinit>:

void
consoleinit(void)
{
80100cc5:	55                   	push   %ebp
80100cc6:	89 e5                	mov    %esp,%ebp
80100cc8:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ccb:	c7 44 24 04 2e 91 10 	movl   $0x8010912e,0x4(%esp)
80100cd2:	80 
80100cd3:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100cda:	e8 3f 42 00 00       	call   80104f1e <initlock>

  devsw[CONSOLE].write = consolewrite;
80100cdf:	c7 05 ac 2e 11 80 4d 	movl   $0x80100c4d,0x80112eac
80100ce6:	0c 10 80 
  devsw[CONSOLE].read = consoleread;
80100ce9:	c7 05 a8 2e 11 80 40 	movl   $0x80100b40,0x80112ea8
80100cf0:	0b 10 80 
  cons.locking = 1;
80100cf3:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100cfa:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100cfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100d04:	00 
80100d05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100d0c:	e8 f2 1e 00 00       	call   80102c03 <ioapicenable>
  setactivefs("//\0");
80100d11:	c7 04 24 36 91 10 80 	movl   $0x80109136,(%esp)
80100d18:	e8 30 81 00 00       	call   80108e4d <setactivefs>
}
80100d1d:	c9                   	leave  
80100d1e:	c3                   	ret    
	...

80100d20 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d29:	e8 01 36 00 00       	call   8010432f <myproc>
80100d2e:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100d31:	e8 01 29 00 00       	call   80103637 <begin_op>

  if((ip = namei(path)) == 0){
80100d36:	8b 45 08             	mov    0x8(%ebp),%eax
80100d39:	89 04 24             	mov    %eax,(%esp)
80100d3c:	e8 22 19 00 00       	call   80102663 <namei>
80100d41:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100d44:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100d48:	75 1b                	jne    80100d65 <exec+0x45>
    end_op();
80100d4a:	e8 6a 29 00 00       	call   801036b9 <end_op>
    cprintf("exec: fail\n");
80100d4f:	c7 04 24 3a 91 10 80 	movl   $0x8010913a,(%esp)
80100d56:	e8 94 f6 ff ff       	call   801003ef <cprintf>
    return -1;
80100d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d60:	e9 f6 03 00 00       	jmp    8010115b <exec+0x43b>
  }
  ilock(ip);
80100d65:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d68:	89 04 24             	mov    %eax,(%esp)
80100d6b:	e8 ce 0d 00 00       	call   80101b3e <ilock>
  pgdir = 0;
80100d70:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d77:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100d7e:	00 
80100d7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100d86:	00 
80100d87:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d91:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d94:	89 04 24             	mov    %eax,(%esp)
80100d97:	e8 39 12 00 00       	call   80101fd5 <readi>
80100d9c:	83 f8 34             	cmp    $0x34,%eax
80100d9f:	74 05                	je     80100da6 <exec+0x86>
    goto bad;
80100da1:	e9 89 03 00 00       	jmp    8010112f <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100da6:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100dac:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100db1:	74 05                	je     80100db8 <exec+0x98>
    goto bad;
80100db3:	e9 77 03 00 00       	jmp    8010112f <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100db8:	e8 11 75 00 00       	call   801082ce <setupkvm>
80100dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100dc0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100dc4:	75 05                	jne    80100dcb <exec+0xab>
    goto bad;
80100dc6:	e9 64 03 00 00       	jmp    8010112f <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100dcb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100dd9:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100ddf:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100de2:	e9 fb 00 00 00       	jmp    80100ee2 <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dea:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100df1:	00 
80100df2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100df6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e00:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100e03:	89 04 24             	mov    %eax,(%esp)
80100e06:	e8 ca 11 00 00       	call   80101fd5 <readi>
80100e0b:	83 f8 20             	cmp    $0x20,%eax
80100e0e:	74 05                	je     80100e15 <exec+0xf5>
      goto bad;
80100e10:	e9 1a 03 00 00       	jmp    8010112f <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100e15:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100e1b:	83 f8 01             	cmp    $0x1,%eax
80100e1e:	74 05                	je     80100e25 <exec+0x105>
      continue;
80100e20:	e9 b1 00 00 00       	jmp    80100ed6 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100e25:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100e2b:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100e31:	39 c2                	cmp    %eax,%edx
80100e33:	73 05                	jae    80100e3a <exec+0x11a>
      goto bad;
80100e35:	e9 f5 02 00 00       	jmp    8010112f <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100e3a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e40:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100e46:	01 c2                	add    %eax,%edx
80100e48:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e4e:	39 c2                	cmp    %eax,%edx
80100e50:	73 05                	jae    80100e57 <exec+0x137>
      goto bad;
80100e52:	e9 d8 02 00 00       	jmp    8010112f <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e57:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e5d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100e63:	01 d0                	add    %edx,%eax
80100e65:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e73:	89 04 24             	mov    %eax,(%esp)
80100e76:	e8 1f 78 00 00       	call   8010869a <allocuvm>
80100e7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e82:	75 05                	jne    80100e89 <exec+0x169>
      goto bad;
80100e84:	e9 a6 02 00 00       	jmp    8010112f <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100e89:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e8f:	25 ff 0f 00 00       	and    $0xfff,%eax
80100e94:	85 c0                	test   %eax,%eax
80100e96:	74 05                	je     80100e9d <exec+0x17d>
      goto bad;
80100e98:	e9 92 02 00 00       	jmp    8010112f <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e9d:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100ea3:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100ea9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100eaf:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100eb3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100eb7:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100eba:	89 54 24 08          	mov    %edx,0x8(%esp)
80100ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ec2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ec5:	89 04 24             	mov    %eax,(%esp)
80100ec8:	e8 ea 76 00 00       	call   801085b7 <loaduvm>
80100ecd:	85 c0                	test   %eax,%eax
80100ecf:	79 05                	jns    80100ed6 <exec+0x1b6>
      goto bad;
80100ed1:	e9 59 02 00 00       	jmp    8010112f <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ed6:	ff 45 ec             	incl   -0x14(%ebp)
80100ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100edc:	83 c0 20             	add    $0x20,%eax
80100edf:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ee2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100ee8:	0f b7 c0             	movzwl %ax,%eax
80100eeb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100eee:	0f 8f f3 fe ff ff    	jg     80100de7 <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ef4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef7:	89 04 24             	mov    %eax,(%esp)
80100efa:	e8 3e 0e 00 00       	call   80101d3d <iunlockput>
  end_op();
80100eff:	e8 b5 27 00 00       	call   801036b9 <end_op>
  ip = 0;
80100f04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100f13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f1e:	05 00 20 00 00       	add    $0x2000,%eax
80100f23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f31:	89 04 24             	mov    %eax,(%esp)
80100f34:	e8 61 77 00 00       	call   8010869a <allocuvm>
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100f40:	75 05                	jne    80100f47 <exec+0x227>
    goto bad;
80100f42:	e9 e8 01 00 00       	jmp    8010112f <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f56:	89 04 24             	mov    %eax,(%esp)
80100f59:	e8 ac 79 00 00       	call   8010890a <clearpteu>
  sp = sz;
80100f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100f6b:	e9 95 00 00 00       	jmp    80101005 <exec+0x2e5>
    if(argc >= MAXARG)
80100f70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100f74:	76 05                	jbe    80100f7b <exec+0x25b>
      goto bad;
80100f76:	e9 b4 01 00 00       	jmp    8010112f <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f88:	01 d0                	add    %edx,%eax
80100f8a:	8b 00                	mov    (%eax),%eax
80100f8c:	89 04 24             	mov    %eax,(%esp)
80100f8f:	e8 61 44 00 00       	call   801053f5 <strlen>
80100f94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f97:	29 c2                	sub    %eax,%edx
80100f99:	89 d0                	mov    %edx,%eax
80100f9b:	48                   	dec    %eax
80100f9c:	83 e0 fc             	and    $0xfffffffc,%eax
80100f9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fac:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faf:	01 d0                	add    %edx,%eax
80100fb1:	8b 00                	mov    (%eax),%eax
80100fb3:	89 04 24             	mov    %eax,(%esp)
80100fb6:	e8 3a 44 00 00       	call   801053f5 <strlen>
80100fbb:	40                   	inc    %eax
80100fbc:	89 c2                	mov    %eax,%edx
80100fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fc1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcb:	01 c8                	add    %ecx,%eax
80100fcd:	8b 00                	mov    (%eax),%eax
80100fcf:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100fd3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80100fde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100fe1:	89 04 24             	mov    %eax,(%esp)
80100fe4:	e8 d9 7a 00 00       	call   80108ac2 <copyout>
80100fe9:	85 c0                	test   %eax,%eax
80100feb:	79 05                	jns    80100ff2 <exec+0x2d2>
      goto bad;
80100fed:	e9 3d 01 00 00       	jmp    8010112f <exec+0x40f>
    ustack[3+argc] = sp;
80100ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff5:	8d 50 03             	lea    0x3(%eax),%edx
80100ff8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ffb:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101002:	ff 45 e4             	incl   -0x1c(%ebp)
80101005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101008:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010100f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101012:	01 d0                	add    %edx,%eax
80101014:	8b 00                	mov    (%eax),%eax
80101016:	85 c0                	test   %eax,%eax
80101018:	0f 85 52 ff ff ff    	jne    80100f70 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
8010101e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101021:	83 c0 03             	add    $0x3,%eax
80101024:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
8010102b:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
8010102f:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80101036:	ff ff ff 
  ustack[1] = argc;
80101039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010103c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101045:	40                   	inc    %eax
80101046:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010104d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101050:	29 d0                	sub    %edx,%eax
80101052:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80101058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010105b:	83 c0 04             	add    $0x4,%eax
8010105e:	c1 e0 02             	shl    $0x2,%eax
80101061:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101067:	83 c0 04             	add    $0x4,%eax
8010106a:	c1 e0 02             	shl    $0x2,%eax
8010106d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101071:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80101077:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010107e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101082:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101085:	89 04 24             	mov    %eax,(%esp)
80101088:	e8 35 7a 00 00       	call   80108ac2 <copyout>
8010108d:	85 c0                	test   %eax,%eax
8010108f:	79 05                	jns    80101096 <exec+0x376>
    goto bad;
80101091:	e9 99 00 00 00       	jmp    8010112f <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010109c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010109f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801010a2:	eb 13                	jmp    801010b7 <exec+0x397>
    if(*s == '/')
801010a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010a7:	8a 00                	mov    (%eax),%al
801010a9:	3c 2f                	cmp    $0x2f,%al
801010ab:	75 07                	jne    801010b4 <exec+0x394>
      last = s+1;
801010ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010b0:	40                   	inc    %eax
801010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010b4:	ff 45 f4             	incl   -0xc(%ebp)
801010b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010ba:	8a 00                	mov    (%eax),%al
801010bc:	84 c0                	test   %al,%al
801010be:	75 e4                	jne    801010a4 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010c3:	8d 50 6c             	lea    0x6c(%eax),%edx
801010c6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801010cd:	00 
801010ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801010d5:	89 14 24             	mov    %edx,(%esp)
801010d8:	e8 d1 42 00 00       	call   801053ae <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010e0:	8b 40 04             	mov    0x4(%eax),%eax
801010e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
801010e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801010ec:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
801010ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801010f5:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
801010f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010fa:	8b 40 18             	mov    0x18(%eax),%eax
801010fd:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80101103:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101106:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101109:	8b 40 18             	mov    0x18(%eax),%eax
8010110c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010110f:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80101112:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 8b 72 00 00       	call   801083a8 <switchuvm>
  freevm(oldpgdir);
8010111d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101120:	89 04 24             	mov    %eax,(%esp)
80101123:	e8 4c 77 00 00       	call   80108874 <freevm>
  return 0;
80101128:	b8 00 00 00 00       	mov    $0x0,%eax
8010112d:	eb 2c                	jmp    8010115b <exec+0x43b>

 bad:
  if(pgdir)
8010112f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101133:	74 0b                	je     80101140 <exec+0x420>
    freevm(pgdir);
80101135:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101138:	89 04 24             	mov    %eax,(%esp)
8010113b:	e8 34 77 00 00       	call   80108874 <freevm>
  if(ip){
80101140:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101144:	74 10                	je     80101156 <exec+0x436>
    iunlockput(ip);
80101146:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101149:	89 04 24             	mov    %eax,(%esp)
8010114c:	e8 ec 0b 00 00       	call   80101d3d <iunlockput>
    end_op();
80101151:	e8 63 25 00 00       	call   801036b9 <end_op>
  }
  return -1;
80101156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010115b:	c9                   	leave  
8010115c:	c3                   	ret    
8010115d:	00 00                	add    %al,(%eax)
	...

80101160 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101166:	c7 44 24 04 46 91 10 	movl   $0x80109146,0x4(%esp)
8010116d:	80 
8010116e:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80101175:	e8 a4 3d 00 00       	call   80104f1e <initlock>
}
8010117a:	c9                   	leave  
8010117b:	c3                   	ret    

8010117c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010117c:	55                   	push   %ebp
8010117d:	89 e5                	mov    %esp,%ebp
8010117f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101182:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80101189:	e8 b1 3d 00 00       	call   80104f3f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010118e:	c7 45 f4 34 25 11 80 	movl   $0x80112534,-0xc(%ebp)
80101195:	eb 29                	jmp    801011c0 <filealloc+0x44>
    if(f->ref == 0){
80101197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119a:	8b 40 04             	mov    0x4(%eax),%eax
8010119d:	85 c0                	test   %eax,%eax
8010119f:	75 1b                	jne    801011bc <filealloc+0x40>
      f->ref = 1;
801011a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
801011ab:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801011b2:	e8 f2 3d 00 00       	call   80104fa9 <release>
      return f;
801011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ba:	eb 1e                	jmp    801011da <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011bc:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801011c0:	81 7d f4 94 2e 11 80 	cmpl   $0x80112e94,-0xc(%ebp)
801011c7:	72 ce                	jb     80101197 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801011c9:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801011d0:	e8 d4 3d 00 00       	call   80104fa9 <release>
  return 0;
801011d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801011da:	c9                   	leave  
801011db:	c3                   	ret    

801011dc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011dc:	55                   	push   %ebp
801011dd:	89 e5                	mov    %esp,%ebp
801011df:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801011e2:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801011e9:	e8 51 3d 00 00       	call   80104f3f <acquire>
  if(f->ref < 1)
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 40 04             	mov    0x4(%eax),%eax
801011f4:	85 c0                	test   %eax,%eax
801011f6:	7f 0c                	jg     80101204 <filedup+0x28>
    panic("filedup");
801011f8:	c7 04 24 4d 91 10 80 	movl   $0x8010914d,(%esp)
801011ff:	e8 7e f3 ff ff       	call   80100582 <panic>
  f->ref++;
80101204:	8b 45 08             	mov    0x8(%ebp),%eax
80101207:	8b 40 04             	mov    0x4(%eax),%eax
8010120a:	8d 50 01             	lea    0x1(%eax),%edx
8010120d:	8b 45 08             	mov    0x8(%ebp),%eax
80101210:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101213:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
8010121a:	e8 8a 3d 00 00       	call   80104fa9 <release>
  return f;
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101222:	c9                   	leave  
80101223:	c3                   	ret    

80101224 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101224:	55                   	push   %ebp
80101225:	89 e5                	mov    %esp,%ebp
80101227:	57                   	push   %edi
80101228:	56                   	push   %esi
80101229:	53                   	push   %ebx
8010122a:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
8010122d:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80101234:	e8 06 3d 00 00       	call   80104f3f <acquire>
  if(f->ref < 1)
80101239:	8b 45 08             	mov    0x8(%ebp),%eax
8010123c:	8b 40 04             	mov    0x4(%eax),%eax
8010123f:	85 c0                	test   %eax,%eax
80101241:	7f 0c                	jg     8010124f <fileclose+0x2b>
    panic("fileclose");
80101243:	c7 04 24 55 91 10 80 	movl   $0x80109155,(%esp)
8010124a:	e8 33 f3 ff ff       	call   80100582 <panic>
  if(--f->ref > 0){
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 40 04             	mov    0x4(%eax),%eax
80101255:	8d 50 ff             	lea    -0x1(%eax),%edx
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	89 50 04             	mov    %edx,0x4(%eax)
8010125e:	8b 45 08             	mov    0x8(%ebp),%eax
80101261:	8b 40 04             	mov    0x4(%eax),%eax
80101264:	85 c0                	test   %eax,%eax
80101266:	7e 0e                	jle    80101276 <fileclose+0x52>
    release(&ftable.lock);
80101268:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
8010126f:	e8 35 3d 00 00       	call   80104fa9 <release>
80101274:	eb 70                	jmp    801012e6 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	8d 55 d0             	lea    -0x30(%ebp),%edx
8010127c:	89 c3                	mov    %eax,%ebx
8010127e:	b8 06 00 00 00       	mov    $0x6,%eax
80101283:	89 d7                	mov    %edx,%edi
80101285:	89 de                	mov    %ebx,%esi
80101287:	89 c1                	mov    %eax,%ecx
80101289:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101295:	8b 45 08             	mov    0x8(%ebp),%eax
80101298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010129e:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801012a5:	e8 ff 3c 00 00       	call   80104fa9 <release>

  if(ff.type == FD_PIPE)
801012aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012ad:	83 f8 01             	cmp    $0x1,%eax
801012b0:	75 17                	jne    801012c9 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
801012b2:	8a 45 d9             	mov    -0x27(%ebp),%al
801012b5:	0f be d0             	movsbl %al,%edx
801012b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801012bf:	89 04 24             	mov    %eax,(%esp)
801012c2:	e8 00 2d 00 00       	call   80103fc7 <pipeclose>
801012c7:	eb 1d                	jmp    801012e6 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
801012c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012cc:	83 f8 02             	cmp    $0x2,%eax
801012cf:	75 15                	jne    801012e6 <fileclose+0xc2>
    begin_op();
801012d1:	e8 61 23 00 00       	call   80103637 <begin_op>
    iput(ff.ip);
801012d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012d9:	89 04 24             	mov    %eax,(%esp)
801012dc:	e8 ab 09 00 00       	call   80101c8c <iput>
    end_op();
801012e1:	e8 d3 23 00 00       	call   801036b9 <end_op>
  }
}
801012e6:	83 c4 3c             	add    $0x3c,%esp
801012e9:	5b                   	pop    %ebx
801012ea:	5e                   	pop    %esi
801012eb:	5f                   	pop    %edi
801012ec:	5d                   	pop    %ebp
801012ed:	c3                   	ret    

801012ee <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012ee:	55                   	push   %ebp
801012ef:	89 e5                	mov    %esp,%ebp
801012f1:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801012f4:	8b 45 08             	mov    0x8(%ebp),%eax
801012f7:	8b 00                	mov    (%eax),%eax
801012f9:	83 f8 02             	cmp    $0x2,%eax
801012fc:	75 38                	jne    80101336 <filestat+0x48>
    ilock(f->ip);
801012fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101301:	8b 40 10             	mov    0x10(%eax),%eax
80101304:	89 04 24             	mov    %eax,(%esp)
80101307:	e8 32 08 00 00       	call   80101b3e <ilock>
    stati(f->ip, st);
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 40 10             	mov    0x10(%eax),%eax
80101312:	8b 55 0c             	mov    0xc(%ebp),%edx
80101315:	89 54 24 04          	mov    %edx,0x4(%esp)
80101319:	89 04 24             	mov    %eax,(%esp)
8010131c:	e8 70 0c 00 00       	call   80101f91 <stati>
    iunlock(f->ip);
80101321:	8b 45 08             	mov    0x8(%ebp),%eax
80101324:	8b 40 10             	mov    0x10(%eax),%eax
80101327:	89 04 24             	mov    %eax,(%esp)
8010132a:	e8 19 09 00 00       	call   80101c48 <iunlock>
    return 0;
8010132f:	b8 00 00 00 00       	mov    $0x0,%eax
80101334:	eb 05                	jmp    8010133b <filestat+0x4d>
  }
  return -1;
80101336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010133b:	c9                   	leave  
8010133c:	c3                   	ret    

8010133d <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010133d:	55                   	push   %ebp
8010133e:	89 e5                	mov    %esp,%ebp
80101340:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101343:	8b 45 08             	mov    0x8(%ebp),%eax
80101346:	8a 40 08             	mov    0x8(%eax),%al
80101349:	84 c0                	test   %al,%al
8010134b:	75 0a                	jne    80101357 <fileread+0x1a>
    return -1;
8010134d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101352:	e9 9f 00 00 00       	jmp    801013f6 <fileread+0xb9>
  if(f->type == FD_PIPE)
80101357:	8b 45 08             	mov    0x8(%ebp),%eax
8010135a:	8b 00                	mov    (%eax),%eax
8010135c:	83 f8 01             	cmp    $0x1,%eax
8010135f:	75 1e                	jne    8010137f <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 40 0c             	mov    0xc(%eax),%eax
80101367:	8b 55 10             	mov    0x10(%ebp),%edx
8010136a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010136e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101371:	89 54 24 04          	mov    %edx,0x4(%esp)
80101375:	89 04 24             	mov    %eax,(%esp)
80101378:	e8 c8 2d 00 00       	call   80104145 <piperead>
8010137d:	eb 77                	jmp    801013f6 <fileread+0xb9>
  if(f->type == FD_INODE){
8010137f:	8b 45 08             	mov    0x8(%ebp),%eax
80101382:	8b 00                	mov    (%eax),%eax
80101384:	83 f8 02             	cmp    $0x2,%eax
80101387:	75 61                	jne    801013ea <fileread+0xad>
    ilock(f->ip);
80101389:	8b 45 08             	mov    0x8(%ebp),%eax
8010138c:	8b 40 10             	mov    0x10(%eax),%eax
8010138f:	89 04 24             	mov    %eax,(%esp)
80101392:	e8 a7 07 00 00       	call   80101b3e <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101397:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	8b 50 14             	mov    0x14(%eax),%edx
801013a0:	8b 45 08             	mov    0x8(%ebp),%eax
801013a3:	8b 40 10             	mov    0x10(%eax),%eax
801013a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801013aa:	89 54 24 08          	mov    %edx,0x8(%esp)
801013ae:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b1:	89 54 24 04          	mov    %edx,0x4(%esp)
801013b5:	89 04 24             	mov    %eax,(%esp)
801013b8:	e8 18 0c 00 00       	call   80101fd5 <readi>
801013bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801013c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801013c4:	7e 11                	jle    801013d7 <fileread+0x9a>
      f->off += r;
801013c6:	8b 45 08             	mov    0x8(%ebp),%eax
801013c9:	8b 50 14             	mov    0x14(%eax),%edx
801013cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013cf:	01 c2                	add    %eax,%edx
801013d1:	8b 45 08             	mov    0x8(%ebp),%eax
801013d4:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801013d7:	8b 45 08             	mov    0x8(%ebp),%eax
801013da:	8b 40 10             	mov    0x10(%eax),%eax
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	e8 63 08 00 00       	call   80101c48 <iunlock>
    return r;
801013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e8:	eb 0c                	jmp    801013f6 <fileread+0xb9>
  }
  panic("fileread");
801013ea:	c7 04 24 5f 91 10 80 	movl   $0x8010915f,(%esp)
801013f1:	e8 8c f1 ff ff       	call   80100582 <panic>
}
801013f6:	c9                   	leave  
801013f7:	c3                   	ret    

801013f8 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013f8:	55                   	push   %ebp
801013f9:	89 e5                	mov    %esp,%ebp
801013fb:	53                   	push   %ebx
801013fc:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801013ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101402:	8a 40 09             	mov    0x9(%eax),%al
80101405:	84 c0                	test   %al,%al
80101407:	75 0a                	jne    80101413 <filewrite+0x1b>
    return -1;
80101409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010140e:	e9 20 01 00 00       	jmp    80101533 <filewrite+0x13b>
  if(f->type == FD_PIPE)
80101413:	8b 45 08             	mov    0x8(%ebp),%eax
80101416:	8b 00                	mov    (%eax),%eax
80101418:	83 f8 01             	cmp    $0x1,%eax
8010141b:	75 21                	jne    8010143e <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
8010141d:	8b 45 08             	mov    0x8(%ebp),%eax
80101420:	8b 40 0c             	mov    0xc(%eax),%eax
80101423:	8b 55 10             	mov    0x10(%ebp),%edx
80101426:	89 54 24 08          	mov    %edx,0x8(%esp)
8010142a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010142d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101431:	89 04 24             	mov    %eax,(%esp)
80101434:	e8 20 2c 00 00       	call   80104059 <pipewrite>
80101439:	e9 f5 00 00 00       	jmp    80101533 <filewrite+0x13b>
  if(f->type == FD_INODE){
8010143e:	8b 45 08             	mov    0x8(%ebp),%eax
80101441:	8b 00                	mov    (%eax),%eax
80101443:	83 f8 02             	cmp    $0x2,%eax
80101446:	0f 85 db 00 00 00    	jne    80101527 <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010144c:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010145a:	e9 a8 00 00 00       	jmp    80101507 <filewrite+0x10f>
      int n1 = n - i;
8010145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101462:	8b 55 10             	mov    0x10(%ebp),%edx
80101465:	29 c2                	sub    %eax,%edx
80101467:	89 d0                	mov    %edx,%eax
80101469:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101472:	7e 06                	jle    8010147a <filewrite+0x82>
        n1 = max;
80101474:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101477:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010147a:	e8 b8 21 00 00       	call   80103637 <begin_op>
      ilock(f->ip);
8010147f:	8b 45 08             	mov    0x8(%ebp),%eax
80101482:	8b 40 10             	mov    0x10(%eax),%eax
80101485:	89 04 24             	mov    %eax,(%esp)
80101488:	e8 b1 06 00 00       	call   80101b3e <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010148d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101490:	8b 45 08             	mov    0x8(%ebp),%eax
80101493:	8b 50 14             	mov    0x14(%eax),%edx
80101496:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010149c:	01 c3                	add    %eax,%ebx
8010149e:	8b 45 08             	mov    0x8(%ebp),%eax
801014a1:	8b 40 10             	mov    0x10(%eax),%eax
801014a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801014a8:	89 54 24 08          	mov    %edx,0x8(%esp)
801014ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801014b0:	89 04 24             	mov    %eax,(%esp)
801014b3:	e8 81 0c 00 00       	call   80102139 <writei>
801014b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
801014bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801014bf:	7e 11                	jle    801014d2 <filewrite+0xda>
        f->off += r;
801014c1:	8b 45 08             	mov    0x8(%ebp),%eax
801014c4:	8b 50 14             	mov    0x14(%eax),%edx
801014c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014ca:	01 c2                	add    %eax,%edx
801014cc:	8b 45 08             	mov    0x8(%ebp),%eax
801014cf:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801014d2:	8b 45 08             	mov    0x8(%ebp),%eax
801014d5:	8b 40 10             	mov    0x10(%eax),%eax
801014d8:	89 04 24             	mov    %eax,(%esp)
801014db:	e8 68 07 00 00       	call   80101c48 <iunlock>
      end_op();
801014e0:	e8 d4 21 00 00       	call   801036b9 <end_op>

      if(r < 0)
801014e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801014e9:	79 02                	jns    801014ed <filewrite+0xf5>
        break;
801014eb:	eb 26                	jmp    80101513 <filewrite+0x11b>
      if(r != n1)
801014ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801014f3:	74 0c                	je     80101501 <filewrite+0x109>
        panic("short filewrite");
801014f5:	c7 04 24 68 91 10 80 	movl   $0x80109168,(%esp)
801014fc:	e8 81 f0 ff ff       	call   80100582 <panic>
      i += r;
80101501:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101504:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010150a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010150d:	0f 8c 4c ff ff ff    	jl     8010145f <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101516:	3b 45 10             	cmp    0x10(%ebp),%eax
80101519:	75 05                	jne    80101520 <filewrite+0x128>
8010151b:	8b 45 10             	mov    0x10(%ebp),%eax
8010151e:	eb 05                	jmp    80101525 <filewrite+0x12d>
80101520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101525:	eb 0c                	jmp    80101533 <filewrite+0x13b>
  }
  panic("filewrite");
80101527:	c7 04 24 78 91 10 80 	movl   $0x80109178,(%esp)
8010152e:	e8 4f f0 ff ff       	call   80100582 <panic>
}
80101533:	83 c4 24             	add    $0x24,%esp
80101536:	5b                   	pop    %ebx
80101537:	5d                   	pop    %ebp
80101538:	c3                   	ret    
80101539:	00 00                	add    %al,(%eax)
	...

8010153c <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010153c:	55                   	push   %ebp
8010153d:	89 e5                	mov    %esp,%ebp
8010153f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101542:	8b 45 08             	mov    0x8(%ebp),%eax
80101545:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010154c:	00 
8010154d:	89 04 24             	mov    %eax,(%esp)
80101550:	e8 60 ec ff ff       	call   801001b5 <bread>
80101555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155b:	83 c0 5c             	add    $0x5c,%eax
8010155e:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101565:	00 
80101566:	89 44 24 04          	mov    %eax,0x4(%esp)
8010156a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010156d:	89 04 24             	mov    %eax,(%esp)
80101570:	e8 f6 3c 00 00       	call   8010526b <memmove>
  brelse(bp);
80101575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101578:	89 04 24             	mov    %eax,(%esp)
8010157b:	e8 ac ec ff ff       	call   8010022c <brelse>
}
80101580:	c9                   	leave  
80101581:	c3                   	ret    

80101582 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101582:	55                   	push   %ebp
80101583:	89 e5                	mov    %esp,%ebp
80101585:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101588:	8b 55 0c             	mov    0xc(%ebp),%edx
8010158b:	8b 45 08             	mov    0x8(%ebp),%eax
8010158e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101592:	89 04 24             	mov    %eax,(%esp)
80101595:	e8 1b ec ff ff       	call   801001b5 <bread>
8010159a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a0:	83 c0 5c             	add    $0x5c,%eax
801015a3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 04 24             	mov    %eax,(%esp)
801015b6:	e8 e7 3b 00 00       	call   801051a2 <memset>
  log_write(bp);
801015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015be:	89 04 24             	mov    %eax,(%esp)
801015c1:	e8 75 22 00 00       	call   8010383b <log_write>
  brelse(bp);
801015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c9:	89 04 24             	mov    %eax,(%esp)
801015cc:	e8 5b ec ff ff       	call   8010022c <brelse>
}
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    

801015d3 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801015d3:	55                   	push   %ebp
801015d4:	89 e5                	mov    %esp,%ebp
801015d6:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801015d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801015e7:	e9 03 01 00 00       	jmp    801016ef <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
801015ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ef:	85 c0                	test   %eax,%eax
801015f1:	79 05                	jns    801015f8 <balloc+0x25>
801015f3:	05 ff 0f 00 00       	add    $0xfff,%eax
801015f8:	c1 f8 0c             	sar    $0xc,%eax
801015fb:	89 c2                	mov    %eax,%edx
801015fd:	a1 18 2f 11 80       	mov    0x80112f18,%eax
80101602:	01 d0                	add    %edx,%eax
80101604:	89 44 24 04          	mov    %eax,0x4(%esp)
80101608:	8b 45 08             	mov    0x8(%ebp),%eax
8010160b:	89 04 24             	mov    %eax,(%esp)
8010160e:	e8 a2 eb ff ff       	call   801001b5 <bread>
80101613:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101616:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010161d:	e9 9b 00 00 00       	jmp    801016bd <balloc+0xea>
      m = 1 << (bi % 8);
80101622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101625:	25 07 00 00 80       	and    $0x80000007,%eax
8010162a:	85 c0                	test   %eax,%eax
8010162c:	79 05                	jns    80101633 <balloc+0x60>
8010162e:	48                   	dec    %eax
8010162f:	83 c8 f8             	or     $0xfffffff8,%eax
80101632:	40                   	inc    %eax
80101633:	ba 01 00 00 00       	mov    $0x1,%edx
80101638:	88 c1                	mov    %al,%cl
8010163a:	d3 e2                	shl    %cl,%edx
8010163c:	89 d0                	mov    %edx,%eax
8010163e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101644:	85 c0                	test   %eax,%eax
80101646:	79 03                	jns    8010164b <balloc+0x78>
80101648:	83 c0 07             	add    $0x7,%eax
8010164b:	c1 f8 03             	sar    $0x3,%eax
8010164e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101651:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101655:	0f b6 c0             	movzbl %al,%eax
80101658:	23 45 e8             	and    -0x18(%ebp),%eax
8010165b:	85 c0                	test   %eax,%eax
8010165d:	75 5b                	jne    801016ba <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
8010165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101662:	85 c0                	test   %eax,%eax
80101664:	79 03                	jns    80101669 <balloc+0x96>
80101666:	83 c0 07             	add    $0x7,%eax
80101669:	c1 f8 03             	sar    $0x3,%eax
8010166c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010166f:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101673:	88 d1                	mov    %dl,%cl
80101675:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101678:	09 ca                	or     %ecx,%edx
8010167a:	88 d1                	mov    %dl,%cl
8010167c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010167f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101683:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101686:	89 04 24             	mov    %eax,(%esp)
80101689:	e8 ad 21 00 00       	call   8010383b <log_write>
        brelse(bp);
8010168e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101691:	89 04 24             	mov    %eax,(%esp)
80101694:	e8 93 eb ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101699:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010169f:	01 c2                	add    %eax,%edx
801016a1:	8b 45 08             	mov    0x8(%ebp),%eax
801016a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801016a8:	89 04 24             	mov    %eax,(%esp)
801016ab:	e8 d2 fe ff ff       	call   80101582 <bzero>
        return b + bi;
801016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b6:	01 d0                	add    %edx,%eax
801016b8:	eb 51                	jmp    8010170b <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016ba:	ff 45 f0             	incl   -0x10(%ebp)
801016bd:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801016c4:	7f 17                	jg     801016dd <balloc+0x10a>
801016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016cc:	01 d0                	add    %edx,%eax
801016ce:	89 c2                	mov    %eax,%edx
801016d0:	a1 00 2f 11 80       	mov    0x80112f00,%eax
801016d5:	39 c2                	cmp    %eax,%edx
801016d7:	0f 82 45 ff ff ff    	jb     80101622 <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801016dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016e0:	89 04 24             	mov    %eax,(%esp)
801016e3:	e8 44 eb ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801016ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016f2:	a1 00 2f 11 80       	mov    0x80112f00,%eax
801016f7:	39 c2                	cmp    %eax,%edx
801016f9:	0f 82 ed fe ff ff    	jb     801015ec <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016ff:	c7 04 24 84 91 10 80 	movl   $0x80109184,(%esp)
80101706:	e8 77 ee ff ff       	call   80100582 <panic>
}
8010170b:	c9                   	leave  
8010170c:	c3                   	ret    

8010170d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010170d:	55                   	push   %ebp
8010170e:	89 e5                	mov    %esp,%ebp
80101710:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101713:	c7 44 24 04 00 2f 11 	movl   $0x80112f00,0x4(%esp)
8010171a:	80 
8010171b:	8b 45 08             	mov    0x8(%ebp),%eax
8010171e:	89 04 24             	mov    %eax,(%esp)
80101721:	e8 16 fe ff ff       	call   8010153c <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101726:	8b 45 0c             	mov    0xc(%ebp),%eax
80101729:	c1 e8 0c             	shr    $0xc,%eax
8010172c:	89 c2                	mov    %eax,%edx
8010172e:	a1 18 2f 11 80       	mov    0x80112f18,%eax
80101733:	01 c2                	add    %eax,%edx
80101735:	8b 45 08             	mov    0x8(%ebp),%eax
80101738:	89 54 24 04          	mov    %edx,0x4(%esp)
8010173c:	89 04 24             	mov    %eax,(%esp)
8010173f:	e8 71 ea ff ff       	call   801001b5 <bread>
80101744:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101747:	8b 45 0c             	mov    0xc(%ebp),%eax
8010174a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101752:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101755:	25 07 00 00 80       	and    $0x80000007,%eax
8010175a:	85 c0                	test   %eax,%eax
8010175c:	79 05                	jns    80101763 <bfree+0x56>
8010175e:	48                   	dec    %eax
8010175f:	83 c8 f8             	or     $0xfffffff8,%eax
80101762:	40                   	inc    %eax
80101763:	ba 01 00 00 00       	mov    $0x1,%edx
80101768:	88 c1                	mov    %al,%cl
8010176a:	d3 e2                	shl    %cl,%edx
8010176c:	89 d0                	mov    %edx,%eax
8010176e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101771:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101774:	85 c0                	test   %eax,%eax
80101776:	79 03                	jns    8010177b <bfree+0x6e>
80101778:	83 c0 07             	add    $0x7,%eax
8010177b:	c1 f8 03             	sar    $0x3,%eax
8010177e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101781:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101785:	0f b6 c0             	movzbl %al,%eax
80101788:	23 45 ec             	and    -0x14(%ebp),%eax
8010178b:	85 c0                	test   %eax,%eax
8010178d:	75 0c                	jne    8010179b <bfree+0x8e>
    panic("freeing free block");
8010178f:	c7 04 24 9a 91 10 80 	movl   $0x8010919a,(%esp)
80101796:	e8 e7 ed ff ff       	call   80100582 <panic>
  bp->data[bi/8] &= ~m;
8010179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179e:	85 c0                	test   %eax,%eax
801017a0:	79 03                	jns    801017a5 <bfree+0x98>
801017a2:	83 c0 07             	add    $0x7,%eax
801017a5:	c1 f8 03             	sar    $0x3,%eax
801017a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017ab:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
801017af:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801017b2:	f7 d1                	not    %ecx
801017b4:	21 ca                	and    %ecx,%edx
801017b6:	88 d1                	mov    %dl,%cl
801017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017bb:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801017bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c2:	89 04 24             	mov    %eax,(%esp)
801017c5:	e8 71 20 00 00       	call   8010383b <log_write>
  brelse(bp);
801017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cd:	89 04 24             	mov    %eax,(%esp)
801017d0:	e8 57 ea ff ff       	call   8010022c <brelse>
}
801017d5:	c9                   	leave  
801017d6:	c3                   	ret    

801017d7 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801017d7:	55                   	push   %ebp
801017d8:	89 e5                	mov    %esp,%ebp
801017da:	57                   	push   %edi
801017db:	56                   	push   %esi
801017dc:	53                   	push   %ebx
801017dd:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801017e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801017e7:	c7 44 24 04 ad 91 10 	movl   $0x801091ad,0x4(%esp)
801017ee:	80 
801017ef:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
801017f6:	e8 23 37 00 00       	call   80104f1e <initlock>
  for(i = 0; i < NINODE; i++) {
801017fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101802:	eb 2b                	jmp    8010182f <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
80101804:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101807:	89 d0                	mov    %edx,%eax
80101809:	c1 e0 03             	shl    $0x3,%eax
8010180c:	01 d0                	add    %edx,%eax
8010180e:	c1 e0 04             	shl    $0x4,%eax
80101811:	83 c0 30             	add    $0x30,%eax
80101814:	05 20 2f 11 80       	add    $0x80112f20,%eax
80101819:	83 c0 10             	add    $0x10,%eax
8010181c:	c7 44 24 04 b4 91 10 	movl   $0x801091b4,0x4(%esp)
80101823:	80 
80101824:	89 04 24             	mov    %eax,(%esp)
80101827:	e8 b4 35 00 00       	call   80104de0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
8010182c:	ff 45 e4             	incl   -0x1c(%ebp)
8010182f:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101833:	7e cf                	jle    80101804 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101835:	c7 44 24 04 00 2f 11 	movl   $0x80112f00,0x4(%esp)
8010183c:	80 
8010183d:	8b 45 08             	mov    0x8(%ebp),%eax
80101840:	89 04 24             	mov    %eax,(%esp)
80101843:	e8 f4 fc ff ff       	call   8010153c <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101848:	a1 18 2f 11 80       	mov    0x80112f18,%eax
8010184d:	8b 3d 14 2f 11 80    	mov    0x80112f14,%edi
80101853:	8b 35 10 2f 11 80    	mov    0x80112f10,%esi
80101859:	8b 1d 0c 2f 11 80    	mov    0x80112f0c,%ebx
8010185f:	8b 0d 08 2f 11 80    	mov    0x80112f08,%ecx
80101865:	8b 15 04 2f 11 80    	mov    0x80112f04,%edx
8010186b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010186e:	8b 15 00 2f 11 80    	mov    0x80112f00,%edx
80101874:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101878:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010187c:	89 74 24 14          	mov    %esi,0x14(%esp)
80101880:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101884:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010188b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010188f:	89 d0                	mov    %edx,%eax
80101891:	89 44 24 04          	mov    %eax,0x4(%esp)
80101895:	c7 04 24 bc 91 10 80 	movl   $0x801091bc,(%esp)
8010189c:	e8 4e eb ff ff       	call   801003ef <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801018a1:	83 c4 4c             	add    $0x4c,%esp
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5f                   	pop    %edi
801018a7:	5d                   	pop    %ebp
801018a8:	c3                   	ret    

801018a9 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018a9:	55                   	push   %ebp
801018aa:	89 e5                	mov    %esp,%ebp
801018ac:	83 ec 28             	sub    $0x28,%esp
801018af:	8b 45 0c             	mov    0xc(%ebp),%eax
801018b2:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801018bd:	e9 9b 00 00 00       	jmp    8010195d <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
801018c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c5:	c1 e8 03             	shr    $0x3,%eax
801018c8:	89 c2                	mov    %eax,%edx
801018ca:	a1 14 2f 11 80       	mov    0x80112f14,%eax
801018cf:	01 d0                	add    %edx,%eax
801018d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
801018d8:	89 04 24             	mov    %eax,(%esp)
801018db:	e8 d5 e8 ff ff       	call   801001b5 <bread>
801018e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e6:	8d 50 5c             	lea    0x5c(%eax),%edx
801018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ec:	83 e0 07             	and    $0x7,%eax
801018ef:	c1 e0 06             	shl    $0x6,%eax
801018f2:	01 d0                	add    %edx,%eax
801018f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801018f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018fa:	8b 00                	mov    (%eax),%eax
801018fc:	66 85 c0             	test   %ax,%ax
801018ff:	75 4e                	jne    8010194f <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
80101901:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101908:	00 
80101909:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101910:	00 
80101911:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101914:	89 04 24             	mov    %eax,(%esp)
80101917:	e8 86 38 00 00       	call   801051a2 <memset>
      dip->type = type;
8010191c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010191f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101922:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101928:	89 04 24             	mov    %eax,(%esp)
8010192b:	e8 0b 1f 00 00       	call   8010383b <log_write>
      brelse(bp);
80101930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101933:	89 04 24             	mov    %eax,(%esp)
80101936:	e8 f1 e8 ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
8010193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101942:	8b 45 08             	mov    0x8(%ebp),%eax
80101945:	89 04 24             	mov    %eax,(%esp)
80101948:	e8 ea 00 00 00       	call   80101a37 <iget>
8010194d:	eb 2a                	jmp    80101979 <ialloc+0xd0>
    }
    brelse(bp);
8010194f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101952:	89 04 24             	mov    %eax,(%esp)
80101955:	e8 d2 e8 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010195a:	ff 45 f4             	incl   -0xc(%ebp)
8010195d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101960:	a1 08 2f 11 80       	mov    0x80112f08,%eax
80101965:	39 c2                	cmp    %eax,%edx
80101967:	0f 82 55 ff ff ff    	jb     801018c2 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010196d:	c7 04 24 0f 92 10 80 	movl   $0x8010920f,(%esp)
80101974:	e8 09 ec ff ff       	call   80100582 <panic>
}
80101979:	c9                   	leave  
8010197a:	c3                   	ret    

8010197b <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010197b:	55                   	push   %ebp
8010197c:	89 e5                	mov    %esp,%ebp
8010197e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 04             	mov    0x4(%eax),%eax
80101987:	c1 e8 03             	shr    $0x3,%eax
8010198a:	89 c2                	mov    %eax,%edx
8010198c:	a1 14 2f 11 80       	mov    0x80112f14,%eax
80101991:	01 c2                	add    %eax,%edx
80101993:	8b 45 08             	mov    0x8(%ebp),%eax
80101996:	8b 00                	mov    (%eax),%eax
80101998:	89 54 24 04          	mov    %edx,0x4(%esp)
8010199c:	89 04 24             	mov    %eax,(%esp)
8010199f:	e8 11 e8 ff ff       	call   801001b5 <bread>
801019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019aa:	8d 50 5c             	lea    0x5c(%eax),%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 04             	mov    0x4(%eax),%eax
801019b3:	83 e0 07             	and    $0x7,%eax
801019b6:	c1 e0 06             	shl    $0x6,%eax
801019b9:	01 d0                	add    %edx,%eax
801019bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801019be:	8b 45 08             	mov    0x8(%ebp),%eax
801019c1:	8b 40 50             	mov    0x50(%eax),%eax
801019c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019c7:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
801019cd:	66 8b 40 52          	mov    0x52(%eax),%ax
801019d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019d4:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801019d8:	8b 45 08             	mov    0x8(%ebp),%eax
801019db:	8b 40 54             	mov    0x54(%eax),%eax
801019de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019e1:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801019e5:	8b 45 08             	mov    0x8(%ebp),%eax
801019e8:	66 8b 40 56          	mov    0x56(%eax),%ax
801019ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019ef:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801019f3:	8b 45 08             	mov    0x8(%ebp),%eax
801019f6:	8b 50 58             	mov    0x58(%eax),%edx
801019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fc:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101a02:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a08:	83 c0 0c             	add    $0xc,%eax
80101a0b:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a12:	00 
80101a13:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a17:	89 04 24             	mov    %eax,(%esp)
80101a1a:	e8 4c 38 00 00       	call   8010526b <memmove>
  log_write(bp);
80101a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a22:	89 04 24             	mov    %eax,(%esp)
80101a25:	e8 11 1e 00 00       	call   8010383b <log_write>
  brelse(bp);
80101a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2d:	89 04 24             	mov    %eax,(%esp)
80101a30:	e8 f7 e7 ff ff       	call   8010022c <brelse>
}
80101a35:	c9                   	leave  
80101a36:	c3                   	ret    

80101a37 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101a37:	55                   	push   %ebp
80101a38:	89 e5                	mov    %esp,%ebp
80101a3a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101a3d:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101a44:	e8 f6 34 00 00       	call   80104f3f <acquire>

  // Is the inode already cached?
  empty = 0;
80101a49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a50:	c7 45 f4 54 2f 11 80 	movl   $0x80112f54,-0xc(%ebp)
80101a57:	eb 5c                	jmp    80101ab5 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5c:	8b 40 08             	mov    0x8(%eax),%eax
80101a5f:	85 c0                	test   %eax,%eax
80101a61:	7e 35                	jle    80101a98 <iget+0x61>
80101a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a66:	8b 00                	mov    (%eax),%eax
80101a68:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a6b:	75 2b                	jne    80101a98 <iget+0x61>
80101a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a70:	8b 40 04             	mov    0x4(%eax),%eax
80101a73:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a76:	75 20                	jne    80101a98 <iget+0x61>
      ip->ref++;
80101a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7b:	8b 40 08             	mov    0x8(%eax),%eax
80101a7e:	8d 50 01             	lea    0x1(%eax),%edx
80101a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a84:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a87:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101a8e:	e8 16 35 00 00       	call   80104fa9 <release>
      return ip;
80101a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a96:	eb 72                	jmp    80101b0a <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a9c:	75 10                	jne    80101aae <iget+0x77>
80101a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa1:	8b 40 08             	mov    0x8(%eax),%eax
80101aa4:	85 c0                	test   %eax,%eax
80101aa6:	75 06                	jne    80101aae <iget+0x77>
      empty = ip;
80101aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aab:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101aae:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101ab5:	81 7d f4 74 4b 11 80 	cmpl   $0x80114b74,-0xc(%ebp)
80101abc:	72 9b                	jb     80101a59 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101ac2:	75 0c                	jne    80101ad0 <iget+0x99>
    panic("iget: no inodes");
80101ac4:	c7 04 24 21 92 10 80 	movl   $0x80109221,(%esp)
80101acb:	e8 b2 ea ff ff       	call   80100582 <panic>

  ip = empty;
80101ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ad9:	8b 55 08             	mov    0x8(%ebp),%edx
80101adc:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ae4:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101af4:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101afb:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101b02:	e8 a2 34 00 00       	call   80104fa9 <release>

  return ip;
80101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101b0a:	c9                   	leave  
80101b0b:	c3                   	ret    

80101b0c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101b0c:	55                   	push   %ebp
80101b0d:	89 e5                	mov    %esp,%ebp
80101b0f:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101b12:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101b19:	e8 21 34 00 00       	call   80104f3f <acquire>
  ip->ref++;
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	8b 40 08             	mov    0x8(%eax),%eax
80101b24:	8d 50 01             	lea    0x1(%eax),%edx
80101b27:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b2d:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101b34:	e8 70 34 00 00       	call   80104fa9 <release>
  return ip;
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b3c:	c9                   	leave  
80101b3d:	c3                   	ret    

80101b3e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b3e:	55                   	push   %ebp
80101b3f:	89 e5                	mov    %esp,%ebp
80101b41:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b48:	74 0a                	je     80101b54 <ilock+0x16>
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	8b 40 08             	mov    0x8(%eax),%eax
80101b50:	85 c0                	test   %eax,%eax
80101b52:	7f 0c                	jg     80101b60 <ilock+0x22>
    panic("ilock");
80101b54:	c7 04 24 31 92 10 80 	movl   $0x80109231,(%esp)
80101b5b:	e8 22 ea ff ff       	call   80100582 <panic>

  acquiresleep(&ip->lock);
80101b60:	8b 45 08             	mov    0x8(%ebp),%eax
80101b63:	83 c0 0c             	add    $0xc,%eax
80101b66:	89 04 24             	mov    %eax,(%esp)
80101b69:	e8 ac 32 00 00       	call   80104e1a <acquiresleep>

  if(ip->valid == 0){
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b74:	85 c0                	test   %eax,%eax
80101b76:	0f 85 ca 00 00 00    	jne    80101c46 <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	8b 40 04             	mov    0x4(%eax),%eax
80101b82:	c1 e8 03             	shr    $0x3,%eax
80101b85:	89 c2                	mov    %eax,%edx
80101b87:	a1 14 2f 11 80       	mov    0x80112f14,%eax
80101b8c:	01 c2                	add    %eax,%edx
80101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b91:	8b 00                	mov    (%eax),%eax
80101b93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 16 e6 ff ff       	call   801001b5 <bread>
80101b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba5:	8d 50 5c             	lea    0x5c(%eax),%edx
80101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bab:	8b 40 04             	mov    0x4(%eax),%eax
80101bae:	83 e0 07             	and    $0x7,%eax
80101bb1:	c1 e0 06             	shl    $0x6,%eax
80101bb4:	01 d0                	add    %edx,%eax
80101bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bbc:	8b 00                	mov    (%eax),%eax
80101bbe:	8b 55 08             	mov    0x8(%ebp),%edx
80101bc1:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc8:	66 8b 40 02          	mov    0x2(%eax),%ax
80101bcc:	8b 55 08             	mov    0x8(%ebp),%edx
80101bcf:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd6:	8b 40 04             	mov    0x4(%eax),%eax
80101bd9:	8b 55 08             	mov    0x8(%ebp),%edx
80101bdc:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be3:	66 8b 40 06          	mov    0x6(%eax),%ax
80101be7:	8b 55 08             	mov    0x8(%ebp),%edx
80101bea:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf1:	8b 50 08             	mov    0x8(%eax),%edx
80101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf7:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfd:	8d 50 0c             	lea    0xc(%eax),%edx
80101c00:	8b 45 08             	mov    0x8(%ebp),%eax
80101c03:	83 c0 5c             	add    $0x5c,%eax
80101c06:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101c0d:	00 
80101c0e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c12:	89 04 24             	mov    %eax,(%esp)
80101c15:	e8 51 36 00 00       	call   8010526b <memmove>
    brelse(bp);
80101c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c1d:	89 04 24             	mov    %eax,(%esp)
80101c20:	e8 07 e6 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	8b 40 50             	mov    0x50(%eax),%eax
80101c35:	66 85 c0             	test   %ax,%ax
80101c38:	75 0c                	jne    80101c46 <ilock+0x108>
      panic("ilock: no type");
80101c3a:	c7 04 24 37 92 10 80 	movl   $0x80109237,(%esp)
80101c41:	e8 3c e9 ff ff       	call   80100582 <panic>
  }
}
80101c46:	c9                   	leave  
80101c47:	c3                   	ret    

80101c48 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c48:	55                   	push   %ebp
80101c49:	89 e5                	mov    %esp,%ebp
80101c4b:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c52:	74 1c                	je     80101c70 <iunlock+0x28>
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	83 c0 0c             	add    $0xc,%eax
80101c5a:	89 04 24             	mov    %eax,(%esp)
80101c5d:	e8 55 32 00 00       	call   80104eb7 <holdingsleep>
80101c62:	85 c0                	test   %eax,%eax
80101c64:	74 0a                	je     80101c70 <iunlock+0x28>
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 40 08             	mov    0x8(%eax),%eax
80101c6c:	85 c0                	test   %eax,%eax
80101c6e:	7f 0c                	jg     80101c7c <iunlock+0x34>
    panic("iunlock");
80101c70:	c7 04 24 46 92 10 80 	movl   $0x80109246,(%esp)
80101c77:	e8 06 e9 ff ff       	call   80100582 <panic>

  releasesleep(&ip->lock);
80101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7f:	83 c0 0c             	add    $0xc,%eax
80101c82:	89 04 24             	mov    %eax,(%esp)
80101c85:	e8 eb 31 00 00       	call   80104e75 <releasesleep>
}
80101c8a:	c9                   	leave  
80101c8b:	c3                   	ret    

80101c8c <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c8c:	55                   	push   %ebp
80101c8d:	89 e5                	mov    %esp,%ebp
80101c8f:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101c92:	8b 45 08             	mov    0x8(%ebp),%eax
80101c95:	83 c0 0c             	add    $0xc,%eax
80101c98:	89 04 24             	mov    %eax,(%esp)
80101c9b:	e8 7a 31 00 00       	call   80104e1a <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ca6:	85 c0                	test   %eax,%eax
80101ca8:	74 5c                	je     80101d06 <iput+0x7a>
80101caa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cad:	66 8b 40 56          	mov    0x56(%eax),%ax
80101cb1:	66 85 c0             	test   %ax,%ax
80101cb4:	75 50                	jne    80101d06 <iput+0x7a>
    acquire(&icache.lock);
80101cb6:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101cbd:	e8 7d 32 00 00       	call   80104f3f <acquire>
    int r = ip->ref;
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 40 08             	mov    0x8(%eax),%eax
80101cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101ccb:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101cd2:	e8 d2 32 00 00       	call   80104fa9 <release>
    if(r == 1){
80101cd7:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101cdb:	75 29                	jne    80101d06 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce0:	89 04 24             	mov    %eax,(%esp)
80101ce3:	e8 86 01 00 00       	call   80101e6e <itrunc>
      ip->type = 0;
80101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ceb:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	89 04 24             	mov    %eax,(%esp)
80101cf7:	e8 7f fc ff ff       	call   8010197b <iupdate>
      ip->valid = 0;
80101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101cff:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101d06:	8b 45 08             	mov    0x8(%ebp),%eax
80101d09:	83 c0 0c             	add    $0xc,%eax
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 61 31 00 00       	call   80104e75 <releasesleep>

  acquire(&icache.lock);
80101d14:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101d1b:	e8 1f 32 00 00       	call   80104f3f <acquire>
  ip->ref--;
80101d20:	8b 45 08             	mov    0x8(%ebp),%eax
80101d23:	8b 40 08             	mov    0x8(%eax),%eax
80101d26:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d2f:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80101d36:	e8 6e 32 00 00       	call   80104fa9 <release>
}
80101d3b:	c9                   	leave  
80101d3c:	c3                   	ret    

80101d3d <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d3d:	55                   	push   %ebp
80101d3e:	89 e5                	mov    %esp,%ebp
80101d40:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101d43:	8b 45 08             	mov    0x8(%ebp),%eax
80101d46:	89 04 24             	mov    %eax,(%esp)
80101d49:	e8 fa fe ff ff       	call   80101c48 <iunlock>
  iput(ip);
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	89 04 24             	mov    %eax,(%esp)
80101d54:	e8 33 ff ff ff       	call   80101c8c <iput>
}
80101d59:	c9                   	leave  
80101d5a:	c3                   	ret    

80101d5b <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d5b:	55                   	push   %ebp
80101d5c:	89 e5                	mov    %esp,%ebp
80101d5e:	53                   	push   %ebx
80101d5f:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d62:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d66:	77 3e                	ja     80101da6 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101d68:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d6e:	83 c2 14             	add    $0x14,%edx
80101d71:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d7c:	75 20                	jne    80101d9e <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	8b 00                	mov    (%eax),%eax
80101d83:	89 04 24             	mov    %eax,(%esp)
80101d86:	e8 48 f8 ff ff       	call   801015d3 <balloc>
80101d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d91:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d94:	8d 4a 14             	lea    0x14(%edx),%ecx
80101d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101da1:	e9 c2 00 00 00       	jmp    80101e68 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101da6:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101daa:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dae:	0f 87 a8 00 00 00    	ja     80101e5c <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101db4:	8b 45 08             	mov    0x8(%ebp),%eax
80101db7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dc4:	75 1c                	jne    80101de2 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc9:	8b 00                	mov    (%eax),%eax
80101dcb:	89 04 24             	mov    %eax,(%esp)
80101dce:	e8 00 f8 ff ff       	call   801015d3 <balloc>
80101dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ddc:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101de2:	8b 45 08             	mov    0x8(%ebp),%eax
80101de5:	8b 00                	mov    (%eax),%eax
80101de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dea:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dee:	89 04 24             	mov    %eax,(%esp)
80101df1:	e8 bf e3 ff ff       	call   801001b5 <bread>
80101df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dfc:	83 c0 5c             	add    $0x5c,%eax
80101dff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e0f:	01 d0                	add    %edx,%eax
80101e11:	8b 00                	mov    (%eax),%eax
80101e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e1a:	75 30                	jne    80101e4c <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e29:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2f:	8b 00                	mov    (%eax),%eax
80101e31:	89 04 24             	mov    %eax,(%esp)
80101e34:	e8 9a f7 ff ff       	call   801015d3 <balloc>
80101e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e3f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e44:	89 04 24             	mov    %eax,(%esp)
80101e47:	e8 ef 19 00 00       	call   8010383b <log_write>
    }
    brelse(bp);
80101e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e4f:	89 04 24             	mov    %eax,(%esp)
80101e52:	e8 d5 e3 ff ff       	call   8010022c <brelse>
    return addr;
80101e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e5a:	eb 0c                	jmp    80101e68 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101e5c:	c7 04 24 4e 92 10 80 	movl   $0x8010924e,(%esp)
80101e63:	e8 1a e7 ff ff       	call   80100582 <panic>
}
80101e68:	83 c4 24             	add    $0x24,%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5d                   	pop    %ebp
80101e6d:	c3                   	ret    

80101e6e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e6e:	55                   	push   %ebp
80101e6f:	89 e5                	mov    %esp,%ebp
80101e71:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e7b:	eb 43                	jmp    80101ec0 <itrunc+0x52>
    if(ip->addrs[i]){
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e83:	83 c2 14             	add    $0x14,%edx
80101e86:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	74 2f                	je     80101ebd <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e94:	83 c2 14             	add    $0x14,%edx
80101e97:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 00                	mov    (%eax),%eax
80101ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea4:	89 04 24             	mov    %eax,(%esp)
80101ea7:	e8 61 f8 ff ff       	call   8010170d <bfree>
      ip->addrs[i] = 0;
80101eac:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eb2:	83 c2 14             	add    $0x14,%edx
80101eb5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ebc:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ebd:	ff 45 f4             	incl   -0xc(%ebp)
80101ec0:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ec4:	7e b7                	jle    80101e7d <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ecf:	85 c0                	test   %eax,%eax
80101ed1:	0f 84 a3 00 00 00    	je     80101f7a <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee3:	8b 00                	mov    (%eax),%eax
80101ee5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ee9:	89 04 24             	mov    %eax,(%esp)
80101eec:	e8 c4 e2 ff ff       	call   801001b5 <bread>
80101ef1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef7:	83 c0 5c             	add    $0x5c,%eax
80101efa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101efd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f04:	eb 3a                	jmp    80101f40 <itrunc+0xd2>
      if(a[j])
80101f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f13:	01 d0                	add    %edx,%eax
80101f15:	8b 00                	mov    (%eax),%eax
80101f17:	85 c0                	test   %eax,%eax
80101f19:	74 22                	je     80101f3d <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f28:	01 d0                	add    %edx,%eax
80101f2a:	8b 10                	mov    (%eax),%edx
80101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2f:	8b 00                	mov    (%eax),%eax
80101f31:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f35:	89 04 24             	mov    %eax,(%esp)
80101f38:	e8 d0 f7 ff ff       	call   8010170d <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101f3d:	ff 45 f0             	incl   -0x10(%ebp)
80101f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f43:	83 f8 7f             	cmp    $0x7f,%eax
80101f46:	76 be                	jbe    80101f06 <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f4b:	89 04 24             	mov    %eax,(%esp)
80101f4e:	e8 d9 e2 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	8b 00                	mov    (%eax),%eax
80101f61:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f65:	89 04 24             	mov    %eax,(%esp)
80101f68:	e8 a0 f7 ff ff       	call   8010170d <bfree>
    ip->addrs[NDIRECT] = 0;
80101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f70:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101f77:	00 00 00 
  }

  ip->size = 0;
80101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7d:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	89 04 24             	mov    %eax,(%esp)
80101f8a:	e8 ec f9 ff ff       	call   8010197b <iupdate>
}
80101f8f:	c9                   	leave  
80101f90:	c3                   	ret    

80101f91 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f91:	55                   	push   %ebp
80101f92:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f94:	8b 45 08             	mov    0x8(%ebp),%eax
80101f97:	8b 00                	mov    (%eax),%eax
80101f99:	89 c2                	mov    %eax,%edx
80101f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f9e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	8b 50 04             	mov    0x4(%eax),%edx
80101fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101faa:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fad:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb0:	8b 40 50             	mov    0x50(%eax),%eax
80101fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fb6:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	66 8b 40 56          	mov    0x56(%eax),%ax
80101fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc3:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fca:	8b 50 58             	mov    0x58(%eax),%edx
80101fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd0:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fd5:	55                   	push   %ebp
80101fd6:	89 e5                	mov    %esp,%ebp
80101fd8:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fde:	8b 40 50             	mov    0x50(%eax),%eax
80101fe1:	66 83 f8 03          	cmp    $0x3,%ax
80101fe5:	75 60                	jne    80102047 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fea:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fee:	66 85 c0             	test   %ax,%ax
80101ff1:	78 20                	js     80102013 <readi+0x3e>
80101ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff6:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ffa:	66 83 f8 09          	cmp    $0x9,%ax
80101ffe:	7f 13                	jg     80102013 <readi+0x3e>
80102000:	8b 45 08             	mov    0x8(%ebp),%eax
80102003:	66 8b 40 52          	mov    0x52(%eax),%ax
80102007:	98                   	cwtl   
80102008:	8b 04 c5 a0 2e 11 80 	mov    -0x7feed160(,%eax,8),%eax
8010200f:	85 c0                	test   %eax,%eax
80102011:	75 0a                	jne    8010201d <readi+0x48>
      return -1;
80102013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102018:	e9 1a 01 00 00       	jmp    80102137 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
8010201d:	8b 45 08             	mov    0x8(%ebp),%eax
80102020:	66 8b 40 52          	mov    0x52(%eax),%ax
80102024:	98                   	cwtl   
80102025:	8b 04 c5 a0 2e 11 80 	mov    -0x7feed160(,%eax,8),%eax
8010202c:	8b 55 14             	mov    0x14(%ebp),%edx
8010202f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102033:	8b 55 0c             	mov    0xc(%ebp),%edx
80102036:	89 54 24 04          	mov    %edx,0x4(%esp)
8010203a:	8b 55 08             	mov    0x8(%ebp),%edx
8010203d:	89 14 24             	mov    %edx,(%esp)
80102040:	ff d0                	call   *%eax
80102042:	e9 f0 00 00 00       	jmp    80102137 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80102047:	8b 45 08             	mov    0x8(%ebp),%eax
8010204a:	8b 40 58             	mov    0x58(%eax),%eax
8010204d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102050:	72 0d                	jb     8010205f <readi+0x8a>
80102052:	8b 45 14             	mov    0x14(%ebp),%eax
80102055:	8b 55 10             	mov    0x10(%ebp),%edx
80102058:	01 d0                	add    %edx,%eax
8010205a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010205d:	73 0a                	jae    80102069 <readi+0x94>
    return -1;
8010205f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102064:	e9 ce 00 00 00       	jmp    80102137 <readi+0x162>
  if(off + n > ip->size)
80102069:	8b 45 14             	mov    0x14(%ebp),%eax
8010206c:	8b 55 10             	mov    0x10(%ebp),%edx
8010206f:	01 c2                	add    %eax,%edx
80102071:	8b 45 08             	mov    0x8(%ebp),%eax
80102074:	8b 40 58             	mov    0x58(%eax),%eax
80102077:	39 c2                	cmp    %eax,%edx
80102079:	76 0c                	jbe    80102087 <readi+0xb2>
    n = ip->size - off;
8010207b:	8b 45 08             	mov    0x8(%ebp),%eax
8010207e:	8b 40 58             	mov    0x58(%eax),%eax
80102081:	2b 45 10             	sub    0x10(%ebp),%eax
80102084:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102087:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010208e:	e9 95 00 00 00       	jmp    80102128 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102093:	8b 45 10             	mov    0x10(%ebp),%eax
80102096:	c1 e8 09             	shr    $0x9,%eax
80102099:	89 44 24 04          	mov    %eax,0x4(%esp)
8010209d:	8b 45 08             	mov    0x8(%ebp),%eax
801020a0:	89 04 24             	mov    %eax,(%esp)
801020a3:	e8 b3 fc ff ff       	call   80101d5b <bmap>
801020a8:	8b 55 08             	mov    0x8(%ebp),%edx
801020ab:	8b 12                	mov    (%edx),%edx
801020ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b1:	89 14 24             	mov    %edx,(%esp)
801020b4:	e8 fc e0 ff ff       	call   801001b5 <bread>
801020b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020bc:	8b 45 10             	mov    0x10(%ebp),%eax
801020bf:	25 ff 01 00 00       	and    $0x1ff,%eax
801020c4:	89 c2                	mov    %eax,%edx
801020c6:	b8 00 02 00 00       	mov    $0x200,%eax
801020cb:	29 d0                	sub    %edx,%eax
801020cd:	89 c1                	mov    %eax,%ecx
801020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d2:	8b 55 14             	mov    0x14(%ebp),%edx
801020d5:	29 c2                	sub    %eax,%edx
801020d7:	89 c8                	mov    %ecx,%eax
801020d9:	39 d0                	cmp    %edx,%eax
801020db:	76 02                	jbe    801020df <readi+0x10a>
801020dd:	89 d0                	mov    %edx,%eax
801020df:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801020e2:	8b 45 10             	mov    0x10(%ebp),%eax
801020e5:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ea:	8d 50 50             	lea    0x50(%eax),%edx
801020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020f0:	01 d0                	add    %edx,%eax
801020f2:	8d 50 0c             	lea    0xc(%eax),%edx
801020f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801020fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80102100:	8b 45 0c             	mov    0xc(%ebp),%eax
80102103:	89 04 24             	mov    %eax,(%esp)
80102106:	e8 60 31 00 00       	call   8010526b <memmove>
    brelse(bp);
8010210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010210e:	89 04 24             	mov    %eax,(%esp)
80102111:	e8 16 e1 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102116:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102119:	01 45 f4             	add    %eax,-0xc(%ebp)
8010211c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010211f:	01 45 10             	add    %eax,0x10(%ebp)
80102122:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102125:	01 45 0c             	add    %eax,0xc(%ebp)
80102128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010212b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010212e:	0f 82 5f ff ff ff    	jb     80102093 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102134:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102137:	c9                   	leave  
80102138:	c3                   	ret    

80102139 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102139:	55                   	push   %ebp
8010213a:	89 e5                	mov    %esp,%ebp
8010213c:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010213f:	8b 45 08             	mov    0x8(%ebp),%eax
80102142:	8b 40 50             	mov    0x50(%eax),%eax
80102145:	66 83 f8 03          	cmp    $0x3,%ax
80102149:	75 60                	jne    801021ab <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
8010214e:	66 8b 40 52          	mov    0x52(%eax),%ax
80102152:	66 85 c0             	test   %ax,%ax
80102155:	78 20                	js     80102177 <writei+0x3e>
80102157:	8b 45 08             	mov    0x8(%ebp),%eax
8010215a:	66 8b 40 52          	mov    0x52(%eax),%ax
8010215e:	66 83 f8 09          	cmp    $0x9,%ax
80102162:	7f 13                	jg     80102177 <writei+0x3e>
80102164:	8b 45 08             	mov    0x8(%ebp),%eax
80102167:	66 8b 40 52          	mov    0x52(%eax),%ax
8010216b:	98                   	cwtl   
8010216c:	8b 04 c5 a4 2e 11 80 	mov    -0x7feed15c(,%eax,8),%eax
80102173:	85 c0                	test   %eax,%eax
80102175:	75 0a                	jne    80102181 <writei+0x48>
      return -1;
80102177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010217c:	e9 45 01 00 00       	jmp    801022c6 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102181:	8b 45 08             	mov    0x8(%ebp),%eax
80102184:	66 8b 40 52          	mov    0x52(%eax),%ax
80102188:	98                   	cwtl   
80102189:	8b 04 c5 a4 2e 11 80 	mov    -0x7feed15c(,%eax,8),%eax
80102190:	8b 55 14             	mov    0x14(%ebp),%edx
80102193:	89 54 24 08          	mov    %edx,0x8(%esp)
80102197:	8b 55 0c             	mov    0xc(%ebp),%edx
8010219a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010219e:	8b 55 08             	mov    0x8(%ebp),%edx
801021a1:	89 14 24             	mov    %edx,(%esp)
801021a4:	ff d0                	call   *%eax
801021a6:	e9 1b 01 00 00       	jmp    801022c6 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
801021ab:	8b 45 08             	mov    0x8(%ebp),%eax
801021ae:	8b 40 58             	mov    0x58(%eax),%eax
801021b1:	3b 45 10             	cmp    0x10(%ebp),%eax
801021b4:	72 0d                	jb     801021c3 <writei+0x8a>
801021b6:	8b 45 14             	mov    0x14(%ebp),%eax
801021b9:	8b 55 10             	mov    0x10(%ebp),%edx
801021bc:	01 d0                	add    %edx,%eax
801021be:	3b 45 10             	cmp    0x10(%ebp),%eax
801021c1:	73 0a                	jae    801021cd <writei+0x94>
    return -1;
801021c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c8:	e9 f9 00 00 00       	jmp    801022c6 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
801021cd:	8b 45 14             	mov    0x14(%ebp),%eax
801021d0:	8b 55 10             	mov    0x10(%ebp),%edx
801021d3:	01 d0                	add    %edx,%eax
801021d5:	3d 00 18 01 00       	cmp    $0x11800,%eax
801021da:	76 0a                	jbe    801021e6 <writei+0xad>
    return -1;
801021dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e1:	e9 e0 00 00 00       	jmp    801022c6 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ed:	e9 a0 00 00 00       	jmp    80102292 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021f2:	8b 45 10             	mov    0x10(%ebp),%eax
801021f5:	c1 e8 09             	shr    $0x9,%eax
801021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fc:	8b 45 08             	mov    0x8(%ebp),%eax
801021ff:	89 04 24             	mov    %eax,(%esp)
80102202:	e8 54 fb ff ff       	call   80101d5b <bmap>
80102207:	8b 55 08             	mov    0x8(%ebp),%edx
8010220a:	8b 12                	mov    (%edx),%edx
8010220c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102210:	89 14 24             	mov    %edx,(%esp)
80102213:	e8 9d df ff ff       	call   801001b5 <bread>
80102218:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010221b:	8b 45 10             	mov    0x10(%ebp),%eax
8010221e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102223:	89 c2                	mov    %eax,%edx
80102225:	b8 00 02 00 00       	mov    $0x200,%eax
8010222a:	29 d0                	sub    %edx,%eax
8010222c:	89 c1                	mov    %eax,%ecx
8010222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102231:	8b 55 14             	mov    0x14(%ebp),%edx
80102234:	29 c2                	sub    %eax,%edx
80102236:	89 c8                	mov    %ecx,%eax
80102238:	39 d0                	cmp    %edx,%eax
8010223a:	76 02                	jbe    8010223e <writei+0x105>
8010223c:	89 d0                	mov    %edx,%eax
8010223e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102241:	8b 45 10             	mov    0x10(%ebp),%eax
80102244:	25 ff 01 00 00       	and    $0x1ff,%eax
80102249:	8d 50 50             	lea    0x50(%eax),%edx
8010224c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010224f:	01 d0                	add    %edx,%eax
80102251:	8d 50 0c             	lea    0xc(%eax),%edx
80102254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102257:	89 44 24 08          	mov    %eax,0x8(%esp)
8010225b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010225e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102262:	89 14 24             	mov    %edx,(%esp)
80102265:	e8 01 30 00 00       	call   8010526b <memmove>
    log_write(bp);
8010226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010226d:	89 04 24             	mov    %eax,(%esp)
80102270:	e8 c6 15 00 00       	call   8010383b <log_write>
    brelse(bp);
80102275:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102278:	89 04 24             	mov    %eax,(%esp)
8010227b:	e8 ac df ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102280:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102283:	01 45 f4             	add    %eax,-0xc(%ebp)
80102286:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102289:	01 45 10             	add    %eax,0x10(%ebp)
8010228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010228f:	01 45 0c             	add    %eax,0xc(%ebp)
80102292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102295:	3b 45 14             	cmp    0x14(%ebp),%eax
80102298:	0f 82 54 ff ff ff    	jb     801021f2 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010229e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022a2:	74 1f                	je     801022c3 <writei+0x18a>
801022a4:	8b 45 08             	mov    0x8(%ebp),%eax
801022a7:	8b 40 58             	mov    0x58(%eax),%eax
801022aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801022ad:	73 14                	jae    801022c3 <writei+0x18a>
    ip->size = off;
801022af:	8b 45 08             	mov    0x8(%ebp),%eax
801022b2:	8b 55 10             	mov    0x10(%ebp),%edx
801022b5:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801022b8:	8b 45 08             	mov    0x8(%ebp),%eax
801022bb:	89 04 24             	mov    %eax,(%esp)
801022be:	e8 b8 f6 ff ff       	call   8010197b <iupdate>
  }
  return n;
801022c3:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022c6:	c9                   	leave  
801022c7:	c3                   	ret    

801022c8 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022c8:	55                   	push   %ebp
801022c9:	89 e5                	mov    %esp,%ebp
801022cb:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801022ce:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022d5:	00 
801022d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801022dd:	8b 45 08             	mov    0x8(%ebp),%eax
801022e0:	89 04 24             	mov    %eax,(%esp)
801022e3:	e8 22 30 00 00       	call   8010530a <strncmp>
}
801022e8:	c9                   	leave  
801022e9:	c3                   	ret    

801022ea <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801022ea:	55                   	push   %ebp
801022eb:	89 e5                	mov    %esp,%ebp
801022ed:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801022f0:	8b 45 08             	mov    0x8(%ebp),%eax
801022f3:	8b 40 50             	mov    0x50(%eax),%eax
801022f6:	66 83 f8 01          	cmp    $0x1,%ax
801022fa:	74 0c                	je     80102308 <dirlookup+0x1e>
    panic("dirlookup not DIR");
801022fc:	c7 04 24 61 92 10 80 	movl   $0x80109261,(%esp)
80102303:	e8 7a e2 ff ff       	call   80100582 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102308:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010230f:	e9 86 00 00 00       	jmp    8010239a <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102314:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010231b:	00 
8010231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102323:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102326:	89 44 24 04          	mov    %eax,0x4(%esp)
8010232a:	8b 45 08             	mov    0x8(%ebp),%eax
8010232d:	89 04 24             	mov    %eax,(%esp)
80102330:	e8 a0 fc ff ff       	call   80101fd5 <readi>
80102335:	83 f8 10             	cmp    $0x10,%eax
80102338:	74 0c                	je     80102346 <dirlookup+0x5c>
      panic("dirlookup read");
8010233a:	c7 04 24 73 92 10 80 	movl   $0x80109273,(%esp)
80102341:	e8 3c e2 ff ff       	call   80100582 <panic>
    if(de.inum == 0)
80102346:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102349:	66 85 c0             	test   %ax,%ax
8010234c:	75 02                	jne    80102350 <dirlookup+0x66>
      continue;
8010234e:	eb 46                	jmp    80102396 <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
80102350:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102353:	83 c0 02             	add    $0x2,%eax
80102356:	89 44 24 04          	mov    %eax,0x4(%esp)
8010235a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010235d:	89 04 24             	mov    %eax,(%esp)
80102360:	e8 63 ff ff ff       	call   801022c8 <namecmp>
80102365:	85 c0                	test   %eax,%eax
80102367:	75 2d                	jne    80102396 <dirlookup+0xac>
      // entry matches path element
      if(poff)
80102369:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010236d:	74 08                	je     80102377 <dirlookup+0x8d>
        *poff = off;
8010236f:	8b 45 10             	mov    0x10(%ebp),%eax
80102372:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102375:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102377:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010237a:	0f b7 c0             	movzwl %ax,%eax
8010237d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102380:	8b 45 08             	mov    0x8(%ebp),%eax
80102383:	8b 00                	mov    (%eax),%eax
80102385:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102388:	89 54 24 04          	mov    %edx,0x4(%esp)
8010238c:	89 04 24             	mov    %eax,(%esp)
8010238f:	e8 a3 f6 ff ff       	call   80101a37 <iget>
80102394:	eb 18                	jmp    801023ae <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102396:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010239a:	8b 45 08             	mov    0x8(%ebp),%eax
8010239d:	8b 40 58             	mov    0x58(%eax),%eax
801023a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801023a3:	0f 87 6b ff ff ff    	ja     80102314 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801023a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023ae:	c9                   	leave  
801023af:	c3                   	ret    

801023b0 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023bd:	00 
801023be:	8b 45 0c             	mov    0xc(%ebp),%eax
801023c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
801023c8:	89 04 24             	mov    %eax,(%esp)
801023cb:	e8 1a ff ff ff       	call   801022ea <dirlookup>
801023d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023d7:	74 15                	je     801023ee <dirlink+0x3e>
    iput(ip);
801023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023dc:	89 04 24             	mov    %eax,(%esp)
801023df:	e8 a8 f8 ff ff       	call   80101c8c <iput>
    return -1;
801023e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023e9:	e9 b6 00 00 00       	jmp    801024a4 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023f5:	eb 45                	jmp    8010243c <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102401:	00 
80102402:	89 44 24 08          	mov    %eax,0x8(%esp)
80102406:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010240d:	8b 45 08             	mov    0x8(%ebp),%eax
80102410:	89 04 24             	mov    %eax,(%esp)
80102413:	e8 bd fb ff ff       	call   80101fd5 <readi>
80102418:	83 f8 10             	cmp    $0x10,%eax
8010241b:	74 0c                	je     80102429 <dirlink+0x79>
      panic("dirlink read");
8010241d:	c7 04 24 82 92 10 80 	movl   $0x80109282,(%esp)
80102424:	e8 59 e1 ff ff       	call   80100582 <panic>
    if(de.inum == 0)
80102429:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010242c:	66 85 c0             	test   %ax,%ax
8010242f:	75 02                	jne    80102433 <dirlink+0x83>
      break;
80102431:	eb 16                	jmp    80102449 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102436:	83 c0 10             	add    $0x10,%eax
80102439:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010243c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
80102442:	8b 40 58             	mov    0x58(%eax),%eax
80102445:	39 c2                	cmp    %eax,%edx
80102447:	72 ae                	jb     801023f7 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102449:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102450:	00 
80102451:	8b 45 0c             	mov    0xc(%ebp),%eax
80102454:	89 44 24 04          	mov    %eax,0x4(%esp)
80102458:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010245b:	83 c0 02             	add    $0x2,%eax
8010245e:	89 04 24             	mov    %eax,(%esp)
80102461:	e8 f2 2e 00 00       	call   80105358 <strncpy>
  de.inum = inum;
80102466:	8b 45 10             	mov    0x10(%ebp),%eax
80102469:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102470:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102477:	00 
80102478:	89 44 24 08          	mov    %eax,0x8(%esp)
8010247c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010247f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102483:	8b 45 08             	mov    0x8(%ebp),%eax
80102486:	89 04 24             	mov    %eax,(%esp)
80102489:	e8 ab fc ff ff       	call   80102139 <writei>
8010248e:	83 f8 10             	cmp    $0x10,%eax
80102491:	74 0c                	je     8010249f <dirlink+0xef>
    panic("dirlink");
80102493:	c7 04 24 8f 92 10 80 	movl   $0x8010928f,(%esp)
8010249a:	e8 e3 e0 ff ff       	call   80100582 <panic>

  return 0;
8010249f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024a4:	c9                   	leave  
801024a5:	c3                   	ret    

801024a6 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024a6:	55                   	push   %ebp
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801024ac:	eb 03                	jmp    801024b1 <skipelem+0xb>
    path++;
801024ae:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801024b1:	8b 45 08             	mov    0x8(%ebp),%eax
801024b4:	8a 00                	mov    (%eax),%al
801024b6:	3c 2f                	cmp    $0x2f,%al
801024b8:	74 f4                	je     801024ae <skipelem+0x8>
    path++;
  if(*path == 0)
801024ba:	8b 45 08             	mov    0x8(%ebp),%eax
801024bd:	8a 00                	mov    (%eax),%al
801024bf:	84 c0                	test   %al,%al
801024c1:	75 0a                	jne    801024cd <skipelem+0x27>
    return 0;
801024c3:	b8 00 00 00 00       	mov    $0x0,%eax
801024c8:	e9 81 00 00 00       	jmp    8010254e <skipelem+0xa8>
  s = path;
801024cd:	8b 45 08             	mov    0x8(%ebp),%eax
801024d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024d3:	eb 03                	jmp    801024d8 <skipelem+0x32>
    path++;
801024d5:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024d8:	8b 45 08             	mov    0x8(%ebp),%eax
801024db:	8a 00                	mov    (%eax),%al
801024dd:	3c 2f                	cmp    $0x2f,%al
801024df:	74 09                	je     801024ea <skipelem+0x44>
801024e1:	8b 45 08             	mov    0x8(%ebp),%eax
801024e4:	8a 00                	mov    (%eax),%al
801024e6:	84 c0                	test   %al,%al
801024e8:	75 eb                	jne    801024d5 <skipelem+0x2f>
    path++;
  len = path - s;
801024ea:	8b 55 08             	mov    0x8(%ebp),%edx
801024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f0:	29 c2                	sub    %eax,%edx
801024f2:	89 d0                	mov    %edx,%eax
801024f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801024f7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801024fb:	7e 1c                	jle    80102519 <skipelem+0x73>
    memmove(name, s, DIRSIZ);
801024fd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102504:	00 
80102505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010250c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010250f:	89 04 24             	mov    %eax,(%esp)
80102512:	e8 54 2d 00 00       	call   8010526b <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102517:	eb 29                	jmp    80102542 <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102519:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010251c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102523:	89 44 24 04          	mov    %eax,0x4(%esp)
80102527:	8b 45 0c             	mov    0xc(%ebp),%eax
8010252a:	89 04 24             	mov    %eax,(%esp)
8010252d:	e8 39 2d 00 00       	call   8010526b <memmove>
    name[len] = 0;
80102532:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102535:	8b 45 0c             	mov    0xc(%ebp),%eax
80102538:	01 d0                	add    %edx,%eax
8010253a:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010253d:	eb 03                	jmp    80102542 <skipelem+0x9c>
    path++;
8010253f:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102542:	8b 45 08             	mov    0x8(%ebp),%eax
80102545:	8a 00                	mov    (%eax),%al
80102547:	3c 2f                	cmp    $0x2f,%al
80102549:	74 f4                	je     8010253f <skipelem+0x99>
    path++;
  return path;
8010254b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010254e:	c9                   	leave  
8010254f:	c3                   	ret    

80102550 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102556:	8b 45 08             	mov    0x8(%ebp),%eax
80102559:	8a 00                	mov    (%eax),%al
8010255b:	3c 2f                	cmp    $0x2f,%al
8010255d:	75 1c                	jne    8010257b <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
8010255f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102566:	00 
80102567:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010256e:	e8 c4 f4 ff ff       	call   80101a37 <iget>
80102573:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102576:	e9 ac 00 00 00       	jmp    80102627 <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010257b:	e8 af 1d 00 00       	call   8010432f <myproc>
80102580:	8b 40 68             	mov    0x68(%eax),%eax
80102583:	89 04 24             	mov    %eax,(%esp)
80102586:	e8 81 f5 ff ff       	call   80101b0c <idup>
8010258b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010258e:	e9 94 00 00 00       	jmp    80102627 <namex+0xd7>
    ilock(ip);
80102593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102596:	89 04 24             	mov    %eax,(%esp)
80102599:	e8 a0 f5 ff ff       	call   80101b3e <ilock>
    if(ip->type != T_DIR){
8010259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025a1:	8b 40 50             	mov    0x50(%eax),%eax
801025a4:	66 83 f8 01          	cmp    $0x1,%ax
801025a8:	74 15                	je     801025bf <namex+0x6f>
      iunlockput(ip);
801025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ad:	89 04 24             	mov    %eax,(%esp)
801025b0:	e8 88 f7 ff ff       	call   80101d3d <iunlockput>
      return 0;
801025b5:	b8 00 00 00 00       	mov    $0x0,%eax
801025ba:	e9 a2 00 00 00       	jmp    80102661 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
801025bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025c3:	74 1c                	je     801025e1 <namex+0x91>
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
801025c8:	8a 00                	mov    (%eax),%al
801025ca:	84 c0                	test   %al,%al
801025cc:	75 13                	jne    801025e1 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
801025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025d1:	89 04 24             	mov    %eax,(%esp)
801025d4:	e8 6f f6 ff ff       	call   80101c48 <iunlock>
      return ip;
801025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025dc:	e9 80 00 00 00       	jmp    80102661 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801025e8:	00 
801025e9:	8b 45 10             	mov    0x10(%ebp),%eax
801025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025f3:	89 04 24             	mov    %eax,(%esp)
801025f6:	e8 ef fc ff ff       	call   801022ea <dirlookup>
801025fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801025fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102602:	75 12                	jne    80102616 <namex+0xc6>
      iunlockput(ip);
80102604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102607:	89 04 24             	mov    %eax,(%esp)
8010260a:	e8 2e f7 ff ff       	call   80101d3d <iunlockput>
      return 0;
8010260f:	b8 00 00 00 00       	mov    $0x0,%eax
80102614:	eb 4b                	jmp    80102661 <namex+0x111>
    }
    iunlockput(ip);
80102616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102619:	89 04 24             	mov    %eax,(%esp)
8010261c:	e8 1c f7 ff ff       	call   80101d3d <iunlockput>
    ip = next;
80102621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102627:	8b 45 10             	mov    0x10(%ebp),%eax
8010262a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010262e:	8b 45 08             	mov    0x8(%ebp),%eax
80102631:	89 04 24             	mov    %eax,(%esp)
80102634:	e8 6d fe ff ff       	call   801024a6 <skipelem>
80102639:	89 45 08             	mov    %eax,0x8(%ebp)
8010263c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102640:	0f 85 4d ff ff ff    	jne    80102593 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102646:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010264a:	74 12                	je     8010265e <namex+0x10e>
    iput(ip);
8010264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010264f:	89 04 24             	mov    %eax,(%esp)
80102652:	e8 35 f6 ff ff       	call   80101c8c <iput>
    return 0;
80102657:	b8 00 00 00 00       	mov    $0x0,%eax
8010265c:	eb 03                	jmp    80102661 <namex+0x111>
  }
  return ip;
8010265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102661:	c9                   	leave  
80102662:	c3                   	ret    

80102663 <namei>:

struct inode*
namei(char *path)
{
80102663:	55                   	push   %ebp
80102664:	89 e5                	mov    %esp,%ebp
80102666:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102669:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010266c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102670:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102677:	00 
80102678:	8b 45 08             	mov    0x8(%ebp),%eax
8010267b:	89 04 24             	mov    %eax,(%esp)
8010267e:	e8 cd fe ff ff       	call   80102550 <namex>
}
80102683:	c9                   	leave  
80102684:	c3                   	ret    

80102685 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
80102688:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010268b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010268e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102692:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102699:	00 
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	89 04 24             	mov    %eax,(%esp)
801026a0:	e8 ab fe ff ff       	call   80102550 <namex>
}
801026a5:	c9                   	leave  
801026a6:	c3                   	ret    
	...

801026a8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 14             	sub    $0x14,%esp
801026ae:	8b 45 08             	mov    0x8(%ebp),%eax
801026b1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801026b8:	89 c2                	mov    %eax,%edx
801026ba:	ec                   	in     (%dx),%al
801026bb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026be:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801026c1:	c9                   	leave  
801026c2:	c3                   	ret    

801026c3 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801026c3:	55                   	push   %ebp
801026c4:	89 e5                	mov    %esp,%ebp
801026c6:	57                   	push   %edi
801026c7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026c8:	8b 55 08             	mov    0x8(%ebp),%edx
801026cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026ce:	8b 45 10             	mov    0x10(%ebp),%eax
801026d1:	89 cb                	mov    %ecx,%ebx
801026d3:	89 df                	mov    %ebx,%edi
801026d5:	89 c1                	mov    %eax,%ecx
801026d7:	fc                   	cld    
801026d8:	f3 6d                	rep insl (%dx),%es:(%edi)
801026da:	89 c8                	mov    %ecx,%eax
801026dc:	89 fb                	mov    %edi,%ebx
801026de:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026e1:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801026e4:	5b                   	pop    %ebx
801026e5:	5f                   	pop    %edi
801026e6:	5d                   	pop    %ebp
801026e7:	c3                   	ret    

801026e8 <outb>:

static inline void
outb(ushort port, uchar data)
{
801026e8:	55                   	push   %ebp
801026e9:	89 e5                	mov    %esp,%ebp
801026eb:	83 ec 08             	sub    $0x8,%esp
801026ee:	8b 45 08             	mov    0x8(%ebp),%eax
801026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801026f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801026f8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026fb:	8a 45 f8             	mov    -0x8(%ebp),%al
801026fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102701:	ee                   	out    %al,(%dx)
}
80102702:	c9                   	leave  
80102703:	c3                   	ret    

80102704 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	56                   	push   %esi
80102708:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102709:	8b 55 08             	mov    0x8(%ebp),%edx
8010270c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010270f:	8b 45 10             	mov    0x10(%ebp),%eax
80102712:	89 cb                	mov    %ecx,%ebx
80102714:	89 de                	mov    %ebx,%esi
80102716:	89 c1                	mov    %eax,%ecx
80102718:	fc                   	cld    
80102719:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010271b:	89 c8                	mov    %ecx,%eax
8010271d:	89 f3                	mov    %esi,%ebx
8010271f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102722:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102725:	5b                   	pop    %ebx
80102726:	5e                   	pop    %esi
80102727:	5d                   	pop    %ebp
80102728:	c3                   	ret    

80102729 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102729:	55                   	push   %ebp
8010272a:	89 e5                	mov    %esp,%ebp
8010272c:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010272f:	90                   	nop
80102730:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102737:	e8 6c ff ff ff       	call   801026a8 <inb>
8010273c:	0f b6 c0             	movzbl %al,%eax
8010273f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102742:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102745:	25 c0 00 00 00       	and    $0xc0,%eax
8010274a:	83 f8 40             	cmp    $0x40,%eax
8010274d:	75 e1                	jne    80102730 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010274f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102753:	74 11                	je     80102766 <idewait+0x3d>
80102755:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102758:	83 e0 21             	and    $0x21,%eax
8010275b:	85 c0                	test   %eax,%eax
8010275d:	74 07                	je     80102766 <idewait+0x3d>
    return -1;
8010275f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102764:	eb 05                	jmp    8010276b <idewait+0x42>
  return 0;
80102766:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010276b:	c9                   	leave  
8010276c:	c3                   	ret    

8010276d <ideinit>:

void
ideinit(void)
{
8010276d:	55                   	push   %ebp
8010276e:	89 e5                	mov    %esp,%ebp
80102770:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102773:	c7 44 24 04 97 92 10 	movl   $0x80109297,0x4(%esp)
8010277a:	80 
8010277b:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102782:	e8 97 27 00 00       	call   80104f1e <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102787:	a1 40 52 11 80       	mov    0x80115240,%eax
8010278c:	48                   	dec    %eax
8010278d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102791:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102798:	e8 66 04 00 00       	call   80102c03 <ioapicenable>
  idewait(0);
8010279d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801027a4:	e8 80 ff ff ff       	call   80102729 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027a9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801027b0:	00 
801027b1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027b8:	e8 2b ff ff ff       	call   801026e8 <outb>
  for(i=0; i<1000; i++){
801027bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027c4:	eb 1f                	jmp    801027e5 <ideinit+0x78>
    if(inb(0x1f7) != 0){
801027c6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027cd:	e8 d6 fe ff ff       	call   801026a8 <inb>
801027d2:	84 c0                	test   %al,%al
801027d4:	74 0c                	je     801027e2 <ideinit+0x75>
      havedisk1 = 1;
801027d6:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
801027dd:	00 00 00 
      break;
801027e0:	eb 0c                	jmp    801027ee <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801027e2:	ff 45 f4             	incl   -0xc(%ebp)
801027e5:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801027ec:	7e d8                	jle    801027c6 <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801027ee:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801027f5:	00 
801027f6:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027fd:	e8 e6 fe ff ff       	call   801026e8 <outb>
}
80102802:	c9                   	leave  
80102803:	c3                   	ret    

80102804 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102804:	55                   	push   %ebp
80102805:	89 e5                	mov    %esp,%ebp
80102807:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
8010280a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010280e:	75 0c                	jne    8010281c <idestart+0x18>
    panic("idestart");
80102810:	c7 04 24 9b 92 10 80 	movl   $0x8010929b,(%esp)
80102817:	e8 66 dd ff ff       	call   80100582 <panic>
  if(b->blockno >= FSSIZE)
8010281c:	8b 45 08             	mov    0x8(%ebp),%eax
8010281f:	8b 40 08             	mov    0x8(%eax),%eax
80102822:	3d 1f 4e 00 00       	cmp    $0x4e1f,%eax
80102827:	76 0c                	jbe    80102835 <idestart+0x31>
    panic("incorrect blockno");
80102829:	c7 04 24 a4 92 10 80 	movl   $0x801092a4,(%esp)
80102830:	e8 4d dd ff ff       	call   80100582 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102835:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010283c:	8b 45 08             	mov    0x8(%ebp),%eax
8010283f:	8b 50 08             	mov    0x8(%eax),%edx
80102842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102845:	0f af c2             	imul   %edx,%eax
80102848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010284b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010284f:	75 07                	jne    80102858 <idestart+0x54>
80102851:	b8 20 00 00 00       	mov    $0x20,%eax
80102856:	eb 05                	jmp    8010285d <idestart+0x59>
80102858:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010285d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102860:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102864:	75 07                	jne    8010286d <idestart+0x69>
80102866:	b8 30 00 00 00       	mov    $0x30,%eax
8010286b:	eb 05                	jmp    80102872 <idestart+0x6e>
8010286d:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102872:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102875:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102879:	7e 0c                	jle    80102887 <idestart+0x83>
8010287b:	c7 04 24 9b 92 10 80 	movl   $0x8010929b,(%esp)
80102882:	e8 fb dc ff ff       	call   80100582 <panic>

  idewait(0);
80102887:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010288e:	e8 96 fe ff ff       	call   80102729 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010289a:	00 
8010289b:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801028a2:	e8 41 fe ff ff       	call   801026e8 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028aa:	0f b6 c0             	movzbl %al,%eax
801028ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801028b1:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801028b8:	e8 2b fe ff ff       	call   801026e8 <outb>
  outb(0x1f3, sector & 0xff);
801028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028c0:	0f b6 c0             	movzbl %al,%eax
801028c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801028c7:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801028ce:	e8 15 fe ff ff       	call   801026e8 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028d6:	c1 f8 08             	sar    $0x8,%eax
801028d9:	0f b6 c0             	movzbl %al,%eax
801028dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801028e0:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801028e7:	e8 fc fd ff ff       	call   801026e8 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028ef:	c1 f8 10             	sar    $0x10,%eax
801028f2:	0f b6 c0             	movzbl %al,%eax
801028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801028f9:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102900:	e8 e3 fd ff ff       	call   801026e8 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102905:	8b 45 08             	mov    0x8(%ebp),%eax
80102908:	8b 40 04             	mov    0x4(%eax),%eax
8010290b:	83 e0 01             	and    $0x1,%eax
8010290e:	c1 e0 04             	shl    $0x4,%eax
80102911:	88 c2                	mov    %al,%dl
80102913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102916:	c1 f8 18             	sar    $0x18,%eax
80102919:	83 e0 0f             	and    $0xf,%eax
8010291c:	09 d0                	or     %edx,%eax
8010291e:	83 c8 e0             	or     $0xffffffe0,%eax
80102921:	0f b6 c0             	movzbl %al,%eax
80102924:	89 44 24 04          	mov    %eax,0x4(%esp)
80102928:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010292f:	e8 b4 fd ff ff       	call   801026e8 <outb>
  if(b->flags & B_DIRTY){
80102934:	8b 45 08             	mov    0x8(%ebp),%eax
80102937:	8b 00                	mov    (%eax),%eax
80102939:	83 e0 04             	and    $0x4,%eax
8010293c:	85 c0                	test   %eax,%eax
8010293e:	74 36                	je     80102976 <idestart+0x172>
    outb(0x1f7, write_cmd);
80102940:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102943:	0f b6 c0             	movzbl %al,%eax
80102946:	89 44 24 04          	mov    %eax,0x4(%esp)
8010294a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102951:	e8 92 fd ff ff       	call   801026e8 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102956:	8b 45 08             	mov    0x8(%ebp),%eax
80102959:	83 c0 5c             	add    $0x5c,%eax
8010295c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102963:	00 
80102964:	89 44 24 04          	mov    %eax,0x4(%esp)
80102968:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010296f:	e8 90 fd ff ff       	call   80102704 <outsl>
80102974:	eb 16                	jmp    8010298c <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102976:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102979:	0f b6 c0             	movzbl %al,%eax
8010297c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102980:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102987:	e8 5c fd ff ff       	call   801026e8 <outb>
  }
}
8010298c:	c9                   	leave  
8010298d:	c3                   	ret    

8010298e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010298e:	55                   	push   %ebp
8010298f:	89 e5                	mov    %esp,%ebp
80102991:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102994:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010299b:	e8 9f 25 00 00       	call   80104f3f <acquire>

  if((b = idequeue) == 0){
801029a0:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029ac:	75 11                	jne    801029bf <ideintr+0x31>
    release(&idelock);
801029ae:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801029b5:	e8 ef 25 00 00       	call   80104fa9 <release>
    return;
801029ba:	e9 90 00 00 00       	jmp    80102a4f <ideintr+0xc1>
  }
  idequeue = b->qnext;
801029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c2:	8b 40 58             	mov    0x58(%eax),%eax
801029c5:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029cd:	8b 00                	mov    (%eax),%eax
801029cf:	83 e0 04             	and    $0x4,%eax
801029d2:	85 c0                	test   %eax,%eax
801029d4:	75 2e                	jne    80102a04 <ideintr+0x76>
801029d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029dd:	e8 47 fd ff ff       	call   80102729 <idewait>
801029e2:	85 c0                	test   %eax,%eax
801029e4:	78 1e                	js     80102a04 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e9:	83 c0 5c             	add    $0x5c,%eax
801029ec:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801029f3:	00 
801029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f8:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801029ff:	e8 bf fc ff ff       	call   801026c3 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a07:	8b 00                	mov    (%eax),%eax
80102a09:	83 c8 02             	or     $0x2,%eax
80102a0c:	89 c2                	mov    %eax,%edx
80102a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a11:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a16:	8b 00                	mov    (%eax),%eax
80102a18:	83 e0 fb             	and    $0xfffffffb,%eax
80102a1b:	89 c2                	mov    %eax,%edx
80102a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a20:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a25:	89 04 24             	mov    %eax,(%esp)
80102a28:	e8 17 22 00 00       	call   80104c44 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a2d:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a32:	85 c0                	test   %eax,%eax
80102a34:	74 0d                	je     80102a43 <ideintr+0xb5>
    idestart(idequeue);
80102a36:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a3b:	89 04 24             	mov    %eax,(%esp)
80102a3e:	e8 c1 fd ff ff       	call   80102804 <idestart>

  release(&idelock);
80102a43:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102a4a:	e8 5a 25 00 00       	call   80104fa9 <release>
}
80102a4f:	c9                   	leave  
80102a50:	c3                   	ret    

80102a51 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a51:	55                   	push   %ebp
80102a52:	89 e5                	mov    %esp,%ebp
80102a54:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102a57:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5a:	83 c0 0c             	add    $0xc,%eax
80102a5d:	89 04 24             	mov    %eax,(%esp)
80102a60:	e8 52 24 00 00       	call   80104eb7 <holdingsleep>
80102a65:	85 c0                	test   %eax,%eax
80102a67:	75 0c                	jne    80102a75 <iderw+0x24>
    panic("iderw: buf not locked");
80102a69:	c7 04 24 b6 92 10 80 	movl   $0x801092b6,(%esp)
80102a70:	e8 0d db ff ff       	call   80100582 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102a75:	8b 45 08             	mov    0x8(%ebp),%eax
80102a78:	8b 00                	mov    (%eax),%eax
80102a7a:	83 e0 06             	and    $0x6,%eax
80102a7d:	83 f8 02             	cmp    $0x2,%eax
80102a80:	75 0c                	jne    80102a8e <iderw+0x3d>
    panic("iderw: nothing to do");
80102a82:	c7 04 24 cc 92 10 80 	movl   $0x801092cc,(%esp)
80102a89:	e8 f4 da ff ff       	call   80100582 <panic>
  if(b->dev != 0 && !havedisk1)
80102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a91:	8b 40 04             	mov    0x4(%eax),%eax
80102a94:	85 c0                	test   %eax,%eax
80102a96:	74 15                	je     80102aad <iderw+0x5c>
80102a98:	a1 78 c6 10 80       	mov    0x8010c678,%eax
80102a9d:	85 c0                	test   %eax,%eax
80102a9f:	75 0c                	jne    80102aad <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102aa1:	c7 04 24 e1 92 10 80 	movl   $0x801092e1,(%esp)
80102aa8:	e8 d5 da ff ff       	call   80100582 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102aad:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102ab4:	e8 86 24 00 00       	call   80104f3f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80102abc:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102ac3:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80102aca:	eb 0b                	jmp    80102ad7 <iderw+0x86>
80102acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acf:	8b 00                	mov    (%eax),%eax
80102ad1:	83 c0 58             	add    $0x58,%eax
80102ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ada:	8b 00                	mov    (%eax),%eax
80102adc:	85 c0                	test   %eax,%eax
80102ade:	75 ec                	jne    80102acc <iderw+0x7b>
    ;
  *pp = b;
80102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80102ae6:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102ae8:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102aed:	3b 45 08             	cmp    0x8(%ebp),%eax
80102af0:	75 0d                	jne    80102aff <iderw+0xae>
    idestart(b);
80102af2:	8b 45 08             	mov    0x8(%ebp),%eax
80102af5:	89 04 24             	mov    %eax,(%esp)
80102af8:	e8 07 fd ff ff       	call   80102804 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102afd:	eb 15                	jmp    80102b14 <iderw+0xc3>
80102aff:	eb 13                	jmp    80102b14 <iderw+0xc3>
    sleep(b, &idelock);
80102b01:	c7 44 24 04 40 c6 10 	movl   $0x8010c640,0x4(%esp)
80102b08:	80 
80102b09:	8b 45 08             	mov    0x8(%ebp),%eax
80102b0c:	89 04 24             	mov    %eax,(%esp)
80102b0f:	e8 5c 20 00 00       	call   80104b70 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b14:	8b 45 08             	mov    0x8(%ebp),%eax
80102b17:	8b 00                	mov    (%eax),%eax
80102b19:	83 e0 06             	and    $0x6,%eax
80102b1c:	83 f8 02             	cmp    $0x2,%eax
80102b1f:	75 e0                	jne    80102b01 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102b21:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102b28:	e8 7c 24 00 00       	call   80104fa9 <release>
}
80102b2d:	c9                   	leave  
80102b2e:	c3                   	ret    
	...

80102b30 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b33:	a1 74 4b 11 80       	mov    0x80114b74,%eax
80102b38:	8b 55 08             	mov    0x8(%ebp),%edx
80102b3b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102b3d:	a1 74 4b 11 80       	mov    0x80114b74,%eax
80102b42:	8b 40 10             	mov    0x10(%eax),%eax
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    

80102b47 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102b47:	55                   	push   %ebp
80102b48:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b4a:	a1 74 4b 11 80       	mov    0x80114b74,%eax
80102b4f:	8b 55 08             	mov    0x8(%ebp),%edx
80102b52:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b54:	a1 74 4b 11 80       	mov    0x80114b74,%eax
80102b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b5c:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b5f:	5d                   	pop    %ebp
80102b60:	c3                   	ret    

80102b61 <ioapicinit>:

void
ioapicinit(void)
{
80102b61:	55                   	push   %ebp
80102b62:	89 e5                	mov    %esp,%ebp
80102b64:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102b67:	c7 05 74 4b 11 80 00 	movl   $0xfec00000,0x80114b74
80102b6e:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102b78:	e8 b3 ff ff ff       	call   80102b30 <ioapicread>
80102b7d:	c1 e8 10             	shr    $0x10,%eax
80102b80:	25 ff 00 00 00       	and    $0xff,%eax
80102b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102b8f:	e8 9c ff ff ff       	call   80102b30 <ioapicread>
80102b94:	c1 e8 18             	shr    $0x18,%eax
80102b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b9a:	a0 a0 4c 11 80       	mov    0x80114ca0,%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
80102ba2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102ba5:	74 0c                	je     80102bb3 <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ba7:	c7 04 24 00 93 10 80 	movl   $0x80109300,(%esp)
80102bae:	e8 3c d8 ff ff       	call   801003ef <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102bba:	eb 3d                	jmp    80102bf9 <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bbf:	83 c0 20             	add    $0x20,%eax
80102bc2:	0d 00 00 01 00       	or     $0x10000,%eax
80102bc7:	89 c2                	mov    %eax,%edx
80102bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bcc:	83 c0 08             	add    $0x8,%eax
80102bcf:	01 c0                	add    %eax,%eax
80102bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
80102bd5:	89 04 24             	mov    %eax,(%esp)
80102bd8:	e8 6a ff ff ff       	call   80102b47 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be0:	83 c0 08             	add    $0x8,%eax
80102be3:	01 c0                	add    %eax,%eax
80102be5:	40                   	inc    %eax
80102be6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102bed:	00 
80102bee:	89 04 24             	mov    %eax,(%esp)
80102bf1:	e8 51 ff ff ff       	call   80102b47 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102bf6:	ff 45 f4             	incl   -0xc(%ebp)
80102bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102bff:	7e bb                	jle    80102bbc <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c01:	c9                   	leave  
80102c02:	c3                   	ret    

80102c03 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c03:	55                   	push   %ebp
80102c04:	89 e5                	mov    %esp,%ebp
80102c06:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c09:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0c:	83 c0 20             	add    $0x20,%eax
80102c0f:	89 c2                	mov    %eax,%edx
80102c11:	8b 45 08             	mov    0x8(%ebp),%eax
80102c14:	83 c0 08             	add    $0x8,%eax
80102c17:	01 c0                	add    %eax,%eax
80102c19:	89 54 24 04          	mov    %edx,0x4(%esp)
80102c1d:	89 04 24             	mov    %eax,(%esp)
80102c20:	e8 22 ff ff ff       	call   80102b47 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c28:	c1 e0 18             	shl    $0x18,%eax
80102c2b:	8b 55 08             	mov    0x8(%ebp),%edx
80102c2e:	83 c2 08             	add    $0x8,%edx
80102c31:	01 d2                	add    %edx,%edx
80102c33:	42                   	inc    %edx
80102c34:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c38:	89 14 24             	mov    %edx,(%esp)
80102c3b:	e8 07 ff ff ff       	call   80102b47 <ioapicwrite>
}
80102c40:	c9                   	leave  
80102c41:	c3                   	ret    
	...

80102c44 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c44:	55                   	push   %ebp
80102c45:	89 e5                	mov    %esp,%ebp
80102c47:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102c4a:	c7 44 24 04 32 93 10 	movl   $0x80109332,0x4(%esp)
80102c51:	80 
80102c52:	c7 04 24 80 4b 11 80 	movl   $0x80114b80,(%esp)
80102c59:	e8 c0 22 00 00       	call   80104f1e <initlock>
  kmem.use_lock = 0;
80102c5e:	c7 05 b4 4b 11 80 00 	movl   $0x0,0x80114bb4
80102c65:	00 00 00 
  freerange(vstart, vend);
80102c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c72:	89 04 24             	mov    %eax,(%esp)
80102c75:	e8 26 00 00 00       	call   80102ca0 <freerange>
}
80102c7a:	c9                   	leave  
80102c7b:	c3                   	ret    

80102c7c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c7c:	55                   	push   %ebp
80102c7d:	89 e5                	mov    %esp,%ebp
80102c7f:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102c82:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c89:	8b 45 08             	mov    0x8(%ebp),%eax
80102c8c:	89 04 24             	mov    %eax,(%esp)
80102c8f:	e8 0c 00 00 00       	call   80102ca0 <freerange>
  kmem.use_lock = 1;
80102c94:	c7 05 b4 4b 11 80 01 	movl   $0x1,0x80114bb4
80102c9b:	00 00 00 
}
80102c9e:	c9                   	leave  
80102c9f:	c3                   	ret    

80102ca0 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca9:	05 ff 0f 00 00       	add    $0xfff,%eax
80102cae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb6:	eb 12                	jmp    80102cca <freerange+0x2a>
    kfree(p);
80102cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbb:	89 04 24             	mov    %eax,(%esp)
80102cbe:	e8 16 00 00 00       	call   80102cd9 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cc3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccd:	05 00 10 00 00       	add    $0x1000,%eax
80102cd2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102cd5:	76 e1                	jbe    80102cb8 <freerange+0x18>
    kfree(p);
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
80102cdc:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce2:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ce7:	85 c0                	test   %eax,%eax
80102ce9:	75 18                	jne    80102d03 <kfree+0x2a>
80102ceb:	81 7d 08 e8 79 11 80 	cmpl   $0x801179e8,0x8(%ebp)
80102cf2:	72 0f                	jb     80102d03 <kfree+0x2a>
80102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf7:	05 00 00 00 80       	add    $0x80000000,%eax
80102cfc:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d01:	76 0c                	jbe    80102d0f <kfree+0x36>
    panic("kfree");
80102d03:	c7 04 24 37 93 10 80 	movl   $0x80109337,(%esp)
80102d0a:	e8 73 d8 ff ff       	call   80100582 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d0f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102d16:	00 
80102d17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102d1e:	00 
80102d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d22:	89 04 24             	mov    %eax,(%esp)
80102d25:	e8 78 24 00 00       	call   801051a2 <memset>

  if(kmem.use_lock)
80102d2a:	a1 b4 4b 11 80       	mov    0x80114bb4,%eax
80102d2f:	85 c0                	test   %eax,%eax
80102d31:	74 0c                	je     80102d3f <kfree+0x66>
    acquire(&kmem.lock);
80102d33:	c7 04 24 80 4b 11 80 	movl   $0x80114b80,(%esp)
80102d3a:	e8 00 22 00 00       	call   80104f3f <acquire>
  r = (struct run*)v;
80102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d45:	8b 15 b8 4b 11 80    	mov    0x80114bb8,%edx
80102d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d4e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d53:	a3 b8 4b 11 80       	mov    %eax,0x80114bb8
  if(kmem.use_lock)
80102d58:	a1 b4 4b 11 80       	mov    0x80114bb4,%eax
80102d5d:	85 c0                	test   %eax,%eax
80102d5f:	74 0c                	je     80102d6d <kfree+0x94>
    release(&kmem.lock);
80102d61:	c7 04 24 80 4b 11 80 	movl   $0x80114b80,(%esp)
80102d68:	e8 3c 22 00 00       	call   80104fa9 <release>
}
80102d6d:	c9                   	leave  
80102d6e:	c3                   	ret    

80102d6f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d6f:	55                   	push   %ebp
80102d70:	89 e5                	mov    %esp,%ebp
80102d72:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102d75:	a1 b4 4b 11 80       	mov    0x80114bb4,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	74 0c                	je     80102d8a <kalloc+0x1b>
    acquire(&kmem.lock);
80102d7e:	c7 04 24 80 4b 11 80 	movl   $0x80114b80,(%esp)
80102d85:	e8 b5 21 00 00       	call   80104f3f <acquire>
  r = kmem.freelist;
80102d8a:	a1 b8 4b 11 80       	mov    0x80114bb8,%eax
80102d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d96:	74 0a                	je     80102da2 <kalloc+0x33>
    kmem.freelist = r->next;
80102d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d9b:	8b 00                	mov    (%eax),%eax
80102d9d:	a3 b8 4b 11 80       	mov    %eax,0x80114bb8
  if(kmem.use_lock)
80102da2:	a1 b4 4b 11 80       	mov    0x80114bb4,%eax
80102da7:	85 c0                	test   %eax,%eax
80102da9:	74 0c                	je     80102db7 <kalloc+0x48>
    release(&kmem.lock);
80102dab:	c7 04 24 80 4b 11 80 	movl   $0x80114b80,(%esp)
80102db2:	e8 f2 21 00 00       	call   80104fa9 <release>
  return (char*)r;
80102db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102dba:	c9                   	leave  
80102dbb:	c3                   	ret    

80102dbc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102dbc:	55                   	push   %ebp
80102dbd:	89 e5                	mov    %esp,%ebp
80102dbf:	83 ec 14             	sub    $0x14,%esp
80102dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80102dc5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dcc:	89 c2                	mov    %eax,%edx
80102dce:	ec                   	in     (%dx),%al
80102dcf:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102dd2:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102dd5:	c9                   	leave  
80102dd6:	c3                   	ret    

80102dd7 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102dd7:	55                   	push   %ebp
80102dd8:	89 e5                	mov    %esp,%ebp
80102dda:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ddd:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102de4:	e8 d3 ff ff ff       	call   80102dbc <inb>
80102de9:	0f b6 c0             	movzbl %al,%eax
80102dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df2:	83 e0 01             	and    $0x1,%eax
80102df5:	85 c0                	test   %eax,%eax
80102df7:	75 0a                	jne    80102e03 <kbdgetc+0x2c>
    return -1;
80102df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dfe:	e9 21 01 00 00       	jmp    80102f24 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102e03:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102e0a:	e8 ad ff ff ff       	call   80102dbc <inb>
80102e0f:	0f b6 c0             	movzbl %al,%eax
80102e12:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102e15:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102e1c:	75 17                	jne    80102e35 <kbdgetc+0x5e>
    shift |= E0ESC;
80102e1e:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e23:	83 c8 40             	or     $0x40,%eax
80102e26:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102e2b:	b8 00 00 00 00       	mov    $0x0,%eax
80102e30:	e9 ef 00 00 00       	jmp    80102f24 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e38:	25 80 00 00 00       	and    $0x80,%eax
80102e3d:	85 c0                	test   %eax,%eax
80102e3f:	74 44                	je     80102e85 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e41:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e46:	83 e0 40             	and    $0x40,%eax
80102e49:	85 c0                	test   %eax,%eax
80102e4b:	75 08                	jne    80102e55 <kbdgetc+0x7e>
80102e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e50:	83 e0 7f             	and    $0x7f,%eax
80102e53:	eb 03                	jmp    80102e58 <kbdgetc+0x81>
80102e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e5e:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e63:	8a 00                	mov    (%eax),%al
80102e65:	83 c8 40             	or     $0x40,%eax
80102e68:	0f b6 c0             	movzbl %al,%eax
80102e6b:	f7 d0                	not    %eax
80102e6d:	89 c2                	mov    %eax,%edx
80102e6f:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e74:	21 d0                	and    %edx,%eax
80102e76:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102e7b:	b8 00 00 00 00       	mov    $0x0,%eax
80102e80:	e9 9f 00 00 00       	jmp    80102f24 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e85:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e8a:	83 e0 40             	and    $0x40,%eax
80102e8d:	85 c0                	test   %eax,%eax
80102e8f:	74 14                	je     80102ea5 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e91:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e98:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e9d:	83 e0 bf             	and    $0xffffffbf,%eax
80102ea0:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80102ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ea8:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ead:	8a 00                	mov    (%eax),%al
80102eaf:	0f b6 d0             	movzbl %al,%edx
80102eb2:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102eb7:	09 d0                	or     %edx,%eax
80102eb9:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
80102ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ec1:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102ec6:	8a 00                	mov    (%eax),%al
80102ec8:	0f b6 d0             	movzbl %al,%edx
80102ecb:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ed0:	31 d0                	xor    %edx,%eax
80102ed2:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ed7:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102edc:	83 e0 03             	and    $0x3,%eax
80102edf:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ee9:	01 d0                	add    %edx,%eax
80102eeb:	8a 00                	mov    (%eax),%al
80102eed:	0f b6 c0             	movzbl %al,%eax
80102ef0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ef3:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ef8:	83 e0 08             	and    $0x8,%eax
80102efb:	85 c0                	test   %eax,%eax
80102efd:	74 22                	je     80102f21 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102eff:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f03:	76 0c                	jbe    80102f11 <kbdgetc+0x13a>
80102f05:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f09:	77 06                	ja     80102f11 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102f0b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102f0f:	eb 10                	jmp    80102f21 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102f11:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102f15:	76 0a                	jbe    80102f21 <kbdgetc+0x14a>
80102f17:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f1b:	77 04                	ja     80102f21 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102f1d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f24:	c9                   	leave  
80102f25:	c3                   	ret    

80102f26 <kbdintr>:

void
kbdintr(void)
{
80102f26:	55                   	push   %ebp
80102f27:	89 e5                	mov    %esp,%ebp
80102f29:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102f2c:	c7 04 24 d7 2d 10 80 	movl   $0x80102dd7,(%esp)
80102f33:	e8 eb d8 ff ff       	call   80100823 <consoleintr>
}
80102f38:	c9                   	leave  
80102f39:	c3                   	ret    
	...

80102f3c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f3c:	55                   	push   %ebp
80102f3d:	89 e5                	mov    %esp,%ebp
80102f3f:	83 ec 14             	sub    $0x14,%esp
80102f42:	8b 45 08             	mov    0x8(%ebp),%eax
80102f45:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f4c:	89 c2                	mov    %eax,%edx
80102f4e:	ec                   	in     (%dx),%al
80102f4f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f52:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102f55:	c9                   	leave  
80102f56:	c3                   	ret    

80102f57 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f57:	55                   	push   %ebp
80102f58:	89 e5                	mov    %esp,%ebp
80102f5a:	83 ec 08             	sub    $0x8,%esp
80102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102f60:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f63:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102f67:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6a:	8a 45 f8             	mov    -0x8(%ebp),%al
80102f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102f70:	ee                   	out    %al,(%dx)
}
80102f71:	c9                   	leave  
80102f72:	c3                   	ret    

80102f73 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102f73:	55                   	push   %ebp
80102f74:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f76:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
80102f7b:	8b 55 08             	mov    0x8(%ebp),%edx
80102f7e:	c1 e2 02             	shl    $0x2,%edx
80102f81:	01 c2                	add    %eax,%edx
80102f83:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f86:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f88:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
80102f8d:	83 c0 20             	add    $0x20,%eax
80102f90:	8b 00                	mov    (%eax),%eax
}
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    

80102f94 <lapicinit>:

void
lapicinit(void)
{
80102f94:	55                   	push   %ebp
80102f95:	89 e5                	mov    %esp,%ebp
80102f97:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102f9a:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 05                	jne    80102fa8 <lapicinit+0x14>
    return;
80102fa3:	e9 43 01 00 00       	jmp    801030eb <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102fa8:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102faf:	00 
80102fb0:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102fb7:	e8 b7 ff ff ff       	call   80102f73 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102fbc:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102fc3:	00 
80102fc4:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102fcb:	e8 a3 ff ff ff       	call   80102f73 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102fd0:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102fd7:	00 
80102fd8:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fdf:	e8 8f ff ff ff       	call   80102f73 <lapicw>
  lapicw(TICR, 10000000);
80102fe4:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102feb:	00 
80102fec:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102ff3:	e8 7b ff ff ff       	call   80102f73 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ff8:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102fff:	00 
80103000:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80103007:	e8 67 ff ff ff       	call   80102f73 <lapicw>
  lapicw(LINT1, MASKED);
8010300c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103013:	00 
80103014:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
8010301b:	e8 53 ff ff ff       	call   80102f73 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103020:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
80103025:	83 c0 30             	add    $0x30,%eax
80103028:	8b 00                	mov    (%eax),%eax
8010302a:	c1 e8 10             	shr    $0x10,%eax
8010302d:	0f b6 c0             	movzbl %al,%eax
80103030:	83 f8 03             	cmp    $0x3,%eax
80103033:	76 14                	jbe    80103049 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80103035:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010303c:	00 
8010303d:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80103044:	e8 2a ff ff ff       	call   80102f73 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103049:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80103050:	00 
80103051:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80103058:	e8 16 ff ff ff       	call   80102f73 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010305d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103064:	00 
80103065:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010306c:	e8 02 ff ff ff       	call   80102f73 <lapicw>
  lapicw(ESR, 0);
80103071:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103078:	00 
80103079:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103080:	e8 ee fe ff ff       	call   80102f73 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103085:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010308c:	00 
8010308d:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103094:	e8 da fe ff ff       	call   80102f73 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103099:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030a0:	00 
801030a1:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030a8:	e8 c6 fe ff ff       	call   80102f73 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801030ad:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
801030b4:	00 
801030b5:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030bc:	e8 b2 fe ff ff       	call   80102f73 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801030c1:	90                   	nop
801030c2:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
801030c7:	05 00 03 00 00       	add    $0x300,%eax
801030cc:	8b 00                	mov    (%eax),%eax
801030ce:	25 00 10 00 00       	and    $0x1000,%eax
801030d3:	85 c0                	test   %eax,%eax
801030d5:	75 eb                	jne    801030c2 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801030d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030de:	00 
801030df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801030e6:	e8 88 fe ff ff       	call   80102f73 <lapicw>
}
801030eb:	c9                   	leave  
801030ec:	c3                   	ret    

801030ed <lapicid>:

int
lapicid(void)
{
801030ed:	55                   	push   %ebp
801030ee:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801030f0:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
801030f5:	85 c0                	test   %eax,%eax
801030f7:	75 07                	jne    80103100 <lapicid+0x13>
    return 0;
801030f9:	b8 00 00 00 00       	mov    $0x0,%eax
801030fe:	eb 0d                	jmp    8010310d <lapicid+0x20>
  return lapic[ID] >> 24;
80103100:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
80103105:	83 c0 20             	add    $0x20,%eax
80103108:	8b 00                	mov    (%eax),%eax
8010310a:	c1 e8 18             	shr    $0x18,%eax
}
8010310d:	5d                   	pop    %ebp
8010310e:	c3                   	ret    

8010310f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010310f:	55                   	push   %ebp
80103110:	89 e5                	mov    %esp,%ebp
80103112:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103115:	a1 bc 4b 11 80       	mov    0x80114bbc,%eax
8010311a:	85 c0                	test   %eax,%eax
8010311c:	74 14                	je     80103132 <lapiceoi+0x23>
    lapicw(EOI, 0);
8010311e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103125:	00 
80103126:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
8010312d:	e8 41 fe ff ff       	call   80102f73 <lapicw>
}
80103132:	c9                   	leave  
80103133:	c3                   	ret    

80103134 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
}
80103137:	5d                   	pop    %ebp
80103138:	c3                   	ret    

80103139 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103139:	55                   	push   %ebp
8010313a:	89 e5                	mov    %esp,%ebp
8010313c:	83 ec 1c             	sub    $0x1c,%esp
8010313f:	8b 45 08             	mov    0x8(%ebp),%eax
80103142:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103145:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010314c:	00 
8010314d:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103154:	e8 fe fd ff ff       	call   80102f57 <outb>
  outb(CMOS_PORT+1, 0x0A);
80103159:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103160:	00 
80103161:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103168:	e8 ea fd ff ff       	call   80102f57 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010316d:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103174:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103177:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010317c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010317f:	8d 50 02             	lea    0x2(%eax),%edx
80103182:	8b 45 0c             	mov    0xc(%ebp),%eax
80103185:	c1 e8 04             	shr    $0x4,%eax
80103188:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010318b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010318f:	c1 e0 18             	shl    $0x18,%eax
80103192:	89 44 24 04          	mov    %eax,0x4(%esp)
80103196:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010319d:	e8 d1 fd ff ff       	call   80102f73 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801031a2:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
801031a9:	00 
801031aa:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801031b1:	e8 bd fd ff ff       	call   80102f73 <lapicw>
  microdelay(200);
801031b6:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801031bd:	e8 72 ff ff ff       	call   80103134 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801031c2:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801031c9:	00 
801031ca:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801031d1:	e8 9d fd ff ff       	call   80102f73 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801031d6:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801031dd:	e8 52 ff ff ff       	call   80103134 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801031e9:	eb 3f                	jmp    8010322a <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
801031eb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031ef:	c1 e0 18             	shl    $0x18,%eax
801031f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801031f6:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801031fd:	e8 71 fd ff ff       	call   80102f73 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103202:	8b 45 0c             	mov    0xc(%ebp),%eax
80103205:	c1 e8 0c             	shr    $0xc,%eax
80103208:	80 cc 06             	or     $0x6,%ah
8010320b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010320f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103216:	e8 58 fd ff ff       	call   80102f73 <lapicw>
    microdelay(200);
8010321b:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103222:	e8 0d ff ff ff       	call   80103134 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103227:	ff 45 fc             	incl   -0x4(%ebp)
8010322a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010322e:	7e bb                	jle    801031eb <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103230:	c9                   	leave  
80103231:	c3                   	ret    

80103232 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103232:	55                   	push   %ebp
80103233:	89 e5                	mov    %esp,%ebp
80103235:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103238:	8b 45 08             	mov    0x8(%ebp),%eax
8010323b:	0f b6 c0             	movzbl %al,%eax
8010323e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103242:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103249:	e8 09 fd ff ff       	call   80102f57 <outb>
  microdelay(200);
8010324e:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103255:	e8 da fe ff ff       	call   80103134 <microdelay>

  return inb(CMOS_RETURN);
8010325a:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103261:	e8 d6 fc ff ff       	call   80102f3c <inb>
80103266:	0f b6 c0             	movzbl %al,%eax
}
80103269:	c9                   	leave  
8010326a:	c3                   	ret    

8010326b <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010326b:	55                   	push   %ebp
8010326c:	89 e5                	mov    %esp,%ebp
8010326e:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103278:	e8 b5 ff ff ff       	call   80103232 <cmos_read>
8010327d:	8b 55 08             	mov    0x8(%ebp),%edx
80103280:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103282:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103289:	e8 a4 ff ff ff       	call   80103232 <cmos_read>
8010328e:	8b 55 08             	mov    0x8(%ebp),%edx
80103291:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103294:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010329b:	e8 92 ff ff ff       	call   80103232 <cmos_read>
801032a0:	8b 55 08             	mov    0x8(%ebp),%edx
801032a3:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801032a6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801032ad:	e8 80 ff ff ff       	call   80103232 <cmos_read>
801032b2:	8b 55 08             	mov    0x8(%ebp),%edx
801032b5:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801032b8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801032bf:	e8 6e ff ff ff       	call   80103232 <cmos_read>
801032c4:	8b 55 08             	mov    0x8(%ebp),%edx
801032c7:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801032ca:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801032d1:	e8 5c ff ff ff       	call   80103232 <cmos_read>
801032d6:	8b 55 08             	mov    0x8(%ebp),%edx
801032d9:	89 42 14             	mov    %eax,0x14(%edx)
}
801032dc:	c9                   	leave  
801032dd:	c3                   	ret    

801032de <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801032de:	55                   	push   %ebp
801032df:	89 e5                	mov    %esp,%ebp
801032e1:	57                   	push   %edi
801032e2:	56                   	push   %esi
801032e3:	53                   	push   %ebx
801032e4:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801032e7:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801032ee:	e8 3f ff ff ff       	call   80103232 <cmos_read>
801032f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801032f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032f9:	83 e0 04             	and    $0x4,%eax
801032fc:	85 c0                	test   %eax,%eax
801032fe:	0f 94 c0             	sete   %al
80103301:	0f b6 c0             	movzbl %al,%eax
80103304:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103307:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010330a:	89 04 24             	mov    %eax,(%esp)
8010330d:	e8 59 ff ff ff       	call   8010326b <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103312:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103319:	e8 14 ff ff ff       	call   80103232 <cmos_read>
8010331e:	25 80 00 00 00       	and    $0x80,%eax
80103323:	85 c0                	test   %eax,%eax
80103325:	74 02                	je     80103329 <cmostime+0x4b>
        continue;
80103327:	eb 36                	jmp    8010335f <cmostime+0x81>
    fill_rtcdate(&t2);
80103329:	8d 45 b0             	lea    -0x50(%ebp),%eax
8010332c:	89 04 24             	mov    %eax,(%esp)
8010332f:	e8 37 ff ff ff       	call   8010326b <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103334:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010333b:	00 
8010333c:	8d 45 b0             	lea    -0x50(%ebp),%eax
8010333f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103343:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103346:	89 04 24             	mov    %eax,(%esp)
80103349:	e8 cb 1e 00 00       	call   80105219 <memcmp>
8010334e:	85 c0                	test   %eax,%eax
80103350:	75 0d                	jne    8010335f <cmostime+0x81>
      break;
80103352:	90                   	nop
  }

  // convert
  if(bcd) {
80103353:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80103357:	0f 84 ac 00 00 00    	je     80103409 <cmostime+0x12b>
8010335d:	eb 02                	jmp    80103361 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010335f:	eb a6                	jmp    80103307 <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103361:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103364:	c1 e8 04             	shr    $0x4,%eax
80103367:	89 c2                	mov    %eax,%edx
80103369:	89 d0                	mov    %edx,%eax
8010336b:	c1 e0 02             	shl    $0x2,%eax
8010336e:	01 d0                	add    %edx,%eax
80103370:	01 c0                	add    %eax,%eax
80103372:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103375:	83 e2 0f             	and    $0xf,%edx
80103378:	01 d0                	add    %edx,%eax
8010337a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
8010337d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103380:	c1 e8 04             	shr    $0x4,%eax
80103383:	89 c2                	mov    %eax,%edx
80103385:	89 d0                	mov    %edx,%eax
80103387:	c1 e0 02             	shl    $0x2,%eax
8010338a:	01 d0                	add    %edx,%eax
8010338c:	01 c0                	add    %eax,%eax
8010338e:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103391:	83 e2 0f             	and    $0xf,%edx
80103394:	01 d0                	add    %edx,%eax
80103396:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103399:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010339c:	c1 e8 04             	shr    $0x4,%eax
8010339f:	89 c2                	mov    %eax,%edx
801033a1:	89 d0                	mov    %edx,%eax
801033a3:	c1 e0 02             	shl    $0x2,%eax
801033a6:	01 d0                	add    %edx,%eax
801033a8:	01 c0                	add    %eax,%eax
801033aa:	8b 55 d0             	mov    -0x30(%ebp),%edx
801033ad:	83 e2 0f             	and    $0xf,%edx
801033b0:	01 d0                	add    %edx,%eax
801033b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
801033b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801033b8:	c1 e8 04             	shr    $0x4,%eax
801033bb:	89 c2                	mov    %eax,%edx
801033bd:	89 d0                	mov    %edx,%eax
801033bf:	c1 e0 02             	shl    $0x2,%eax
801033c2:	01 d0                	add    %edx,%eax
801033c4:	01 c0                	add    %eax,%eax
801033c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801033c9:	83 e2 0f             	and    $0xf,%edx
801033cc:	01 d0                	add    %edx,%eax
801033ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
801033d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033d4:	c1 e8 04             	shr    $0x4,%eax
801033d7:	89 c2                	mov    %eax,%edx
801033d9:	89 d0                	mov    %edx,%eax
801033db:	c1 e0 02             	shl    $0x2,%eax
801033de:	01 d0                	add    %edx,%eax
801033e0:	01 c0                	add    %eax,%eax
801033e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
801033e5:	83 e2 0f             	and    $0xf,%edx
801033e8:	01 d0                	add    %edx,%eax
801033ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
801033ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033f0:	c1 e8 04             	shr    $0x4,%eax
801033f3:	89 c2                	mov    %eax,%edx
801033f5:	89 d0                	mov    %edx,%eax
801033f7:	c1 e0 02             	shl    $0x2,%eax
801033fa:	01 d0                	add    %edx,%eax
801033fc:	01 c0                	add    %eax,%eax
801033fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103401:	83 e2 0f             	and    $0xf,%edx
80103404:	01 d0                	add    %edx,%eax
80103406:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
80103409:	8b 45 08             	mov    0x8(%ebp),%eax
8010340c:	89 c2                	mov    %eax,%edx
8010340e:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80103411:	b8 06 00 00 00       	mov    $0x6,%eax
80103416:	89 d7                	mov    %edx,%edi
80103418:	89 de                	mov    %ebx,%esi
8010341a:	89 c1                	mov    %eax,%ecx
8010341c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010341e:	8b 45 08             	mov    0x8(%ebp),%eax
80103421:	8b 40 14             	mov    0x14(%eax),%eax
80103424:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010342a:	8b 45 08             	mov    0x8(%ebp),%eax
8010342d:	89 50 14             	mov    %edx,0x14(%eax)
}
80103430:	83 c4 5c             	add    $0x5c,%esp
80103433:	5b                   	pop    %ebx
80103434:	5e                   	pop    %esi
80103435:	5f                   	pop    %edi
80103436:	5d                   	pop    %ebp
80103437:	c3                   	ret    

80103438 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103438:	55                   	push   %ebp
80103439:	89 e5                	mov    %esp,%ebp
8010343b:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010343e:	c7 44 24 04 3d 93 10 	movl   $0x8010933d,0x4(%esp)
80103445:	80 
80103446:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
8010344d:	e8 cc 1a 00 00       	call   80104f1e <initlock>
  readsb(dev, &sb);
80103452:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103455:	89 44 24 04          	mov    %eax,0x4(%esp)
80103459:	8b 45 08             	mov    0x8(%ebp),%eax
8010345c:	89 04 24             	mov    %eax,(%esp)
8010345f:	e8 d8 e0 ff ff       	call   8010153c <readsb>
  log.start = sb.logstart;
80103464:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103467:	a3 f4 4b 11 80       	mov    %eax,0x80114bf4
  log.size = sb.nlog;
8010346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010346f:	a3 f8 4b 11 80       	mov    %eax,0x80114bf8
  log.dev = dev;
80103474:	8b 45 08             	mov    0x8(%ebp),%eax
80103477:	a3 04 4c 11 80       	mov    %eax,0x80114c04
  recover_from_log();
8010347c:	e8 95 01 00 00       	call   80103616 <recover_from_log>
}
80103481:	c9                   	leave  
80103482:	c3                   	ret    

80103483 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103483:	55                   	push   %ebp
80103484:	89 e5                	mov    %esp,%ebp
80103486:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103490:	e9 89 00 00 00       	jmp    8010351e <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103495:	8b 15 f4 4b 11 80    	mov    0x80114bf4,%edx
8010349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010349e:	01 d0                	add    %edx,%eax
801034a0:	40                   	inc    %eax
801034a1:	89 c2                	mov    %eax,%edx
801034a3:	a1 04 4c 11 80       	mov    0x80114c04,%eax
801034a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801034ac:	89 04 24             	mov    %eax,(%esp)
801034af:	e8 01 cd ff ff       	call   801001b5 <bread>
801034b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034ba:	83 c0 10             	add    $0x10,%eax
801034bd:	8b 04 85 cc 4b 11 80 	mov    -0x7feeb434(,%eax,4),%eax
801034c4:	89 c2                	mov    %eax,%edx
801034c6:	a1 04 4c 11 80       	mov    0x80114c04,%eax
801034cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801034cf:	89 04 24             	mov    %eax,(%esp)
801034d2:	e8 de cc ff ff       	call   801001b5 <bread>
801034d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034dd:	8d 50 5c             	lea    0x5c(%eax),%edx
801034e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034e3:	83 c0 5c             	add    $0x5c,%eax
801034e6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801034ed:	00 
801034ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801034f2:	89 04 24             	mov    %eax,(%esp)
801034f5:	e8 71 1d 00 00       	call   8010526b <memmove>
    bwrite(dbuf);  // write dst to disk
801034fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034fd:	89 04 24             	mov    %eax,(%esp)
80103500:	e8 e7 cc ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103505:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103508:	89 04 24             	mov    %eax,(%esp)
8010350b:	e8 1c cd ff ff       	call   8010022c <brelse>
    brelse(dbuf);
80103510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103513:	89 04 24             	mov    %eax,(%esp)
80103516:	e8 11 cd ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010351b:	ff 45 f4             	incl   -0xc(%ebp)
8010351e:	a1 08 4c 11 80       	mov    0x80114c08,%eax
80103523:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103526:	0f 8f 69 ff ff ff    	jg     80103495 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
8010352c:	c9                   	leave  
8010352d:	c3                   	ret    

8010352e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010352e:	55                   	push   %ebp
8010352f:	89 e5                	mov    %esp,%ebp
80103531:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103534:	a1 f4 4b 11 80       	mov    0x80114bf4,%eax
80103539:	89 c2                	mov    %eax,%edx
8010353b:	a1 04 4c 11 80       	mov    0x80114c04,%eax
80103540:	89 54 24 04          	mov    %edx,0x4(%esp)
80103544:	89 04 24             	mov    %eax,(%esp)
80103547:	e8 69 cc ff ff       	call   801001b5 <bread>
8010354c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010354f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103552:	83 c0 5c             	add    $0x5c,%eax
80103555:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103558:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010355b:	8b 00                	mov    (%eax),%eax
8010355d:	a3 08 4c 11 80       	mov    %eax,0x80114c08
  for (i = 0; i < log.lh.n; i++) {
80103562:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103569:	eb 1a                	jmp    80103585 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
8010356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010356e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103571:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103578:	83 c2 10             	add    $0x10,%edx
8010357b:	89 04 95 cc 4b 11 80 	mov    %eax,-0x7feeb434(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103582:	ff 45 f4             	incl   -0xc(%ebp)
80103585:	a1 08 4c 11 80       	mov    0x80114c08,%eax
8010358a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010358d:	7f dc                	jg     8010356b <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010358f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103592:	89 04 24             	mov    %eax,(%esp)
80103595:	e8 92 cc ff ff       	call   8010022c <brelse>
}
8010359a:	c9                   	leave  
8010359b:	c3                   	ret    

8010359c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010359c:	55                   	push   %ebp
8010359d:	89 e5                	mov    %esp,%ebp
8010359f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801035a2:	a1 f4 4b 11 80       	mov    0x80114bf4,%eax
801035a7:	89 c2                	mov    %eax,%edx
801035a9:	a1 04 4c 11 80       	mov    0x80114c04,%eax
801035ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801035b2:	89 04 24             	mov    %eax,(%esp)
801035b5:	e8 fb cb ff ff       	call   801001b5 <bread>
801035ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801035bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035c0:	83 c0 5c             	add    $0x5c,%eax
801035c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801035c6:	8b 15 08 4c 11 80    	mov    0x80114c08,%edx
801035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035cf:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801035d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035d8:	eb 1a                	jmp    801035f4 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
801035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dd:	83 c0 10             	add    $0x10,%eax
801035e0:	8b 0c 85 cc 4b 11 80 	mov    -0x7feeb434(,%eax,4),%ecx
801035e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035ed:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035f1:	ff 45 f4             	incl   -0xc(%ebp)
801035f4:	a1 08 4c 11 80       	mov    0x80114c08,%eax
801035f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035fc:	7f dc                	jg     801035da <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103601:	89 04 24             	mov    %eax,(%esp)
80103604:	e8 e3 cb ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103609:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010360c:	89 04 24             	mov    %eax,(%esp)
8010360f:	e8 18 cc ff ff       	call   8010022c <brelse>
}
80103614:	c9                   	leave  
80103615:	c3                   	ret    

80103616 <recover_from_log>:

static void
recover_from_log(void)
{
80103616:	55                   	push   %ebp
80103617:	89 e5                	mov    %esp,%ebp
80103619:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010361c:	e8 0d ff ff ff       	call   8010352e <read_head>
  install_trans(); // if committed, copy from log to disk
80103621:	e8 5d fe ff ff       	call   80103483 <install_trans>
  log.lh.n = 0;
80103626:	c7 05 08 4c 11 80 00 	movl   $0x0,0x80114c08
8010362d:	00 00 00 
  write_head(); // clear the log
80103630:	e8 67 ff ff ff       	call   8010359c <write_head>
}
80103635:	c9                   	leave  
80103636:	c3                   	ret    

80103637 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103637:	55                   	push   %ebp
80103638:	89 e5                	mov    %esp,%ebp
8010363a:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010363d:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103644:	e8 f6 18 00 00       	call   80104f3f <acquire>
  while(1){
    if(log.committing){
80103649:	a1 00 4c 11 80       	mov    0x80114c00,%eax
8010364e:	85 c0                	test   %eax,%eax
80103650:	74 16                	je     80103668 <begin_op+0x31>
      sleep(&log, &log.lock);
80103652:	c7 44 24 04 c0 4b 11 	movl   $0x80114bc0,0x4(%esp)
80103659:	80 
8010365a:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103661:	e8 0a 15 00 00       	call   80104b70 <sleep>
80103666:	eb 4d                	jmp    801036b5 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103668:	8b 15 08 4c 11 80    	mov    0x80114c08,%edx
8010366e:	a1 fc 4b 11 80       	mov    0x80114bfc,%eax
80103673:	8d 48 01             	lea    0x1(%eax),%ecx
80103676:	89 c8                	mov    %ecx,%eax
80103678:	c1 e0 02             	shl    $0x2,%eax
8010367b:	01 c8                	add    %ecx,%eax
8010367d:	01 c0                	add    %eax,%eax
8010367f:	01 d0                	add    %edx,%eax
80103681:	83 f8 1e             	cmp    $0x1e,%eax
80103684:	7e 16                	jle    8010369c <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103686:	c7 44 24 04 c0 4b 11 	movl   $0x80114bc0,0x4(%esp)
8010368d:	80 
8010368e:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103695:	e8 d6 14 00 00       	call   80104b70 <sleep>
8010369a:	eb 19                	jmp    801036b5 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
8010369c:	a1 fc 4b 11 80       	mov    0x80114bfc,%eax
801036a1:	40                   	inc    %eax
801036a2:	a3 fc 4b 11 80       	mov    %eax,0x80114bfc
      release(&log.lock);
801036a7:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
801036ae:	e8 f6 18 00 00       	call   80104fa9 <release>
      break;
801036b3:	eb 02                	jmp    801036b7 <begin_op+0x80>
    }
  }
801036b5:	eb 92                	jmp    80103649 <begin_op+0x12>
}
801036b7:	c9                   	leave  
801036b8:	c3                   	ret    

801036b9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801036b9:	55                   	push   %ebp
801036ba:	89 e5                	mov    %esp,%ebp
801036bc:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801036bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801036c6:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
801036cd:	e8 6d 18 00 00       	call   80104f3f <acquire>
  log.outstanding -= 1;
801036d2:	a1 fc 4b 11 80       	mov    0x80114bfc,%eax
801036d7:	48                   	dec    %eax
801036d8:	a3 fc 4b 11 80       	mov    %eax,0x80114bfc
  if(log.committing)
801036dd:	a1 00 4c 11 80       	mov    0x80114c00,%eax
801036e2:	85 c0                	test   %eax,%eax
801036e4:	74 0c                	je     801036f2 <end_op+0x39>
    panic("log.committing");
801036e6:	c7 04 24 41 93 10 80 	movl   $0x80109341,(%esp)
801036ed:	e8 90 ce ff ff       	call   80100582 <panic>
  if(log.outstanding == 0){
801036f2:	a1 fc 4b 11 80       	mov    0x80114bfc,%eax
801036f7:	85 c0                	test   %eax,%eax
801036f9:	75 13                	jne    8010370e <end_op+0x55>
    do_commit = 1;
801036fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103702:	c7 05 00 4c 11 80 01 	movl   $0x1,0x80114c00
80103709:	00 00 00 
8010370c:	eb 0c                	jmp    8010371a <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010370e:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103715:	e8 2a 15 00 00       	call   80104c44 <wakeup>
  }
  release(&log.lock);
8010371a:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103721:	e8 83 18 00 00       	call   80104fa9 <release>

  if(do_commit){
80103726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010372a:	74 33                	je     8010375f <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010372c:	e8 db 00 00 00       	call   8010380c <commit>
    acquire(&log.lock);
80103731:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103738:	e8 02 18 00 00       	call   80104f3f <acquire>
    log.committing = 0;
8010373d:	c7 05 00 4c 11 80 00 	movl   $0x0,0x80114c00
80103744:	00 00 00 
    wakeup(&log);
80103747:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
8010374e:	e8 f1 14 00 00       	call   80104c44 <wakeup>
    release(&log.lock);
80103753:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
8010375a:	e8 4a 18 00 00       	call   80104fa9 <release>
  }
}
8010375f:	c9                   	leave  
80103760:	c3                   	ret    

80103761 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103761:	55                   	push   %ebp
80103762:	89 e5                	mov    %esp,%ebp
80103764:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010376e:	e9 89 00 00 00       	jmp    801037fc <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103773:	8b 15 f4 4b 11 80    	mov    0x80114bf4,%edx
80103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377c:	01 d0                	add    %edx,%eax
8010377e:	40                   	inc    %eax
8010377f:	89 c2                	mov    %eax,%edx
80103781:	a1 04 4c 11 80       	mov    0x80114c04,%eax
80103786:	89 54 24 04          	mov    %edx,0x4(%esp)
8010378a:	89 04 24             	mov    %eax,(%esp)
8010378d:	e8 23 ca ff ff       	call   801001b5 <bread>
80103792:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103798:	83 c0 10             	add    $0x10,%eax
8010379b:	8b 04 85 cc 4b 11 80 	mov    -0x7feeb434(,%eax,4),%eax
801037a2:	89 c2                	mov    %eax,%edx
801037a4:	a1 04 4c 11 80       	mov    0x80114c04,%eax
801037a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801037ad:	89 04 24             	mov    %eax,(%esp)
801037b0:	e8 00 ca ff ff       	call   801001b5 <bread>
801037b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801037b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037bb:	8d 50 5c             	lea    0x5c(%eax),%edx
801037be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037c1:	83 c0 5c             	add    $0x5c,%eax
801037c4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801037cb:	00 
801037cc:	89 54 24 04          	mov    %edx,0x4(%esp)
801037d0:	89 04 24             	mov    %eax,(%esp)
801037d3:	e8 93 1a 00 00       	call   8010526b <memmove>
    bwrite(to);  // write the log
801037d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037db:	89 04 24             	mov    %eax,(%esp)
801037de:	e8 09 ca ff ff       	call   801001ec <bwrite>
    brelse(from);
801037e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037e6:	89 04 24             	mov    %eax,(%esp)
801037e9:	e8 3e ca ff ff       	call   8010022c <brelse>
    brelse(to);
801037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f1:	89 04 24             	mov    %eax,(%esp)
801037f4:	e8 33 ca ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037f9:	ff 45 f4             	incl   -0xc(%ebp)
801037fc:	a1 08 4c 11 80       	mov    0x80114c08,%eax
80103801:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103804:	0f 8f 69 ff ff ff    	jg     80103773 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
8010380a:	c9                   	leave  
8010380b:	c3                   	ret    

8010380c <commit>:

static void
commit()
{
8010380c:	55                   	push   %ebp
8010380d:	89 e5                	mov    %esp,%ebp
8010380f:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103812:	a1 08 4c 11 80       	mov    0x80114c08,%eax
80103817:	85 c0                	test   %eax,%eax
80103819:	7e 1e                	jle    80103839 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010381b:	e8 41 ff ff ff       	call   80103761 <write_log>
    write_head();    // Write header to disk -- the real commit
80103820:	e8 77 fd ff ff       	call   8010359c <write_head>
    install_trans(); // Now install writes to home locations
80103825:	e8 59 fc ff ff       	call   80103483 <install_trans>
    log.lh.n = 0;
8010382a:	c7 05 08 4c 11 80 00 	movl   $0x0,0x80114c08
80103831:	00 00 00 
    write_head();    // Erase the transaction from the log
80103834:	e8 63 fd ff ff       	call   8010359c <write_head>
  }
}
80103839:	c9                   	leave  
8010383a:	c3                   	ret    

8010383b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010383b:	55                   	push   %ebp
8010383c:	89 e5                	mov    %esp,%ebp
8010383e:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103841:	a1 08 4c 11 80       	mov    0x80114c08,%eax
80103846:	83 f8 1d             	cmp    $0x1d,%eax
80103849:	7f 10                	jg     8010385b <log_write+0x20>
8010384b:	a1 08 4c 11 80       	mov    0x80114c08,%eax
80103850:	8b 15 f8 4b 11 80    	mov    0x80114bf8,%edx
80103856:	4a                   	dec    %edx
80103857:	39 d0                	cmp    %edx,%eax
80103859:	7c 0c                	jl     80103867 <log_write+0x2c>
    panic("too big a transaction");
8010385b:	c7 04 24 50 93 10 80 	movl   $0x80109350,(%esp)
80103862:	e8 1b cd ff ff       	call   80100582 <panic>
  if (log.outstanding < 1)
80103867:	a1 fc 4b 11 80       	mov    0x80114bfc,%eax
8010386c:	85 c0                	test   %eax,%eax
8010386e:	7f 0c                	jg     8010387c <log_write+0x41>
    panic("log_write outside of trans");
80103870:	c7 04 24 66 93 10 80 	movl   $0x80109366,(%esp)
80103877:	e8 06 cd ff ff       	call   80100582 <panic>

  acquire(&log.lock);
8010387c:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80103883:	e8 b7 16 00 00       	call   80104f3f <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010388f:	eb 1e                	jmp    801038af <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103894:	83 c0 10             	add    $0x10,%eax
80103897:	8b 04 85 cc 4b 11 80 	mov    -0x7feeb434(,%eax,4),%eax
8010389e:	89 c2                	mov    %eax,%edx
801038a0:	8b 45 08             	mov    0x8(%ebp),%eax
801038a3:	8b 40 08             	mov    0x8(%eax),%eax
801038a6:	39 c2                	cmp    %eax,%edx
801038a8:	75 02                	jne    801038ac <log_write+0x71>
      break;
801038aa:	eb 0d                	jmp    801038b9 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801038ac:	ff 45 f4             	incl   -0xc(%ebp)
801038af:	a1 08 4c 11 80       	mov    0x80114c08,%eax
801038b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038b7:	7f d8                	jg     80103891 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801038b9:	8b 45 08             	mov    0x8(%ebp),%eax
801038bc:	8b 40 08             	mov    0x8(%eax),%eax
801038bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038c2:	83 c2 10             	add    $0x10,%edx
801038c5:	89 04 95 cc 4b 11 80 	mov    %eax,-0x7feeb434(,%edx,4)
  if (i == log.lh.n)
801038cc:	a1 08 4c 11 80       	mov    0x80114c08,%eax
801038d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d4:	75 0b                	jne    801038e1 <log_write+0xa6>
    log.lh.n++;
801038d6:	a1 08 4c 11 80       	mov    0x80114c08,%eax
801038db:	40                   	inc    %eax
801038dc:	a3 08 4c 11 80       	mov    %eax,0x80114c08
  b->flags |= B_DIRTY; // prevent eviction
801038e1:	8b 45 08             	mov    0x8(%ebp),%eax
801038e4:	8b 00                	mov    (%eax),%eax
801038e6:	83 c8 04             	or     $0x4,%eax
801038e9:	89 c2                	mov    %eax,%edx
801038eb:	8b 45 08             	mov    0x8(%ebp),%eax
801038ee:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038f0:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
801038f7:	e8 ad 16 00 00       	call   80104fa9 <release>
}
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    
	...

80103900 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103906:	8b 55 08             	mov    0x8(%ebp),%edx
80103909:	8b 45 0c             	mov    0xc(%ebp),%eax
8010390c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010390f:	f0 87 02             	lock xchg %eax,(%edx)
80103912:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103915:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103918:	c9                   	leave  
80103919:	c3                   	ret    

8010391a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010391a:	55                   	push   %ebp
8010391b:	89 e5                	mov    %esp,%ebp
8010391d:	83 e4 f0             	and    $0xfffffff0,%esp
80103920:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103923:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010392a:	80 
8010392b:	c7 04 24 e8 79 11 80 	movl   $0x801179e8,(%esp)
80103932:	e8 0d f3 ff ff       	call   80102c44 <kinit1>
  kvmalloc();      // kernel page table
80103937:	e8 3b 4a 00 00       	call   80108377 <kvmalloc>
  mpinit();        // detect other processors
8010393c:	e8 c4 03 00 00       	call   80103d05 <mpinit>
  lapicinit();     // interrupt controller
80103941:	e8 4e f6 ff ff       	call   80102f94 <lapicinit>
  seginit();       // segment descriptors
80103946:	e8 14 45 00 00       	call   80107e5f <seginit>
  picinit();       // disable pic
8010394b:	e8 04 05 00 00       	call   80103e54 <picinit>
  ioapicinit();    // another interrupt controller
80103950:	e8 0c f2 ff ff       	call   80102b61 <ioapicinit>
  consoleinit();   // console hardware
80103955:	e8 6b d3 ff ff       	call   80100cc5 <consoleinit>
  uartinit();      // serial port
8010395a:	e8 8c 38 00 00       	call   801071eb <uartinit>
  pinit();         // process table
8010395f:	e8 e6 08 00 00       	call   8010424a <pinit>
  tvinit();        // trap vectors
80103964:	e8 6b 34 00 00       	call   80106dd4 <tvinit>
  binit();         // buffer cache
80103969:	e8 c6 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010396e:	e8 ed d7 ff ff       	call   80101160 <fileinit>
  ideinit();       // disk 
80103973:	e8 f5 ed ff ff       	call   8010276d <ideinit>
  startothers();   // start other processors
80103978:	e8 83 00 00 00       	call   80103a00 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010397d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103984:	8e 
80103985:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010398c:	e8 eb f2 ff ff       	call   80102c7c <kinit2>
  userinit();      // first user process
80103991:	e8 c1 0a 00 00       	call   80104457 <userinit>
  mpmain();        // finish this processor's setup
80103996:	e8 1a 00 00 00       	call   801039b5 <mpmain>

8010399b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010399b:	55                   	push   %ebp
8010399c:	89 e5                	mov    %esp,%ebp
8010399e:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801039a1:	e8 e8 49 00 00       	call   8010838e <switchkvm>
  seginit();
801039a6:	e8 b4 44 00 00       	call   80107e5f <seginit>
  lapicinit();
801039ab:	e8 e4 f5 ff ff       	call   80102f94 <lapicinit>
  mpmain();
801039b0:	e8 00 00 00 00       	call   801039b5 <mpmain>

801039b5 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039b5:	55                   	push   %ebp
801039b6:	89 e5                	mov    %esp,%ebp
801039b8:	53                   	push   %ebx
801039b9:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801039bc:	e8 a5 08 00 00       	call   80104266 <cpuid>
801039c1:	89 c3                	mov    %eax,%ebx
801039c3:	e8 9e 08 00 00       	call   80104266 <cpuid>
801039c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801039cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801039d0:	c7 04 24 81 93 10 80 	movl   $0x80109381,(%esp)
801039d7:	e8 13 ca ff ff       	call   801003ef <cprintf>
  idtinit();       // load idt register
801039dc:	e8 50 35 00 00       	call   80106f31 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801039e1:	e8 c5 08 00 00       	call   801042ab <mycpu>
801039e6:	05 a0 00 00 00       	add    $0xa0,%eax
801039eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801039f2:	00 
801039f3:	89 04 24             	mov    %eax,(%esp)
801039f6:	e8 05 ff ff ff       	call   80103900 <xchg>
  scheduler();     // start running processes
801039fb:	e8 a6 0f 00 00       	call   801049a6 <scheduler>

80103a00 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103a06:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a0d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a12:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a16:	c7 44 24 04 4c c5 10 	movl   $0x8010c54c,0x4(%esp)
80103a1d:	80 
80103a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a21:	89 04 24             	mov    %eax,(%esp)
80103a24:	e8 42 18 00 00       	call   8010526b <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103a29:	c7 45 f4 c0 4c 11 80 	movl   $0x80114cc0,-0xc(%ebp)
80103a30:	eb 75                	jmp    80103aa7 <startothers+0xa7>
    if(c == mycpu())  // We've started already.
80103a32:	e8 74 08 00 00       	call   801042ab <mycpu>
80103a37:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a3a:	75 02                	jne    80103a3e <startothers+0x3e>
      continue;
80103a3c:	eb 62                	jmp    80103aa0 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a3e:	e8 2c f3 ff ff       	call   80102d6f <kalloc>
80103a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a49:	83 e8 04             	sub    $0x4,%eax
80103a4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a4f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a55:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5a:	83 e8 08             	sub    $0x8,%eax
80103a5d:	c7 00 9b 39 10 80    	movl   $0x8010399b,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a66:	8d 50 f4             	lea    -0xc(%eax),%edx
80103a69:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103a6e:	05 00 00 00 80       	add    $0x80000000,%eax
80103a73:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a78:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a81:	8a 00                	mov    (%eax),%al
80103a83:	0f b6 c0             	movzbl %al,%eax
80103a86:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a8a:	89 04 24             	mov    %eax,(%esp)
80103a8d:	e8 a7 f6 ff ff       	call   80103139 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a92:	90                   	nop
80103a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a96:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	74 f3                	je     80103a93 <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103aa0:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103aa7:	a1 40 52 11 80       	mov    0x80115240,%eax
80103aac:	89 c2                	mov    %eax,%edx
80103aae:	89 d0                	mov    %edx,%eax
80103ab0:	c1 e0 02             	shl    $0x2,%eax
80103ab3:	01 d0                	add    %edx,%eax
80103ab5:	01 c0                	add    %eax,%eax
80103ab7:	01 d0                	add    %edx,%eax
80103ab9:	c1 e0 04             	shl    $0x4,%eax
80103abc:	05 c0 4c 11 80       	add    $0x80114cc0,%eax
80103ac1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ac4:	0f 87 68 ff ff ff    	ja     80103a32 <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103aca:	c9                   	leave  
80103acb:	c3                   	ret    

80103acc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103acc:	55                   	push   %ebp
80103acd:	89 e5                	mov    %esp,%ebp
80103acf:	83 ec 14             	sub    $0x14,%esp
80103ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ad5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103adc:	89 c2                	mov    %eax,%edx
80103ade:	ec                   	in     (%dx),%al
80103adf:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103ae2:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103ae5:	c9                   	leave  
80103ae6:	c3                   	ret    

80103ae7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103ae7:	55                   	push   %ebp
80103ae8:	89 e5                	mov    %esp,%ebp
80103aea:	83 ec 08             	sub    $0x8,%esp
80103aed:	8b 45 08             	mov    0x8(%ebp),%eax
80103af0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103af3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103af7:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103afa:	8a 45 f8             	mov    -0x8(%ebp),%al
80103afd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b00:	ee                   	out    %al,(%dx)
}
80103b01:	c9                   	leave  
80103b02:	c3                   	ret    

80103b03 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103b03:	55                   	push   %ebp
80103b04:	89 e5                	mov    %esp,%ebp
80103b06:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103b09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b17:	eb 13                	jmp    80103b2c <sum+0x29>
    sum += addr[i];
80103b19:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b1f:	01 d0                	add    %edx,%eax
80103b21:	8a 00                	mov    (%eax),%al
80103b23:	0f b6 c0             	movzbl %al,%eax
80103b26:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103b29:	ff 45 fc             	incl   -0x4(%ebp)
80103b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b32:	7c e5                	jl     80103b19 <sum+0x16>
    sum += addr[i];
  return sum;
80103b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b37:	c9                   	leave  
80103b38:	c3                   	ret    

80103b39 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b39:	55                   	push   %ebp
80103b3a:	89 e5                	mov    %esp,%ebp
80103b3c:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103b42:	05 00 00 00 80       	add    $0x80000000,%eax
80103b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b50:	01 d0                	add    %edx,%eax
80103b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b5b:	eb 3f                	jmp    80103b9c <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b5d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b64:	00 
80103b65:	c7 44 24 04 98 93 10 	movl   $0x80109398,0x4(%esp)
80103b6c:	80 
80103b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b70:	89 04 24             	mov    %eax,(%esp)
80103b73:	e8 a1 16 00 00       	call   80105219 <memcmp>
80103b78:	85 c0                	test   %eax,%eax
80103b7a:	75 1c                	jne    80103b98 <mpsearch1+0x5f>
80103b7c:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103b83:	00 
80103b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b87:	89 04 24             	mov    %eax,(%esp)
80103b8a:	e8 74 ff ff ff       	call   80103b03 <sum>
80103b8f:	84 c0                	test   %al,%al
80103b91:	75 05                	jne    80103b98 <mpsearch1+0x5f>
      return (struct mp*)p;
80103b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b96:	eb 11                	jmp    80103ba9 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b98:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ba2:	72 b9                	jb     80103b5d <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ba4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ba9:	c9                   	leave  
80103baa:	c3                   	ret    

80103bab <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103bab:	55                   	push   %ebp
80103bac:	89 e5                	mov    %esp,%ebp
80103bae:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bb1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbb:	83 c0 0f             	add    $0xf,%eax
80103bbe:	8a 00                	mov    (%eax),%al
80103bc0:	0f b6 c0             	movzbl %al,%eax
80103bc3:	c1 e0 08             	shl    $0x8,%eax
80103bc6:	89 c2                	mov    %eax,%edx
80103bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcb:	83 c0 0e             	add    $0xe,%eax
80103bce:	8a 00                	mov    (%eax),%al
80103bd0:	0f b6 c0             	movzbl %al,%eax
80103bd3:	09 d0                	or     %edx,%eax
80103bd5:	c1 e0 04             	shl    $0x4,%eax
80103bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bdf:	74 21                	je     80103c02 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103be1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103be8:	00 
80103be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bec:	89 04 24             	mov    %eax,(%esp)
80103bef:	e8 45 ff ff ff       	call   80103b39 <mpsearch1>
80103bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bfb:	74 4e                	je     80103c4b <mpsearch+0xa0>
      return mp;
80103bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c00:	eb 5d                	jmp    80103c5f <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c05:	83 c0 14             	add    $0x14,%eax
80103c08:	8a 00                	mov    (%eax),%al
80103c0a:	0f b6 c0             	movzbl %al,%eax
80103c0d:	c1 e0 08             	shl    $0x8,%eax
80103c10:	89 c2                	mov    %eax,%edx
80103c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c15:	83 c0 13             	add    $0x13,%eax
80103c18:	8a 00                	mov    (%eax),%al
80103c1a:	0f b6 c0             	movzbl %al,%eax
80103c1d:	09 d0                	or     %edx,%eax
80103c1f:	c1 e0 0a             	shl    $0xa,%eax
80103c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c28:	2d 00 04 00 00       	sub    $0x400,%eax
80103c2d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103c34:	00 
80103c35:	89 04 24             	mov    %eax,(%esp)
80103c38:	e8 fc fe ff ff       	call   80103b39 <mpsearch1>
80103c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c44:	74 05                	je     80103c4b <mpsearch+0xa0>
      return mp;
80103c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c49:	eb 14                	jmp    80103c5f <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c4b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103c52:	00 
80103c53:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103c5a:	e8 da fe ff ff       	call   80103b39 <mpsearch1>
}
80103c5f:	c9                   	leave  
80103c60:	c3                   	ret    

80103c61 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c61:	55                   	push   %ebp
80103c62:	89 e5                	mov    %esp,%ebp
80103c64:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c67:	e8 3f ff ff ff       	call   80103bab <mpsearch>
80103c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c73:	74 0a                	je     80103c7f <mpconfig+0x1e>
80103c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c78:	8b 40 04             	mov    0x4(%eax),%eax
80103c7b:	85 c0                	test   %eax,%eax
80103c7d:	75 07                	jne    80103c86 <mpconfig+0x25>
    return 0;
80103c7f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c84:	eb 7d                	jmp    80103d03 <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c89:	8b 40 04             	mov    0x4(%eax),%eax
80103c8c:	05 00 00 00 80       	add    $0x80000000,%eax
80103c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c94:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c9b:	00 
80103c9c:	c7 44 24 04 9d 93 10 	movl   $0x8010939d,0x4(%esp)
80103ca3:	80 
80103ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca7:	89 04 24             	mov    %eax,(%esp)
80103caa:	e8 6a 15 00 00       	call   80105219 <memcmp>
80103caf:	85 c0                	test   %eax,%eax
80103cb1:	74 07                	je     80103cba <mpconfig+0x59>
    return 0;
80103cb3:	b8 00 00 00 00       	mov    $0x0,%eax
80103cb8:	eb 49                	jmp    80103d03 <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbd:	8a 40 06             	mov    0x6(%eax),%al
80103cc0:	3c 01                	cmp    $0x1,%al
80103cc2:	74 11                	je     80103cd5 <mpconfig+0x74>
80103cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc7:	8a 40 06             	mov    0x6(%eax),%al
80103cca:	3c 04                	cmp    $0x4,%al
80103ccc:	74 07                	je     80103cd5 <mpconfig+0x74>
    return 0;
80103cce:	b8 00 00 00 00       	mov    $0x0,%eax
80103cd3:	eb 2e                	jmp    80103d03 <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd8:	8b 40 04             	mov    0x4(%eax),%eax
80103cdb:	0f b7 c0             	movzwl %ax,%eax
80103cde:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce5:	89 04 24             	mov    %eax,(%esp)
80103ce8:	e8 16 fe ff ff       	call   80103b03 <sum>
80103ced:	84 c0                	test   %al,%al
80103cef:	74 07                	je     80103cf8 <mpconfig+0x97>
    return 0;
80103cf1:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf6:	eb 0b                	jmp    80103d03 <mpconfig+0xa2>
  *pmp = mp;
80103cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cfe:	89 10                	mov    %edx,(%eax)
  return conf;
80103d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d03:	c9                   	leave  
80103d04:	c3                   	ret    

80103d05 <mpinit>:

void
mpinit(void)
{
80103d05:	55                   	push   %ebp
80103d06:	89 e5                	mov    %esp,%ebp
80103d08:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103d0b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103d0e:	89 04 24             	mov    %eax,(%esp)
80103d11:	e8 4b ff ff ff       	call   80103c61 <mpconfig>
80103d16:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d1d:	75 0c                	jne    80103d2b <mpinit+0x26>
    panic("Expect to run on an SMP");
80103d1f:	c7 04 24 a2 93 10 80 	movl   $0x801093a2,(%esp)
80103d26:	e8 57 c8 ff ff       	call   80100582 <panic>
  ismp = 1;
80103d2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d35:	8b 40 24             	mov    0x24(%eax),%eax
80103d38:	a3 bc 4b 11 80       	mov    %eax,0x80114bbc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d40:	83 c0 2c             	add    $0x2c,%eax
80103d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d49:	8b 40 04             	mov    0x4(%eax),%eax
80103d4c:	0f b7 d0             	movzwl %ax,%edx
80103d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d52:	01 d0                	add    %edx,%eax
80103d54:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103d57:	eb 7d                	jmp    80103dd6 <mpinit+0xd1>
    switch(*p){
80103d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d5c:	8a 00                	mov    (%eax),%al
80103d5e:	0f b6 c0             	movzbl %al,%eax
80103d61:	83 f8 04             	cmp    $0x4,%eax
80103d64:	77 68                	ja     80103dce <mpinit+0xc9>
80103d66:	8b 04 85 dc 93 10 80 	mov    -0x7fef6c24(,%eax,4),%eax
80103d6d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103d75:	a1 40 52 11 80       	mov    0x80115240,%eax
80103d7a:	83 f8 07             	cmp    $0x7,%eax
80103d7d:	7f 2c                	jg     80103dab <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d7f:	8b 15 40 52 11 80    	mov    0x80115240,%edx
80103d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d88:	8a 48 01             	mov    0x1(%eax),%cl
80103d8b:	89 d0                	mov    %edx,%eax
80103d8d:	c1 e0 02             	shl    $0x2,%eax
80103d90:	01 d0                	add    %edx,%eax
80103d92:	01 c0                	add    %eax,%eax
80103d94:	01 d0                	add    %edx,%eax
80103d96:	c1 e0 04             	shl    $0x4,%eax
80103d99:	05 c0 4c 11 80       	add    $0x80114cc0,%eax
80103d9e:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103da0:	a1 40 52 11 80       	mov    0x80115240,%eax
80103da5:	40                   	inc    %eax
80103da6:	a3 40 52 11 80       	mov    %eax,0x80115240
      }
      p += sizeof(struct mpproc);
80103dab:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103daf:	eb 25                	jmp    80103dd6 <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db4:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dba:	8a 40 01             	mov    0x1(%eax),%al
80103dbd:	a2 a0 4c 11 80       	mov    %al,0x80114ca0
      p += sizeof(struct mpioapic);
80103dc2:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dc6:	eb 0e                	jmp    80103dd6 <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103dc8:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dcc:	eb 08                	jmp    80103dd6 <mpinit+0xd1>
    default:
      ismp = 0;
80103dce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103dd5:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103ddc:	0f 82 77 ff ff ff    	jb     80103d59 <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103de2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103de6:	75 0c                	jne    80103df4 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103de8:	c7 04 24 bc 93 10 80 	movl   $0x801093bc,(%esp)
80103def:	e8 8e c7 ff ff       	call   80100582 <panic>

  if(mp->imcrp){
80103df4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103df7:	8a 40 0c             	mov    0xc(%eax),%al
80103dfa:	84 c0                	test   %al,%al
80103dfc:	74 36                	je     80103e34 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103dfe:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103e05:	00 
80103e06:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103e0d:	e8 d5 fc ff ff       	call   80103ae7 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e12:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e19:	e8 ae fc ff ff       	call   80103acc <inb>
80103e1e:	83 c8 01             	or     $0x1,%eax
80103e21:	0f b6 c0             	movzbl %al,%eax
80103e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e28:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e2f:	e8 b3 fc ff ff       	call   80103ae7 <outb>
  }
}
80103e34:	c9                   	leave  
80103e35:	c3                   	ret    
	...

80103e38 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e38:	55                   	push   %ebp
80103e39:	89 e5                	mov    %esp,%ebp
80103e3b:	83 ec 08             	sub    $0x8,%esp
80103e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e41:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e48:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e4b:	8a 45 f8             	mov    -0x8(%ebp),%al
80103e4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e51:	ee                   	out    %al,(%dx)
}
80103e52:	c9                   	leave  
80103e53:	c3                   	ret    

80103e54 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e5a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e61:	00 
80103e62:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e69:	e8 ca ff ff ff       	call   80103e38 <outb>
  outb(IO_PIC2+1, 0xFF);
80103e6e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e75:	00 
80103e76:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e7d:	e8 b6 ff ff ff       	call   80103e38 <outb>
}
80103e82:	c9                   	leave  
80103e83:	c3                   	ret    

80103e84 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103e8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103e91:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e9d:	8b 10                	mov    (%eax),%edx
80103e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea2:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ea4:	e8 d3 d2 ff ff       	call   8010117c <filealloc>
80103ea9:	8b 55 08             	mov    0x8(%ebp),%edx
80103eac:	89 02                	mov    %eax,(%edx)
80103eae:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb1:	8b 00                	mov    (%eax),%eax
80103eb3:	85 c0                	test   %eax,%eax
80103eb5:	0f 84 c8 00 00 00    	je     80103f83 <pipealloc+0xff>
80103ebb:	e8 bc d2 ff ff       	call   8010117c <filealloc>
80103ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ec3:	89 02                	mov    %eax,(%edx)
80103ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ec8:	8b 00                	mov    (%eax),%eax
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	0f 84 b1 00 00 00    	je     80103f83 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ed2:	e8 98 ee ff ff       	call   80102d6f <kalloc>
80103ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ede:	75 05                	jne    80103ee5 <pipealloc+0x61>
    goto bad;
80103ee0:	e9 9e 00 00 00       	jmp    80103f83 <pipealloc+0xff>
  p->readopen = 1;
80103ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103eef:	00 00 00 
  p->writeopen = 1;
80103ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103efc:	00 00 00 
  p->nwrite = 0;
80103eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f02:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103f09:	00 00 00 
  p->nread = 0;
80103f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f0f:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103f16:	00 00 00 
  initlock(&p->lock, "pipe");
80103f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f1c:	c7 44 24 04 f0 93 10 	movl   $0x801093f0,0x4(%esp)
80103f23:	80 
80103f24:	89 04 24             	mov    %eax,(%esp)
80103f27:	e8 f2 0f 00 00       	call   80104f1e <initlock>
  (*f0)->type = FD_PIPE;
80103f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2f:	8b 00                	mov    (%eax),%eax
80103f31:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103f37:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3a:	8b 00                	mov    (%eax),%eax
80103f3c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103f40:	8b 45 08             	mov    0x8(%ebp),%eax
80103f43:	8b 00                	mov    (%eax),%eax
80103f45:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103f49:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4c:	8b 00                	mov    (%eax),%eax
80103f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f51:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103f54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f57:	8b 00                	mov    (%eax),%eax
80103f59:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f62:	8b 00                	mov    (%eax),%eax
80103f64:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6b:	8b 00                	mov    (%eax),%eax
80103f6d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103f71:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f74:	8b 00                	mov    (%eax),%eax
80103f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f79:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103f7c:	b8 00 00 00 00       	mov    $0x0,%eax
80103f81:	eb 42                	jmp    80103fc5 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f87:	74 0b                	je     80103f94 <pipealloc+0x110>
    kfree((char*)p);
80103f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8c:	89 04 24             	mov    %eax,(%esp)
80103f8f:	e8 45 ed ff ff       	call   80102cd9 <kfree>
  if(*f0)
80103f94:	8b 45 08             	mov    0x8(%ebp),%eax
80103f97:	8b 00                	mov    (%eax),%eax
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	74 0d                	je     80103faa <pipealloc+0x126>
    fileclose(*f0);
80103f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa0:	8b 00                	mov    (%eax),%eax
80103fa2:	89 04 24             	mov    %eax,(%esp)
80103fa5:	e8 7a d2 ff ff       	call   80101224 <fileclose>
  if(*f1)
80103faa:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fad:	8b 00                	mov    (%eax),%eax
80103faf:	85 c0                	test   %eax,%eax
80103fb1:	74 0d                	je     80103fc0 <pipealloc+0x13c>
    fileclose(*f1);
80103fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fb6:	8b 00                	mov    (%eax),%eax
80103fb8:	89 04 24             	mov    %eax,(%esp)
80103fbb:	e8 64 d2 ff ff       	call   80101224 <fileclose>
  return -1;
80103fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fc5:	c9                   	leave  
80103fc6:	c3                   	ret    

80103fc7 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103fc7:	55                   	push   %ebp
80103fc8:	89 e5                	mov    %esp,%ebp
80103fca:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd0:	89 04 24             	mov    %eax,(%esp)
80103fd3:	e8 67 0f 00 00       	call   80104f3f <acquire>
  if(writable){
80103fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103fdc:	74 1f                	je     80103ffd <pipeclose+0x36>
    p->writeopen = 0;
80103fde:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe1:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103fe8:	00 00 00 
    wakeup(&p->nread);
80103feb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fee:	05 34 02 00 00       	add    $0x234,%eax
80103ff3:	89 04 24             	mov    %eax,(%esp)
80103ff6:	e8 49 0c 00 00       	call   80104c44 <wakeup>
80103ffb:	eb 1d                	jmp    8010401a <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80104000:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104007:	00 00 00 
    wakeup(&p->nwrite);
8010400a:	8b 45 08             	mov    0x8(%ebp),%eax
8010400d:	05 38 02 00 00       	add    $0x238,%eax
80104012:	89 04 24             	mov    %eax,(%esp)
80104015:	e8 2a 0c 00 00       	call   80104c44 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010401a:	8b 45 08             	mov    0x8(%ebp),%eax
8010401d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104023:	85 c0                	test   %eax,%eax
80104025:	75 25                	jne    8010404c <pipeclose+0x85>
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104030:	85 c0                	test   %eax,%eax
80104032:	75 18                	jne    8010404c <pipeclose+0x85>
    release(&p->lock);
80104034:	8b 45 08             	mov    0x8(%ebp),%eax
80104037:	89 04 24             	mov    %eax,(%esp)
8010403a:	e8 6a 0f 00 00       	call   80104fa9 <release>
    kfree((char*)p);
8010403f:	8b 45 08             	mov    0x8(%ebp),%eax
80104042:	89 04 24             	mov    %eax,(%esp)
80104045:	e8 8f ec ff ff       	call   80102cd9 <kfree>
8010404a:	eb 0b                	jmp    80104057 <pipeclose+0x90>
  } else
    release(&p->lock);
8010404c:	8b 45 08             	mov    0x8(%ebp),%eax
8010404f:	89 04 24             	mov    %eax,(%esp)
80104052:	e8 52 0f 00 00       	call   80104fa9 <release>
}
80104057:	c9                   	leave  
80104058:	c3                   	ret    

80104059 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104059:	55                   	push   %ebp
8010405a:	89 e5                	mov    %esp,%ebp
8010405c:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
8010405f:	8b 45 08             	mov    0x8(%ebp),%eax
80104062:	89 04 24             	mov    %eax,(%esp)
80104065:	e8 d5 0e 00 00       	call   80104f3f <acquire>
  for(i = 0; i < n; i++){
8010406a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104071:	e9 a3 00 00 00       	jmp    80104119 <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104076:	eb 56                	jmp    801040ce <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80104078:	8b 45 08             	mov    0x8(%ebp),%eax
8010407b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104081:	85 c0                	test   %eax,%eax
80104083:	74 0c                	je     80104091 <pipewrite+0x38>
80104085:	e8 a5 02 00 00       	call   8010432f <myproc>
8010408a:	8b 40 24             	mov    0x24(%eax),%eax
8010408d:	85 c0                	test   %eax,%eax
8010408f:	74 15                	je     801040a6 <pipewrite+0x4d>
        release(&p->lock);
80104091:	8b 45 08             	mov    0x8(%ebp),%eax
80104094:	89 04 24             	mov    %eax,(%esp)
80104097:	e8 0d 0f 00 00       	call   80104fa9 <release>
        return -1;
8010409c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040a1:	e9 9d 00 00 00       	jmp    80104143 <pipewrite+0xea>
      }
      wakeup(&p->nread);
801040a6:	8b 45 08             	mov    0x8(%ebp),%eax
801040a9:	05 34 02 00 00       	add    $0x234,%eax
801040ae:	89 04 24             	mov    %eax,(%esp)
801040b1:	e8 8e 0b 00 00       	call   80104c44 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801040b6:	8b 45 08             	mov    0x8(%ebp),%eax
801040b9:	8b 55 08             	mov    0x8(%ebp),%edx
801040bc:	81 c2 38 02 00 00    	add    $0x238,%edx
801040c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801040c6:	89 14 24             	mov    %edx,(%esp)
801040c9:	e8 a2 0a 00 00       	call   80104b70 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040ce:	8b 45 08             	mov    0x8(%ebp),%eax
801040d1:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801040d7:	8b 45 08             	mov    0x8(%ebp),%eax
801040da:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801040e0:	05 00 02 00 00       	add    $0x200,%eax
801040e5:	39 c2                	cmp    %eax,%edx
801040e7:	74 8f                	je     80104078 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040e9:	8b 45 08             	mov    0x8(%ebp),%eax
801040ec:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040f2:	8d 48 01             	lea    0x1(%eax),%ecx
801040f5:	8b 55 08             	mov    0x8(%ebp),%edx
801040f8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801040fe:	25 ff 01 00 00       	and    $0x1ff,%eax
80104103:	89 c1                	mov    %eax,%ecx
80104105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104108:	8b 45 0c             	mov    0xc(%ebp),%eax
8010410b:	01 d0                	add    %edx,%eax
8010410d:	8a 10                	mov    (%eax),%dl
8010410f:	8b 45 08             	mov    0x8(%ebp),%eax
80104112:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104116:	ff 45 f4             	incl   -0xc(%ebp)
80104119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010411f:	0f 8c 51 ff ff ff    	jl     80104076 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104125:	8b 45 08             	mov    0x8(%ebp),%eax
80104128:	05 34 02 00 00       	add    $0x234,%eax
8010412d:	89 04 24             	mov    %eax,(%esp)
80104130:	e8 0f 0b 00 00       	call   80104c44 <wakeup>
  release(&p->lock);
80104135:	8b 45 08             	mov    0x8(%ebp),%eax
80104138:	89 04 24             	mov    %eax,(%esp)
8010413b:	e8 69 0e 00 00       	call   80104fa9 <release>
  return n;
80104140:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104143:	c9                   	leave  
80104144:	c3                   	ret    

80104145 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104145:	55                   	push   %ebp
80104146:	89 e5                	mov    %esp,%ebp
80104148:	53                   	push   %ebx
80104149:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
8010414c:	8b 45 08             	mov    0x8(%ebp),%eax
8010414f:	89 04 24             	mov    %eax,(%esp)
80104152:	e8 e8 0d 00 00       	call   80104f3f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104157:	eb 39                	jmp    80104192 <piperead+0x4d>
    if(myproc()->killed){
80104159:	e8 d1 01 00 00       	call   8010432f <myproc>
8010415e:	8b 40 24             	mov    0x24(%eax),%eax
80104161:	85 c0                	test   %eax,%eax
80104163:	74 15                	je     8010417a <piperead+0x35>
      release(&p->lock);
80104165:	8b 45 08             	mov    0x8(%ebp),%eax
80104168:	89 04 24             	mov    %eax,(%esp)
8010416b:	e8 39 0e 00 00       	call   80104fa9 <release>
      return -1;
80104170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104175:	e9 b3 00 00 00       	jmp    8010422d <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010417a:	8b 45 08             	mov    0x8(%ebp),%eax
8010417d:	8b 55 08             	mov    0x8(%ebp),%edx
80104180:	81 c2 34 02 00 00    	add    $0x234,%edx
80104186:	89 44 24 04          	mov    %eax,0x4(%esp)
8010418a:	89 14 24             	mov    %edx,(%esp)
8010418d:	e8 de 09 00 00       	call   80104b70 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104192:	8b 45 08             	mov    0x8(%ebp),%eax
80104195:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010419b:	8b 45 08             	mov    0x8(%ebp),%eax
8010419e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041a4:	39 c2                	cmp    %eax,%edx
801041a6:	75 0d                	jne    801041b5 <piperead+0x70>
801041a8:	8b 45 08             	mov    0x8(%ebp),%eax
801041ab:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041b1:	85 c0                	test   %eax,%eax
801041b3:	75 a4                	jne    80104159 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041bc:	eb 49                	jmp    80104207 <piperead+0xc2>
    if(p->nread == p->nwrite)
801041be:	8b 45 08             	mov    0x8(%ebp),%eax
801041c1:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041d0:	39 c2                	cmp    %eax,%edx
801041d2:	75 02                	jne    801041d6 <piperead+0x91>
      break;
801041d4:	eb 39                	jmp    8010420f <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801041d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801041dc:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801041df:	8b 45 08             	mov    0x8(%ebp),%eax
801041e2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041e8:	8d 48 01             	lea    0x1(%eax),%ecx
801041eb:	8b 55 08             	mov    0x8(%ebp),%edx
801041ee:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801041f4:	25 ff 01 00 00       	and    $0x1ff,%eax
801041f9:	89 c2                	mov    %eax,%edx
801041fb:	8b 45 08             	mov    0x8(%ebp),%eax
801041fe:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
80104202:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104204:	ff 45 f4             	incl   -0xc(%ebp)
80104207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010420d:	7c af                	jl     801041be <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010420f:	8b 45 08             	mov    0x8(%ebp),%eax
80104212:	05 38 02 00 00       	add    $0x238,%eax
80104217:	89 04 24             	mov    %eax,(%esp)
8010421a:	e8 25 0a 00 00       	call   80104c44 <wakeup>
  release(&p->lock);
8010421f:	8b 45 08             	mov    0x8(%ebp),%eax
80104222:	89 04 24             	mov    %eax,(%esp)
80104225:	e8 7f 0d 00 00       	call   80104fa9 <release>
  return i;
8010422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010422d:	83 c4 24             	add    $0x24,%esp
80104230:	5b                   	pop    %ebx
80104231:	5d                   	pop    %ebp
80104232:	c3                   	ret    
	...

80104234 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010423a:	9c                   	pushf  
8010423b:	58                   	pop    %eax
8010423c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010423f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104242:	c9                   	leave  
80104243:	c3                   	ret    

80104244 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104247:	fb                   	sti    
}
80104248:	5d                   	pop    %ebp
80104249:	c3                   	ret    

8010424a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010424a:	55                   	push   %ebp
8010424b:	89 e5                	mov    %esp,%ebp
8010424d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104250:	c7 44 24 04 f8 93 10 	movl   $0x801093f8,0x4(%esp)
80104257:	80 
80104258:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
8010425f:	e8 ba 0c 00 00       	call   80104f1e <initlock>
}
80104264:	c9                   	leave  
80104265:	c3                   	ret    

80104266 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104266:	55                   	push   %ebp
80104267:	89 e5                	mov    %esp,%ebp
80104269:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010426c:	e8 3a 00 00 00       	call   801042ab <mycpu>
80104271:	89 c2                	mov    %eax,%edx
80104273:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80104278:	29 c2                	sub    %eax,%edx
8010427a:	89 d0                	mov    %edx,%eax
8010427c:	c1 f8 04             	sar    $0x4,%eax
8010427f:	89 c1                	mov    %eax,%ecx
80104281:	89 ca                	mov    %ecx,%edx
80104283:	c1 e2 03             	shl    $0x3,%edx
80104286:	01 ca                	add    %ecx,%edx
80104288:	89 d0                	mov    %edx,%eax
8010428a:	c1 e0 05             	shl    $0x5,%eax
8010428d:	29 d0                	sub    %edx,%eax
8010428f:	c1 e0 02             	shl    $0x2,%eax
80104292:	01 c8                	add    %ecx,%eax
80104294:	c1 e0 03             	shl    $0x3,%eax
80104297:	01 c8                	add    %ecx,%eax
80104299:	89 c2                	mov    %eax,%edx
8010429b:	c1 e2 0f             	shl    $0xf,%edx
8010429e:	29 c2                	sub    %eax,%edx
801042a0:	c1 e2 02             	shl    $0x2,%edx
801042a3:	01 ca                	add    %ecx,%edx
801042a5:	89 d0                	mov    %edx,%eax
801042a7:	f7 d8                	neg    %eax
}
801042a9:	c9                   	leave  
801042aa:	c3                   	ret    

801042ab <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801042ab:	55                   	push   %ebp
801042ac:	89 e5                	mov    %esp,%ebp
801042ae:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801042b1:	e8 7e ff ff ff       	call   80104234 <readeflags>
801042b6:	25 00 02 00 00       	and    $0x200,%eax
801042bb:	85 c0                	test   %eax,%eax
801042bd:	74 0c                	je     801042cb <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
801042bf:	c7 04 24 00 94 10 80 	movl   $0x80109400,(%esp)
801042c6:	e8 b7 c2 ff ff       	call   80100582 <panic>
  
  apicid = lapicid();
801042cb:	e8 1d ee ff ff       	call   801030ed <lapicid>
801042d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801042d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042da:	eb 3b                	jmp    80104317 <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
801042dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042df:	89 d0                	mov    %edx,%eax
801042e1:	c1 e0 02             	shl    $0x2,%eax
801042e4:	01 d0                	add    %edx,%eax
801042e6:	01 c0                	add    %eax,%eax
801042e8:	01 d0                	add    %edx,%eax
801042ea:	c1 e0 04             	shl    $0x4,%eax
801042ed:	05 c0 4c 11 80       	add    $0x80114cc0,%eax
801042f2:	8a 00                	mov    (%eax),%al
801042f4:	0f b6 c0             	movzbl %al,%eax
801042f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801042fa:	75 18                	jne    80104314 <mycpu+0x69>
      return &cpus[i];
801042fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ff:	89 d0                	mov    %edx,%eax
80104301:	c1 e0 02             	shl    $0x2,%eax
80104304:	01 d0                	add    %edx,%eax
80104306:	01 c0                	add    %eax,%eax
80104308:	01 d0                	add    %edx,%eax
8010430a:	c1 e0 04             	shl    $0x4,%eax
8010430d:	05 c0 4c 11 80       	add    $0x80114cc0,%eax
80104312:	eb 19                	jmp    8010432d <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104314:	ff 45 f4             	incl   -0xc(%ebp)
80104317:	a1 40 52 11 80       	mov    0x80115240,%eax
8010431c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010431f:	7c bb                	jl     801042dc <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80104321:	c7 04 24 26 94 10 80 	movl   $0x80109426,(%esp)
80104328:	e8 55 c2 ff ff       	call   80100582 <panic>
}
8010432d:	c9                   	leave  
8010432e:	c3                   	ret    

8010432f <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010432f:	55                   	push   %ebp
80104330:	89 e5                	mov    %esp,%ebp
80104332:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104335:	e8 64 0d 00 00       	call   8010509e <pushcli>
  c = mycpu();
8010433a:	e8 6c ff ff ff       	call   801042ab <mycpu>
8010433f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80104342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104345:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010434b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
8010434e:	e8 95 0d 00 00       	call   801050e8 <popcli>
  return p;
80104353:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104356:	c9                   	leave  
80104357:	c3                   	ret    

80104358 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104358:	55                   	push   %ebp
80104359:	89 e5                	mov    %esp,%ebp
8010435b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010435e:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104365:	e8 d5 0b 00 00       	call   80104f3f <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436a:	c7 45 f4 94 52 11 80 	movl   $0x80115294,-0xc(%ebp)
80104371:	eb 50                	jmp    801043c3 <allocproc+0x6b>
    if(p->state == UNUSED)
80104373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104376:	8b 40 0c             	mov    0xc(%eax),%eax
80104379:	85 c0                	test   %eax,%eax
8010437b:	75 42                	jne    801043bf <allocproc+0x67>
      goto found;
8010437d:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104381:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104388:	a1 00 c0 10 80       	mov    0x8010c000,%eax
8010438d:	8d 50 01             	lea    0x1(%eax),%edx
80104390:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
80104396:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104399:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
8010439c:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
801043a3:	e8 01 0c 00 00       	call   80104fa9 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801043a8:	e8 c2 e9 ff ff       	call   80102d6f <kalloc>
801043ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043b0:	89 42 08             	mov    %eax,0x8(%edx)
801043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b6:	8b 40 08             	mov    0x8(%eax),%eax
801043b9:	85 c0                	test   %eax,%eax
801043bb:	75 33                	jne    801043f0 <allocproc+0x98>
801043bd:	eb 20                	jmp    801043df <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043bf:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801043c3:	81 7d f4 94 71 11 80 	cmpl   $0x80117194,-0xc(%ebp)
801043ca:	72 a7                	jb     80104373 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801043cc:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
801043d3:	e8 d1 0b 00 00       	call   80104fa9 <release>
  return 0;
801043d8:	b8 00 00 00 00       	mov    $0x0,%eax
801043dd:	eb 76                	jmp    80104455 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801043e9:	b8 00 00 00 00       	mov    $0x0,%eax
801043ee:	eb 65                	jmp    80104455 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f3:	8b 40 08             	mov    0x8(%eax),%eax
801043f6:	05 00 10 00 00       	add    $0x1000,%eax
801043fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801043fe:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104405:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104408:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010440b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010440f:	ba 90 6d 10 80       	mov    $0x80106d90,%edx
80104414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104417:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104419:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104420:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104423:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104429:	8b 40 1c             	mov    0x1c(%eax),%eax
8010442c:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104433:	00 
80104434:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010443b:	00 
8010443c:	89 04 24             	mov    %eax,(%esp)
8010443f:	e8 5e 0d 00 00       	call   801051a2 <memset>
  p->context->eip = (uint)forkret;
80104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104447:	8b 40 1c             	mov    0x1c(%eax),%eax
8010444a:	ba 31 4b 10 80       	mov    $0x80104b31,%edx
8010444f:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104452:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104455:	c9                   	leave  
80104456:	c3                   	ret    

80104457 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104457:	55                   	push   %ebp
80104458:	89 e5                	mov    %esp,%ebp
8010445a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
8010445d:	e8 f6 fe ff ff       	call   80104358 <allocproc>
80104462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104468:	a3 80 c6 10 80       	mov    %eax,0x8010c680
  if((p->pgdir = setupkvm()) == 0)
8010446d:	e8 5c 3e 00 00       	call   801082ce <setupkvm>
80104472:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104475:	89 42 04             	mov    %eax,0x4(%edx)
80104478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447b:	8b 40 04             	mov    0x4(%eax),%eax
8010447e:	85 c0                	test   %eax,%eax
80104480:	75 0c                	jne    8010448e <userinit+0x37>
    panic("userinit: out of memory?");
80104482:	c7 04 24 36 94 10 80 	movl   $0x80109436,(%esp)
80104489:	e8 f4 c0 ff ff       	call   80100582 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010448e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104496:	8b 40 04             	mov    0x4(%eax),%eax
80104499:	89 54 24 08          	mov    %edx,0x8(%esp)
8010449d:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
801044a4:	80 
801044a5:	89 04 24             	mov    %eax,(%esp)
801044a8:	e8 82 40 00 00       	call   8010852f <inituvm>
  p->sz = PGSIZE;
801044ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b0:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801044b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b9:	8b 40 18             	mov    0x18(%eax),%eax
801044bc:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801044c3:	00 
801044c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044cb:	00 
801044cc:	89 04 24             	mov    %eax,(%esp)
801044cf:	e8 ce 0c 00 00       	call   801051a2 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d7:	8b 40 18             	mov    0x18(%eax),%eax
801044da:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e3:	8b 40 18             	mov    0x18(%eax),%eax
801044e6:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ef:	8b 50 18             	mov    0x18(%eax),%edx
801044f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f5:	8b 40 18             	mov    0x18(%eax),%eax
801044f8:	8b 40 2c             	mov    0x2c(%eax),%eax
801044fb:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104502:	8b 50 18             	mov    0x18(%eax),%edx
80104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104508:	8b 40 18             	mov    0x18(%eax),%eax
8010450b:	8b 40 2c             	mov    0x2c(%eax),%eax
8010450e:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
80104512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104515:	8b 40 18             	mov    0x18(%eax),%eax
80104518:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010451f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104522:	8b 40 18             	mov    0x18(%eax),%eax
80104525:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452f:	8b 40 18             	mov    0x18(%eax),%eax
80104532:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453c:	83 c0 6c             	add    $0x6c,%eax
8010453f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104546:	00 
80104547:	c7 44 24 04 4f 94 10 	movl   $0x8010944f,0x4(%esp)
8010454e:	80 
8010454f:	89 04 24             	mov    %eax,(%esp)
80104552:	e8 57 0e 00 00       	call   801053ae <safestrcpy>
  p->cwd = namei("/");
80104557:	c7 04 24 58 94 10 80 	movl   $0x80109458,(%esp)
8010455e:	e8 00 e1 ff ff       	call   80102663 <namei>
80104563:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104566:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104569:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104570:	e8 ca 09 00 00       	call   80104f3f <acquire>

  p->state = RUNNABLE;
80104575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104578:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010457f:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104586:	e8 1e 0a 00 00       	call   80104fa9 <release>
}
8010458b:	c9                   	leave  
8010458c:	c3                   	ret    

8010458d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010458d:	55                   	push   %ebp
8010458e:	89 e5                	mov    %esp,%ebp
80104590:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
80104593:	e8 97 fd ff ff       	call   8010432f <myproc>
80104598:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
8010459b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010459e:	8b 00                	mov    (%eax),%eax
801045a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045a7:	7e 31                	jle    801045da <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045a9:	8b 55 08             	mov    0x8(%ebp),%edx
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	01 c2                	add    %eax,%edx
801045b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045b4:	8b 40 04             	mov    0x4(%eax),%eax
801045b7:	89 54 24 08          	mov    %edx,0x8(%esp)
801045bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045be:	89 54 24 04          	mov    %edx,0x4(%esp)
801045c2:	89 04 24             	mov    %eax,(%esp)
801045c5:	e8 d0 40 00 00       	call   8010869a <allocuvm>
801045ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045d1:	75 3e                	jne    80104611 <growproc+0x84>
      return -1;
801045d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d8:	eb 4f                	jmp    80104629 <growproc+0x9c>
  } else if(n < 0){
801045da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045de:	79 31                	jns    80104611 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045e0:	8b 55 08             	mov    0x8(%ebp),%edx
801045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e6:	01 c2                	add    %eax,%edx
801045e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045eb:	8b 40 04             	mov    0x4(%eax),%eax
801045ee:	89 54 24 08          	mov    %edx,0x8(%esp)
801045f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801045f9:	89 04 24             	mov    %eax,(%esp)
801045fc:	e8 af 41 00 00       	call   801087b0 <deallocuvm>
80104601:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104608:	75 07                	jne    80104611 <growproc+0x84>
      return -1;
8010460a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010460f:	eb 18                	jmp    80104629 <growproc+0x9c>
  }
  curproc->sz = sz;
80104611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104614:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104617:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010461c:	89 04 24             	mov    %eax,(%esp)
8010461f:	e8 84 3d 00 00       	call   801083a8 <switchuvm>
  return 0;
80104624:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104629:	c9                   	leave  
8010462a:	c3                   	ret    

8010462b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010462b:	55                   	push   %ebp
8010462c:	89 e5                	mov    %esp,%ebp
8010462e:	57                   	push   %edi
8010462f:	56                   	push   %esi
80104630:	53                   	push   %ebx
80104631:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104634:	e8 f6 fc ff ff       	call   8010432f <myproc>
80104639:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
8010463c:	e8 17 fd ff ff       	call   80104358 <allocproc>
80104641:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104644:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104648:	75 0a                	jne    80104654 <fork+0x29>
    return -1;
8010464a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010464f:	e9 35 01 00 00       	jmp    80104789 <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104654:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104657:	8b 10                	mov    (%eax),%edx
80104659:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010465c:	8b 40 04             	mov    0x4(%eax),%eax
8010465f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104663:	89 04 24             	mov    %eax,(%esp)
80104666:	e8 e5 42 00 00       	call   80108950 <copyuvm>
8010466b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010466e:	89 42 04             	mov    %eax,0x4(%edx)
80104671:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104674:	8b 40 04             	mov    0x4(%eax),%eax
80104677:	85 c0                	test   %eax,%eax
80104679:	75 2c                	jne    801046a7 <fork+0x7c>
    kfree(np->kstack);
8010467b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010467e:	8b 40 08             	mov    0x8(%eax),%eax
80104681:	89 04 24             	mov    %eax,(%esp)
80104684:	e8 50 e6 ff ff       	call   80102cd9 <kfree>
    np->kstack = 0;
80104689:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010468c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104693:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104696:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010469d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a2:	e9 e2 00 00 00       	jmp    80104789 <fork+0x15e>
  }
  np->sz = curproc->sz;
801046a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046aa:	8b 10                	mov    (%eax),%edx
801046ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046af:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801046b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801046b7:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801046ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046bd:	8b 50 18             	mov    0x18(%eax),%edx
801046c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046c3:	8b 40 18             	mov    0x18(%eax),%eax
801046c6:	89 c3                	mov    %eax,%ebx
801046c8:	b8 13 00 00 00       	mov    $0x13,%eax
801046cd:	89 d7                	mov    %edx,%edi
801046cf:	89 de                	mov    %ebx,%esi
801046d1:	89 c1                	mov    %eax,%ecx
801046d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801046d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046d8:	8b 40 18             	mov    0x18(%eax),%eax
801046db:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801046e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801046e9:	eb 36                	jmp    80104721 <fork+0xf6>
    if(curproc->ofile[i])
801046eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046f1:	83 c2 08             	add    $0x8,%edx
801046f4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046f8:	85 c0                	test   %eax,%eax
801046fa:	74 22                	je     8010471e <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104702:	83 c2 08             	add    $0x8,%edx
80104705:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104709:	89 04 24             	mov    %eax,(%esp)
8010470c:	e8 cb ca ff ff       	call   801011dc <filedup>
80104711:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104714:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104717:	83 c1 08             	add    $0x8,%ecx
8010471a:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010471e:	ff 45 e4             	incl   -0x1c(%ebp)
80104721:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104725:	7e c4                	jle    801046eb <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80104727:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472a:	8b 40 68             	mov    0x68(%eax),%eax
8010472d:	89 04 24             	mov    %eax,(%esp)
80104730:	e8 d7 d3 ff ff       	call   80101b0c <idup>
80104735:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104738:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010473b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104741:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104744:	83 c0 6c             	add    $0x6c,%eax
80104747:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010474e:	00 
8010474f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104753:	89 04 24             	mov    %eax,(%esp)
80104756:	e8 53 0c 00 00       	call   801053ae <safestrcpy>

  pid = np->pid;
8010475b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010475e:	8b 40 10             	mov    0x10(%eax),%eax
80104761:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104764:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
8010476b:	e8 cf 07 00 00       	call   80104f3f <acquire>

  np->state = RUNNABLE;
80104770:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104773:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010477a:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104781:	e8 23 08 00 00       	call   80104fa9 <release>

  return pid;
80104786:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104789:	83 c4 2c             	add    $0x2c,%esp
8010478c:	5b                   	pop    %ebx
8010478d:	5e                   	pop    %esi
8010478e:	5f                   	pop    %edi
8010478f:	5d                   	pop    %ebp
80104790:	c3                   	ret    

80104791 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104791:	55                   	push   %ebp
80104792:	89 e5                	mov    %esp,%ebp
80104794:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104797:	e8 93 fb ff ff       	call   8010432f <myproc>
8010479c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010479f:	a1 80 c6 10 80       	mov    0x8010c680,%eax
801047a4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801047a7:	75 0c                	jne    801047b5 <exit+0x24>
    panic("init exiting");
801047a9:	c7 04 24 5a 94 10 80 	movl   $0x8010945a,(%esp)
801047b0:	e8 cd bd ff ff       	call   80100582 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801047bc:	eb 3a                	jmp    801047f8 <exit+0x67>
    if(curproc->ofile[fd]){
801047be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047c4:	83 c2 08             	add    $0x8,%edx
801047c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047cb:	85 c0                	test   %eax,%eax
801047cd:	74 26                	je     801047f5 <exit+0x64>
      fileclose(curproc->ofile[fd]);
801047cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047d5:	83 c2 08             	add    $0x8,%edx
801047d8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047dc:	89 04 24             	mov    %eax,(%esp)
801047df:	e8 40 ca ff ff       	call   80101224 <fileclose>
      curproc->ofile[fd] = 0;
801047e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047ea:	83 c2 08             	add    $0x8,%edx
801047ed:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801047f4:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047f5:	ff 45 f0             	incl   -0x10(%ebp)
801047f8:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801047fc:	7e c0                	jle    801047be <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801047fe:	e8 34 ee ff ff       	call   80103637 <begin_op>
  iput(curproc->cwd);
80104803:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104806:	8b 40 68             	mov    0x68(%eax),%eax
80104809:	89 04 24             	mov    %eax,(%esp)
8010480c:	e8 7b d4 ff ff       	call   80101c8c <iput>
  end_op();
80104811:	e8 a3 ee ff ff       	call   801036b9 <end_op>
  curproc->cwd = 0;
80104816:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104819:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104820:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104827:	e8 13 07 00 00       	call   80104f3f <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010482c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010482f:	8b 40 14             	mov    0x14(%eax),%eax
80104832:	89 04 24             	mov    %eax,(%esp)
80104835:	e8 cc 03 00 00       	call   80104c06 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010483a:	c7 45 f4 94 52 11 80 	movl   $0x80115294,-0xc(%ebp)
80104841:	eb 33                	jmp    80104876 <exit+0xe5>
    if(p->parent == curproc){
80104843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104846:	8b 40 14             	mov    0x14(%eax),%eax
80104849:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010484c:	75 24                	jne    80104872 <exit+0xe1>
      p->parent = initproc;
8010484e:	8b 15 80 c6 10 80    	mov    0x8010c680,%edx
80104854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104857:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010485a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485d:	8b 40 0c             	mov    0xc(%eax),%eax
80104860:	83 f8 05             	cmp    $0x5,%eax
80104863:	75 0d                	jne    80104872 <exit+0xe1>
        wakeup1(initproc);
80104865:	a1 80 c6 10 80       	mov    0x8010c680,%eax
8010486a:	89 04 24             	mov    %eax,(%esp)
8010486d:	e8 94 03 00 00       	call   80104c06 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104872:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104876:	81 7d f4 94 71 11 80 	cmpl   $0x80117194,-0xc(%ebp)
8010487d:	72 c4                	jb     80104843 <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010487f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104882:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104889:	e8 c3 01 00 00       	call   80104a51 <sched>
  panic("zombie exit");
8010488e:	c7 04 24 67 94 10 80 	movl   $0x80109467,(%esp)
80104895:	e8 e8 bc ff ff       	call   80100582 <panic>

8010489a <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010489a:	55                   	push   %ebp
8010489b:	89 e5                	mov    %esp,%ebp
8010489d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801048a0:	e8 8a fa ff ff       	call   8010432f <myproc>
801048a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801048a8:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
801048af:	e8 8b 06 00 00       	call   80104f3f <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801048b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048bb:	c7 45 f4 94 52 11 80 	movl   $0x80115294,-0xc(%ebp)
801048c2:	e9 95 00 00 00       	jmp    8010495c <wait+0xc2>
      if(p->parent != curproc)
801048c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ca:	8b 40 14             	mov    0x14(%eax),%eax
801048cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801048d0:	74 05                	je     801048d7 <wait+0x3d>
        continue;
801048d2:	e9 81 00 00 00       	jmp    80104958 <wait+0xbe>
      havekids = 1;
801048d7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801048de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e1:	8b 40 0c             	mov    0xc(%eax),%eax
801048e4:	83 f8 05             	cmp    $0x5,%eax
801048e7:	75 6f                	jne    80104958 <wait+0xbe>
        // Found one.
        pid = p->pid;
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ec:	8b 40 10             	mov    0x10(%eax),%eax
801048ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801048f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f5:	8b 40 08             	mov    0x8(%eax),%eax
801048f8:	89 04 24             	mov    %eax,(%esp)
801048fb:	e8 d9 e3 ff ff       	call   80102cd9 <kfree>
        p->kstack = 0;
80104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104903:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010490a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490d:	8b 40 04             	mov    0x4(%eax),%eax
80104910:	89 04 24             	mov    %eax,(%esp)
80104913:	e8 5c 3f 00 00       	call   80108874 <freevm>
        p->pid = 0;
80104918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104925:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010492c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104940:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104947:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
8010494e:	e8 56 06 00 00       	call   80104fa9 <release>
        return pid;
80104953:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104956:	eb 4c                	jmp    801049a4 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104958:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010495c:	81 7d f4 94 71 11 80 	cmpl   $0x80117194,-0xc(%ebp)
80104963:	0f 82 5e ff ff ff    	jb     801048c7 <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010496d:	74 0a                	je     80104979 <wait+0xdf>
8010496f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104972:	8b 40 24             	mov    0x24(%eax),%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	74 13                	je     8010498c <wait+0xf2>
      release(&ptable.lock);
80104979:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104980:	e8 24 06 00 00       	call   80104fa9 <release>
      return -1;
80104985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010498a:	eb 18                	jmp    801049a4 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010498c:	c7 44 24 04 60 52 11 	movl   $0x80115260,0x4(%esp)
80104993:	80 
80104994:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104997:	89 04 24             	mov    %eax,(%esp)
8010499a:	e8 d1 01 00 00       	call   80104b70 <sleep>
  }
8010499f:	e9 10 ff ff ff       	jmp    801048b4 <wait+0x1a>
}
801049a4:	c9                   	leave  
801049a5:	c3                   	ret    

801049a6 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801049a6:	55                   	push   %ebp
801049a7:	89 e5                	mov    %esp,%ebp
801049a9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801049ac:	e8 fa f8 ff ff       	call   801042ab <mycpu>
801049b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801049b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049b7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801049be:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801049c1:	e8 7e f8 ff ff       	call   80104244 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801049c6:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
801049cd:	e8 6d 05 00 00       	call   80104f3f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049d2:	c7 45 f4 94 52 11 80 	movl   $0x80115294,-0xc(%ebp)
801049d9:	eb 5c                	jmp    80104a37 <scheduler+0x91>
      if(p->state != RUNNABLE)
801049db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049de:	8b 40 0c             	mov    0xc(%eax),%eax
801049e1:	83 f8 03             	cmp    $0x3,%eax
801049e4:	74 02                	je     801049e8 <scheduler+0x42>
        continue;
801049e6:	eb 4b                	jmp    80104a33 <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801049e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049ee:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801049f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f7:	89 04 24             	mov    %eax,(%esp)
801049fa:	e8 a9 39 00 00       	call   801083a8 <switchuvm>
      p->state = RUNNING;
801049ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a02:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a12:	83 c2 04             	add    $0x4,%edx
80104a15:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a19:	89 14 24             	mov    %edx,(%esp)
80104a1c:	e8 53 0b 00 00       	call   80105574 <swtch>
      switchkvm();
80104a21:	e8 68 39 00 00       	call   8010838e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a29:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a30:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a33:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a37:	81 7d f4 94 71 11 80 	cmpl   $0x80117194,-0xc(%ebp)
80104a3e:	72 9b                	jb     801049db <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104a40:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104a47:	e8 5d 05 00 00       	call   80104fa9 <release>

  }
80104a4c:	e9 70 ff ff ff       	jmp    801049c1 <scheduler+0x1b>

80104a51 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104a51:	55                   	push   %ebp
80104a52:	89 e5                	mov    %esp,%ebp
80104a54:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104a57:	e8 d3 f8 ff ff       	call   8010432f <myproc>
80104a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104a5f:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104a66:	e8 02 06 00 00       	call   8010506d <holding>
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	75 0c                	jne    80104a7b <sched+0x2a>
    panic("sched ptable.lock");
80104a6f:	c7 04 24 73 94 10 80 	movl   $0x80109473,(%esp)
80104a76:	e8 07 bb ff ff       	call   80100582 <panic>
  if(mycpu()->ncli != 1)
80104a7b:	e8 2b f8 ff ff       	call   801042ab <mycpu>
80104a80:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a86:	83 f8 01             	cmp    $0x1,%eax
80104a89:	74 0c                	je     80104a97 <sched+0x46>
    panic("sched locks");
80104a8b:	c7 04 24 85 94 10 80 	movl   $0x80109485,(%esp)
80104a92:	e8 eb ba ff ff       	call   80100582 <panic>
  if(p->state == RUNNING)
80104a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9a:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9d:	83 f8 04             	cmp    $0x4,%eax
80104aa0:	75 0c                	jne    80104aae <sched+0x5d>
    panic("sched running");
80104aa2:	c7 04 24 91 94 10 80 	movl   $0x80109491,(%esp)
80104aa9:	e8 d4 ba ff ff       	call   80100582 <panic>
  if(readeflags()&FL_IF)
80104aae:	e8 81 f7 ff ff       	call   80104234 <readeflags>
80104ab3:	25 00 02 00 00       	and    $0x200,%eax
80104ab8:	85 c0                	test   %eax,%eax
80104aba:	74 0c                	je     80104ac8 <sched+0x77>
    panic("sched interruptible");
80104abc:	c7 04 24 9f 94 10 80 	movl   $0x8010949f,(%esp)
80104ac3:	e8 ba ba ff ff       	call   80100582 <panic>
  intena = mycpu()->intena;
80104ac8:	e8 de f7 ff ff       	call   801042ab <mycpu>
80104acd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104ad6:	e8 d0 f7 ff ff       	call   801042ab <mycpu>
80104adb:	8b 40 04             	mov    0x4(%eax),%eax
80104ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ae1:	83 c2 1c             	add    $0x1c,%edx
80104ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae8:	89 14 24             	mov    %edx,(%esp)
80104aeb:	e8 84 0a 00 00       	call   80105574 <swtch>
  mycpu()->intena = intena;
80104af0:	e8 b6 f7 ff ff       	call   801042ab <mycpu>
80104af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104af8:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104afe:	c9                   	leave  
80104aff:	c3                   	ret    

80104b00 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104b06:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104b0d:	e8 2d 04 00 00       	call   80104f3f <acquire>
  myproc()->state = RUNNABLE;
80104b12:	e8 18 f8 ff ff       	call   8010432f <myproc>
80104b17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104b1e:	e8 2e ff ff ff       	call   80104a51 <sched>
  release(&ptable.lock);
80104b23:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104b2a:	e8 7a 04 00 00       	call   80104fa9 <release>
}
80104b2f:	c9                   	leave  
80104b30:	c3                   	ret    

80104b31 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b31:	55                   	push   %ebp
80104b32:	89 e5                	mov    %esp,%ebp
80104b34:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b37:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104b3e:	e8 66 04 00 00       	call   80104fa9 <release>

  if (first) {
80104b43:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	74 22                	je     80104b6e <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104b4c:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104b53:	00 00 00 
    iinit(ROOTDEV);
80104b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b5d:	e8 75 cc ff ff       	call   801017d7 <iinit>
    initlog(ROOTDEV);
80104b62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b69:	e8 ca e8 ff ff       	call   80103438 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b6e:	c9                   	leave  
80104b6f:	c3                   	ret    

80104b70 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104b76:	e8 b4 f7 ff ff       	call   8010432f <myproc>
80104b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104b82:	75 0c                	jne    80104b90 <sleep+0x20>
    panic("sleep");
80104b84:	c7 04 24 b3 94 10 80 	movl   $0x801094b3,(%esp)
80104b8b:	e8 f2 b9 ff ff       	call   80100582 <panic>

  if(lk == 0)
80104b90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b94:	75 0c                	jne    80104ba2 <sleep+0x32>
    panic("sleep without lk");
80104b96:	c7 04 24 b9 94 10 80 	movl   $0x801094b9,(%esp)
80104b9d:	e8 e0 b9 ff ff       	call   80100582 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ba2:	81 7d 0c 60 52 11 80 	cmpl   $0x80115260,0xc(%ebp)
80104ba9:	74 17                	je     80104bc2 <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104bab:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104bb2:	e8 88 03 00 00       	call   80104f3f <acquire>
    release(lk);
80104bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bba:	89 04 24             	mov    %eax,(%esp)
80104bbd:	e8 e7 03 00 00       	call   80104fa9 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc8:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bce:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104bd5:	e8 77 fe ff ff       	call   80104a51 <sched>

  // Tidy up.
  p->chan = 0;
80104bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdd:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104be4:	81 7d 0c 60 52 11 80 	cmpl   $0x80115260,0xc(%ebp)
80104beb:	74 17                	je     80104c04 <sleep+0x94>
    release(&ptable.lock);
80104bed:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104bf4:	e8 b0 03 00 00       	call   80104fa9 <release>
    acquire(lk);
80104bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfc:	89 04 24             	mov    %eax,(%esp)
80104bff:	e8 3b 03 00 00       	call   80104f3f <acquire>
  }
}
80104c04:	c9                   	leave  
80104c05:	c3                   	ret    

80104c06 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104c06:	55                   	push   %ebp
80104c07:	89 e5                	mov    %esp,%ebp
80104c09:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c0c:	c7 45 fc 94 52 11 80 	movl   $0x80115294,-0x4(%ebp)
80104c13:	eb 24                	jmp    80104c39 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c18:	8b 40 0c             	mov    0xc(%eax),%eax
80104c1b:	83 f8 02             	cmp    $0x2,%eax
80104c1e:	75 15                	jne    80104c35 <wakeup1+0x2f>
80104c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c23:	8b 40 20             	mov    0x20(%eax),%eax
80104c26:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c29:	75 0a                	jne    80104c35 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c2e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c35:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104c39:	81 7d fc 94 71 11 80 	cmpl   $0x80117194,-0x4(%ebp)
80104c40:	72 d3                	jb     80104c15 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104c42:	c9                   	leave  
80104c43:	c3                   	ret    

80104c44 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104c4a:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104c51:	e8 e9 02 00 00       	call   80104f3f <acquire>
  wakeup1(chan);
80104c56:	8b 45 08             	mov    0x8(%ebp),%eax
80104c59:	89 04 24             	mov    %eax,(%esp)
80104c5c:	e8 a5 ff ff ff       	call   80104c06 <wakeup1>
  release(&ptable.lock);
80104c61:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104c68:	e8 3c 03 00 00       	call   80104fa9 <release>
}
80104c6d:	c9                   	leave  
80104c6e:	c3                   	ret    

80104c6f <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c6f:	55                   	push   %ebp
80104c70:	89 e5                	mov    %esp,%ebp
80104c72:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c75:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104c7c:	e8 be 02 00 00       	call   80104f3f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c81:	c7 45 f4 94 52 11 80 	movl   $0x80115294,-0xc(%ebp)
80104c88:	eb 41                	jmp    80104ccb <kill+0x5c>
    if(p->pid == pid){
80104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8d:	8b 40 10             	mov    0x10(%eax),%eax
80104c90:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c93:	75 32                	jne    80104cc7 <kill+0x58>
      p->killed = 1;
80104c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c98:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ca5:	83 f8 02             	cmp    $0x2,%eax
80104ca8:	75 0a                	jne    80104cb4 <kill+0x45>
        p->state = RUNNABLE;
80104caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104cb4:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104cbb:	e8 e9 02 00 00       	call   80104fa9 <release>
      return 0;
80104cc0:	b8 00 00 00 00       	mov    $0x0,%eax
80104cc5:	eb 1e                	jmp    80104ce5 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc7:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ccb:	81 7d f4 94 71 11 80 	cmpl   $0x80117194,-0xc(%ebp)
80104cd2:	72 b6                	jb     80104c8a <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104cd4:	c7 04 24 60 52 11 80 	movl   $0x80115260,(%esp)
80104cdb:	e8 c9 02 00 00       	call   80104fa9 <release>
  return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    

80104ce7 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ce7:	55                   	push   %ebp
80104ce8:	89 e5                	mov    %esp,%ebp
80104cea:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ced:	c7 45 f0 94 52 11 80 	movl   $0x80115294,-0x10(%ebp)
80104cf4:	e9 d5 00 00 00       	jmp    80104dce <procdump+0xe7>
    if(p->state == UNUSED)
80104cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cfc:	8b 40 0c             	mov    0xc(%eax),%eax
80104cff:	85 c0                	test   %eax,%eax
80104d01:	75 05                	jne    80104d08 <procdump+0x21>
      continue;
80104d03:	e9 c2 00 00 00       	jmp    80104dca <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d0b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d0e:	83 f8 05             	cmp    $0x5,%eax
80104d11:	77 23                	ja     80104d36 <procdump+0x4f>
80104d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d16:	8b 40 0c             	mov    0xc(%eax),%eax
80104d19:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104d20:	85 c0                	test   %eax,%eax
80104d22:	74 12                	je     80104d36 <procdump+0x4f>
      state = states[p->state];
80104d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d27:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2a:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d34:	eb 07                	jmp    80104d3d <procdump+0x56>
    else
      state = "???";
80104d36:	c7 45 ec ca 94 10 80 	movl   $0x801094ca,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d40:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d46:	8b 40 10             	mov    0x10(%eax),%eax
80104d49:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104d4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d50:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d54:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d58:	c7 04 24 ce 94 10 80 	movl   $0x801094ce,(%esp)
80104d5f:	e8 8b b6 ff ff       	call   801003ef <cprintf>
    if(p->state == SLEEPING){
80104d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d67:	8b 40 0c             	mov    0xc(%eax),%eax
80104d6a:	83 f8 02             	cmp    $0x2,%eax
80104d6d:	75 4f                	jne    80104dbe <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d72:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d75:	8b 40 0c             	mov    0xc(%eax),%eax
80104d78:	83 c0 08             	add    $0x8,%eax
80104d7b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d82:	89 04 24             	mov    %eax,(%esp)
80104d85:	e8 6c 02 00 00       	call   80104ff6 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d91:	eb 1a                	jmp    80104dad <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d96:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d9e:	c7 04 24 d7 94 10 80 	movl   $0x801094d7,(%esp)
80104da5:	e8 45 b6 ff ff       	call   801003ef <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104daa:	ff 45 f4             	incl   -0xc(%ebp)
80104dad:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104db1:	7f 0b                	jg     80104dbe <procdump+0xd7>
80104db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	75 d5                	jne    80104d93 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104dbe:	c7 04 24 db 94 10 80 	movl   $0x801094db,(%esp)
80104dc5:	e8 25 b6 ff ff       	call   801003ef <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dca:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104dce:	81 7d f0 94 71 11 80 	cmpl   $0x80117194,-0x10(%ebp)
80104dd5:	0f 82 1e ff ff ff    	jb     80104cf9 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104ddb:	c9                   	leave  
80104ddc:	c3                   	ret    
80104ddd:	00 00                	add    %al,(%eax)
	...

80104de0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104de6:	8b 45 08             	mov    0x8(%ebp),%eax
80104de9:	83 c0 04             	add    $0x4,%eax
80104dec:	c7 44 24 04 07 95 10 	movl   $0x80109507,0x4(%esp)
80104df3:	80 
80104df4:	89 04 24             	mov    %eax,(%esp)
80104df7:	e8 22 01 00 00       	call   80104f1e <initlock>
  lk->name = name;
80104dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80104dff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e02:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104e05:	8b 45 08             	mov    0x8(%ebp),%eax
80104e08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e11:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104e18:	c9                   	leave  
80104e19:	c3                   	ret    

80104e1a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e1a:	55                   	push   %ebp
80104e1b:	89 e5                	mov    %esp,%ebp
80104e1d:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104e20:	8b 45 08             	mov    0x8(%ebp),%eax
80104e23:	83 c0 04             	add    $0x4,%eax
80104e26:	89 04 24             	mov    %eax,(%esp)
80104e29:	e8 11 01 00 00       	call   80104f3f <acquire>
  while (lk->locked) {
80104e2e:	eb 15                	jmp    80104e45 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104e30:	8b 45 08             	mov    0x8(%ebp),%eax
80104e33:	83 c0 04             	add    $0x4,%eax
80104e36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3d:	89 04 24             	mov    %eax,(%esp)
80104e40:	e8 2b fd ff ff       	call   80104b70 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104e45:	8b 45 08             	mov    0x8(%ebp),%eax
80104e48:	8b 00                	mov    (%eax),%eax
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	75 e2                	jne    80104e30 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e51:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104e57:	e8 d3 f4 ff ff       	call   8010432f <myproc>
80104e5c:	8b 50 10             	mov    0x10(%eax),%edx
80104e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e62:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104e65:	8b 45 08             	mov    0x8(%ebp),%eax
80104e68:	83 c0 04             	add    $0x4,%eax
80104e6b:	89 04 24             	mov    %eax,(%esp)
80104e6e:	e8 36 01 00 00       	call   80104fa9 <release>
}
80104e73:	c9                   	leave  
80104e74:	c3                   	ret    

80104e75 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e75:	55                   	push   %ebp
80104e76:	89 e5                	mov    %esp,%ebp
80104e78:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7e:	83 c0 04             	add    $0x4,%eax
80104e81:	89 04 24             	mov    %eax,(%esp)
80104e84:	e8 b6 00 00 00       	call   80104f3f <acquire>
  lk->locked = 0;
80104e89:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e92:	8b 45 08             	mov    0x8(%ebp),%eax
80104e95:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9f:	89 04 24             	mov    %eax,(%esp)
80104ea2:	e8 9d fd ff ff       	call   80104c44 <wakeup>
  release(&lk->lk);
80104ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80104eaa:	83 c0 04             	add    $0x4,%eax
80104ead:	89 04 24             	mov    %eax,(%esp)
80104eb0:	e8 f4 00 00 00       	call   80104fa9 <release>
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    

80104eb7 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104eb7:	55                   	push   %ebp
80104eb8:	89 e5                	mov    %esp,%ebp
80104eba:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec0:	83 c0 04             	add    $0x4,%eax
80104ec3:	89 04 24             	mov    %eax,(%esp)
80104ec6:	e8 74 00 00 00       	call   80104f3f <acquire>
  r = lk->locked;
80104ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ece:	8b 00                	mov    (%eax),%eax
80104ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed6:	83 c0 04             	add    $0x4,%eax
80104ed9:	89 04 24             	mov    %eax,(%esp)
80104edc:	e8 c8 00 00 00       	call   80104fa9 <release>
  return r;
80104ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104ee4:	c9                   	leave  
80104ee5:	c3                   	ret    
	...

80104ee8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ee8:	55                   	push   %ebp
80104ee9:	89 e5                	mov    %esp,%ebp
80104eeb:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104eee:	9c                   	pushf  
80104eef:	58                   	pop    %eax
80104ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ef6:	c9                   	leave  
80104ef7:	c3                   	ret    

80104ef8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104ef8:	55                   	push   %ebp
80104ef9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104efb:	fa                   	cli    
}
80104efc:	5d                   	pop    %ebp
80104efd:	c3                   	ret    

80104efe <sti>:

static inline void
sti(void)
{
80104efe:	55                   	push   %ebp
80104eff:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f01:	fb                   	sti    
}
80104f02:	5d                   	pop    %ebp
80104f03:	c3                   	ret    

80104f04 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f13:	f0 87 02             	lock xchg %eax,(%edx)
80104f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f1c:	c9                   	leave  
80104f1d:	c3                   	ret    

80104f1e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f1e:	55                   	push   %ebp
80104f1f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f21:	8b 45 08             	mov    0x8(%ebp),%eax
80104f24:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f27:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f33:	8b 45 08             	mov    0x8(%ebp),%eax
80104f36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f3d:	5d                   	pop    %ebp
80104f3e:	c3                   	ret    

80104f3f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f3f:	55                   	push   %ebp
80104f40:	89 e5                	mov    %esp,%ebp
80104f42:	53                   	push   %ebx
80104f43:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f46:	e8 53 01 00 00       	call   8010509e <pushcli>
  if(holding(lk))
80104f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4e:	89 04 24             	mov    %eax,(%esp)
80104f51:	e8 17 01 00 00       	call   8010506d <holding>
80104f56:	85 c0                	test   %eax,%eax
80104f58:	74 0c                	je     80104f66 <acquire+0x27>
    panic("acquire");
80104f5a:	c7 04 24 12 95 10 80 	movl   $0x80109512,(%esp)
80104f61:	e8 1c b6 ff ff       	call   80100582 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104f66:	90                   	nop
80104f67:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f71:	00 
80104f72:	89 04 24             	mov    %eax,(%esp)
80104f75:	e8 8a ff ff ff       	call   80104f04 <xchg>
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	75 e9                	jne    80104f67 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104f7e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104f83:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f86:	e8 20 f3 ff ff       	call   801042ab <mycpu>
80104f8b:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f91:	83 c0 0c             	add    $0xc,%eax
80104f94:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f98:	8d 45 08             	lea    0x8(%ebp),%eax
80104f9b:	89 04 24             	mov    %eax,(%esp)
80104f9e:	e8 53 00 00 00       	call   80104ff6 <getcallerpcs>
}
80104fa3:	83 c4 14             	add    $0x14,%esp
80104fa6:	5b                   	pop    %ebx
80104fa7:	5d                   	pop    %ebp
80104fa8:	c3                   	ret    

80104fa9 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fa9:	55                   	push   %ebp
80104faa:	89 e5                	mov    %esp,%ebp
80104fac:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104faf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb2:	89 04 24             	mov    %eax,(%esp)
80104fb5:	e8 b3 00 00 00       	call   8010506d <holding>
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	75 0c                	jne    80104fca <release+0x21>
    panic("release");
80104fbe:	c7 04 24 1a 95 10 80 	movl   $0x8010951a,(%esp)
80104fc5:	e8 b8 b5 ff ff       	call   80100582 <panic>

  lk->pcs[0] = 0;
80104fca:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104fde:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe6:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104fef:	e8 f4 00 00 00       	call   801050e8 <popcli>
}
80104ff4:	c9                   	leave  
80104ff5:	c3                   	ret    

80104ff6 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ff6:	55                   	push   %ebp
80104ff7:	89 e5                	mov    %esp,%ebp
80104ff9:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fff:	83 e8 08             	sub    $0x8,%eax
80105002:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105005:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010500c:	eb 37                	jmp    80105045 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010500e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105012:	74 37                	je     8010504b <getcallerpcs+0x55>
80105014:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010501b:	76 2e                	jbe    8010504b <getcallerpcs+0x55>
8010501d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105021:	74 28                	je     8010504b <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105023:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105026:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010502d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105030:	01 c2                	add    %eax,%edx
80105032:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105035:	8b 40 04             	mov    0x4(%eax),%eax
80105038:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010503a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010503d:	8b 00                	mov    (%eax),%eax
8010503f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105042:	ff 45 f8             	incl   -0x8(%ebp)
80105045:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105049:	7e c3                	jle    8010500e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010504b:	eb 18                	jmp    80105065 <getcallerpcs+0x6f>
    pcs[i] = 0;
8010504d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105050:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505a:	01 d0                	add    %edx,%eax
8010505c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105062:	ff 45 f8             	incl   -0x8(%ebp)
80105065:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105069:	7e e2                	jle    8010504d <getcallerpcs+0x57>
    pcs[i] = 0;
}
8010506b:	c9                   	leave  
8010506c:	c3                   	ret    

8010506d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010506d:	55                   	push   %ebp
8010506e:	89 e5                	mov    %esp,%ebp
80105070:	53                   	push   %ebx
80105071:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105074:	8b 45 08             	mov    0x8(%ebp),%eax
80105077:	8b 00                	mov    (%eax),%eax
80105079:	85 c0                	test   %eax,%eax
8010507b:	74 16                	je     80105093 <holding+0x26>
8010507d:	8b 45 08             	mov    0x8(%ebp),%eax
80105080:	8b 58 08             	mov    0x8(%eax),%ebx
80105083:	e8 23 f2 ff ff       	call   801042ab <mycpu>
80105088:	39 c3                	cmp    %eax,%ebx
8010508a:	75 07                	jne    80105093 <holding+0x26>
8010508c:	b8 01 00 00 00       	mov    $0x1,%eax
80105091:	eb 05                	jmp    80105098 <holding+0x2b>
80105093:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105098:	83 c4 04             	add    $0x4,%esp
8010509b:	5b                   	pop    %ebx
8010509c:	5d                   	pop    %ebp
8010509d:	c3                   	ret    

8010509e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010509e:	55                   	push   %ebp
8010509f:	89 e5                	mov    %esp,%ebp
801050a1:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801050a4:	e8 3f fe ff ff       	call   80104ee8 <readeflags>
801050a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801050ac:	e8 47 fe ff ff       	call   80104ef8 <cli>
  if(mycpu()->ncli == 0)
801050b1:	e8 f5 f1 ff ff       	call   801042ab <mycpu>
801050b6:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050bc:	85 c0                	test   %eax,%eax
801050be:	75 14                	jne    801050d4 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
801050c0:	e8 e6 f1 ff ff       	call   801042ab <mycpu>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	81 e2 00 02 00 00    	and    $0x200,%edx
801050ce:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801050d4:	e8 d2 f1 ff ff       	call   801042ab <mycpu>
801050d9:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050df:	42                   	inc    %edx
801050e0:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801050e6:	c9                   	leave  
801050e7:	c3                   	ret    

801050e8 <popcli>:

void
popcli(void)
{
801050e8:	55                   	push   %ebp
801050e9:	89 e5                	mov    %esp,%ebp
801050eb:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801050ee:	e8 f5 fd ff ff       	call   80104ee8 <readeflags>
801050f3:	25 00 02 00 00       	and    $0x200,%eax
801050f8:	85 c0                	test   %eax,%eax
801050fa:	74 0c                	je     80105108 <popcli+0x20>
    panic("popcli - interruptible");
801050fc:	c7 04 24 22 95 10 80 	movl   $0x80109522,(%esp)
80105103:	e8 7a b4 ff ff       	call   80100582 <panic>
  if(--mycpu()->ncli < 0)
80105108:	e8 9e f1 ff ff       	call   801042ab <mycpu>
8010510d:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105113:	4a                   	dec    %edx
80105114:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010511a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105120:	85 c0                	test   %eax,%eax
80105122:	79 0c                	jns    80105130 <popcli+0x48>
    panic("popcli");
80105124:	c7 04 24 39 95 10 80 	movl   $0x80109539,(%esp)
8010512b:	e8 52 b4 ff ff       	call   80100582 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105130:	e8 76 f1 ff ff       	call   801042ab <mycpu>
80105135:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010513b:	85 c0                	test   %eax,%eax
8010513d:	75 14                	jne    80105153 <popcli+0x6b>
8010513f:	e8 67 f1 ff ff       	call   801042ab <mycpu>
80105144:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010514a:	85 c0                	test   %eax,%eax
8010514c:	74 05                	je     80105153 <popcli+0x6b>
    sti();
8010514e:	e8 ab fd ff ff       	call   80104efe <sti>
}
80105153:	c9                   	leave  
80105154:	c3                   	ret    
80105155:	00 00                	add    %al,(%eax)
	...

80105158 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105158:	55                   	push   %ebp
80105159:	89 e5                	mov    %esp,%ebp
8010515b:	57                   	push   %edi
8010515c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010515d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105160:	8b 55 10             	mov    0x10(%ebp),%edx
80105163:	8b 45 0c             	mov    0xc(%ebp),%eax
80105166:	89 cb                	mov    %ecx,%ebx
80105168:	89 df                	mov    %ebx,%edi
8010516a:	89 d1                	mov    %edx,%ecx
8010516c:	fc                   	cld    
8010516d:	f3 aa                	rep stos %al,%es:(%edi)
8010516f:	89 ca                	mov    %ecx,%edx
80105171:	89 fb                	mov    %edi,%ebx
80105173:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105176:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105179:	5b                   	pop    %ebx
8010517a:	5f                   	pop    %edi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    

8010517d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010517d:	55                   	push   %ebp
8010517e:	89 e5                	mov    %esp,%ebp
80105180:	57                   	push   %edi
80105181:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105182:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105185:	8b 55 10             	mov    0x10(%ebp),%edx
80105188:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518b:	89 cb                	mov    %ecx,%ebx
8010518d:	89 df                	mov    %ebx,%edi
8010518f:	89 d1                	mov    %edx,%ecx
80105191:	fc                   	cld    
80105192:	f3 ab                	rep stos %eax,%es:(%edi)
80105194:	89 ca                	mov    %ecx,%edx
80105196:	89 fb                	mov    %edi,%ebx
80105198:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010519b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010519e:	5b                   	pop    %ebx
8010519f:	5f                   	pop    %edi
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret    

801051a2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051a2:	55                   	push   %ebp
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051a8:	8b 45 08             	mov    0x8(%ebp),%eax
801051ab:	83 e0 03             	and    $0x3,%eax
801051ae:	85 c0                	test   %eax,%eax
801051b0:	75 49                	jne    801051fb <memset+0x59>
801051b2:	8b 45 10             	mov    0x10(%ebp),%eax
801051b5:	83 e0 03             	and    $0x3,%eax
801051b8:	85 c0                	test   %eax,%eax
801051ba:	75 3f                	jne    801051fb <memset+0x59>
    c &= 0xFF;
801051bc:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051c3:	8b 45 10             	mov    0x10(%ebp),%eax
801051c6:	c1 e8 02             	shr    $0x2,%eax
801051c9:	89 c2                	mov    %eax,%edx
801051cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ce:	c1 e0 18             	shl    $0x18,%eax
801051d1:	89 c1                	mov    %eax,%ecx
801051d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d6:	c1 e0 10             	shl    $0x10,%eax
801051d9:	09 c1                	or     %eax,%ecx
801051db:	8b 45 0c             	mov    0xc(%ebp),%eax
801051de:	c1 e0 08             	shl    $0x8,%eax
801051e1:	09 c8                	or     %ecx,%eax
801051e3:	0b 45 0c             	or     0xc(%ebp),%eax
801051e6:	89 54 24 08          	mov    %edx,0x8(%esp)
801051ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ee:	8b 45 08             	mov    0x8(%ebp),%eax
801051f1:	89 04 24             	mov    %eax,(%esp)
801051f4:	e8 84 ff ff ff       	call   8010517d <stosl>
801051f9:	eb 19                	jmp    80105214 <memset+0x72>
  } else
    stosb(dst, c, n);
801051fb:	8b 45 10             	mov    0x10(%ebp),%eax
801051fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105202:	8b 45 0c             	mov    0xc(%ebp),%eax
80105205:	89 44 24 04          	mov    %eax,0x4(%esp)
80105209:	8b 45 08             	mov    0x8(%ebp),%eax
8010520c:	89 04 24             	mov    %eax,(%esp)
8010520f:	e8 44 ff ff ff       	call   80105158 <stosb>
  return dst;
80105214:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105217:	c9                   	leave  
80105218:	c3                   	ret    

80105219 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105219:	55                   	push   %ebp
8010521a:	89 e5                	mov    %esp,%ebp
8010521c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010521f:	8b 45 08             	mov    0x8(%ebp),%eax
80105222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105225:	8b 45 0c             	mov    0xc(%ebp),%eax
80105228:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010522b:	eb 2a                	jmp    80105257 <memcmp+0x3e>
    if(*s1 != *s2)
8010522d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105230:	8a 10                	mov    (%eax),%dl
80105232:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105235:	8a 00                	mov    (%eax),%al
80105237:	38 c2                	cmp    %al,%dl
80105239:	74 16                	je     80105251 <memcmp+0x38>
      return *s1 - *s2;
8010523b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010523e:	8a 00                	mov    (%eax),%al
80105240:	0f b6 d0             	movzbl %al,%edx
80105243:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105246:	8a 00                	mov    (%eax),%al
80105248:	0f b6 c0             	movzbl %al,%eax
8010524b:	29 c2                	sub    %eax,%edx
8010524d:	89 d0                	mov    %edx,%eax
8010524f:	eb 18                	jmp    80105269 <memcmp+0x50>
    s1++, s2++;
80105251:	ff 45 fc             	incl   -0x4(%ebp)
80105254:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105257:	8b 45 10             	mov    0x10(%ebp),%eax
8010525a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010525d:	89 55 10             	mov    %edx,0x10(%ebp)
80105260:	85 c0                	test   %eax,%eax
80105262:	75 c9                	jne    8010522d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105264:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105269:	c9                   	leave  
8010526a:	c3                   	ret    

8010526b <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010526b:	55                   	push   %ebp
8010526c:	89 e5                	mov    %esp,%ebp
8010526e:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105271:	8b 45 0c             	mov    0xc(%ebp),%eax
80105274:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105277:	8b 45 08             	mov    0x8(%ebp),%eax
8010527a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010527d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105280:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105283:	73 3a                	jae    801052bf <memmove+0x54>
80105285:	8b 45 10             	mov    0x10(%ebp),%eax
80105288:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010528b:	01 d0                	add    %edx,%eax
8010528d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105290:	76 2d                	jbe    801052bf <memmove+0x54>
    s += n;
80105292:	8b 45 10             	mov    0x10(%ebp),%eax
80105295:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105298:	8b 45 10             	mov    0x10(%ebp),%eax
8010529b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010529e:	eb 10                	jmp    801052b0 <memmove+0x45>
      *--d = *--s;
801052a0:	ff 4d f8             	decl   -0x8(%ebp)
801052a3:	ff 4d fc             	decl   -0x4(%ebp)
801052a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052a9:	8a 10                	mov    (%eax),%dl
801052ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ae:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052b0:	8b 45 10             	mov    0x10(%ebp),%eax
801052b3:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b6:	89 55 10             	mov    %edx,0x10(%ebp)
801052b9:	85 c0                	test   %eax,%eax
801052bb:	75 e3                	jne    801052a0 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052bd:	eb 25                	jmp    801052e4 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052bf:	eb 16                	jmp    801052d7 <memmove+0x6c>
      *d++ = *s++;
801052c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c4:	8d 50 01             	lea    0x1(%eax),%edx
801052c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
801052ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052cd:	8d 4a 01             	lea    0x1(%edx),%ecx
801052d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801052d3:	8a 12                	mov    (%edx),%dl
801052d5:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052d7:	8b 45 10             	mov    0x10(%ebp),%eax
801052da:	8d 50 ff             	lea    -0x1(%eax),%edx
801052dd:	89 55 10             	mov    %edx,0x10(%ebp)
801052e0:	85 c0                	test   %eax,%eax
801052e2:	75 dd                	jne    801052c1 <memmove+0x56>
      *d++ = *s++;

  return dst;
801052e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052e7:	c9                   	leave  
801052e8:	c3                   	ret    

801052e9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052e9:	55                   	push   %ebp
801052ea:	89 e5                	mov    %esp,%ebp
801052ec:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801052ef:	8b 45 10             	mov    0x10(%ebp),%eax
801052f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801052f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105300:	89 04 24             	mov    %eax,(%esp)
80105303:	e8 63 ff ff ff       	call   8010526b <memmove>
}
80105308:	c9                   	leave  
80105309:	c3                   	ret    

8010530a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010530a:	55                   	push   %ebp
8010530b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010530d:	eb 09                	jmp    80105318 <strncmp+0xe>
    n--, p++, q++;
8010530f:	ff 4d 10             	decl   0x10(%ebp)
80105312:	ff 45 08             	incl   0x8(%ebp)
80105315:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010531c:	74 17                	je     80105335 <strncmp+0x2b>
8010531e:	8b 45 08             	mov    0x8(%ebp),%eax
80105321:	8a 00                	mov    (%eax),%al
80105323:	84 c0                	test   %al,%al
80105325:	74 0e                	je     80105335 <strncmp+0x2b>
80105327:	8b 45 08             	mov    0x8(%ebp),%eax
8010532a:	8a 10                	mov    (%eax),%dl
8010532c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010532f:	8a 00                	mov    (%eax),%al
80105331:	38 c2                	cmp    %al,%dl
80105333:	74 da                	je     8010530f <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105335:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105339:	75 07                	jne    80105342 <strncmp+0x38>
    return 0;
8010533b:	b8 00 00 00 00       	mov    $0x0,%eax
80105340:	eb 14                	jmp    80105356 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
80105342:	8b 45 08             	mov    0x8(%ebp),%eax
80105345:	8a 00                	mov    (%eax),%al
80105347:	0f b6 d0             	movzbl %al,%edx
8010534a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010534d:	8a 00                	mov    (%eax),%al
8010534f:	0f b6 c0             	movzbl %al,%eax
80105352:	29 c2                	sub    %eax,%edx
80105354:	89 d0                	mov    %edx,%eax
}
80105356:	5d                   	pop    %ebp
80105357:	c3                   	ret    

80105358 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105358:	55                   	push   %ebp
80105359:	89 e5                	mov    %esp,%ebp
8010535b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010535e:	8b 45 08             	mov    0x8(%ebp),%eax
80105361:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105364:	90                   	nop
80105365:	8b 45 10             	mov    0x10(%ebp),%eax
80105368:	8d 50 ff             	lea    -0x1(%eax),%edx
8010536b:	89 55 10             	mov    %edx,0x10(%ebp)
8010536e:	85 c0                	test   %eax,%eax
80105370:	7e 1c                	jle    8010538e <strncpy+0x36>
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
80105375:	8d 50 01             	lea    0x1(%eax),%edx
80105378:	89 55 08             	mov    %edx,0x8(%ebp)
8010537b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010537e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105381:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105384:	8a 12                	mov    (%edx),%dl
80105386:	88 10                	mov    %dl,(%eax)
80105388:	8a 00                	mov    (%eax),%al
8010538a:	84 c0                	test   %al,%al
8010538c:	75 d7                	jne    80105365 <strncpy+0xd>
    ;
  while(n-- > 0)
8010538e:	eb 0c                	jmp    8010539c <strncpy+0x44>
    *s++ = 0;
80105390:	8b 45 08             	mov    0x8(%ebp),%eax
80105393:	8d 50 01             	lea    0x1(%eax),%edx
80105396:	89 55 08             	mov    %edx,0x8(%ebp)
80105399:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010539c:	8b 45 10             	mov    0x10(%ebp),%eax
8010539f:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a2:	89 55 10             	mov    %edx,0x10(%ebp)
801053a5:	85 c0                	test   %eax,%eax
801053a7:	7f e7                	jg     80105390 <strncpy+0x38>
    *s++ = 0;
  return os;
801053a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053ac:	c9                   	leave  
801053ad:	c3                   	ret    

801053ae <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053ae:	55                   	push   %ebp
801053af:	89 e5                	mov    %esp,%ebp
801053b1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801053b4:	8b 45 08             	mov    0x8(%ebp),%eax
801053b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053be:	7f 05                	jg     801053c5 <safestrcpy+0x17>
    return os;
801053c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053c3:	eb 2e                	jmp    801053f3 <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
801053c5:	ff 4d 10             	decl   0x10(%ebp)
801053c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053cc:	7e 1c                	jle    801053ea <safestrcpy+0x3c>
801053ce:	8b 45 08             	mov    0x8(%ebp),%eax
801053d1:	8d 50 01             	lea    0x1(%eax),%edx
801053d4:	89 55 08             	mov    %edx,0x8(%ebp)
801053d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801053da:	8d 4a 01             	lea    0x1(%edx),%ecx
801053dd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053e0:	8a 12                	mov    (%edx),%dl
801053e2:	88 10                	mov    %dl,(%eax)
801053e4:	8a 00                	mov    (%eax),%al
801053e6:	84 c0                	test   %al,%al
801053e8:	75 db                	jne    801053c5 <safestrcpy+0x17>
    ;
  *s = 0;
801053ea:	8b 45 08             	mov    0x8(%ebp),%eax
801053ed:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801053f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053f3:	c9                   	leave  
801053f4:	c3                   	ret    

801053f5 <strlen>:

int
strlen(const char *s)
{
801053f5:	55                   	push   %ebp
801053f6:	89 e5                	mov    %esp,%ebp
801053f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801053fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105402:	eb 03                	jmp    80105407 <strlen+0x12>
80105404:	ff 45 fc             	incl   -0x4(%ebp)
80105407:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010540a:	8b 45 08             	mov    0x8(%ebp),%eax
8010540d:	01 d0                	add    %edx,%eax
8010540f:	8a 00                	mov    (%eax),%al
80105411:	84 c0                	test   %al,%al
80105413:	75 ef                	jne    80105404 <strlen+0xf>
    ;
  return n;
80105415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105418:	c9                   	leave  
80105419:	c3                   	ret    

8010541a <strcat>:

char*
strcat(char *dest, const char *src)
{
8010541a:	55                   	push   %ebp
8010541b:	89 e5                	mov    %esp,%ebp
8010541d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
80105420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105427:	eb 03                	jmp    8010542c <strcat+0x12>
80105429:	ff 45 fc             	incl   -0x4(%ebp)
8010542c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010542f:	8b 45 08             	mov    0x8(%ebp),%eax
80105432:	01 d0                	add    %edx,%eax
80105434:	8a 00                	mov    (%eax),%al
80105436:	84 c0                	test   %al,%al
80105438:	75 ef                	jne    80105429 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
8010543a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105441:	eb 1e                	jmp    80105461 <strcat+0x47>
        dest[i+j] = src[j];
80105443:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105446:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105449:	01 d0                	add    %edx,%eax
8010544b:	89 c2                	mov    %eax,%edx
8010544d:	8b 45 08             	mov    0x8(%ebp),%eax
80105450:	01 c2                	add    %eax,%edx
80105452:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80105455:	8b 45 0c             	mov    0xc(%ebp),%eax
80105458:	01 c8                	add    %ecx,%eax
8010545a:	8a 00                	mov    (%eax),%al
8010545c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
8010545e:	ff 45 f8             	incl   -0x8(%ebp)
80105461:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105464:	8b 45 0c             	mov    0xc(%ebp),%eax
80105467:	01 d0                	add    %edx,%eax
80105469:	8a 00                	mov    (%eax),%al
8010546b:	84 c0                	test   %al,%al
8010546d:	75 d4                	jne    80105443 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
8010546f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105472:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105475:	01 d0                	add    %edx,%eax
80105477:	89 c2                	mov    %eax,%edx
80105479:	8b 45 08             	mov    0x8(%ebp),%eax
8010547c:	01 d0                	add    %edx,%eax
8010547e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
80105481:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105484:	c9                   	leave  
80105485:	c3                   	ret    

80105486 <itoa>:

char* itoa(int num, char* str, int base)
{
80105486:	55                   	push   %ebp
80105487:	89 e5                	mov    %esp,%ebp
80105489:	83 ec 10             	sub    $0x10,%esp
    char temp;
    int rem, i = 0, j = 0;
8010548c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 
    if (num == 0)
8010549a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010549e:	75 26                	jne    801054c6 <itoa+0x40>
    {
        str[i++] = '0';
801054a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054a3:	8d 50 01             	lea    0x1(%eax),%edx
801054a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054a9:	89 c2                	mov    %eax,%edx
801054ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ae:	01 d0                	add    %edx,%eax
801054b0:	c6 00 30             	movb   $0x30,(%eax)
        str[i] = '\0';
801054b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
801054b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b9:	01 d0                	add    %edx,%eax
801054bb:	c6 00 00             	movb   $0x0,(%eax)
        return str;
801054be:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c1:	e9 ab 00 00 00       	jmp    80105571 <itoa+0xeb>
    }
 
    while (num != 0)
801054c6:	eb 36                	jmp    801054fe <itoa+0x78>
    {
        rem = num % base;
801054c8:	8b 45 08             	mov    0x8(%ebp),%eax
801054cb:	99                   	cltd   
801054cc:	f7 7d 10             	idivl  0x10(%ebp)
801054cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
        if(rem > 9)
801054d2:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
801054d6:	7e 04                	jle    801054dc <itoa+0x56>
        {
            rem = rem - 10;
801054d8:	83 6d fc 0a          	subl   $0xa,-0x4(%ebp)
        }
        /* Add the digit as a string */
        str[i++] = rem + '0';
801054dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054df:	8d 50 01             	lea    0x1(%eax),%edx
801054e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054e5:	89 c2                	mov    %eax,%edx
801054e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ea:	01 c2                	add    %eax,%edx
801054ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ef:	83 c0 30             	add    $0x30,%eax
801054f2:	88 02                	mov    %al,(%edx)
        num = num/base;
801054f4:	8b 45 08             	mov    0x8(%ebp),%eax
801054f7:	99                   	cltd   
801054f8:	f7 7d 10             	idivl  0x10(%ebp)
801054fb:	89 45 08             	mov    %eax,0x8(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
 
    while (num != 0)
801054fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105502:	75 c4                	jne    801054c8 <itoa+0x42>
        /* Add the digit as a string */
        str[i++] = rem + '0';
        num = num/base;
    }

    str[i] = '\0';
80105504:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105507:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550a:	01 d0                	add    %edx,%eax
8010550c:	c6 00 00             	movb   $0x0,(%eax)

    for(j = 0; j < i / 2; j++)
8010550f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105516:	eb 45                	jmp    8010555d <itoa+0xd7>
    {
        temp = str[j];
80105518:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010551b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010551e:	01 d0                	add    %edx,%eax
80105520:	8a 00                	mov    (%eax),%al
80105522:	88 45 f3             	mov    %al,-0xd(%ebp)
        str[j] = str[i - j - 1];
80105525:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105528:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552b:	01 c2                	add    %eax,%edx
8010552d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105530:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80105533:	29 c1                	sub    %eax,%ecx
80105535:	89 c8                	mov    %ecx,%eax
80105537:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010553a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553d:	01 c8                	add    %ecx,%eax
8010553f:	8a 00                	mov    (%eax),%al
80105541:	88 02                	mov    %al,(%edx)
        str[i - j - 1] = temp;
80105543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105546:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105549:	29 c2                	sub    %eax,%edx
8010554b:	89 d0                	mov    %edx,%eax
8010554d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105550:	8b 45 0c             	mov    0xc(%ebp),%eax
80105553:	01 c2                	add    %eax,%edx
80105555:	8a 45 f3             	mov    -0xd(%ebp),%al
80105558:	88 02                	mov    %al,(%edx)
        num = num/base;
    }

    str[i] = '\0';

    for(j = 0; j < i / 2; j++)
8010555a:	ff 45 f4             	incl   -0xc(%ebp)
8010555d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105560:	89 c2                	mov    %eax,%edx
80105562:	c1 ea 1f             	shr    $0x1f,%edx
80105565:	01 d0                	add    %edx,%eax
80105567:	d1 f8                	sar    %eax
80105569:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010556c:	7f aa                	jg     80105518 <itoa+0x92>
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
 
    return str;
8010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80105571:	c9                   	leave  
80105572:	c3                   	ret    
	...

80105574 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105574:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105578:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010557c:	55                   	push   %ebp
  pushl %ebx
8010557d:	53                   	push   %ebx
  pushl %esi
8010557e:	56                   	push   %esi
  pushl %edi
8010557f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105580:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105582:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105584:	5f                   	pop    %edi
  popl %esi
80105585:	5e                   	pop    %esi
  popl %ebx
80105586:	5b                   	pop    %ebx
  popl %ebp
80105587:	5d                   	pop    %ebp
  ret
80105588:	c3                   	ret    
80105589:	00 00                	add    %al,(%eax)
	...

8010558c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010558c:	55                   	push   %ebp
8010558d:	89 e5                	mov    %esp,%ebp
8010558f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105592:	e8 98 ed ff ff       	call   8010432f <myproc>
80105597:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010559a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559d:	8b 00                	mov    (%eax),%eax
8010559f:	3b 45 08             	cmp    0x8(%ebp),%eax
801055a2:	76 0f                	jbe    801055b3 <fetchint+0x27>
801055a4:	8b 45 08             	mov    0x8(%ebp),%eax
801055a7:	8d 50 04             	lea    0x4(%eax),%edx
801055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ad:	8b 00                	mov    (%eax),%eax
801055af:	39 c2                	cmp    %eax,%edx
801055b1:	76 07                	jbe    801055ba <fetchint+0x2e>
    return -1;
801055b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b8:	eb 0f                	jmp    801055c9 <fetchint+0x3d>
  *ip = *(int*)(addr);
801055ba:	8b 45 08             	mov    0x8(%ebp),%eax
801055bd:	8b 10                	mov    (%eax),%edx
801055bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c2:	89 10                	mov    %edx,(%eax)
  return 0;
801055c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055c9:	c9                   	leave  
801055ca:	c3                   	ret    

801055cb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055cb:	55                   	push   %ebp
801055cc:	89 e5                	mov    %esp,%ebp
801055ce:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801055d1:	e8 59 ed ff ff       	call   8010432f <myproc>
801055d6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801055d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055dc:	8b 00                	mov    (%eax),%eax
801055de:	3b 45 08             	cmp    0x8(%ebp),%eax
801055e1:	77 07                	ja     801055ea <fetchstr+0x1f>
    return -1;
801055e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e8:	eb 41                	jmp    8010562b <fetchstr+0x60>
  *pp = (char*)addr;
801055ea:	8b 55 08             	mov    0x8(%ebp),%edx
801055ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f0:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801055f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f5:	8b 00                	mov    (%eax),%eax
801055f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801055fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801055fd:	8b 00                	mov    (%eax),%eax
801055ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105602:	eb 1a                	jmp    8010561e <fetchstr+0x53>
    if(*s == 0)
80105604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105607:	8a 00                	mov    (%eax),%al
80105609:	84 c0                	test   %al,%al
8010560b:	75 0e                	jne    8010561b <fetchstr+0x50>
      return s - *pp;
8010560d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105610:	8b 45 0c             	mov    0xc(%ebp),%eax
80105613:	8b 00                	mov    (%eax),%eax
80105615:	29 c2                	sub    %eax,%edx
80105617:	89 d0                	mov    %edx,%eax
80105619:	eb 10                	jmp    8010562b <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010561b:	ff 45 f4             	incl   -0xc(%ebp)
8010561e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105621:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105624:	72 de                	jb     80105604 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80105626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010562b:	c9                   	leave  
8010562c:	c3                   	ret    

8010562d <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010562d:	55                   	push   %ebp
8010562e:	89 e5                	mov    %esp,%ebp
80105630:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105633:	e8 f7 ec ff ff       	call   8010432f <myproc>
80105638:	8b 40 18             	mov    0x18(%eax),%eax
8010563b:	8b 50 44             	mov    0x44(%eax),%edx
8010563e:	8b 45 08             	mov    0x8(%ebp),%eax
80105641:	c1 e0 02             	shl    $0x2,%eax
80105644:	01 d0                	add    %edx,%eax
80105646:	8d 50 04             	lea    0x4(%eax),%edx
80105649:	8b 45 0c             	mov    0xc(%ebp),%eax
8010564c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105650:	89 14 24             	mov    %edx,(%esp)
80105653:	e8 34 ff ff ff       	call   8010558c <fetchint>
}
80105658:	c9                   	leave  
80105659:	c3                   	ret    

8010565a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010565a:	55                   	push   %ebp
8010565b:	89 e5                	mov    %esp,%ebp
8010565d:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
80105660:	e8 ca ec ff ff       	call   8010432f <myproc>
80105665:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105668:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010566b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010566f:	8b 45 08             	mov    0x8(%ebp),%eax
80105672:	89 04 24             	mov    %eax,(%esp)
80105675:	e8 b3 ff ff ff       	call   8010562d <argint>
8010567a:	85 c0                	test   %eax,%eax
8010567c:	79 07                	jns    80105685 <argptr+0x2b>
    return -1;
8010567e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105683:	eb 3d                	jmp    801056c2 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105685:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105689:	78 21                	js     801056ac <argptr+0x52>
8010568b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568e:	89 c2                	mov    %eax,%edx
80105690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105693:	8b 00                	mov    (%eax),%eax
80105695:	39 c2                	cmp    %eax,%edx
80105697:	73 13                	jae    801056ac <argptr+0x52>
80105699:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010569c:	89 c2                	mov    %eax,%edx
8010569e:	8b 45 10             	mov    0x10(%ebp),%eax
801056a1:	01 c2                	add    %eax,%edx
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	8b 00                	mov    (%eax),%eax
801056a8:	39 c2                	cmp    %eax,%edx
801056aa:	76 07                	jbe    801056b3 <argptr+0x59>
    return -1;
801056ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b1:	eb 0f                	jmp    801056c2 <argptr+0x68>
  *pp = (char*)i;
801056b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b6:	89 c2                	mov    %eax,%edx
801056b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801056bb:	89 10                	mov    %edx,(%eax)
  return 0;
801056bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056c2:	c9                   	leave  
801056c3:	c3                   	ret    

801056c4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801056d1:	8b 45 08             	mov    0x8(%ebp),%eax
801056d4:	89 04 24             	mov    %eax,(%esp)
801056d7:	e8 51 ff ff ff       	call   8010562d <argint>
801056dc:	85 c0                	test   %eax,%eax
801056de:	79 07                	jns    801056e7 <argstr+0x23>
    return -1;
801056e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e5:	eb 12                	jmp    801056f9 <argstr+0x35>
  return fetchstr(addr, pp);
801056e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801056ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801056f1:	89 04 24             	mov    %eax,(%esp)
801056f4:	e8 d2 fe ff ff       	call   801055cb <fetchstr>
}
801056f9:	c9                   	leave  
801056fa:	c3                   	ret    

801056fb <syscall>:
[SYS_setatroot]    sys_setatroot,
};

void
syscall(void)
{
801056fb:	55                   	push   %ebp
801056fc:	89 e5                	mov    %esp,%ebp
801056fe:	53                   	push   %ebx
801056ff:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105702:	e8 28 ec ff ff       	call   8010432f <myproc>
80105707:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010570a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570d:	8b 40 18             	mov    0x18(%eax),%eax
80105710:	8b 40 1c             	mov    0x1c(%eax),%eax
80105713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010571a:	7e 2d                	jle    80105749 <syscall+0x4e>
8010571c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010571f:	83 f8 2a             	cmp    $0x2a,%eax
80105722:	77 25                	ja     80105749 <syscall+0x4e>
80105724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105727:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
8010572e:	85 c0                	test   %eax,%eax
80105730:	74 17                	je     80105749 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105735:	8b 58 18             	mov    0x18(%eax),%ebx
80105738:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573b:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105742:	ff d0                	call   *%eax
80105744:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105747:	eb 34                	jmp    8010577d <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574c:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010574f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105752:	8b 40 10             	mov    0x10(%eax),%eax
80105755:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105758:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010575c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105760:	89 44 24 04          	mov    %eax,0x4(%esp)
80105764:	c7 04 24 40 95 10 80 	movl   $0x80109540,(%esp)
8010576b:	e8 7f ac ff ff       	call   801003ef <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105773:	8b 40 18             	mov    0x18(%eax),%eax
80105776:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010577d:	83 c4 24             	add    $0x24,%esp
80105780:	5b                   	pop    %ebx
80105781:	5d                   	pop    %ebp
80105782:	c3                   	ret    
	...

80105784 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010578a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010578d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105791:	8b 45 08             	mov    0x8(%ebp),%eax
80105794:	89 04 24             	mov    %eax,(%esp)
80105797:	e8 91 fe ff ff       	call   8010562d <argint>
8010579c:	85 c0                	test   %eax,%eax
8010579e:	79 07                	jns    801057a7 <argfd+0x23>
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a5:	eb 4f                	jmp    801057f6 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057aa:	85 c0                	test   %eax,%eax
801057ac:	78 20                	js     801057ce <argfd+0x4a>
801057ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b1:	83 f8 0f             	cmp    $0xf,%eax
801057b4:	7f 18                	jg     801057ce <argfd+0x4a>
801057b6:	e8 74 eb ff ff       	call   8010432f <myproc>
801057bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057be:	83 c2 08             	add    $0x8,%edx
801057c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057cc:	75 07                	jne    801057d5 <argfd+0x51>
    return -1;
801057ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d3:	eb 21                	jmp    801057f6 <argfd+0x72>
  if(pfd)
801057d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057d9:	74 08                	je     801057e3 <argfd+0x5f>
    *pfd = fd;
801057db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057de:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e1:	89 10                	mov    %edx,(%eax)
  if(pf)
801057e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057e7:	74 08                	je     801057f1 <argfd+0x6d>
    *pf = f;
801057e9:	8b 45 10             	mov    0x10(%ebp),%eax
801057ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057ef:	89 10                	mov    %edx,(%eax)
  return 0;
801057f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057f6:	c9                   	leave  
801057f7:	c3                   	ret    

801057f8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801057f8:	55                   	push   %ebp
801057f9:	89 e5                	mov    %esp,%ebp
801057fb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801057fe:	e8 2c eb ff ff       	call   8010432f <myproc>
80105803:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010580d:	eb 29                	jmp    80105838 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
8010580f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105812:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105815:	83 c2 08             	add    $0x8,%edx
80105818:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	75 15                	jne    80105835 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105823:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105826:	8d 4a 08             	lea    0x8(%edx),%ecx
80105829:	8b 55 08             	mov    0x8(%ebp),%edx
8010582c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105833:	eb 0e                	jmp    80105843 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105835:	ff 45 f4             	incl   -0xc(%ebp)
80105838:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010583c:	7e d1                	jle    8010580f <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010583e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105843:	c9                   	leave  
80105844:	c3                   	ret    

80105845 <sys_dup>:

int
sys_dup(void)
{
80105845:	55                   	push   %ebp
80105846:	89 e5                	mov    %esp,%ebp
80105848:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010584b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010584e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105852:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105859:	00 
8010585a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105861:	e8 1e ff ff ff       	call   80105784 <argfd>
80105866:	85 c0                	test   %eax,%eax
80105868:	79 07                	jns    80105871 <sys_dup+0x2c>
    return -1;
8010586a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586f:	eb 29                	jmp    8010589a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105871:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105874:	89 04 24             	mov    %eax,(%esp)
80105877:	e8 7c ff ff ff       	call   801057f8 <fdalloc>
8010587c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010587f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105883:	79 07                	jns    8010588c <sys_dup+0x47>
    return -1;
80105885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588a:	eb 0e                	jmp    8010589a <sys_dup+0x55>
  filedup(f);
8010588c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588f:	89 04 24             	mov    %eax,(%esp)
80105892:	e8 45 b9 ff ff       	call   801011dc <filedup>
  return fd;
80105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    

8010589c <sys_read>:

int
sys_read(void)
{
8010589c:	55                   	push   %ebp
8010589d:	89 e5                	mov    %esp,%ebp
8010589f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801058a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b0:	00 
801058b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058b8:	e8 c7 fe ff ff       	call   80105784 <argfd>
801058bd:	85 c0                	test   %eax,%eax
801058bf:	78 35                	js     801058f6 <sys_read+0x5a>
801058c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058cf:	e8 59 fd ff ff       	call   8010562d <argint>
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 1e                	js     801058f6 <sys_read+0x5a>
801058d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058db:	89 44 24 08          	mov    %eax,0x8(%esp)
801058df:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801058e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058ed:	e8 68 fd ff ff       	call   8010565a <argptr>
801058f2:	85 c0                	test   %eax,%eax
801058f4:	79 07                	jns    801058fd <sys_read+0x61>
    return -1;
801058f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fb:	eb 19                	jmp    80105916 <sys_read+0x7a>
  return fileread(f, p, n);
801058fd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105900:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105906:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010590a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010590e:	89 04 24             	mov    %eax,(%esp)
80105911:	e8 27 ba ff ff       	call   8010133d <fileread>
}
80105916:	c9                   	leave  
80105917:	c3                   	ret    

80105918 <sys_write>:

int
sys_write(void)
{
80105918:	55                   	push   %ebp
80105919:	89 e5                	mov    %esp,%ebp
8010591b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010591e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105921:	89 44 24 08          	mov    %eax,0x8(%esp)
80105925:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010592c:	00 
8010592d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105934:	e8 4b fe ff ff       	call   80105784 <argfd>
80105939:	85 c0                	test   %eax,%eax
8010593b:	78 35                	js     80105972 <sys_write+0x5a>
8010593d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105940:	89 44 24 04          	mov    %eax,0x4(%esp)
80105944:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010594b:	e8 dd fc ff ff       	call   8010562d <argint>
80105950:	85 c0                	test   %eax,%eax
80105952:	78 1e                	js     80105972 <sys_write+0x5a>
80105954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105957:	89 44 24 08          	mov    %eax,0x8(%esp)
8010595b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010595e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105962:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105969:	e8 ec fc ff ff       	call   8010565a <argptr>
8010596e:	85 c0                	test   %eax,%eax
80105970:	79 07                	jns    80105979 <sys_write+0x61>
    return -1;
80105972:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105977:	eb 19                	jmp    80105992 <sys_write+0x7a>
  return filewrite(f, p, n);
80105979:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010597c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010597f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105982:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105986:	89 54 24 04          	mov    %edx,0x4(%esp)
8010598a:	89 04 24             	mov    %eax,(%esp)
8010598d:	e8 66 ba ff ff       	call   801013f8 <filewrite>
}
80105992:	c9                   	leave  
80105993:	c3                   	ret    

80105994 <sys_close>:

int
sys_close(void)
{
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010599a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010599d:	89 44 24 08          	mov    %eax,0x8(%esp)
801059a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059af:	e8 d0 fd ff ff       	call   80105784 <argfd>
801059b4:	85 c0                	test   %eax,%eax
801059b6:	79 07                	jns    801059bf <sys_close+0x2b>
    return -1;
801059b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bd:	eb 23                	jmp    801059e2 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
801059bf:	e8 6b e9 ff ff       	call   8010432f <myproc>
801059c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c7:	83 c2 08             	add    $0x8,%edx
801059ca:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059d1:	00 
  fileclose(f);
801059d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d5:	89 04 24             	mov    %eax,(%esp)
801059d8:	e8 47 b8 ff ff       	call   80101224 <fileclose>
  return 0;
801059dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059e2:	c9                   	leave  
801059e3:	c3                   	ret    

801059e4 <sys_fstat>:

int
sys_fstat(void)
{
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801059f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059f8:	00 
801059f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a00:	e8 7f fd ff ff       	call   80105784 <argfd>
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 1f                	js     80105a28 <sys_fstat+0x44>
80105a09:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105a10:	00 
80105a11:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a1f:	e8 36 fc ff ff       	call   8010565a <argptr>
80105a24:	85 c0                	test   %eax,%eax
80105a26:	79 07                	jns    80105a2f <sys_fstat+0x4b>
    return -1;
80105a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2d:	eb 12                	jmp    80105a41 <sys_fstat+0x5d>
  return filestat(f, st);
80105a2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a35:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a39:	89 04 24             	mov    %eax,(%esp)
80105a3c:	e8 ad b8 ff ff       	call   801012ee <filestat>
}
80105a41:	c9                   	leave  
80105a42:	c3                   	ret    

80105a43 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a43:	55                   	push   %ebp
80105a44:	89 e5                	mov    %esp,%ebp
80105a46:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a49:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a57:	e8 68 fc ff ff       	call   801056c4 <argstr>
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	78 17                	js     80105a77 <sys_link+0x34>
80105a60:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a63:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a6e:	e8 51 fc ff ff       	call   801056c4 <argstr>
80105a73:	85 c0                	test   %eax,%eax
80105a75:	79 0a                	jns    80105a81 <sys_link+0x3e>
    return -1;
80105a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7c:	e9 3d 01 00 00       	jmp    80105bbe <sys_link+0x17b>

  begin_op();
80105a81:	e8 b1 db ff ff       	call   80103637 <begin_op>
  if((ip = namei(old)) == 0){
80105a86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a89:	89 04 24             	mov    %eax,(%esp)
80105a8c:	e8 d2 cb ff ff       	call   80102663 <namei>
80105a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a98:	75 0f                	jne    80105aa9 <sys_link+0x66>
    end_op();
80105a9a:	e8 1a dc ff ff       	call   801036b9 <end_op>
    return -1;
80105a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa4:	e9 15 01 00 00       	jmp    80105bbe <sys_link+0x17b>
  }

  ilock(ip);
80105aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aac:	89 04 24             	mov    %eax,(%esp)
80105aaf:	e8 8a c0 ff ff       	call   80101b3e <ilock>
  if(ip->type == T_DIR){
80105ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab7:	8b 40 50             	mov    0x50(%eax),%eax
80105aba:	66 83 f8 01          	cmp    $0x1,%ax
80105abe:	75 1a                	jne    80105ada <sys_link+0x97>
    iunlockput(ip);
80105ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac3:	89 04 24             	mov    %eax,(%esp)
80105ac6:	e8 72 c2 ff ff       	call   80101d3d <iunlockput>
    end_op();
80105acb:	e8 e9 db ff ff       	call   801036b9 <end_op>
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad5:	e9 e4 00 00 00       	jmp    80105bbe <sys_link+0x17b>
  }

  ip->nlink++;
80105ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105add:	66 8b 40 56          	mov    0x56(%eax),%ax
80105ae1:	40                   	inc    %eax
80105ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ae5:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	89 04 24             	mov    %eax,(%esp)
80105aef:	e8 87 be ff ff       	call   8010197b <iupdate>
  iunlock(ip);
80105af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af7:	89 04 24             	mov    %eax,(%esp)
80105afa:	e8 49 c1 ff ff       	call   80101c48 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105aff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b02:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b05:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b09:	89 04 24             	mov    %eax,(%esp)
80105b0c:	e8 74 cb ff ff       	call   80102685 <nameiparent>
80105b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b18:	75 02                	jne    80105b1c <sys_link+0xd9>
    goto bad;
80105b1a:	eb 68                	jmp    80105b84 <sys_link+0x141>
  ilock(dp);
80105b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1f:	89 04 24             	mov    %eax,(%esp)
80105b22:	e8 17 c0 ff ff       	call   80101b3e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2a:	8b 10                	mov    (%eax),%edx
80105b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2f:	8b 00                	mov    (%eax),%eax
80105b31:	39 c2                	cmp    %eax,%edx
80105b33:	75 20                	jne    80105b55 <sys_link+0x112>
80105b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b38:	8b 40 04             	mov    0x4(%eax),%eax
80105b3b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b3f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b49:	89 04 24             	mov    %eax,(%esp)
80105b4c:	e8 5f c8 ff ff       	call   801023b0 <dirlink>
80105b51:	85 c0                	test   %eax,%eax
80105b53:	79 0d                	jns    80105b62 <sys_link+0x11f>
    iunlockput(dp);
80105b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b58:	89 04 24             	mov    %eax,(%esp)
80105b5b:	e8 dd c1 ff ff       	call   80101d3d <iunlockput>
    goto bad;
80105b60:	eb 22                	jmp    80105b84 <sys_link+0x141>
  }
  iunlockput(dp);
80105b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b65:	89 04 24             	mov    %eax,(%esp)
80105b68:	e8 d0 c1 ff ff       	call   80101d3d <iunlockput>
  iput(ip);
80105b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b70:	89 04 24             	mov    %eax,(%esp)
80105b73:	e8 14 c1 ff ff       	call   80101c8c <iput>

  end_op();
80105b78:	e8 3c db ff ff       	call   801036b9 <end_op>

  return 0;
80105b7d:	b8 00 00 00 00       	mov    $0x0,%eax
80105b82:	eb 3a                	jmp    80105bbe <sys_link+0x17b>

bad:
  ilock(ip);
80105b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b87:	89 04 24             	mov    %eax,(%esp)
80105b8a:	e8 af bf ff ff       	call   80101b3e <ilock>
  ip->nlink--;
80105b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b92:	66 8b 40 56          	mov    0x56(%eax),%ax
80105b96:	48                   	dec    %eax
80105b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b9a:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba1:	89 04 24             	mov    %eax,(%esp)
80105ba4:	e8 d2 bd ff ff       	call   8010197b <iupdate>
  iunlockput(ip);
80105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bac:	89 04 24             	mov    %eax,(%esp)
80105baf:	e8 89 c1 ff ff       	call   80101d3d <iunlockput>
  end_op();
80105bb4:	e8 00 db ff ff       	call   801036b9 <end_op>
  return -1;
80105bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    

80105bc0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bc6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bcd:	eb 4a                	jmp    80105c19 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105bd9:	00 
80105bda:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bde:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105be1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105be5:	8b 45 08             	mov    0x8(%ebp),%eax
80105be8:	89 04 24             	mov    %eax,(%esp)
80105beb:	e8 e5 c3 ff ff       	call   80101fd5 <readi>
80105bf0:	83 f8 10             	cmp    $0x10,%eax
80105bf3:	74 0c                	je     80105c01 <isdirempty+0x41>
      panic("isdirempty: readi");
80105bf5:	c7 04 24 5c 95 10 80 	movl   $0x8010955c,(%esp)
80105bfc:	e8 81 a9 ff ff       	call   80100582 <panic>
    if(de.inum != 0)
80105c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c04:	66 85 c0             	test   %ax,%ax
80105c07:	74 07                	je     80105c10 <isdirempty+0x50>
      return 0;
80105c09:	b8 00 00 00 00       	mov    $0x0,%eax
80105c0e:	eb 1b                	jmp    80105c2b <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c13:	83 c0 10             	add    $0x10,%eax
80105c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c1f:	8b 40 58             	mov    0x58(%eax),%eax
80105c22:	39 c2                	cmp    %eax,%edx
80105c24:	72 a9                	jb     80105bcf <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105c26:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c2b:	c9                   	leave  
80105c2c:	c3                   	ret    

80105c2d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c2d:	55                   	push   %ebp
80105c2e:	89 e5                	mov    %esp,%ebp
80105c30:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c33:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c41:	e8 7e fa ff ff       	call   801056c4 <argstr>
80105c46:	85 c0                	test   %eax,%eax
80105c48:	79 0a                	jns    80105c54 <sys_unlink+0x27>
    return -1;
80105c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4f:	e9 a9 01 00 00       	jmp    80105dfd <sys_unlink+0x1d0>

  begin_op();
80105c54:	e8 de d9 ff ff       	call   80103637 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c5c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c5f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c63:	89 04 24             	mov    %eax,(%esp)
80105c66:	e8 1a ca ff ff       	call   80102685 <nameiparent>
80105c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c72:	75 0f                	jne    80105c83 <sys_unlink+0x56>
    end_op();
80105c74:	e8 40 da ff ff       	call   801036b9 <end_op>
    return -1;
80105c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7e:	e9 7a 01 00 00       	jmp    80105dfd <sys_unlink+0x1d0>
  }

  ilock(dp);
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	89 04 24             	mov    %eax,(%esp)
80105c89:	e8 b0 be ff ff       	call   80101b3e <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c8e:	c7 44 24 04 6e 95 10 	movl   $0x8010956e,0x4(%esp)
80105c95:	80 
80105c96:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c99:	89 04 24             	mov    %eax,(%esp)
80105c9c:	e8 27 c6 ff ff       	call   801022c8 <namecmp>
80105ca1:	85 c0                	test   %eax,%eax
80105ca3:	0f 84 3f 01 00 00    	je     80105de8 <sys_unlink+0x1bb>
80105ca9:	c7 44 24 04 70 95 10 	movl   $0x80109570,0x4(%esp)
80105cb0:	80 
80105cb1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cb4:	89 04 24             	mov    %eax,(%esp)
80105cb7:	e8 0c c6 ff ff       	call   801022c8 <namecmp>
80105cbc:	85 c0                	test   %eax,%eax
80105cbe:	0f 84 24 01 00 00    	je     80105de8 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105cc4:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ccb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd5:	89 04 24             	mov    %eax,(%esp)
80105cd8:	e8 0d c6 ff ff       	call   801022ea <dirlookup>
80105cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ce0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ce4:	75 05                	jne    80105ceb <sys_unlink+0xbe>
    goto bad;
80105ce6:	e9 fd 00 00 00       	jmp    80105de8 <sys_unlink+0x1bb>
  ilock(ip);
80105ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cee:	89 04 24             	mov    %eax,(%esp)
80105cf1:	e8 48 be ff ff       	call   80101b3e <ilock>

  if(ip->nlink < 1)
80105cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf9:	66 8b 40 56          	mov    0x56(%eax),%ax
80105cfd:	66 85 c0             	test   %ax,%ax
80105d00:	7f 0c                	jg     80105d0e <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105d02:	c7 04 24 73 95 10 80 	movl   $0x80109573,(%esp)
80105d09:	e8 74 a8 ff ff       	call   80100582 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d11:	8b 40 50             	mov    0x50(%eax),%eax
80105d14:	66 83 f8 01          	cmp    $0x1,%ax
80105d18:	75 1f                	jne    80105d39 <sys_unlink+0x10c>
80105d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1d:	89 04 24             	mov    %eax,(%esp)
80105d20:	e8 9b fe ff ff       	call   80105bc0 <isdirempty>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	75 10                	jne    80105d39 <sys_unlink+0x10c>
    iunlockput(ip);
80105d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2c:	89 04 24             	mov    %eax,(%esp)
80105d2f:	e8 09 c0 ff ff       	call   80101d3d <iunlockput>
    goto bad;
80105d34:	e9 af 00 00 00       	jmp    80105de8 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105d39:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105d40:	00 
80105d41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d48:	00 
80105d49:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d4c:	89 04 24             	mov    %eax,(%esp)
80105d4f:	e8 4e f4 ff ff       	call   801051a2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d54:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d57:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105d5e:	00 
80105d5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d63:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6d:	89 04 24             	mov    %eax,(%esp)
80105d70:	e8 c4 c3 ff ff       	call   80102139 <writei>
80105d75:	83 f8 10             	cmp    $0x10,%eax
80105d78:	74 0c                	je     80105d86 <sys_unlink+0x159>
    panic("unlink: writei");
80105d7a:	c7 04 24 85 95 10 80 	movl   $0x80109585,(%esp)
80105d81:	e8 fc a7 ff ff       	call   80100582 <panic>
  if(ip->type == T_DIR){
80105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d89:	8b 40 50             	mov    0x50(%eax),%eax
80105d8c:	66 83 f8 01          	cmp    $0x1,%ax
80105d90:	75 1a                	jne    80105dac <sys_unlink+0x17f>
    dp->nlink--;
80105d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d95:	66 8b 40 56          	mov    0x56(%eax),%ax
80105d99:	48                   	dec    %eax
80105d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9d:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da4:	89 04 24             	mov    %eax,(%esp)
80105da7:	e8 cf bb ff ff       	call   8010197b <iupdate>
  }
  iunlockput(dp);
80105dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105daf:	89 04 24             	mov    %eax,(%esp)
80105db2:	e8 86 bf ff ff       	call   80101d3d <iunlockput>

  ip->nlink--;
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	66 8b 40 56          	mov    0x56(%eax),%ax
80105dbe:	48                   	dec    %eax
80105dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dc2:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc9:	89 04 24             	mov    %eax,(%esp)
80105dcc:	e8 aa bb ff ff       	call   8010197b <iupdate>
  iunlockput(ip);
80105dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd4:	89 04 24             	mov    %eax,(%esp)
80105dd7:	e8 61 bf ff ff       	call   80101d3d <iunlockput>

  end_op();
80105ddc:	e8 d8 d8 ff ff       	call   801036b9 <end_op>

  return 0;
80105de1:	b8 00 00 00 00       	mov    $0x0,%eax
80105de6:	eb 15                	jmp    80105dfd <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	89 04 24             	mov    %eax,(%esp)
80105dee:	e8 4a bf ff ff       	call   80101d3d <iunlockput>
  end_op();
80105df3:	e8 c1 d8 ff ff       	call   801036b9 <end_op>
  return -1;
80105df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfd:	c9                   	leave  
80105dfe:	c3                   	ret    

80105dff <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105dff:	55                   	push   %ebp
80105e00:	89 e5                	mov    %esp,%ebp
80105e02:	83 ec 48             	sub    $0x48,%esp
80105e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e08:	8b 55 10             	mov    0x10(%ebp),%edx
80105e0b:	8b 45 14             	mov    0x14(%ebp),%eax
80105e0e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e12:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e16:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e1a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e21:	8b 45 08             	mov    0x8(%ebp),%eax
80105e24:	89 04 24             	mov    %eax,(%esp)
80105e27:	e8 59 c8 ff ff       	call   80102685 <nameiparent>
80105e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e33:	75 0a                	jne    80105e3f <create+0x40>
    return 0;
80105e35:	b8 00 00 00 00       	mov    $0x0,%eax
80105e3a:	e9 79 01 00 00       	jmp    80105fb8 <create+0x1b9>
  ilock(dp);
80105e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e42:	89 04 24             	mov    %eax,(%esp)
80105e45:	e8 f4 bc ff ff       	call   80101b3e <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e51:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5b:	89 04 24             	mov    %eax,(%esp)
80105e5e:	e8 87 c4 ff ff       	call   801022ea <dirlookup>
80105e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e6a:	74 46                	je     80105eb2 <create+0xb3>
    iunlockput(dp);
80105e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6f:	89 04 24             	mov    %eax,(%esp)
80105e72:	e8 c6 be ff ff       	call   80101d3d <iunlockput>
    ilock(ip);
80105e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7a:	89 04 24             	mov    %eax,(%esp)
80105e7d:	e8 bc bc ff ff       	call   80101b3e <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e82:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e87:	75 14                	jne    80105e9d <create+0x9e>
80105e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8c:	8b 40 50             	mov    0x50(%eax),%eax
80105e8f:	66 83 f8 02          	cmp    $0x2,%ax
80105e93:	75 08                	jne    80105e9d <create+0x9e>
      return ip;
80105e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e98:	e9 1b 01 00 00       	jmp    80105fb8 <create+0x1b9>
    iunlockput(ip);
80105e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea0:	89 04 24             	mov    %eax,(%esp)
80105ea3:	e8 95 be ff ff       	call   80101d3d <iunlockput>
    return 0;
80105ea8:	b8 00 00 00 00       	mov    $0x0,%eax
80105ead:	e9 06 01 00 00       	jmp    80105fb8 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105eb2:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb9:	8b 00                	mov    (%eax),%eax
80105ebb:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ebf:	89 04 24             	mov    %eax,(%esp)
80105ec2:	e8 e2 b9 ff ff       	call   801018a9 <ialloc>
80105ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ece:	75 0c                	jne    80105edc <create+0xdd>
    panic("create: ialloc");
80105ed0:	c7 04 24 94 95 10 80 	movl   $0x80109594,(%esp)
80105ed7:	e8 a6 a6 ff ff       	call   80100582 <panic>

  ilock(ip);
80105edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edf:	89 04 24             	mov    %eax,(%esp)
80105ee2:	e8 57 bc ff ff       	call   80101b3e <ilock>
  ip->major = major;
80105ee7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105eea:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105eed:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105ef1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ef4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ef7:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105efe:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f07:	89 04 24             	mov    %eax,(%esp)
80105f0a:	e8 6c ba ff ff       	call   8010197b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105f0f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f14:	75 68                	jne    80105f7e <create+0x17f>
    dp->nlink++;  // for ".."
80105f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f19:	66 8b 40 56          	mov    0x56(%eax),%ax
80105f1d:	40                   	inc    %eax
80105f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f21:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f28:	89 04 24             	mov    %eax,(%esp)
80105f2b:	e8 4b ba ff ff       	call   8010197b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f33:	8b 40 04             	mov    0x4(%eax),%eax
80105f36:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f3a:	c7 44 24 04 6e 95 10 	movl   $0x8010956e,0x4(%esp)
80105f41:	80 
80105f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f45:	89 04 24             	mov    %eax,(%esp)
80105f48:	e8 63 c4 ff ff       	call   801023b0 <dirlink>
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	78 21                	js     80105f72 <create+0x173>
80105f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f54:	8b 40 04             	mov    0x4(%eax),%eax
80105f57:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f5b:	c7 44 24 04 70 95 10 	movl   $0x80109570,0x4(%esp)
80105f62:	80 
80105f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f66:	89 04 24             	mov    %eax,(%esp)
80105f69:	e8 42 c4 ff ff       	call   801023b0 <dirlink>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	79 0c                	jns    80105f7e <create+0x17f>
      panic("create dots");
80105f72:	c7 04 24 a3 95 10 80 	movl   $0x801095a3,(%esp)
80105f79:	e8 04 a6 ff ff       	call   80100582 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f81:	8b 40 04             	mov    0x4(%eax),%eax
80105f84:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f88:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f92:	89 04 24             	mov    %eax,(%esp)
80105f95:	e8 16 c4 ff ff       	call   801023b0 <dirlink>
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	79 0c                	jns    80105faa <create+0x1ab>
    panic("create: dirlink");
80105f9e:	c7 04 24 af 95 10 80 	movl   $0x801095af,(%esp)
80105fa5:	e8 d8 a5 ff ff       	call   80100582 <panic>

  iunlockput(dp);
80105faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fad:	89 04 24             	mov    %eax,(%esp)
80105fb0:	e8 88 bd ff ff       	call   80101d3d <iunlockput>

  return ip;
80105fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fb8:	c9                   	leave  
80105fb9:	c3                   	ret    

80105fba <sys_open>:

int
sys_open(void)
{
80105fba:	55                   	push   %ebp
80105fbb:	89 e5                	mov    %esp,%ebp
80105fbd:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fc0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fce:	e8 f1 f6 ff ff       	call   801056c4 <argstr>
80105fd3:	85 c0                	test   %eax,%eax
80105fd5:	78 17                	js     80105fee <sys_open+0x34>
80105fd7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fe5:	e8 43 f6 ff ff       	call   8010562d <argint>
80105fea:	85 c0                	test   %eax,%eax
80105fec:	79 0a                	jns    80105ff8 <sys_open+0x3e>
    return -1;
80105fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff3:	e9 5b 01 00 00       	jmp    80106153 <sys_open+0x199>

  begin_op();
80105ff8:	e8 3a d6 ff ff       	call   80103637 <begin_op>

  if(omode & O_CREATE){
80105ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106000:	25 00 02 00 00       	and    $0x200,%eax
80106005:	85 c0                	test   %eax,%eax
80106007:	74 3b                	je     80106044 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106009:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010600c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106013:	00 
80106014:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010601b:	00 
8010601c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106023:	00 
80106024:	89 04 24             	mov    %eax,(%esp)
80106027:	e8 d3 fd ff ff       	call   80105dff <create>
8010602c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010602f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106033:	75 6a                	jne    8010609f <sys_open+0xe5>
      end_op();
80106035:	e8 7f d6 ff ff       	call   801036b9 <end_op>
      return -1;
8010603a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603f:	e9 0f 01 00 00       	jmp    80106153 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80106044:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106047:	89 04 24             	mov    %eax,(%esp)
8010604a:	e8 14 c6 ff ff       	call   80102663 <namei>
8010604f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106056:	75 0f                	jne    80106067 <sys_open+0xad>
      end_op();
80106058:	e8 5c d6 ff ff       	call   801036b9 <end_op>
      return -1;
8010605d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106062:	e9 ec 00 00 00       	jmp    80106153 <sys_open+0x199>
    }
    ilock(ip);
80106067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606a:	89 04 24             	mov    %eax,(%esp)
8010606d:	e8 cc ba ff ff       	call   80101b3e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106075:	8b 40 50             	mov    0x50(%eax),%eax
80106078:	66 83 f8 01          	cmp    $0x1,%ax
8010607c:	75 21                	jne    8010609f <sys_open+0xe5>
8010607e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106081:	85 c0                	test   %eax,%eax
80106083:	74 1a                	je     8010609f <sys_open+0xe5>
      iunlockput(ip);
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	89 04 24             	mov    %eax,(%esp)
8010608b:	e8 ad bc ff ff       	call   80101d3d <iunlockput>
      end_op();
80106090:	e8 24 d6 ff ff       	call   801036b9 <end_op>
      return -1;
80106095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609a:	e9 b4 00 00 00       	jmp    80106153 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010609f:	e8 d8 b0 ff ff       	call   8010117c <filealloc>
801060a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ab:	74 14                	je     801060c1 <sys_open+0x107>
801060ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b0:	89 04 24             	mov    %eax,(%esp)
801060b3:	e8 40 f7 ff ff       	call   801057f8 <fdalloc>
801060b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060bf:	79 28                	jns    801060e9 <sys_open+0x12f>
    if(f)
801060c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c5:	74 0b                	je     801060d2 <sys_open+0x118>
      fileclose(f);
801060c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ca:	89 04 24             	mov    %eax,(%esp)
801060cd:	e8 52 b1 ff ff       	call   80101224 <fileclose>
    iunlockput(ip);
801060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d5:	89 04 24             	mov    %eax,(%esp)
801060d8:	e8 60 bc ff ff       	call   80101d3d <iunlockput>
    end_op();
801060dd:	e8 d7 d5 ff ff       	call   801036b9 <end_op>
    return -1;
801060e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e7:	eb 6a                	jmp    80106153 <sys_open+0x199>
  }
  iunlock(ip);
801060e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ec:	89 04 24             	mov    %eax,(%esp)
801060ef:	e8 54 bb ff ff       	call   80101c48 <iunlock>
  end_op();
801060f4:	e8 c0 d5 ff ff       	call   801036b9 <end_op>

  f->type = FD_INODE;
801060f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106102:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106108:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010610b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106118:	83 e0 01             	and    $0x1,%eax
8010611b:	85 c0                	test   %eax,%eax
8010611d:	0f 94 c0             	sete   %al
80106120:	88 c2                	mov    %al,%dl
80106122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106125:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010612b:	83 e0 01             	and    $0x1,%eax
8010612e:	85 c0                	test   %eax,%eax
80106130:	75 0a                	jne    8010613c <sys_open+0x182>
80106132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106135:	83 e0 02             	and    $0x2,%eax
80106138:	85 c0                	test   %eax,%eax
8010613a:	74 07                	je     80106143 <sys_open+0x189>
8010613c:	b8 01 00 00 00       	mov    $0x1,%eax
80106141:	eb 05                	jmp    80106148 <sys_open+0x18e>
80106143:	b8 00 00 00 00       	mov    $0x0,%eax
80106148:	88 c2                	mov    %al,%dl
8010614a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614d:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106150:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106153:	c9                   	leave  
80106154:	c3                   	ret    

80106155 <sys_mkdir>:

int
sys_mkdir(void)
{
80106155:	55                   	push   %ebp
80106156:	89 e5                	mov    %esp,%ebp
80106158:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010615b:	e8 d7 d4 ff ff       	call   80103637 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106160:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106163:	89 44 24 04          	mov    %eax,0x4(%esp)
80106167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010616e:	e8 51 f5 ff ff       	call   801056c4 <argstr>
80106173:	85 c0                	test   %eax,%eax
80106175:	78 2c                	js     801061a3 <sys_mkdir+0x4e>
80106177:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106181:	00 
80106182:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106189:	00 
8010618a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106191:	00 
80106192:	89 04 24             	mov    %eax,(%esp)
80106195:	e8 65 fc ff ff       	call   80105dff <create>
8010619a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010619d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061a1:	75 0c                	jne    801061af <sys_mkdir+0x5a>
    end_op();
801061a3:	e8 11 d5 ff ff       	call   801036b9 <end_op>
    return -1;
801061a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ad:	eb 15                	jmp    801061c4 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	89 04 24             	mov    %eax,(%esp)
801061b5:	e8 83 bb ff ff       	call   80101d3d <iunlockput>
  end_op();
801061ba:	e8 fa d4 ff ff       	call   801036b9 <end_op>
  return 0;
801061bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061c4:	c9                   	leave  
801061c5:	c3                   	ret    

801061c6 <sys_mknod>:

int
sys_mknod(void)
{
801061c6:	55                   	push   %ebp
801061c7:	89 e5                	mov    %esp,%ebp
801061c9:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801061cc:	e8 66 d4 ff ff       	call   80103637 <begin_op>
  if((argstr(0, &path)) < 0 ||
801061d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061df:	e8 e0 f4 ff ff       	call   801056c4 <argstr>
801061e4:	85 c0                	test   %eax,%eax
801061e6:	78 5e                	js     80106246 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801061e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801061ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061f6:	e8 32 f4 ff ff       	call   8010562d <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801061fb:	85 c0                	test   %eax,%eax
801061fd:	78 47                	js     80106246 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801061ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106202:	89 44 24 04          	mov    %eax,0x4(%esp)
80106206:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010620d:	e8 1b f4 ff ff       	call   8010562d <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106212:	85 c0                	test   %eax,%eax
80106214:	78 30                	js     80106246 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106216:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106219:	0f bf c8             	movswl %ax,%ecx
8010621c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010621f:	0f bf d0             	movswl %ax,%edx
80106222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106225:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106229:	89 54 24 08          	mov    %edx,0x8(%esp)
8010622d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106234:	00 
80106235:	89 04 24             	mov    %eax,(%esp)
80106238:	e8 c2 fb ff ff       	call   80105dff <create>
8010623d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106244:	75 0c                	jne    80106252 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106246:	e8 6e d4 ff ff       	call   801036b9 <end_op>
    return -1;
8010624b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106250:	eb 15                	jmp    80106267 <sys_mknod+0xa1>
  }
  iunlockput(ip);
80106252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106255:	89 04 24             	mov    %eax,(%esp)
80106258:	e8 e0 ba ff ff       	call   80101d3d <iunlockput>
  end_op();
8010625d:	e8 57 d4 ff ff       	call   801036b9 <end_op>
  return 0;
80106262:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106267:	c9                   	leave  
80106268:	c3                   	ret    

80106269 <sys_chdir>:

int
sys_chdir(void)
{
80106269:	55                   	push   %ebp
8010626a:	89 e5                	mov    %esp,%ebp
8010626c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010626f:	e8 bb e0 ff ff       	call   8010432f <myproc>
80106274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106277:	e8 bb d3 ff ff       	call   80103637 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010627c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010627f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010628a:	e8 35 f4 ff ff       	call   801056c4 <argstr>
8010628f:	85 c0                	test   %eax,%eax
80106291:	78 14                	js     801062a7 <sys_chdir+0x3e>
80106293:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106296:	89 04 24             	mov    %eax,(%esp)
80106299:	e8 c5 c3 ff ff       	call   80102663 <namei>
8010629e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062a5:	75 0c                	jne    801062b3 <sys_chdir+0x4a>
    end_op();
801062a7:	e8 0d d4 ff ff       	call   801036b9 <end_op>
    return -1;
801062ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b1:	eb 5a                	jmp    8010630d <sys_chdir+0xa4>
  }
  ilock(ip);
801062b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b6:	89 04 24             	mov    %eax,(%esp)
801062b9:	e8 80 b8 ff ff       	call   80101b3e <ilock>
  if(ip->type != T_DIR){
801062be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c1:	8b 40 50             	mov    0x50(%eax),%eax
801062c4:	66 83 f8 01          	cmp    $0x1,%ax
801062c8:	74 17                	je     801062e1 <sys_chdir+0x78>
    iunlockput(ip);
801062ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062cd:	89 04 24             	mov    %eax,(%esp)
801062d0:	e8 68 ba ff ff       	call   80101d3d <iunlockput>
    end_op();
801062d5:	e8 df d3 ff ff       	call   801036b9 <end_op>
    return -1;
801062da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062df:	eb 2c                	jmp    8010630d <sys_chdir+0xa4>
  }
  iunlock(ip);
801062e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e4:	89 04 24             	mov    %eax,(%esp)
801062e7:	e8 5c b9 ff ff       	call   80101c48 <iunlock>
  iput(curproc->cwd);
801062ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ef:	8b 40 68             	mov    0x68(%eax),%eax
801062f2:	89 04 24             	mov    %eax,(%esp)
801062f5:	e8 92 b9 ff ff       	call   80101c8c <iput>
  end_op();
801062fa:	e8 ba d3 ff ff       	call   801036b9 <end_op>
  curproc->cwd = ip;
801062ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106302:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106305:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106308:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010630d:	c9                   	leave  
8010630e:	c3                   	ret    

8010630f <sys_exec>:

int
sys_exec(void)
{
8010630f:	55                   	push   %ebp
80106310:	89 e5                	mov    %esp,%ebp
80106312:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106318:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010631b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010631f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106326:	e8 99 f3 ff ff       	call   801056c4 <argstr>
8010632b:	85 c0                	test   %eax,%eax
8010632d:	78 1a                	js     80106349 <sys_exec+0x3a>
8010632f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106335:	89 44 24 04          	mov    %eax,0x4(%esp)
80106339:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106340:	e8 e8 f2 ff ff       	call   8010562d <argint>
80106345:	85 c0                	test   %eax,%eax
80106347:	79 0a                	jns    80106353 <sys_exec+0x44>
    return -1;
80106349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634e:	e9 c7 00 00 00       	jmp    8010641a <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106353:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010635a:	00 
8010635b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106362:	00 
80106363:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106369:	89 04 24             	mov    %eax,(%esp)
8010636c:	e8 31 ee ff ff       	call   801051a2 <memset>
  for(i=0;; i++){
80106371:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637b:	83 f8 1f             	cmp    $0x1f,%eax
8010637e:	76 0a                	jbe    8010638a <sys_exec+0x7b>
      return -1;
80106380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106385:	e9 90 00 00 00       	jmp    8010641a <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010638a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638d:	c1 e0 02             	shl    $0x2,%eax
80106390:	89 c2                	mov    %eax,%edx
80106392:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106398:	01 c2                	add    %eax,%edx
8010639a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801063a4:	89 14 24             	mov    %edx,(%esp)
801063a7:	e8 e0 f1 ff ff       	call   8010558c <fetchint>
801063ac:	85 c0                	test   %eax,%eax
801063ae:	79 07                	jns    801063b7 <sys_exec+0xa8>
      return -1;
801063b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b5:	eb 63                	jmp    8010641a <sys_exec+0x10b>
    if(uarg == 0){
801063b7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063bd:	85 c0                	test   %eax,%eax
801063bf:	75 26                	jne    801063e7 <sys_exec+0xd8>
      argv[i] = 0;
801063c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063cb:	00 00 00 00 
      break;
801063cf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d3:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801063dd:	89 04 24             	mov    %eax,(%esp)
801063e0:	e8 3b a9 ff ff       	call   80100d20 <exec>
801063e5:	eb 33                	jmp    8010641a <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801063e7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801063ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063f0:	c1 e2 02             	shl    $0x2,%edx
801063f3:	01 c2                	add    %eax,%edx
801063f5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801063ff:	89 04 24             	mov    %eax,(%esp)
80106402:	e8 c4 f1 ff ff       	call   801055cb <fetchstr>
80106407:	85 c0                	test   %eax,%eax
80106409:	79 07                	jns    80106412 <sys_exec+0x103>
      return -1;
8010640b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106410:	eb 08                	jmp    8010641a <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106412:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106415:	e9 5e ff ff ff       	jmp    80106378 <sys_exec+0x69>
  return exec(path, argv);
}
8010641a:	c9                   	leave  
8010641b:	c3                   	ret    

8010641c <sys_pipe>:

int
sys_pipe(void)
{
8010641c:	55                   	push   %ebp
8010641d:	89 e5                	mov    %esp,%ebp
8010641f:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106422:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106429:	00 
8010642a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010642d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106431:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106438:	e8 1d f2 ff ff       	call   8010565a <argptr>
8010643d:	85 c0                	test   %eax,%eax
8010643f:	79 0a                	jns    8010644b <sys_pipe+0x2f>
    return -1;
80106441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106446:	e9 9a 00 00 00       	jmp    801064e5 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
8010644b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010644e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106452:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106455:	89 04 24             	mov    %eax,(%esp)
80106458:	e8 27 da ff ff       	call   80103e84 <pipealloc>
8010645d:	85 c0                	test   %eax,%eax
8010645f:	79 07                	jns    80106468 <sys_pipe+0x4c>
    return -1;
80106461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106466:	eb 7d                	jmp    801064e5 <sys_pipe+0xc9>
  fd0 = -1;
80106468:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010646f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106472:	89 04 24             	mov    %eax,(%esp)
80106475:	e8 7e f3 ff ff       	call   801057f8 <fdalloc>
8010647a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010647d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106481:	78 14                	js     80106497 <sys_pipe+0x7b>
80106483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106486:	89 04 24             	mov    %eax,(%esp)
80106489:	e8 6a f3 ff ff       	call   801057f8 <fdalloc>
8010648e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106495:	79 36                	jns    801064cd <sys_pipe+0xb1>
    if(fd0 >= 0)
80106497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010649b:	78 13                	js     801064b0 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
8010649d:	e8 8d de ff ff       	call   8010432f <myproc>
801064a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064a5:	83 c2 08             	add    $0x8,%edx
801064a8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064af:	00 
    fileclose(rf);
801064b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064b3:	89 04 24             	mov    %eax,(%esp)
801064b6:	e8 69 ad ff ff       	call   80101224 <fileclose>
    fileclose(wf);
801064bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064be:	89 04 24             	mov    %eax,(%esp)
801064c1:	e8 5e ad ff ff       	call   80101224 <fileclose>
    return -1;
801064c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cb:	eb 18                	jmp    801064e5 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
801064cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064d3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801064d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064d8:	8d 50 04             	lea    0x4(%eax),%edx
801064db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064de:	89 02                	mov    %eax,(%edx)
  return 0;
801064e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    

801064e7 <name_of_inode>:

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
801064e7:	55                   	push   %ebp
801064e8:	89 e5                	mov    %esp,%ebp
801064ea:	83 ec 38             	sub    $0x38,%esp
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
801064ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801064f4:	eb 6a                	jmp    80106560 <name_of_inode+0x79>
        if (readi(parent, (char*)&de, off, sizeof(de)) != sizeof(de))
801064f6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801064fd:	00 
801064fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106501:	89 44 24 08          	mov    %eax,0x8(%esp)
80106505:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010650c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010650f:	89 04 24             	mov    %eax,(%esp)
80106512:	e8 be ba ff ff       	call   80101fd5 <readi>
80106517:	83 f8 10             	cmp    $0x10,%eax
8010651a:	74 0c                	je     80106528 <name_of_inode+0x41>
            panic("couldn't read dir entry");
8010651c:	c7 04 24 bf 95 10 80 	movl   $0x801095bf,(%esp)
80106523:	e8 5a a0 ff ff       	call   80100582 <panic>
        if (de.inum == ip->inum) {
80106528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010652b:	0f b7 d0             	movzwl %ax,%edx
8010652e:	8b 45 08             	mov    0x8(%ebp),%eax
80106531:	8b 40 04             	mov    0x4(%eax),%eax
80106534:	39 c2                	cmp    %eax,%edx
80106536:	75 24                	jne    8010655c <name_of_inode+0x75>
            safestrcpy(buf, de.name, DIRSIZ);
80106538:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010653f:	00 
80106540:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106543:	83 c0 02             	add    $0x2,%eax
80106546:	89 44 24 04          	mov    %eax,0x4(%esp)
8010654a:	8b 45 10             	mov    0x10(%ebp),%eax
8010654d:	89 04 24             	mov    %eax,(%esp)
80106550:	e8 59 ee ff ff       	call   801053ae <safestrcpy>
            return 0;
80106555:	b8 00 00 00 00       	mov    $0x0,%eax
8010655a:	eb 14                	jmp    80106570 <name_of_inode+0x89>

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
8010655c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80106560:	8b 45 0c             	mov    0xc(%ebp),%eax
80106563:	8b 40 58             	mov    0x58(%eax),%eax
80106566:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106569:	77 8b                	ja     801064f6 <name_of_inode+0xf>
        if (de.inum == ip->inum) {
            safestrcpy(buf, de.name, DIRSIZ);
            return 0;
        }
    }
    return -1;
8010656b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106570:	c9                   	leave  
80106571:	c3                   	ret    

80106572 <name_for_inode>:

int
name_for_inode(char* buf, int n, struct inode *ip) {
80106572:	55                   	push   %ebp
80106573:	89 e5                	mov    %esp,%ebp
80106575:	53                   	push   %ebx
80106576:	83 ec 34             	sub    $0x34,%esp
    int path_offset;
    struct inode *parent;
    char node_name[DIRSIZ];
    if (ip->inum == namei("/")->inum) { //namei is inefficient but iget isn't exported for some reason
80106579:	8b 45 10             	mov    0x10(%ebp),%eax
8010657c:	8b 58 04             	mov    0x4(%eax),%ebx
8010657f:	c7 04 24 d7 95 10 80 	movl   $0x801095d7,(%esp)
80106586:	e8 d8 c0 ff ff       	call   80102663 <namei>
8010658b:	8b 40 04             	mov    0x4(%eax),%eax
8010658e:	39 c3                	cmp    %eax,%ebx
80106590:	75 10                	jne    801065a2 <name_for_inode+0x30>
        buf[0] = '/';
80106592:	8b 45 08             	mov    0x8(%ebp),%eax
80106595:	c6 00 2f             	movb   $0x2f,(%eax)
        return 1;
80106598:	b8 01 00 00 00       	mov    $0x1,%eax
8010659d:	e9 1d 01 00 00       	jmp    801066bf <name_for_inode+0x14d>
    } else if (ip->type == T_DIR) {
801065a2:	8b 45 10             	mov    0x10(%ebp),%eax
801065a5:	8b 40 50             	mov    0x50(%eax),%eax
801065a8:	66 83 f8 01          	cmp    $0x1,%ax
801065ac:	0f 85 dd 00 00 00    	jne    8010668f <name_for_inode+0x11d>
        parent = dirlookup(ip, "..", 0);
801065b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801065b9:	00 
801065ba:	c7 44 24 04 70 95 10 	movl   $0x80109570,0x4(%esp)
801065c1:	80 
801065c2:	8b 45 10             	mov    0x10(%ebp),%eax
801065c5:	89 04 24             	mov    %eax,(%esp)
801065c8:	e8 1d bd ff ff       	call   801022ea <dirlookup>
801065cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ilock(parent);
801065d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d3:	89 04 24             	mov    %eax,(%esp)
801065d6:	e8 63 b5 ff ff       	call   80101b3e <ilock>
        if (name_of_inode(ip, parent, node_name)) {
801065db:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801065de:	89 44 24 08          	mov    %eax,0x8(%esp)
801065e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801065e9:	8b 45 10             	mov    0x10(%ebp),%eax
801065ec:	89 04 24             	mov    %eax,(%esp)
801065ef:	e8 f3 fe ff ff       	call   801064e7 <name_of_inode>
801065f4:	85 c0                	test   %eax,%eax
801065f6:	74 0c                	je     80106604 <name_for_inode+0x92>
            panic("could not find name of inode in parent!");
801065f8:	c7 04 24 dc 95 10 80 	movl   $0x801095dc,(%esp)
801065ff:	e8 7e 9f ff ff       	call   80100582 <panic>
        }
        path_offset = name_for_inode(buf, n, parent);
80106604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106607:	89 44 24 08          	mov    %eax,0x8(%esp)
8010660b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010660e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106612:	8b 45 08             	mov    0x8(%ebp),%eax
80106615:	89 04 24             	mov    %eax,(%esp)
80106618:	e8 55 ff ff ff       	call   80106572 <name_for_inode>
8010661d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        safestrcpy(buf + path_offset, node_name, n - path_offset);
80106620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106623:	8b 55 0c             	mov    0xc(%ebp),%edx
80106626:	29 c2                	sub    %eax,%edx
80106628:	89 d0                	mov    %edx,%eax
8010662a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010662d:	8b 55 08             	mov    0x8(%ebp),%edx
80106630:	01 ca                	add    %ecx,%edx
80106632:	89 44 24 08          	mov    %eax,0x8(%esp)
80106636:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106639:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663d:	89 14 24             	mov    %edx,(%esp)
80106640:	e8 69 ed ff ff       	call   801053ae <safestrcpy>
        path_offset += strlen(node_name);
80106645:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106648:	89 04 24             	mov    %eax,(%esp)
8010664b:	e8 a5 ed ff ff       	call   801053f5 <strlen>
80106650:	01 45 f0             	add    %eax,-0x10(%ebp)
        if (path_offset == n - 1) {
80106653:	8b 45 0c             	mov    0xc(%ebp),%eax
80106656:	48                   	dec    %eax
80106657:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010665a:	75 10                	jne    8010666c <name_for_inode+0xfa>
            buf[path_offset] = '\0';
8010665c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010665f:	8b 45 08             	mov    0x8(%ebp),%eax
80106662:	01 d0                	add    %edx,%eax
80106664:	c6 00 00             	movb   $0x0,(%eax)
            return n;
80106667:	8b 45 0c             	mov    0xc(%ebp),%eax
8010666a:	eb 53                	jmp    801066bf <name_for_inode+0x14d>
        } else {
            buf[path_offset++] = '/';
8010666c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010666f:	8d 50 01             	lea    0x1(%eax),%edx
80106672:	89 55 f0             	mov    %edx,-0x10(%ebp)
80106675:	89 c2                	mov    %eax,%edx
80106677:	8b 45 08             	mov    0x8(%ebp),%eax
8010667a:	01 d0                	add    %edx,%eax
8010667c:	c6 00 2f             	movb   $0x2f,(%eax)
        }
        iput(parent); //free
8010667f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106682:	89 04 24             	mov    %eax,(%esp)
80106685:	e8 02 b6 ff ff       	call   80101c8c <iput>
        return path_offset;
8010668a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010668d:	eb 30                	jmp    801066bf <name_for_inode+0x14d>
    } else if (ip->type == T_DEV || ip->type == T_FILE) {
8010668f:	8b 45 10             	mov    0x10(%ebp),%eax
80106692:	8b 40 50             	mov    0x50(%eax),%eax
80106695:	66 83 f8 03          	cmp    $0x3,%ax
80106699:	74 0c                	je     801066a7 <name_for_inode+0x135>
8010669b:	8b 45 10             	mov    0x10(%ebp),%eax
8010669e:	8b 40 50             	mov    0x50(%eax),%eax
801066a1:	66 83 f8 02          	cmp    $0x2,%ax
801066a5:	75 0c                	jne    801066b3 <name_for_inode+0x141>
        panic("process cwd is a device node / file, not a directory!");
801066a7:	c7 04 24 04 96 10 80 	movl   $0x80109604,(%esp)
801066ae:	e8 cf 9e ff ff       	call   80100582 <panic>
    } else {
        panic("unknown inode type");
801066b3:	c7 04 24 3a 96 10 80 	movl   $0x8010963a,(%esp)
801066ba:	e8 c3 9e ff ff       	call   80100582 <panic>
    }
}
801066bf:	83 c4 34             	add    $0x34,%esp
801066c2:	5b                   	pop    %ebx
801066c3:	5d                   	pop    %ebp
801066c4:	c3                   	ret    

801066c5 <sys_getcwd>:

int
sys_getcwd(void)
{
801066c5:	55                   	push   %ebp
801066c6:	89 e5                	mov    %esp,%ebp
801066c8:	83 ec 28             	sub    $0x28,%esp
    char *p;
    int n;
    if(argint(1, &n) < 0 || argptr(0, &p, n) < 0)
801066cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801066d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801066d9:	e8 4f ef ff ff       	call   8010562d <argint>
801066de:	85 c0                	test   %eax,%eax
801066e0:	78 1e                	js     80106700 <sys_getcwd+0x3b>
801066e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801066e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801066f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066f7:	e8 5e ef ff ff       	call   8010565a <argptr>
801066fc:	85 c0                	test   %eax,%eax
801066fe:	79 07                	jns    80106707 <sys_getcwd+0x42>
        return -1;
80106700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106705:	eb 1e                	jmp    80106725 <sys_getcwd+0x60>
    return name_for_inode(p, n, myproc()->cwd);
80106707:	e8 23 dc ff ff       	call   8010432f <myproc>
8010670c:	8b 48 68             	mov    0x68(%eax),%ecx
8010670f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106715:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106719:	89 54 24 04          	mov    %edx,0x4(%esp)
8010671d:	89 04 24             	mov    %eax,(%esp)
80106720:	e8 4d fe ff ff       	call   80106572 <name_for_inode>
}
80106725:	c9                   	leave  
80106726:	c3                   	ret    
	...

80106728 <sys_fork>:
#include "container.h"


int
sys_fork(void)
{
80106728:	55                   	push   %ebp
80106729:	89 e5                	mov    %esp,%ebp
8010672b:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010672e:	e8 f8 de ff ff       	call   8010462b <fork>
}
80106733:	c9                   	leave  
80106734:	c3                   	ret    

80106735 <sys_exit>:

int
sys_exit(void)
{
80106735:	55                   	push   %ebp
80106736:	89 e5                	mov    %esp,%ebp
80106738:	83 ec 08             	sub    $0x8,%esp
  exit();
8010673b:	e8 51 e0 ff ff       	call   80104791 <exit>
  return 0;  // not reached
80106740:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106745:	c9                   	leave  
80106746:	c3                   	ret    

80106747 <sys_wait>:

int
sys_wait(void)
{
80106747:	55                   	push   %ebp
80106748:	89 e5                	mov    %esp,%ebp
8010674a:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010674d:	e8 48 e1 ff ff       	call   8010489a <wait>
}
80106752:	c9                   	leave  
80106753:	c3                   	ret    

80106754 <sys_kill>:

int
sys_kill(void)
{
80106754:	55                   	push   %ebp
80106755:	89 e5                	mov    %esp,%ebp
80106757:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010675a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010675d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106761:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106768:	e8 c0 ee ff ff       	call   8010562d <argint>
8010676d:	85 c0                	test   %eax,%eax
8010676f:	79 07                	jns    80106778 <sys_kill+0x24>
    return -1;
80106771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106776:	eb 0b                	jmp    80106783 <sys_kill+0x2f>
  return kill(pid);
80106778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677b:	89 04 24             	mov    %eax,(%esp)
8010677e:	e8 ec e4 ff ff       	call   80104c6f <kill>
}
80106783:	c9                   	leave  
80106784:	c3                   	ret    

80106785 <sys_getpid>:

int
sys_getpid(void)
{
80106785:	55                   	push   %ebp
80106786:	89 e5                	mov    %esp,%ebp
80106788:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010678b:	e8 9f db ff ff       	call   8010432f <myproc>
80106790:	8b 40 10             	mov    0x10(%eax),%eax
}
80106793:	c9                   	leave  
80106794:	c3                   	ret    

80106795 <sys_sbrk>:

int
sys_sbrk(void)
{
80106795:	55                   	push   %ebp
80106796:	89 e5                	mov    %esp,%ebp
80106798:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010679b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010679e:	89 44 24 04          	mov    %eax,0x4(%esp)
801067a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067a9:	e8 7f ee ff ff       	call   8010562d <argint>
801067ae:	85 c0                	test   %eax,%eax
801067b0:	79 07                	jns    801067b9 <sys_sbrk+0x24>
    return -1;
801067b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b7:	eb 23                	jmp    801067dc <sys_sbrk+0x47>
  addr = myproc()->sz;
801067b9:	e8 71 db ff ff       	call   8010432f <myproc>
801067be:	8b 00                	mov    (%eax),%eax
801067c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801067c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c6:	89 04 24             	mov    %eax,(%esp)
801067c9:	e8 bf dd ff ff       	call   8010458d <growproc>
801067ce:	85 c0                	test   %eax,%eax
801067d0:	79 07                	jns    801067d9 <sys_sbrk+0x44>
    return -1;
801067d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d7:	eb 03                	jmp    801067dc <sys_sbrk+0x47>
  return addr;
801067d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067dc:	c9                   	leave  
801067dd:	c3                   	ret    

801067de <sys_sleep>:

int
sys_sleep(void)
{
801067de:	55                   	push   %ebp
801067df:	89 e5                	mov    %esp,%ebp
801067e1:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801067eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067f2:	e8 36 ee ff ff       	call   8010562d <argint>
801067f7:	85 c0                	test   %eax,%eax
801067f9:	79 07                	jns    80106802 <sys_sleep+0x24>
    return -1;
801067fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106800:	eb 6b                	jmp    8010686d <sys_sleep+0x8f>
  acquire(&tickslock);
80106802:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106809:	e8 31 e7 ff ff       	call   80104f3f <acquire>
  ticks0 = ticks;
8010680e:	a1 e0 79 11 80       	mov    0x801179e0,%eax
80106813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106816:	eb 33                	jmp    8010684b <sys_sleep+0x6d>
    if(myproc()->killed){
80106818:	e8 12 db ff ff       	call   8010432f <myproc>
8010681d:	8b 40 24             	mov    0x24(%eax),%eax
80106820:	85 c0                	test   %eax,%eax
80106822:	74 13                	je     80106837 <sys_sleep+0x59>
      release(&tickslock);
80106824:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
8010682b:	e8 79 e7 ff ff       	call   80104fa9 <release>
      return -1;
80106830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106835:	eb 36                	jmp    8010686d <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
80106837:	c7 44 24 04 a0 71 11 	movl   $0x801171a0,0x4(%esp)
8010683e:	80 
8010683f:	c7 04 24 e0 79 11 80 	movl   $0x801179e0,(%esp)
80106846:	e8 25 e3 ff ff       	call   80104b70 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010684b:	a1 e0 79 11 80       	mov    0x801179e0,%eax
80106850:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106853:	89 c2                	mov    %eax,%edx
80106855:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106858:	39 c2                	cmp    %eax,%edx
8010685a:	72 bc                	jb     80106818 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010685c:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106863:	e8 41 e7 ff ff       	call   80104fa9 <release>
  return 0;
80106868:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010686d:	c9                   	leave  
8010686e:	c3                   	ret    

8010686f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010686f:	55                   	push   %ebp
80106870:	89 e5                	mov    %esp,%ebp
80106872:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106875:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
8010687c:	e8 be e6 ff ff       	call   80104f3f <acquire>
  xticks = ticks;
80106881:	a1 e0 79 11 80       	mov    0x801179e0,%eax
80106886:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106889:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106890:	e8 14 e7 ff ff       	call   80104fa9 <release>
  return xticks;
80106895:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106898:	c9                   	leave  
80106899:	c3                   	ret    

8010689a <sys_getname>:

int
sys_getname(void)
{
8010689a:	55                   	push   %ebp
8010689b:	89 e5                	mov    %esp,%ebp
8010689d:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801068a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068ae:	e8 7a ed ff ff       	call   8010562d <argint>
801068b3:	85 c0                	test   %eax,%eax
801068b5:	78 17                	js     801068ce <sys_getname+0x34>
801068b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801068be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801068c5:	e8 fa ed ff ff       	call   801056c4 <argstr>
801068ca:	85 c0                	test   %eax,%eax
801068cc:	79 07                	jns    801068d5 <sys_getname+0x3b>
    return -1;
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	eb 12                	jmp    801068e7 <sys_getname+0x4d>
  }

  return getname(index, name);
801068d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801068d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068db:	89 54 24 04          	mov    %edx,0x4(%esp)
801068df:	89 04 24             	mov    %eax,(%esp)
801068e2:	e8 bd 22 00 00       	call   80108ba4 <getname>
}
801068e7:	c9                   	leave  
801068e8:	c3                   	ret    

801068e9 <sys_setname>:

int
sys_setname(void)
{
801068e9:	55                   	push   %ebp
801068ea:	89 e5                	mov    %esp,%ebp
801068ec:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801068ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801068f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068fd:	e8 2b ed ff ff       	call   8010562d <argint>
80106902:	85 c0                	test   %eax,%eax
80106904:	78 17                	js     8010691d <sys_setname+0x34>
80106906:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106909:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106914:	e8 ab ed ff ff       	call   801056c4 <argstr>
80106919:	85 c0                	test   %eax,%eax
8010691b:	79 07                	jns    80106924 <sys_setname+0x3b>
    return -1;
8010691d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106922:	eb 12                	jmp    80106936 <sys_setname+0x4d>
  }

  return setname(index, name);
80106924:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010692a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010692e:	89 04 24             	mov    %eax,(%esp)
80106931:	e8 b7 22 00 00       	call   80108bed <setname>
}
80106936:	c9                   	leave  
80106937:	c3                   	ret    

80106938 <sys_getmaxproc>:

int
sys_getmaxproc(void)
{
80106938:	55                   	push   %ebp
80106939:	89 e5                	mov    %esp,%ebp
8010693b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
8010693e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106941:	89 44 24 04          	mov    %eax,0x4(%esp)
80106945:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010694c:	e8 dc ec ff ff       	call   8010562d <argint>
80106951:	85 c0                	test   %eax,%eax
80106953:	79 07                	jns    8010695c <sys_getmaxproc+0x24>
    return -1;
80106955:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695a:	eb 0b                	jmp    80106967 <sys_getmaxproc+0x2f>
  }

  return getmaxproc(index);
8010695c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695f:	89 04 24             	mov    %eax,(%esp)
80106962:	e8 e2 22 00 00       	call   80108c49 <getmaxproc>
}
80106967:	c9                   	leave  
80106968:	c3                   	ret    

80106969 <sys_setmaxproc>:

int
sys_setmaxproc(void)
{
80106969:	55                   	push   %ebp
8010696a:	89 e5                	mov    %esp,%ebp
8010696c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
8010696f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106972:	89 44 24 04          	mov    %eax,0x4(%esp)
80106976:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010697d:	e8 ab ec ff ff       	call   8010562d <argint>
80106982:	85 c0                	test   %eax,%eax
80106984:	78 17                	js     8010699d <sys_setmaxproc+0x34>
80106986:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106989:	89 44 24 04          	mov    %eax,0x4(%esp)
8010698d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106994:	e8 94 ec ff ff       	call   8010562d <argint>
80106999:	85 c0                	test   %eax,%eax
8010699b:	74 07                	je     801069a4 <sys_setmaxproc+0x3b>
    return -1;
8010699d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a2:	eb 12                	jmp    801069b6 <sys_setmaxproc+0x4d>
  }

  return setmaxproc(index, max);
801069a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801069ae:	89 04 24             	mov    %eax,(%esp)
801069b1:	e8 ac 22 00 00       	call   80108c62 <setmaxproc>
}
801069b6:	c9                   	leave  
801069b7:	c3                   	ret    

801069b8 <sys_getmaxmem>:

int
sys_getmaxmem(void)
{
801069b8:	55                   	push   %ebp
801069b9:	89 e5                	mov    %esp,%ebp
801069bb:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
801069be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801069c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069cc:	e8 5c ec ff ff       	call   8010562d <argint>
801069d1:	85 c0                	test   %eax,%eax
801069d3:	79 07                	jns    801069dc <sys_getmaxmem+0x24>
    return -1;
801069d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069da:	eb 0b                	jmp    801069e7 <sys_getmaxmem+0x2f>
  }

  return getmaxmem(index);
801069dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069df:	89 04 24             	mov    %eax,(%esp)
801069e2:	e8 9d 22 00 00       	call   80108c84 <getmaxmem>
}
801069e7:	c9                   	leave  
801069e8:	c3                   	ret    

801069e9 <sys_setmaxmem>:

int
sys_setmaxmem(void)
{
801069e9:	55                   	push   %ebp
801069ea:	89 e5                	mov    %esp,%ebp
801069ec:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
801069ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069fd:	e8 2b ec ff ff       	call   8010562d <argint>
80106a02:	85 c0                	test   %eax,%eax
80106a04:	78 17                	js     80106a1d <sys_setmaxmem+0x34>
80106a06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a14:	e8 14 ec ff ff       	call   8010562d <argint>
80106a19:	85 c0                	test   %eax,%eax
80106a1b:	74 07                	je     80106a24 <sys_setmaxmem+0x3b>
    return -1;
80106a1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a22:	eb 12                	jmp    80106a36 <sys_setmaxmem+0x4d>
  }

  return setmaxmem(index, max);
80106a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a2e:	89 04 24             	mov    %eax,(%esp)
80106a31:	e8 67 22 00 00       	call   80108c9d <setmaxmem>
}
80106a36:	c9                   	leave  
80106a37:	c3                   	ret    

80106a38 <sys_getmaxdisk>:

int
sys_getmaxdisk(void)
{
80106a38:	55                   	push   %ebp
80106a39:	89 e5                	mov    %esp,%ebp
80106a3b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106a3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a4c:	e8 dc eb ff ff       	call   8010562d <argint>
80106a51:	85 c0                	test   %eax,%eax
80106a53:	79 07                	jns    80106a5c <sys_getmaxdisk+0x24>
    return -1;
80106a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a5a:	eb 0b                	jmp    80106a67 <sys_getmaxdisk+0x2f>
  }

  return getmaxdisk(index);
80106a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a5f:	89 04 24             	mov    %eax,(%esp)
80106a62:	e8 58 22 00 00       	call   80108cbf <getmaxdisk>
}
80106a67:	c9                   	leave  
80106a68:	c3                   	ret    

80106a69 <sys_setmaxdisk>:

int
sys_setmaxdisk(void)
{
80106a69:	55                   	push   %ebp
80106a6a:	89 e5                	mov    %esp,%ebp
80106a6c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a7d:	e8 ab eb ff ff       	call   8010562d <argint>
80106a82:	85 c0                	test   %eax,%eax
80106a84:	78 17                	js     80106a9d <sys_setmaxdisk+0x34>
80106a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a94:	e8 94 eb ff ff       	call   8010562d <argint>
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	74 07                	je     80106aa4 <sys_setmaxdisk+0x3b>
    return -1;
80106a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa2:	eb 12                	jmp    80106ab6 <sys_setmaxdisk+0x4d>
  }

  return setmaxdisk(index, max);
80106aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aae:	89 04 24             	mov    %eax,(%esp)
80106ab1:	e8 21 22 00 00       	call   80108cd7 <setmaxdisk>
}
80106ab6:	c9                   	leave  
80106ab7:	c3                   	ret    

80106ab8 <sys_getusedmem>:

int
sys_getusedmem(void)
{
80106ab8:	55                   	push   %ebp
80106ab9:	89 e5                	mov    %esp,%ebp
80106abb:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106abe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ac5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106acc:	e8 5c eb ff ff       	call   8010562d <argint>
80106ad1:	85 c0                	test   %eax,%eax
80106ad3:	79 07                	jns    80106adc <sys_getusedmem+0x24>
    return -1;
80106ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ada:	eb 0b                	jmp    80106ae7 <sys_getusedmem+0x2f>
  }

  return getusedmem(index);
80106adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106adf:	89 04 24             	mov    %eax,(%esp)
80106ae2:	e8 11 22 00 00       	call   80108cf8 <getusedmem>
}
80106ae7:	c9                   	leave  
80106ae8:	c3                   	ret    

80106ae9 <sys_setusedmem>:

int
sys_setusedmem(void)
{
80106ae9:	55                   	push   %ebp
80106aea:	89 e5                	mov    %esp,%ebp
80106aec:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106af2:	89 44 24 04          	mov    %eax,0x4(%esp)
80106af6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106afd:	e8 2b eb ff ff       	call   8010562d <argint>
80106b02:	85 c0                	test   %eax,%eax
80106b04:	78 17                	js     80106b1d <sys_setusedmem+0x34>
80106b06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b14:	e8 14 eb ff ff       	call   8010562d <argint>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	74 07                	je     80106b24 <sys_setusedmem+0x3b>
    return -1;
80106b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b22:	eb 12                	jmp    80106b36 <sys_setusedmem+0x4d>
  }

  return setusedmem(index, max);
80106b24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b2e:	89 04 24             	mov    %eax,(%esp)
80106b31:	e8 db 21 00 00       	call   80108d11 <setusedmem>
}
80106b36:	c9                   	leave  
80106b37:	c3                   	ret    

80106b38 <sys_getuseddisk>:

int
sys_getuseddisk(void)
{
80106b38:	55                   	push   %ebp
80106b39:	89 e5                	mov    %esp,%ebp
80106b3b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106b3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b4c:	e8 dc ea ff ff       	call   8010562d <argint>
80106b51:	85 c0                	test   %eax,%eax
80106b53:	79 07                	jns    80106b5c <sys_getuseddisk+0x24>
    return -1;
80106b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b5a:	eb 0b                	jmp    80106b67 <sys_getuseddisk+0x2f>
  }

  return getuseddisk(index);
80106b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b5f:	89 04 24             	mov    %eax,(%esp)
80106b62:	e8 cc 21 00 00       	call   80108d33 <getuseddisk>
}
80106b67:	c9                   	leave  
80106b68:	c3                   	ret    

80106b69 <sys_setuseddisk>:

int
sys_setuseddisk(void)
{
80106b69:	55                   	push   %ebp
80106b6a:	89 e5                	mov    %esp,%ebp
80106b6c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106b6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b7d:	e8 ab ea ff ff       	call   8010562d <argint>
80106b82:	85 c0                	test   %eax,%eax
80106b84:	78 17                	js     80106b9d <sys_setuseddisk+0x34>
80106b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b94:	e8 94 ea ff ff       	call   8010562d <argint>
80106b99:	85 c0                	test   %eax,%eax
80106b9b:	74 07                	je     80106ba4 <sys_setuseddisk+0x3b>
    return -1;
80106b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba2:	eb 12                	jmp    80106bb6 <sys_setuseddisk+0x4d>
  }

  return setuseddisk(index, max);
80106ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106baa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bae:	89 04 24             	mov    %eax,(%esp)
80106bb1:	e8 96 21 00 00       	call   80108d4c <setuseddisk>
}
80106bb6:	c9                   	leave  
80106bb7:	c3                   	ret    

80106bb8 <sys_setvc>:


int
sys_setvc(void){
80106bb8:	55                   	push   %ebp
80106bb9:	89 e5                	mov    %esp,%ebp
80106bbb:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *vc;

  if(argint(0, &index) < 0 || argstr(1, &vc) < 0){
80106bbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bcc:	e8 5c ea ff ff       	call   8010562d <argint>
80106bd1:	85 c0                	test   %eax,%eax
80106bd3:	78 17                	js     80106bec <sys_setvc+0x34>
80106bd5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106be3:	e8 dc ea ff ff       	call   801056c4 <argstr>
80106be8:	85 c0                	test   %eax,%eax
80106bea:	79 07                	jns    80106bf3 <sys_setvc+0x3b>
    return -1;
80106bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf1:	eb 12                	jmp    80106c05 <sys_setvc+0x4d>
  }

  return setvc(index, vc);
80106bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bfd:	89 04 24             	mov    %eax,(%esp)
80106c00:	e8 69 21 00 00       	call   80108d6e <setvc>
}
80106c05:	c9                   	leave  
80106c06:	c3                   	ret    

80106c07 <sys_setactivefs>:

int
sys_setactivefs(void){
80106c07:	55                   	push   %ebp
80106c08:	89 e5                	mov    %esp,%ebp
80106c0a:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106c0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c10:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c1b:	e8 a4 ea ff ff       	call   801056c4 <argstr>
80106c20:	85 c0                	test   %eax,%eax
80106c22:	79 07                	jns    80106c2b <sys_setactivefs+0x24>
    return -1;
80106c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c29:	eb 0b                	jmp    80106c36 <sys_setactivefs+0x2f>
  }

  return setactivefs(fs);
80106c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2e:	89 04 24             	mov    %eax,(%esp)
80106c31:	e8 17 22 00 00       	call   80108e4d <setactivefs>
}
80106c36:	c9                   	leave  
80106c37:	c3                   	ret    

80106c38 <sys_getactivefs>:

int
sys_getactivefs(void){
80106c38:	55                   	push   %ebp
80106c39:	89 e5                	mov    %esp,%ebp
80106c3b:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106c3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c4c:	e8 73 ea ff ff       	call   801056c4 <argstr>
80106c51:	85 c0                	test   %eax,%eax
80106c53:	79 07                	jns    80106c5c <sys_getactivefs+0x24>
    return -1;
80106c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5a:	eb 0b                	jmp    80106c67 <sys_getactivefs+0x2f>
  }

  return getactivefs(fs);
80106c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c5f:	89 04 24             	mov    %eax,(%esp)
80106c62:	e8 1f 22 00 00       	call   80108e86 <getactivefs>
}
80106c67:	c9                   	leave  
80106c68:	c3                   	ret    

80106c69 <sys_getvcfs>:


int
sys_getvcfs(void){
80106c69:	55                   	push   %ebp
80106c6a:	89 e5                	mov    %esp,%ebp
80106c6c:	83 ec 28             	sub    $0x28,%esp
  char *vc;
  char *fs;

  if(argstr(0, &vc) < 0 || argstr(1, &fs) < 0){
80106c6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c7d:	e8 42 ea ff ff       	call   801056c4 <argstr>
80106c82:	85 c0                	test   %eax,%eax
80106c84:	78 17                	js     80106c9d <sys_getvcfs+0x34>
80106c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106c94:	e8 2b ea ff ff       	call   801056c4 <argstr>
80106c99:	85 c0                	test   %eax,%eax
80106c9b:	79 07                	jns    80106ca4 <sys_getvcfs+0x3b>
    return -1;
80106c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ca2:	eb 12                	jmp    80106cb6 <sys_getvcfs+0x4d>
  }

  return getvcfs(vc, fs);
80106ca4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106caa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106cae:	89 04 24             	mov    %eax,(%esp)
80106cb1:	e8 14 21 00 00       	call   80108dca <getvcfs>
}
80106cb6:	c9                   	leave  
80106cb7:	c3                   	ret    

80106cb8 <sys_tostring>:

int
sys_tostring(void){
80106cb8:	55                   	push   %ebp
80106cb9:	89 e5                	mov    %esp,%ebp
80106cbb:	83 ec 28             	sub    $0x28,%esp
  char *string;

  if(argstr(0, &string) < 0){
80106cbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ccc:	e8 f3 e9 ff ff       	call   801056c4 <argstr>
80106cd1:	85 c0                	test   %eax,%eax
80106cd3:	79 07                	jns    80106cdc <sys_tostring+0x24>
    return -1;
80106cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cda:	eb 0b                	jmp    80106ce7 <sys_tostring+0x2f>
  }

  return tostring(string);
80106cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cdf:	89 04 24             	mov    %eax,(%esp)
80106ce2:	e8 60 22 00 00       	call   80108f47 <tostring>
}
80106ce7:	c9                   	leave  
80106ce8:	c3                   	ret    

80106ce9 <sys_getactivefsindex>:


int
sys_getactivefsindex(void){
80106ce9:	55                   	push   %ebp
80106cea:	89 e5                	mov    %esp,%ebp
80106cec:	83 ec 08             	sub    $0x8,%esp
    return getactivefsindex();
80106cef:	e8 c7 21 00 00       	call   80108ebb <getactivefsindex>
}
80106cf4:	c9                   	leave  
80106cf5:	c3                   	ret    

80106cf6 <sys_setatroot>:

int
sys_setatroot(void){
80106cf6:	55                   	push   %ebp
80106cf7:	89 e5                	mov    %esp,%ebp
80106cf9:	83 ec 28             	sub    $0x28,%esp
  int index, val;

  if(argint(0, &index) < 0 || argint(1, &val) < 0){
80106cfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d0a:	e8 1e e9 ff ff       	call   8010562d <argint>
80106d0f:	85 c0                	test   %eax,%eax
80106d11:	78 17                	js     80106d2a <sys_setatroot+0x34>
80106d13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d16:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d21:	e8 07 e9 ff ff       	call   8010562d <argint>
80106d26:	85 c0                	test   %eax,%eax
80106d28:	79 07                	jns    80106d31 <sys_setatroot+0x3b>
    return -1;
80106d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d2f:	eb 12                	jmp    80106d43 <sys_setatroot+0x4d>
  }

  return setatroot(index, val);
80106d31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d37:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d3b:	89 04 24             	mov    %eax,(%esp)
80106d3e:	e8 c9 21 00 00       	call   80108f0c <setatroot>
}
80106d43:	c9                   	leave  
80106d44:	c3                   	ret    

80106d45 <sys_getatroot>:

int
sys_getatroot(void){
80106d45:	55                   	push   %ebp
80106d46:	89 e5                	mov    %esp,%ebp
80106d48:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d59:	e8 cf e8 ff ff       	call   8010562d <argint>
80106d5e:	85 c0                	test   %eax,%eax
80106d60:	79 07                	jns    80106d69 <sys_getatroot+0x24>
    return -1;
80106d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d67:	eb 0b                	jmp    80106d74 <sys_getatroot+0x2f>
  }

  return getatroot(index);
80106d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6c:	89 04 24             	mov    %eax,(%esp)
80106d6f:	e8 ba 21 00 00       	call   80108f2e <getatroot>
}
80106d74:	c9                   	leave  
80106d75:	c3                   	ret    
	...

80106d78 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d78:	1e                   	push   %ds
  pushl %es
80106d79:	06                   	push   %es
  pushl %fs
80106d7a:	0f a0                	push   %fs
  pushl %gs
80106d7c:	0f a8                	push   %gs
  pushal
80106d7e:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106d7f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d83:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d85:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d87:	54                   	push   %esp
  call trap
80106d88:	e8 c0 01 00 00       	call   80106f4d <trap>
  addl $4, %esp
80106d8d:	83 c4 04             	add    $0x4,%esp

80106d90 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d90:	61                   	popa   
  popl %gs
80106d91:	0f a9                	pop    %gs
  popl %fs
80106d93:	0f a1                	pop    %fs
  popl %es
80106d95:	07                   	pop    %es
  popl %ds
80106d96:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d97:	83 c4 08             	add    $0x8,%esp
  iret
80106d9a:	cf                   	iret   
	...

80106d9c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d9c:	55                   	push   %ebp
80106d9d:	89 e5                	mov    %esp,%ebp
80106d9f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da5:	48                   	dec    %eax
80106da6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106daa:	8b 45 08             	mov    0x8(%ebp),%eax
80106dad:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106db1:	8b 45 08             	mov    0x8(%ebp),%eax
80106db4:	c1 e8 10             	shr    $0x10,%eax
80106db7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106dbb:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106dbe:	0f 01 18             	lidtl  (%eax)
}
80106dc1:	c9                   	leave  
80106dc2:	c3                   	ret    

80106dc3 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106dc3:	55                   	push   %ebp
80106dc4:	89 e5                	mov    %esp,%ebp
80106dc6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106dc9:	0f 20 d0             	mov    %cr2,%eax
80106dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106dd2:	c9                   	leave  
80106dd3:	c3                   	ret    

80106dd4 <tvinit>:

uint ticks;

void
tvinit(void)
{
80106dd4:	55                   	push   %ebp
80106dd5:	89 e5                	mov    %esp,%ebp
80106dd7:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106dda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106de1:	e9 b8 00 00 00       	jmp    80106e9e <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106de9:	8b 04 85 cc c0 10 80 	mov    -0x7fef3f34(,%eax,4),%eax
80106df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106df3:	66 89 04 d5 e0 71 11 	mov    %ax,-0x7fee8e20(,%edx,8)
80106dfa:	80 
80106dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dfe:	66 c7 04 c5 e2 71 11 	movw   $0x8,-0x7fee8e1e(,%eax,8)
80106e05:	80 08 00 
80106e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0b:	8a 14 c5 e4 71 11 80 	mov    -0x7fee8e1c(,%eax,8),%dl
80106e12:	83 e2 e0             	and    $0xffffffe0,%edx
80106e15:	88 14 c5 e4 71 11 80 	mov    %dl,-0x7fee8e1c(,%eax,8)
80106e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e1f:	8a 14 c5 e4 71 11 80 	mov    -0x7fee8e1c(,%eax,8),%dl
80106e26:	83 e2 1f             	and    $0x1f,%edx
80106e29:	88 14 c5 e4 71 11 80 	mov    %dl,-0x7fee8e1c(,%eax,8)
80106e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e33:	8a 14 c5 e5 71 11 80 	mov    -0x7fee8e1b(,%eax,8),%dl
80106e3a:	83 e2 f0             	and    $0xfffffff0,%edx
80106e3d:	83 ca 0e             	or     $0xe,%edx
80106e40:	88 14 c5 e5 71 11 80 	mov    %dl,-0x7fee8e1b(,%eax,8)
80106e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e4a:	8a 14 c5 e5 71 11 80 	mov    -0x7fee8e1b(,%eax,8),%dl
80106e51:	83 e2 ef             	and    $0xffffffef,%edx
80106e54:	88 14 c5 e5 71 11 80 	mov    %dl,-0x7fee8e1b(,%eax,8)
80106e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5e:	8a 14 c5 e5 71 11 80 	mov    -0x7fee8e1b(,%eax,8),%dl
80106e65:	83 e2 9f             	and    $0xffffff9f,%edx
80106e68:	88 14 c5 e5 71 11 80 	mov    %dl,-0x7fee8e1b(,%eax,8)
80106e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e72:	8a 14 c5 e5 71 11 80 	mov    -0x7fee8e1b(,%eax,8),%dl
80106e79:	83 ca 80             	or     $0xffffff80,%edx
80106e7c:	88 14 c5 e5 71 11 80 	mov    %dl,-0x7fee8e1b(,%eax,8)
80106e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e86:	8b 04 85 cc c0 10 80 	mov    -0x7fef3f34(,%eax,4),%eax
80106e8d:	c1 e8 10             	shr    $0x10,%eax
80106e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e93:	66 89 04 d5 e6 71 11 	mov    %ax,-0x7fee8e1a(,%edx,8)
80106e9a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106e9b:	ff 45 f4             	incl   -0xc(%ebp)
80106e9e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ea5:	0f 8e 3b ff ff ff    	jle    80106de6 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106eab:	a1 cc c1 10 80       	mov    0x8010c1cc,%eax
80106eb0:	66 a3 e0 73 11 80    	mov    %ax,0x801173e0
80106eb6:	66 c7 05 e2 73 11 80 	movw   $0x8,0x801173e2
80106ebd:	08 00 
80106ebf:	a0 e4 73 11 80       	mov    0x801173e4,%al
80106ec4:	83 e0 e0             	and    $0xffffffe0,%eax
80106ec7:	a2 e4 73 11 80       	mov    %al,0x801173e4
80106ecc:	a0 e4 73 11 80       	mov    0x801173e4,%al
80106ed1:	83 e0 1f             	and    $0x1f,%eax
80106ed4:	a2 e4 73 11 80       	mov    %al,0x801173e4
80106ed9:	a0 e5 73 11 80       	mov    0x801173e5,%al
80106ede:	83 c8 0f             	or     $0xf,%eax
80106ee1:	a2 e5 73 11 80       	mov    %al,0x801173e5
80106ee6:	a0 e5 73 11 80       	mov    0x801173e5,%al
80106eeb:	83 e0 ef             	and    $0xffffffef,%eax
80106eee:	a2 e5 73 11 80       	mov    %al,0x801173e5
80106ef3:	a0 e5 73 11 80       	mov    0x801173e5,%al
80106ef8:	83 c8 60             	or     $0x60,%eax
80106efb:	a2 e5 73 11 80       	mov    %al,0x801173e5
80106f00:	a0 e5 73 11 80       	mov    0x801173e5,%al
80106f05:	83 c8 80             	or     $0xffffff80,%eax
80106f08:	a2 e5 73 11 80       	mov    %al,0x801173e5
80106f0d:	a1 cc c1 10 80       	mov    0x8010c1cc,%eax
80106f12:	c1 e8 10             	shr    $0x10,%eax
80106f15:	66 a3 e6 73 11 80    	mov    %ax,0x801173e6

  initlock(&tickslock, "time");
80106f1b:	c7 44 24 04 50 96 10 	movl   $0x80109650,0x4(%esp)
80106f22:	80 
80106f23:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106f2a:	e8 ef df ff ff       	call   80104f1e <initlock>
}
80106f2f:	c9                   	leave  
80106f30:	c3                   	ret    

80106f31 <idtinit>:

void
idtinit(void)
{
80106f31:	55                   	push   %ebp
80106f32:	89 e5                	mov    %esp,%ebp
80106f34:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106f37:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106f3e:	00 
80106f3f:	c7 04 24 e0 71 11 80 	movl   $0x801171e0,(%esp)
80106f46:	e8 51 fe ff ff       	call   80106d9c <lidt>
}
80106f4b:	c9                   	leave  
80106f4c:	c3                   	ret    

80106f4d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f4d:	55                   	push   %ebp
80106f4e:	89 e5                	mov    %esp,%ebp
80106f50:	57                   	push   %edi
80106f51:	56                   	push   %esi
80106f52:	53                   	push   %ebx
80106f53:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106f56:	8b 45 08             	mov    0x8(%ebp),%eax
80106f59:	8b 40 30             	mov    0x30(%eax),%eax
80106f5c:	83 f8 40             	cmp    $0x40,%eax
80106f5f:	75 3c                	jne    80106f9d <trap+0x50>
    if(myproc()->killed)
80106f61:	e8 c9 d3 ff ff       	call   8010432f <myproc>
80106f66:	8b 40 24             	mov    0x24(%eax),%eax
80106f69:	85 c0                	test   %eax,%eax
80106f6b:	74 05                	je     80106f72 <trap+0x25>
      exit();
80106f6d:	e8 1f d8 ff ff       	call   80104791 <exit>
    myproc()->tf = tf;
80106f72:	e8 b8 d3 ff ff       	call   8010432f <myproc>
80106f77:	8b 55 08             	mov    0x8(%ebp),%edx
80106f7a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f7d:	e8 79 e7 ff ff       	call   801056fb <syscall>
    if(myproc()->killed)
80106f82:	e8 a8 d3 ff ff       	call   8010432f <myproc>
80106f87:	8b 40 24             	mov    0x24(%eax),%eax
80106f8a:	85 c0                	test   %eax,%eax
80106f8c:	74 0a                	je     80106f98 <trap+0x4b>
      exit();
80106f8e:	e8 fe d7 ff ff       	call   80104791 <exit>
    return;
80106f93:	e9 13 02 00 00       	jmp    801071ab <trap+0x25e>
80106f98:	e9 0e 02 00 00       	jmp    801071ab <trap+0x25e>
  }

  switch(tf->trapno){
80106f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa0:	8b 40 30             	mov    0x30(%eax),%eax
80106fa3:	83 e8 20             	sub    $0x20,%eax
80106fa6:	83 f8 1f             	cmp    $0x1f,%eax
80106fa9:	0f 87 ae 00 00 00    	ja     8010705d <trap+0x110>
80106faf:	8b 04 85 f8 96 10 80 	mov    -0x7fef6908(,%eax,4),%eax
80106fb6:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106fb8:	e8 a9 d2 ff ff       	call   80104266 <cpuid>
80106fbd:	85 c0                	test   %eax,%eax
80106fbf:	75 2f                	jne    80106ff0 <trap+0xa3>
      acquire(&tickslock);
80106fc1:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106fc8:	e8 72 df ff ff       	call   80104f3f <acquire>
      ticks++;
80106fcd:	a1 e0 79 11 80       	mov    0x801179e0,%eax
80106fd2:	40                   	inc    %eax
80106fd3:	a3 e0 79 11 80       	mov    %eax,0x801179e0
      // myproc()->ticks++;
      wakeup(&ticks);
80106fd8:	c7 04 24 e0 79 11 80 	movl   $0x801179e0,(%esp)
80106fdf:	e8 60 dc ff ff       	call   80104c44 <wakeup>
      release(&tickslock);
80106fe4:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
80106feb:	e8 b9 df ff ff       	call   80104fa9 <release>
    }
    lapiceoi();
80106ff0:	e8 1a c1 ff ff       	call   8010310f <lapiceoi>
    break;
80106ff5:	e9 35 01 00 00       	jmp    8010712f <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ffa:	e8 8f b9 ff ff       	call   8010298e <ideintr>
    lapiceoi();
80106fff:	e8 0b c1 ff ff       	call   8010310f <lapiceoi>
    break;
80107004:	e9 26 01 00 00       	jmp    8010712f <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107009:	e8 18 bf ff ff       	call   80102f26 <kbdintr>
    lapiceoi();
8010700e:	e8 fc c0 ff ff       	call   8010310f <lapiceoi>
    break;
80107013:	e9 17 01 00 00       	jmp    8010712f <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107018:	e8 70 03 00 00       	call   8010738d <uartintr>
    lapiceoi();
8010701d:	e8 ed c0 ff ff       	call   8010310f <lapiceoi>
    break;
80107022:	e9 08 01 00 00       	jmp    8010712f <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107027:	8b 45 08             	mov    0x8(%ebp),%eax
8010702a:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010702d:	8b 45 08             	mov    0x8(%ebp),%eax
80107030:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107033:	0f b7 d8             	movzwl %ax,%ebx
80107036:	e8 2b d2 ff ff       	call   80104266 <cpuid>
8010703b:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010703f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107043:	89 44 24 04          	mov    %eax,0x4(%esp)
80107047:	c7 04 24 58 96 10 80 	movl   $0x80109658,(%esp)
8010704e:	e8 9c 93 ff ff       	call   801003ef <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80107053:	e8 b7 c0 ff ff       	call   8010310f <lapiceoi>
    break;
80107058:	e9 d2 00 00 00       	jmp    8010712f <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010705d:	e8 cd d2 ff ff       	call   8010432f <myproc>
80107062:	85 c0                	test   %eax,%eax
80107064:	74 10                	je     80107076 <trap+0x129>
80107066:	8b 45 08             	mov    0x8(%ebp),%eax
80107069:	8b 40 3c             	mov    0x3c(%eax),%eax
8010706c:	0f b7 c0             	movzwl %ax,%eax
8010706f:	83 e0 03             	and    $0x3,%eax
80107072:	85 c0                	test   %eax,%eax
80107074:	75 40                	jne    801070b6 <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107076:	e8 48 fd ff ff       	call   80106dc3 <rcr2>
8010707b:	89 c3                	mov    %eax,%ebx
8010707d:	8b 45 08             	mov    0x8(%ebp),%eax
80107080:	8b 70 38             	mov    0x38(%eax),%esi
80107083:	e8 de d1 ff ff       	call   80104266 <cpuid>
80107088:	8b 55 08             	mov    0x8(%ebp),%edx
8010708b:	8b 52 30             	mov    0x30(%edx),%edx
8010708e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107092:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107096:	89 44 24 08          	mov    %eax,0x8(%esp)
8010709a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010709e:	c7 04 24 7c 96 10 80 	movl   $0x8010967c,(%esp)
801070a5:	e8 45 93 ff ff       	call   801003ef <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801070aa:	c7 04 24 ae 96 10 80 	movl   $0x801096ae,(%esp)
801070b1:	e8 cc 94 ff ff       	call   80100582 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070b6:	e8 08 fd ff ff       	call   80106dc3 <rcr2>
801070bb:	89 c6                	mov    %eax,%esi
801070bd:	8b 45 08             	mov    0x8(%ebp),%eax
801070c0:	8b 40 38             	mov    0x38(%eax),%eax
801070c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070c6:	e8 9b d1 ff ff       	call   80104266 <cpuid>
801070cb:	89 c3                	mov    %eax,%ebx
801070cd:	8b 45 08             	mov    0x8(%ebp),%eax
801070d0:	8b 78 34             	mov    0x34(%eax),%edi
801070d3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801070d6:	8b 45 08             	mov    0x8(%ebp),%eax
801070d9:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801070dc:	e8 4e d2 ff ff       	call   8010432f <myproc>
801070e1:	8d 50 6c             	lea    0x6c(%eax),%edx
801070e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
801070e7:	e8 43 d2 ff ff       	call   8010432f <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070ec:	8b 40 10             	mov    0x10(%eax),%eax
801070ef:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801070f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070f6:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801070fa:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801070fe:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107101:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107105:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80107109:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010710c:	89 54 24 08          	mov    %edx,0x8(%esp)
80107110:	89 44 24 04          	mov    %eax,0x4(%esp)
80107114:	c7 04 24 b4 96 10 80 	movl   $0x801096b4,(%esp)
8010711b:	e8 cf 92 ff ff       	call   801003ef <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80107120:	e8 0a d2 ff ff       	call   8010432f <myproc>
80107125:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010712c:	eb 01                	jmp    8010712f <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010712e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010712f:	e8 fb d1 ff ff       	call   8010432f <myproc>
80107134:	85 c0                	test   %eax,%eax
80107136:	74 22                	je     8010715a <trap+0x20d>
80107138:	e8 f2 d1 ff ff       	call   8010432f <myproc>
8010713d:	8b 40 24             	mov    0x24(%eax),%eax
80107140:	85 c0                	test   %eax,%eax
80107142:	74 16                	je     8010715a <trap+0x20d>
80107144:	8b 45 08             	mov    0x8(%ebp),%eax
80107147:	8b 40 3c             	mov    0x3c(%eax),%eax
8010714a:	0f b7 c0             	movzwl %ax,%eax
8010714d:	83 e0 03             	and    $0x3,%eax
80107150:	83 f8 03             	cmp    $0x3,%eax
80107153:	75 05                	jne    8010715a <trap+0x20d>
    exit();
80107155:	e8 37 d6 ff ff       	call   80104791 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010715a:	e8 d0 d1 ff ff       	call   8010432f <myproc>
8010715f:	85 c0                	test   %eax,%eax
80107161:	74 1d                	je     80107180 <trap+0x233>
80107163:	e8 c7 d1 ff ff       	call   8010432f <myproc>
80107168:	8b 40 0c             	mov    0xc(%eax),%eax
8010716b:	83 f8 04             	cmp    $0x4,%eax
8010716e:	75 10                	jne    80107180 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80107170:	8b 45 08             	mov    0x8(%ebp),%eax
80107173:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107176:	83 f8 20             	cmp    $0x20,%eax
80107179:	75 05                	jne    80107180 <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010717b:	e8 80 d9 ff ff       	call   80104b00 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107180:	e8 aa d1 ff ff       	call   8010432f <myproc>
80107185:	85 c0                	test   %eax,%eax
80107187:	74 22                	je     801071ab <trap+0x25e>
80107189:	e8 a1 d1 ff ff       	call   8010432f <myproc>
8010718e:	8b 40 24             	mov    0x24(%eax),%eax
80107191:	85 c0                	test   %eax,%eax
80107193:	74 16                	je     801071ab <trap+0x25e>
80107195:	8b 45 08             	mov    0x8(%ebp),%eax
80107198:	8b 40 3c             	mov    0x3c(%eax),%eax
8010719b:	0f b7 c0             	movzwl %ax,%eax
8010719e:	83 e0 03             	and    $0x3,%eax
801071a1:	83 f8 03             	cmp    $0x3,%eax
801071a4:	75 05                	jne    801071ab <trap+0x25e>
    exit();
801071a6:	e8 e6 d5 ff ff       	call   80104791 <exit>
}
801071ab:	83 c4 3c             	add    $0x3c,%esp
801071ae:	5b                   	pop    %ebx
801071af:	5e                   	pop    %esi
801071b0:	5f                   	pop    %edi
801071b1:	5d                   	pop    %ebp
801071b2:	c3                   	ret    
	...

801071b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801071b4:	55                   	push   %ebp
801071b5:	89 e5                	mov    %esp,%ebp
801071b7:	83 ec 14             	sub    $0x14,%esp
801071ba:	8b 45 08             	mov    0x8(%ebp),%eax
801071bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801071c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801071c4:	89 c2                	mov    %eax,%edx
801071c6:	ec                   	in     (%dx),%al
801071c7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801071ca:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801071cd:	c9                   	leave  
801071ce:	c3                   	ret    

801071cf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801071cf:	55                   	push   %ebp
801071d0:	89 e5                	mov    %esp,%ebp
801071d2:	83 ec 08             	sub    $0x8,%esp
801071d5:	8b 45 08             	mov    0x8(%ebp),%eax
801071d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071db:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801071df:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071e2:	8a 45 f8             	mov    -0x8(%ebp),%al
801071e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801071e8:	ee                   	out    %al,(%dx)
}
801071e9:	c9                   	leave  
801071ea:	c3                   	ret    

801071eb <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801071eb:	55                   	push   %ebp
801071ec:	89 e5                	mov    %esp,%ebp
801071ee:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801071f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801071f8:	00 
801071f9:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107200:	e8 ca ff ff ff       	call   801071cf <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107205:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010720c:	00 
8010720d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107214:	e8 b6 ff ff ff       	call   801071cf <outb>
  outb(COM1+0, 115200/9600);
80107219:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107220:	00 
80107221:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107228:	e8 a2 ff ff ff       	call   801071cf <outb>
  outb(COM1+1, 0);
8010722d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107234:	00 
80107235:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010723c:	e8 8e ff ff ff       	call   801071cf <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107241:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107248:	00 
80107249:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107250:	e8 7a ff ff ff       	call   801071cf <outb>
  outb(COM1+4, 0);
80107255:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010725c:	00 
8010725d:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107264:	e8 66 ff ff ff       	call   801071cf <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107269:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107270:	00 
80107271:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107278:	e8 52 ff ff ff       	call   801071cf <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010727d:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107284:	e8 2b ff ff ff       	call   801071b4 <inb>
80107289:	3c ff                	cmp    $0xff,%al
8010728b:	75 02                	jne    8010728f <uartinit+0xa4>
    return;
8010728d:	eb 5b                	jmp    801072ea <uartinit+0xff>
  uart = 1;
8010728f:	c7 05 84 c6 10 80 01 	movl   $0x1,0x8010c684
80107296:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107299:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801072a0:	e8 0f ff ff ff       	call   801071b4 <inb>
  inb(COM1+0);
801072a5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072ac:	e8 03 ff ff ff       	call   801071b4 <inb>
  ioapicenable(IRQ_COM1, 0);
801072b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072b8:	00 
801072b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801072c0:	e8 3e b9 ff ff       	call   80102c03 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801072c5:	c7 45 f4 78 97 10 80 	movl   $0x80109778,-0xc(%ebp)
801072cc:	eb 13                	jmp    801072e1 <uartinit+0xf6>
    uartputc(*p);
801072ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d1:	8a 00                	mov    (%eax),%al
801072d3:	0f be c0             	movsbl %al,%eax
801072d6:	89 04 24             	mov    %eax,(%esp)
801072d9:	e8 0e 00 00 00       	call   801072ec <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801072de:	ff 45 f4             	incl   -0xc(%ebp)
801072e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e4:	8a 00                	mov    (%eax),%al
801072e6:	84 c0                	test   %al,%al
801072e8:	75 e4                	jne    801072ce <uartinit+0xe3>
    uartputc(*p);
}
801072ea:	c9                   	leave  
801072eb:	c3                   	ret    

801072ec <uartputc>:

void
uartputc(int c)
{
801072ec:	55                   	push   %ebp
801072ed:	89 e5                	mov    %esp,%ebp
801072ef:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801072f2:	a1 84 c6 10 80       	mov    0x8010c684,%eax
801072f7:	85 c0                	test   %eax,%eax
801072f9:	75 02                	jne    801072fd <uartputc+0x11>
    return;
801072fb:	eb 4a                	jmp    80107347 <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107304:	eb 0f                	jmp    80107315 <uartputc+0x29>
    microdelay(10);
80107306:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010730d:	e8 22 be ff ff       	call   80103134 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107312:	ff 45 f4             	incl   -0xc(%ebp)
80107315:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107319:	7f 16                	jg     80107331 <uartputc+0x45>
8010731b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107322:	e8 8d fe ff ff       	call   801071b4 <inb>
80107327:	0f b6 c0             	movzbl %al,%eax
8010732a:	83 e0 20             	and    $0x20,%eax
8010732d:	85 c0                	test   %eax,%eax
8010732f:	74 d5                	je     80107306 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80107331:	8b 45 08             	mov    0x8(%ebp),%eax
80107334:	0f b6 c0             	movzbl %al,%eax
80107337:	89 44 24 04          	mov    %eax,0x4(%esp)
8010733b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107342:	e8 88 fe ff ff       	call   801071cf <outb>
}
80107347:	c9                   	leave  
80107348:	c3                   	ret    

80107349 <uartgetc>:

static int
uartgetc(void)
{
80107349:	55                   	push   %ebp
8010734a:	89 e5                	mov    %esp,%ebp
8010734c:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010734f:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80107354:	85 c0                	test   %eax,%eax
80107356:	75 07                	jne    8010735f <uartgetc+0x16>
    return -1;
80107358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010735d:	eb 2c                	jmp    8010738b <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010735f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107366:	e8 49 fe ff ff       	call   801071b4 <inb>
8010736b:	0f b6 c0             	movzbl %al,%eax
8010736e:	83 e0 01             	and    $0x1,%eax
80107371:	85 c0                	test   %eax,%eax
80107373:	75 07                	jne    8010737c <uartgetc+0x33>
    return -1;
80107375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010737a:	eb 0f                	jmp    8010738b <uartgetc+0x42>
  return inb(COM1+0);
8010737c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107383:	e8 2c fe ff ff       	call   801071b4 <inb>
80107388:	0f b6 c0             	movzbl %al,%eax
}
8010738b:	c9                   	leave  
8010738c:	c3                   	ret    

8010738d <uartintr>:

void
uartintr(void)
{
8010738d:	55                   	push   %ebp
8010738e:	89 e5                	mov    %esp,%ebp
80107390:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107393:	c7 04 24 49 73 10 80 	movl   $0x80107349,(%esp)
8010739a:	e8 84 94 ff ff       	call   80100823 <consoleintr>
}
8010739f:	c9                   	leave  
801073a0:	c3                   	ret    
801073a1:	00 00                	add    %al,(%eax)
	...

801073a4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $0
801073a6:	6a 00                	push   $0x0
  jmp alltraps
801073a8:	e9 cb f9 ff ff       	jmp    80106d78 <alltraps>

801073ad <vector1>:
.globl vector1
vector1:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $1
801073af:	6a 01                	push   $0x1
  jmp alltraps
801073b1:	e9 c2 f9 ff ff       	jmp    80106d78 <alltraps>

801073b6 <vector2>:
.globl vector2
vector2:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $2
801073b8:	6a 02                	push   $0x2
  jmp alltraps
801073ba:	e9 b9 f9 ff ff       	jmp    80106d78 <alltraps>

801073bf <vector3>:
.globl vector3
vector3:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $3
801073c1:	6a 03                	push   $0x3
  jmp alltraps
801073c3:	e9 b0 f9 ff ff       	jmp    80106d78 <alltraps>

801073c8 <vector4>:
.globl vector4
vector4:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $4
801073ca:	6a 04                	push   $0x4
  jmp alltraps
801073cc:	e9 a7 f9 ff ff       	jmp    80106d78 <alltraps>

801073d1 <vector5>:
.globl vector5
vector5:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $5
801073d3:	6a 05                	push   $0x5
  jmp alltraps
801073d5:	e9 9e f9 ff ff       	jmp    80106d78 <alltraps>

801073da <vector6>:
.globl vector6
vector6:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $6
801073dc:	6a 06                	push   $0x6
  jmp alltraps
801073de:	e9 95 f9 ff ff       	jmp    80106d78 <alltraps>

801073e3 <vector7>:
.globl vector7
vector7:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $7
801073e5:	6a 07                	push   $0x7
  jmp alltraps
801073e7:	e9 8c f9 ff ff       	jmp    80106d78 <alltraps>

801073ec <vector8>:
.globl vector8
vector8:
  pushl $8
801073ec:	6a 08                	push   $0x8
  jmp alltraps
801073ee:	e9 85 f9 ff ff       	jmp    80106d78 <alltraps>

801073f3 <vector9>:
.globl vector9
vector9:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $9
801073f5:	6a 09                	push   $0x9
  jmp alltraps
801073f7:	e9 7c f9 ff ff       	jmp    80106d78 <alltraps>

801073fc <vector10>:
.globl vector10
vector10:
  pushl $10
801073fc:	6a 0a                	push   $0xa
  jmp alltraps
801073fe:	e9 75 f9 ff ff       	jmp    80106d78 <alltraps>

80107403 <vector11>:
.globl vector11
vector11:
  pushl $11
80107403:	6a 0b                	push   $0xb
  jmp alltraps
80107405:	e9 6e f9 ff ff       	jmp    80106d78 <alltraps>

8010740a <vector12>:
.globl vector12
vector12:
  pushl $12
8010740a:	6a 0c                	push   $0xc
  jmp alltraps
8010740c:	e9 67 f9 ff ff       	jmp    80106d78 <alltraps>

80107411 <vector13>:
.globl vector13
vector13:
  pushl $13
80107411:	6a 0d                	push   $0xd
  jmp alltraps
80107413:	e9 60 f9 ff ff       	jmp    80106d78 <alltraps>

80107418 <vector14>:
.globl vector14
vector14:
  pushl $14
80107418:	6a 0e                	push   $0xe
  jmp alltraps
8010741a:	e9 59 f9 ff ff       	jmp    80106d78 <alltraps>

8010741f <vector15>:
.globl vector15
vector15:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $15
80107421:	6a 0f                	push   $0xf
  jmp alltraps
80107423:	e9 50 f9 ff ff       	jmp    80106d78 <alltraps>

80107428 <vector16>:
.globl vector16
vector16:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $16
8010742a:	6a 10                	push   $0x10
  jmp alltraps
8010742c:	e9 47 f9 ff ff       	jmp    80106d78 <alltraps>

80107431 <vector17>:
.globl vector17
vector17:
  pushl $17
80107431:	6a 11                	push   $0x11
  jmp alltraps
80107433:	e9 40 f9 ff ff       	jmp    80106d78 <alltraps>

80107438 <vector18>:
.globl vector18
vector18:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $18
8010743a:	6a 12                	push   $0x12
  jmp alltraps
8010743c:	e9 37 f9 ff ff       	jmp    80106d78 <alltraps>

80107441 <vector19>:
.globl vector19
vector19:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $19
80107443:	6a 13                	push   $0x13
  jmp alltraps
80107445:	e9 2e f9 ff ff       	jmp    80106d78 <alltraps>

8010744a <vector20>:
.globl vector20
vector20:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $20
8010744c:	6a 14                	push   $0x14
  jmp alltraps
8010744e:	e9 25 f9 ff ff       	jmp    80106d78 <alltraps>

80107453 <vector21>:
.globl vector21
vector21:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $21
80107455:	6a 15                	push   $0x15
  jmp alltraps
80107457:	e9 1c f9 ff ff       	jmp    80106d78 <alltraps>

8010745c <vector22>:
.globl vector22
vector22:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $22
8010745e:	6a 16                	push   $0x16
  jmp alltraps
80107460:	e9 13 f9 ff ff       	jmp    80106d78 <alltraps>

80107465 <vector23>:
.globl vector23
vector23:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $23
80107467:	6a 17                	push   $0x17
  jmp alltraps
80107469:	e9 0a f9 ff ff       	jmp    80106d78 <alltraps>

8010746e <vector24>:
.globl vector24
vector24:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $24
80107470:	6a 18                	push   $0x18
  jmp alltraps
80107472:	e9 01 f9 ff ff       	jmp    80106d78 <alltraps>

80107477 <vector25>:
.globl vector25
vector25:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $25
80107479:	6a 19                	push   $0x19
  jmp alltraps
8010747b:	e9 f8 f8 ff ff       	jmp    80106d78 <alltraps>

80107480 <vector26>:
.globl vector26
vector26:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $26
80107482:	6a 1a                	push   $0x1a
  jmp alltraps
80107484:	e9 ef f8 ff ff       	jmp    80106d78 <alltraps>

80107489 <vector27>:
.globl vector27
vector27:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $27
8010748b:	6a 1b                	push   $0x1b
  jmp alltraps
8010748d:	e9 e6 f8 ff ff       	jmp    80106d78 <alltraps>

80107492 <vector28>:
.globl vector28
vector28:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $28
80107494:	6a 1c                	push   $0x1c
  jmp alltraps
80107496:	e9 dd f8 ff ff       	jmp    80106d78 <alltraps>

8010749b <vector29>:
.globl vector29
vector29:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $29
8010749d:	6a 1d                	push   $0x1d
  jmp alltraps
8010749f:	e9 d4 f8 ff ff       	jmp    80106d78 <alltraps>

801074a4 <vector30>:
.globl vector30
vector30:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $30
801074a6:	6a 1e                	push   $0x1e
  jmp alltraps
801074a8:	e9 cb f8 ff ff       	jmp    80106d78 <alltraps>

801074ad <vector31>:
.globl vector31
vector31:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $31
801074af:	6a 1f                	push   $0x1f
  jmp alltraps
801074b1:	e9 c2 f8 ff ff       	jmp    80106d78 <alltraps>

801074b6 <vector32>:
.globl vector32
vector32:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $32
801074b8:	6a 20                	push   $0x20
  jmp alltraps
801074ba:	e9 b9 f8 ff ff       	jmp    80106d78 <alltraps>

801074bf <vector33>:
.globl vector33
vector33:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $33
801074c1:	6a 21                	push   $0x21
  jmp alltraps
801074c3:	e9 b0 f8 ff ff       	jmp    80106d78 <alltraps>

801074c8 <vector34>:
.globl vector34
vector34:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $34
801074ca:	6a 22                	push   $0x22
  jmp alltraps
801074cc:	e9 a7 f8 ff ff       	jmp    80106d78 <alltraps>

801074d1 <vector35>:
.globl vector35
vector35:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $35
801074d3:	6a 23                	push   $0x23
  jmp alltraps
801074d5:	e9 9e f8 ff ff       	jmp    80106d78 <alltraps>

801074da <vector36>:
.globl vector36
vector36:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $36
801074dc:	6a 24                	push   $0x24
  jmp alltraps
801074de:	e9 95 f8 ff ff       	jmp    80106d78 <alltraps>

801074e3 <vector37>:
.globl vector37
vector37:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $37
801074e5:	6a 25                	push   $0x25
  jmp alltraps
801074e7:	e9 8c f8 ff ff       	jmp    80106d78 <alltraps>

801074ec <vector38>:
.globl vector38
vector38:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $38
801074ee:	6a 26                	push   $0x26
  jmp alltraps
801074f0:	e9 83 f8 ff ff       	jmp    80106d78 <alltraps>

801074f5 <vector39>:
.globl vector39
vector39:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $39
801074f7:	6a 27                	push   $0x27
  jmp alltraps
801074f9:	e9 7a f8 ff ff       	jmp    80106d78 <alltraps>

801074fe <vector40>:
.globl vector40
vector40:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $40
80107500:	6a 28                	push   $0x28
  jmp alltraps
80107502:	e9 71 f8 ff ff       	jmp    80106d78 <alltraps>

80107507 <vector41>:
.globl vector41
vector41:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $41
80107509:	6a 29                	push   $0x29
  jmp alltraps
8010750b:	e9 68 f8 ff ff       	jmp    80106d78 <alltraps>

80107510 <vector42>:
.globl vector42
vector42:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $42
80107512:	6a 2a                	push   $0x2a
  jmp alltraps
80107514:	e9 5f f8 ff ff       	jmp    80106d78 <alltraps>

80107519 <vector43>:
.globl vector43
vector43:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $43
8010751b:	6a 2b                	push   $0x2b
  jmp alltraps
8010751d:	e9 56 f8 ff ff       	jmp    80106d78 <alltraps>

80107522 <vector44>:
.globl vector44
vector44:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $44
80107524:	6a 2c                	push   $0x2c
  jmp alltraps
80107526:	e9 4d f8 ff ff       	jmp    80106d78 <alltraps>

8010752b <vector45>:
.globl vector45
vector45:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $45
8010752d:	6a 2d                	push   $0x2d
  jmp alltraps
8010752f:	e9 44 f8 ff ff       	jmp    80106d78 <alltraps>

80107534 <vector46>:
.globl vector46
vector46:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $46
80107536:	6a 2e                	push   $0x2e
  jmp alltraps
80107538:	e9 3b f8 ff ff       	jmp    80106d78 <alltraps>

8010753d <vector47>:
.globl vector47
vector47:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $47
8010753f:	6a 2f                	push   $0x2f
  jmp alltraps
80107541:	e9 32 f8 ff ff       	jmp    80106d78 <alltraps>

80107546 <vector48>:
.globl vector48
vector48:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $48
80107548:	6a 30                	push   $0x30
  jmp alltraps
8010754a:	e9 29 f8 ff ff       	jmp    80106d78 <alltraps>

8010754f <vector49>:
.globl vector49
vector49:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $49
80107551:	6a 31                	push   $0x31
  jmp alltraps
80107553:	e9 20 f8 ff ff       	jmp    80106d78 <alltraps>

80107558 <vector50>:
.globl vector50
vector50:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $50
8010755a:	6a 32                	push   $0x32
  jmp alltraps
8010755c:	e9 17 f8 ff ff       	jmp    80106d78 <alltraps>

80107561 <vector51>:
.globl vector51
vector51:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $51
80107563:	6a 33                	push   $0x33
  jmp alltraps
80107565:	e9 0e f8 ff ff       	jmp    80106d78 <alltraps>

8010756a <vector52>:
.globl vector52
vector52:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $52
8010756c:	6a 34                	push   $0x34
  jmp alltraps
8010756e:	e9 05 f8 ff ff       	jmp    80106d78 <alltraps>

80107573 <vector53>:
.globl vector53
vector53:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $53
80107575:	6a 35                	push   $0x35
  jmp alltraps
80107577:	e9 fc f7 ff ff       	jmp    80106d78 <alltraps>

8010757c <vector54>:
.globl vector54
vector54:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $54
8010757e:	6a 36                	push   $0x36
  jmp alltraps
80107580:	e9 f3 f7 ff ff       	jmp    80106d78 <alltraps>

80107585 <vector55>:
.globl vector55
vector55:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $55
80107587:	6a 37                	push   $0x37
  jmp alltraps
80107589:	e9 ea f7 ff ff       	jmp    80106d78 <alltraps>

8010758e <vector56>:
.globl vector56
vector56:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $56
80107590:	6a 38                	push   $0x38
  jmp alltraps
80107592:	e9 e1 f7 ff ff       	jmp    80106d78 <alltraps>

80107597 <vector57>:
.globl vector57
vector57:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $57
80107599:	6a 39                	push   $0x39
  jmp alltraps
8010759b:	e9 d8 f7 ff ff       	jmp    80106d78 <alltraps>

801075a0 <vector58>:
.globl vector58
vector58:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $58
801075a2:	6a 3a                	push   $0x3a
  jmp alltraps
801075a4:	e9 cf f7 ff ff       	jmp    80106d78 <alltraps>

801075a9 <vector59>:
.globl vector59
vector59:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $59
801075ab:	6a 3b                	push   $0x3b
  jmp alltraps
801075ad:	e9 c6 f7 ff ff       	jmp    80106d78 <alltraps>

801075b2 <vector60>:
.globl vector60
vector60:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $60
801075b4:	6a 3c                	push   $0x3c
  jmp alltraps
801075b6:	e9 bd f7 ff ff       	jmp    80106d78 <alltraps>

801075bb <vector61>:
.globl vector61
vector61:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $61
801075bd:	6a 3d                	push   $0x3d
  jmp alltraps
801075bf:	e9 b4 f7 ff ff       	jmp    80106d78 <alltraps>

801075c4 <vector62>:
.globl vector62
vector62:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $62
801075c6:	6a 3e                	push   $0x3e
  jmp alltraps
801075c8:	e9 ab f7 ff ff       	jmp    80106d78 <alltraps>

801075cd <vector63>:
.globl vector63
vector63:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $63
801075cf:	6a 3f                	push   $0x3f
  jmp alltraps
801075d1:	e9 a2 f7 ff ff       	jmp    80106d78 <alltraps>

801075d6 <vector64>:
.globl vector64
vector64:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $64
801075d8:	6a 40                	push   $0x40
  jmp alltraps
801075da:	e9 99 f7 ff ff       	jmp    80106d78 <alltraps>

801075df <vector65>:
.globl vector65
vector65:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $65
801075e1:	6a 41                	push   $0x41
  jmp alltraps
801075e3:	e9 90 f7 ff ff       	jmp    80106d78 <alltraps>

801075e8 <vector66>:
.globl vector66
vector66:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $66
801075ea:	6a 42                	push   $0x42
  jmp alltraps
801075ec:	e9 87 f7 ff ff       	jmp    80106d78 <alltraps>

801075f1 <vector67>:
.globl vector67
vector67:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $67
801075f3:	6a 43                	push   $0x43
  jmp alltraps
801075f5:	e9 7e f7 ff ff       	jmp    80106d78 <alltraps>

801075fa <vector68>:
.globl vector68
vector68:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $68
801075fc:	6a 44                	push   $0x44
  jmp alltraps
801075fe:	e9 75 f7 ff ff       	jmp    80106d78 <alltraps>

80107603 <vector69>:
.globl vector69
vector69:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $69
80107605:	6a 45                	push   $0x45
  jmp alltraps
80107607:	e9 6c f7 ff ff       	jmp    80106d78 <alltraps>

8010760c <vector70>:
.globl vector70
vector70:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $70
8010760e:	6a 46                	push   $0x46
  jmp alltraps
80107610:	e9 63 f7 ff ff       	jmp    80106d78 <alltraps>

80107615 <vector71>:
.globl vector71
vector71:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $71
80107617:	6a 47                	push   $0x47
  jmp alltraps
80107619:	e9 5a f7 ff ff       	jmp    80106d78 <alltraps>

8010761e <vector72>:
.globl vector72
vector72:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $72
80107620:	6a 48                	push   $0x48
  jmp alltraps
80107622:	e9 51 f7 ff ff       	jmp    80106d78 <alltraps>

80107627 <vector73>:
.globl vector73
vector73:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $73
80107629:	6a 49                	push   $0x49
  jmp alltraps
8010762b:	e9 48 f7 ff ff       	jmp    80106d78 <alltraps>

80107630 <vector74>:
.globl vector74
vector74:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $74
80107632:	6a 4a                	push   $0x4a
  jmp alltraps
80107634:	e9 3f f7 ff ff       	jmp    80106d78 <alltraps>

80107639 <vector75>:
.globl vector75
vector75:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $75
8010763b:	6a 4b                	push   $0x4b
  jmp alltraps
8010763d:	e9 36 f7 ff ff       	jmp    80106d78 <alltraps>

80107642 <vector76>:
.globl vector76
vector76:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $76
80107644:	6a 4c                	push   $0x4c
  jmp alltraps
80107646:	e9 2d f7 ff ff       	jmp    80106d78 <alltraps>

8010764b <vector77>:
.globl vector77
vector77:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $77
8010764d:	6a 4d                	push   $0x4d
  jmp alltraps
8010764f:	e9 24 f7 ff ff       	jmp    80106d78 <alltraps>

80107654 <vector78>:
.globl vector78
vector78:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $78
80107656:	6a 4e                	push   $0x4e
  jmp alltraps
80107658:	e9 1b f7 ff ff       	jmp    80106d78 <alltraps>

8010765d <vector79>:
.globl vector79
vector79:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $79
8010765f:	6a 4f                	push   $0x4f
  jmp alltraps
80107661:	e9 12 f7 ff ff       	jmp    80106d78 <alltraps>

80107666 <vector80>:
.globl vector80
vector80:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $80
80107668:	6a 50                	push   $0x50
  jmp alltraps
8010766a:	e9 09 f7 ff ff       	jmp    80106d78 <alltraps>

8010766f <vector81>:
.globl vector81
vector81:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $81
80107671:	6a 51                	push   $0x51
  jmp alltraps
80107673:	e9 00 f7 ff ff       	jmp    80106d78 <alltraps>

80107678 <vector82>:
.globl vector82
vector82:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $82
8010767a:	6a 52                	push   $0x52
  jmp alltraps
8010767c:	e9 f7 f6 ff ff       	jmp    80106d78 <alltraps>

80107681 <vector83>:
.globl vector83
vector83:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $83
80107683:	6a 53                	push   $0x53
  jmp alltraps
80107685:	e9 ee f6 ff ff       	jmp    80106d78 <alltraps>

8010768a <vector84>:
.globl vector84
vector84:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $84
8010768c:	6a 54                	push   $0x54
  jmp alltraps
8010768e:	e9 e5 f6 ff ff       	jmp    80106d78 <alltraps>

80107693 <vector85>:
.globl vector85
vector85:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $85
80107695:	6a 55                	push   $0x55
  jmp alltraps
80107697:	e9 dc f6 ff ff       	jmp    80106d78 <alltraps>

8010769c <vector86>:
.globl vector86
vector86:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $86
8010769e:	6a 56                	push   $0x56
  jmp alltraps
801076a0:	e9 d3 f6 ff ff       	jmp    80106d78 <alltraps>

801076a5 <vector87>:
.globl vector87
vector87:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $87
801076a7:	6a 57                	push   $0x57
  jmp alltraps
801076a9:	e9 ca f6 ff ff       	jmp    80106d78 <alltraps>

801076ae <vector88>:
.globl vector88
vector88:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $88
801076b0:	6a 58                	push   $0x58
  jmp alltraps
801076b2:	e9 c1 f6 ff ff       	jmp    80106d78 <alltraps>

801076b7 <vector89>:
.globl vector89
vector89:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $89
801076b9:	6a 59                	push   $0x59
  jmp alltraps
801076bb:	e9 b8 f6 ff ff       	jmp    80106d78 <alltraps>

801076c0 <vector90>:
.globl vector90
vector90:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $90
801076c2:	6a 5a                	push   $0x5a
  jmp alltraps
801076c4:	e9 af f6 ff ff       	jmp    80106d78 <alltraps>

801076c9 <vector91>:
.globl vector91
vector91:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $91
801076cb:	6a 5b                	push   $0x5b
  jmp alltraps
801076cd:	e9 a6 f6 ff ff       	jmp    80106d78 <alltraps>

801076d2 <vector92>:
.globl vector92
vector92:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $92
801076d4:	6a 5c                	push   $0x5c
  jmp alltraps
801076d6:	e9 9d f6 ff ff       	jmp    80106d78 <alltraps>

801076db <vector93>:
.globl vector93
vector93:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $93
801076dd:	6a 5d                	push   $0x5d
  jmp alltraps
801076df:	e9 94 f6 ff ff       	jmp    80106d78 <alltraps>

801076e4 <vector94>:
.globl vector94
vector94:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $94
801076e6:	6a 5e                	push   $0x5e
  jmp alltraps
801076e8:	e9 8b f6 ff ff       	jmp    80106d78 <alltraps>

801076ed <vector95>:
.globl vector95
vector95:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $95
801076ef:	6a 5f                	push   $0x5f
  jmp alltraps
801076f1:	e9 82 f6 ff ff       	jmp    80106d78 <alltraps>

801076f6 <vector96>:
.globl vector96
vector96:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $96
801076f8:	6a 60                	push   $0x60
  jmp alltraps
801076fa:	e9 79 f6 ff ff       	jmp    80106d78 <alltraps>

801076ff <vector97>:
.globl vector97
vector97:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $97
80107701:	6a 61                	push   $0x61
  jmp alltraps
80107703:	e9 70 f6 ff ff       	jmp    80106d78 <alltraps>

80107708 <vector98>:
.globl vector98
vector98:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $98
8010770a:	6a 62                	push   $0x62
  jmp alltraps
8010770c:	e9 67 f6 ff ff       	jmp    80106d78 <alltraps>

80107711 <vector99>:
.globl vector99
vector99:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $99
80107713:	6a 63                	push   $0x63
  jmp alltraps
80107715:	e9 5e f6 ff ff       	jmp    80106d78 <alltraps>

8010771a <vector100>:
.globl vector100
vector100:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $100
8010771c:	6a 64                	push   $0x64
  jmp alltraps
8010771e:	e9 55 f6 ff ff       	jmp    80106d78 <alltraps>

80107723 <vector101>:
.globl vector101
vector101:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $101
80107725:	6a 65                	push   $0x65
  jmp alltraps
80107727:	e9 4c f6 ff ff       	jmp    80106d78 <alltraps>

8010772c <vector102>:
.globl vector102
vector102:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $102
8010772e:	6a 66                	push   $0x66
  jmp alltraps
80107730:	e9 43 f6 ff ff       	jmp    80106d78 <alltraps>

80107735 <vector103>:
.globl vector103
vector103:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $103
80107737:	6a 67                	push   $0x67
  jmp alltraps
80107739:	e9 3a f6 ff ff       	jmp    80106d78 <alltraps>

8010773e <vector104>:
.globl vector104
vector104:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $104
80107740:	6a 68                	push   $0x68
  jmp alltraps
80107742:	e9 31 f6 ff ff       	jmp    80106d78 <alltraps>

80107747 <vector105>:
.globl vector105
vector105:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $105
80107749:	6a 69                	push   $0x69
  jmp alltraps
8010774b:	e9 28 f6 ff ff       	jmp    80106d78 <alltraps>

80107750 <vector106>:
.globl vector106
vector106:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $106
80107752:	6a 6a                	push   $0x6a
  jmp alltraps
80107754:	e9 1f f6 ff ff       	jmp    80106d78 <alltraps>

80107759 <vector107>:
.globl vector107
vector107:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $107
8010775b:	6a 6b                	push   $0x6b
  jmp alltraps
8010775d:	e9 16 f6 ff ff       	jmp    80106d78 <alltraps>

80107762 <vector108>:
.globl vector108
vector108:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $108
80107764:	6a 6c                	push   $0x6c
  jmp alltraps
80107766:	e9 0d f6 ff ff       	jmp    80106d78 <alltraps>

8010776b <vector109>:
.globl vector109
vector109:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $109
8010776d:	6a 6d                	push   $0x6d
  jmp alltraps
8010776f:	e9 04 f6 ff ff       	jmp    80106d78 <alltraps>

80107774 <vector110>:
.globl vector110
vector110:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $110
80107776:	6a 6e                	push   $0x6e
  jmp alltraps
80107778:	e9 fb f5 ff ff       	jmp    80106d78 <alltraps>

8010777d <vector111>:
.globl vector111
vector111:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $111
8010777f:	6a 6f                	push   $0x6f
  jmp alltraps
80107781:	e9 f2 f5 ff ff       	jmp    80106d78 <alltraps>

80107786 <vector112>:
.globl vector112
vector112:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $112
80107788:	6a 70                	push   $0x70
  jmp alltraps
8010778a:	e9 e9 f5 ff ff       	jmp    80106d78 <alltraps>

8010778f <vector113>:
.globl vector113
vector113:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $113
80107791:	6a 71                	push   $0x71
  jmp alltraps
80107793:	e9 e0 f5 ff ff       	jmp    80106d78 <alltraps>

80107798 <vector114>:
.globl vector114
vector114:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $114
8010779a:	6a 72                	push   $0x72
  jmp alltraps
8010779c:	e9 d7 f5 ff ff       	jmp    80106d78 <alltraps>

801077a1 <vector115>:
.globl vector115
vector115:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $115
801077a3:	6a 73                	push   $0x73
  jmp alltraps
801077a5:	e9 ce f5 ff ff       	jmp    80106d78 <alltraps>

801077aa <vector116>:
.globl vector116
vector116:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $116
801077ac:	6a 74                	push   $0x74
  jmp alltraps
801077ae:	e9 c5 f5 ff ff       	jmp    80106d78 <alltraps>

801077b3 <vector117>:
.globl vector117
vector117:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $117
801077b5:	6a 75                	push   $0x75
  jmp alltraps
801077b7:	e9 bc f5 ff ff       	jmp    80106d78 <alltraps>

801077bc <vector118>:
.globl vector118
vector118:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $118
801077be:	6a 76                	push   $0x76
  jmp alltraps
801077c0:	e9 b3 f5 ff ff       	jmp    80106d78 <alltraps>

801077c5 <vector119>:
.globl vector119
vector119:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $119
801077c7:	6a 77                	push   $0x77
  jmp alltraps
801077c9:	e9 aa f5 ff ff       	jmp    80106d78 <alltraps>

801077ce <vector120>:
.globl vector120
vector120:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $120
801077d0:	6a 78                	push   $0x78
  jmp alltraps
801077d2:	e9 a1 f5 ff ff       	jmp    80106d78 <alltraps>

801077d7 <vector121>:
.globl vector121
vector121:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $121
801077d9:	6a 79                	push   $0x79
  jmp alltraps
801077db:	e9 98 f5 ff ff       	jmp    80106d78 <alltraps>

801077e0 <vector122>:
.globl vector122
vector122:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $122
801077e2:	6a 7a                	push   $0x7a
  jmp alltraps
801077e4:	e9 8f f5 ff ff       	jmp    80106d78 <alltraps>

801077e9 <vector123>:
.globl vector123
vector123:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $123
801077eb:	6a 7b                	push   $0x7b
  jmp alltraps
801077ed:	e9 86 f5 ff ff       	jmp    80106d78 <alltraps>

801077f2 <vector124>:
.globl vector124
vector124:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $124
801077f4:	6a 7c                	push   $0x7c
  jmp alltraps
801077f6:	e9 7d f5 ff ff       	jmp    80106d78 <alltraps>

801077fb <vector125>:
.globl vector125
vector125:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $125
801077fd:	6a 7d                	push   $0x7d
  jmp alltraps
801077ff:	e9 74 f5 ff ff       	jmp    80106d78 <alltraps>

80107804 <vector126>:
.globl vector126
vector126:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $126
80107806:	6a 7e                	push   $0x7e
  jmp alltraps
80107808:	e9 6b f5 ff ff       	jmp    80106d78 <alltraps>

8010780d <vector127>:
.globl vector127
vector127:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $127
8010780f:	6a 7f                	push   $0x7f
  jmp alltraps
80107811:	e9 62 f5 ff ff       	jmp    80106d78 <alltraps>

80107816 <vector128>:
.globl vector128
vector128:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $128
80107818:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010781d:	e9 56 f5 ff ff       	jmp    80106d78 <alltraps>

80107822 <vector129>:
.globl vector129
vector129:
  pushl $0
80107822:	6a 00                	push   $0x0
  pushl $129
80107824:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107829:	e9 4a f5 ff ff       	jmp    80106d78 <alltraps>

8010782e <vector130>:
.globl vector130
vector130:
  pushl $0
8010782e:	6a 00                	push   $0x0
  pushl $130
80107830:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107835:	e9 3e f5 ff ff       	jmp    80106d78 <alltraps>

8010783a <vector131>:
.globl vector131
vector131:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $131
8010783c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107841:	e9 32 f5 ff ff       	jmp    80106d78 <alltraps>

80107846 <vector132>:
.globl vector132
vector132:
  pushl $0
80107846:	6a 00                	push   $0x0
  pushl $132
80107848:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010784d:	e9 26 f5 ff ff       	jmp    80106d78 <alltraps>

80107852 <vector133>:
.globl vector133
vector133:
  pushl $0
80107852:	6a 00                	push   $0x0
  pushl $133
80107854:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107859:	e9 1a f5 ff ff       	jmp    80106d78 <alltraps>

8010785e <vector134>:
.globl vector134
vector134:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $134
80107860:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107865:	e9 0e f5 ff ff       	jmp    80106d78 <alltraps>

8010786a <vector135>:
.globl vector135
vector135:
  pushl $0
8010786a:	6a 00                	push   $0x0
  pushl $135
8010786c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107871:	e9 02 f5 ff ff       	jmp    80106d78 <alltraps>

80107876 <vector136>:
.globl vector136
vector136:
  pushl $0
80107876:	6a 00                	push   $0x0
  pushl $136
80107878:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010787d:	e9 f6 f4 ff ff       	jmp    80106d78 <alltraps>

80107882 <vector137>:
.globl vector137
vector137:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $137
80107884:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107889:	e9 ea f4 ff ff       	jmp    80106d78 <alltraps>

8010788e <vector138>:
.globl vector138
vector138:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $138
80107890:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107895:	e9 de f4 ff ff       	jmp    80106d78 <alltraps>

8010789a <vector139>:
.globl vector139
vector139:
  pushl $0
8010789a:	6a 00                	push   $0x0
  pushl $139
8010789c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801078a1:	e9 d2 f4 ff ff       	jmp    80106d78 <alltraps>

801078a6 <vector140>:
.globl vector140
vector140:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $140
801078a8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801078ad:	e9 c6 f4 ff ff       	jmp    80106d78 <alltraps>

801078b2 <vector141>:
.globl vector141
vector141:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $141
801078b4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801078b9:	e9 ba f4 ff ff       	jmp    80106d78 <alltraps>

801078be <vector142>:
.globl vector142
vector142:
  pushl $0
801078be:	6a 00                	push   $0x0
  pushl $142
801078c0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801078c5:	e9 ae f4 ff ff       	jmp    80106d78 <alltraps>

801078ca <vector143>:
.globl vector143
vector143:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $143
801078cc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801078d1:	e9 a2 f4 ff ff       	jmp    80106d78 <alltraps>

801078d6 <vector144>:
.globl vector144
vector144:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $144
801078d8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801078dd:	e9 96 f4 ff ff       	jmp    80106d78 <alltraps>

801078e2 <vector145>:
.globl vector145
vector145:
  pushl $0
801078e2:	6a 00                	push   $0x0
  pushl $145
801078e4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801078e9:	e9 8a f4 ff ff       	jmp    80106d78 <alltraps>

801078ee <vector146>:
.globl vector146
vector146:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $146
801078f0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801078f5:	e9 7e f4 ff ff       	jmp    80106d78 <alltraps>

801078fa <vector147>:
.globl vector147
vector147:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $147
801078fc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107901:	e9 72 f4 ff ff       	jmp    80106d78 <alltraps>

80107906 <vector148>:
.globl vector148
vector148:
  pushl $0
80107906:	6a 00                	push   $0x0
  pushl $148
80107908:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010790d:	e9 66 f4 ff ff       	jmp    80106d78 <alltraps>

80107912 <vector149>:
.globl vector149
vector149:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $149
80107914:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107919:	e9 5a f4 ff ff       	jmp    80106d78 <alltraps>

8010791e <vector150>:
.globl vector150
vector150:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $150
80107920:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107925:	e9 4e f4 ff ff       	jmp    80106d78 <alltraps>

8010792a <vector151>:
.globl vector151
vector151:
  pushl $0
8010792a:	6a 00                	push   $0x0
  pushl $151
8010792c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107931:	e9 42 f4 ff ff       	jmp    80106d78 <alltraps>

80107936 <vector152>:
.globl vector152
vector152:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $152
80107938:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010793d:	e9 36 f4 ff ff       	jmp    80106d78 <alltraps>

80107942 <vector153>:
.globl vector153
vector153:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $153
80107944:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107949:	e9 2a f4 ff ff       	jmp    80106d78 <alltraps>

8010794e <vector154>:
.globl vector154
vector154:
  pushl $0
8010794e:	6a 00                	push   $0x0
  pushl $154
80107950:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107955:	e9 1e f4 ff ff       	jmp    80106d78 <alltraps>

8010795a <vector155>:
.globl vector155
vector155:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $155
8010795c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107961:	e9 12 f4 ff ff       	jmp    80106d78 <alltraps>

80107966 <vector156>:
.globl vector156
vector156:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $156
80107968:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010796d:	e9 06 f4 ff ff       	jmp    80106d78 <alltraps>

80107972 <vector157>:
.globl vector157
vector157:
  pushl $0
80107972:	6a 00                	push   $0x0
  pushl $157
80107974:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107979:	e9 fa f3 ff ff       	jmp    80106d78 <alltraps>

8010797e <vector158>:
.globl vector158
vector158:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $158
80107980:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107985:	e9 ee f3 ff ff       	jmp    80106d78 <alltraps>

8010798a <vector159>:
.globl vector159
vector159:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $159
8010798c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107991:	e9 e2 f3 ff ff       	jmp    80106d78 <alltraps>

80107996 <vector160>:
.globl vector160
vector160:
  pushl $0
80107996:	6a 00                	push   $0x0
  pushl $160
80107998:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010799d:	e9 d6 f3 ff ff       	jmp    80106d78 <alltraps>

801079a2 <vector161>:
.globl vector161
vector161:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $161
801079a4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801079a9:	e9 ca f3 ff ff       	jmp    80106d78 <alltraps>

801079ae <vector162>:
.globl vector162
vector162:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $162
801079b0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801079b5:	e9 be f3 ff ff       	jmp    80106d78 <alltraps>

801079ba <vector163>:
.globl vector163
vector163:
  pushl $0
801079ba:	6a 00                	push   $0x0
  pushl $163
801079bc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801079c1:	e9 b2 f3 ff ff       	jmp    80106d78 <alltraps>

801079c6 <vector164>:
.globl vector164
vector164:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $164
801079c8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801079cd:	e9 a6 f3 ff ff       	jmp    80106d78 <alltraps>

801079d2 <vector165>:
.globl vector165
vector165:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $165
801079d4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801079d9:	e9 9a f3 ff ff       	jmp    80106d78 <alltraps>

801079de <vector166>:
.globl vector166
vector166:
  pushl $0
801079de:	6a 00                	push   $0x0
  pushl $166
801079e0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801079e5:	e9 8e f3 ff ff       	jmp    80106d78 <alltraps>

801079ea <vector167>:
.globl vector167
vector167:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $167
801079ec:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801079f1:	e9 82 f3 ff ff       	jmp    80106d78 <alltraps>

801079f6 <vector168>:
.globl vector168
vector168:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $168
801079f8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801079fd:	e9 76 f3 ff ff       	jmp    80106d78 <alltraps>

80107a02 <vector169>:
.globl vector169
vector169:
  pushl $0
80107a02:	6a 00                	push   $0x0
  pushl $169
80107a04:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a09:	e9 6a f3 ff ff       	jmp    80106d78 <alltraps>

80107a0e <vector170>:
.globl vector170
vector170:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $170
80107a10:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a15:	e9 5e f3 ff ff       	jmp    80106d78 <alltraps>

80107a1a <vector171>:
.globl vector171
vector171:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $171
80107a1c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a21:	e9 52 f3 ff ff       	jmp    80106d78 <alltraps>

80107a26 <vector172>:
.globl vector172
vector172:
  pushl $0
80107a26:	6a 00                	push   $0x0
  pushl $172
80107a28:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a2d:	e9 46 f3 ff ff       	jmp    80106d78 <alltraps>

80107a32 <vector173>:
.globl vector173
vector173:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $173
80107a34:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a39:	e9 3a f3 ff ff       	jmp    80106d78 <alltraps>

80107a3e <vector174>:
.globl vector174
vector174:
  pushl $0
80107a3e:	6a 00                	push   $0x0
  pushl $174
80107a40:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a45:	e9 2e f3 ff ff       	jmp    80106d78 <alltraps>

80107a4a <vector175>:
.globl vector175
vector175:
  pushl $0
80107a4a:	6a 00                	push   $0x0
  pushl $175
80107a4c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107a51:	e9 22 f3 ff ff       	jmp    80106d78 <alltraps>

80107a56 <vector176>:
.globl vector176
vector176:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $176
80107a58:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107a5d:	e9 16 f3 ff ff       	jmp    80106d78 <alltraps>

80107a62 <vector177>:
.globl vector177
vector177:
  pushl $0
80107a62:	6a 00                	push   $0x0
  pushl $177
80107a64:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107a69:	e9 0a f3 ff ff       	jmp    80106d78 <alltraps>

80107a6e <vector178>:
.globl vector178
vector178:
  pushl $0
80107a6e:	6a 00                	push   $0x0
  pushl $178
80107a70:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107a75:	e9 fe f2 ff ff       	jmp    80106d78 <alltraps>

80107a7a <vector179>:
.globl vector179
vector179:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $179
80107a7c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107a81:	e9 f2 f2 ff ff       	jmp    80106d78 <alltraps>

80107a86 <vector180>:
.globl vector180
vector180:
  pushl $0
80107a86:	6a 00                	push   $0x0
  pushl $180
80107a88:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107a8d:	e9 e6 f2 ff ff       	jmp    80106d78 <alltraps>

80107a92 <vector181>:
.globl vector181
vector181:
  pushl $0
80107a92:	6a 00                	push   $0x0
  pushl $181
80107a94:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107a99:	e9 da f2 ff ff       	jmp    80106d78 <alltraps>

80107a9e <vector182>:
.globl vector182
vector182:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $182
80107aa0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107aa5:	e9 ce f2 ff ff       	jmp    80106d78 <alltraps>

80107aaa <vector183>:
.globl vector183
vector183:
  pushl $0
80107aaa:	6a 00                	push   $0x0
  pushl $183
80107aac:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107ab1:	e9 c2 f2 ff ff       	jmp    80106d78 <alltraps>

80107ab6 <vector184>:
.globl vector184
vector184:
  pushl $0
80107ab6:	6a 00                	push   $0x0
  pushl $184
80107ab8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107abd:	e9 b6 f2 ff ff       	jmp    80106d78 <alltraps>

80107ac2 <vector185>:
.globl vector185
vector185:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $185
80107ac4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107ac9:	e9 aa f2 ff ff       	jmp    80106d78 <alltraps>

80107ace <vector186>:
.globl vector186
vector186:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $186
80107ad0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107ad5:	e9 9e f2 ff ff       	jmp    80106d78 <alltraps>

80107ada <vector187>:
.globl vector187
vector187:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $187
80107adc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107ae1:	e9 92 f2 ff ff       	jmp    80106d78 <alltraps>

80107ae6 <vector188>:
.globl vector188
vector188:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $188
80107ae8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107aed:	e9 86 f2 ff ff       	jmp    80106d78 <alltraps>

80107af2 <vector189>:
.globl vector189
vector189:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $189
80107af4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107af9:	e9 7a f2 ff ff       	jmp    80106d78 <alltraps>

80107afe <vector190>:
.globl vector190
vector190:
  pushl $0
80107afe:	6a 00                	push   $0x0
  pushl $190
80107b00:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b05:	e9 6e f2 ff ff       	jmp    80106d78 <alltraps>

80107b0a <vector191>:
.globl vector191
vector191:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $191
80107b0c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b11:	e9 62 f2 ff ff       	jmp    80106d78 <alltraps>

80107b16 <vector192>:
.globl vector192
vector192:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $192
80107b18:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b1d:	e9 56 f2 ff ff       	jmp    80106d78 <alltraps>

80107b22 <vector193>:
.globl vector193
vector193:
  pushl $0
80107b22:	6a 00                	push   $0x0
  pushl $193
80107b24:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b29:	e9 4a f2 ff ff       	jmp    80106d78 <alltraps>

80107b2e <vector194>:
.globl vector194
vector194:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $194
80107b30:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b35:	e9 3e f2 ff ff       	jmp    80106d78 <alltraps>

80107b3a <vector195>:
.globl vector195
vector195:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $195
80107b3c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b41:	e9 32 f2 ff ff       	jmp    80106d78 <alltraps>

80107b46 <vector196>:
.globl vector196
vector196:
  pushl $0
80107b46:	6a 00                	push   $0x0
  pushl $196
80107b48:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b4d:	e9 26 f2 ff ff       	jmp    80106d78 <alltraps>

80107b52 <vector197>:
.globl vector197
vector197:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $197
80107b54:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107b59:	e9 1a f2 ff ff       	jmp    80106d78 <alltraps>

80107b5e <vector198>:
.globl vector198
vector198:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $198
80107b60:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107b65:	e9 0e f2 ff ff       	jmp    80106d78 <alltraps>

80107b6a <vector199>:
.globl vector199
vector199:
  pushl $0
80107b6a:	6a 00                	push   $0x0
  pushl $199
80107b6c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107b71:	e9 02 f2 ff ff       	jmp    80106d78 <alltraps>

80107b76 <vector200>:
.globl vector200
vector200:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $200
80107b78:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107b7d:	e9 f6 f1 ff ff       	jmp    80106d78 <alltraps>

80107b82 <vector201>:
.globl vector201
vector201:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $201
80107b84:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107b89:	e9 ea f1 ff ff       	jmp    80106d78 <alltraps>

80107b8e <vector202>:
.globl vector202
vector202:
  pushl $0
80107b8e:	6a 00                	push   $0x0
  pushl $202
80107b90:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107b95:	e9 de f1 ff ff       	jmp    80106d78 <alltraps>

80107b9a <vector203>:
.globl vector203
vector203:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $203
80107b9c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107ba1:	e9 d2 f1 ff ff       	jmp    80106d78 <alltraps>

80107ba6 <vector204>:
.globl vector204
vector204:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $204
80107ba8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107bad:	e9 c6 f1 ff ff       	jmp    80106d78 <alltraps>

80107bb2 <vector205>:
.globl vector205
vector205:
  pushl $0
80107bb2:	6a 00                	push   $0x0
  pushl $205
80107bb4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107bb9:	e9 ba f1 ff ff       	jmp    80106d78 <alltraps>

80107bbe <vector206>:
.globl vector206
vector206:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $206
80107bc0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107bc5:	e9 ae f1 ff ff       	jmp    80106d78 <alltraps>

80107bca <vector207>:
.globl vector207
vector207:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $207
80107bcc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107bd1:	e9 a2 f1 ff ff       	jmp    80106d78 <alltraps>

80107bd6 <vector208>:
.globl vector208
vector208:
  pushl $0
80107bd6:	6a 00                	push   $0x0
  pushl $208
80107bd8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107bdd:	e9 96 f1 ff ff       	jmp    80106d78 <alltraps>

80107be2 <vector209>:
.globl vector209
vector209:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $209
80107be4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107be9:	e9 8a f1 ff ff       	jmp    80106d78 <alltraps>

80107bee <vector210>:
.globl vector210
vector210:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $210
80107bf0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107bf5:	e9 7e f1 ff ff       	jmp    80106d78 <alltraps>

80107bfa <vector211>:
.globl vector211
vector211:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $211
80107bfc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c01:	e9 72 f1 ff ff       	jmp    80106d78 <alltraps>

80107c06 <vector212>:
.globl vector212
vector212:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $212
80107c08:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c0d:	e9 66 f1 ff ff       	jmp    80106d78 <alltraps>

80107c12 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $213
80107c14:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c19:	e9 5a f1 ff ff       	jmp    80106d78 <alltraps>

80107c1e <vector214>:
.globl vector214
vector214:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $214
80107c20:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c25:	e9 4e f1 ff ff       	jmp    80106d78 <alltraps>

80107c2a <vector215>:
.globl vector215
vector215:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $215
80107c2c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c31:	e9 42 f1 ff ff       	jmp    80106d78 <alltraps>

80107c36 <vector216>:
.globl vector216
vector216:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $216
80107c38:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c3d:	e9 36 f1 ff ff       	jmp    80106d78 <alltraps>

80107c42 <vector217>:
.globl vector217
vector217:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $217
80107c44:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c49:	e9 2a f1 ff ff       	jmp    80106d78 <alltraps>

80107c4e <vector218>:
.globl vector218
vector218:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $218
80107c50:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107c55:	e9 1e f1 ff ff       	jmp    80106d78 <alltraps>

80107c5a <vector219>:
.globl vector219
vector219:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $219
80107c5c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107c61:	e9 12 f1 ff ff       	jmp    80106d78 <alltraps>

80107c66 <vector220>:
.globl vector220
vector220:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $220
80107c68:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107c6d:	e9 06 f1 ff ff       	jmp    80106d78 <alltraps>

80107c72 <vector221>:
.globl vector221
vector221:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $221
80107c74:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107c79:	e9 fa f0 ff ff       	jmp    80106d78 <alltraps>

80107c7e <vector222>:
.globl vector222
vector222:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $222
80107c80:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107c85:	e9 ee f0 ff ff       	jmp    80106d78 <alltraps>

80107c8a <vector223>:
.globl vector223
vector223:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $223
80107c8c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107c91:	e9 e2 f0 ff ff       	jmp    80106d78 <alltraps>

80107c96 <vector224>:
.globl vector224
vector224:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $224
80107c98:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107c9d:	e9 d6 f0 ff ff       	jmp    80106d78 <alltraps>

80107ca2 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ca2:	6a 00                	push   $0x0
  pushl $225
80107ca4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107ca9:	e9 ca f0 ff ff       	jmp    80106d78 <alltraps>

80107cae <vector226>:
.globl vector226
vector226:
  pushl $0
80107cae:	6a 00                	push   $0x0
  pushl $226
80107cb0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107cb5:	e9 be f0 ff ff       	jmp    80106d78 <alltraps>

80107cba <vector227>:
.globl vector227
vector227:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $227
80107cbc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107cc1:	e9 b2 f0 ff ff       	jmp    80106d78 <alltraps>

80107cc6 <vector228>:
.globl vector228
vector228:
  pushl $0
80107cc6:	6a 00                	push   $0x0
  pushl $228
80107cc8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107ccd:	e9 a6 f0 ff ff       	jmp    80106d78 <alltraps>

80107cd2 <vector229>:
.globl vector229
vector229:
  pushl $0
80107cd2:	6a 00                	push   $0x0
  pushl $229
80107cd4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107cd9:	e9 9a f0 ff ff       	jmp    80106d78 <alltraps>

80107cde <vector230>:
.globl vector230
vector230:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $230
80107ce0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ce5:	e9 8e f0 ff ff       	jmp    80106d78 <alltraps>

80107cea <vector231>:
.globl vector231
vector231:
  pushl $0
80107cea:	6a 00                	push   $0x0
  pushl $231
80107cec:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107cf1:	e9 82 f0 ff ff       	jmp    80106d78 <alltraps>

80107cf6 <vector232>:
.globl vector232
vector232:
  pushl $0
80107cf6:	6a 00                	push   $0x0
  pushl $232
80107cf8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107cfd:	e9 76 f0 ff ff       	jmp    80106d78 <alltraps>

80107d02 <vector233>:
.globl vector233
vector233:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $233
80107d04:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d09:	e9 6a f0 ff ff       	jmp    80106d78 <alltraps>

80107d0e <vector234>:
.globl vector234
vector234:
  pushl $0
80107d0e:	6a 00                	push   $0x0
  pushl $234
80107d10:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d15:	e9 5e f0 ff ff       	jmp    80106d78 <alltraps>

80107d1a <vector235>:
.globl vector235
vector235:
  pushl $0
80107d1a:	6a 00                	push   $0x0
  pushl $235
80107d1c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d21:	e9 52 f0 ff ff       	jmp    80106d78 <alltraps>

80107d26 <vector236>:
.globl vector236
vector236:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $236
80107d28:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d2d:	e9 46 f0 ff ff       	jmp    80106d78 <alltraps>

80107d32 <vector237>:
.globl vector237
vector237:
  pushl $0
80107d32:	6a 00                	push   $0x0
  pushl $237
80107d34:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d39:	e9 3a f0 ff ff       	jmp    80106d78 <alltraps>

80107d3e <vector238>:
.globl vector238
vector238:
  pushl $0
80107d3e:	6a 00                	push   $0x0
  pushl $238
80107d40:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d45:	e9 2e f0 ff ff       	jmp    80106d78 <alltraps>

80107d4a <vector239>:
.globl vector239
vector239:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $239
80107d4c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107d51:	e9 22 f0 ff ff       	jmp    80106d78 <alltraps>

80107d56 <vector240>:
.globl vector240
vector240:
  pushl $0
80107d56:	6a 00                	push   $0x0
  pushl $240
80107d58:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107d5d:	e9 16 f0 ff ff       	jmp    80106d78 <alltraps>

80107d62 <vector241>:
.globl vector241
vector241:
  pushl $0
80107d62:	6a 00                	push   $0x0
  pushl $241
80107d64:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107d69:	e9 0a f0 ff ff       	jmp    80106d78 <alltraps>

80107d6e <vector242>:
.globl vector242
vector242:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $242
80107d70:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107d75:	e9 fe ef ff ff       	jmp    80106d78 <alltraps>

80107d7a <vector243>:
.globl vector243
vector243:
  pushl $0
80107d7a:	6a 00                	push   $0x0
  pushl $243
80107d7c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107d81:	e9 f2 ef ff ff       	jmp    80106d78 <alltraps>

80107d86 <vector244>:
.globl vector244
vector244:
  pushl $0
80107d86:	6a 00                	push   $0x0
  pushl $244
80107d88:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107d8d:	e9 e6 ef ff ff       	jmp    80106d78 <alltraps>

80107d92 <vector245>:
.globl vector245
vector245:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $245
80107d94:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107d99:	e9 da ef ff ff       	jmp    80106d78 <alltraps>

80107d9e <vector246>:
.globl vector246
vector246:
  pushl $0
80107d9e:	6a 00                	push   $0x0
  pushl $246
80107da0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107da5:	e9 ce ef ff ff       	jmp    80106d78 <alltraps>

80107daa <vector247>:
.globl vector247
vector247:
  pushl $0
80107daa:	6a 00                	push   $0x0
  pushl $247
80107dac:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107db1:	e9 c2 ef ff ff       	jmp    80106d78 <alltraps>

80107db6 <vector248>:
.globl vector248
vector248:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $248
80107db8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107dbd:	e9 b6 ef ff ff       	jmp    80106d78 <alltraps>

80107dc2 <vector249>:
.globl vector249
vector249:
  pushl $0
80107dc2:	6a 00                	push   $0x0
  pushl $249
80107dc4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107dc9:	e9 aa ef ff ff       	jmp    80106d78 <alltraps>

80107dce <vector250>:
.globl vector250
vector250:
  pushl $0
80107dce:	6a 00                	push   $0x0
  pushl $250
80107dd0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107dd5:	e9 9e ef ff ff       	jmp    80106d78 <alltraps>

80107dda <vector251>:
.globl vector251
vector251:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $251
80107ddc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107de1:	e9 92 ef ff ff       	jmp    80106d78 <alltraps>

80107de6 <vector252>:
.globl vector252
vector252:
  pushl $0
80107de6:	6a 00                	push   $0x0
  pushl $252
80107de8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107ded:	e9 86 ef ff ff       	jmp    80106d78 <alltraps>

80107df2 <vector253>:
.globl vector253
vector253:
  pushl $0
80107df2:	6a 00                	push   $0x0
  pushl $253
80107df4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107df9:	e9 7a ef ff ff       	jmp    80106d78 <alltraps>

80107dfe <vector254>:
.globl vector254
vector254:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $254
80107e00:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e05:	e9 6e ef ff ff       	jmp    80106d78 <alltraps>

80107e0a <vector255>:
.globl vector255
vector255:
  pushl $0
80107e0a:	6a 00                	push   $0x0
  pushl $255
80107e0c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e11:	e9 62 ef ff ff       	jmp    80106d78 <alltraps>
	...

80107e18 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107e18:	55                   	push   %ebp
80107e19:	89 e5                	mov    %esp,%ebp
80107e1b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e21:	48                   	dec    %eax
80107e22:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e26:	8b 45 08             	mov    0x8(%ebp),%eax
80107e29:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e30:	c1 e8 10             	shr    $0x10,%eax
80107e33:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107e37:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e3a:	0f 01 10             	lgdtl  (%eax)
}
80107e3d:	c9                   	leave  
80107e3e:	c3                   	ret    

80107e3f <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107e3f:	55                   	push   %ebp
80107e40:	89 e5                	mov    %esp,%ebp
80107e42:	83 ec 04             	sub    $0x4,%esp
80107e45:	8b 45 08             	mov    0x8(%ebp),%eax
80107e48:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e4f:	0f 00 d8             	ltr    %ax
}
80107e52:	c9                   	leave  
80107e53:	c3                   	ret    

80107e54 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107e54:	55                   	push   %ebp
80107e55:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e57:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5a:	0f 22 d8             	mov    %eax,%cr3
}
80107e5d:	5d                   	pop    %ebp
80107e5e:	c3                   	ret    

80107e5f <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107e5f:	55                   	push   %ebp
80107e60:	89 e5                	mov    %esp,%ebp
80107e62:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107e65:	e8 fc c3 ff ff       	call   80104266 <cpuid>
80107e6a:	89 c2                	mov    %eax,%edx
80107e6c:	89 d0                	mov    %edx,%eax
80107e6e:	c1 e0 02             	shl    $0x2,%eax
80107e71:	01 d0                	add    %edx,%eax
80107e73:	01 c0                	add    %eax,%eax
80107e75:	01 d0                	add    %edx,%eax
80107e77:	c1 e0 04             	shl    $0x4,%eax
80107e7a:	05 c0 4c 11 80       	add    $0x80114cc0,%eax
80107e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e85:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e97:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9e:	8a 50 7d             	mov    0x7d(%eax),%dl
80107ea1:	83 e2 f0             	and    $0xfffffff0,%edx
80107ea4:	83 ca 0a             	or     $0xa,%edx
80107ea7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ead:	8a 50 7d             	mov    0x7d(%eax),%dl
80107eb0:	83 ca 10             	or     $0x10,%edx
80107eb3:	88 50 7d             	mov    %dl,0x7d(%eax)
80107eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb9:	8a 50 7d             	mov    0x7d(%eax),%dl
80107ebc:	83 e2 9f             	and    $0xffffff9f,%edx
80107ebf:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec5:	8a 50 7d             	mov    0x7d(%eax),%dl
80107ec8:	83 ca 80             	or     $0xffffff80,%edx
80107ecb:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed1:	8a 50 7e             	mov    0x7e(%eax),%dl
80107ed4:	83 ca 0f             	or     $0xf,%edx
80107ed7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edd:	8a 50 7e             	mov    0x7e(%eax),%dl
80107ee0:	83 e2 ef             	and    $0xffffffef,%edx
80107ee3:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee9:	8a 50 7e             	mov    0x7e(%eax),%dl
80107eec:	83 e2 df             	and    $0xffffffdf,%edx
80107eef:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	8a 50 7e             	mov    0x7e(%eax),%dl
80107ef8:	83 ca 40             	or     $0x40,%edx
80107efb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f01:	8a 50 7e             	mov    0x7e(%eax),%dl
80107f04:	83 ca 80             	or     $0xffffff80,%edx
80107f07:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f14:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f1b:	ff ff 
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107f27:	00 00 
80107f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f36:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107f3c:	83 e2 f0             	and    $0xfffffff0,%edx
80107f3f:	83 ca 02             	or     $0x2,%edx
80107f42:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4b:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107f51:	83 ca 10             	or     $0x10,%edx
80107f54:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5d:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107f63:	83 e2 9f             	and    $0xffffff9f,%edx
80107f66:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6f:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107f75:	83 ca 80             	or     $0xffffff80,%edx
80107f78:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f81:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107f87:	83 ca 0f             	or     $0xf,%edx
80107f8a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f93:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107f99:	83 e2 ef             	and    $0xffffffef,%edx
80107f9c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107fab:	83 e2 df             	and    $0xffffffdf,%edx
80107fae:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb7:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107fbd:	83 ca 40             	or     $0x40,%edx
80107fc0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc9:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107fcf:	83 ca 80             	or     $0xffffff80,%edx
80107fd2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107fec:	ff ff 
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107ff8:	00 00 
80107ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffd:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80108004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108007:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
8010800d:	83 e2 f0             	and    $0xfffffff0,%edx
80108010:	83 ca 0a             	or     $0xa,%edx
80108013:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801c:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80108022:	83 ca 10             	or     $0x10,%edx
80108025:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010802b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802e:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80108034:	83 ca 60             	or     $0x60,%edx
80108037:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80108046:	83 ca 80             	or     $0xffffff80,%edx
80108049:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010804f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108052:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80108058:	83 ca 0f             	or     $0xf,%edx
8010805b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108064:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010806a:	83 e2 ef             	and    $0xffffffef,%edx
8010806d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108076:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010807c:	83 e2 df             	and    $0xffffffdf,%edx
8010807f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108088:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010808e:	83 ca 40             	or     $0x40,%edx
80108091:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809a:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
801080a0:	83 ca 80             	or     $0xffffff80,%edx
801080a3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ac:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801080b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b6:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080bd:	ff ff 
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080c9:	00 00 
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d8:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801080de:	83 e2 f0             	and    $0xfffffff0,%edx
801080e1:	83 ca 02             	or     $0x2,%edx
801080e4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ed:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801080f3:	83 ca 10             	or     $0x10,%edx
801080f6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ff:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108105:	83 ca 60             	or     $0x60,%edx
80108108:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010810e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108111:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108117:	83 ca 80             	or     $0xffffff80,%edx
8010811a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108123:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108129:	83 ca 0f             	or     $0xf,%edx
8010812c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108135:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010813b:	83 e2 ef             	and    $0xffffffef,%edx
8010813e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108147:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010814d:	83 e2 df             	and    $0xffffffdf,%edx
80108150:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108159:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010815f:	83 ca 40             	or     $0x40,%edx
80108162:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108171:	83 ca 80             	or     $0xffffff80,%edx
80108174:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80108184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108187:	83 c0 70             	add    $0x70,%eax
8010818a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80108191:	00 
80108192:	89 04 24             	mov    %eax,(%esp)
80108195:	e8 7e fc ff ff       	call   80107e18 <lgdt>
}
8010819a:	c9                   	leave  
8010819b:	c3                   	ret    

8010819c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010819c:	55                   	push   %ebp
8010819d:	89 e5                	mov    %esp,%ebp
8010819f:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801081a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801081a5:	c1 e8 16             	shr    $0x16,%eax
801081a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081af:	8b 45 08             	mov    0x8(%ebp),%eax
801081b2:	01 d0                	add    %edx,%eax
801081b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801081b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ba:	8b 00                	mov    (%eax),%eax
801081bc:	83 e0 01             	and    $0x1,%eax
801081bf:	85 c0                	test   %eax,%eax
801081c1:	74 14                	je     801081d7 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081c6:	8b 00                	mov    (%eax),%eax
801081c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081cd:	05 00 00 00 80       	add    $0x80000000,%eax
801081d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081d5:	eb 48                	jmp    8010821f <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801081d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801081db:	74 0e                	je     801081eb <walkpgdir+0x4f>
801081dd:	e8 8d ab ff ff       	call   80102d6f <kalloc>
801081e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081e9:	75 07                	jne    801081f2 <walkpgdir+0x56>
      return 0;
801081eb:	b8 00 00 00 00       	mov    $0x0,%eax
801081f0:	eb 44                	jmp    80108236 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801081f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081f9:	00 
801081fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108201:	00 
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	89 04 24             	mov    %eax,(%esp)
80108208:	e8 95 cf ff ff       	call   801051a2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010820d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108210:	05 00 00 00 80       	add    $0x80000000,%eax
80108215:	83 c8 07             	or     $0x7,%eax
80108218:	89 c2                	mov    %eax,%edx
8010821a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010821d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010821f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108222:	c1 e8 0c             	shr    $0xc,%eax
80108225:	25 ff 03 00 00       	and    $0x3ff,%eax
8010822a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108234:	01 d0                	add    %edx,%eax
}
80108236:	c9                   	leave  
80108237:	c3                   	ret    

80108238 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108238:	55                   	push   %ebp
80108239:	89 e5                	mov    %esp,%ebp
8010823b:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010823e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108241:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108246:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108249:	8b 55 0c             	mov    0xc(%ebp),%edx
8010824c:	8b 45 10             	mov    0x10(%ebp),%eax
8010824f:	01 d0                	add    %edx,%eax
80108251:	48                   	dec    %eax
80108252:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010825a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108261:	00 
80108262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108265:	89 44 24 04          	mov    %eax,0x4(%esp)
80108269:	8b 45 08             	mov    0x8(%ebp),%eax
8010826c:	89 04 24             	mov    %eax,(%esp)
8010826f:	e8 28 ff ff ff       	call   8010819c <walkpgdir>
80108274:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108277:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010827b:	75 07                	jne    80108284 <mappages+0x4c>
      return -1;
8010827d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108282:	eb 48                	jmp    801082cc <mappages+0x94>
    if(*pte & PTE_P)
80108284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108287:	8b 00                	mov    (%eax),%eax
80108289:	83 e0 01             	and    $0x1,%eax
8010828c:	85 c0                	test   %eax,%eax
8010828e:	74 0c                	je     8010829c <mappages+0x64>
      panic("remap");
80108290:	c7 04 24 80 97 10 80 	movl   $0x80109780,(%esp)
80108297:	e8 e6 82 ff ff       	call   80100582 <panic>
    *pte = pa | perm | PTE_P;
8010829c:	8b 45 18             	mov    0x18(%ebp),%eax
8010829f:	0b 45 14             	or     0x14(%ebp),%eax
801082a2:	83 c8 01             	or     $0x1,%eax
801082a5:	89 c2                	mov    %eax,%edx
801082a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082aa:	89 10                	mov    %edx,(%eax)
    if(a == last)
801082ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801082b2:	75 08                	jne    801082bc <mappages+0x84>
      break;
801082b4:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801082b5:	b8 00 00 00 00       	mov    $0x0,%eax
801082ba:	eb 10                	jmp    801082cc <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801082bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801082c3:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801082ca:	eb 8e                	jmp    8010825a <mappages+0x22>
  return 0;
}
801082cc:	c9                   	leave  
801082cd:	c3                   	ret    

801082ce <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801082ce:	55                   	push   %ebp
801082cf:	89 e5                	mov    %esp,%ebp
801082d1:	53                   	push   %ebx
801082d2:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801082d5:	e8 95 aa ff ff       	call   80102d6f <kalloc>
801082da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082e1:	75 0a                	jne    801082ed <setupkvm+0x1f>
    return 0;
801082e3:	b8 00 00 00 00       	mov    $0x0,%eax
801082e8:	e9 84 00 00 00       	jmp    80108371 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
801082ed:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082f4:	00 
801082f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082fc:	00 
801082fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108300:	89 04 24             	mov    %eax,(%esp)
80108303:	e8 9a ce ff ff       	call   801051a2 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108308:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
8010830f:	eb 54                	jmp    80108365 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108314:	8b 48 0c             	mov    0xc(%eax),%ecx
80108317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831a:	8b 50 04             	mov    0x4(%eax),%edx
8010831d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108320:	8b 58 08             	mov    0x8(%eax),%ebx
80108323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108326:	8b 40 04             	mov    0x4(%eax),%eax
80108329:	29 c3                	sub    %eax,%ebx
8010832b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832e:	8b 00                	mov    (%eax),%eax
80108330:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108334:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108338:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010833c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108340:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108343:	89 04 24             	mov    %eax,(%esp)
80108346:	e8 ed fe ff ff       	call   80108238 <mappages>
8010834b:	85 c0                	test   %eax,%eax
8010834d:	79 12                	jns    80108361 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
8010834f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108352:	89 04 24             	mov    %eax,(%esp)
80108355:	e8 1a 05 00 00       	call   80108874 <freevm>
      return 0;
8010835a:	b8 00 00 00 00       	mov    $0x0,%eax
8010835f:	eb 10                	jmp    80108371 <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108361:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108365:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
8010836c:	72 a3                	jb     80108311 <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
8010836e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108371:	83 c4 34             	add    $0x34,%esp
80108374:	5b                   	pop    %ebx
80108375:	5d                   	pop    %ebp
80108376:	c3                   	ret    

80108377 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108377:	55                   	push   %ebp
80108378:	89 e5                	mov    %esp,%ebp
8010837a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010837d:	e8 4c ff ff ff       	call   801082ce <setupkvm>
80108382:	a3 e4 79 11 80       	mov    %eax,0x801179e4
  switchkvm();
80108387:	e8 02 00 00 00       	call   8010838e <switchkvm>
}
8010838c:	c9                   	leave  
8010838d:	c3                   	ret    

8010838e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010838e:	55                   	push   %ebp
8010838f:	89 e5                	mov    %esp,%ebp
80108391:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108394:	a1 e4 79 11 80       	mov    0x801179e4,%eax
80108399:	05 00 00 00 80       	add    $0x80000000,%eax
8010839e:	89 04 24             	mov    %eax,(%esp)
801083a1:	e8 ae fa ff ff       	call   80107e54 <lcr3>
}
801083a6:	c9                   	leave  
801083a7:	c3                   	ret    

801083a8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801083a8:	55                   	push   %ebp
801083a9:	89 e5                	mov    %esp,%ebp
801083ab:	57                   	push   %edi
801083ac:	56                   	push   %esi
801083ad:	53                   	push   %ebx
801083ae:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
801083b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801083b5:	75 0c                	jne    801083c3 <switchuvm+0x1b>
    panic("switchuvm: no process");
801083b7:	c7 04 24 86 97 10 80 	movl   $0x80109786,(%esp)
801083be:	e8 bf 81 ff ff       	call   80100582 <panic>
  if(p->kstack == 0)
801083c3:	8b 45 08             	mov    0x8(%ebp),%eax
801083c6:	8b 40 08             	mov    0x8(%eax),%eax
801083c9:	85 c0                	test   %eax,%eax
801083cb:	75 0c                	jne    801083d9 <switchuvm+0x31>
    panic("switchuvm: no kstack");
801083cd:	c7 04 24 9c 97 10 80 	movl   $0x8010979c,(%esp)
801083d4:	e8 a9 81 ff ff       	call   80100582 <panic>
  if(p->pgdir == 0)
801083d9:	8b 45 08             	mov    0x8(%ebp),%eax
801083dc:	8b 40 04             	mov    0x4(%eax),%eax
801083df:	85 c0                	test   %eax,%eax
801083e1:	75 0c                	jne    801083ef <switchuvm+0x47>
    panic("switchuvm: no pgdir");
801083e3:	c7 04 24 b1 97 10 80 	movl   $0x801097b1,(%esp)
801083ea:	e8 93 81 ff ff       	call   80100582 <panic>

  pushcli();
801083ef:	e8 aa cc ff ff       	call   8010509e <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801083f4:	e8 b2 be ff ff       	call   801042ab <mycpu>
801083f9:	89 c3                	mov    %eax,%ebx
801083fb:	e8 ab be ff ff       	call   801042ab <mycpu>
80108400:	83 c0 08             	add    $0x8,%eax
80108403:	89 c6                	mov    %eax,%esi
80108405:	e8 a1 be ff ff       	call   801042ab <mycpu>
8010840a:	83 c0 08             	add    $0x8,%eax
8010840d:	c1 e8 10             	shr    $0x10,%eax
80108410:	89 c7                	mov    %eax,%edi
80108412:	e8 94 be ff ff       	call   801042ab <mycpu>
80108417:	83 c0 08             	add    $0x8,%eax
8010841a:	c1 e8 18             	shr    $0x18,%eax
8010841d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80108424:	67 00 
80108426:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
8010842d:	89 f9                	mov    %edi,%ecx
8010842f:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108435:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
8010843b:	83 e2 f0             	and    $0xfffffff0,%edx
8010843e:	83 ca 09             	or     $0x9,%edx
80108441:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108447:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
8010844d:	83 ca 10             	or     $0x10,%edx
80108450:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108456:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
8010845c:	83 e2 9f             	and    $0xffffff9f,%edx
8010845f:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108465:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
8010846b:	83 ca 80             	or     $0xffffff80,%edx
8010846e:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108474:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
8010847a:	83 e2 f0             	and    $0xfffffff0,%edx
8010847d:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80108483:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108489:	83 e2 ef             	and    $0xffffffef,%edx
8010848c:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80108492:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108498:	83 e2 df             	and    $0xffffffdf,%edx
8010849b:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801084a1:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
801084a7:	83 ca 40             	or     $0x40,%edx
801084aa:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801084b0:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
801084b6:	83 e2 7f             	and    $0x7f,%edx
801084b9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801084bf:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801084c5:	e8 e1 bd ff ff       	call   801042ab <mycpu>
801084ca:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801084d0:	83 e2 ef             	and    $0xffffffef,%edx
801084d3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801084d9:	e8 cd bd ff ff       	call   801042ab <mycpu>
801084de:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801084e4:	e8 c2 bd ff ff       	call   801042ab <mycpu>
801084e9:	8b 55 08             	mov    0x8(%ebp),%edx
801084ec:	8b 52 08             	mov    0x8(%edx),%edx
801084ef:	81 c2 00 10 00 00    	add    $0x1000,%edx
801084f5:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801084f8:	e8 ae bd ff ff       	call   801042ab <mycpu>
801084fd:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80108503:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
8010850a:	e8 30 f9 ff ff       	call   80107e3f <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010850f:	8b 45 08             	mov    0x8(%ebp),%eax
80108512:	8b 40 04             	mov    0x4(%eax),%eax
80108515:	05 00 00 00 80       	add    $0x80000000,%eax
8010851a:	89 04 24             	mov    %eax,(%esp)
8010851d:	e8 32 f9 ff ff       	call   80107e54 <lcr3>
  popcli();
80108522:	e8 c1 cb ff ff       	call   801050e8 <popcli>
}
80108527:	83 c4 1c             	add    $0x1c,%esp
8010852a:	5b                   	pop    %ebx
8010852b:	5e                   	pop    %esi
8010852c:	5f                   	pop    %edi
8010852d:	5d                   	pop    %ebp
8010852e:	c3                   	ret    

8010852f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010852f:	55                   	push   %ebp
80108530:	89 e5                	mov    %esp,%ebp
80108532:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80108535:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010853c:	76 0c                	jbe    8010854a <inituvm+0x1b>
    panic("inituvm: more than a page");
8010853e:	c7 04 24 c5 97 10 80 	movl   $0x801097c5,(%esp)
80108545:	e8 38 80 ff ff       	call   80100582 <panic>
  mem = kalloc();
8010854a:	e8 20 a8 ff ff       	call   80102d6f <kalloc>
8010854f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108552:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108559:	00 
8010855a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108561:	00 
80108562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108565:	89 04 24             	mov    %eax,(%esp)
80108568:	e8 35 cc ff ff       	call   801051a2 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010856d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108570:	05 00 00 00 80       	add    $0x80000000,%eax
80108575:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010857c:	00 
8010857d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108581:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108588:	00 
80108589:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108590:	00 
80108591:	8b 45 08             	mov    0x8(%ebp),%eax
80108594:	89 04 24             	mov    %eax,(%esp)
80108597:	e8 9c fc ff ff       	call   80108238 <mappages>
  memmove(mem, init, sz);
8010859c:	8b 45 10             	mov    0x10(%ebp),%eax
8010859f:	89 44 24 08          	mov    %eax,0x8(%esp)
801085a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801085a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801085aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ad:	89 04 24             	mov    %eax,(%esp)
801085b0:	e8 b6 cc ff ff       	call   8010526b <memmove>
}
801085b5:	c9                   	leave  
801085b6:	c3                   	ret    

801085b7 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801085b7:	55                   	push   %ebp
801085b8:	89 e5                	mov    %esp,%ebp
801085ba:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801085bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801085c0:	25 ff 0f 00 00       	and    $0xfff,%eax
801085c5:	85 c0                	test   %eax,%eax
801085c7:	74 0c                	je     801085d5 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
801085c9:	c7 04 24 e0 97 10 80 	movl   $0x801097e0,(%esp)
801085d0:	e8 ad 7f ff ff       	call   80100582 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801085d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085dc:	e9 a6 00 00 00       	jmp    80108687 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e4:	8b 55 0c             	mov    0xc(%ebp),%edx
801085e7:	01 d0                	add    %edx,%eax
801085e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085f0:	00 
801085f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801085f5:	8b 45 08             	mov    0x8(%ebp),%eax
801085f8:	89 04 24             	mov    %eax,(%esp)
801085fb:	e8 9c fb ff ff       	call   8010819c <walkpgdir>
80108600:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108607:	75 0c                	jne    80108615 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80108609:	c7 04 24 03 98 10 80 	movl   $0x80109803,(%esp)
80108610:	e8 6d 7f ff ff       	call   80100582 <panic>
    pa = PTE_ADDR(*pte);
80108615:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108618:	8b 00                	mov    (%eax),%eax
8010861a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010861f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108625:	8b 55 18             	mov    0x18(%ebp),%edx
80108628:	29 c2                	sub    %eax,%edx
8010862a:	89 d0                	mov    %edx,%eax
8010862c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108631:	77 0f                	ja     80108642 <loaduvm+0x8b>
      n = sz - i;
80108633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108636:	8b 55 18             	mov    0x18(%ebp),%edx
80108639:	29 c2                	sub    %eax,%edx
8010863b:	89 d0                	mov    %edx,%eax
8010863d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108640:	eb 07                	jmp    80108649 <loaduvm+0x92>
    else
      n = PGSIZE;
80108642:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010864c:	8b 55 14             	mov    0x14(%ebp),%edx
8010864f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80108652:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108655:	05 00 00 00 80       	add    $0x80000000,%eax
8010865a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010865d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108661:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80108665:	89 44 24 04          	mov    %eax,0x4(%esp)
80108669:	8b 45 10             	mov    0x10(%ebp),%eax
8010866c:	89 04 24             	mov    %eax,(%esp)
8010866f:	e8 61 99 ff ff       	call   80101fd5 <readi>
80108674:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108677:	74 07                	je     80108680 <loaduvm+0xc9>
      return -1;
80108679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010867e:	eb 18                	jmp    80108698 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108680:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868a:	3b 45 18             	cmp    0x18(%ebp),%eax
8010868d:	0f 82 4e ff ff ff    	jb     801085e1 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108693:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108698:	c9                   	leave  
80108699:	c3                   	ret    

8010869a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010869a:	55                   	push   %ebp
8010869b:	89 e5                	mov    %esp,%ebp
8010869d:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801086a0:	8b 45 10             	mov    0x10(%ebp),%eax
801086a3:	85 c0                	test   %eax,%eax
801086a5:	79 0a                	jns    801086b1 <allocuvm+0x17>
    return 0;
801086a7:	b8 00 00 00 00       	mov    $0x0,%eax
801086ac:	e9 fd 00 00 00       	jmp    801087ae <allocuvm+0x114>
  if(newsz < oldsz)
801086b1:	8b 45 10             	mov    0x10(%ebp),%eax
801086b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086b7:	73 08                	jae    801086c1 <allocuvm+0x27>
    return oldsz;
801086b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801086bc:	e9 ed 00 00 00       	jmp    801087ae <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
801086c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c4:	05 ff 0f 00 00       	add    $0xfff,%eax
801086c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801086d1:	e9 c9 00 00 00       	jmp    8010879f <allocuvm+0x105>
    mem = kalloc();
801086d6:	e8 94 a6 ff ff       	call   80102d6f <kalloc>
801086db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801086de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086e2:	75 2f                	jne    80108713 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
801086e4:	c7 04 24 21 98 10 80 	movl   $0x80109821,(%esp)
801086eb:	e8 ff 7c ff ff       	call   801003ef <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801086f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801086f3:	89 44 24 08          	mov    %eax,0x8(%esp)
801086f7:	8b 45 10             	mov    0x10(%ebp),%eax
801086fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801086fe:	8b 45 08             	mov    0x8(%ebp),%eax
80108701:	89 04 24             	mov    %eax,(%esp)
80108704:	e8 a7 00 00 00       	call   801087b0 <deallocuvm>
      return 0;
80108709:	b8 00 00 00 00       	mov    $0x0,%eax
8010870e:	e9 9b 00 00 00       	jmp    801087ae <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
80108713:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010871a:	00 
8010871b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108722:	00 
80108723:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108726:	89 04 24             	mov    %eax,(%esp)
80108729:	e8 74 ca ff ff       	call   801051a2 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010872e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108731:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873a:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108741:	00 
80108742:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108746:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010874d:	00 
8010874e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108752:	8b 45 08             	mov    0x8(%ebp),%eax
80108755:	89 04 24             	mov    %eax,(%esp)
80108758:	e8 db fa ff ff       	call   80108238 <mappages>
8010875d:	85 c0                	test   %eax,%eax
8010875f:	79 37                	jns    80108798 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80108761:	c7 04 24 39 98 10 80 	movl   $0x80109839,(%esp)
80108768:	e8 82 7c ff ff       	call   801003ef <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010876d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108770:	89 44 24 08          	mov    %eax,0x8(%esp)
80108774:	8b 45 10             	mov    0x10(%ebp),%eax
80108777:	89 44 24 04          	mov    %eax,0x4(%esp)
8010877b:	8b 45 08             	mov    0x8(%ebp),%eax
8010877e:	89 04 24             	mov    %eax,(%esp)
80108781:	e8 2a 00 00 00       	call   801087b0 <deallocuvm>
      kfree(mem);
80108786:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108789:	89 04 24             	mov    %eax,(%esp)
8010878c:	e8 48 a5 ff ff       	call   80102cd9 <kfree>
      return 0;
80108791:	b8 00 00 00 00       	mov    $0x0,%eax
80108796:	eb 16                	jmp    801087ae <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108798:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010879f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a2:	3b 45 10             	cmp    0x10(%ebp),%eax
801087a5:	0f 82 2b ff ff ff    	jb     801086d6 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801087ab:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087ae:	c9                   	leave  
801087af:	c3                   	ret    

801087b0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087b0:	55                   	push   %ebp
801087b1:	89 e5                	mov    %esp,%ebp
801087b3:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801087b6:	8b 45 10             	mov    0x10(%ebp),%eax
801087b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087bc:	72 08                	jb     801087c6 <deallocuvm+0x16>
    return oldsz;
801087be:	8b 45 0c             	mov    0xc(%ebp),%eax
801087c1:	e9 ac 00 00 00       	jmp    80108872 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
801087c6:	8b 45 10             	mov    0x10(%ebp),%eax
801087c9:	05 ff 0f 00 00       	add    $0xfff,%eax
801087ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801087d6:	e9 88 00 00 00       	jmp    80108863 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
801087db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087e5:	00 
801087e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801087ea:	8b 45 08             	mov    0x8(%ebp),%eax
801087ed:	89 04 24             	mov    %eax,(%esp)
801087f0:	e8 a7 f9 ff ff       	call   8010819c <walkpgdir>
801087f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087fc:	75 14                	jne    80108812 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801087fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108801:	c1 e8 16             	shr    $0x16,%eax
80108804:	40                   	inc    %eax
80108805:	c1 e0 16             	shl    $0x16,%eax
80108808:	2d 00 10 00 00       	sub    $0x1000,%eax
8010880d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108810:	eb 4a                	jmp    8010885c <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80108812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108815:	8b 00                	mov    (%eax),%eax
80108817:	83 e0 01             	and    $0x1,%eax
8010881a:	85 c0                	test   %eax,%eax
8010881c:	74 3e                	je     8010885c <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
8010881e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108821:	8b 00                	mov    (%eax),%eax
80108823:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108828:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010882b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010882f:	75 0c                	jne    8010883d <deallocuvm+0x8d>
        panic("kfree");
80108831:	c7 04 24 55 98 10 80 	movl   $0x80109855,(%esp)
80108838:	e8 45 7d ff ff       	call   80100582 <panic>
      char *v = P2V(pa);
8010883d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108840:	05 00 00 00 80       	add    $0x80000000,%eax
80108845:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108848:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010884b:	89 04 24             	mov    %eax,(%esp)
8010884e:	e8 86 a4 ff ff       	call   80102cd9 <kfree>
      *pte = 0;
80108853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108856:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010885c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108866:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108869:	0f 82 6c ff ff ff    	jb     801087db <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010886f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108872:	c9                   	leave  
80108873:	c3                   	ret    

80108874 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108874:	55                   	push   %ebp
80108875:	89 e5                	mov    %esp,%ebp
80108877:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010887a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010887e:	75 0c                	jne    8010888c <freevm+0x18>
    panic("freevm: no pgdir");
80108880:	c7 04 24 5b 98 10 80 	movl   $0x8010985b,(%esp)
80108887:	e8 f6 7c ff ff       	call   80100582 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010888c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108893:	00 
80108894:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010889b:	80 
8010889c:	8b 45 08             	mov    0x8(%ebp),%eax
8010889f:	89 04 24             	mov    %eax,(%esp)
801088a2:	e8 09 ff ff ff       	call   801087b0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801088a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088ae:	eb 44                	jmp    801088f4 <freevm+0x80>
    if(pgdir[i] & PTE_P){
801088b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088ba:	8b 45 08             	mov    0x8(%ebp),%eax
801088bd:	01 d0                	add    %edx,%eax
801088bf:	8b 00                	mov    (%eax),%eax
801088c1:	83 e0 01             	and    $0x1,%eax
801088c4:	85 c0                	test   %eax,%eax
801088c6:	74 29                	je     801088f1 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801088c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088d2:	8b 45 08             	mov    0x8(%ebp),%eax
801088d5:	01 d0                	add    %edx,%eax
801088d7:	8b 00                	mov    (%eax),%eax
801088d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088de:	05 00 00 00 80       	add    $0x80000000,%eax
801088e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801088e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e9:	89 04 24             	mov    %eax,(%esp)
801088ec:	e8 e8 a3 ff ff       	call   80102cd9 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088f1:	ff 45 f4             	incl   -0xc(%ebp)
801088f4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088fb:	76 b3                	jbe    801088b0 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108900:	89 04 24             	mov    %eax,(%esp)
80108903:	e8 d1 a3 ff ff       	call   80102cd9 <kfree>
}
80108908:	c9                   	leave  
80108909:	c3                   	ret    

8010890a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010890a:	55                   	push   %ebp
8010890b:	89 e5                	mov    %esp,%ebp
8010890d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108910:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108917:	00 
80108918:	8b 45 0c             	mov    0xc(%ebp),%eax
8010891b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010891f:	8b 45 08             	mov    0x8(%ebp),%eax
80108922:	89 04 24             	mov    %eax,(%esp)
80108925:	e8 72 f8 ff ff       	call   8010819c <walkpgdir>
8010892a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010892d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108931:	75 0c                	jne    8010893f <clearpteu+0x35>
    panic("clearpteu");
80108933:	c7 04 24 6c 98 10 80 	movl   $0x8010986c,(%esp)
8010893a:	e8 43 7c ff ff       	call   80100582 <panic>
  *pte &= ~PTE_U;
8010893f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108942:	8b 00                	mov    (%eax),%eax
80108944:	83 e0 fb             	and    $0xfffffffb,%eax
80108947:	89 c2                	mov    %eax,%edx
80108949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010894c:	89 10                	mov    %edx,(%eax)
}
8010894e:	c9                   	leave  
8010894f:	c3                   	ret    

80108950 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108950:	55                   	push   %ebp
80108951:	89 e5                	mov    %esp,%ebp
80108953:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108956:	e8 73 f9 ff ff       	call   801082ce <setupkvm>
8010895b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010895e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108962:	75 0a                	jne    8010896e <copyuvm+0x1e>
    return 0;
80108964:	b8 00 00 00 00       	mov    $0x0,%eax
80108969:	e9 f8 00 00 00       	jmp    80108a66 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
8010896e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108975:	e9 cb 00 00 00       	jmp    80108a45 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010897a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010897d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108984:	00 
80108985:	89 44 24 04          	mov    %eax,0x4(%esp)
80108989:	8b 45 08             	mov    0x8(%ebp),%eax
8010898c:	89 04 24             	mov    %eax,(%esp)
8010898f:	e8 08 f8 ff ff       	call   8010819c <walkpgdir>
80108994:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010899b:	75 0c                	jne    801089a9 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
8010899d:	c7 04 24 76 98 10 80 	movl   $0x80109876,(%esp)
801089a4:	e8 d9 7b ff ff       	call   80100582 <panic>
    if(!(*pte & PTE_P))
801089a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089ac:	8b 00                	mov    (%eax),%eax
801089ae:	83 e0 01             	and    $0x1,%eax
801089b1:	85 c0                	test   %eax,%eax
801089b3:	75 0c                	jne    801089c1 <copyuvm+0x71>
      panic("copyuvm: page not present");
801089b5:	c7 04 24 90 98 10 80 	movl   $0x80109890,(%esp)
801089bc:	e8 c1 7b ff ff       	call   80100582 <panic>
    pa = PTE_ADDR(*pte);
801089c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c4:	8b 00                	mov    (%eax),%eax
801089c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801089ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089d1:	8b 00                	mov    (%eax),%eax
801089d3:	25 ff 0f 00 00       	and    $0xfff,%eax
801089d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801089db:	e8 8f a3 ff ff       	call   80102d6f <kalloc>
801089e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801089e7:	75 02                	jne    801089eb <copyuvm+0x9b>
      goto bad;
801089e9:	eb 6b                	jmp    80108a56 <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801089eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089ee:	05 00 00 00 80       	add    $0x80000000,%eax
801089f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801089fa:	00 
801089fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801089ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a02:	89 04 24             	mov    %eax,(%esp)
80108a05:	e8 61 c8 ff ff       	call   8010526b <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a10:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a19:	89 54 24 10          	mov    %edx,0x10(%esp)
80108a1d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108a21:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a28:	00 
80108a29:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a30:	89 04 24             	mov    %eax,(%esp)
80108a33:	e8 00 f8 ff ff       	call   80108238 <mappages>
80108a38:	85 c0                	test   %eax,%eax
80108a3a:	79 02                	jns    80108a3e <copyuvm+0xee>
      goto bad;
80108a3c:	eb 18                	jmp    80108a56 <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108a3e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a4b:	0f 82 29 ff ff ff    	jb     8010897a <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a54:	eb 10                	jmp    80108a66 <copyuvm+0x116>

bad:
  freevm(d);
80108a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a59:	89 04 24             	mov    %eax,(%esp)
80108a5c:	e8 13 fe ff ff       	call   80108874 <freevm>
  return 0;
80108a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a66:	c9                   	leave  
80108a67:	c3                   	ret    

80108a68 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a68:	55                   	push   %ebp
80108a69:	89 e5                	mov    %esp,%ebp
80108a6b:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a75:	00 
80108a76:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a79:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80108a80:	89 04 24             	mov    %eax,(%esp)
80108a83:	e8 14 f7 ff ff       	call   8010819c <walkpgdir>
80108a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a8e:	8b 00                	mov    (%eax),%eax
80108a90:	83 e0 01             	and    $0x1,%eax
80108a93:	85 c0                	test   %eax,%eax
80108a95:	75 07                	jne    80108a9e <uva2ka+0x36>
    return 0;
80108a97:	b8 00 00 00 00       	mov    $0x0,%eax
80108a9c:	eb 22                	jmp    80108ac0 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa1:	8b 00                	mov    (%eax),%eax
80108aa3:	83 e0 04             	and    $0x4,%eax
80108aa6:	85 c0                	test   %eax,%eax
80108aa8:	75 07                	jne    80108ab1 <uva2ka+0x49>
    return 0;
80108aaa:	b8 00 00 00 00       	mov    $0x0,%eax
80108aaf:	eb 0f                	jmp    80108ac0 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab4:	8b 00                	mov    (%eax),%eax
80108ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108abb:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108ac0:	c9                   	leave  
80108ac1:	c3                   	ret    

80108ac2 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108ac2:	55                   	push   %ebp
80108ac3:	89 e5                	mov    %esp,%ebp
80108ac5:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108ac8:	8b 45 10             	mov    0x10(%ebp),%eax
80108acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108ace:	e9 87 00 00 00       	jmp    80108b5a <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ad6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae8:	89 04 24             	mov    %eax,(%esp)
80108aeb:	e8 78 ff ff ff       	call   80108a68 <uva2ka>
80108af0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108af3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108af7:	75 07                	jne    80108b00 <copyout+0x3e>
      return -1;
80108af9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108afe:	eb 69                	jmp    80108b69 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108b00:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108b06:	29 c2                	sub    %eax,%edx
80108b08:	89 d0                	mov    %edx,%eax
80108b0a:	05 00 10 00 00       	add    $0x1000,%eax
80108b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b15:	3b 45 14             	cmp    0x14(%ebp),%eax
80108b18:	76 06                	jbe    80108b20 <copyout+0x5e>
      n = len;
80108b1a:	8b 45 14             	mov    0x14(%ebp),%eax
80108b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b26:	29 c2                	sub    %eax,%edx
80108b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b2b:	01 c2                	add    %eax,%edx
80108b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b30:	89 44 24 08          	mov    %eax,0x8(%esp)
80108b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b37:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b3b:	89 14 24             	mov    %edx,(%esp)
80108b3e:	e8 28 c7 ff ff       	call   8010526b <memmove>
    len -= n;
80108b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b46:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b4c:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b52:	05 00 10 00 00       	add    $0x1000,%eax
80108b57:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b5a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108b5e:	0f 85 6f ff ff ff    	jne    80108ad3 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b69:	c9                   	leave  
80108b6a:	c3                   	ret    
	...

80108b6c <strcmp>:

#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
80108b6c:	55                   	push   %ebp
80108b6d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
80108b6f:	eb 06                	jmp    80108b77 <strcmp+0xb>
    p++, q++;
80108b71:	ff 45 08             	incl   0x8(%ebp)
80108b74:	ff 45 0c             	incl   0xc(%ebp)
#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80108b77:	8b 45 08             	mov    0x8(%ebp),%eax
80108b7a:	8a 00                	mov    (%eax),%al
80108b7c:	84 c0                	test   %al,%al
80108b7e:	74 0e                	je     80108b8e <strcmp+0x22>
80108b80:	8b 45 08             	mov    0x8(%ebp),%eax
80108b83:	8a 10                	mov    (%eax),%dl
80108b85:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b88:	8a 00                	mov    (%eax),%al
80108b8a:	38 c2                	cmp    %al,%dl
80108b8c:	74 e3                	je     80108b71 <strcmp+0x5>
    p++, q++;
  return (char)*p - (char)*q;
80108b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80108b91:	8a 00                	mov    (%eax),%al
80108b93:	0f be d0             	movsbl %al,%edx
80108b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b99:	8a 00                	mov    (%eax),%al
80108b9b:	0f be c0             	movsbl %al,%eax
80108b9e:	29 c2                	sub    %eax,%edx
80108ba0:	89 d0                	mov    %edx,%eax
}
80108ba2:	5d                   	pop    %ebp
80108ba3:	c3                   	ret    

80108ba4 <getname>:

int getname(int index, char* name){
80108ba4:	55                   	push   %ebp
80108ba5:	89 e5                	mov    %esp,%ebp
80108ba7:	53                   	push   %ebx
80108ba8:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108bab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((*name++ = cabinet.tuperwares[index].name[i++]) != 0);
80108bb2:	90                   	nop
80108bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80108bb6:	8d 42 01             	lea    0x1(%edx),%eax
80108bb9:	89 45 0c             	mov    %eax,0xc(%ebp)
80108bbc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80108bbf:	8d 41 01             	lea    0x1(%ecx),%eax
80108bc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108bc8:	89 d8                	mov    %ebx,%eax
80108bca:	01 c0                	add    %eax,%eax
80108bcc:	01 d8                	add    %ebx,%eax
80108bce:	c1 e0 05             	shl    $0x5,%eax
80108bd1:	01 c8                	add    %ecx,%eax
80108bd3:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108bd8:	8a 00                	mov    (%eax),%al
80108bda:	88 02                	mov    %al,(%edx)
80108bdc:	8a 02                	mov    (%edx),%al
80108bde:	84 c0                	test   %al,%al
80108be0:	75 d1                	jne    80108bb3 <getname+0xf>

    return 0;
80108be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108be7:	83 c4 10             	add    $0x10,%esp
80108bea:	5b                   	pop    %ebx
80108beb:	5d                   	pop    %ebp
80108bec:	c3                   	ret    

80108bed <setname>:

int setname(int index, char* name){
80108bed:	55                   	push   %ebp
80108bee:	89 e5                	mov    %esp,%ebp
80108bf0:	53                   	push   %ebx
80108bf1:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108bf4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].name[i++] = *name++) != 0);
80108bfb:	90                   	nop
80108bfc:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108bff:	8d 42 01             	lea    0x1(%edx),%eax
80108c02:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108c05:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c08:	8d 48 01             	lea    0x1(%eax),%ecx
80108c0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108c0e:	8a 08                	mov    (%eax),%cl
80108c10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108c13:	89 d8                	mov    %ebx,%eax
80108c15:	01 c0                	add    %eax,%eax
80108c17:	01 d8                	add    %ebx,%eax
80108c19:	c1 e0 05             	shl    $0x5,%eax
80108c1c:	01 d0                	add    %edx,%eax
80108c1e:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108c23:	88 08                	mov    %cl,(%eax)
80108c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108c28:	89 c8                	mov    %ecx,%eax
80108c2a:	01 c0                	add    %eax,%eax
80108c2c:	01 c8                	add    %ecx,%eax
80108c2e:	c1 e0 05             	shl    $0x5,%eax
80108c31:	01 d0                	add    %edx,%eax
80108c33:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108c38:	8a 00                	mov    (%eax),%al
80108c3a:	84 c0                	test   %al,%al
80108c3c:	75 be                	jne    80108bfc <setname+0xf>

    return 0;
80108c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c43:	83 c4 10             	add    $0x10,%esp
80108c46:	5b                   	pop    %ebx
80108c47:	5d                   	pop    %ebp
80108c48:	c3                   	ret    

80108c49 <getmaxproc>:

int getmaxproc(int index){
80108c49:	55                   	push   %ebp
80108c4a:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_proc;
80108c4c:	8b 55 08             	mov    0x8(%ebp),%edx
80108c4f:	89 d0                	mov    %edx,%eax
80108c51:	01 c0                	add    %eax,%eax
80108c53:	01 d0                	add    %edx,%eax
80108c55:	c1 e0 05             	shl    $0x5,%eax
80108c58:	05 e0 20 11 80       	add    $0x801120e0,%eax
80108c5d:	8b 40 08             	mov    0x8(%eax),%eax
}
80108c60:	5d                   	pop    %ebp
80108c61:	c3                   	ret    

80108c62 <setmaxproc>:

int setmaxproc(int index, int max_proc){
80108c62:	55                   	push   %ebp
80108c63:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_proc = max_proc;
80108c65:	8b 55 08             	mov    0x8(%ebp),%edx
80108c68:	89 d0                	mov    %edx,%eax
80108c6a:	01 c0                	add    %eax,%eax
80108c6c:	01 d0                	add    %edx,%eax
80108c6e:	c1 e0 05             	shl    $0x5,%eax
80108c71:	8d 90 e0 20 11 80    	lea    -0x7feedf20(%eax),%edx
80108c77:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c7a:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c82:	5d                   	pop    %ebp
80108c83:	c3                   	ret    

80108c84 <getmaxmem>:

int getmaxmem(int index){
80108c84:	55                   	push   %ebp
80108c85:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_mem;
80108c87:	8b 55 08             	mov    0x8(%ebp),%edx
80108c8a:	89 d0                	mov    %edx,%eax
80108c8c:	01 c0                	add    %eax,%eax
80108c8e:	01 d0                	add    %edx,%eax
80108c90:	c1 e0 05             	shl    $0x5,%eax
80108c93:	05 e0 20 11 80       	add    $0x801120e0,%eax
80108c98:	8b 40 0c             	mov    0xc(%eax),%eax
}
80108c9b:	5d                   	pop    %ebp
80108c9c:	c3                   	ret    

80108c9d <setmaxmem>:

int setmaxmem(int index, int max_mem){
80108c9d:	55                   	push   %ebp
80108c9e:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_mem = max_mem;
80108ca0:	8b 55 08             	mov    0x8(%ebp),%edx
80108ca3:	89 d0                	mov    %edx,%eax
80108ca5:	01 c0                	add    %eax,%eax
80108ca7:	01 d0                	add    %edx,%eax
80108ca9:	c1 e0 05             	shl    $0x5,%eax
80108cac:	8d 90 e0 20 11 80    	lea    -0x7feedf20(%eax),%edx
80108cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cb5:	89 42 0c             	mov    %eax,0xc(%edx)
    return 0;
80108cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cbd:	5d                   	pop    %ebp
80108cbe:	c3                   	ret    

80108cbf <getmaxdisk>:

int getmaxdisk(int index){
80108cbf:	55                   	push   %ebp
80108cc0:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_disk;
80108cc2:	8b 55 08             	mov    0x8(%ebp),%edx
80108cc5:	89 d0                	mov    %edx,%eax
80108cc7:	01 c0                	add    %eax,%eax
80108cc9:	01 d0                	add    %edx,%eax
80108ccb:	c1 e0 05             	shl    $0x5,%eax
80108cce:	05 f0 20 11 80       	add    $0x801120f0,%eax
80108cd3:	8b 00                	mov    (%eax),%eax
}
80108cd5:	5d                   	pop    %ebp
80108cd6:	c3                   	ret    

80108cd7 <setmaxdisk>:

int setmaxdisk(int index, int max_disk){
80108cd7:	55                   	push   %ebp
80108cd8:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_disk = max_disk;
80108cda:	8b 55 08             	mov    0x8(%ebp),%edx
80108cdd:	89 d0                	mov    %edx,%eax
80108cdf:	01 c0                	add    %eax,%eax
80108ce1:	01 d0                	add    %edx,%eax
80108ce3:	c1 e0 05             	shl    $0x5,%eax
80108ce6:	8d 90 f0 20 11 80    	lea    -0x7feedf10(%eax),%edx
80108cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cef:	89 02                	mov    %eax,(%edx)
    return 0;
80108cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cf6:	5d                   	pop    %ebp
80108cf7:	c3                   	ret    

80108cf8 <getusedmem>:

int getusedmem(int index){
80108cf8:	55                   	push   %ebp
80108cf9:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_mem;
80108cfb:	8b 55 08             	mov    0x8(%ebp),%edx
80108cfe:	89 d0                	mov    %edx,%eax
80108d00:	01 c0                	add    %eax,%eax
80108d02:	01 d0                	add    %edx,%eax
80108d04:	c1 e0 05             	shl    $0x5,%eax
80108d07:	05 f0 20 11 80       	add    $0x801120f0,%eax
80108d0c:	8b 40 04             	mov    0x4(%eax),%eax
}
80108d0f:	5d                   	pop    %ebp
80108d10:	c3                   	ret    

80108d11 <setusedmem>:

int setusedmem(int index, int used_mem){
80108d11:	55                   	push   %ebp
80108d12:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_mem = used_mem;
80108d14:	8b 55 08             	mov    0x8(%ebp),%edx
80108d17:	89 d0                	mov    %edx,%eax
80108d19:	01 c0                	add    %eax,%eax
80108d1b:	01 d0                	add    %edx,%eax
80108d1d:	c1 e0 05             	shl    $0x5,%eax
80108d20:	8d 90 f0 20 11 80    	lea    -0x7feedf10(%eax),%edx
80108d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d29:	89 42 04             	mov    %eax,0x4(%edx)
    return 0;
80108d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d31:	5d                   	pop    %ebp
80108d32:	c3                   	ret    

80108d33 <getuseddisk>:

int getuseddisk(int index){
80108d33:	55                   	push   %ebp
80108d34:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_disk;
80108d36:	8b 55 08             	mov    0x8(%ebp),%edx
80108d39:	89 d0                	mov    %edx,%eax
80108d3b:	01 c0                	add    %eax,%eax
80108d3d:	01 d0                	add    %edx,%eax
80108d3f:	c1 e0 05             	shl    $0x5,%eax
80108d42:	05 f0 20 11 80       	add    $0x801120f0,%eax
80108d47:	8b 40 08             	mov    0x8(%eax),%eax
}
80108d4a:	5d                   	pop    %ebp
80108d4b:	c3                   	ret    

80108d4c <setuseddisk>:

int setuseddisk(int index, int used_disk){
80108d4c:	55                   	push   %ebp
80108d4d:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_disk = used_disk;
80108d4f:	8b 55 08             	mov    0x8(%ebp),%edx
80108d52:	89 d0                	mov    %edx,%eax
80108d54:	01 c0                	add    %eax,%eax
80108d56:	01 d0                	add    %edx,%eax
80108d58:	c1 e0 05             	shl    $0x5,%eax
80108d5b:	8d 90 f0 20 11 80    	lea    -0x7feedf10(%eax),%edx
80108d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d64:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d6c:	5d                   	pop    %ebp
80108d6d:	c3                   	ret    

80108d6e <setvc>:

int setvc(int index, char* vc){
80108d6e:	55                   	push   %ebp
80108d6f:	89 e5                	mov    %esp,%ebp
80108d71:	53                   	push   %ebx
80108d72:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108d75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].vc[i++] = *vc++) != 0);
80108d7c:	90                   	nop
80108d7d:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108d80:	8d 42 01             	lea    0x1(%edx),%eax
80108d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108d86:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d89:	8d 48 01             	lea    0x1(%eax),%ecx
80108d8c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108d8f:	8a 08                	mov    (%eax),%cl
80108d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108d94:	89 d8                	mov    %ebx,%eax
80108d96:	01 c0                	add    %eax,%eax
80108d98:	01 d8                	add    %ebx,%eax
80108d9a:	c1 e0 05             	shl    $0x5,%eax
80108d9d:	01 d0                	add    %edx,%eax
80108d9f:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108da4:	88 08                	mov    %cl,(%eax)
80108da6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108da9:	89 c8                	mov    %ecx,%eax
80108dab:	01 c0                	add    %eax,%eax
80108dad:	01 c8                	add    %ecx,%eax
80108daf:	c1 e0 05             	shl    $0x5,%eax
80108db2:	01 d0                	add    %edx,%eax
80108db4:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108db9:	8a 00                	mov    (%eax),%al
80108dbb:	84 c0                	test   %al,%al
80108dbd:	75 be                	jne    80108d7d <setvc+0xf>

    return 0;
80108dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108dc4:	83 c4 10             	add    $0x10,%esp
80108dc7:	5b                   	pop    %ebx
80108dc8:	5d                   	pop    %ebp
80108dc9:	c3                   	ret    

80108dca <getvcfs>:

int getvcfs(char *vc, char *fs){
80108dca:	55                   	push   %ebp
80108dcb:	89 e5                	mov    %esp,%ebp
80108dcd:	53                   	push   %ebx
80108dce:	83 ec 18             	sub    $0x18,%esp
    int i, j = 0;
80108dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(i = 0; i < NUM_VCS; i++){
80108dd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80108ddf:	eb 5b                	jmp    80108e3c <getvcfs+0x72>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
80108de1:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108de4:	89 d0                	mov    %edx,%eax
80108de6:	01 c0                	add    %eax,%eax
80108de8:	01 d0                	add    %edx,%eax
80108dea:	c1 e0 05             	shl    $0x5,%eax
80108ded:	83 c0 20             	add    $0x20,%eax
80108df0:	8d 90 a0 20 11 80    	lea    -0x7feedf60(%eax),%edx
80108df6:	8b 45 08             	mov    0x8(%ebp),%eax
80108df9:	89 44 24 04          	mov    %eax,0x4(%esp)
80108dfd:	89 14 24             	mov    %edx,(%esp)
80108e00:	e8 67 fd ff ff       	call   80108b6c <strcmp>
80108e05:	85 c0                	test   %eax,%eax
80108e07:	75 30                	jne    80108e39 <getvcfs+0x6f>
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
80108e09:	90                   	nop
80108e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e0d:	8d 42 01             	lea    0x1(%edx),%eax
80108e10:	89 45 0c             	mov    %eax,0xc(%ebp)
80108e13:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108e16:	8d 41 01             	lea    0x1(%ecx),%eax
80108e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108e1c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80108e1f:	89 d8                	mov    %ebx,%eax
80108e21:	01 c0                	add    %eax,%eax
80108e23:	01 d8                	add    %ebx,%eax
80108e25:	c1 e0 05             	shl    $0x5,%eax
80108e28:	01 c8                	add    %ecx,%eax
80108e2a:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108e2f:	8a 00                	mov    (%eax),%al
80108e31:	88 02                	mov    %al,(%edx)
80108e33:	8a 02                	mov    (%edx),%al
80108e35:	84 c0                	test   %al,%al
80108e37:	75 d1                	jne    80108e0a <getvcfs+0x40>
    return 0;
}

int getvcfs(char *vc, char *fs){
    int i, j = 0;
    for(i = 0; i < NUM_VCS; i++){
80108e39:	ff 45 f8             	incl   -0x8(%ebp)
80108e3c:	83 7d f8 03          	cmpl   $0x3,-0x8(%ebp)
80108e40:	7e 9f                	jle    80108de1 <getvcfs+0x17>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
        }
    }return 0;
80108e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e47:	83 c4 18             	add    $0x18,%esp
80108e4a:	5b                   	pop    %ebx
80108e4b:	5d                   	pop    %ebp
80108e4c:	c3                   	ret    

80108e4d <setactivefs>:

int setactivefs(char *fs){
80108e4d:	55                   	push   %ebp
80108e4e:	89 e5                	mov    %esp,%ebp
80108e50:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((cabinet.active_fs[i++] = *fs++) != 0);
80108e5a:	90                   	nop
80108e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108e5e:	8d 50 01             	lea    0x1(%eax),%edx
80108e61:	89 55 fc             	mov    %edx,-0x4(%ebp)
80108e64:	8b 55 08             	mov    0x8(%ebp),%edx
80108e67:	8d 4a 01             	lea    0x1(%edx),%ecx
80108e6a:	89 4d 08             	mov    %ecx,0x8(%ebp)
80108e6d:	8a 12                	mov    (%edx),%dl
80108e6f:	88 90 20 22 11 80    	mov    %dl,-0x7feedde0(%eax)
80108e75:	8a 80 20 22 11 80    	mov    -0x7feedde0(%eax),%al
80108e7b:	84 c0                	test   %al,%al
80108e7d:	75 dc                	jne    80108e5b <setactivefs+0xe>

    return 0;
80108e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e84:	c9                   	leave  
80108e85:	c3                   	ret    

80108e86 <getactivefs>:

int getactivefs(char *fs){
80108e86:	55                   	push   %ebp
80108e87:	89 e5                	mov    %esp,%ebp
80108e89:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108e8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((*fs++ = cabinet.active_fs[i++]) != 0);
80108e93:	90                   	nop
80108e94:	8b 45 08             	mov    0x8(%ebp),%eax
80108e97:	8d 50 01             	lea    0x1(%eax),%edx
80108e9a:	89 55 08             	mov    %edx,0x8(%ebp)
80108e9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108ea0:	8d 4a 01             	lea    0x1(%edx),%ecx
80108ea3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80108ea6:	8a 92 20 22 11 80    	mov    -0x7feedde0(%edx),%dl
80108eac:	88 10                	mov    %dl,(%eax)
80108eae:	8a 00                	mov    (%eax),%al
80108eb0:	84 c0                	test   %al,%al
80108eb2:	75 e0                	jne    80108e94 <getactivefs+0xe>

    return 0;
80108eb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108eb9:	c9                   	leave  
80108eba:	c3                   	ret    

80108ebb <getactivefsindex>:

int getactivefsindex(void){
80108ebb:	55                   	push   %ebp
80108ebc:	89 e5                	mov    %esp,%ebp
80108ebe:	83 ec 18             	sub    $0x18,%esp
    int i, index = -1;
80108ec1:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%ebp)
    for(i = 0; i < NUM_VCS; i++){
80108ec8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108ecf:	eb 30                	jmp    80108f01 <getactivefsindex+0x46>
        if(strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
80108ed1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108ed4:	89 d0                	mov    %edx,%eax
80108ed6:	01 c0                	add    %eax,%eax
80108ed8:	01 d0                	add    %edx,%eax
80108eda:	c1 e0 05             	shl    $0x5,%eax
80108edd:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108ee2:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ee6:	c7 04 24 21 22 11 80 	movl   $0x80112221,(%esp)
80108eed:	e8 7a fc ff ff       	call   80108b6c <strcmp>
80108ef2:	85 c0                	test   %eax,%eax
80108ef4:	75 08                	jne    80108efe <getactivefsindex+0x43>
            index = i;
80108ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108ef9:	89 45 f8             	mov    %eax,-0x8(%ebp)
            break;
80108efc:	eb 09                	jmp    80108f07 <getactivefsindex+0x4c>
    return 0;
}

int getactivefsindex(void){
    int i, index = -1;
    for(i = 0; i < NUM_VCS; i++){
80108efe:	ff 45 fc             	incl   -0x4(%ebp)
80108f01:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
80108f05:	7e ca                	jle    80108ed1 <getactivefsindex+0x16>
        if(strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
            index = i;
            break;
        }
    }return index;
80108f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80108f0a:	c9                   	leave  
80108f0b:	c3                   	ret    

80108f0c <setatroot>:

int setatroot(int index, int val){
80108f0c:	55                   	push   %ebp
80108f0d:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].atroot = val;
80108f0f:	8b 55 08             	mov    0x8(%ebp),%edx
80108f12:	89 d0                	mov    %edx,%eax
80108f14:	01 c0                	add    %eax,%eax
80108f16:	01 d0                	add    %edx,%eax
80108f18:	c1 e0 05             	shl    $0x5,%eax
80108f1b:	8d 90 f0 20 11 80    	lea    -0x7feedf10(%eax),%edx
80108f21:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f24:	89 42 0c             	mov    %eax,0xc(%edx)

    return 0;
80108f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f2c:	5d                   	pop    %ebp
80108f2d:	c3                   	ret    

80108f2e <getatroot>:

int getatroot(int index){
80108f2e:	55                   	push   %ebp
80108f2f:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].atroot;
80108f31:	8b 55 08             	mov    0x8(%ebp),%edx
80108f34:	89 d0                	mov    %edx,%eax
80108f36:	01 c0                	add    %eax,%eax
80108f38:	01 d0                	add    %edx,%eax
80108f3a:	c1 e0 05             	shl    $0x5,%eax
80108f3d:	05 f0 20 11 80       	add    $0x801120f0,%eax
80108f42:	8b 40 0c             	mov    0xc(%eax),%eax
}
80108f45:	5d                   	pop    %ebp
80108f46:	c3                   	ret    

80108f47 <tostring>:


int tostring(char *string){
80108f47:	55                   	push   %ebp
80108f48:	89 e5                	mov    %esp,%ebp
80108f4a:	83 ec 48             	sub    $0x48,%esp
    int i;
    strncpy(string, "Active FS: ", 11);
80108f4d:	c7 44 24 08 0b 00 00 	movl   $0xb,0x8(%esp)
80108f54:	00 
80108f55:	c7 44 24 04 aa 98 10 	movl   $0x801098aa,0x4(%esp)
80108f5c:	80 
80108f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80108f60:	89 04 24             	mov    %eax,(%esp)
80108f63:	e8 f0 c3 ff ff       	call   80105358 <strncpy>
    strcat(string, cabinet.active_fs);
80108f68:	c7 44 24 04 20 22 11 	movl   $0x80112220,0x4(%esp)
80108f6f:	80 
80108f70:	8b 45 08             	mov    0x8(%ebp),%eax
80108f73:	89 04 24             	mov    %eax,(%esp)
80108f76:	e8 9f c4 ff ff       	call   8010541a <strcat>
    strcat(string, "\n\n");
80108f7b:	c7 44 24 04 b6 98 10 	movl   $0x801098b6,0x4(%esp)
80108f82:	80 
80108f83:	8b 45 08             	mov    0x8(%ebp),%eax
80108f86:	89 04 24             	mov    %eax,(%esp)
80108f89:	e8 8c c4 ff ff       	call   8010541a <strcat>
    for(i = 0; i < NUM_VCS; i++){
80108f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f95:	e9 e4 00 00 00       	jmp    8010907e <tostring+0x137>
        if(cabinet.tuperwares[i].name != 0){
            strcat(string, "Name: ");
80108f9a:	c7 44 24 04 b9 98 10 	movl   $0x801098b9,0x4(%esp)
80108fa1:	80 
80108fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80108fa5:	89 04 24             	mov    %eax,(%esp)
80108fa8:	e8 6d c4 ff ff       	call   8010541a <strcat>
            strcat(string, cabinet.tuperwares[i].name);
80108fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108fb0:	89 d0                	mov    %edx,%eax
80108fb2:	01 c0                	add    %eax,%eax
80108fb4:	01 d0                	add    %edx,%eax
80108fb6:	c1 e0 05             	shl    $0x5,%eax
80108fb9:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80108fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80108fc5:	89 04 24             	mov    %eax,(%esp)
80108fc8:	e8 4d c4 ff ff       	call   8010541a <strcat>
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
80108fcd:	c7 44 24 04 c0 98 10 	movl   $0x801098c0,0x4(%esp)
80108fd4:	80 
80108fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80108fd8:	89 04 24             	mov    %eax,(%esp)
80108fdb:	e8 3a c4 ff ff       	call   8010541a <strcat>
        if(cabinet.tuperwares[i].vc != 0){
            strcat(string, "VC: ");
80108fe0:	c7 44 24 04 c2 98 10 	movl   $0x801098c2,0x4(%esp)
80108fe7:	80 
80108fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80108feb:	89 04 24             	mov    %eax,(%esp)
80108fee:	e8 27 c4 ff ff       	call   8010541a <strcat>
            strcat(string, cabinet.tuperwares[i].vc);
80108ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108ff6:	89 d0                	mov    %edx,%eax
80108ff8:	01 c0                	add    %eax,%eax
80108ffa:	01 d0                	add    %edx,%eax
80108ffc:	c1 e0 05             	shl    $0x5,%eax
80108fff:	83 c0 20             	add    $0x20,%eax
80109002:	05 a0 20 11 80       	add    $0x801120a0,%eax
80109007:	89 44 24 04          	mov    %eax,0x4(%esp)
8010900b:	8b 45 08             	mov    0x8(%ebp),%eax
8010900e:	89 04 24             	mov    %eax,(%esp)
80109011:	e8 04 c4 ff ff       	call   8010541a <strcat>
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
80109016:	c7 44 24 04 c0 98 10 	movl   $0x801098c0,0x4(%esp)
8010901d:	80 
8010901e:	8b 45 08             	mov    0x8(%ebp),%eax
80109021:	89 04 24             	mov    %eax,(%esp)
80109024:	e8 f1 c3 ff ff       	call   8010541a <strcat>
        strcat(string, "Index: ");
80109029:	c7 44 24 04 c7 98 10 	movl   $0x801098c7,0x4(%esp)
80109030:	80 
80109031:	8b 45 08             	mov    0x8(%ebp),%eax
80109034:	89 04 24             	mov    %eax,(%esp)
80109037:	e8 de c3 ff ff       	call   8010541a <strcat>
        char num_string[32];
        itoa(i, num_string, 10);
8010903c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
80109043:	00 
80109044:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109047:	89 44 24 04          	mov    %eax,0x4(%esp)
8010904b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010904e:	89 04 24             	mov    %eax,(%esp)
80109051:	e8 30 c4 ff ff       	call   80105486 <itoa>
        strcat(string, num_string);
80109056:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109059:	89 44 24 04          	mov    %eax,0x4(%esp)
8010905d:	8b 45 08             	mov    0x8(%ebp),%eax
80109060:	89 04 24             	mov    %eax,(%esp)
80109063:	e8 b2 c3 ff ff       	call   8010541a <strcat>
        strcat(string, "\n\n");
80109068:	c7 44 24 04 b6 98 10 	movl   $0x801098b6,0x4(%esp)
8010906f:	80 
80109070:	8b 45 08             	mov    0x8(%ebp),%eax
80109073:	89 04 24             	mov    %eax,(%esp)
80109076:	e8 9f c3 ff ff       	call   8010541a <strcat>
int tostring(char *string){
    int i;
    strncpy(string, "Active FS: ", 11);
    strcat(string, cabinet.active_fs);
    strcat(string, "\n\n");
    for(i = 0; i < NUM_VCS; i++){
8010907b:	ff 45 f4             	incl   -0xc(%ebp)
8010907e:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80109082:	0f 8e 12 ff ff ff    	jle    80108f9a <tostring+0x53>
        char num_string[32];
        itoa(i, num_string, 10);
        strcat(string, num_string);
        strcat(string, "\n\n");
    }
    strcat(string, "\0");
80109088:	c7 44 24 04 cf 98 10 	movl   $0x801098cf,0x4(%esp)
8010908f:	80 
80109090:	8b 45 08             	mov    0x8(%ebp),%eax
80109093:	89 04 24             	mov    %eax,(%esp)
80109096:	e8 7f c3 ff ff       	call   8010541a <strcat>
    return 0;
8010909b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801090a0:	c9                   	leave  
801090a1:	c3                   	ret    
