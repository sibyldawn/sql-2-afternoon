-- 1. Get all invoices where the `UnitPrice` on the `InvoiceLine` is greater than $0.99.

        select *
        from Invoice i
        join InvoiceLine il on il.invoiceId = i.invoiceId
        where il.unitPrice > 0.99;

-- 2. Get the `InvoiceDate`, customer `FirstName` and `LastName`, and `Total` from all invoices.
        select InvoiceDate, FirstName, LastName, Total
        from Invoice i
        join Customer c on i.customerId = c.customerId;

-- 3. Get the customer `FirstName` and `LastName` and the support rep's `FirstName` and `LastName` from all customers. 
--     * Support reps are on the Employee table.

        select c.FirstName, c.LastName,e.FirstName, e.LastName
        from Customer c
        join Employee e on c.supportRepId = e.employeeId;

-- 4. Get the album `Title` and the artist `Name` from all albums.
        select al.Title, ar.Name
        from Album al
        join Artist ar on al.artistId = ar.artistId;
-- 5. Get all PlaylistTrack TrackIds where the playlist `Name` is Music.
        select pt.TrackId 
        from PlaylistTrack pt
        join Playlist p on pt.PlaylistId = p.PlayListId
        where Name = 'Music';

-- 6. Get all Track `Name`s for `PlaylistId` 5.
        select t.Name 
        from Track t
        join PlaylistTrack pt on t.trackId = pt.trackId
        where pt.PlaylistId = 5;

-- 7. Get all Track `Name`s and the playlist `Name` that they're on ( 2 joins ).
        select t.name, p.name
        from Track t
        join PlaylistTrack pt on t.trackId = pt.trackId
        join Playlist p on pt.playlistId = p.playListId;


-- 8. Get all Track `Name`s and Album `Title`s that are the genre `"Alternative"` ( 2 joins ).
        select t.name, a.title
            from Track t
            join Album a on t.albumId = a.albumId
            join Genre g on t.genreId = g.genreId
            where g.GenreId = 
                (select g.GenreId
                from genre 
                where g.Name =
                'Alternative');


-- * Get all tracks on the playlist(s) called Music and show their name, genre name, album name, and artist name.
--   * At least 5 joins.
    select p.name, g.name, al.title,ar.name
    from Track t
    join PlaylistTrack pt on pt.trackId = t.trackId 
    join Playlist p on p.playlistId = pt.playListId
    join Genre g on g.genreId = t.genreId
    join Album al on al.albumId = t.albumId
    join Artist ar on ar.artistId = al.artistId
    where p.name = 'Music';

--NESTED QUERIES
-- 1. Get all invoices where the `UnitPrice` on the `InvoiceLine` is greater than $0.99.
        select * 
        from invoice
        where invoiceId in 
        (select invoiceId from invoiceLine
        where unitPrice > 0.99);


-- 2. Get all Playlist Tracks where the playlist name is Music.
        select *
        from Track
        where TrackId in 
        (select TrackId 
        from PlaylistTrack
        where playlistId in
        (select playlistId from playlist
        where name = 'Music'));
-- 3. Get all Track names for `PlaylistId` 5.
        select track.Name
        from Track
        where trackId in (select trackId from PlaylistTrack
                 	      where playlistId = 5)
-- 4. Get all tracks where the `Genre` is Comedy.
        select *
        from Track
        where genreId in (select genreId from Genre where name='Comedy')
-- 5. Get all tracks where the `Album` is Fireball.
        select *
        from Track
        where albumId in (select albumId from Album where name = 'Fireball')
-- 6. Get all tracks for the artist Queen ( 2 nested subqueries ).
         select *
         from Track
         where AlbumId in (select AlbumId from Album where ArtistId in 
                        (select ArtistId from Artist where Name ='Queen'));

/*UPDATE*/

-- 1. Find all customers with fax numbers and set those numbers to `null`.
        update customer
        set fax =null
        where fax is not null;
-- 2. Find all customers with no company (null) and set their company to `"Self"`.
        update Customer
        set Company = 'Self'
        where Company is null;
-- 3. Find the customer `Julia Barnett` and change her last name to `Thompson`.
        update Customer
        set LastName = 'Thompson'
        where FirstName = 'Julia' and LastName ='Barnett';

-- 4. Find the customer with this email `luisrojas@yahoo.cl` and change his support rep to `4`.
        update Customer
        set supportRepId = 4
        where Email = 'luisrojas@yahoo.cl';
-- 5. Find all tracks that are the genre `Metal` and have no composer. Set the composer to `"The darkness around us"`.
        update Track
        Set Composer = 'The darkness around us'
        where Composer is null and GenreId in (select GenreId from Genre where name = 'Metal' );
-- 6. Refresh your page to remove all database changes. 
        REFRESHED


/*GROUP BY*/
-- 1. Find a count of how many tracks there are per genre. Display the genre name with the count.
        select count(*), g.Name
        from track t
        join genre g on t.genreId = g.genreId
        group by g.Name;
-- 2. Find a count of how many tracks are the `"Pop"` genre and how many tracks are the `"Rock"` genre.
        select count(*), g.Name
        from track t
        join genre g on t.genreId = g.genreId
        where g.Name = 'Pop' or g.Name= 'Rock'
        group by g.Name;

-- 3. Find a list of all artists and how many albums they have.
        select artist.Name,count(*)
        from artist 
        join album on artist.artistid = album.artistid
        group by album.artistid;


/*DISTINCT*/
-- 1. From the `Track` table find a unique list of all `Composer`s.
        select distinct composer
        from track;
-- 2. From the `Invoice` table find a unique list of all `BillingPostalCode`s.
        select distinct billingpostalcode
        from invoice;
-- 3. From the `Customer` table find a unique list of all `Company`s.
        select distinct company
        from customer;

/*CREATE DUMMY TABLE THEN DELETE*/
-- Copy, paste, and run the SQL code from the summary.
-- Delete all "bronze" entries from the table.
    delete from practice_delete
    where type = 'bronze';
-- Delete all "silver" entries from the table.
    delete from practice_delete
    where type = 'silver';
-- Delete all entries whose value is equal to 150.
    delete from practice_delete
    where value = 150;

-- ### Summary

-- Let's simulate an e-commerce site. We're going to need users, products, and orders.

-- * Users need a name and an email.
-- * Products need a name and a price
-- * Orders need a ref to product.
-- * All 3 need primary keys.

-- ### Instructions

-- * Create 3 tables following the criteria in the summary.

create table products
( product_id SERIAL PRIMARY KEY,
  name text ,
  price decimal
); 

create table orders ( 
  order_id SERIAL PRIMARY KEY,
  product_id integer,
  quantity integer,
  Foreign Key (product_id) references products(product_id)
  Foreign Key (user_id) references users(user_id)
);  


create table users
(user_id SERIAL PRIMARY KEY,
 name text not null,
 email text not null unique,
  order_id integer references orders(order_id)); 


-- * Add some data to fill up each table.
--   * At least 3 users, 3 products, 3 orders.
insert into users
(name,email)
values
('Sibyl','gmail@sibyl.com'),
('Beau','gmail@beau.com'),
('Andi','gmail@andi.com'); 

insert into products
(name,price)
values
('apple',0.99),
('cauliflower', 4.00),
('spinach', 1.00); 

insert into orders
(user_id, product_id, quantity)
values
(3,1,5),
(3,1,2),
(2,1,10),
(1,2,3);
    
-- * Run queries against your data.
--   * Get all products for the first order.
        select *, u.name
        from orders o
        join users u on u.user_id = o.user_id
        where o.order_id = 1;
--   * Get all orders.
        select *,u.name,p.name
        from orders o
        join users u on o.user_id = u.user_id
        join products p on o.product_id = p.product_id;

--   * Get the total cost of an order ( sum the price of all products on an order ).
        select sum(price)
        from products p 
        join orders o on o.product_id = p.product_id
        where order_id = 1;
-- * Add a foreign key reference from Orders to Users.
        alter table orders add column user_id integer references users(user_id);
-- * Update the Orders table to link a user to each order.
        update orders
        set user_id = 1
        where order_id =3;
-- * Run queries against your data.
--   * Get all orders for a user.
        select *
        from orders o
        join users u on o.user_id = u.user_id
        join products p on o.product_id = p.product_id
        where u.user_id = 3;
--   * Get how many orders each user has.
        select SUM(p.price) 
        from products p
        join orders o on o.product_id = p.product_id
        join users u on o.user_id = u.user_id
        where u.user_id=3;

-- ### Black Diamond

-- * Get the total amount on all orders for each user.
        select SUM(p.price)
        from products p
        join orders o on o.product_id = p.product_id
        join users u on o.user_id = u.user_id
        group by u.user_id;