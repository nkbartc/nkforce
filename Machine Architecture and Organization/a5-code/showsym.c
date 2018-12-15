// Template for parsing an ELF file to print its symbol table
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <elf.h>

int DEBUG = 0;                  // controls whether to print debug messages

int main(int argc, char *argv[]){
  if(argc < 2){
    printf("usage: %s [-d] <file>\n",argv[0]);
    return 0;
  }

  char *objfile_name = argv[1];

  // check for debug mode
  if(argc >=3){
    if(strcmp("-d",argv[1])==0){
      DEBUG = 1;                // set debug flag if -d is passed on command line
      objfile_name = argv[2];
    }
    else{
      printf("incorrect usage\n");
      return 1;
    }
  }

  // Open file descriptor and set up memory map for objfile_name

  int fd = open(objfile_name, O_RDONLY);
  struct stat stat_buf;
  fstat(fd, &stat_buf);
  int size = stat_buf.st_size;
  char *file_bytes =
    mmap(NULL, size, PROT_READ, MAP_SHARED,
         fd, 0);

  // CREATE A POINTER to the intial bytes of the file which are an ELF64_Ehdr struct
  Elf64_Ehdr *ehdr = (Elf64_Ehdr *) file_bytes;


  // CHECK e_ident field's bytes 0 to for for the sequence {0x75,'E','L','F'}.
  // Exit the program with code 1 if the bytes do not match

  int ident_matches = // check the first bytes to ensure correct file format
    ehdr->e_ident[0] == 0x7f &&
    ehdr->e_ident[1] == 'E'  &&
    ehdr->e_ident[2] == 'L'  &&
    ehdr->e_ident[3] == 'F';

  if(!ident_matches){
    printf("Magic bytes wrong, this is not an ELF file\n");
    exit(1);
  }

  // PROVIDED: check for a 64-bit file
  if(ehdr->e_ident[EI_CLASS] != ELFCLASS64){
    printf("Not a 64-bit file ELF file\n");
    return 1;
  }

  // PROVIDED: check for x86-64 architecture
  if(ehdr->e_machine != EM_X86_64){
    printf("Not an x86-64 file\n");
    return 1;
  }

  // DETERMINE THE OFFSET of the Section ehdr Array (e_shoff), the
  // number of sections (e_shnum), and the index of the Section ehdr
  // String table (e_shstrndx). These fields are from the ELF File
  // ehdr.

  // Set up a pointer to the array of section ehdrs. Use the section
  // ehdr string table index to find its byte position in the file
  // and set up a pointer to it.

  // Search the Section ehdr Array for the secion with name .symtab
  // (symbol table) and .strtab (string table).  Note their positions
  // in the file (sh_offset field).  Also note the size in bytes
  // (sh_size) and and the size of each entry (sh_entsize) for .symtab
  // so its number of entries can be computed.
  int offset = ehdr->e_shoff;
  int num_sect = ehdr->e_shnum;
  int index_sect = ehdr->e_shstrndx;

  // Section ehdr Array(pink)
  Elf64_Shdr *sha = (Elf64_Shdr *) (file_bytes + offset);
  // need its offset to reach Section ehdr String Table(purple)
  Elf64_Shdr *shdr2= (Elf64_Shdr *) &(sha[index_sect]);
  // Section ehdr String Table(purple)
  char *shst = file_bytes + shdr2->sh_offset;

  int symbol_offset = 0;
  int symbol_size   = 0;
  int symbol_entsize= 0;
  int symbol_num_ent= 0;

  int string_offset = 0;

  for(int i=0; i<num_sect; i++){
    char *targ = sha[i].sh_name + shst;
    if (strcmp(targ, ".symtab") == 0){
      symbol_offset = sha[i].sh_offset;
      symbol_size   = sha[i].sh_size;
      symbol_entsize= sha[i].sh_entsize;
      symbol_num_ent= symbol_size / symbol_entsize;
    }
    else if (strcmp(targ, ".strtab") == 0){
      string_offset = sha[i].sh_offset;
    }
  }

  if(symbol_offset == 0){
    printf("Couldn't find symbol table\n");
    return 1;
  }

  if(string_offset == 0){
    printf("Couldn't find string table\n");
    return 1;
  }

  // PRINT byte information about where the symbol table was found and
  // its sizes. The number of entries in the symbol table can be
  // determined by dividing its total size in bytes by the size of
  // each entry.
  printf("Symbol Table\n");
  printf("- %lu bytes offset from start of file\n",(size_t)symbol_offset);
  printf("- %lu bytes total size\n",(size_t)symbol_size);
  printf("- %lu bytes per entry\n",(size_t)symbol_entsize);
  printf("- %lu entries\n",(size_t)symbol_num_ent);


  // Set up pointers to the Symbol Table and associated String Table
  // using offsets found earlier.

  Elf64_Sym *sym = (Elf64_Sym *) (symbol_offset + file_bytes);
  char *str = string_offset + file_bytes;

  // Print column IDs for info on each symbol
  printf("[%3s]  %8s %4s %s\n",
         "idx","TYPE","SIZE","NAME");

  // Iterate over the symbol table entries
  for(int i=0; i<symbol_num_ent; i++){
    // Determine size of symbol and name. Use <NONE> name has zero
    // length.
    int size1 = sym[i].st_size;
    int name_num = sym[i].st_name;
    char *name;
    char *type;
    if (name_num == 0){
      name = "<NONE>";
    }
    else{
      name = str + name_num;
    }
    // Determine type of symbol. See assignment specification for
    // fields, macros, and definitions related to this.
    unsigned char typec = ELF64_ST_TYPE(sym[i].st_info);
    if (typec == STT_NOTYPE) {
      type = "NOTYPE";
    }
    else if (typec == STT_OBJECT) {
      type = "OBJECT";
    }
    else if (typec == STT_FUNC) {
      type = "FUNC";
    }
    else if (typec == STT_SECTION) {
      type = "SECTION";
    }
    else if (typec == STT_FILE) {
      type = "FILE";
    }

    // Print symbol information
    printf("[%3d]: %8s %4lu %s\n",i, type, (size_t)size1, name);
  }


  // Unmap file from memory and close associated file descriptor
  munmap(file_bytes, size);
  close(fd);
  return 0;
}
