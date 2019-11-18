package ru.sbrf.bdata.ctl.robot;

public class RobotLogging {
    enum LogLevel {ERROR, WARN, INFO, DEBUG, TRACE}

    public static String error(String message) {
        return log(LogLevel.ERROR, message); // TODO add stack trace
    }

    public static String warn(String message) {
        return log(LogLevel.WARN, message);
    }

    public static String info(String message) {
        return log(LogLevel.INFO, message);
    }

    public static String debug(String message) {
        return log(LogLevel.DEBUG, message);
    }

    public static String trace(String message) {
        return log(LogLevel.TRACE, message);
    }

    private static String log(LogLevel level, String message) {
        String s = String.format("*%s:%d* %s", level, System.currentTimeMillis(), message);
        System.out.println(s);
        return s;
    }
}
