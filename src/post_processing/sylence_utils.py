import pandas as pd
from osekit.utils.timestamp_utils import strptime_from_text


def clean_pamguard_false_detection(df: pd.DataFrame) -> pd.DataFrame:
    """Clean PAMGuard false detections.

    The first detection on each audio file corresponds to the detection of
    an electronic buzz made by the recorder (might be very specific to Sylence data).
    This function identifies and removes these false detections by checking if
    a detection occurs within the first five seconds of the corresponding audio file.

    Parameters
    ----------
    df: pd.DataFrame
        APLOSE DataFrame (presumably from PAMGuard)

    Returns
    -------
    A cleaned DataFrame with false detections removed

    """
    filenames = df["filename"]
    tz_data = df["start_datetime"][0].tz
    filename_datetimes = [
        strptime_from_text(fn, "%Y_%m_%d_%H_%M_%S").tz_localize(tz_data)
        for fn in filenames
    ]

    start_datetimes = df["start_datetime"]

    # compare date of filename detection and date of detection and delete all lines
    # for which the detection happens in the 5 first seconds of the file
    max_time = 5
    idx_false_detections = []
    for i in range(len(start_datetimes)):
        d = (start_datetimes[i] - filename_datetimes[i]).total_seconds()
        if d < max_time:
            idx_false_detections.append(i)

    return df.drop(labels=idx_false_detections)
