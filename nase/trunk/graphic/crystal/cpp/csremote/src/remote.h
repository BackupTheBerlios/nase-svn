#ifndef __CS_REMOTE_H__
#define __CS_REMOTE_H__

struct iObjectRegistry;
struct iGraphics2D;
struct iImage;  //um ScreenShot zu speichern
struct iNetworkDriver2;
struct iNetworkSocket2;

 

enum csRemoteControlMessage
  {
    CS_REMOTE_NOMESSAGE,
    CS_REMOTE_KBD_LEFT,
    CS_REMOTE_KBD_RIGHT,
    CS_REMOTE_SCREENSHOT_REQUEST
  };
 
// csRemoteControl
class csRemoteControl
{
 private:
  iObjectRegistry* object_reg;
  csRef<iNetworkDriver2> netdriver;
  csRef<iNetworkSocket2>  client;
  csRef<iNetworkSocket2>  server;
  csRef<iGraphics2D> g2d;
  csRef<iImage> bild;  //Screenshot speichern  //überprüfen, ob wirklich sinnvoll als SmartPointer
  void BlockSend(char* memory, long int memsize);

 public:
   csRemoteControl (iObjectRegistry* object_reg); 
  ~csRemoteControl();
  bool Initialize(csRef<iGraphics2D> g2d, int port);
  bool ConnectToLocalHost();
  csRemoteControlMessage TalkToRemote();
  void SendScreenShot();
};

// ENDE csRemoteControl

#endif // __CS_REMOTE_H__
