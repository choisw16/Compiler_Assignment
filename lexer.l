%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_SIZE 100
char postfix[MAX_SIZE];
int top = -1;
int isError = 0;
int isNumError = 0;
char result[1000]=""; 

void push(char ch){
    if(top == MAX_SIZE - 1){
        printf("Error\n");
        exit(1);
    }
    postfix[++top] = ch;
}

char pop(){
    if(top == -1){
        printf("Error\n");
        exit(1);
    }
    return postfix[top--];
}

%}

 
DIGIT [0-9]
OPERATOR [-+]
NUMBER (0|([1-9]{DIGIT}*))

%%
{NUMBER}    {   if(isNumError==1){
	            printf("error\n");
		    exit(1);
		}
		else{
		    strcat(result,yytext);
		    strcat(result, " ");
		    isError=0; 
		    isNumError=1; 
		}    // operand 출력 
	    }  
{OPERATOR}  {
                if((yytext[0] == '+' || yytext[0] == '-') && isError == 1){
                    printf("error\n");
                    exit(1);
                }
                else if(top == -1){
                    push(yytext[0]);
		    isError = 1;
                }
                else{
                    while(top != -1 && isError==0){
			char str[2];
			str[0] = pop();
			str[1] = '\0';
                        strcat(result, str);
			strcat(result, " ");
                    }
                    push(yytext[0]);
                }
		isNumError=0;
            }
[ \t]        { }    // 무시
\n          { 
                while(top != -1){
		    char str[2];
		    str[0] = pop();
		    str[1]='\0';
		    strcat(result, str);
		}  // 스택에 남아있는 연산자 출력
		printf("%s", result);
                printf("\n"); 
            }
.           { printf("error\n"); exit(1); }
%%

int main(){
    yylex();

    return 0;
}


