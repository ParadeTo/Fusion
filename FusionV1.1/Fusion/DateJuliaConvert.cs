using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Fusion
{
    class DateJuliaConvert
    {
        //public int year;
        //public int month;
        //public int day;
        //public int juliaday;
        public DateJuliaConvert()
        {
        }
        public int[] JuliaDay(int year, int month, int day)
        {
            int[] Y = new int[2];
            int leapyear = year % 4;
            int juliaday = 0;
            int leap;
            if (leapyear > 0)
            {
                leap = 0;
            }
            else
            {
                if (year % 100 == 0 && year % 400 == 0)
                {
                    leap = 0;
                }
                else//平年
                {
                    leap = 1;
                }
            }
            //
            switch (month)
            {
                case 1: juliaday = day; break;
                case 2: juliaday = day + 31; break;
                case 3: juliaday = day + 59; break;
                case 4: juliaday = day + 90; break;
                case 5: juliaday = day + 120; break;
                case 6: juliaday = day + 151; break;
                case 7: juliaday = day + 181; break;
                case 8: juliaday = day + 212; break;
                case 9: juliaday = day + 243; break;
                case 10: juliaday = day + 273; break;
                case 11: juliaday = day + 304; break;
                case 12: juliaday = day + 334; break;
            }
            if (leap == 1)
            {
                if (month >= 3)
                {
                    juliaday = juliaday + 1;
                }
            }
            Y[0] = year;
            Y[1] = juliaday;
            return Y;
        }
        public int[] _JuliaDay(int year, int juliaday)
        {
            int leapyear = year % 4;
            int[] Y = new int[3];
            int leap;
            int month=0;
            int day=0;
            if (leapyear > 0)
            {
                leap = 0;
            }
            else
            {
                if (year % 100 == 0 && year % 400 == 0)
                {
                    leap = 0;
                }
                else//平年
                {
                    leap = 1;
                }
            }
            if (leap == 0)
            {
                if (juliaday <= 31)
                {
                    month = 1;
                    day = juliaday;
                }
                if (juliaday >= 32 && juliaday <= 59)
                {
                    month = 2;
                    day = juliaday - 31;
                }
                if (juliaday >= 60 && juliaday <= 90)
                {
                    month = 3;
                    day = juliaday - 59;
                }
                if (juliaday >= 91 && juliaday <= 120)
                {
                    month = 4;
                    day = juliaday - 90;
                }
                if (juliaday >= 121 && juliaday <= 151)
                {
                    month = 5;
                    day = juliaday - 120;
                }
                if (juliaday >= 152 && juliaday <= 181)
                {
                    month = 6;
                    day = juliaday - 151;
                }
                if (juliaday >= 182 && juliaday <= 212)
                {
                    month = 7;
                    day = juliaday - 181;
                }
                if (juliaday >= 213 && juliaday <= 243)
                {
                    month = 8;
                    day = juliaday - 212;
                }
                if (juliaday >= 244 && juliaday <= 273)
                {
                    month = 9;
                    day = juliaday - 243;
                }
                if (juliaday >= 274 && juliaday <= 304)
                {
                    month = 10;
                    day = juliaday - 274;
                }
                if (juliaday >= 305 && juliaday <= 334)
                {
                    month = 11;
                    day = juliaday - 305;
                }
                if (juliaday >= 335 && juliaday <= 365)
                {
                    month = 12;
                    day = juliaday - 334;
                }
            }
            else//闰年
            {
                if (juliaday <= 31)
                {
                    month = 1;
                    day = juliaday;
                }
                if (juliaday >= 32 && juliaday <= 60)
                {
                    month = 2;
                    day = juliaday - 31;
                }
                if (juliaday >= 61 && juliaday <= 91)
                {
                    month = 3;
                    day = juliaday - 60;
                }
                if (juliaday >= 92 && juliaday <= 121)
                {
                    month = 4;
                    day = juliaday - 91;
                }
                if (juliaday >= 122 && juliaday <= 152)
                {
                    month = 5;
                    day = juliaday - 121;
                }
                if (juliaday >= 153&& juliaday <= 182)
                {
                    month = 6;
                    day = juliaday - 152;
                }
                if (juliaday >= 183 && juliaday <= 213)
                {
                    month = 7;
                    day = juliaday - 182;
                }
                if (juliaday >= 214 && juliaday <= 244)
                {
                    month = 8;
                    day = juliaday - 213;
                }
                if (juliaday >= 245 && juliaday <= 274)
                {
                    month = 9;
                    day = juliaday - 244;
                }
                if (juliaday >= 275 && juliaday <= 305)
                {
                    month = 10;
                    day = juliaday - 275;
                }
                if (juliaday >= 306 && juliaday <= 335)
                {
                    month = 11;
                    day = juliaday - 306;
                }
                if (juliaday >= 336 && juliaday <= 366)
                {
                    month = 12;
                    day = juliaday - 335;
                }
            }
            Y[0] = year;
            Y[1] = month;
            Y[2] = day;
            return Y;
        }
    }
}
