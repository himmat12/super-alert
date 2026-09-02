
BEGIN;
    INSERT INTO dt.users(id, name) VALUES(1, 'Bob Miller');
    INSERT INTO dt.users(id, name) VALUES(2, 'Alice Tyler');
    INSERT INTO dt.users(id, name) VALUES(3, 'John Meyer');
COMMIT;