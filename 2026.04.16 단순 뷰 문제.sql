/* ==========================================================
   [1] 마당서점 기본 뷰 생성 문제 (10문제)
   ========================================================== */

-- 마당서점 복합 뷰 생성 문제
-- 마당서점의 기본 테이블 구조입니다.
--  sql-- 고객 테이블
-- Customer(custid, name, address, phone)-- 도서 테이블
-- Book(bookid, bookname, publisher, price)-- 주문 테이블
-- Orders(orderid, custid, bookid, saleprice, orderdate)
-- 문제 10개

-- 문제 1. 고객별 총 주문금액과 주문 횟수
CREATE OR REPLACE VIEW v_cust_order_summary AS
SELECT c.name AS 고객이름, SUM(o.saleprice) AS 총주문금액, COUNT(o.orderid) AS 주문횟수
FROM Customer c JOIN Orders o ON c.custid = o.custid
GROUP BY c.name;

-- 문제 2. 도서별 도서명, 출판사, 판매 총 수량, 총 판매금액
CREATE OR REPLACE VIEW v_book_sales AS
SELECT b.bookname AS 도서명, b.publisher AS 출판사, COUNT(o.orderid) AS 주문횟수, SUM(o.saleprice) AS 총판매금액
FROM Book b LEFT JOIN Orders o ON b.bookid = o.bookid
GROUP BY b.bookname, b.publisher;

-- 문제 3. 주문 고객 이름, 주소, 최근 주문일
CREATE OR REPLACE VIEW v_cust_last_order AS
SELECT c.name, c.address, MAX(o.orderdate) AS 최근주문일
FROM Customer c JOIN Orders o ON c.custid = o.custid
GROUP BY c.name, c.address;

-- 문제 4. 정가보다 할인되어 판매된 주문 내역
CREATE OR REPLACE VIEW v_discounted_orders AS
SELECT o.orderid, c.name, b.bookname, b.price AS 정가, o.saleprice AS 판매가, (b.price - o.saleprice) AS 할인금액
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid
WHERE b.price > o.saleprice;

-- 문제 5. 출판사별 평균 및 최고 판매가격
CREATE OR REPLACE VIEW v_publisher_stats AS
SELECT b.publisher, AVG(o.saleprice) AS 평균판매가, MAX(o.saleprice) AS 최고판매가
FROM Book b JOIN Orders o ON b.bookid = o.bookid
GROUP BY b.publisher;

-- 문제 6. 총 주문금액 3만 원 이상 우수 고객
CREATE OR REPLACE VIEW v_vip_customer AS
SELECT c.name, SUM(o.saleprice) AS 총주문금액
FROM Customer c JOIN Orders o ON c.custid = o.custid
GROUP BY c.name
HAVING SUM(o.saleprice) >= 30000;

-- 문제 7. 2024년 주문 내역
CREATE OR REPLACE VIEW v_orders_2024 AS
SELECT c.name, b.bookname, o.saleprice, o.orderdate
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid
WHERE o.orderdate BETWEEN '2024-01-01' AND '2024-12-31';

-- 문제 8. 한 번도 주문되지 않은 도서
CREATE OR REPLACE VIEW v_unsold_books AS
SELECT bookname, publisher, price
FROM Book
WHERE bookid NOT IN (SELECT bookid FROM Orders);

-- 문제 9. 고객별 최고가 구매 도서명과 금액
CREATE OR REPLACE VIEW v_cust_max_order AS
SELECT c.name AS 고객이름, b.bookname AS 도서명, o.saleprice AS 최고구매금액
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid
WHERE (o.custid, o.saleprice) IN (SELECT custid, MAX(saleprice) FROM Orders GROUP BY custid);

-- 문제 10. 판매가 대비 해당 도서 평균가 및 차이
CREATE OR REPLACE VIEW v_book_price_compare AS
SELECT b.bookname, c.name, o.saleprice, 
       (SELECT AVG(saleprice) FROM Orders WHERE bookid = b.bookid) AS 도서평균판매가,
       (o.saleprice - (SELECT AVG(saleprice) FROM Orders WHERE bookid = b.bookid)) AS 차이
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid;


/* ==========================================================
   [2] 마당서점 복합 뷰 문제 (10문제)
   ========================================================== */
[사원 데이터베이스]

-- 문제 1. 출판사별 판매 도서 수와 총 판매금액
CREATE OR REPLACE VIEW v_publisher_sales AS
SELECT b.publisher, COUNT(o.orderid) AS 판매도서수, SUM(o.saleprice) AS 총판매금액
FROM Book b JOIN Orders o ON b.bookid = o.bookid
GROUP BY b.publisher;

-- 문제 2. 평균 구매금액이 전체 평균보다 높은 고객
CREATE OR REPLACE VIEW v_above_avg_customer AS
SELECT c.name AS 고객이름, AVG(o.saleprice) AS 평균구매금액
FROM Customer c JOIN Orders o ON c.custid = o.custid
GROUP BY c.name
HAVING AVG(o.saleprice) > (SELECT AVG(saleprice) FROM Orders);

-- 문제 3. 판매가격 높은 순 정렬 주문 내역
CREATE OR REPLACE VIEW v_orders_detail AS
SELECT b.bookname, c.name, o.orderdate, o.saleprice
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid
ORDER BY o.saleprice DESC;

-- 문제 4. 2권 이상 주문한 고객과 횟수
CREATE OR REPLACE VIEW v_frequent_customer AS
SELECT c.name, COUNT(o.orderid) AS 주문횟수
FROM Customer c JOIN Orders o ON c.custid = o.custid
GROUP BY c.name
HAVING COUNT(o.orderid) >= 2;

-- 문제 5. 고객별 마지막 주문 도서명과 일자
CREATE OR REPLACE VIEW v_last_ordered_book AS
SELECT c.name AS 고객이름, b.bookname AS 도서명, o.orderdate AS 주문일자
FROM Orders o JOIN Customer c ON o.custid = c.custid JOIN Book b ON o.bookid = b.bookid
WHERE (o.custid, o.orderdate) IN (SELECT custid, MAX(orderdate) FROM Orders GROUP BY custid);

-- 문제 6. 평균 할인율이 가장 높은 출판사 순 (할인된 경우만)
CREATE OR REPLACE VIEW v_publisher_discount_rate AS
SELECT b.publisher, AVG((b.price - o.saleprice) / b.price * 100) AS 평균할인율
FROM Book b JOIN Orders o ON b.bookid = o.bookid
WHERE b.price > o.saleprice
GROUP BY b.publisher
ORDER BY 평균할인율 DESC;

-- 문제 7. 주문 유무 구분 (주문있음/주문없음)
CREATE OR REPLACE VIEW v_customer_order_status AS
SELECT c.name AS 고객이름, 
       CASE WHEN COUNT(o.orderid) > 0 THEN '주문있음' ELSE '주문없음' END AS 주문여부
FROM Customer c LEFT JOIN Orders o ON c.custid = o.custid
GROUP BY c.name;

-- 문제 8. 월별 총 판매금액과 주문 건수
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT TO_CHAR(orderdate, 'YYYY') AS 년도, TO_CHAR(orderdate, 'MM') AS 월, 
       SUM(saleprice) AS 총판매금액, COUNT(orderid) AS 주문건수
FROM Orders
GROUP BY TO_CHAR(orderdate, 'YYYY'), TO_CHAR(orderdate, 'MM');

-- 문제 9. 같은 출판사 도서 2종류 이상 구매 고객
CREATE OR REPLACE VIEW v_publisher_loyal_customer AS
SELECT c.name, b.publisher, COUNT(DISTINCT b.bookid) AS 구매종류수
FROM Customer c JOIN Orders o ON c.custid = o.custid JOIN Book b ON o.bookid = b.bookid
GROUP BY c.name, b.publisher
HAVING COUNT(DISTINCT b.bookid) >= 2;

-- 문제 10. 도서별 최고/최저/평균 및 최대 할인금액
CREATE OR REPLACE VIEW v_book_price_stats AS
SELECT b.bookname, b.publisher, MAX(o.saleprice) AS 최고판매가, MIN(o.saleprice) AS 최저판매가, 
       AVG(o.saleprice) AS 평균판매가, MAX(b.price - o.saleprice) AS 최대할인금액
FROM Book b JOIN Orders o ON b.bookid = o.bookid
GROUP BY b.bookname, b.publisher;


/* ==========================================================
   [3] 사원 데이터베이스 기초 문제 (10문제)
   ========================================================== */

-- 문제 1. 사원 기본 정보
CREATE OR REPLACE VIEW v_emp_basic AS
SELECT e.empid, e.name, d.dept_name, e.position, e.salary
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id;

-- 문제 2. 급여 500만 원 이상 (읽기 전용)
CREATE OR REPLACE VIEW v_high_salary_emp AS
SELECT name, position, salary, dept_name
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE salary >= 5000000
WITH READ ONLY;

-- 문제 3. 현재 진행 중인 프로젝트
CREATE OR REPLACE VIEW v_active_projects AS
SELECT proj_id, proj_name, start_date, end_date
FROM Project
WHERE SYSDATE BETWEEN start_date AND end_date;

-- 문제 4. 2019년 이전 입사자 근속연수
CREATE OR REPLACE VIEW v_veteran_employee AS
SELECT empid, name, d.dept_name, hire_date, 
       (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date)) AS 근속연수
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE hire_date < TO_DATE('2019-01-01', 'YYYY-MM-DD');

-- 문제 5. 서울 소재 부서 정보
CREATE OR REPLACE VIEW v_seoul_department AS
SELECT dept_id, dept_name, budget
FROM Dept
WHERE location = '서울';

-- 문제 6. 부장 또는 이사 (읽기 전용)
CREATE OR REPLACE VIEW v_senior_position AS
SELECT empid, name, position, salary
FROM Emp
WHERE position IN ('부장', '이사')
WITH READ ONLY;

-- 문제 7. PM 역할 사원 정보
CREATE OR REPLACE VIEW v_pm_role AS
SELECT empid, proj_id, role, hours
FROM Emp_Project
WHERE role = 'PM';

-- 문제 8. 주니어 급여 사원 (2022년 이후 입사 & 300만 미만)
CREATE OR REPLACE VIEW v_junior_emp AS
SELECT name, position, salary, hire_date
FROM Emp
WHERE salary < 3000000 AND hire_date >= TO_DATE('2022-01-01', 'YYYY-MM-DD');

-- 문제 9. 1억 이상 프로젝트 (읽기 전용)
CREATE OR REPLACE VIEW v_large_budget_project AS
SELECT proj_name, start_date, end_date, budget
FROM Project
WHERE budget >= 100000000
WITH READ ONLY;

-- 문제 10. 관리자 없는 최상위 관리자 중 고연봉자
CREATE OR REPLACE VIEW v_top_executive AS
SELECT e.empid, e.name, d.dept_name, e.position, e.salary
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE e.manager_id IS NULL AND e.salary >= 7000000
WITH READ ONLY;


/* ==========================================================
   [4] 사원 데이터베이스 복합 문제 (10문제)
   ========================================================== */

-- 문제 1. 부서별 평균/최고/최저 급여
CREATE OR REPLACE VIEW v_dept_salary_stats AS
SELECT d.dept_name, AVG(e.salary) AS 평균급여, MAX(e.salary) AS 최고급여, MIN(e.salary) AS 최저급여
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 문제 2. 사원별 참여 프로젝트 수와 총 시간
CREATE OR REPLACE VIEW v_emp_project_summary AS
SELECT e.name AS 사원이름, COUNT(ep.proj_id) AS 참여프로젝트수, SUM(ep.hours) AS 총투입시간
FROM Emp e JOIN Emp_Project ep ON e.empid = ep.empid
GROUP BY e.name;

-- 문제 3. 부서 예산 대비 평균 급여 비율
CREATE OR REPLACE VIEW v_dept_budget_ratio AS
SELECT d.dept_name, d.budget AS 부서예산, AVG(e.salary) AS 평균급여, 
       ROUND(AVG(e.salary) / d.budget * 100, 2) AS 급여예산비율
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
GROUP BY d.dept_name, d.budget;

-- 문제 4. 활성 프로젝트 참여 사원 상세
CREATE OR REPLACE VIEW v_active_project_emp AS
SELECT e.name, d.dept_name, p.proj_name, ep.role
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id 
JOIN Emp_Project ep ON e.empid = ep.empid 
JOIN Project p ON ep.proj_id = p.proj_id
WHERE SYSDATE BETWEEN p.start_date AND p.end_date;

-- 문제 5. 프로젝트 미참여 사원
CREATE OR REPLACE VIEW v_no_project_emp AS
SELECT e.empid, e.name, d.dept_name, e.position
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE e.empid NOT IN (SELECT empid FROM Emp_Project);

-- 문제 6. 프로젝트별 참여 현황
CREATE OR REPLACE VIEW v_project_stats AS
SELECT p.proj_name, COUNT(ep.empid) AS 참여사원수, SUM(ep.hours) AS 총투입시간, AVG(ep.hours) AS 평균투입시간
FROM Project p JOIN Emp_Project ep ON p.proj_id = ep.proj_id
GROUP BY p.proj_name;

-- 문제 7. 부서 평균보다 높은 급여 사원
CREATE OR REPLACE VIEW v_above_dept_avg AS
SELECT e.name, d.dept_name, e.salary, 
       (SELECT AVG(salary) FROM Emp WHERE dept_id = e.dept_id) AS 부서평균급여
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE e.salary > (SELECT AVG(salary) FROM Emp WHERE dept_id = e.dept_id);

-- 문제 8. 부서별 최고 근속자
CREATE OR REPLACE VIEW v_longest_serving AS
SELECT e.name, d.dept_name, e.hire_date, 
       (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM e.hire_date)) AS 근속연수
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
WHERE (e.dept_id, e.hire_date) IN (SELECT dept_id, MIN(hire_date) FROM Emp GROUP BY dept_id);

-- 문제 9. 2개 이상 프로젝트 & 100시간 이상 투입 사원
CREATE OR REPLACE VIEW v_active_emp AS
SELECT e.name, COUNT(ep.proj_id) AS 참여프로젝트수, SUM(ep.hours) AS 총투입시간
FROM Emp e JOIN Emp_Project ep ON e.empid = ep.empid
GROUP BY e.name
HAVING COUNT(ep.proj_id) >= 2 AND SUM(ep.hours) >= 100;

-- 문제 10. 부서별 PM 수 및 부서 평균 급여
CREATE OR REPLACE VIEW v_dept_pm_stats AS
SELECT d.dept_name, 
       (SELECT COUNT(*) FROM Emp e2 JOIN Emp_Project ep2 ON e2.empid = ep2.empid 
        WHERE e2.dept_id = d.dept_id AND ep2.role = 'PM') AS PM수,
       AVG(e.salary) AS 부서평균급여
FROM Emp e JOIN Dept d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;