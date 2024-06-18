#include <stdio.h>
#include <stdlib.h>

int readfile(const char *filename, float **xs, size_t *size);
void prefix(const float *xs, float *ns, size_t size);
int writefile(const char *filename, const float *xs, size_t size);

int main(int argc, char **argv)
{
	int status = EXIT_SUCCESS;

	float *xs = NULL;
	float *ns = NULL;
	size_t size = 0;

	if (argc != 3)
	{
		puts("Usage: prefix.exe input.txt output.txt");
		return status;
	}

	if (readfile(argv[1], &xs, &size))
	{
		status = EXIT_FAILURE;
		goto cleanup;
	}

	ns = calloc(size, sizeof(float));
	if (!ns)
	{
		fputs("[FATAL ERROR] Out of memory.\n", stderr);
		status = EXIT_FAILURE;
		goto cleanup;
	}

	prefix(xs, ns, size);

	status = writefile(argv[2], ns, size);

cleanup:
	free(xs);
	free(ns);

	return 0;
}

static int readstream(FILE *stream, float **xs, size_t *size)
{
	float *data;
	size_t i;

	fscanf(stream, "%zu", size);

	*xs = calloc(*size, sizeof(float));
	if (!xs)
	{
		fputs("[FATAL ERROR] Out of memory.\n", stderr);
		return EXIT_FAILURE;
	}

	data = *xs;

	for (i = 0; i < *size; i++)
		fscanf(stream, "%f", &data[i]);

	return EXIT_SUCCESS;
}

int readfile(const char *filename, float **xs, size_t *size)
{
	FILE *fin = fopen(filename, "r");

	if (!fin)
	{
		fputs("[FATAL ERROR] Can't open file to read.\n", stderr);
		return EXIT_FAILURE;
	}

	return readstream(fin, xs, size);
}

void prefix(const float *xs, float *ns, size_t size)
{
	float sum = 0.0f;
	size_t i;

	for (i = 0; i < size; i++)
	{
		sum += xs[i];
		ns[i] = sum;
	}
}

static void writestream(FILE *stream, const float *xs, size_t size)
{
	size_t i;
	for (i = 0; i < size; i++)
		fprintf(stream, "%f ", xs[i]);
	fprintf(stream, "\n");
}

int writefile(const char *filename, const float *xs, size_t size)
{
	FILE *fout = fopen(filename, "w");

	if (!fout)
	{
		fputs("[FATAL ERROR] Can't open file to write.\n", stderr);
		return EXIT_FAILURE;
	}

	writestream(fout, xs, size);
	fclose(fout);

	return EXIT_SUCCESS;
}
