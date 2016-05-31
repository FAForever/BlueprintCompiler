-- Routines for validating Unit blueprints.
--
-- As with all validator scripts, each validator is an object that looks like this:
-- {
--     Name: "Ensure not stupid",
--     Routine: <some function that takes a blueprint returns an error message on failure, or true>
-- }
--
-- The validation engine will invoke every validator registered in VALIDATORS for every blueprint of
-- this type that was loaded, collect up all the error messages, and print them all (if there were
-- any).
return {}
