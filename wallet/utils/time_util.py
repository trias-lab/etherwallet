import time

def stamp2datetime(stamp):
    # stamp to date
    tl = time.localtime(int(stamp))
    format_time = time.strftime("%Y-%m-%d %H:%M:%S", tl)
    return format_time

def stamp2UTCdatetime(stamp):
    # stamp to date
    tl = time.gmtime(int(stamp))
    format_time = time.strftime("%Y-%m-%dT%H:%M:%S.000000Z", tl)
    return format_time
