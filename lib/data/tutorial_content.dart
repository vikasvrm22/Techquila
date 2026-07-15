import '../models/tutorial.dart';

final List<Tutorial> tutorials = [
  Tutorial(
    id: 'playwright',
    name: 'Playwright',
    subtitle: 'Browser automation aur end-to-end testing',
    chapters: [
      Chapter(
        id: 'pw_1',
        title: 'Introduction aur Setup',
        diagram: 'pw_flow',
        content: '''Playwright Microsoft ka banaya hua ek open-source automation library hai jo Chromium, Firefox aur WebKit teeno browsers ko control kar sakti hai — ek hi API se.

Setup karne ke liye:
```
npm init playwright@latest
```

Yeh command project setup kar deti hai — config file, example tests, aur browsers download ho jaate hain.

Playwright ka sabse bada fayda hai "auto-waiting" — matlab yeh khud element ke ready hone ka wait karta hai, aapko manually sleep() lagane ki zaroorat nahi.''',
      ),
      Chapter(
        id: 'pw_2',
        title: 'Pehla Test Likhna',
        content: '''Har Playwright test ek async function hoti hai jo "page" object leti hai:

```
import { test, expect } from '@playwright/test';

test('homepage has title', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveTitle(/Example/);
});
```

"page" object browser tab ko represent karta hai. Har test apna fresh browser context leta hai — isliye tests ek dusre se isolated rehte hain.

Test chalane ke liye:
```
npx playwright test
```''',
      ),
      Chapter(
        id: 'pw_3',
        title: 'Locators — Basics',
        content: '''Locators Playwright ka core concept hain — yeh element ko "kaise dhoondhna hai" define karte hain, lekin lazy hote hain (jab tak action na ho, search nahi hoti).

Recommended locators:
```
page.getByRole('button', { name: 'Submit' })
page.getByLabel('Username')
page.getByText('Welcome')
page.getByPlaceholder('Enter email')
page.getByTestId('submit-btn')
```

CSS selectors bhi chal jaate hain (page.locator('.class')) lekin role-based locators zyada stable hote hain kyunki yeh accessibility tree pe based hain, DOM structure pe nahi.''',
      ),
      Chapter(
        id: 'pw_4',
        title: 'Locators — Chaining aur Filtering',
        content: '''Locators ko chain aur filter kiya ja sakta hai taaki specific element mile:

```
// Ek list mein se text ke basis pe filter
page.getByRole('listitem').filter({ hasText: 'Product 2' });

// Nested locator — parent ke andar child dhoondhna
page.locator('.card').getByRole('button', { name: 'Buy' });

// nth element
page.getByRole('listitem').nth(2);

// first / last
page.getByRole('row').first();
page.getByRole('row').last();
```

Filtering se aap complex UI (jaise list ya table) mein exact element target kar sakte ho bina fragile CSS selectors likhe.''',
      ),
      Chapter(
        id: 'pw_5',
        title: 'Actions',
        content: '''Common user actions jo Playwright simulate kar sakta hai:

```
await page.getByRole('textbox').fill('hello');
await page.getByRole('button').click();
await page.getByRole('checkbox').check();
await page.getByLabel('Country').selectOption('India');
await page.getByRole('textbox').press('Enter');
await page.locator('input[type=file]').setInputFiles('photo.png');
await page.mouse.hover({ x: 100, y: 200 });
```

Har action se pehle Playwright automatically check karta hai ki element visible, enabled aur stable hai — isse "actionability checks" kehte hain.''',
      ),
      Chapter(
        id: 'pw_6',
        title: 'Assertions',
        content: '''Playwright ke assertions "expect" se aate hain aur automatically retry karte hain jab tak condition sahi na ho ya timeout na ho jaaye:

```
await expect(page.getByText('Success')).toBeVisible();
await expect(page.locator('.count')).toHaveText('5');
await expect(page).toHaveURL(/dashboard/);
await expect(page.getByRole('checkbox')).toBeChecked();
await expect(page.locator('button')).toBeDisabled();
```

Yeh "web-first assertions" hain — inhe manually wait karne ki zaroorat nahi, yeh khud smart retry karte hain (default timeout 5 seconds).''',
      ),
      Chapter(
        id: 'pw_7',
        title: 'Hooks — beforeEach aur afterEach',
        content: '''Hooks se repeated setup/cleanup code alag likha ja sakta hai:

```
import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('https://example.com/login');
  await page.getByLabel('Username').fill('admin');
  await page.getByRole('button', { name: 'Login' }).click();
});

test.afterEach(async ({ page }, testInfo) => {
  console.log(`Finished: \${testInfo.title} — \${testInfo.status}`);
});

test('dashboard shows welcome message', async ({ page }) => {
  await expect(page.getByText('Welcome')).toBeVisible();
});
```

`beforeEach` har test se pehle chalta hai — login jaisa common setup ek jagah likhne ke liye ideal.''',
      ),
      Chapter(
        id: 'pw_8',
        title: 'Page Object Model',
        content: '''Page Object Model (POM) ek design pattern hai jisme har page ke locators/actions ek class mein encapsulate hote hain — tests clean aur maintainable rehte hain.

```
// loginPage.ts
export class LoginPage {
  constructor(private page) {}
  async login(username: string, password: string) {
    await this.page.getByLabel('Username').fill(username);
    await this.page.getByLabel('Password').fill(password);
    await this.page.getByRole('button', { name: 'Login' }).click();
  }
}

// test file
test('login works', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await page.goto('/login');
  await loginPage.login('admin', 'secret');
});
```

Fayda: UI change hone pe sirf Page Object update karna padta hai, saare tests nahi.''',
      ),
      Chapter(
        id: 'pw_9',
        title: 'Fixtures',
        content: '''Fixtures Playwright ka mechanism hai jisse tests ko reusable "setup objects" milte hain — jaise page, context, browser, aur custom fixtures bhi.

```
import { test as base } from '@playwright/test';
import { LoginPage } from './loginPage';

export const test = base.extend({
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await page.goto('/login');
    await use(loginPage);
  },
});

test('dashboard visible after login', async ({ loginPage, page }) => {
  await loginPage.login('admin', 'secret');
  await expect(page.getByText('Dashboard')).toBeVisible();
});
```

Custom fixtures se boilerplate kam hota hai aur tests declarative ban jaate hain.''',
      ),
      Chapter(
        id: 'pw_10',
        title: 'Playwright Config',
        content: '''`playwright.config.ts` project-wide settings define karta hai:

```
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  retries: 2,
  use: {
    baseURL: 'https://example.com',
    headless: true,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
    { name: 'firefox', use: { browserName: 'firefox' } },
  ],
});
```

`baseURL` set karne ke baad tests mein pura URL likhne ki zaroorat nahi — sirf `page.goto('/login')` kaafi hai.''',
      ),
      Chapter(
        id: 'pw_11',
        title: 'Parallelization',
        content: '''Playwright by default tests **parallel** mein chalata hai — alag-alag worker processes mein, jisse suite fast chalti hai.

```
// playwright.config.ts
export default defineConfig({
  workers: 4,
  fullyParallel: true,
});
```

Ek hi file ke tests ko sequential rakhna ho toh:
```
test.describe.serial('checkout flow', () => {
  test('add to cart', async ({ page }) => { /* ... */ });
  test('checkout', async ({ page }) => { /* ... */ });
});
```

CI mein workers ki sankhya kam rakhna better hota hai (resources limited hote hain), local mein zyada.''',
      ),
      Chapter(
        id: 'pw_12',
        title: 'API Testing',
        content: '''Playwright sirf UI nahi, direct API calls bhi test kar sakta hai — `request` fixture se:

```
test('API returns user', async ({ request }) => {
  const response = await request.get('/api/users/1');
  expect(response.status()).toBe(200);
  const body = await response.json();
  expect(body.name).toBe('Rahul');
});

test('create user via API', async ({ request }) => {
  const response = await request.post('/api/users', {
    data: { name: 'New User', email: 'a@b.com' },
  });
  expect(response.ok()).toBeTruthy();
});
```

UI tests se pehle API se test data seed karna ek common pattern hai — isse UI tests fast aur reliable ban jaate hain.''',
      ),
      Chapter(
        id: 'pw_13',
        title: 'Network Interception aur Mocking',
        content: '''Playwright network requests ko intercept, modify, ya mock kar sakta hai:

```
await page.route('**/api/products', async (route) => {
  await route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify([{ id: 1, name: 'Mock Product' }]),
  });
});

await page.route('**/analytics/**', (route) => route.abort());

await page.goto('/products');
```

Isse aap backend down hone par bhi, ya edge cases (empty list, error response) test kar sakte ho bina real API pe depend kiye.''',
      ),
      Chapter(
        id: 'pw_14',
        title: 'Authentication — Storage State',
        content: '''Har test mein login repeat karna slow hota hai. Playwright ek baar login karke session save kar sakta hai:

```
// auth.setup.ts
import { test as setup } from '@playwright/test';

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Username').fill('admin');
  await page.getByLabel('Password').fill('secret');
  await page.getByRole('button', { name: 'Login' }).click();
  await page.context().storageState({ path: 'auth.json' });
});
```

```
use: { storageState: 'auth.json' }
```

Isse cookies/localStorage save ho jaate hain aur agli baar login skip ho jaata hai — suite bahut fast chalti hai.''',
      ),
      Chapter(
        id: 'pw_15',
        title: 'Visual aur Screenshot Testing',
        content: '''Playwright screenshots le sakta hai aur pixel-level comparison bhi kar sakta hai:

```
await page.screenshot({ path: 'homepage.png', fullPage: true });

await expect(page).toHaveScreenshot('homepage.png');

await expect(page.locator('.card')).toHaveScreenshot();
```

Pehli baar chalane pe baseline image save hoti hai; agli baar current UI usse compare hoti hai. Difference hone par test fail hota hai aur diff image generate hoti hai.''',
      ),
      Chapter(
        id: 'pw_16',
        title: 'Mobile Emulation',
        content: '''Playwright real devices emulate kar sakta hai — viewport, user agent, touch support sab included:

```
import { devices } from '@playwright/test';

export default defineConfig({
  projects: [
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 13'] } },
  ],
});
```

Manually bhi viewport set ho sakta hai:
```
const context = await browser.newContext({
  viewport: { width: 375, height: 667 },
  isMobile: true,
  hasTouch: true,
});
```

Isse responsive design ke bugs CI mein hi pakde jaate hain, real devices ki zaroorat nahi.''',
      ),
      Chapter(
        id: 'pw_17',
        title: 'Debugging aur Trace Viewer',
        diagram: 'pw_trace',
        content: '''Debugging ke liye:
```
npx playwright test --debug
```

Yeh Playwright Inspector kholta hai jisse aap step-by-step test dekh sakte ho.

Trace Viewer bhi bahut useful hai — failed tests ka poora recording (screenshots, network, console) dikhata hai:
```
npx playwright show-trace trace.zip
```

Config mein trace on karna:
```
use: { trace: 'on-first-retry' }
```

Test report dekhne ke liye:
```
npx playwright show-report
```''',
      ),
      Chapter(
        id: 'pw_18',
        title: 'CI Integration',
        content: '''Playwright ko GitHub Actions ya Jenkins jaise CI systems mein chalana straightforward hai:

```
name: Playwright Tests
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
```

`--with-deps` browsers ke saath system dependencies bhi install kar deta hai — CI mein zaroori hota hai kyunki fresh machine hoti hai.''',
      ),
    ],
  ),
  Tutorial(
    id: 'typescript',
    name: 'TypeScript',
    subtitle: 'JavaScript ke upar type safety',
    chapters: [
      Chapter(
        id: 'ts_1',
        title: 'TypeScript Kya Hai',
        content: '''TypeScript JavaScript ka superset hai jo static typing add karta hai. Matlab aap variables, functions, objects ke types define kar sakte ho, aur compiler galtiyan pakad leta hai code chalane se pehle.

let age: number = 25;
let name: string = "Rahul";
let isActive: boolean = true;

TypeScript code ".ts" file mein likha jaata hai, aur "tsc" compiler use karke plain JavaScript mein convert hota hai jo browser/Node chala sakta hai.''',
      ),
      Chapter(
        id: 'ts_2',
        title: 'Interfaces aur Types',
        content: '''Interface ek "shape" define karta hai ki object kaisa dikhna chahiye:

interface User {
  name: string;
  age: number;
  email?: string;  // optional property
}

function greet(user: User) {
  console.log(`Hello, \${user.name}`);
}

"type" keyword se bhi similar cheez ban sakti hai:
type User = { name: string; age: number };

Farak: interface extend ho sakta hai (aur merge bhi), type mein union/intersection types easily ban sakte hain. Simple object shapes ke liye dono chalte hain.''',
      ),
      Chapter(
        id: 'ts_3',
        title: 'Generics',
        content: '''Generics aapko reusable, type-safe code likhne dete hain jo multiple types ke saath kaam kare:

function identity<T>(value: T): T {
  return value;
}

identity<string>("hello");
identity<number>(42);

Generics ka use collections, API responses, aur utility functions mein bahut hota hai — jaise Array<T>, Promise<T>.''',
      ),
      Chapter(
        id: 'ts_4',
        title: 'Union Types aur Narrowing',
        content: '''Union type ek variable ko multiple possible types dene ka tarika hai:

function printId(id: number | string) {
  if (typeof id === 'string') {
    console.log(id.toUpperCase());
  } else {
    console.log(id.toFixed(2));
  }
}

Is process ko "narrowing" kehte hain — typeof check karke TypeScript automatically samajh jaata hai ki us block ke andar variable ka exact type kya hai.''',
      ),
      Chapter(
        id: 'ts_5',
        title: 'Configuration (tsconfig.json)',
        content: '''tsconfig.json project ke compilation rules define karta hai:

{
  "compilerOptions": {
    "target": "ES2020",
    "strict": true,
    "outDir": "./dist",
    "module": "commonjs"
  }
}

"strict": true sabse important setting hai — yeh sabhi strict type-checking options ko enable kar deta hai, jisse bugs jaldi pakde jaate hain.''',
      ),
    ],
  ),
  Tutorial(
    id: 'git',
    name: 'Git',
    subtitle: 'Version control system',
    chapters: [
      Chapter(
        id: 'git_1',
        title: 'Basics — Init, Add, Commit',
        content: '''Git ek distributed version control system hai jo code ki har change ka history rakhta hai.

git init                 // naya repo banao
git add file.txt         // file ko staging area mein daalo
git add .                // saari changed files add karo
git commit -m "message"  // changes ko permanently save karo

Staging area (index) ek "draft" jagah hai — aap decide kar sakte ho ki commit mein kya jaayega, kya nahi.''',
      ),
      Chapter(
        id: 'git_2',
        title: 'Branches',
        content: '''Branch ek independent line of development hai:

git branch feature-x        // nayi branch banao
git checkout feature-x      // branch pe switch karo
git checkout -b feature-x   // dono ek saath (banao + switch)
git branch                  // saari branches list karo

Branches se aap main code ko touch kiye bina naye features try kar sakte ho, aur baad mein merge kar sakte ho.''',
      ),
      Chapter(
        id: 'git_3',
        title: 'Merge vs Rebase',
        content: '''Merge: dono branches ke history ko jodta hai, ek naya "merge commit" banata hai. History mein dono paths dikhte hain.

git checkout main
git merge feature-x

Rebase: feature branch ke commits ko main ke latest point ke upar "replay" karta hai — history linear (seedhi) ban jaati hai.

git checkout feature-x
git rebase main

Rule of thumb: shared/public branches pe rebase mat karo (history rewrite hoti hai), apni local branch pe rebase safe hai.''',
      ),
      Chapter(
        id: 'git_4',
        title: 'Remote Repositories',
        content: '''Remote ek server pe hosted repo hai (jaise GitHub):

git remote add origin <url>
git push origin main       // apne commits remote pe bhejo
git pull origin main       // remote se naye commits lao
git fetch origin           // sirf data lao, merge mat karo

"pull" asal mein "fetch + merge" hai. Agar aap pehle dekhna chahte ho ki kya naya aaya hai, "fetch" use karo.''',
      ),
      Chapter(
        id: 'git_5',
        title: 'Undo Karna',
        content: '''Galti sudharne ke liye common commands:

git checkout -- file.txt      // uncommitted changes discard karo
git reset HEAD~1               // last commit undo karo, changes rakho
git reset --hard HEAD~1        // last commit + changes dono discard karo
git revert <commit>            // ek naya commit banao jo purane ko undo kare (safe, shared branches ke liye)

"revert" safe hai kyunki yeh history delete nahi karta, naya commit add karta hai. "reset --hard" khatarnak hai — data permanently delete ho sakta hai.''',
      ),
    ],
  ),
  Tutorial(
    id: 'jenkins',
    name: 'Jenkins',
    subtitle: 'CI/CD automation server',
    chapters: [
      Chapter(
        id: 'jk_1',
        title: 'Jenkins Kya Hai',
        content: '''Jenkins ek open-source automation server hai jo CI/CD (Continuous Integration/Continuous Deployment) pipelines chalata hai. Yeh code commit hone pe automatically build, test, aur deploy kar sakta hai.

Jenkins "jobs" ya "pipelines" ke through kaam karta hai — har job ek set of steps hota hai jo trigger hone pe chalte hain (jaise naya commit push hona).''',
      ),
      Chapter(
        id: 'jk_2',
        title: 'Freestyle Job vs Pipeline',
        content: '''Freestyle Job: UI se click-click karke configure karte ho — simple projects ke liye theek hai.

Pipeline: code ke through define hota hai (Jenkinsfile) — version control mein rakha ja sakta hai, complex workflows ke liye better.

pipeline {
    agent any
    stages {
        stage('Build') {
            steps { echo 'Building...' }
        }
        stage('Test') {
            steps { echo 'Testing...' }
        }
    }
}

Pipeline as Code ka fayda: history track hoti hai, review ho sakta hai, aur reusable hai.''',
      ),
      Chapter(
        id: 'jk_3',
        title: 'Jenkinsfile Basics',
        content: '''Jenkinsfile do syntax mein likha ja sakta hai: Declarative (structured, easier) aur Scripted (Groovy-based, zyada flexible).

Declarative example:

pipeline {
    agent any
    environment {
        NODE_ENV = 'production'
    }
    stages {
        stage('Checkout') {
            steps { git 'https://github.com/user/repo.git' }
        }
        stage('Install') {
            steps { sh 'npm install' }
        }
        stage('Test') {
            steps { sh 'npm test' }
        }
    }
    post {
        always { echo 'Pipeline finished' }
    }
}

"post" block har stage ke baad chalta hai — success, failure, ya hamesha (always).''',
      ),
      Chapter(
        id: 'jk_4',
        title: 'Plugins aur Integrations',
        content: '''Jenkins ki taaqat uske **plugins ecosystem** mein hai — 1800+ plugins available hain:

- Git plugin — source code checkout
- Docker plugin — containers build/run
- Slack plugin — notifications
- Credentials plugin — secrets safely store karna

Plugins Manage Jenkins → Plugins se install hote hain. Har plugin naye steps ya integrations add karta hai pipeline mein.''',
      ),
      Chapter(
        id: 'jk_5',
        title: 'Triggers',
        content: '''Pipeline kab chale, yeh triggers decide karte hain:

- **Poll SCM**: har X minute mein check karo naya commit aaya ya nahi
- **Webhook**: GitHub/GitLab khud Jenkins ko batata hai jab code push ho (instant, better approach)
- **Scheduled (Cron)**: fixed time pe chalao, jaise raat 2 baje daily build

triggers {
    cron('H 2 * * *')
}

Webhooks poll karne se better hain kyunki instant hote hain aur server pe unnecessary load nahi daalte.''',
      ),
    ],
  ),
  Tutorial(
    id: 'java',
    name: 'Java',
    subtitle: 'Interview programs aur core concepts',
    chapters: [
      Chapter(
        id: 'jv_1',
        title: 'OOP Concepts',
        content: '''Java ke 4 pillars:

**Encapsulation**: data ko private rakhna, getter/setter se access dena.
**Inheritance**: ek class doosri class ke properties/methods extend kare (extends keyword).
**Polymorphism**: same method naam, different behavior — overloading (same class, different parameters) aur overriding (child class parent ka method redefine kare).
**Abstraction**: implementation details chhupana, sirf zaroori cheez dikhana (abstract class, interface).

class Animal {
    void sound() { System.out.println("Some sound"); }
}
class Dog extends Animal {
    @Override
    void sound() { System.out.println("Bark"); }
}''',
      ),
      Chapter(
        id: 'jv_2',
        title: 'String Programs',
        content: '''Common interview question — String palindrome check:

public boolean isPalindrome(String s) {
    int left = 0, right = s.length() - 1;
    while (left < right) {
        if (s.charAt(left) != s.charAt(right)) return false;
        left++;
        right--;
    }
    return true;
}

String reverse karna:

public String reverse(String s) {
    return new StringBuilder(s).reverse().toString();
}

Note: String immutable hoti hai Java mein — har modification naya object banata hai. Bahut zyada concatenation ke liye StringBuilder use karo (better performance).''',
      ),
      Chapter(
        id: 'jv_3',
        title: 'Array aur Collection Programs',
        content: '''Array mein duplicate dhoondhna:

public void findDuplicates(int[] arr) {
    Set<Integer> seen = new HashSet<>();
    for (int num : arr) {
        if (!seen.add(num)) {
            System.out.println("Duplicate: " + num);
        }
    }
}

ArrayList vs LinkedList: ArrayList random access mein fast hai (index se O(1)), LinkedList insert/delete mein fast hai beech mein (kyunki sirf pointers change hote hain, poora array shift nahi karna padta).

HashMap vs TreeMap: HashMap fast hai (O(1) average) lekin order guarantee nahi karta. TreeMap sorted order mein rakhta hai (O(log n)).''',
      ),
      Chapter(
        id: 'jv_4',
        title: 'Exception Handling',
        content: '''try-catch-finally se errors handle hote hain:

try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Error: " + e.getMessage());
} finally {
    System.out.println("Always runs");
}

Checked exceptions (jaise IOException) compile time pe handle karni padti hain. Unchecked exceptions (jaise NullPointerException) runtime pe aati hain, compiler force nahi karta handle karne ke liye.

Custom exception banana:
class InvalidAgeException extends Exception {
    InvalidAgeException(String message) { super(message); }
}''',
      ),
      Chapter(
        id: 'jv_5',
        title: 'Multithreading Basics',
        content: '''Thread banane ke 2 tarike:

// Tarika 1: Thread class extend karo
class MyThread extends Thread {
    public void run() { System.out.println("Running"); }
}

// Tarika 2: Runnable implement karo (zyada flexible, preferred)
class MyTask implements Runnable {
    public void run() { System.out.println("Running"); }
}
new Thread(new MyTask()).start();

"synchronized" keyword use hota hai jab multiple threads ek shared resource access karein — race conditions rokne ke liye:

public synchronized void increment() {
    count++;
}''',
      ),
    ],
  ),
];
