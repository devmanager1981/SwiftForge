# agents/utils.py

import logging
import os
def setup_logger(name, level=logging.INFO, log_file=None):
    import logging
    import os

    logger = logging.getLogger(name)
    logger.setLevel(level)

    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    if not logger.handlers:
        ch = logging.StreamHandler()
        ch.setFormatter(formatter)
        logger.addHandler(ch)

        if log_file:
            os.makedirs(os.path.dirname(log_file), exist_ok=True)
            fh = logging.FileHandler(log_file, encoding="utf-8")
            fh.setFormatter(formatter)
            logger.addHandler(fh)

    return logger

def safe_get(obj: dict, path: list, default=None):
    """Safely get a nested value from a dictionary using a list of keys."""
    try:
        for key in path:
            obj = obj[key]
        return obj
    except (KeyError, TypeError):
        return default
