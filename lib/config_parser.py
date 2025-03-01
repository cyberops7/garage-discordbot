"""
Parse a yaml config file and resolve special tokens to allow for dynamic configuration.
"""

import os
import re
from ast import literal_eval
from typing import Any


def resolve_env_token(token: str) -> str | None:
    try:
        # Extract environment variable name and default value
        parts = token.replace("@env", "").strip().split(",")
        env_var_name = parts[0].strip()
        default_value = parts[1].strip() if len(parts) > 1 else None
    except IndexError as e:
        msg = f"Invalid @env token format: {token}"
        raise ValueError(msg) from e
    else:
        return os.getenv(env_var_name, default_value)


def resolve_format_token(token: str) -> str | None:
    try:
        # Extract the inner string for @format
        formatted_string = token.replace("@format", "").strip()

        # Find and resolve all nested tokens using a regex
        tokens = re.findall(r"{(.*?)}", formatted_string)
        resolved_tokens = {token: resolve_value(token) for token in tokens}

        # Replace each nested token with its resolved value
        for tkn, resolved_value in resolved_tokens.items():
            if resolved_value is None:
                continue  # Skip tokens wth `None` values
            formatted_string = formatted_string.replace(
                f"{{{tkn}}}", str(resolved_value)
            )
    except Exception as e:
        msg = f"Invalid @format token format: {token}. Error: {e}"
        raise ValueError(msg) from e
    else:
        return formatted_string


def resolve_math_token(token: str) -> int | None:
    try:
        # Remove the @math prefix and evaluate the expression
        math_expression = token.replace("@math", "").strip()
        result = literal_eval(math_expression)
    except Exception as e:
        msg = f"Invalid @math expression: {token}. Error: {e}"
        raise ValueError(msg) from e
    else:
        return int(result)


def resolve_value(value: str) -> str | int | None:
    """
    Resolves a single value.
    If the value contains a special token, it gets evaluated.
    """
    # Handle @env tokens
    if isinstance(value, str) and value.startswith("@env"):
        return resolve_env_token(value)
    # Handle @format tokens
    if isinstance(value, str) and value.startswith("@format"):
        return resolve_format_token(value)
    # Handle @math tokens
    if isinstance(value, str) and value.startswith("@math"):
        return resolve_math_token(value)
    return value


def resolve_nested_dict(
    current_dict: dict[str, Any | dict[str, Any]],
) -> dict[str, Any | dict[str, Any]]:
    """
    Recursively resolves values in the dictionary, including nested dictionaries.
    """
    resolved_dict = {}
    for key, value in current_dict.items():
        if isinstance(value, dict):
            # Recursive call for nested dictionaries
            resolved_dict[key] = resolve_nested_dict(value)
        else:
            # Resolve a single value
            resolved_dict[key] = resolve_value(value)
    return resolved_dict


def resolve_values(
    env_dict: dict[str, Any | dict[str, Any]],
) -> dict[str, Any | dict[str, Any]]:
    """
    Recursively evaluates all values in a nested dictionary and resolves special tokens:
        - @env:     Retrieves the value of an environment variable,
                    with the second token as the default value.
        - @format:  Resolves nested tokens and constructs a formatted string.
        - @math:    Evaluates a mathematical expression.

    Returns a new dictionary with all values resolved.

    Token format examples:
        - "@env ENV_VAR,default_value"
        - "@format {@env ENV_VAR1,default_value1}/{@env ENV_VAR2,default_value2}"
        - "@math 1 + 2 * 3"
    """
    # Start recursive resolution on the top-level dictionary
    return resolve_nested_dict(env_dict)
