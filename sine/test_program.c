#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare the extern assembly function
extern void sine(char *input, char *output);

int main() {
    char input[] = "0.5"; // Input string
    char output[100];    // Buffer to store the result

    // Call the assembly function to compute sine
    sine(input, output);

    // Print the result
    printf("Sine of %s is: %s\n", input, output);

    return 0;
}
