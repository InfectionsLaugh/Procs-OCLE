extern void myputchar(char x);
extern void miputs(char *x);

char *str = "Hola mundo\0";

void main(void) {
  miputs(str);
}