import { render, fireEvent, screen, waitForElementToBeRemoved } from '@testing-library/react';
import {getSlug, backendUrl} from "./api";
import {rest} from 'msw'
import {setupServer} from 'msw/node'
import App from './App';


const fakeUserResponse = {token: 'fake_user_token'}
const server = setupServer(
  rest.put(backendUrl, (req, res, ctx) => {
    return res(ctx.set('Content-Location', 'localhost:4567/abc'))
  }),
)

beforeAll(() => server.listen())
// This should probably be "beforeEach",
// but that's not what the docs use
afterEach(() => {
    server.resetHandlers()
    window.localStorage.removeItem('token')
})

afterAll(() => server.close())

test('renders instructions', () => {
  render(<App />);
  const instructionsElement = screen.getByText(/Please Enter/)
  expect(instructionsElement).toBeInTheDocument();
});

test('it gets a url from the backend and shows it to the user', async () => {
  render(<App />);
  const input = screen.getByLabelText("Where do you want to go?")
  const submitButton = screen.getByRole('button')
  fireEvent.change(input, {
    target: {value: 'happypath.com'},
  })
  fireEvent.click(submitButton)
  const displayedResult = await screen.findByTestId('short_url')
  expect(displayedResult).toHaveAttribute('href', 'localhost:4567/abc')
});

test('it displays the server error message to the user', async () => {
	const errorMessage = 'Ya Messed Up'
  server.use(
    rest.put(backendUrl, (req, res, ctx) => {
      return res(ctx.status(403), ctx.body(errorMessage))
    }),
  )
  render(<App />);
  const input = screen.getByLabelText("Where do you want to go?")
  const submitButton = screen.getByRole('button')
  fireEvent.change(input, {
    target: {value: 'makecrash.com'},
  })
  fireEvent.click(submitButton)
  const errorDisplay = await screen.findByTestId('error_message')
  expect(errorDisplay).toHaveTextContent(errorMessage)
});

test('it clears the server error message on a successful request', async () => {
	const errorMessage = 'Ya Messed Up'
  server.use(
    rest.put(backendUrl, (req, res, ctx) => {
		const destination = JSON.parse(req.body).destination
		if (destination == 'makecrash.com') {
      return res(ctx.status(403), ctx.body(errorMessage))
		} else {
      return res(ctx.set('Content-Location', 'localhost:4567/abc'))
    }

    }),
  )
  render(<App />);


  fireEvent.change(screen.getByLabelText("Where do you want to go?"), {
    target: {value: 'makecrash.com'},
  })
  fireEvent.click(screen.getByRole('button'))
  await screen.findByTestId('error_message')
  fireEvent.change(screen.getByLabelText("Where do you want to go?"), {
    target: {value: 'happypath.com'},
  })
  fireEvent.click(screen.getByRole('button'))
  await waitForElementToBeRemoved(() => screen.queryByTestId('error_message'))
});


test('it clears the displayed URL on a bad request', async () => {
	const errorMessage = 'Ya Messed Up'
  server.use(
    rest.put(backendUrl, (req, res, ctx) => {
		const destination = JSON.parse(req.body).destination
		if (destination == 'makecrash.com') {
      return res(ctx.status(403), ctx.body(errorMessage))
		} else {
      return res(ctx.set('Content-Location', 'localhost:4567/abc'))
    }

    }),
  )
  render(<App />);
  fireEvent.change(screen.getByLabelText("Where do you want to go?"), {
    target: {value: 'happypath.com'},
  })
  fireEvent.click(screen.getByRole('button'))
  await screen.findByTestId('short_url')
  fireEvent.change(screen.getByLabelText("Where do you want to go?"), {
    target: {value: 'makecrash.com'},
  })
  fireEvent.click(screen.getByRole('button'))
  await waitForElementToBeRemoved(() => screen.queryByTestId('short_url'))
})
