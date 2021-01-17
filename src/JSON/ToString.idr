module JSON.ToString

import JSON.Value

private
escapeControlChar : Char -> List Char

private
escapeChars : List Char -> List Char -- TODO: remove all other control characters
escapeChars [] = []
escapeChars (c :: cs) = c' ++ escapeChars cs where
  prependBackslash : Char -> List Char
  prependBackslash c = ['\\', c]
  c' : List Char
  c' = case c of
            '"' => prependBackslash '"'
            '\\' => prependBackslash '\\'
            '\b' => prependBackslash 'b'
            '\f' => prependBackslash 'f'
            '\n' => prependBackslash 'n'
            '\r' => prependBackslash 'r'
            _ => escapeControlChar c

public export
toString : JSONValue -> String
toString JSONNull = "null"
toString (JSONBool x) = case x of
                             True => "true"
                             False => "false"
toString (JSONNumber x) = show x -- TODO: use scientific number
toString (JSONString x) = pack $ escapeChars $ unpack $ x where
toString (JSONObject xs) = "{" ++ pairsToString xs ++ "}" where
  pairsToString : List (String, JSONValue) -> String
  pairsToString [] = ""
  pairsToString ((name, value) :: []) = toString (JSONString name) ++ ":" ++ toString value
  pairsToString (pair :: pairs) = pairsToString [pair] ++ "," ++ pairsToString pairs
toString (JSONArray xs) = "[" ++ valuesToString xs ++ "]" where
  valuesToString : List JSONValue -> String
  valuesToString [] = ""
  valuesToString (x :: []) = toString x
  valuesToString (x :: xs) = valuesToString [x] ++ "," ++ valuesToString xs