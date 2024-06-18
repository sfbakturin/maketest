#include <stdio.h>
#include <unistd.h>

int main(void)
{
	int id = fork();
	if (id != 0)
	{
		fork();
	}
	puts("Hello!");
	return 0;
}
