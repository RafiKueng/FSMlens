@* Exception.

@(ErrorMsg.java@>=
  package qgd.util;
  @= /** Front-end to system exceptions. */ @>
  public class ErrorMsg extends Exception
    { private static final long serialVersionUID = 42;
      public ErrorMsg(String msg)
        { super(msg);
        }
    }

