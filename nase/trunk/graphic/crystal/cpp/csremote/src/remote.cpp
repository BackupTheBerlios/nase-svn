#include <iostream.h>
#include <string.h>
#include "cssysdef.h"
#include "cssys/sysfunc.h"
#include "cstool/initapp.h"
#include "remote.h"
#include "iutil/objreg.h"
#include "ivideo/graph2d.h"
#include "igraphic/imageio.h"
#include "imap/parser.h"
#include "ivaria/reporter.h"
#include "ivaria/stdrep.h"
#include "csutil/cmdhelp.h"
#include "csgfx/rgbpixel.h"
#include "inetwork/driver2.h"
#include "inetwork/socket2.h"
#include "inetwork/sockerr.h"
  
//*************************************************
//Implementation von csRemoteControl
//*************************************************
csRemoteControl::csRemoteControl (iObjectRegistry* object_reg)
{
  //SCF_CONSTRUCT_IBASE(NULL)
  printf("hallo");
  csRemoteControl::object_reg = object_reg;
  
}


csRemoteControl::~csRemoteControl()
{
  printf("csRemoteControl::~csRemoteControl()\n");
  if (client != NULL)
    {
      client->Disconnect();
      client->Close();
    }

  server->Close();
  printf("Server closed\n");
  printf("Server == NULL is "); 
  if (server == NULL)  
    {
      printf("true"); 
    }
   else printf("false");
  printf("\n");
}

bool csRemoteControl::Initialize(csRef<iGraphics2D> g2d, int port)
{
  if (!csInitializer::RequestPlugins (object_reg,
	CS_REQUEST_PLUGIN("crystalspace.network.driver.sockets2",iNetworkDriver2),
	CS_REQUEST_END))
  {
    csReport (object_reg, CS_REPORTER_SEVERITY_ERROR,
    	"crystalspace.application.simple",
	"Can't initialize Network-Plugin!");
    return false;
  }
  int portnumber;
  if ((port > 1000) and (port < 9999)) 
  {
    portnumber=port; 
    cout << portnumber;
  }
  else portnumber=1234;

  printf("Initialisiere Remote Object\n");
  netdriver = CS_QUERY_REGISTRY(object_reg, iNetworkDriver2);
  printf("iNetworkDriver2 geladen\n");
  if (!netdriver)
    {
       csReport (object_reg, CS_REPORTER_SEVERITY_ERROR,
    	"crystalspace.application.simple",
    	"Error loading network driver");
    return false;
    }
  // Create TCP socket.
  server = netdriver->CreateSocket(CS_NET_SOCKET_TYPE_TCP);

  printf("TCP socket erzeugt\n");

  // Last error is netdriver->LastError().
  if (server)
    {
      server->SetSocketReuse(true);
      if (server->LastError() != CS_NET_SOCKET_NOERROR)
	printf("Unable to unset reuse option.\n");
      server->SetSocketBlock(true);
      if (server->LastError() != CS_NET_SOCKET_NOERROR)
	printf("Unable to set block option.\n");
      // Wait on port portnumber queue up to 200 connections.
      printf("Try connecting to port %d\n", portnumber);
      server->WaitForConnection(0, portnumber, 200);
      if (server->LastError() != CS_NET_SOCKET_NOERROR)
	printf("Unable to bind to port.\n");
      if (server->IsConnected()) printf("server is connected\n");
    }
  
  csRemoteControl::g2d=g2d;
  return true;
}

bool csRemoteControl::ConnectToLocalHost()
{
  if (server)
    {

      if ((client == NULL) or (!client->IsConnected())) 
        {
          //          printf("Verbinde mit Client\n");
          client = server->Accept();
          if (server->LastError() != CS_NET_SOCKET_NOERROR) printf("cannot accept\n");
          client->SetSocketReuse(true);
          client->SetSocketBlock(false);
          //            printf("client ist ");
          //            if (!client->IsConnected()) printf("NICHT ");
          //            printf("connected\n");
          char *RName;
          RName=client->RemoteName();
          char *LocalHost="127.0.0.1";
          //           cout << "RemoteName[0]=" << RName[7] << RName[8] << (int)RName[9] << endl;
          //           cout << "Length of localVarLocalHost:" << strlen(LocalHost) << endl;
          //           cout << "Length of client->RemoteName()" << strlen(RName) << endl;
          //           for (int i=0; i<strlen(RName); i++) cout <<i<<": "<<RName[i]<<" "<<LocalHost[i]<<endl;
          //           cout << endl;
          unsigned int StrIsEquel;
          StrIsEquel = strncmp(RName, LocalHost, 8);
          //          cout << "strncmp(RName, LocalHost, 8) = " << StrIsEquel;
          if (! (StrIsEquel == 0))
            {
              //               cout << "no correct localhost connection" << endl;
              client->Disconnect();
              client->Close();
            }
          else 
            {
              cout << "connected to LocalHost"<<endl;
              return true;
            }
        }
    }
  return false;
}


csRemoteControlMessage csRemoteControl::TalkToRemote()
{
  if (server != NULL)
    {
      if (client != NULL)
        {
          // We have a connection.
//           cout << "client != NULL" << endl;
//           cout << "Client ist ";
//           if (!client->IsConnected()) cout << "NICHT ";
//           cout << "connected" << endl;
//           cout << "RemoteName: " << client->RemoteName() << endl;

          if (client->IsConnected())
            {
              //              cout << "RemoteName: " << client->RemoteName() << endl;
              char a;
              a='x';
              //            client->Send("Hallo\r\n",7);
              client->Recv(&a, 1);
//               if (a='x')
//                 {
//                   //                 printf("No Message sent from Remote\n");
//                   return CS_REMOTE_NOMESSAGE;
//                 }
//               else
                {
                  switch((int)a)
                    {
//                     case 'x': printf("NoMessage");
//                       break;
                    case 'g': return CS_REMOTE_SCREENSHOT_REQUEST;               
                      break;
                    case (char)10: printf("End Of Line sent\n");
                      break;
                    case 'l': return CS_REMOTE_KBD_LEFT;
                      break;
                    case 'r': return CS_REMOTE_KBD_RIGHT;
                      break;
                    case 'h': client->Send("Hallo\r\n",7);
                      break;
                    }
                }
                //              cout << "a= " << (int)a << " = " << a << endl;
            }
        }
    }
  return CS_REMOTE_NOMESSAGE;
}

void csRemoteControl::BlockSend(char* memory, long int memsize)
{
  printf("Block-Send ...");
  long int MaxBlockSize = 30000;
  long int RestSize = memsize;
  char* MemPointer = memory;
  int SendSize = 0;
  while (RestSize > MaxBlockSize)
    {
      char a = 'a';
      //      printf("Sende %d Byte Block %d\n", MaxBlockSize, a);
      SendSize = client->Send(MemPointer, MaxBlockSize);     
      //      printf("SendSize = %d \n", SendSize);
      if (SendSize > 0) 
        {
          MemPointer = MemPointer + SendSize;
          RestSize = RestSize - SendSize;
        }
    }
  while (RestSize > 0)
    {
      //      printf("Sende Rest\n");
      SendSize = client->Send(MemPointer, RestSize);
      //      printf("SendSize = %d \n", SendSize);
      if (SendSize > 0) 
        {
          MemPointer = MemPointer + SendSize;
          RestSize = RestSize - SendSize;
        }      
    }
  printf("\n done \n");
}


void csRemoteControl::SendScreenShot()
{
  printf("ScreenShot requested\n");
  bild=g2d->ScreenShot();
  cout << "Bildformat:" << bild->GetFormat() << endl;
  cout << "g2dFormat:" << g2d->GetPixelFormat()->PixelBytes << endl;
  cout << "BildSize:" << bild->GetSize() << endl;
  int bwidth;
  bwidth = bild->GetWidth();
  cout << "BildWidth:" << bwidth << endl;
  int bheight;
  bheight = bild->GetHeight();
  cout << "BildHight:" << bheight << endl;
  csRGBpixel *dst;
  csRGBpixel *IData; 
  IData = (csRGBpixel*)bild->GetImageData();
  dst=IData;
  unsigned char pixel;
  char* PictureMemory;
  long int memsize = bwidth*bheight;
  PictureMemory = new char[memsize];
  char*  MemPointer = PictureMemory;
  printf("MemorySize=%d  long=%d",bwidth*bheight, memsize);

  cout << "ENDE" << endl;
  
  client->Send("ScreenShotStart\n",16);
  void* IntPointer=&bwidth;
  client->Send((char*)IntPointer, sizeof(bwidth));
  IntPointer = &bheight;
  client->Send((char*)IntPointer, sizeof(bheight));
  void* PixelPointer;

  //client->SetSocketBlock(true);
  printf("Sende ScreenShot ...\n");
 for (int h=0; h<bheight; h++) for (int b=0; b<bwidth; b++) 
    {
      pixel=dst->red;
      //    printf("%d ", pixel);
      PixelPointer=&pixel;
      *MemPointer=(char)pixel;
      // client->Send((char*)PixelPointer, sizeof(pixel));
      //      printf("%d %d\n",(int)(*MemPointer), (int)pixel);
      dst++;
      MemPointer++;
    }
 // client->Send(PictureMemory, memsize); 
 //printf("fertig \n");
 BlockSend(PictureMemory, memsize);
 //client->SetSocketBlock(false);

 delete[] PictureMemory;
}

//*************************************************
//ENDE csRemoteControl
//*************************************************
