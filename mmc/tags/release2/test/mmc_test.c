#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>


//Slot identifiers
// 1  - 0x72
// 2  - 0x74
// 3  - 0x76
// 4  - 0x78
// 5  - 0x7a
// 6  - 0x7c
// 7  - 0x7e
// 8  - 0x80
// 9  - 0x82
// 10 - 0x84
// 11 - 0x86
// 12 - 0x88



//Globals
char base_command[1000];
int mch_type, amc_slot = 1, verbose = 0, aoe = 0, nblink = 5;


//Prototypes
int ipmi_test(char *sc, char *result, int special);
void led_test(void);


/*****************/
void led_test(void)
/*****************/
{
  int loop;
  
  printf("The 3 AMC LEDs will now blink %d times\n", nblink);
  for(loop = 0; loop < nblink; loop++)
  {
    ipmi_test("0x2c 7 0 0 0 0xff 0 0x0f", " ", 2);
    ipmi_test("0x2c 7 0 0 1 0xff 0 0x0f", " ", 2);
    ipmi_test("0x2c 7 0 0 2 0xff 0 0x0f", " ", 2);
    sleep(1);
    ipmi_test("0x2c 7 0 0 0 0x00 0 0x0f", " ", 2);
    ipmi_test("0x2c 7 0 0 1 0x00 0 0x0f", " ", 2);
    ipmi_test("0x2c 7 0 0 2 0x00 0 0x0f", " ", 2);
    sleep(1);
  }
  
  //Restore local control
  ipmi_test("0x2c 7 0 0 0 0xfc 0 0x0f", " ", 2);
  ipmi_test("0x2c 7 0 0 1 0xfc 0 0x0f", " ", 2);
  ipmi_test("0x2c 7 0 0 2 0xfc 0 0x0f", " ", 2);
}


/************************************************/
int ipmi_test(char *sc, char *result, int special)
/************************************************/
{
  FILE *fp;
  int got_line = 0, bad;
  char c, command[1000], out_text[1035], full_out_text[2000];

  strcpy(command, base_command);
  strcat(command, sc);
  strcat(command, " 2> /dev/null");
  if (verbose) printf("Command = %s\n", command);

  fp = popen(command, "r"); //Open the command for reading
  if (fp == NULL) 
  {
    printf("ERROR: Failed to run command\n");
    exit(-1);
  }

  // Read the output a line at a time - output it
  memset(full_out_text, 0, 2000); 
  while (fgets(out_text, sizeof(out_text) - 1, fp) != NULL) 
  {
    got_line = 1;
    if (verbose) printf("%s\n", out_text);
    strncat(full_out_text, out_text, 48);
    if (verbose) printf("full_out_text = %s\n", full_out_text);
  }
  
  if(!got_line)
  {
    printf("ERROR: Failed to execute ipmitool for command %s\n", sc);
    if (aoe) exit(-1);
    return(0);
  }
  
  if (special == 0)
    bad = strncmp(result, full_out_text, strlen(result));

  if (special == 1)
  {
    if (strlen(full_out_text) == 7)
      bad = 0;
    else
    {
      printf("strlen = %d\n", strlen(full_out_text));
      bad = 1; 
    }   
  }

  if (special == 2)
    bad = 0; //In case of a "Set" command we just look at error codes from ipmitool 

  if (special == 3)
  {
    if (strlen(full_out_text) == 10)
    {
      bad = strncmp(result, &full_out_text[3], strlen(result - 3));
      if (bad)
        printf("Text = %s\n", &full_out_text[3]);
    }  
    else
    {
      printf("strlen = %d\n", strlen(full_out_text));
      bad = 1; 
    }    
  }

  if(bad != 0)
  {
    printf("ERROR: Sub-test for command %s failed\n", sc);
    printf("Expected result = %s\n", result);
    printf("Actual result   = %s\n", full_out_text);
    if (aoe) exit(-1);
  }

  if (verbose) printf("Test result for command <%s>: %s\n\n\n", sc, bad?"ERROR":"OK");

  pclose(fp);
  return (1 - bad);
}


/******************************/
int main(int argc, char *argv[])
/******************************/
{
  int ok, status;
  char mchname[20], sub_command[1000], c;

  sprintf(mchname, "phesemch02"); 

  while ((c = getopt(argc, argv, "avs:m:b:")) != -1)
  {
    switch (c)
    {
      case 's': amc_slot = atoi(optarg);       break;
      case 'b': nblink = atoi(optarg);         break;
      case 'v': verbose = 1;                   break;
      case 'a': aoe = 1;                       break;
      case 'm': sscanf(optarg, "%s", mchname); break;
            
      default:
        printf("Invalid option %c\n", c);
	printf("Usage: %s [options]: \n", argv[0]);
        printf("Valid options are ...\n");
        printf("-s <AMC slot number>: Slot number (1..12) of the AMC under test\n");
        printf("-m <MCH>: Short IP name of the MCH. Default = phesemch02\n");
        printf("-b <N>: Blink the 3 AMC LEDs N times\n");
        printf("-v Verbose mode\n");
        printf("-a Abort on first error\n");
        exit(-1);
    }
  }
  
  if (verbose) printf("\n\n\n\nStarting test....\n\n");

  memset(base_command, 0, 1000); 
  strcpy(base_command, "ipmitool -I lan -H ");
  strcat(base_command, mchname);
  
  if (strcmp(mchname, "phesemch02") == 0)  //NAT
  {
    if (verbose) printf("\nUsing NAT MCH....\n\n");
    strcat(base_command, " -v -P admin -T 0x82 -t ");
    mch_type = 2;
  }
  else //Kontron
  {
    if (verbose) printf("\nUsing Kontron MCH....\n\n");
    strcat(base_command, " -v -U admin -P admin -A PASSWORD -T 0x82 -t ");
    mch_type = 1;
  }
  
  sprintf(sub_command, "0x%02x", 0x70 + amc_slot * 2); 
  strcat(base_command, sub_command);
  strcat(base_command, " -b 7 raw ");
  if (verbose) printf("Base Command = %s\n", base_command);

  if (nblink)
    led_test();

  ok = ipmi_test("0x06 0x01", " 00 80 01 00 51 29 ad be 00 ad be", 0);

  ok = ipmi_test("0x04 0x01", " 20", 0);  //MJ: Should we not get " 20 00"?
  ok = ipmi_test("0x04 0x00 0x20", "", 2);

  ok = ipmi_test("0x04 0x20", " 08 01", 0);
 
  if(mch_type == 2)
  {
    ok = ipmi_test("0x04 0x21 0 0 0 0 0 20", " 01 00 00 00 51 12 16 76 00 00 29 00 00 00 c1 63 00 cb 41 4d 43 2d", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 1 0 0 20", " 02 00 01 00 51 01 3b 76 00 01 c1 63 03 48 01 01 80 0a a8 7a 38 38", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 2 0 0 20", " 03 00 02 00 51 01 33 76 00 02 c1 63 03 48 01 01 80 0a a8 7a 38 38", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 3 0 0 20", " 04 00 03 00 51 01 37 76 00 00 c1 63 03 c1 f2 6f 07 00 07 00 00 00", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 4 0 0 20", " 05 00 04 00 51 02 23 76 00 03 c1 63 03 c2 08 6f 01 00 01 00 01 00", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 5 0 0 20", " 06 00 05 00 51 02 26 76 00 04 c1 63 03 c2 07 0a 01 00 01 00 01 00", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 6 0 0 20", " 07 00 06 00 51 01 2e 76 00 05 c1 63 03 48 02 01 80 0a a8 7a 38 38", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 7 0 0 20", " 08 00 07 00 51 01 3a 76 00 07 c1 63 03 48 01 01 80 0a a8 7a 38 38", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 8 0 0 20", " ff ff 08 00 51 02 25 76 00 06 c1 63 03 c2 07 0a 01 00 01 00 01 00", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
  }
  else
  {  
    ok = ipmi_test("0x04 0x21 0 0 0 0 0 14", " 01 00 00 00 51 12 16 76 00 00 29 00 00 00 c1 63", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 1 0 0 14", " 02 00 01 00 51 01 3b 76 00 01 c1 63 03 48 01 01", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 2 0 0 14", " 03 00 02 00 51 01 33 76 00 02 c1 63 03 48 01 01", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 3 0 0 14", " 04 00 03 00 51 01 37 76 00 00 c1 63 03 c1 f2 6f", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 4 0 0 14", " 05 00 04 00 51 02 23 76 00 03 c1 63 03 c2 08 6f", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 5 0 0 14", " 06 00 05 00 51 02 26 76 00 04 c1 63 03 c2 07 0a", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 6 0 0 14", " 07 00 06 00 51 01 2e 76 00 05 c1 63 03 48 02 01", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 7 0 0 14", " 08 00 07 00 51 01 3a 76 00 07 c1 63 03 48 01 01", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
    ok = ipmi_test("0x04 0x21 0 0 8 0 0 14", " ff ff 08 00 51 02 25 76 00 06 c1 63 03 c2 07 0a", 0);  //MJ: The records are actually longer. We just look at the first 20 bytes 
  }

  ok = ipmi_test("0x04 0x22", "", 1);
  ok = ipmi_test("0x04 0x2d 0", " c0 01", 3);
  ok = ipmi_test("0x04 0x2d 1", " c0 20", 3);
  ok = ipmi_test("0x04 0x2d 2", " c0 20", 3);
  ok = ipmi_test("0x04 0x2d 3", " c0 00", 3);
  ok = ipmi_test("0x04 0x2d 4", " c0 00", 3);
  ok = ipmi_test("0x04 0x2d 5", " c0 00", 3);  
  ok = ipmi_test("0x04 0x2d 6", " c0 00", 3);
  ok = ipmi_test("0x04 0x2d 7", " c0 20", 3);
  ok = ipmi_test("0x0a 0x10 0", " 28 01 00", 0);

  if(mch_type == 2)
  {
    ok = ipmi_test("0x0a 0x11 0 0x00 0x00 0x10", " 10 01 00 00 01 11 21 00 cc 01 10 19 50 4a 74 c4 43", 0);
    ok = ipmi_test("0x0a 0x11 0 0x10 0x00 0x10", " 10 50 50 4d cb 41 4d 43 2d 53 6f 72 6d 69 6f 75 c9", 0);
    ok = ipmi_test("0x0a 0x11 0 0x20 0x00 0x10", " 10 31 31 31 31 31 31 31 31 31 c5 41 4d 43 2d 53 c0", 0);
    ok = ipmi_test("0x0a 0x11 0 0x30 0x00 0x10", " 10 c1 d5 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x40 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x50 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x60 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x70 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x80 0x00 0x10", " 10 00 00 00 00 00 00 00 2f 01 10 19 c4 43 50 50 4d", 0);
    ok = ipmi_test("0x0a 0x11 0 0x90 0x00 0x10", " 10 cb 41 4d 43 2d 53 75 67 69 74 6f 6e c5 41 4d 43", 0);
    ok = ipmi_test("0x0a 0x11 0 0xa0 0x00 0x10", " 10 2d 53 c2 30 32 cc 31 31 31 31 31 31 31 31 32 31", 0);
    ok = ipmi_test("0x0a 0x11 0 0xb0 0x00 0x10", " 10 31 32 01 c0 c1 d1 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xc0 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xd0 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xe0 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xf0 0x00 0x10", " 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x00 0x01 0x10", " 10 00 00 00 00 00 00 00 89 c0 02 06 30 08 5a 31 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x10 0x01 0x10", " 10 16 00 2f c0 82 10 ac 02 5a 31 00 19 00 00 80 01", 0);
  }
  else
  {
    ok = ipmi_test("0x0a 0x11 0 0x00 0x00 15", " 0f 01 00 00 01 11 21 00 cc 01 10 19 50 4a 74 c4", 0);
    ok = ipmi_test("0x0a 0x11 0 0x10 0x00 15", " 0f 50 50 4d cb 41 4d 43 2d 53 6f 72 6d 69 6f 75", 0);
    ok = ipmi_test("0x0a 0x11 0 0x20 0x00 15", " 0f 31 31 31 31 31 31 31 31 31 c5 41 4d 43 2d 53", 0);
    ok = ipmi_test("0x0a 0x11 0 0x30 0x00 15", " 0f c1 d5 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x40 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x50 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x60 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x70 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x80 0x00 15", " 0f 00 00 00 00 00 00 00 2f 01 10 19 c4 43 50 50", 0);
    ok = ipmi_test("0x0a 0x11 0 0x90 0x00 15", " 0f cb 41 4d 43 2d 53 75 67 69 74 6f 6e c5 41 4d", 0);
    ok = ipmi_test("0x0a 0x11 0 0xa0 0x00 15", " 0f 2d 53 c2 30 32 cc 31 31 31 31 31 31 31 31 32", 0);
    ok = ipmi_test("0x0a 0x11 0 0xb0 0x00 15", " 0f 31 32 01 c0 c1 d1 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xc0 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xd0 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xe0 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0xf0 0x00 15", " 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0);
    ok = ipmi_test("0x0a 0x11 0 0x00 0x01 15", " 0f 00 00 00 00 00 00 00 89 c0 02 06 30 08 5a 31", 0);
    ok = ipmi_test("0x0a 0x11 0 0x10 0x01 15", " 0f 16 00 2f c0 82 10 ac 02 5a 31 00 19 00 00 80", 0);
  }

  ok = ipmi_test("0x0a 0x11 0 0x20 0x01 0x08", " 08 a4 98 f3 00 00 00 00 00", 0);
  
  ok = ipmi_test("0x2c 0x00 0", " 00 04 00 00", 0);  //MJ: Does the data make sense?
  ok = ipmi_test("0x2c 0x04 0 0 1", " 00", 0);
  ok = ipmi_test("0x2c 0x05 0", " 00 07 00", 0);
  ok = ipmi_test("0x2c 0x06 0 0 0", " 00 02 01 01", 0);
  ok = ipmi_test("0x2c 0x06 0 0 1", " 00 04 02 02", 0);
  ok = ipmi_test("0x2c 0x06 0 0 2", " 00 08 03 03", 0);

  ok = ipmi_test("0x2c 0x08 0 0 0", " 00 01 00 00 01", 0);
  ok = ipmi_test("0x2c 0x08 0 0 1", " 00 01 00 00 02", 0);
  ok = ipmi_test("0x2c 0x08 0 0 2", " 00 01 ff 00 03", 0);

  ok = ipmi_test("0x2c 0xd 0 0 0", " 00 00 00", 0);  //MJ: This command should only require 2 parameters

  ok = ipmi_test("0x2c 0x1a 0 0", " 00", 0);

  return 0;
}

