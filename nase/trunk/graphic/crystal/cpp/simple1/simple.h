#ifndef __SIMPLE_H__
#define __SIMPLE_H__

#include <stdarg.h>
#include "remote.h"

struct iEngine;
struct iLoader;
struct iGraphics3D;
struct iKeyboardDriver;
struct iSector;
struct iView;
struct iVirtualClock;
struct iObjectRegistry;
struct iEvent;
struct iSector;
struct iView;

class Simple
{
private:
  iObjectRegistry* object_reg;
  csRef<iEngine> engine;
  csRef<iLoader> loader;
  csRef<iGraphics3D> g3d;
  csRef<iKeyboardDriver> kbd;
  csRef<iVirtualClock> vc;
  csRef<iView> view;
  iSector* room;
  static bool SimpleEventHandler (iEvent& ev);
  bool HandleEvent (iEvent& ev);
  void SetupFrame ();
  void FinishFrame ();
  csRemoteControl* remote; 
  bool ConnectNow;
  int port; 
 
public:
  Simple (iObjectRegistry* object_reg);
  ~Simple ();

  bool Initialize ();
  void Start ();
};

#endif // __SIMPLE1_H__
