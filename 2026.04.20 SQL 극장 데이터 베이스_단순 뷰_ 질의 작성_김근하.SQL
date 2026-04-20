판매원 테이블
Salesperson(name, age, salary)
고객 테이블
Customer(name, city, industrytype)
주문 테이블
Order(number, custname, salesperson, amount)-- 컬럼 설명
name         -- 판매원/고객 이름
age          -- 판매원 나이
salary       -- 판매원 급여
city         -- 고객 거주 도시
industrytype -- 고객 직업
number       -- 주문번호
custname     -- 주문 고객 이름
salesperson  -- 담당 판매원 이름
amount       -- 주문 금액

-- tip: view 수정 시 : create or replace view 구문 숙지

문제 1.
모든 판매원의 이름, 나이, 급여를 보여주는 뷰 v_salesperson_info를 작성하시오.
CREATE VIEW v_salesperson_info AS
SELECT name AS '이름', age AS '나이', salary AS '급여'
FROM Salesperson
;  (O)

문제 2.
급여가 10,000원 이상인 판매원의 이름과 급여를 보여주는
읽기 전용 뷰 v_high_salary_sp를 작성하시오.
CREATE VIEW v_high_salary_sp AS
SELECT name AS '이름', salary AS '급여'
FROM Salesperson 
WHERE salary >= 10000
;  (O)

문제 3.
나이가 30세 미만인 판매원의 이름, 나이, 급여를 보여주는
뷰 v_young_salesperson을 작성하시오.

CREATE VIEW v_young_salesperson AS
SELECT name AS '이름', age AS '나이', salary AS '급여'
FROM Salesperson
WHERE age < 30
;   (O)

문제 4.
 'LA'에 거주하는 고객의 이름, 도시, 직업을 보여주는
읽기 전용 뷰 v_la_customer를 작성하시오.

CREATE VIEW v_la_customer AS
SELECT name AS '이름', city AS '도시', industrytype AS '직업'
FROM Customer  
WHERE city = 'LA'
;   (O)


문제 5.
직업이 '개발자'인 고객의 이름, 도시, 직업을 보여주는
뷰 v_developer_customer를 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.

CREATE VIEW v_developer_customer AS
SELECT name AS '이름', city AS '도시', industrytype AS '직업'
FROM Customer
WHERE industrytype = '개발자'
;   (O)

문제 6.
주문 금액이 15,000원 이상인 주문의
주문번호, 고객이름, 담당판매원, 주문금액을 보여주는
읽기 전용 뷰 v_high_amount_order를 작성하시오.

CREATE VIEW v_high_amount_order AS
SELECT o.number AS '주문번호', o.custname AS '고객이름', o.salesperson AS '담당판매원', o.amount AS '주문금액'
FROM Customer c JOIN Order o ON c.name = o.custname
WHERE o.amount >= 15000 
; (O)

문제 7.
급여가 8,000원 이상 12,000원 이하인 판매원의
이름, 나이, 급여를 보여주는 뷰 v_mid_salary_sp를 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.

CREATE VIEW v_mid_salary_sp AS
SELECT name AS '이름', age AS '나이', salary '급여'
FROM Salesperson
WHERE salary BETWEEN 8000 AND 12000
with check option
;

-- with check option 처음 보니 숙지 할 것.



문제 8.
담당 판매원이 'Tom'인 주문의
주문번호, 고객이름, 담당판매원, 주문금액을 보여주는
뷰 v_tom_order를 작성하시오.

CREATE VIEW v_tom_order AS
SELECT salesperson AS '담당판매원', number AS '주문번호', amount AS '주문금액'
FROM order
WHERE salesperson = 'Tom'
; (O) 

문제 9.
이름이 'S'로 시작하는 판매원의 이름, 나이, 급여를 보여주는
읽기 전용 뷰 v_s_salesperson을 작성하시오.

CREATE VIEW v_s_salesperson AS
SELECT name AS '이름', age AS '나이', salary AS '급여'
FROM Salesperson
WHERE name LIKE 'S%'
; (O)

문제 10.
주문 금액이 5,000원 이상 10,000원 이하인 주문의
주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 뷰 v_mid_amount_order를 작성하시
오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
 (복합 뷰)

CREATE VIEW v_mid_amount_order AS
SELECT number AS '주문번호', custname AS '고객이름', salesperson AS '담당판매원', amount AS '주문금액'
FROM Order 
WHERE amount BETWEEN 5000 AND 10000
with check option
; (O)

문제 1.
판매원별 총 주문금액과 주문 횟수를 보여주는 뷰 v_sp_order_summary를 작성하시오.
 (출력 컬럼 : 판매원이름, 총주문금액, 주문횟수)
 
CREATE OR REPLACE VIEW v_sp_order_summary AS
SELECT s.name AS 판매원이름,
       SUM(o.amount) AS 총주문금액,
       COUNT(o.number) AS 주문횟수
FROM Salesperson s
JOIN "Order" o ON s.name = o.salesperson
GROUP BY s.name;


문제 2.
고객별 총 주문금액과 주문 횟수를 보여주는 뷰 v_cust_order_summary를 작성하시오.
 (출력 컬럼 : 고객이름, 도시, 총주문금액, 주문횟수)
 
 
CREATE OR REPLACE VIEW v_cust_order_summary AS
SELECT c.name AS 고객이름,
       c.city AS 도시,
       SUM(o.amount) AS 총주문금액,
       COUNT(o.number) AS 주문횟수
FROM Customer c
JOIN "Order" o ON c.name = o.custname
GROUP BY c.name, c.city;


문제 3.
판매원의 평균 급여보다 높은 급여를 받는 판매원의
이름, 나이, 급여를 보여주는 뷰 v_above_avg_salary를 작성하시오.
CREATE OR REPLACE VIEW v_above_avg_salary AS
SELECT name AS '이름', age AS '나이', salary AS '급여'
FROM Salesperson
WHERE salary > (SELECT AVG(salary) 
FROM Salesperson
); 

-- where 절에는 집계 함수를 쓸 수 없음.

문제 4.
한 번도 주문을 받지 못한 판매원의
이름, 나이, 급여를 보여주는 뷰 v_no_order_sp를 작성하시오.

CREATE VIEW v_no_order_sp AS
SELECT name AS '이름', age AS '나이', salary AS '급여'
FROM Salesperson 
WHERE name NOT IN 
(SELECT number FROM Order 
); (O)

문제 5.
 'LA'에 거주하는 고객으로부터 주문을 받은 판매원의
이름, 나이, 급여를 보여주는 뷰 v_la_order_sp를 작성하시오.

create view v_la_order_sp AS
SELECT name as '이름', age as '나이', salary as '급여'
FROM Salesperson 
WHERE name in (
SELECT o.salesperson
FROM Order o 
JOIN Customer c ON o.custname = c.name 
WHERE c.city = 'LA'
); (O)

문제 6.
판매원별 평균 주문금액을 계산하여
전체 평균 주문금액보다 높은 판매원의 이름과 평균주문금액을 보여주는
뷰 v_above_avg_order_sp를 작성하시오.

CREATE VIEW v_above_avg_order_sp AS
SELECT salesperson AS '이름', AVG(amount) AS '평균주문금액'
FROM Order
GROUP BY salesperson
HAVING AVG(amount) > (
SELECT AVG(amount) 
FROM Order)
;

문제 7.
한 번도 주문하지 않은 고객의
이름, 도시, 직업을 보여주는 뷰 v_no_order_cust를 작성하시오.

CREATE VIEW v_no_order_cust AS
SELECT name as '고객 이름', city as '도시', industrytype as '직업'
FROM Customer 
WHERE name NOT in (
      SELECT custname
      FROM Order
      ); (O)

문제 8.
 2건 이상 주문을 받은 판매원의
이름과 주문 횟수, 총 주문금액을 보여주는 뷰 v_frequent_sp를 작성하시오.

CREATE VIEW v_frequent_sp AS
SELECT salesperson as '판매원 이름', count(number) as, '주문 횟수' sum(amount) as '총 주문금액'
FROM Order
GROUP BY salesperson
HAVING count(number) >= 2; (O)

문제 9.
고객의 도시별 총 주문금액과 주문 건수를 보여주는
뷰 v_city_order_stats를 작성하시오.
 (출력 컬럼 : 도시, 총주문금액, 주문건수)

create view v_city_order_stats AS
select c.city as '도시 명', sum(o.amount) as '총 주문 금액', count(o.number) as '총 주문 건수'
from Order o JOIN Customer c ON o.custname = c.name
GROUP BY c.city ; (O)


문제 10.
판매원별 최고 주문금액, 최저 주문금액, 평균 주문금액과
자신의 급여 대비 총 주문금액 비율을 보여주는
뷰 v_sp_order_stats를 작성하시오.
 (출력 컬럼 : 판매원이름, 급여, 최고주문금액, 최저주문금액, 평균주문금액, 급여대비주문비율)

create view v_sp_order_stats as
select s.salesperson as '판매원 이름', s.salary as '급여', max(o.amount) as '최고주문금액', min(o.amount) as '최저주문금액', avg(o.amount) as '평균주문금액', SUM(o.amount) / s.salary AS '급여대비비율'
from Salesperson s  JOIN Order o ON s.name = o.salesperson
GROUP BY s.salesperson, s.salary; 

-- on 사용 시 주의할 점
--1. 이름이 아닌 '역할(Role)'을 보세요
--Name이라는 컬럼이 여러 테이블에 있다고 해서 다 같은 데이터가 아닙니다.

--Customer 테이블의 Name: 물건을 산 사람 (구매자)

--Salesperson 테이블의 Name: 물건을 판 사람 (판매자)

--Order 테이블의 Custname: 이 주문을 누가 샀는지 기록한 것

--Order 테이블의 Salesperson: 이 주문을 누가 팔았는지 기록한 것

--잘못된 예: Salesperson.Name = Customer.Name
--(판매원 이름과 고객 이름이 같은 경우만 찾게 됨 → 데이터가 거의 안 나옴)

문제 11.
직업별 총 주문금액과 평균 주문금액을 보여주는
뷰 v_industry_order_stats를 작성하시오.
 (출력 컬럼 : 직업, 총주문금액, 평균주문금액)

create view v_industry_order_stats as
select c.industrytype as '직업', o.sum(amount) as '총 주문금액', o.avg(amount) as '평균 주문금액'
from Customer c JOIN Order o = c.industrytype = o.custname
GROUP BY c.industrytype;

문제 12.
판매원 중 자신의 급여보다 총 주문금액이 더 높은 판매원의
이름, 급여, 총주문금액을 보여주는 뷰 v_sp_order_over_salary를 작성하시오.

create view v_sp_order_over_salary as
select o.salesperson as '이름', s.salary as '급여', sum(o.amount) as '총 주문금액'
from Order o JOIN Salesperson s ON o.salesperson = s.name
GROUP BY o.salesperson, s.salary
HAVING sum(o.amount) > s.salary;


문제 13.
각 판매원이 주문을 받은 고객의 수(서로 다른 고객만)와
총 주문금액을 보여주는 뷰 v_sp_cust_count를 작성하시오.
 (출력 컬럼 : 판매원이름, 담당고객수, 총주문금액)

CREATE VIEW v_sp_cust_count as
select salesperson as "판매원 이름", count(Distinct custname) as "담당고객수", sum(amount) as "총 주문금액"
from Order
GROUP BY salesperson;

-- 서로 다른 고객 = distinct 사용 여부 필 확인

문제 14.
주문 금액이 가장 높은 주문을 한 고객의
이름, 도시, 직업, 주문금액을 보여주는 뷰 v_max_order_cust를 작성하시오.

create view v_max_order_cust as
select c.name, c.city, c.industrytype, o.amount
from Customer c JOIN Order o ON c.name = o.custname 
where o.amount = (select max(amount)
from Order
);

문제 15.
판매원별로 주문금액의 합계를 구하고,
전체 주문금액 대비 각 판매원의 주문 비중을 보여주는
뷰 v_sp_order_ratio를 작성하시오.
 (출력 컬럼 : 판매원이름, 총주문금액, 전체주문금액, 주문비중)

cCREATE VIEW v_sp_order_ratio AS
SELECT 
    salesperson AS "판매원이름", 
    SUM(amount) AS "총주문금액", 
    (SELECT SUM(amount) FROM "Order") AS "전체주문금액", 
    -- 내 실적을 전체 실적으로 나누기
    SUM(amount) / (SELECT SUM(amount) FROM "Order") AS "주문비중"
FROM "Order"
GROUP BY salesperson;

문제 11.
직업별 총 주문금액과 평균 주문금액을 보여주는
뷰 v_industry_order_stats를 작성하시오.
 (출력 컬럼 : 직업, 총주문금액, 평균주문금액)

create view v_industry_order_stats as
select c.industrytype , sum(o.amount), avg(o.amount)
from Customer c JOIN Order o ON c.name = o.custname
GROUP BY c.industrytype;

문제 12.
판매원 중 자신의 급여보다 총 주문금액이 더 높은 판매원의
이름, 급여, 총주문금액을 보여주는 뷰 v_sp_order_over_salary를 작성하시오.

create view v_sp_order_over_salary as
select s.name , s.salary, sum(o.amount)
from Salesperson s JOIN Order o ON s.name = o.salesperson
GROUP BY s.name, s.salary
HAVING s.salary < sum(amount);

문제 13.
각 판매원이 주문을 받은 고객의 수(서로 다른 고객만)와
총 주문금액을 보여주는 뷰 v_sp_cust_count를 작성하시오.
 (출력 컬럼 : 판매원이름, 담당고객수, 총주문금액)
create view v_sp_cust_count as
select salesperson as "판매원이름" , count(distinct custname) as "담당고객수", sum(amount) as "총주문금액"
from Order
GROUP BY salesperson;


문제 14.
주문 금액이 가장 높은 주문을 한 고객의
이름, 도시, 직업, 주문금액을 보여주는 뷰 v_max_order_cust를 작성하시오.
create view v_max_order_cust as
select c.name as "이름", c.city as "도시", c.industrytype as "직업", o.amount as "주문금액"
from Customer c JOIN Order o ON c.name = o.custname
where amount = (select max(amount) from Order); 

문제 15.
판매원별로 주문금액의 합계를 구하고,
전체 주문금액 대비 각 판매원의 주문 비중을 보여주는
뷰 v_sp_order_ratio를 작성하시오.
 (출력 컬럼 : 판매원이름, 총주문금액, 전체주문금액, 주문비중)

select salesperson as "판매원 이름", sum(amount) as "총 주문금액", (select sum(amount) from Order) as "전채주문금액", sum(amount) / (SELECT sum(amount) FROM Order) as "주문비중" 
from Order 
GROUP BY salesperson;