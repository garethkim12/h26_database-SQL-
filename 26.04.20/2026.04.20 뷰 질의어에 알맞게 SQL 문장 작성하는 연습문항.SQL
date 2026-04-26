 4월 16일  뷰 질의어에 알맞게 SQL문장을 작성하는 연습문항.

교재 127 chap2장 연습문제 17번 기준
 [수강신청 데이터베이스]
학생(학번, 이름, 전공, 학년)
수강(과목코드, 학번, 수강학기, 성적)
과목(과목코드, 과목이름, 강의실, 요일, 담당교수)
 
 (1)학생 수강 전체 현황 뷰를 작성하시오.
 (학생정보+수강 과목+성적을 한 번에 확인가능하도록 작성)
  CREATE VIEW V_all_student as
  select 학번, 이름, 전공, 학년, 과목코드, 학번, 수강학기, 성적 as
  from 학생 ㅎ JOIN 수강 ㅅ ON ㅎ.학번 = ㅅ.학번;

 (2)각 학생별 평균 성적 뷰를 작성하시오.
 (각 학생의 전체 수강 과목 평균 성적 계산 뷰)
 
  create view V_학생별_평균성적 AS
  select 학번, avg(성적)  
  from 수강
  group by 학번;

 (3)과목별 수강 인원 및 평균 성적 뷰를 작성하시오.
 (각 과목의 수강 인원과 평균, 최고,최저 성적 통계 뷰)
 
 create view v_과목별_평균성적 as
 select 과목코드, count(학번), avg(성적), max(성적), min(성적)
 from 수강
 group by 과목코드; 

 (4)성적 우수 학생 뷰를 작성하시오.(평균 90점 이상)
 (평균 성적이 90점 이상이 우수 학생만 조회하는 뷰)
 create view v_우수학생 as
 select ㅎ.학번, ㅎ.이름, ㅎ.전공, ㅎ.학년, avg(ㅅ.성적)
 from 학생 ㅎ JOIN 수강 ㅅ ON ㅎ.학번 = ㅅ.학번
 group by ㅎ.학번, ㅎ.이름, ㅎ.전공, ㅎ.학년
 having avg(성적) >= 90;

 (5)전공 별 수강 통계 뷰를 작성하시오.
전공별 총 수강 건수와 전공 평균 성적 비교 뷰)
 
 create view v_수강통계 as
 select ㅎ.전공, count(ㅅ.학번), avg(ㅅ.성적)
 from 학생 ㅎ JOIN 수강.ㅅ
  
 (6)학기별 수강 현황 뷰를 작성하시오.
 
CREATE VIEW v_학기별_현황 AS
SELECT 수강학기, COUNT(*) AS 수강건수, AVG(성적) AS 평균성적
FROM 수강
GROUP BY 수강학기;

 (7)미수강 학생 뷰를 작성하시오.
 
CREATE VIEW v_미수강_학생 AS
SELECT s.학번, s.이름, s.전공
FROM 학생 s
LEFT JOIN 수강 e ON s.학번 = e.학번
WHERE e.학번 IS NULL;

 (8)담당 교수별 강의 및 수강 현황 뷰를 작성하시오.
  과목별 담당 과목 수와 총 수강 학생수를 집계하는 뷰)
 
CREATE VIEW v_교수별_현황 AS
SELECT c.담당교수, COUNT(DISTINCT c.과목코드) AS 담당과목수, COUNT(e.학번) AS 총수강학생수
FROM 과목 c
LEFT JOIN 수강 e ON c.과목코드 = e.과목코드
GROUP BY c.담당교수;

 (9)학년별 수강 과목 수 및 평균 성적 뷰를 작성하시오.
 (학년에 따른 수강 부담과 성적 추이를 파악하는 뷰 작성)
 
CREATE VIEW v_학년별_현황 AS
SELECT s.학년, COUNT(e.과목코드) AS 총수강과목수, AVG(e.성적) AS 평균성적
FROM 학생 s
JOIN 수강 e ON s.학번 = e.학번
GROUP BY s.학년;

 (10)성적 미입력(NULL) 수강 내역 뷰를 작성하시오.
 (성적이 아직 입력되지 않은 수강 내역 관리용이다.)

CREATE VIEW v_성적_미입력 AS
SELECT *
FROM 수강
WHERE 성적 IS NULL;

교재 126 chap2장 연습문제 16번 극장데이터베이스 기준
위 데이터베이스 정보를 가지고 문제에 대한 뷰를 작성한다.
 ￿테이블 구조 확인
극장(극장번호, 극장이름, 위치)
상영관(극장번호, 상영관번호, 영화제목, 가격, 좌석수)
예약(극장번호, 상영관번호, 고객번호, 좌석번호, 날짜)
고객(고객번호, 이름, 주소)

 ￿뷰 생성 질의어 15개

1. 전체 상영 정보 통합 뷰를 작성하시오.
 (극장 + 상영관 + 영화 정보를 한눈에 확인 가능하도록 작성)

CREATE VIEW v_전체_상영정보 AS
SELECT t.극장이름, t.위치, s.상영관번호, s.영화제목, s.가격
FROM 극장 t
JOIN 상영관 s ON t.극장번호 = s.극장번호;
 
2 .예약 전체 현황 뷰를 작성하시오
 (고객이 어떤 극장·상영관·영화를 예약했는지 통합 조회하도록 작성)
 
CREATE VIEW v_예약_현황 AS
SELECT c.이름 AS 고객명, t.극장이름, r.상영관번호, s.영화제목, r.날짜
FROM 예약 r
JOIN 고객 c ON r.고객번호 = c.고객번호
JOIN 극장 t ON r.극장번호 = t.극장번호
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호;

3. 극장별 상영 영화 목록 뷰를 작성하시오
  (각 극장에서 상영 중인 영화와 가격, 좌석수 조회)

CREATE VIEW v_극장별_영화 AS
SELECT t.극장이름, s.영화제목, s.가격, s.좌석수
FROM 극장 t
JOIN 상영관 s ON t.극장번호 = s.극장번호;

4. 고객별 예약 내역 뷰를 작성하시오
  (고객별 예약한 영화 목록과 날짜, 금액 조회가능한 뷰)

CREATE VIEW v_고객별_예약 AS
SELECT c.이름, s.영화제목, r.날짜, s.가격 AS 금액
FROM 고객 c
JOIN 예약 r ON c.고객번호 = r.고객번호
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호;

5. 상영관별 예약 인원 및 잔여 좌석 뷰를 작성하시오
  (상영관의 총 좌석 대비 예약 현황과 잔여 좌석 계산)

CREATE VIEW v_상영관별_좌석현황 AS
SELECT s.극장번호, s.상영관번호, s.좌석수 AS 총좌석, COUNT(r.고객번호) AS 예약인원, (s.좌석수 - COUNT(r.고객번호)) AS 잔여좌석
FROM 상영관 s
LEFT JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호
GROUP BY s.극장번호, s.상영관번호, s.좌석수;

6. 극장별 총 예약 수 및 매출 뷰를 작성하시오
  (극장별 총 예약 건수와 누적 매출 집계를 볼 수 있는 뷰)
 
CREATE VIEW v_극장별_매출 AS
SELECT t.극장이름, COUNT(r.고객번호) AS 총예약수, SUM(s.가격) AS 총매출
FROM 극장 t
JOIN 예약 r ON t.극장번호 = r.극장번호
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호
GROUP BY t.극장이름;

7. 영화별 예약 현황 뷰를 작성하시오
  (영화 제목별 총 예약 인원과 총 매출 집계 뷰)
      
CREATE VIEW v_영화별_매출 AS
SELECT s.영화제목, COUNT(r.고객번호) AS 총예약인원, SUM(s.가격) AS 총매출
FROM 상영관 s
JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호
GROUP BY s.영화제목;

8. 날짜별 예약 현황 뷰를 작성하시오
  (날짜별 예약 건수와 해당 날짜 매출 조회 가능한 뷰 작성)

CREATE VIEW v_날짜별_매출 AS
SELECT r.날짜, COUNT(*) AS 예약건수, SUM(s.가격) AS 매출
FROM 예약 r
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호
GROUP BY r.날짜;

9. 예약 이력이 없는 고객 뷰
(한 번도 예약한 적 없는 고객 조회하는 뷰 작서)

CREATE VIEW v_미예약_고객 AS
SELECT c.이름, c.주소
FROM 고객 c
LEFT JOIN 예약 r ON c.고객번호 = r.고객번호
WHERE r.고객번호 IS NULL;

 10. 고객별 총 예약 횟수 및 결제 금액 뷰
(고객의 예약 활동 통계) (충성 고객 분석용)

CREATE VIEW v_고객_충성도 AS
SELECT c.이름, COUNT(r.고객번호) AS 예약횟수, SUM(s.가격) AS 총결제금액
FROM 고객 c
JOIN 예약 r ON c.고객번호 = r.고객번호
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호
GROUP BY c.이름;

 11. 가격이 가장 비싼 상영관 뷰를 작성하시오
   (티켓 가격 기준 상위 상영관 목록 조회하는 뷰 작성)

CREATE VIEW v_최고가_상영관 AS
SELECT *
FROM 상영관
WHERE 가격 = (SELECT MAX(가격) FROM 상영관);

 12. 위치별 극장 및 상영 현황 뷰
 (지역(위치)별로 운영 중인 극장과 상영 영화 수 집계하는 뷰 작성)

CREATE VIEW v_지역별_현황 AS
SELECT t.위치, COUNT(DISTINCT t.극장번호) AS 극장수, COUNT(s.영화제목) AS 상영영화수
FROM 극장 t
JOIN 상영관 s ON t.극장번호 = s.극장번호
GROUP BY t.위치;

 13. 만석 상영관 뷰를 작성하시오
  (예약 좌석 수가 전체 좌석 수와 동일한 매진 상영관 조회)

CREATE VIEW v_매진_상영관 AS
SELECT s.극장번호, s.상영관번호, s.영화제목
FROM 상영관 s
JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호
GROUP BY s.극장번호, s.상영관번호, s.영화제목, s.좌석수
HAVING COUNT(r.고객번호) = s.좌석수;

 14. 특정 날짜 예약 고객 상세 뷰를 작성하시오
  (날짜별 예약 고객 정보와 관람 영화 상세 조회)

CREATE VIEW v_날짜별_고객상세 AS
SELECT r.날짜, c.이름, c.주소, s.영화제목, s.상영관번호
FROM 예약 r
JOIN 고객 c ON r.고객번호 = c.고객번호
JOIN 상영관 s ON r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호;

 15. 예약 없는 상영관 뷰
  개설되었지만 예약이 한 건도 없는 상영관 조회
 
CREATE VIEW v_예약없는_상영관 AS
SELECT s.극장번호, s.상영관번호, s.영화제목
FROM 상영관 s
LEFT JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호
WHERE r.극장번호 IS NULL;

127페이지 문제 18번  [판매원 데이터베이스]를 기본으로 뷰를 작성한다.
 [판매원 데이터베이스]
 Salesperson(name,   age,  salary)
 Order(number, custname, salesperson,amount)
 Customer(name,   city,   industrytype)
 Order.salesperson → Salesperson.name 참조
Order.custname → Customer.name 참조

 뷰 생성 질의어 15개

1. 전체 주문 통합 현황 뷰를 작성하시오
(주문 + 고객 + 영업사원 정보를 한눈에 통합 조회 뷰)
 
create view v_전체주문_통합뷰 as
select o.number, o.custname, s.name, s.age, s.salary 
from Order o JOIN Customer c ON o.custname = c.name
JOIN Saleperson s ON o.salesperson = s.name;

2. 영업사원별 총 주문 금액 및 건수 뷰를 작성하시오
(영업사원별 실적(주문 건수, 총 매출) 집계)

create view v_영업사원별_총주문금액 as
select s.name, count(o.number), sum(o.amount)
from Salesperson s JOIN Order o ON s.name = o.salesperson
group by s.name;


3. 고객별 총 주문 금액 뷰를 작성하시오
(고객별 누적 주문 횟수와 총 구매 금액 집계 포함된 뷰)
 
 create view v_sum_sal as
 select c.name AS "고객명", count(o.number) AS "누적주문횟수",, sum(o.amount) AS "총구매금액"
 from Order o 
 JOIN Customer c ON o.name = c.custname
 group by c.name

4. 도시별 주문 현황 뷰를 작성하시오
(도시(city)별 총 주문 건수와 매출 집계 포함된 뷰)
 
create view v_city_all as
select city as '도시',  

5. 업종별 주문 통계 뷰를 작성하시오
  (산업 유형(industrytype)별 주문 건수 및 총 매출 비교 뷰)

6. 고액 주문 뷰 (amount 상위)를 작성하시오
  (주문 금액이 평균 이상인 고액 주문만 조회하는 뷰)

7. 주문 실적 없는 영업사원 뷰를 작성하시오
   (한 건도 주문을 처리하지 않은 영업사원 조회 뷰)

8. 주문 이력 없는 고객 뷰를 작성하시오
  (등록은 되어 있지만 한 번도 주문하지 않은 고객 조회 뷰)

9. 영업사원 급여 등급 뷰를 작성하시오
  (급여 구간별로 영업사원을 분류하는 뷰)

10. 영업사원별 담당 고객 목록 뷰를 작성하시오
  (각 영업사원이 주문을 처리한 고객 목록(중복 제거) 생성 뷰)

11. 최고 실적 영업사원 뷰를 작성하시오
  (총 주문 금액이 가장 높은 영업사원 조회하는 뷰)
  
12. 도시별 영업사원 활동 현황 뷰를 작성하시오
  (어느 도시의 고객에게 얼마나 판매했는지 영업사원 기준 집계 뷰)

 13. 영업사원 급여 대비 매출 효율 뷰를 작성하시오
 (영업사원 급여 대비 총 매출 비율로 효율성 측정 뷰)

 14. 업종별 담당 영업사원 현황 뷰를 작성하시오
   (산업 유형별로 어떤 영업사원이 활동하는지 파악)

15. 주문 금액 구간별 분류 뷰를 작성하시오
  (주문을 금액 구간으로 나누어 분류 및 통계 제공 뷰)

 [여행사 데이터베이스] 128page 연습문제 19
 ￿테이블 구조 확인 
  Passenger(pid,  pname,  pgender, pcity)
  Agency(aid,  aname,  acity)
  Flight(fid,  fdate,  time,  src,  dest)
  Booking(pid,  aid,  fid,  fdate)
 Booking.pid  → Passenger.pid 참조
Booking.aid  → Agency.aid 참조
Booking.fid  → Flight.fid 참조

￿뷰 생성 질의어 15개

1. 전체 예약 통합 현황 뷰를 작성하시오
  (승객 + 여행사 + 항공편 정보를 한눈에 통합 조회 뷰)
 
 CREATE VIEW v_total_reservation AS
SELECT r.rnumber, p.pname, a.aname, f.fnumber, f.src, f.dest
FROM Reservation r
JOIN Passenger p ON r.pid = p.pid
JOIN Agency a ON r.aid = a.aid
JOIN Flight f ON r.fnumber = f.fnumber;
 
 2. 승객별 예약 내역 뷰를 작성하시오
   (각 승객이 예약한 항공편과 여행사 정보 조회 뷰)
 
CREATE VIEW v_passenger_res_details AS
SELECT p.pname, f.fnumber, f.src, f.dest, a.aname
FROM Passenger p
JOIN Reservation r ON p.pid = r.pid
JOIN Flight f ON r.fnumber = f.fnumber
JOIN Agency a ON r.aid = a.aid;

 3. 여행사별 예약 건수 및 실적 뷰를 작성하시오
   (각 여행사의 총 예약 건수와 취급 항공편 수 집계 뷰)
 
 CREATE VIEW v_agency_performance AS
SELECT a.aname, 
       COUNT(r.rnumber) AS "총 예약 건수",
       COUNT(DISTINCT r.fnumber) AS "취급 항공편 수"
FROM Agency a
LEFT JOIN Reservation r ON a.aid = r.aid
GROUP BY a.aname;

 4. 항공편별 예약 승객 수 뷰를 작성하시오
   (각 항공편의 예약된 승객 수와 출발·도착지 조회 뷰)
 
CREATE VIEW v_flight_passenger_count AS
SELECT f.fnumber, f.src, f.dest, COUNT(r.pid) AS "예약 승객 수"
FROM Flight f
LEFT JOIN Reservation r ON f.fnumber = r.fnumber
GROUP BY f.fnumber, f.src, f.dest;

 5. 출발지·도착지별 노선 통계 뷰를 작성하시오
  (노선(src → dest)별 운항 횟수와 총 예약 건수 집계 뷰)
 
CREATE VIEW v_route_stats AS
SELECT src, dest, 
       COUNT(DISTINCT fnumber) AS "운항 횟수", 
       COUNT(rnumber) AS "총 예약 건수"
FROM Flight f
LEFT JOIN Reservation r ON f.fnumber = r.fnumber
GROUP BY src, dest;

 6. 도시별 승객 예약 현황 뷰를 작성하시오
   (승객 거주 도시별 총 예약 건수 및 이용 현황 집계 뷰)
 
CREATE VIEW v_city_passenger_stats AS
SELECT p.pcity, COUNT(r.rnumber) AS "총 예약 건수"
FROM Passenger p
LEFT JOIN Reservation r ON p.pid = r.pid
GROUP BY p.pcity;

 7. 성별 이용 통계 뷰를 작성하시오
   (성별(pgender)에 따른 예약 건수와 이용 노선 수 비교 뷰)

CREATE VIEW v_gender_stats AS
SELECT p.pgender, 
       COUNT(r.rnumber) AS "예약 건수",
       COUNT(DISTINCT f.src || f.dest) AS "이용 노선 수"
FROM Passenger p
LEFT JOIN Reservation r ON p.pid = r.pid
LEFT JOIN Flight f ON r.fnumber = f.fnumber
GROUP BY p.pgender;

8. 예약 이력 없는 승객 뷰를 작성하시오
   (한 번도 예약하지 않은 승객 조회 (비활성 승객 관리) 뷰)
 
CREATE VIEW v_inactive_passengers AS
SELECT p.*
FROM Passenger p
LEFT JOIN Reservation r ON p.pid = r.pid
WHERE r.rnumber IS NULL;

 9. 예약 실적 없는 여행사 뷰를 작성하시오
   (한 건도 예약을 처리하지 않은 여행사 조회 뷰)
 
CREATE VIEW v_no_performance_agency AS
SELECT a.*
FROM Agency a
LEFT JOIN Reservation r ON a.aid = r.aid
WHERE r.rnumber IS NULL;

 10. 승객별 이용 여행사 목록 뷰를 작성하시오
   (각 승객이 이용한 여행사 목록 (중복 제거) 뷰)
 
CREATE VIEW v_passenger_agencies AS
SELECT DISTINCT p.pname, a.aname
FROM Passenger p
JOIN Reservation r ON p.pid = r.pid
JOIN Agency a ON r.aid = a.aid;

 11. 동일 출발·도착지 왕복 노선 뷰를 작성하시오
   (왕복 운항이 가능한 노선 쌍(A→B, B→A) 조회 뷰)
 
CREATE VIEW v_round_trip_routes AS
SELECT f1.src, f1.dest
FROM Flight f1
JOIN Flight f2 ON f1.src = f2.dest AND f1.dest = f2.src;

 12. 여행사별 담당 승객 상세 뷰를 작성하시오
   (여행사별로 담당한 승객 정보와 이용 항공편 상세 조회 뷰)
 
CREATE VIEW v_agency_customer_details AS
SELECT a.aname, p.pname, f.fnumber, f.fdate
FROM Agency a
JOIN Reservation r ON a.aid = r.aid
JOIN Passenger p ON r.pid = p.pid
JOIN Flight f ON r.fnumber = f.fnumber;

 13. 날짜별 예약 및 항공편 현황 뷰를 작성하시오
   (날짜별 총 예약 건수와 운항 항공편 수 집계 뷰)
 
CREATE VIEW v_daily_stats AS
SELECT f.fdate, 
       COUNT(r.rnumber) AS "총 예약 건수",
       COUNT(DISTINCT f.fnumber) AS "운항 항공편 수"
FROM Flight f
LEFT JOIN Reservation r ON f.fnumber = r.fnumber
GROUP BY f.fdate;

 14. 다중 항공편 이용 승객 뷰를 작성하시오
   (2개 이상의 항공편을 예약한 승객 조회 (자주 이용 고객) 뷰)
 
CREATE VIEW v_frequent_flyers AS
SELECT p.pname, COUNT(r.fnumber) AS "예약 횟수"
FROM Passenger p
JOIN Reservation r ON p.pid = r.pid
GROUP BY p.pid, p.pname
HAVING COUNT(r.fnumber) >= 2;

 15. 승객-여행사 동일 도시 예약 뷰를 작성하시오
   (승객의 거주 도시와 여행사 위치가 같은 예약 조회 뷰)

CREATE VIEW v_same_city_reservation AS
SELECT p.pname, a.aname, p.pcity AS "공통 도시"
FROM Reservation r
JOIN Passenger p ON r.pid = p.pid
JOIN Agency a ON r.aid = a.aid
WHERE p.pcity = a.acity;

 [기업프로젝트 데이터베이스] 128page 20번 문제
Employee(empno,  name,  phoneno,  address,  sex,  position,  deptno)
 Department(deptno, deptname, manager)
 Project(projno,proname,deptno)
 Works(empno, projno,  hours_worked)
 Employee.deptno  → Department.deptno 참조
Project.deptno   → Department.deptno 참조
Works.empno      → Employee.empno 참조
Works.projno     → Project.projno 참조
 
 [뷰 생성 질의어 ]
 
 1. 직원 전체 정보 통합 뷰를 작성하시오
  (직원 정보와 소속 부서명을 함께 조회하는 뷰)
 
CREATE VIEW v_emp_dept_total AS
SELECT e.*, d.dname
FROM Employee e
LEFT JOIN Department d ON e.dno = d.dno;

 2. 직원별 프로젝트 참여 현황 뷰를 작성하시오
  (직원이 참여 중인 프로젝트명과 투입 시간 조회하는 뷰)
 
CREATE VIEW v_emp_project_status AS
SELECT e.ename, p.pname, w.hours
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
JOIN Project p ON w.pno = p.pno;

 3. 부서별 직원 수 및 현황 뷰를 작성하시오
  (부서별 소속 직원 수와 관리자 정보 집계 뷰)
 
CREATE VIEW v_dept_summary AS
SELECT d.dname, COUNT(e.eid) AS "직원 수", m.ename AS "관리자명"
FROM Department d
LEFT JOIN Employee e ON d.dno = e.dno
LEFT JOIN Employee m ON d.mgreid = m.eid
GROUP BY d.dname, m.ename;

 4. 프로젝트별 참여 직원 및 총 투입 시간 뷰를 작성하시오
  (각 프로젝트에 참여한 직원 수와 총 근무 시간 집계 뷰)

CREATE VIEW v_project_work_stats AS
SELECT p.pname, COUNT(w.eid) AS "참여 직원 수", SUM(w.hours) AS "총 투입 시간"
FROM Project p
LEFT JOIN Works_On w ON p.pno = w.pno
GROUP BY p.pno, p.pname;

 5. 직원별 총 근무 시간 뷰를 작성하시오
   (직원이 전체 프로젝트에 투입한 총 시간 집계 뷰)
 
CREATE VIEW v_emp_total_hours AS
SELECT e.ename, SUM(w.hours) AS "전체 투입 시간"
FROM Employee e
LEFT JOIN Works_On w ON e.eid = w.eid
GROUP BY e.eid, e.ename;

 6. 부서별 프로젝트 현황 뷰를 작성하시오
   (각 부서가 담당하는 프로젝트 수와 총 투입 시간 집계 뷰)
 
CREATE VIEW v_dept_project_stats AS
SELECT d.dname, COUNT(DISTINCT p.pno) AS "프로젝트 수", SUM(w.hours) AS "총 투입 시간"
FROM Department d
LEFT JOIN Project p ON d.dno = p.dno
LEFT JOIN Works_On w ON p.pno = w.pno
GROUP BY d.dno, d.dname;

 7. 프로젝트에 참여하지 않는 직원 뷰를 작성하시오
  (어떤 프로젝트에도 투입되지 않은 직원 조회 뷰)
 
CREATE VIEW v_idle_employees AS
SELECT e.ename, e.position
FROM Employee e
LEFT JOIN Works_On w ON e.eid = w.eid
WHERE w.eid IS NULL;

 8. 성별 프로젝트 참여 통계 뷰를 작성하시오
   (성별(sex)에 따른 프로젝트 참여 수와 평균 근무 시간 비교 뷰)
 
CREATE VIEW v_gender_project_stats AS
SELECT e.sex, COUNT(w.pno) AS "참여 건수", AVG(w.hours) AS "평균 근무 시간"
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
GROUP BY e.sex;

 9. 관리자(Manager) 직원 상세 뷰를 작성하시오
   (부서 관리자로 지정된 직원의 상세 정보 조회 뷰)
 
CREATE VIEW v_manager_details AS
SELECT e.*, d.dname AS "관리부서"
FROM Employee e
JOIN Department d ON e.eid = d.mgreid;

 10. 직책별 프로젝트 참여 현황 뷰를 작성하시오
   (직책(position)별 총 프로젝트 참여 건수와 평균 투입 시간 뷰)
 
CREATE VIEW v_position_stats AS
SELECT e.position, COUNT(w.pno) AS "총 참여 건수", AVG(w.hours) AS "평균 투입 시간"
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
GROUP BY e.position;

 11. 다중 프로젝트 참여 직원 뷰를 작성하시오
   (2개 이상의 프로젝트에 참여 중인 직원 조회 뷰)

CREATE VIEW v_multi_project_emp AS
SELECT e.ename, COUNT(w.pno) AS "참여 프로젝트 수"
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
GROUP BY e.eid, e.ename
HAVING COUNT(w.pno) >= 2;       

12. 부서 내 프로젝트 참여 직원 상세 뷰를 작성하시오
(같은 부서 소속 직원이 해당 부서 프로젝트에 참여하는 현황 뷰)

-- 직원의 부서(e.dno)와 프로젝트의 담당 부서(p.dno)가 같은 경우
CREATE VIEW v_internal_project_emp AS
SELECT e.ename, d.dname, p.pname
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
JOIN Project p ON w.pno = p.pno
JOIN Department d ON e.dno = d.dno
WHERE e.dno = p.dno;

 13. 타 부서 프로젝트 참여 직원 뷰를 작성하시오
(자신의 소속 부서가 아닌 타 부서 프로젝트에 참여하는 직원 뷰)

-- 직원의 부서와 프로젝트의 담당 부서가 다른 경우
CREATE VIEW v_external_project_emp AS
SELECT e.ename, d.dname AS "소속부서", p.pname AS "타부서프로젝트"
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
JOIN Project p ON w.pno = p.pno
JOIN Department d ON e.dno = d.dno
WHERE e.dno != p.dno;

 14. 고투입 시간 직원 뷰 (평균 이상 근무)를 작성하시오
(프로젝트 평균 투입 시간보다 많이 근무한 직원 조회 뷰)

CREATE VIEW v_high_effort_employees AS
SELECT e.ename, w.hours
FROM Employee e
JOIN Works_On w ON e.eid = w.eid
WHERE w.hours > (SELECT AVG(hours) FROM Works_On);

 15. 프로젝트 미배정 부서 뷰를 작성하시오
(담당 프로젝트가 하나도 없는 부서 조회 뷰)

CREATE VIEW v_no_project_dept AS
SELECT d.dname
FROM Department d
LEFT JOIN Project p ON d.dno = p.dno
WHERE p.pno IS NULL;