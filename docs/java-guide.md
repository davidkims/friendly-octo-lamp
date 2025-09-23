# Java 완전 가이드

## 목차
1. [Java 소개](#java-소개)
2. [Java 설치 및 환경 설정](#java-설치-및-환경-설정)
3. [Java 기본 문법](#java-기본-문법)
4. [객체지향 프로그래밍](#객체지향-프로그래밍)
5. [Java 고급 기능](#java-고급-기능)
6. [Java 프레임워크](#java-프레임워크)
7. [개발 도구](#개발-도구)
8. [베스트 프랙티스](#베스트-프랙티스)

## Java 소개

### Java란?
Java는 Sun Microsystems(현재 Oracle)에서 개발한 객체지향 프로그래밍 언어입니다. 1995년에 처음 발표되었으며, "Write Once, Run Anywhere" (WORA) 철학을 바탕으로 설계되었습니다.

### Java의 특징
- **플랫폼 독립성**: JVM(Java Virtual Machine) 위에서 실행되어 운영체제에 관계없이 동작
- **객체지향**: 캡슐화, 상속, 다형성을 지원
- **강력한 메모리 관리**: 가비지 컬렉션을 통한 자동 메모리 관리
- **멀티스레딩**: 동시성 프로그래밍 지원
- **보안**: 강력한 보안 모델 제공
- **풍부한 라이브러리**: 방대한 표준 라이브러리와 생태계

### Java 버전 히스토리
- **Java 8 (LTS)**: Lambda 표현식, Stream API 도입
- **Java 11 (LTS)**: 모듈 시스템 안정화, HTTP 클라이언트 API
- **Java 17 (LTS)**: Record 클래스, Sealed 클래스
- **Java 21 (LTS)**: Virtual Threads, Pattern Matching

## Java 설치 및 환경 설정

### JDK 설치

#### Windows
1. Oracle JDK 또는 OpenJDK 다운로드
2. 설치 파일 실행
3. 환경 변수 설정:
   ```cmd
   JAVA_HOME=C:\Program Files\Java\jdk-17
   PATH=%PATH%;%JAVA_HOME%\bin
   ```

#### macOS
```bash
# Homebrew를 통한 설치
brew install openjdk@17

# 환경 변수 설정 (.zshrc 또는 .bash_profile)
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export PATH=$PATH:$JAVA_HOME/bin
```

#### Linux (Ubuntu/Debian)
```bash
# OpenJDK 설치
sudo apt update
sudo apt install openjdk-17-jdk

# 환경 변수 설정 (~/.bashrc)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
```

### 설치 확인
```bash
java -version
javac -version
```

## Java 기본 문법

### Hello World
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("안녕하세요, Java!");
    }
}
```

### 변수와 데이터 타입

#### 기본 데이터 타입
```java
// 정수형
byte byteVar = 127;
short shortVar = 32767;
int intVar = 2147483647;
long longVar = 9223372036854775807L;

// 실수형
float floatVar = 3.14f;
double doubleVar = 3.14159265359;

// 문자형
char charVar = 'A';

// 논리형
boolean boolVar = true;
```

#### 참조 타입
```java
String str = "Hello Java";
int[] array = {1, 2, 3, 4, 5};
List<String> list = new ArrayList<>();
```

### 제어문

#### 조건문
```java
// if-else
if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else {
    grade = "C";
}

// switch
switch (day) {
    case "월요일":
        System.out.println("주의 시작");
        break;
    case "금요일":
        System.out.println("주말이 다가옴");
        break;
    default:
        System.out.println("평범한 날");
}
```

#### 반복문
```java
// for 루프
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

// 향상된 for 루프
for (String item : list) {
    System.out.println(item);
}

// while 루프
int i = 0;
while (i < 10) {
    System.out.println(i);
    i++;
}
```

## 객체지향 프로그래밍

### 클래스와 객체
```java
public class Person {
    // 필드 (인스턴스 변수)
    private String name;
    private int age;
    
    // 생성자
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // 메서드
    public void introduce() {
        System.out.println("안녕하세요, 저는 " + name + "이고 " + age + "살입니다.");
    }
    
    // Getter와 Setter
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
}

// 객체 생성과 사용
Person person = new Person("김자바", 25);
person.introduce();
```

### 상속
```java
public class Student extends Person {
    private String studentId;
    
    public Student(String name, int age, String studentId) {
        super(name, age);  // 부모 생성자 호출
        this.studentId = studentId;
    }
    
    @Override
    public void introduce() {
        super.introduce();
        System.out.println("학번은 " + studentId + "입니다.");
    }
}
```

### 인터페이스
```java
public interface Drawable {
    void draw();
    
    // Java 8부터 default 메서드 지원
    default void print() {
        System.out.println("그리기 완료");
    }
}

public class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("원을 그립니다.");
    }
}
```

### 추상 클래스
```java
public abstract class Shape {
    protected String color;
    
    public abstract double calculateArea();
    
    public void setColor(String color) {
        this.color = color;
    }
}

public class Rectangle extends Shape {
    private double width;
    private double height;
    
    @Override
    public double calculateArea() {
        return width * height;
    }
}
```

## Java 고급 기능

### 제네릭스
```java
// 제네릭 클래스
public class Box<T> {
    private T content;
    
    public void set(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

// 사용
Box<String> stringBox = new Box<>();
stringBox.set("Hello");
String value = stringBox.get();

// 제네릭 메서드
public static <T> void swap(T[] array, int i, int j) {
    T temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}
```

### 람다 표현식 (Java 8+)
```java
// 기존 방식
List<String> names = Arrays.asList("김철수", "이영희", "박민수");
names.sort(new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return a.compareTo(b);
    }
});

// 람다 표현식
names.sort((a, b) -> a.compareTo(b));
// 또는 메서드 참조
names.sort(String::compareTo);
```

### Stream API
```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// 짝수만 필터링하고 제곱하여 리스트로 수집
List<Integer> evenSquares = numbers.stream()
    .filter(n -> n % 2 == 0)
    .map(n -> n * n)
    .collect(Collectors.toList());

// 합계 계산
int sum = numbers.stream()
    .mapToInt(Integer::intValue)
    .sum();
```

### 예외 처리
```java
try {
    // 예외가 발생할 수 있는 코드
    FileReader file = new FileReader("file.txt");
} catch (FileNotFoundException e) {
    System.out.println("파일을 찾을 수 없습니다: " + e.getMessage());
} catch (IOException e) {
    System.out.println("IO 오류: " + e.getMessage());
} finally {
    // 항상 실행되는 코드
    System.out.println("정리 작업 수행");
}

// try-with-resources (Java 7+)
try (FileReader file = new FileReader("file.txt");
     BufferedReader reader = new BufferedReader(file)) {
    String line = reader.readLine();
} catch (IOException e) {
    e.printStackTrace();
}
```

### 멀티스레딩
```java
// Thread 클래스 상속
class MyThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println("Thread: " + i);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

// Runnable 인터페이스 구현
class MyRunnable implements Runnable {
    @Override
    public void run() {
        // 스레드가 실행할 코드
    }
}

// 사용
MyThread thread1 = new MyThread();
Thread thread2 = new Thread(new MyRunnable());

thread1.start();
thread2.start();

// 람다와 함께 사용
Thread thread3 = new Thread(() -> {
    System.out.println("람다로 생성된 스레드");
});
thread3.start();
```

## Java 프레임워크

### Spring Framework
```java
// Spring Boot 애플리케이션
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

// REST Controller
@RestController
@RequestMapping("/api")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/users")
    public List<User> getUsers() {
        return userService.findAll();
    }
    
    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return userService.save(user);
    }
}

// Service 클래스
@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public List<User> findAll() {
        return userRepository.findAll();
    }
    
    public User save(User user) {
        return userRepository.save(user);
    }
}
```

### JPA/Hibernate
```java
// Entity 클래스
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(unique = true)
    private String email;
    
    // 생성자, getter, setter
}

// Repository 인터페이스
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByName(String name);
    Optional<User> findByEmail(String email);
}
```

## 개발 도구

### IDE
- **IntelliJ IDEA**: 강력한 상용 IDE
- **Eclipse**: 오픈소스 IDE
- **Visual Studio Code**: 경량 에디터 (Java Extension Pack)

### 빌드 도구

#### Maven
```xml
<!-- pom.xml -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.1.0</version>
        </dependency>
    </dependencies>
</project>
```

#### Gradle
```gradle
// build.gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.1.0'
}

group = 'com.example'
version = '1.0-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

### 테스팅

#### JUnit 5
```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {
    
    private Calculator calculator;
    
    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }
    
    @Test
    void testAddition() {
        assertEquals(5, calculator.add(2, 3));
    }
    
    @Test
    void testDivisionByZero() {
        assertThrows(ArithmeticException.class, () -> {
            calculator.divide(10, 0);
        });
    }
}
```

## 베스트 프랙티스

### 코딩 스타일
```java
// 좋은 예
public class UserService {
    private static final int MAX_RETRY_COUNT = 3;
    private final UserRepository userRepository;
    
    public UserService(UserRepository userRepository) {
        this.userRepository = Objects.requireNonNull(userRepository);
    }
    
    public Optional<User> findUserById(Long id) {
        if (id == null || id <= 0) {
            return Optional.empty();
        }
        return userRepository.findById(id);
    }
}
```

### 성능 최적화
1. **StringBuilder 사용**: 문자열 연결 시
```java
// 나쁜 예
String result = "";
for (int i = 0; i < 1000; i++) {
    result += "a";
}

// 좋은 예
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 1000; i++) {
    sb.append("a");
}
String result = sb.toString();
```

2. **컬렉션 초기 용량 설정**
```java
// 예상 크기를 아는 경우
List<String> list = new ArrayList<>(100);
Map<String, String> map = new HashMap<>(16);
```

3. **스트림 API 적절한 사용**
```java
// 간단한 경우는 전통적인 반복문이 더 빠를 수 있음
List<String> result = new ArrayList<>();
for (String item : list) {
    if (item.length() > 5) {
        result.add(item.toUpperCase());
    }
}
```

### 메모리 관리
1. **리소스 해제**: try-with-resources 사용
2. **대용량 데이터 처리**: 스트림 처리 고려
3. **메모리 누수 방지**: 리스너, 콜백 해제

### 보안
```java
// 입력 검증
public void processUserInput(String input) {
    if (input == null || input.trim().isEmpty()) {
        throw new IllegalArgumentException("입력값이 비어있습니다");
    }
    
    // SQL 인젝션 방지 - PreparedStatement 사용
    String sql = "SELECT * FROM users WHERE name = ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, input);
        // 실행...
    }
}

// 민감한 정보 처리
public class SecureConfig {
    private static final String PASSWORD = System.getenv("DB_PASSWORD");
    
    // 비밀번호는 char[]로 처리하고 사용 후 지움
    public void authenticate(char[] password) {
        try {
            // 인증 로직
        } finally {
            Arrays.fill(password, ' '); // 메모리에서 지움
        }
    }
}
```

이 가이드는 Java 개발의 핵심 개념과 실무에서 필요한 지식을 포괄적으로 다룹니다. 지속적인 학습과 실습을 통해 Java 전문성을 향상시킬 수 있습니다.