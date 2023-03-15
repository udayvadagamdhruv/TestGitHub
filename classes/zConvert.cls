public with sharing class zConvert
{
  public static String ToString(Datetime Value,String format)
  {
     /* string representation if a Datetime value with formatting */
     return Value.format(format);
  }
}