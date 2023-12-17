USE clean;

/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT TOP(5)*
FROM users
ORDER BY created_at 

/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/
SELECT TOP(3) Month_name, count(Month_name) as countofdays
FROM (
		SELECT DateName(weekday , created_at) as Month_name
		FROM users
	 ) countofdays
GROUP BY Month_name
ORDER BY countofdays DESC


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/
SELECT u.username
FROM users u
LEFT JOIN photos p
ON u.id = p.user_id
WHERE image_url IS NULL


/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/
SELECT * FROM users;
SELECT * FROM photos;
SELECT * FROM likes;


SELECT *
from photos p
join likes l
on p.id = l.photo_id
join users u
on u.id = p.user_id
GROUP BY 

/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/
SELECT (SELECT COUNT(*) FROM photos)/(SELECT COUNT(*) FROM users) as div


/*user ranking by postings higher to lower*/
SELECT username, u.id,COUNT(username) as no_of_posts
FROM users u
JOIN photos p
ON u.id = p.user_id
GROUP BY username, u.id
ORDER BY no_of_posts DESC


/*total numbers of users who have posted at least one time */
SELECT COUNT(id) as no_of_users
FROM
	(
		SELECT username, u.id,COUNT(username) as no_of_posts
		FROM users u
		JOIN photos p
		ON u.id = p.user_id
		GROUP BY username, u.id
		
	) a


/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
SELECT * FROM tags
SELECT * FROM photo_tags

SELECT tag_name, tag_id,COUNT(tag_id) as no_of_tags
FROM tags t
JOIN photo_tags pt
ON t.id = pt.tag_id
GROUP BY tag_name, tag_id
ORDER BY no_of_tags DESC


/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/
SELECT *
FROM 
	(
		SELECT u.username, COUNT(username) as count_of_likes
		FROM users u
		JOIN likes l
		ON u.id = l.user_id
		GROUP BY username
	) a
WHERE count_of_likes = 
(
SELECT COUNT(*) FROM photos
) 


/*We also have a problem with celebrities
Find users who have never commented on a photo*/
SELECT * FROM comments
SELECT * FROM users

SELECT username
FROM users u
LEFT JOIN comments c
ON u.id = c.user_id
WHERE comment_text IS NULL


/*Mega Challenges
Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on every photo*/
SELECT username
FROM users u
LEFT JOIN comments c
ON u.id = c.user_id
WHERE comment_text IS NULL 

SELECT username 
FROM users u
JOIN comments c
ON u.id = c.user_id
WHERE comment_text = (SELECT COUNT(*) FROM comments)



SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who likes every photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				--GROUP BY users.id
				WHERE comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT users.id,username, COUNT(users.id) As total_likes_by_user
				FROM users
				JOIN likes ON users.id = likes.user_id
				GROUP BY users.id,username
				HAVING COUNT(users.id) = (SELECT COUNT(*) FROM photos)) AS users_likes_every_photos
	)AS tableB;





